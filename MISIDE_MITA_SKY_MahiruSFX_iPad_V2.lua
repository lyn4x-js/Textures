-- MiSide Mita Sky + Mahiru SFX + Mahiru SFX - iPad/Delta
local env = (getgenv and getgenv()) or _G
local KEY = "__MITA_SKY_MAHIRU_SFX_V2"

if env[KEY] and env[KEY].connections then
    for _,c in ipairs(env[KEY].connections) do
        pcall(function() c:Disconnect() end)
    end
end

local state = {connections={}}
env[KEY] = state
local function keep(c)
    if c then table.insert(state.connections,c) end
end

-- Load existing sky pack
local okSky, errSky = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/lyn4x-js/Textures/main/MISIDE_MITA_SKY_AllInOne_iPad_V1.lua"))()
end)
if not okSky then
    warn("[MiSide Mita Sky + Mahiru SFX] sky load failed: "..tostring(errSky))
end

local write = writefile
local custom = getcustomasset or getsynasset
if not (write and custom) then
    warn("[MiSide Mita Sky + Mahiru SFX] writefile/getcustomasset missing")
    return
end

local function validMp3(body)
    return type(body) == "string" and #body > 3 and
        (body:sub(1,3) == "ID3" or body:byte(1) == 255)
end

local function fetch(file, url)
    local ok, result = pcall(function()
        local body = game:HttpGet(url)
        if not validMp3(body) then error("bad mp3 download") end
        write(file, body)
        local asset = custom(file)
        if type(asset) ~= "string" or asset == "" then
            error("custom asset failed")
        end
        return asset
    end)
    if not ok then
        warn("[MiSide Mita Sky + Mahiru SFX] "..tostring(result))
        return nil
    end
    return result
end

-- Exact Mahiru SFX from the working Mahiru pack
local kill = fetch(
    "mahiru_combo_kill.mp3",
    "https://raw.githubusercontent.com/crypt0knifer-111/Texture-mahiru/79f7b5e755740e45fa06d37d0e6a223418505d40/a-la-a-la.mp3"
)

local move = fetch(
    "mahiru_combo_move.mp3",
    "https://raw.githubusercontent.com/crypt0knifer-111/Mp3-s/4abce95151973a5ba6464d502712e28c980cd5f4/sounder.MP3"
)

local function getId(v)
    if type(v) ~= "string" then return nil end
    return v:match("rbxassetid://(%d+)") or
           v:match("[?&]id=(%d+)") or
           v:match("(%d+)")
end

local soundMap = {}

if kill then
    soundMap["16530229616"] = kill
    soundMap["16530229541"] = kill
    soundMap["16530229695"] = kill
end

if move then
    soundMap["16737738420"] = move
    soundMap["16770456156"] = move
    soundMap["16492958314"] = move
end

local function patchSound(obj)
    if not obj:IsA("Sound") then return end
    local ok, id = pcall(function()
        return getId(obj.SoundId)
    end)
    local replacement = ok and soundMap[id] or nil
    if replacement then
        pcall(function()
            obj.SoundId = replacement
        end)
    end
end

for i,obj in ipairs(game:GetDescendants()) do
    patchSound(obj)
    if i % 500 == 0 then task.wait() end
end

keep(game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        if env[KEY] ~= state or not obj.Parent then return end
        patchSound(obj)
    end)
end))

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "MiSide Mita Sky + Mahiru SFX",
        Text = "Sky + Mahiru SFX loaded",
        Duration = 6
    })
end)

print("[MiSide Mita Sky + Mahiru SFX] loaded")
