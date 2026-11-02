-- Untested: client-only presentation; caller supplies a vetted Model and container.
-- Bounding box includes invisible parts; test aspect ratio and replace with authored bounds if needed.
local Config = { Name = "ModelPreview", FieldOfView = 40, Zoom = 1.5, Direction = Vector3.new(-0.55, 0.22, -1).Unit }
local function showPreview(container, source)
	local old = container:FindFirstChild(Config.Name)
	if old then old:Destroy() end
	if not source or not source:IsA("Model") then return nil end
	local view = Instance.new("ViewportFrame")
	view.Name = Config.Name
	view.Size = UDim2.fromScale(1, 1)
	view.BackgroundTransparency = 1
	local clone = source:Clone()
	for _, object in ipairs(clone:GetDescendants()) do
		if object:IsA("BasePart") then
			object.Anchored, object.CanCollide, object.CanTouch, object.CanQuery = true, false, false, false
		elseif object:IsA("LuaSourceContainer") or object:IsA("LayerCollector") then
			object:Destroy()
		end
	end
	clone:PivotTo(CFrame.identity)
	clone.Parent = view
	local bounds, size = clone:GetBoundingBox()
	local radius = math.max(size.X, size.Y, size.Z, 1) / 2
	local distance = radius / math.tan(math.rad(Config.FieldOfView / 2)) * Config.Zoom
	local camera = Instance.new("Camera")
	camera.FieldOfView = Config.FieldOfView
	camera.CFrame = CFrame.lookAt(bounds.Position + Config.Direction * distance, bounds.Position)
	camera.Parent = view
	view.CurrentCamera = camera
	view.Parent = container
	return view
end
return showPreview
