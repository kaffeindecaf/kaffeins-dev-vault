--!nocheck
-- Tested: Studio mock fault harness, 34 checks, 2026-11-02; no DataStore/purchase/HTTP calls.
-- Copy this and the backend modules into one Folder. Require this ModuleScript, then call (folder).
return function(folder)
    local Accounts = require(folder["backend-account-store"])
    local Ledger = require(folder["cross-server-gift-ledger"])
    local Retention = require(folder["retention-engine"])
    local Quests = require(folder["quest-blueprint-factory"])
    local Center = require(folder["purchase-fulfillment-center"])
    local Guard = require(folder["data-vault-guard"])
    local checks = 0
    local function check(value, message)
        assert(value, message); checks += 1
    end
    local fake = {values = {}, failBefore = nil, failAfter = nil, replayTransform = true}
    function fake:UpdateAsync(key, transform)
        if self.failBefore == key then self.failBefore = nil; error("injected_before_write") end
        local old = Accounts.Copy(self.values[key])
        if self.replayTransform then transform(Accounts.Copy(old), nil) end
        local value = transform(Accounts.Copy(old), nil)
        self.values[key] = Accounts.Copy(value)
        if self.failAfter == key then self.failAfter = nil; error("injected_lost_response") end
        return Accounts.Copy(value)
    end
    local accounts = Accounts.new(fake)
    local function coins(userId)
        local ok, _, data = accounts:Snapshot(userId)
        assert(ok); return data.coins
    end
    local function grant(data, reward)
        data.coins += reward.coins or 0
    end
    accounts:Update(1, function(data) data.coins = 100; return true end)
    local ledger = Ledger.new(accounts)
    fake.failAfter = "u_2"
    local delivered = ledger:Send(1, 2, 25, "gift-one")
    check(not delivered, "lost credit response must remain pending")
    check(coins(1) == 75 and coins(2) == 25, "prepared debit + committed credit")
    check(ledger:Resume(1, "gift-one"), "recover interrupted delivery")
    check(ledger:Send(1, 2, 25, "gift-one"), "repeat gift must acknowledge")
    check(coins(1) == 75 and coins(2) == 25, "no duplicate debit or credit")
    check(not ledger:Send(1, 2, 26, "gift-one"), "conflicting ID must fail closed")
    check(not ledger:Send(1, 2, 1000, "too-large"), "insufficient balance")
    fake.failBefore = "u_2"
    check(not ledger:Send(1, 2, 5, "gift-two"), "destination unavailable")
    check(coins(1) == 70 and coins(2) == 25, "escrow retained until retry")
    ledger:Recover(1)
    check(coins(1) == 70 and coins(2) == 30, "recovery completes pending gift")
    accounts:Update(1, function(data) data.inventory.sword = {template = "sword", level = 3}; return true end)
    fake.failAfter = "u_2"
    check(not ledger:SendItem(1, 2, "sword", "item-one"), "item response lost")
    check(ledger:Resume(1, "item-one"), "item recovery")
    check(ledger:SendItem(1, 2, "sword", "item-one"), "same item transaction acknowledged")
    local _, _, senderData = accounts:Snapshot(1)
    local _, _, receiverData = accounts:Snapshot(2)
    check(senderData.inventory.sword == nil and receiverData.inventory.sword.level == 3, "item moved once")
    check(not ledger:SendItem(1, 2, "sword", "item-two"), "missing item cannot be sent again")

    local center = Center.new(accounts, {[123] = {coins = 10}}, grant, function() return true end)
    local receipt = {PlayerId = 1, ProductId = 123, PurchaseId = "receipt-one"}
    fake.failAfter = "u_1"
    check(center:Process(receipt) == Enum.ProductPurchaseDecision.NotProcessedYet, "ambiguous save deferred")
    check(center:Process(receipt) == Enum.ProductPurchaseDecision.PurchaseGranted, "durable retry acknowledged")
    check(center:Process(receipt) == Enum.ProductPurchaseDecision.PurchaseGranted, "repeat receipt acknowledged")
    check(coins(1) == 80, "purchase awarded once even when transforms repeat")
    check(center:Process({PlayerId = 1, ProductId = 999, PurchaseId = "unknown"})
        == Enum.ProductPurchaseDecision.NotProcessedYet, "unknown product deferred")

    local retention = Retention.new(accounts, {
        daily = {{coins = 1}, {coins = 2}},
        playtime = {first = {seconds = 60, reward = {coins = 5}}},
        events = {launch = {starts = 0, ends = 100, reward = {coins = 3}}},
    }, grant)
    local _, first = retention:ClaimDaily(1, 86399)
    local _, nextDay = retention:ClaimDaily(1, 86400)
    check(first.streak == 1 and nextDay.streak == 2, "UTC midnight advances streak")
    local _, duplicate = retention:ClaimDaily(1, 86401)
    check(duplicate.status ~= "granted", "same day cannot claim twice")
    local _, gap = retention:ClaimDaily(1, 3 * 86400)
    check(gap.streak == 1, "missed day resets streak")
    retention:CheckpointPlaytime(1, "session-a", 60)
    retention:CheckpointPlaytime(1, "session-a", 60)
    local _, checkpoint = retention:CheckpointPlaytime(1, "session-a", 61)
    check(checkpoint.seconds == 61, "cumulative checkpoint deduplicates")
    retention:ClaimPlaytime(1, "first")
    local _, twice = retention:ClaimPlaytime(1, "first")
    check(twice.status == "already_claimed", "playtime tier once")
    local _, closed = retention:ClaimEvent(1, "launch", 100, function() return true end)
    check(closed.status == "ineligible", "event end exclusive")

    local quests = Quests.new(accounts, {
        hunt = {version = 1, title = "Hunt", event = "EnemyDefeated", target = 2, reward = {coins = 7}},
    }, grant)
    quests:Emit(1, "EnemyDefeated", "kill-b", 1)
    quests:Emit(1, "EnemyDefeated", "kill-b", 1)
    local _, partial = quests:Snapshot(1)
    check(partial[1].progress == 1, "duplicate event ignored")
    quests:Emit(1, "EnemyDefeated", "kill-a", 1)
    local _, claimed = quests:Claim(1, "hunt")
    local _, claimedTwice = quests:Claim(1, "hunt")
    check(claimed.status == "granted" and claimedTwice.status == "already_claimed", "quest award once")

    local guard = Guard.new(Guard.DefaultChecks, function() end)
    local profile = {Inventory = {"sword"}, Coins = 10}
    local snapshot = guard:BeforeSave("session", profile)
    check(snapshot and snapshot ~= profile and snapshot.Inventory ~= profile.Inventory, "detached shadow")
    guard:Saved("session", snapshot)
    profile.Inventory = nil
    check(guard:BeforeSave("session", profile) == nil, "corruption blocks save")
    profile.Inventory = {}
    check(not guard:CanMutate("session"), "lock sticks after shape repaired")
    fake.values.u_9 = {schema = 99}
    check(not accounts:Snapshot(9), "unknown schema cannot be overwritten")
    check(fake.values.u_9.schema == 99, "corrupt record preserved")
    local tiny = Accounts.new(fake, 0)
    check(not tiny:Update(10, function(data)
        data.receipts.test = {productId = 123}; return true
    end), "history capacity fails closed")
    print(string.format("Backend fault harness: %d checks passed (mock services only)", checks))
    return checks
end
