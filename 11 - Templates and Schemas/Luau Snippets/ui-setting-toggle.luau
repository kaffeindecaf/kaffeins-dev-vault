-- Untested: client presentation only. Host validates/persists requests on server.
-- button is a GuiButton, label a TextLabel; applyLocal previews the setting.
local Config = { OnText = "ON", OffText = "OFF", OnColor = Color3.fromRGB(56, 160, 93), OffColor = Color3.fromRGB(100, 100, 100) }
local function bindToggle(button, label, settingKey, initial, applyLocal, requestChange)
	local value = initial == true
	local function render(nextValue)
		value = nextValue == true
		label.Text = value and Config.OnText or Config.OffText
		button.BackgroundColor3 = value and Config.OnColor or Config.OffColor
		if applyLocal then applyLocal(settingKey, value) end
	end
	local connection = button.Activated:Connect(function()
		local nextValue = not value
		render(nextValue)
		if requestChange then requestChange(settingKey, nextValue) end
	end)
	render(value)
	-- Host must render authoritative updates and reconcile rejection/failure.
	return render, function() connection:Disconnect() end
end
return bindToggle
