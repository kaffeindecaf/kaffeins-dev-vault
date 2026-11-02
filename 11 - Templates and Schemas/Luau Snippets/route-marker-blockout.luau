-- Untested: original static primitive milestone blockout, not source art.
-- Caller parents and positions it in a separate safe test place.
local Config = { Name = "RouteMarker", Height = 6, Width = 0.5, SignSize = Vector3.new(5, 2, 0.3), PostColor = Color3.fromRGB(110, 78, 49), SignColor = Color3.fromRGB(240, 194, 95) }
local function build()
	local model = Instance.new("Model")
	model.Name = Config.Name
	local post = Instance.new("Part")
	post.Name, post.Size, post.Color = "Post", Vector3.new(Config.Width, Config.Height, Config.Width), Config.PostColor
	post.Position = Vector3.new(0, Config.Height / 2, 0)
	post.Anchored, post.CanCollide = true, false
	post.Parent = model
	local sign = Instance.new("Part")
	sign.Name, sign.Size, sign.Color = "Sign", Config.SignSize, Config.SignColor
	sign.Position = Vector3.new(0, Config.Height, 0)
	sign.Anchored, sign.CanCollide = true, false
	sign.Parent = model
	model.PrimaryPart = post -- pivot is post center; initial bottom is at world Y=0
	return model
end
return build
