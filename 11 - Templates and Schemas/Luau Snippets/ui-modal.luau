-- Untested: simple visual open/close helper for a supplied panel and optional backdrop.
-- Configure focus restoration and Escape/gamepad cancellation in the owning ScreenGui controller.

local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local CONFIG = {
	OpenTime = 0.18,
	CloseTime = 0.14,
	ReducedMotion = false,
}

local function attachModal(panel: GuiObject, backdrop: GuiObject?, firstAction: GuiObject?, config)
	config = config or CONFIG
	local savedSelection: GuiObject? = nil
	local activeTween: Tween? = nil
	local transitionId = 0
	local originalSize = panel.Size
	local scale = panel:FindFirstChildOfClass("UIScale")
	if not scale then
		scale = Instance.new("UIScale")
		scale.Parent = panel
	end

	local function cancelTween()
		if activeTween then activeTween:Cancel(); activeTween = nil end
	end

	local function open()
		transitionId += 1
		local thisTransition = transitionId
		savedSelection = GuiService.SelectedObject
		panel.Visible = true
		if backdrop then backdrop.Visible = true end
		if firstAction and firstAction.Selectable then GuiService.SelectedObject = firstAction end
		cancelTween()
		if config.ReducedMotion then
			panel.Size = originalSize
			scale.Scale = 1
			return
		end
		panel.Size = UDim2.new(originalSize.X.Scale * 0.96, originalSize.X.Offset, originalSize.Y.Scale * 0.96, originalSize.Y.Offset)
		scale.Scale = 0.98
		activeTween = TweenService:Create(panel, TweenInfo.new(config.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = originalSize })
		activeTween:Play()
		TweenService:Create(scale, TweenInfo.new(config.OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()
	end

	local function close()
		transitionId += 1
		local thisTransition = transitionId
		cancelTween()
		local function finish()
			panel.Visible = false
			if backdrop then backdrop.Visible = false end
			if savedSelection and savedSelection.Parent then GuiService.SelectedObject = savedSelection end
		end
		if config.ReducedMotion then finish(); return end
		activeTween = TweenService:Create(panel, TweenInfo.new(config.CloseTime, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Size = UDim2.new(originalSize.X.Scale * 0.96, originalSize.X.Offset, originalSize.Y.Scale * 0.96, originalSize.Y.Offset),
		})
		activeTween.Completed:Once(function(playbackState)
			if playbackState == Enum.PlaybackState.Completed and transitionId == thisTransition then
				finish()
			end
		end)
		activeTween:Play()
	end

	return { Open = open, Close = close, Cancel = cancelTween }
end

return attachModal
