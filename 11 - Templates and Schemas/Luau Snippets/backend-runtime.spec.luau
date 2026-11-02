--!nocheck
-- Studio-only public-contract checks, invoked by the built-in test case with (t, modules).
return function(t, modules)
    -- Catch syntax/load errors even in optional adapters not invoked by the fault scenarios.
    t.test("all backend modules load", function()
        for _, module in ipairs(modules:GetChildren()) do
            t.expect.truthy(pcall(require, module))
        end
    end)
    -- Waiting account writes must retain enqueue order when the active write yields.
    t.test("account writes commit in FIFO enqueue order", function()
        local A = require(modules["backend-account-store"])
        local gate, completed = Instance.new("BindableEvent"), Instance.new("BindableEvent")
        local fake, calls, order, finished = {}, 0, {}, 0
        function fake:UpdateAsync(_, transform)
            calls += 1
            if calls == 1 then gate.Event:Wait() end
            self.value = transform(self.value)
            return A.Copy(self.value)
        end
        local accounts = A.new(fake)
        for index = 1, 3 do
            local request = index
            task.spawn(function()
                local ok, result = accounts:Update(1, function(data)
                    data.coins += 1
                    return request
                end)
                assert(ok)
                table.insert(order, result)
                finished += 1
                if finished == 3 then completed:Fire() end
            end)
        end
        gate:Fire()
        completed.Event:Wait()
        t.expect.equal(table.concat(order, ","), "1,2,3")
        local ok, _, snapshot = accounts:Snapshot(1)
        t.expect.truthy(ok); t.expect.equal(snapshot.coins, 3)
        gate:Destroy(); completed:Destroy()
    end)
    -- Explicitly tracked components report once after the scope grace period.
    t.test("component survives grace and is reported once", function()
        local P = require(modules["lifecycle-leak-profiler"])
        local profiler, component, reports = P.new(60), {}, 0
        local ticket = profiler:Track("round", component, "test component")
        profiler:EndScope("round", 0)
        profiler:Poll(59, function() reports += 1 end)
        t.expect.equal(reports, 0)
        profiler:Poll(60, function() reports += 1 end)
        profiler:Poll(61, function() reports += 1 end)
        t.expect.equal(reports, 1)
        profiler:Forget(ticket)
        profiler:Destroy()
    end)
    -- Registered inbound handlers enforce bursts without retaining raw payloads.
    t.test("remote burst drops third request and forget clears player", function()
        local T = require(modules["remote-telemetry"])
        local handler, now, calls, sent = nil, 0, 0, 0
        local remote = {OnServerEvent = {}}
        function remote:IsA(class) return class == "RemoteEvent" end
        function remote.OnServerEvent:Connect(fn) handler = fn; return {Disconnect = function() end} end
        function remote:FireClient() sent += 1 end
        local telemetry = T.new({burst = 2, rate = 1, clock = function() return now end})
        local player = {UserId = 100}
        telemetry:Bind("Action", remote, function() calls += 1 end)
        handler(player, "a"); handler(player, "b"); handler(player, "c")
        t.expect.equal(calls, 2)
        t.expect.truthy(telemetry:Snapshot()[1].flags > 0)
        now = 1; handler(player, "d")
        t.expect.equal(calls, 3)
        telemetry:Send("Action", player, "hello")
        t.expect.equal(sent, 1)
        telemetry:Forget(player); t.expect.equal(#telemetry:Snapshot(), 0)
        telemetry:Destroy()
    end)
    -- Cycles and excessive nesting cannot cause unbounded estimator traversal.
    t.test("remote cyclic payload fails closed", function()
        local T = require(modules["remote-telemetry"])
        local handler, calls = nil, 0
        local remote = {OnServerEvent = {}}
        function remote:IsA() return true end
        function remote.OnServerEvent:Connect(fn) handler = fn; return {Disconnect = function() end} end
        local telemetry = T.new()
        telemetry:Bind("Cycle", remote, function() calls += 1 end)
        local cycle = {}; cycle.self = cycle
        handler({UserId = 100}, cycle)
        t.expect.equal(calls, 0)
        telemetry:Destroy()
    end)
    -- Ring rollover preserves time order and detaches exported frame tables.
    t.test("rolling replay overwrites oldest and detaches clip", function()
        local Recorder = require(modules["rolling-replay-recorder"])
        local recorder = Recorder.new(1, 2)
        local parent, model = Instance.new("Folder"), Instance.new("Model")
        model.Parent = parent
        local part = Instance.new("Part"); part.Anchored = true; part.Parent = model
        recorder:Register("actor", model)
        for n = 0, 4 do model:PivotTo(CFrame.new(n, 0, 0)); recorder:Sample(n * 0.5) end
        local clip = recorder:Clip(1)
        t.expect.equal(#clip, 3)
        t.expect.equal(clip[1].time, 1)
        clip[1].objects.actor = nil
        t.expect.truthy(recorder:Clip(1)[1].objects.actor)
        recorder:Destroy(); parent:Destroy()
    end)
    -- One completion event wins; cleanup runs after results and on destroy only once.
    t.test("room phases reject repeated finish and clean map once", function()
        local FSM = require(modules["match-room-fsm"])
        local now, cleaned = 0, 0
        local fsm = FSM.new({minPlayers = 1, intermission = 1, loadTimeout = 5,
            roundDuration = 10, resultsDuration = 2, clock = function() return now end},
            function() return 1 end, function() return function() cleaned += 1 end end)
        fsm:Step(0); t.expect.equal(fsm.state, "Intermission")
        now = 1; fsm:Step(now)
        -- task.spawn loader does not yield in this case.
        t.expect.equal(fsm.state, "ActiveRound")
        t.expect.truthy(fsm:Finish(1, "test"))
        t.expect.falsy(fsm:Finish(1, "duplicate"))
        fsm:Step(3); t.expect.equal(fsm.state, "WaitingForPlayers")
        t.expect.equal(cleaned, 1)
        fsm:Destroy(); t.expect.equal(cleaned, 1)
    end)
    -- Capacity and membership prohibit placing one player in two rooms.
    t.test("room capacity and membership gates", function()
        local Rooms = require(modules["room-orchestrator"])
        local rooms = Rooms.new()
        local config = {minPlayers = 1, intermission = 1, loadTimeout = 5, roundDuration = 10, resultsDuration = 2}
        local function load() return function() end end
        rooms:Add("a", 1, config, load); rooms:Add("b", 1, config, load)
        local p1, p2 = {}, {}
        t.expect.truthy(rooms:Join(p1, "a"))
        t.expect.falsy(rooms:Join(p1, "b"))
        t.expect.falsy(rooms:Join(p2, "a"))
        rooms:Leave(p1); t.expect.truthy(rooms:Join(p2, "a"))
        rooms:Destroy()
    end)
    -- Tagged cosmetics use different enter and exit distances.
    t.test("proximity hysteresis and tag cleanup", function()
        local C = require(modules["proximity-component-culler"])
        local CS = game:GetService("CollectionService")
        local model, part = Instance.new("Model"), Instance.new("Part")
        part.Anchored = true; part.Parent = model; model.Parent = workspace
        model:PivotTo(CFrame.new(0, 1000, 0))
        local active = nil
        CS:AddTag(model, "VaultBackendTestChunk")
        local culler = C.new("VaultBackendTestChunk", 10, 20, function(_, enabled) active = enabled end)
        culler:Step(Vector3.new(0, 1000, 0)); t.expect.truthy(active)
        culler:Step(Vector3.new(15, 1000, 0)); t.expect.truthy(active)
        culler:Step(Vector3.new(21, 1000, 0)); t.expect.falsy(active)
        culler:Destroy(); model:Destroy()
    end)
    -- Progress views create bounded rows and update existing labels instead of duplicates.
    t.test("quest view updates rows and removes stale entries", function()
        local V = require(modules["quest-progress-view"])
        local parent = Instance.new("Folder")
        local view = V.new(parent)
        view:Render({{id = "q", title = "Quest", progress = 1, target = 2, claimed = false}})
        view:Render({{id = "q", title = "Quest", progress = 2, target = 2, claimed = true}})
        local frame = parent:GetChildren()[1]
        local labels = 0
        for _, child in ipairs(frame:GetChildren()) do if child:IsA("TextLabel") then labels += 1 end end
        t.expect.equal(labels, 1)
        view:Render({})
        t.expect.equal(#frame:GetChildren(), 1) -- UIListLayout only
        view:Destroy(); parent:Destroy()
    end)
end
