-- PASHA'S TEXTURES - iPad/Delta Adaptive V1
local URL="https://raw.githubusercontent.com/pashagamer23221-spec/texture/main/texture.png"
local IDS={["7658055825"]=true}
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then warn("[PASHA] file/custom asset APIs unavailable"); return end

local ok,asset=pcall(function()
 local body=game:HttpGet(URL)
 write("pasha_texture.png",body)
 return custom("pasha_texture.png")
end)
if not ok then warn("[PASHA] texture download failed: "..tostring(asset)); return end

local function getid(v)
 if type(v)~="string" then return nil end
 return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end
local queue,head={},1
local function qp(o,p)
 local ok2,v=pcall(function() return o[p] end)
 local id=ok2 and getid(v)
 if id and IDS[id] then queue[#queue+1]={o,p,asset} end
end
local function inspect(o)
 if o:IsA("Texture") or o:IsA("Decal") then qp(o,"Texture")
 elseif o:IsA("MeshPart") then qp(o,"TextureID")
 elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then qp(o,"Image")
 elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then qp(o,"Texture")
 end
end

for i,o in ipairs(game:GetDescendants()) do inspect(o); if i%250==0 then task.wait() end end
game.DescendantAdded:Connect(function(o) task.defer(function() inspect(o); task.wait(.25); if o.Parent then inspect(o) end end) end)

task.spawn(function()
 while true do
  local n=0
  while head<=#queue and n<8 do
   local x=queue[head]; head+=1; n+=1
   if x[1] and x[1].Parent then pcall(function() x[1][x[2]]=x[3] end) end
  end
  task.wait(.10)
 end
end)

pcall(function()
 game:GetService("StarterGui"):SetCore("SendNotification",{Title="Pasha's Textures",Text="Texture loaded",Duration=5})
end)
