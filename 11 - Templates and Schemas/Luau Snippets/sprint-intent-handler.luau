-- Untested: server-side handler factory; integrate with one existing remote.
-- ResolveSpeed must derive speed from trusted server state and coordinate buffs.
local Config = { MinRequestInterval = 0.1 }
local function createHandler(resolveSpeed, sendState)
	local last = {}
	local function handle(player, requested)
		if typeof(requested) ~= "boolean" then return end
		local now = os.clock()
		if last[player] and now - last[player] < Config.MinRequestInterval then return end
		last[player] = now
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then return end
		local approved, speed = resolveSpeed(player, requested)
		if type(speed) ~= "number" or speed ~= speed or speed < 0 or speed == math.huge then return end
		humanoid.WalkSpeed = speed
		if sendState then sendState(player, approved == true, speed) end
	end
	return handle, function(player) last[player] = nil end
end
return createHandler
