--!nocheck
-- Local Studio test runner adapted from Roblox rbx-unit-test skill.
-- Place at ServerStorage.UnitTest.RunUnitTest with Cases and Modules folders.
local function runOne(fn, timeout)
    local done, ok, reason = false, false, nil
    local thread = task.spawn(function() ok, reason = pcall(fn); done = true end)
    local waited = 0
    while not done and waited < timeout do waited += task.wait() end
    if not done then task.cancel(thread); return false, "timeout" end
    return ok, reason
end
return function(filter, timeout)
    local totals = {run = 0, passed = 0, failed = 0}
    local cases = script.Parent.Cases:GetChildren()
    table.sort(cases, function(a, b) return a.Name < b.Name end)
    local t = {expect = {}}
    function t.expect.equal(actual, expected) assert(actual == expected, "expected " .. tostring(expected) .. ", got " .. tostring(actual)) end
    function t.expect.truthy(value) assert(value, "expected truthy") end
    function t.expect.falsy(value) assert(not value, "expected falsy") end
    function t.expect.near(actual, expected, tolerance) assert(math.abs(actual - expected) <= (tolerance or 1e-6), "not near") end
    function t.expect.throws(fn) assert(not pcall(fn), "expected throw") end
    function t.test(name, fn)
        totals.run += 1
        local ok, reason = runOne(fn, timeout or 5)
        if ok then totals.passed += 1; print("[PASS] " .. name)
        else totals.failed += 1; warn("[FAIL] " .. name .. " | " .. tostring(reason)) end
    end
    for _, module in ipairs(cases) do
        if module:IsA("ModuleScript") and (not filter or string.find(module.Name, filter, 1, true)) then
            local ok, reason = pcall(function() require(module)(t) end)
            if not ok then
                totals.run += 1; totals.failed += 1
                warn("[FAIL] case load " .. module.Name .. " | " .. tostring(reason))
            end
        end
    end
    print(string.format("[SUMMARY] %d run, %d passed, %d failed", totals.run, totals.passed, totals.failed))
    return totals
end
