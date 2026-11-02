-- Untested: static, original primitive vehicle blockout; not driveable.
-- Caller positions and parents the returned model in a separate test place.
local Config = {
	Name = "VehicleBlockout", BodySize = Vector3.new(6, 2, 10),
	BodyColor = Color3.fromRGB(240, 177, 56), WheelColor = Color3.fromRGB(35, 35, 35),
	WheelSize = Vector3.new(1, 2.5, 2.5),
}
local function build()
	local model = Instance.new("Model")
	model.Name = Config.Name
	local function part(name, size, position, color)
		local p = Instance.new("Part")
		p.Name, p.Size, p.Position, p.Color = name, size, position, color
		p.Anchored, p.CanCollide = true, false
		p.Parent = model
		return p
	end
	local body = part("Body", Config.BodySize, Vector3.new(0, Config.WheelSize.Y / 2 + Config.BodySize.Y / 2, 0), Config.BodyColor)
	for _, side in ipairs({-1, 1}) do
		for _, endSign in ipairs({-1, 1}) do
			part("Wheel", Config.WheelSize, Vector3.new(side * (Config.BodySize.X + Config.WheelSize.X) / 2, Config.WheelSize.Y / 2, endSign * Config.BodySize.Z * 0.32), Config.WheelColor)
		end
	end
	model.PrimaryPart = body -- pivot is body center; bottom initially lies at world Y=0
	return model
end
return build
