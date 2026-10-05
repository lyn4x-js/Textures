-- KnifePolice Lavender Arena + SFX - iPad/Delta V7 (Pasha Method)
local URL="https://raw.githubusercontent.com/lyn4x-js/Textures/main/lavender_cloud_blossom_tile_1024.png"
local IDS={["7658055825"]=true}
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then warn("[KNIFEPOLICE] file/custom asset APIs unavailable"); return end

local ok,asset=pcall(function()
 local body=game:HttpGet(URL)
 write("knifepolice_lavender_1024.png",body)
 return custom("knifepolice_lavender_1024.png")
end)
if not ok then warn("[KNIFEPOLICE] texture download failed: "..tostring(asset)); return end

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
 game:GetService("StarterGui"):SetCore("SendNotification",{Title="KnifePolice V7",Text="Lavender arena + SFX loaded",Duration=5})
end)


-- KnifePolice SFX
local function addSound(file,url,ids)
 local ok,a=pcall(function()
  local body=game:HttpGet(url)
  write(file,body)
  return custom(file)
 end)
 if not ok then warn("[KNIFEPOLICE SFX] "..tostring(a)); return end

 local map={}
 for _,id in ipairs(ids) do map[tostring(id)]=true end

 local function sid(v)
  if type(v)~="string" then return nil end
  return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
 end

 local seen=setmetatable({},{__mode="k"})
 local function patch(o)
  if not o:IsA("Sound") then return end
  if map[sid(o.SoundId)] then pcall(function() o.SoundId=a end) end
  if not seen[o] then
   seen[o]=true
   o:GetPropertyChangedSignal("SoundId"):Connect(function()
    if map[sid(o.SoundId)] then
     task.defer(function()
      if o.Parent then pcall(function() o.SoundId=a end) end
     end)
    end
   end)
  end
 end

 for i,o in ipairs(game:GetDescendants()) do patch(o); if i%400==0 then task.wait() end end
 game.DescendantAdded:Connect(function(o) task.defer(function() if o.Parent then patch(o) end end) end)
end

task.spawn(function()
 addSound("kp_loadin.mp3","https://files.catbox.moe/ufjhxz.mp3",{6384899588})
 addSound("kp_kill.mp3","https://files.catbox.moe/jdntvt.mp3",{16530229616,16530229541,16530229695})
 addSound("kp_doublejump.wav","https://files.catbox.moe/0ut9pd.wav",{16770456156})
 addSound("kp_weaponswitch.mp3","https://files.catbox.moe/tjjhtd.mp3",{13158734943,13158735106,13158735037})
 addSound("kp_click.mp3","https://files.catbox.moe/d7x6vx.mp3",{177266782})
 addSound("kp_roundloss.mp3","https://files.catbox.moe/7b1g1u.mp3",{17016581922})
 addSound("kp_matchpoint.mp3","https://files.catbox.moe/ipbe38.mp3",{17026600996})
 addSound("kp_suddendeath.mp3","https://files.catbox.moe/g39j91.mp3",{17467242617})
 addSound("kp_lobby.mp3","https://files.catbox.moe/f8wr4p.mp3",{17697682466,17733314783,120824068504773,114306049661290})
 addSound("kp_roundwin.mp3","https://files.catbox.moe/oid7n6.mp3",{16810041280})
 addSound("kp_wintheme.mp3","https://files.catbox.moe/3nk8yt.mp3",{18221725850,18239670056,18221726246})
 addSound("kp_matchmaking.mp3","https://files.catbox.moe/iddabj.mp3",{18525513345})
 addSound("kp_slide.wav","https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/sparkle.wav",{16737738420})
end)
