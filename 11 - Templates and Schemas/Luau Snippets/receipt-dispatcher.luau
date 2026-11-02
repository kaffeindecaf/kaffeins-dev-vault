-- Untested: server-only integration scaffold, NOT a working purchase system.
-- Configure actual IDs only after creation. Do not deploy with a second callback.
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local Config = { Products = {
	-- [YOUR_PRODUCT_ID] = "your_stable_entitlement_key",
} }

-- Replace with a durable, concurrency-safe transaction that atomically records
-- receipt.PurchaseId and its entitlement, or an independently reviewed protocol.
-- Return true only when a previous or new grant is durably committed.
local function CommitReceipt(_player, _receipt, _entitlementKey)
	return false -- intentionally disabled until integrated
end

MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	local entitlement = Config.Products[receipt.ProductId]
	if not player or not entitlement then return Enum.ProductPurchaseDecision.NotProcessedYet end
	local ok, committed = pcall(CommitReceipt, player, receipt, entitlement)
	if ok and committed == true then return Enum.ProductPurchaseDecision.PurchaseGranted end
	return Enum.ProductPurchaseDecision.NotProcessedYet
end
