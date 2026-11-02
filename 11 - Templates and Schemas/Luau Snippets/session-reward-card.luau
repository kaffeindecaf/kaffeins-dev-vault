-- Untested: presentation-only session reward card template.
-- Supply a GuiButton with TextLabel children named Reward and Timer.
-- OnClaim is an intent callback; eligibility and grants belong to the server.
local Config = {
	WaitingColor = Color3.fromRGB(255, 190, 45),
	ReadyColor = Color3.fromRGB(32, 205, 72),
	ClaimedColor = Color3.fromRGB(105, 110, 115),
	ReadyText = "READY!",
	ClaimedText = "CLAIMED",
}

local function bindCard(card, rewardId, onClaim)
	local reward = card:WaitForChild("Reward")
	local timer = card:WaitForChild("Timer")
	local ready = false
	local connection = card.Activated:Connect(function()
		if ready and onClaim then onClaim(rewardId) end
	end)
	local function render(snapshot)
		reward.Text = snapshot.Label or "REWARD"
		ready = not snapshot.Claimed and type(snapshot.Remaining) == "number" and snapshot.Remaining <= 0
		if snapshot.Claimed then
			timer.Text, card.BackgroundColor3 = Config.ClaimedText, Config.ClaimedColor
		elseif ready then
			timer.Text, card.BackgroundColor3 = Config.ReadyText, Config.ReadyColor
		elseif type(snapshot.Remaining) == "number" then
			local seconds = math.max(0, math.ceil(snapshot.Remaining))
			timer.Text = string.format("%dm %02ds", math.floor(seconds / 60), seconds % 60)
			card.BackgroundColor3 = Config.WaitingColor
		else
			timer.Text, card.BackgroundColor3 = "--", Config.WaitingColor
		end
	end
	return render, function() connection:Disconnect() end
end

return bindCard
