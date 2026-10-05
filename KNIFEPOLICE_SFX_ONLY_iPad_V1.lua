-- KnifePolice SFX Only - iPad/Delta V1
-- No arena/image/sky texture replacements.
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then
 warn("[KnifePolice SFX] asset APIs missing")
 return
end

local function getid(v)
 if type(v)~="string" then return nil end
 return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local function fetch(name,url)
 local ok,res=pcall(function()
  local body=game:HttpGet(url)
  local clean=url:match("^[^?]+") or url
  local ext=clean:match("%.([%w]+)$") or "dat"
  local fn="kp_sfx_"..name:gsub("[^%w]","_").."."..ext
  write(fn,body)
  return custom(fn)
 end)
 if ok then return res end
 warn("[KnifePolice SFX] "..name.." failed: "..tostring(res))
end

local soundMap={}
local s1=fetch("load in sound","https://files.catbox.moe/ufjhxz.mp3")
if s1 then soundMap["6384899588"]=s1 end
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
local s13=fetch("Profile 35","https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/sparkle.wav")
if s13 then soundMap["16737738420"]=s13 end

local watched=setmetatable({},{__mode="k"})
local function patch(o)
 if not o:IsA("Sound") then return end
 local rep=soundMap[getid(o.SoundId)]
 if rep then pcall(function()o.SoundId=rep end) end

 if not watched[o] then
  watched[o]=true
  o:GetPropertyChangedSignal("SoundId"):Connect(function()
   local r=soundMap[getid(o.SoundId)]
   if r then
    task.defer(function()
     if o.Parent then pcall(function()o.SoundId=r end) end
    end)
   end
  end)
 end
end

for i,o in ipairs(game:GetDescendants()) do
 patch(o)
 if i%300==0 then task.wait() end
end

game.DescendantAdded:Connect(function(o)
 task.defer(function()
  if o.Parent then patch(o) end
 end)
end)

pcall(function()
 game:GetService("StarterGui"):SetCore("SendNotification",{
  Title="KnifePolice SFX",
  Text="SFX-only pack loaded",
  Duration=6
 })
end)

print("[KnifePolice SFX] loaded")
