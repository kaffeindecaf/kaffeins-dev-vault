--!nocheck
-- Tested: Studio local room capacity/membership; no cross-server skill or teleport queue.
local FSM = require(script.Parent["match-room-fsm"])
local Rooms = {}
Rooms.__index = Rooms
function Rooms.new()
    return setmetatable({rooms = {}, membership = {}}, Rooms)
end
function Rooms:Add(id, capacity, config, loader)
    assert(not self.rooms[id] and capacity >= config.minPlayers, "invalid_room")
    local room = {members = {}, capacity = capacity}
    room.fsm = FSM.new(config, function()
        local n = 0
        for _ in pairs(room.members) do n += 1 end
        return n
    end, loader)
    self.rooms[id] = room
    return room.fsm
end
function Rooms:Join(player, id)
    local room = self.rooms[id]
    if not room or self.membership[player] then return false end
    local state = room.fsm.state
    if state ~= "WaitingForPlayers" and state ~= "Intermission" then return false end
    local n = 0
    for _ in pairs(room.members) do n += 1 end
    if n >= room.capacity then return false end
    room.members[player], self.membership[player] = true, id
    return true
end
function Rooms:Leave(player)
    local id = self.membership[player]
    if id and self.rooms[id] then self.rooms[id].members[player] = nil end
    self.membership[player] = nil
end
function Rooms:Step(now)
    for _, room in pairs(self.rooms) do room.fsm:Step(now) end
end
function Rooms:Remove(id)
    local room = self.rooms[id]
    if not room then return end
    for player in pairs(room.members) do self.membership[player] = nil end
    room.fsm:Destroy(); self.rooms[id] = nil
end
function Rooms:Destroy()
    local ids = {}
    for id in pairs(self.rooms) do table.insert(ids, id) end
    for _, id in ipairs(ids) do self:Remove(id) end
end
return Rooms
