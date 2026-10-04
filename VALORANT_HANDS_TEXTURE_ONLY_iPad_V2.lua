-- VALORANT HANDS TEXTURE ONLY - iPad/Delta V2
-- Keeps original arm meshes and replaces only the arm/hand texture.

local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then
    warn("[VAL HANDS TEX] writefile/getcustomasset unavailable")
    return
end

local URL="https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/FP_Wushu_S0_DF.png"
local TARGET_ID="144076357"

local ok,asset=pcall(function()
    local body=game:HttpGet(URL)
    if type(body)~="string" or #body<4 then error("bad download") end
    write("val_hands_texture.png",body)
    return custom("val_hands_texture.png")
end)

if not ok then
    warn("[VAL HANDS TEX] texture download failed: "..tostring(asset))
    return
end

local function getId(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local queue,head={},1

local function queueProp(obj,prop)
    local ok2,v=pcall(function() return obj[prop] end)
    if not ok2 or type(v)~="string" then return end
    if getId(v)==TARGET_ID then
        queue[#queue+1]={obj,prop,asset}
    end
end

local function inspect(obj)
    if obj:IsA("MeshPart") then
        queueProp(obj,"TextureID")
    elseif obj:IsA("SpecialMesh") then
        queueProp(obj,"TextureId")
    elseif obj:IsA("Texture") or obj:IsA("Decal") then
        queueProp(obj,"Texture")
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        queueProp(obj,"Image")
    end
end

for i,obj in ipairs(game:GetDescendants()) do
    inspect(obj)
    if i%250==0 then task.wait() end
end

game.DescendantAdded:Connect(function(obj)
    task.defer(function()
        inspect(obj)
        task.wait(.25)
        if obj and obj.Parent then inspect(obj) end
        task.wait(.75)
        if obj and obj.Parent then inspect(obj) end
    end)
end)

task.spawn(function()
    while true do
        local n=0
        while head<=#queue and n<8 do
            local item=queue[head]
            head+=1
            n+=1
            if item[1] and item[1].Parent then
                pcall(function() item[1][item[2]]=item[3] end)
            end
        end
        task.wait(.10)
    end
end)

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Valorant Hands Texture",
        Text="Original hand meshes kept; texture replacement loaded",
        Duration=6
    })
end)
