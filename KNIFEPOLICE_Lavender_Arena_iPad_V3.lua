-- Replace the Arena Textures URL with your own raw GitHub PNG URL before using.
-- KnifePolice Custom - iPad/Delta Adaptive V1
local write=writefile
local custom=getcustomasset or getsynasset
if not(write and custom)then warn("[KnifePolice] asset APIs missing")return end

local function getid(v)
 if type(v)~="string"then return end
 return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local function fetch(name,url)
 local ok,res=pcall(function()
  local body=game:HttpGet(url)
  local ext=url:match("%.([%w]+)") or "dat"
  local fn="kp_"..name:gsub("[^%w]","_").."."..ext
  write(fn,body)
  return custom(fn)
 end)
 if ok then return res end
 warn("[KnifePolice] "..name.." failed: "..tostring(res))
end

local visualMap={}
local soundMap={}

local vArena=fetch("Arena Textures","https://raw.githubusercontent.com/lyn4x-js/Textures/main/lavender_cloud_blossom_tile.png")
if vArena then visualMap["7658055825"]=vArena end
local v1=fetch("Loading Screen 01","https://files.catbox.moe/qslolb.png")
if v1 then visualMap["13854780042"]=v1 end
local v2=fetch("Loading Screen 02","https://files.catbox.moe/jw7nod.png")
if v2 then visualMap["13854780213"]=v2 end
local v3=fetch("Police Loading Screen WM","https://github.com/leitopatatua-lab/echo-imagen-README.md/blob/main/quintillizas_rivals-removebg-preview.png?raw=true")
if v3 then visualMap["85313933907097"]=v3 end
local v4=fetch("Loading Screen Model","https://files.catbox.moe/hhl9tb.png")
if v4 then visualMap["133917828562858"]=v4;visualMap["121503061771505"]=v4 end
local s1=fetch("load in sound","https://files.catbox.moe/ufjhxz.mp3")
if s1 then soundMap["6384899588"]=s1 end
local v5=fetch("curvy Font","https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/Matcha%20Mint.otf")
if v5 then visualMap["12187323909"]=v5;visualMap["12187320363"]=v5;visualMap["12187354260"]=v5;visualMap["12187342816"]=v5;visualMap["12187280273"]=v5;visualMap["12187303601"]=v5;visualMap["12187262242"]=v5;visualMap["12187288714"]=v5;visualMap["12187341500"]=v5;visualMap["12187271237"]=v5;visualMap["12187341020"]=v5 end
local s2=fetch("Kill Sound","https://files.catbox.moe/jdntvt.mp3")
if s2 then soundMap["16530229616"]=s2;soundMap["16530229541"]=s2;soundMap["16530229695"]=s2 end
local s3=fetch("Double Jump Sound","https://files.catbox.moe/0ut9pd.wav")
if s3 then soundMap["16770456156"]=s3 end
local s4=fetch("Weapon Switch Sound","https://files.catbox.moe/tjjhtd.mp3")
if s4 then soundMap["13158734943"]=s4;soundMap["13158735106"]=s4;soundMap["13158735037"]=s4 end
local s5=fetch("Click UI Sound","https://files.catbox.moe/d7x6vx.mp3")
if s5 then soundMap["177266782"]=s5 end
local s6=fetch("Round Loss Sound","https://files.catbox.moe/7b1g1u.mp3")
if s6 then soundMap["17016581922"]=s6 end
local s7=fetch("Matchpoint Sound","https://files.catbox.moe/ipbe38.mp3")
if s7 then soundMap["17026600996"]=s7 end
local s8=fetch("Sudden Death Sound","https://files.catbox.moe/g39j91.mp3")
if s8 then soundMap["17467242617"]=s8 end
local s9=fetch("Lobby Music","https://files.catbox.moe/f8wr4p.mp3")
if s9 then soundMap["17697682466"]=s9;soundMap["17733314783"]=s9;soundMap["120824068504773"]=s9;soundMap["114306049661290"]=s9 end
local s10=fetch("Round Win Sound","https://files.catbox.moe/oid7n6.mp3")
if s10 then soundMap["16810041280"]=s10 end
local s11=fetch("win  theme","https://files.catbox.moe/3nk8yt.mp3")
if s11 then soundMap["18221725850"]=s11;soundMap["18239670056"]=s11;soundMap["18221725850"]=s11;soundMap["18221726246"]=s11 end
local s12=fetch("matchmaking","https://files.catbox.moe/iddabj.mp3")
if s12 then soundMap["18525513345"]=s12 end
local v6=fetch("Fire DMG Indicator","https://files.catbox.moe/b9js2r.png")
if v6 then visualMap["13853836511"]=v6 end
local v7=fetch("Weapon Background","https://files.catbox.moe/ay91xm.png")
if v7 then visualMap["13220167337"]=v7;visualMap["13220167472"]=v7;visualMap["13188242420"]=v7 end
local v8=fetch("Level Icon","https://github.com/leitopatatua-lab/echo-imagen-README.md/blob/main/chibi_headphones-removebg-preview.png?raw=true")
if v8 then visualMap["81461991645938"]=v8 end
local v9=fetch("elim icon","https://github.com/leitopatatua-lab/echo-imagen-README.md/blob/main/image-removebg-preview.png?raw=true")
if v9 then visualMap["16802957270"]=v9 end
local s13=fetch("Profile 35","https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/sparkle.wav")
if s13 then soundMap["16737738420"]=s13 end
local v10=fetch("Profile 35","https://github.com/leitopatatua-lab/echo-imagen-README.md/blob/main/heart.png?raw=true")
if v10 then visualMap["17860673529"]=v10 end
local v11=fetch("Profile 36","https://github.com/leitopatatua-lab/echo-imagen-README.md/blob/main/heart.png?raw=true")
if v11 then visualMap["18175187129"]=v11 end


local queue={}
local head=1
local function inspect(o)
 local prop
 if o:IsA("Texture") or o:IsA("Decal") or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then prop="Texture"
 elseif o:IsA("MeshPart") then prop="TextureID"
 elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then prop="Image" end

 if prop then
  local ok,v=pcall(function()return o[prop]end)
  local rep=ok and visualMap[getid(v)]
  if rep then queue[#queue+1]={o,prop,rep} end
 end

 if o:IsA("Sound") then
  local rep=soundMap[getid(o.SoundId)]
  if rep then pcall(function()o.SoundId=rep end) end
 end
end

task.spawn(function()
 for i,o in ipairs(game:GetDescendants())do
  inspect(o)
  if i%250==0 then task.wait() end
 end
end)

game.DescendantAdded:Connect(function(o)
 task.defer(function()if o.Parent then inspect(o)end end)
end)

task.spawn(function()
 while true do
  local n=0
  while head<=#queue and n<8 do
   local x=queue[head]
   head+=1;n+=1
   if x[1] and x[1].Parent then pcall(function()x[1][x[2]]=x[3]end) end
  end
  task.wait(.10)
 end
end)

pcall(function()
 game:GetService("StarterGui"):SetCore("SendNotification",{Title="KnifePolice",Text="iPad adaptive pack loaded",Duration=6})
end)
