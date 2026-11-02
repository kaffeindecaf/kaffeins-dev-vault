--!nocheck
-- Tested: Studio mock receipts; live Marketplace integration untested. Install one owner.
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Center = {}
Center.__index = Center
local owner = nil

function Center.new(accounts, products, grant, findPlayer)
    return setmetatable({accounts = accounts, products = products, grant = grant,
        findPlayer = findPlayer or function(id) return Players:GetPlayerByUserId(id) end}, Center)
end
function Center:Process(receipt)
    local retry = Enum.ProductPurchaseDecision.NotProcessedYet
    -- The account module serializes operations locally; UpdateAsync handles cross-server conflicts.
    if not self.findPlayer(receipt.PlayerId) then return retry end
    local ok, result = self.accounts:Update(receipt.PlayerId, function(data)
        local previous = data.receipts[receipt.PurchaseId]
        if previous then
            assert(previous.productId == receipt.ProductId, "purchase_id_conflict")
            return "recorded"
        end
        local reward = self.products[receipt.ProductId]
        if not reward then return "unknown_product" end -- keep old product mappings after delisting
        self.grant(data, reward) -- pure, deterministic, non-yielding, no Instances/remotes
        data.receipts[receipt.PurchaseId] = {productId = receipt.ProductId}
        return "recorded"
    end)
    if ok and result == "recorded" then return Enum.ProductPurchaseDecision.PurchaseGranted end
    return retry
end
function Center:Install()
    assert(owner == nil, "receipt_owner_already_installed")
    owner = self
    MarketplaceService.ProcessReceipt = function(receipt)
        local ok, result = pcall(function() return self:Process(receipt) end)
        if not ok then warn("Receipt deferred"); return Enum.ProductPurchaseDecision.NotProcessedYet end
        return result
    end
    -- Do not install another dispatcher or rely on PromptProductPurchaseFinished to fulfill products.
end
function Center:OwnsPass(player, passId)
    local ok, owns = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(player.UserId, passId)
    end)
    if not ok then return nil, "ownership_unavailable" end
    return owns
end
function Center:BindPasses(passRewards, applyEntitlement)
    -- Entitlement must be idempotent (set a capability, not add currency per join).
    local function refresh(player)
        for passId, entitlement in pairs(passRewards) do
            local owns = self:OwnsPass(player, passId)
            if owns and player.Parent == Players then
                applyEntitlement(player, entitlement)
            end
        end
    end
    local added = Players.PlayerAdded:Connect(function(player) task.spawn(refresh, player) end)
    local purchased = MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, passId, bought)
        if bought and passRewards[passId] then task.spawn(refresh, player) end
    end)
    for _, player in ipairs(Players:GetPlayers()) do task.spawn(refresh, player) end
    return function() added:Disconnect(); purchased:Disconnect() end
end
return Center
