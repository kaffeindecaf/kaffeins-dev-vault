-- Untested: progress renderer for an existing fill and optional text label.
-- Supply the current/target values from the appropriate client data controller.

local TweenService = game:GetService("TweenService")

local CONFIG = {
	Min = 0,
	Max = 50,
	ReducedMotion = false,
	Duration = 0.22,
	Format = function(value, maximum)
		return string.format("%d / %d", value, maximum)
	end,
}

local function setProgress(fill: GuiObject, valueLabel: TextLabel?, value: number, config)
	config = config or CONFIG
	local span = config.Max - config.Min
	local alpha = if span <= 0 then 0 else math.clamp((value - config.Min) / span, 0, 1)
	local target = UDim2.new(alpha, 0, fill.Size.Y.Scale, fill.Size.Y.Offset)

	if config.ReducedMotion then
		fill.Size = target
	else
		TweenService:Create(fill, TweenInfo.new(config.Duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = target }):Play()
	end

	if valueLabel then
		valueLabel.Text = config.Format(math.clamp(value, config.Min, config.Max), config.Max)
	end
	return alpha
end

return setProgress
