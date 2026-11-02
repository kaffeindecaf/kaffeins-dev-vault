-- Untested: original blockout inspired by the idea of a world shop, not source geometry.
-- Initial bottom-center is at origin; PrimaryPart pivot is the base center.
local Config = {
	Name = "ShopStandPlaceholder", BaseSize = Vector3.new(10, 1, 6),
	PostHeight = 8, PostWidth = 0.5, RoofThickness = 0.6,
	BaseColor = Color3.fromRGB(120, 81, 48), RoofColor = Color3.fromRGB(71, 138, 76),
}
local function buildStand()
	local model = Instance.new("Model")
	model.Name = Config.Name
	local function block(name, size, position, color)
		local part = Instance.new("Part")
		part.Name, part.Size, part.Position, part.Color = name, size, position, color
		part.Anchored = true
		part.Parent = model
		return part
	end
	local base = block("Base", Config.BaseSize, Vector3.new(0, Config.BaseSize.Y / 2, 0), Config.BaseColor)
	for _, x in ipairs({-1, 1}) do
		for _, z in ipairs({-1, 1}) do
			block("Post", Vector3.new(Config.PostWidth, Config.PostHeight, Config.PostWidth), Vector3.new(x * (Config.BaseSize.X - Config.PostWidth) / 2, Config.BaseSize.Y + Config.PostHeight / 2, z * (Config.BaseSize.Z - Config.PostWidth) / 2), Config.BaseColor)
		end
	end
	block("Roof", Vector3.new(Config.BaseSize.X, Config.RoofThickness, Config.BaseSize.Z), Vector3.new(0, Config.BaseSize.Y + Config.PostHeight + Config.RoofThickness / 2, 0), Config.RoofColor)
	model.PrimaryPart = base
	return model
end
return buildStand
