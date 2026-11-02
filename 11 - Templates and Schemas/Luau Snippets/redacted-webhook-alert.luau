--!nocheck
-- Untested: delivery; module loaded in Studio. Endpoint comes from private server configuration.
-- Use an approved HTTPS relay when direct webhook requests are unavailable.
local HttpService = game:GetService("HttpService")
return function(endpoint, minimumInterval)
    assert(type(endpoint) == "string" and string.sub(endpoint, 1, 8) == "https://", "https_required")
    local nextAllowed = 0
    return function(alert)
        local now = os.clock()
        if now < nextAllowed then return end
        nextAllowed = now + (minimumInterval or 30)
        local ok, response = pcall(function()
            return HttpService:RequestAsync({
                Url = endpoint, Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    content = "Data integrity lock: " .. string.sub(tostring(alert.reason), 1, 120),
                    allowed_mentions = {parse = {}},
                }),
            })
        end)
        if not ok or not response.Success then warn("Integrity alert delivery failed") end
        -- Never print request errors/URLs: a webhook URL can contain a credential.
    end
end
