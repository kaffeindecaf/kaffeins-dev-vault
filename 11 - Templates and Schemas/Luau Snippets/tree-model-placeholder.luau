-- Untested: original primitive placeholder; no source art or asset IDs.
-- Initial bottom-center is at origin; PrimaryPart pivot is the trunk center.
local Config = {
	Name = "TreePlaceholder", TrunkSize = Vector3.new(2, 7, 2),
	CrownSize = Vector3.new(7, 6, 7), TrunkColor = Color3.fromRGB(112, 72, 42),
	CrownColor = Color3.fromRGB(67, 154, 76),
}
local function buildTree()
	local model = Instance.new("Model")
	model.Name = Config.Name
	local function part(name, size, color, position, shape)
		local p = Instance.new("Part")
		p.Name, p.Size, p.Color, p.Position = name, size, color, position
		p.Anchored, p.CanCollide, p.Shape = true, false, shape
		p.Parent = model
		return p
	end
	local trunk = part("Trunk", Config.TrunkSize, Config.TrunkColor, Vector3.new(0, Config.TrunkSize.Y / 2, 0), Enum.PartType.Block)
	part("Crown", Config.CrownSize, Config.CrownColor, Vector3.new(0, Config.TrunkSize.Y + Config.CrownSize.Y / 2, 0), Enum.PartType.Ball)
	model.PrimaryPart = trunk
	return model
end
return buildTree
