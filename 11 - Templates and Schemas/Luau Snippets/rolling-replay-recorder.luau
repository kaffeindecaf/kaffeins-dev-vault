--!nocheck
-- Tested: Studio bounded transform snapshots; live animation capture untested.
local Recorder = {}
Recorder.__index = Recorder
function Recorder.new(seconds, hz, maxObjects)
    assert(seconds > 0 and seconds <= 10 and hz >= 1 and hz <= 30, "invalid_buffer")
    return setmetatable({capacity = math.ceil(seconds * hz) + 1, interval = 1 / hz,
        maxObjects = maxObjects or 32, objects = {}, frames = {}, head = 0, count = 0, last = nil}, Recorder)
end
function Recorder:Register(id, model, animator)
    assert(type(id) == "string" and #id <= 64 and not self.objects[id], "invalid_id")
    local n = 0
    for _ in pairs(self.objects) do n += 1 end
    assert(n < self.maxObjects, "object_capacity")
    self.objects[id] = {model = model, animator = animator}
end
function Recorder:Unregister(id) self.objects[id] = nil end
function Recorder:Sample(now)
    if self.last and now - self.last < self.interval then return end
    self.last = now
    local objects = {}
    for id, object in pairs(self.objects) do
        if object.model.Parent then
            local animations = {}
            if object.animator then
                for _, track in ipairs(object.animator:GetPlayingAnimationTracks()) do
                    if #animations >= 8 then break end
                    if track.Animation then table.insert(animations, {
                        id = track.Animation.AnimationId, position = track.TimePosition,
                        speed = track.Speed, weight = track.WeightCurrent,
                    }) end
                end
            end
            objects[id] = {pivot = object.model:GetPivot(), animations = animations}
        end
    end
    self.head = self.head % self.capacity + 1
    self.frames[self.head] = {time = now, objects = objects}
    self.count = math.min(self.count + 1, self.capacity)
end
function Recorder:Clip(seconds)
    local result = {}
    if self.count == 0 then return result end
    local cutoff = self.frames[self.head].time - seconds
    for offset = self.count - 1, 0, -1 do
        local index = (self.head - offset - 1) % self.capacity + 1
        local frame = self.frames[index]
        if frame.time >= cutoff then
            local detached = {time = frame.time, objects = {}}
            for id, object in pairs(frame.objects) do
                local animations = {}
                for _, animation in ipairs(object.animations) do
                    table.insert(animations, table.clone(animation))
                end
                detached.objects[id] = {pivot = object.pivot, animations = animations}
            end
            table.insert(result, detached)
        end
    end
    return result
end
function Recorder:Destroy()
    table.clear(self.objects); table.clear(self.frames); self.count, self.head, self.last = 0, 0, nil
end
return Recorder
