--!nocheck
-- Tested: Studio CLIENT transform interpolation and cleanup; animation playback untested.
-- Caller passes a bounded trusted clip; never execute arbitrary animation IDs from client uploads.
local Player = {}
function Player.new(clip, factory)
    assert(#clip >= 2 and #clip <= 301, "invalid_clip")
    local ghosts, tracks = {}, {}
    local destroyed = false
    local elapsed, index = 0, 1
    local length = clip[#clip].time - clip[1].time
    assert(length > 0 and length <= 11, "invalid_duration")
    local object = {}
    function object:Step(dt)
        if destroyed then return false end
        elapsed = math.min(length, elapsed + math.max(0, dt))
        local now = clip[1].time + elapsed
        while index < #clip - 1 and clip[index + 1].time <= now do index += 1 end
        local a, b = clip[index], clip[index + 1]
        local alpha = math.clamp((now - a.time) / math.max(0.001, b.time - a.time), 0, 1)
        for id in pairs(a.objects) do
            if not ghosts[id] then
                local model, animator = factory(id)
                ghosts[id], tracks[id] = {model = model, animator = animator}, {}
            end
        end
        for id, ghost in pairs(ghosts) do
            local first, second = a.objects[id], b.objects[id]
            if first and second then
                ghost.model:PivotTo(first.pivot:Lerp(second.pivot, alpha))
                local active = {}
                for _, state in ipairs(first.animations) do
                    active[state.id] = true
                    local track = tracks[id][state.id]
                    if not track and ghost.animator then
                        local animation = Instance.new("Animation")
                        animation.AnimationId = state.id
                        local ok, loaded = pcall(function() return ghost.animator:LoadAnimation(animation) end)
                        animation:Destroy()
                        if ok then track = loaded; tracks[id][state.id] = track end
                    end
                    if track then
                        if not track.IsPlaying then track:Play(0, state.weight, 0) end
                        track:AdjustWeight(state.weight, 0)
                        if track.Length > 0 then
                            track.TimePosition = math.clamp(state.position + (now - a.time) * state.speed, 0, track.Length)
                        end
                    end
                end
                for animationId, track in pairs(tracks[id]) do
                    if not active[animationId] then track:Stop(0) end
                end
            else
                -- Removed/absent objects: destroy ghost; recreate if ID returns later.
                for _, track in pairs(tracks[id]) do track:Destroy() end
                ghost.model:Destroy(); ghosts[id], tracks[id] = nil, nil
            end
        end
        return elapsed < length
    end
    function object:Destroy()
        if destroyed then return end
        destroyed = true
        for id, ghost in pairs(ghosts) do
            for _, track in pairs(tracks[id]) do track:Destroy() end
            ghost.model:Destroy()
        end
        table.clear(ghosts); table.clear(tracks)
    end
    return object
end
return Player
