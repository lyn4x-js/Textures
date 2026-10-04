-- COOL BLACK SKY - iPad / Delta Standalone V1
-- Built directly from cool black sky.json

local TARGET = "rbxassetid://7658055825"
local IDS = {
    ["2108482005"] = true,
    ["14147881792"] = true,
    ["135908632589654"] = true,
    ["84214501374682"] = true,
    ["10196550937"] = true,
    ["12261809766"] = true,
    ["2108545280"] = true,
    ["10196550667"] = true,
    ["14147882149"] = true,
    ["103020541883227"] = true,
    ["89972436184102"] = true,
    ["12261813110"] = true,
    ["14147882761"] = true,
    ["12261809766"] = true,
    ["135908632589654"] = true,
    ["84214501374682"] = true,
    ["10196550367"] = true,
    ["2108482231"] = true,
    ["14147883091"] = true,
    ["135908632589654"] = true,
    ["84214501374682"] = true,
    ["2108482395"] = true,
    ["12261809766"] = true,
    ["10196550128"] = true,
    ["14147882405"] = true,
    ["135908632589654"] = true,
    ["84214501374682"] = true,
    ["2108482542"] = true,
    ["12261809766"] = true,
    ["10196549902"] = true,
    ["14147881297"] = true,
    ["72960281658487"] = true,
    ["92138082970751"] = true,
    ["2108482676"] = true,
    ["10196567794"] = true,
    ["12261813678"] = true,
}

local PROPS = {"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}

local function getId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)")
        or v:match("[?&]id=(%d+)")
        or v:match("(%d+)")
end

local function apply(sky)
    if not sky:IsA("Sky") then return end
    for _,prop in ipairs(PROPS) do
        pcall(function()
            local id=getId(sky[prop])
            if id and IDS[id] then
                sky[prop]=TARGET
            end
        end)
    end
end

local Lighting=game:GetService("Lighting")

for _,obj in ipairs(Lighting:GetChildren()) do
    apply(obj)
end

Lighting.ChildAdded:Connect(function(obj)
    if obj:IsA("Sky") then
        task.defer(function()
            apply(obj)
            task.wait(0.25)
            if obj.Parent then apply(obj) end
        end)
    end
end)

-- RIVALS may configure/replace its sky shortly after loading.
task.spawn(function()
    for _,delayTime in ipairs({0.5,1,2,4,7}) do
        task.wait(delayTime)
        for _,obj in ipairs(Lighting:GetChildren()) do
            apply(obj)
        end
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Cool Black Sky",
        Text="Sky replacement loaded",
        Duration=5
    })
end)
