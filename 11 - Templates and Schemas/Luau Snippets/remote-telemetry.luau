--!nocheck
-- Tested: Studio fake remotes; explicit wrappers estimate application bytes, NOT wire bytes.
local Telemetry = {}
Telemetry.__index = Telemetry
local function estimate(value, seen, budget, depth)
    budget.nodes -= 1
    if budget.nodes < 0 or depth > 8 then return 0, false end
    local kind = typeof(value)
    if kind == "nil" then return 1, true end
    if kind == "boolean" then return 1, true end
    if kind == "number" then return 8, true end
    if kind == "string" then return #value + 4, true end
    if kind == "Vector3" then return 12, true end
    if kind == "CFrame" then return 48, true end
    if kind == "Instance" then return 8, true end
    if kind ~= "table" or seen[value] then return 0, false end
    seen[value] = true
    local total = 4
    for k, v in pairs(value) do
        local a, okA = estimate(k, seen, budget, depth + 1)
        local b, okB = estimate(v, seen, budget, depth + 1)
        if not okA or not okB then seen[value] = nil; return total, false end
        total += a + b
    end
    seen[value] = nil
    return total, true
end
function Telemetry.new(config)
    config = config or {}
    return setmetatable({
        rate = config.rate or 20, burst = config.burst or 40,
        maxBytes = config.maxEstimatedBytes or 16000, window = config.window or 2,
        now = config.clock or os.clock, rows = {}, connections = {}, names = {},
        maxRoutes = config.maxRoutes or 64,
    }, Telemetry)
end
function Telemetry:Register(name, remote)
    assert(type(name) == "string" and #name <= 64 and not self.names[name], "duplicate_route")
    assert(remote:IsA("RemoteEvent"), "RemoteEvent_required")
    local n = 0
    for _ in pairs(self.names) do n += 1 end
    assert(n < self.maxRoutes, "route_capacity")
    self.names[name] = remote
end
function Telemetry:_record(player, name, direction, args)
    assert(self.names[name], "unregistered_route")
    local now = self.now()
    local byPlayer = self.rows[player.UserId]
    if not byPlayer then byPlayer = {}; self.rows[player.UserId] = byPlayer end
    local key = name .. ":" .. direction
    local row = byPlayer[key]
    if not row then
        row = {name = name, direction = direction, start = now, calls = 0, bytes = 0,
            drops = 0, unknown = 0, tokens = self.burst, last = now}
        byPlayer[key] = row
    end
    if now - row.start >= self.window then
        row.start, row.calls, row.bytes, row.drops, row.unknown = now, 0, 0, 0, 0
    end
    row.tokens = math.min(self.burst, row.tokens + math.max(0, now - row.last) * self.rate)
    row.last = now
    local bytes, known = estimate(args, {}, {nodes = 512}, 0)
    row.calls += 1; row.bytes += bytes
    if not known then row.unknown += 1 end
    local allowed = known and bytes <= self.maxBytes and row.tokens >= 1
    if allowed then row.tokens -= 1 else row.drops += 1 end
    return allowed
end
function Telemetry:Bind(name, remote, handler)
    self:Register(name, remote)
    local connection = remote.OnServerEvent:Connect(function(player, ...)
        local args = table.pack(...)
        if self:_record(player, name, "in", args) then
            -- Handler still validates shape, ownership, range and state. No raw payload logs.
            handler(player, table.unpack(args, 1, args.n))
        end
    end)
    table.insert(self.connections, connection)
end
function Telemetry:Send(name, player, ...)
    local args = table.pack(...)
    self:_record(player, name, "out", args) -- observe only; never silently drop game-critical output
    self.names[name]:FireClient(player, table.unpack(args, 1, args.n))
end
function Telemetry:Snapshot()
    local snapshot, now = {}, self.now()
    for userId, routes in pairs(self.rows) do
        for _, row in pairs(routes) do
            if now - row.start < self.window then
                table.insert(snapshot, {userId = userId, route = row.name, direction = row.direction,
                    hz = row.calls / math.max(0.1, now - row.start),
                    estimatedBytes = row.bytes, flags = row.drops + row.unknown})
            end
        end
    end
    table.sort(snapshot, function(a, b) return a.flags > b.flags end)
    while #snapshot > 50 do table.remove(snapshot) end
    return snapshot
end
function Telemetry:Forget(player) self.rows[player.UserId] = nil end
function Telemetry:Destroy()
    for _, c in ipairs(self.connections) do c:Disconnect() end
    table.clear(self.connections); table.clear(self.rows); table.clear(self.names)
end
return Telemetry
