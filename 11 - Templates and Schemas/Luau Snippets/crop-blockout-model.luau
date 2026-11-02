-- Untested: original static primitive crop blockout, not the source game's model.
-- Caller positions and parents it in a separate safe test place.
local Config = { Name = "CropBlockout", StemHeight = 4, StemWidth = 0.35, CobSize = Vector3.new(1.2, 2, 1.2), StemColor = Color3.fromRGB(68, 142, 58), CobColor = Color3.fromRGB(245, 200, 63) }
local function build()
	local model = Instance.new("Model")
	model.Name = Config.Name
	local stem = Instance.new("Part")
	stem.Name, stem.Size, stem.Color = "Stem", Vector3.new(Config.StemWidth, Config.StemHeight, Config.StemWidth), Config.StemColor
	stem.Position = Vector3.new(0, Config.StemHeight / 2, 0)
	stem.Anchored, stem.CanCollide = true, false
	stem.Parent = model
	local cob = Instance.new("Part")
	cob.Name, cob.Size, cob.Color = "Crop", Config.CobSize, Config.CobColor
	cob.Position = Vector3.new(0, Config.StemHeight, 0)
	cob.Anchored, cob.CanCollide = true, false
	cob.Parent = model
	model.PrimaryPart = stem -- pivot is stem center; initial bottom is world Y=0
	return model
end
return build
