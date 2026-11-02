-- Untested: client-only stack. Container should have a UIListLayout;
-- template must be a hidden GuiObject with a descendant TextLabel named Message.
local Config = { MaxVisible = 3, DefaultSeconds = 3 }
local function createStack(container, template)
	local active, destroyed = {}, false
	local function remove(card)
		local i = table.find(active, card)
		if i then table.remove(active, i) end
		card:Destroy()
	end
	local function show(message, seconds)
		if destroyed then return end
		while #active >= Config.MaxVisible do remove(active[1]) end
		local card = template:Clone()
		local label = card:FindFirstChild("Message", true)
		if not label or not label:IsA("TextLabel") then card:Destroy(); return end
		label.Text = tostring(message)
		card.Visible = true
		card.Parent = container
		table.insert(active, card)
		task.delay(math.max(0, tonumber(seconds) or Config.DefaultSeconds), function()
			if table.find(active, card) then remove(card) end
		end)
	end
	return show, function()
		destroyed = true
		while #active > 0 do remove(active[1]) end
	end
end
return createStack
