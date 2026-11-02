-- Untested: pointer drag logic for an existing slider track, fill, and thumb.
-- Add keyboard/gamepad adjustment in the owning settings controller before shipping.

local UserInputService = game:GetService("UserInputService")

local CONFIG = {
	Min = 0,
	Max = 100,
	Step = 1,
	InitialValue = 50,
	Format = function(value) return string.format("%d%%", value) end,
	OnChanged = function(_value) end, -- {{UPDATE_LOCAL_SETTING}}
}

local function attachSlider(track: GuiObject, fill: GuiObject, thumb: GuiObject, valueLabel: TextLabel?, config)
	config = config or CONFIG
	assert(config.Max > config.Min, "slider Max must be greater than Min")
	assert(config.Step > 0, "slider Step must be positive")

	local value = config.InitialValue
	local dragging = false
	local connections = {}

	local function quantize(raw)
		local clamped = math.clamp(raw, config.Min, config.Max)
		local steps = math.floor(((clamped - config.Min) / config.Step) + 0.5)
		return math.clamp(config.Min + steps * config.Step, config.Min, config.Max)
	end

	local function render(nextValue, fireChanged)
		value = quantize(nextValue)
		local alpha = (value - config.Min) / (config.Max - config.Min)
		fill.Size = UDim2.new(alpha, 0, fill.Size.Y.Scale, fill.Size.Y.Offset)
		thumb.Position = UDim2.new(alpha, 0, thumb.Position.Y.Scale, thumb.Position.Y.Offset)
		if valueLabel then valueLabel.Text = config.Format(value) end
		if fireChanged then config.OnChanged(value) end
	end

	local function updateFromScreenX(screenX)
		local width = track.AbsoluteSize.X
		if width <= 0 then return end
		local alpha = math.clamp((screenX - track.AbsolutePosition.X) / width, 0, 1)
		render(config.Min + alpha * (config.Max - config.Min), true)
	end

	local function beginDrag(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromScreenX(input.Position.X)
		end
	end

	table.insert(connections, track.InputBegan:Connect(beginDrag))
	table.insert(connections, thumb.InputBegan:Connect(beginDrag))
	table.insert(connections, UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromScreenX(input.Position.X)
		end
	end))
	table.insert(connections, UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))

	render(value, false)
	return function()
		dragging = false
		for _, connection in ipairs(connections) do connection:Disconnect() end
	end
end

return attachSlider
