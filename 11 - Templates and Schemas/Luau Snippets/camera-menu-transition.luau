-- Untested: client camera transition helper only; host owns enter/exit and focus.
-- Supply a current camera and target CFrame. Call cleanup before camera replacement.
local TweenService = game:GetService("TweenService")
local Config = { Duration = 0.7, Easing = Enum.EasingStyle.Sine }
local function create(camera)
	local active = nil
	local function move(target, reducedMotion)
		if active then active:Cancel(); active = nil end
		if reducedMotion then camera.CFrame = target; return end
		active = TweenService:Create(camera, TweenInfo.new(Config.Duration, Config.Easing, Enum.EasingDirection.Out), {CFrame = target})
		active:Play()
	end
	local function cleanup()
		if active then active:Cancel(); active = nil end
	end
	return move, cleanup
end
return create
