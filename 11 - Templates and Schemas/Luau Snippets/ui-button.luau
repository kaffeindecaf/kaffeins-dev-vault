-- Untested: data-driven button treatment; supply the existing TextButton and local callbacks.
-- AI fill-in fields are in CONFIG. This snippet does not grant gameplay or purchase authority.

local TweenService = game:GetService("TweenService")

local CONFIG = {
	Text = "{{BUTTON_LABEL}}",
	BackgroundColor = Color3.fromRGB(70, 155, 230),
	HoverColor = Color3.fromRGB(92, 176, 248),
	PressedColor = Color3.fromRGB(56, 128, 198),
	TextColor = Color3.fromRGB(255, 255, 255),
	HoverScale = 1.04,
	PressScale = 0.97,
	TweenTime = 0.12,
	ReducedMotion = false,
	OnActivated = function() end, -- {{CLIENT_ACTION_OR_REQUEST}}
}

local function attachButton(button: TextButton, config)
	config = config or CONFIG
	assert(button and button:IsA("TextButton"), "attachButton expects a TextButton")

	button.Text = config.Text
	button.AutoButtonColor = false
	button.Selectable = true
	button.BackgroundColor3 = config.BackgroundColor
	button.TextColor3 = config.TextColor

	local scale = button:FindFirstChildOfClass("UIScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Parent = button
	end

	local activeTween: Tween? = nil
	local function animate(targetScale: number, color: Color3)
		if activeTween then activeTween:Cancel() end
		if config.ReducedMotion then
			scale.Scale = 1
			button.BackgroundColor3 = color
			return
		end
		activeTween = TweenService:Create(button, TweenInfo.new(config.TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { BackgroundColor3 = color })
		activeTween:Play()
		TweenService:Create(scale, TweenInfo.new(config.TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = targetScale }):Play()
	end

	local connections = {
		button.MouseEnter:Connect(function() animate(config.HoverScale, config.HoverColor) end),
		button.MouseLeave:Connect(function() animate(1, config.BackgroundColor) end),
		button.SelectionGained:Connect(function() animate(config.HoverScale, config.HoverColor) end),
		button.SelectionLost:Connect(function() animate(1, config.BackgroundColor) end),
		button.Activated:Connect(function()
			animate(config.PressScale, config.PressedColor)
			config.OnActivated()
			task.delay(config.TweenTime, function()
				if button.Parent then animate(1, config.BackgroundColor) end
			end)
		end),
	}

	return function()
		if activeTween then activeTween:Cancel() end
		for _, connection in ipairs(connections) do connection:Disconnect() end
	end
end

return attachButton
