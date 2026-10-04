-- Pearlescent iPad/Delta Adaptive V1
-- Built from the supplied Pearlscent JSON. Normal pack: textures/UI/SFX/font mappings; no forced custom sky.

local env=(getgenv and getgenv()) or _G
local KEY="__PEARLESCENT_IPAD_ADAPTIVE_V1"
if env[KEY] and env[KEY].connections then
 for _,c in ipairs(env[KEY].connections) do pcall(function()c:Disconnect()end) end
end
local state={connections={},queued=setmetatable({},{__mode="k"})}
env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local write=writefile
local custom=getcustomasset or getsynasset
if not(write and custom) then warn("[Pearlescent] asset APIs missing") return end

local function fetch(file,url)
 local ok,res=pcall(function()
  local body=game:HttpGet(url)
  if type(body)~="string" or #body<20 then error("bad download "..file) end
  write(file,body)
  return custom(file)
 end)
 if not ok then warn("[Pearlescent] "..tostring(res));return nil end
 return res
end

local main=fetch("pearlescent_main.png","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/blob/main/fcc06bbf-0829-4e29-80ac-661bcbb57a22-removebg-preview.png?raw=true")
local item=fetch("pearlescent_item.png","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/blob/main/IMG_4989.PNG?raw=true")
local fontAsset=fetch("pearlescent_font.ttf","https://raw.githubusercontent.com/prism658/Resources-fleasion/main/Garet-Book.ttf")

local function getId(v)
 if type(v)~="string" then return nil end
 return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local mainIds={["7658055825"]=true}
local itemIds={["13220167337"]=true,["13188242420"]=true,["13220167472"]=true,["13188153054"]=true,["13188242287"]=true}
local headIds={["16537337310"]=true,["16537449730"]=true}
local fontIds={["12187323909"]=true,["12187320363"]=true,["12187354260"]=true,["12187342816"]=true,["12187280273"]=true,["12187303601"]=true,["12187262242"]=true,["12187288714"]=true,["12187341500"]=true,["12187271237"]=true,["12187341020"]=true}

local queue={}
local head=1
local function enqueue(o,p,repl)
 if not o or not o.Parent or not repl then return end
 local key=tostring(o).."|"..p
 if state.queued[key] then return end
 state.queued[key]=true
 queue[#queue+1]={o,p,repl}
end

local function inspect(o)
 local prop
 if o:IsA("Texture") or o:IsA("Decal") or o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then prop="Texture"
 elseif o:IsA("MeshPart") then prop="TextureID"
 elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then prop="Image" end
 if prop then
  local ok,v=pcall(function()return o[prop]end)
  local id=ok and getId(v)
  if id then
   if mainIds[id] and main then enqueue(o,prop,main)
   elseif itemIds[id] and item then enqueue(o,prop,item)
   elseif headIds[id] then enqueue(o,prop,"rbxassetid://70643163489676") end
  end
 end
 -- Font replacement where executor supports custom FontFace assets
 if fontAsset and (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) then
  local ok,v=pcall(function()return tostring(o.FontFace)end)
  local id=ok and getId(v)
  if id and fontIds[id] then
   pcall(function()o.FontFace=Font.new(fontAsset)end)
  end
 end
end

local soundMap={}
local snd1=fetch("pearlescent_sfx_1.ogg","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/raw/refs/heads/main/bell%20ding%20sfx.ogg")
if snd1 then soundMap["16770456156"]=snd1 end
local snd2=fetch("pearlescent_sfx_2.ogg","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/raw/refs/heads/main/bell%20ding%20sfx.ogg")
if snd2 then soundMap["16492958314"]=snd2 end
local snd3=fetch("pearlescent_sfx_3.wav","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/raw/refs/heads/main/sparkle.wav")
if snd3 then soundMap["16737738420"]=snd3 end
local snd4=fetch("pearlescent_sfx_4.mp3","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/raw/refs/heads/main/universfield-water-drop-131023.mp3")
if snd4 then soundMap["177266782"]=snd4 end
local snd5=fetch("pearlescent_sfx_5.mp3","https://github.com/H4rb0r-rbx/Fleasion-pearlscent-textures/raw/refs/heads/main/benkirb-shine-1-268902.mp3")
if snd5 then soundMap["16530229616"]=snd5;soundMap["16530229541"]=snd5;soundMap["16530229695"]=snd5 end

local function patchSound(o)
 if not o:IsA("Sound") then return end
 local id=getId(o.SoundId)
 local r=id and soundMap[id]
 if r then pcall(function()o.SoundId=r end) end
end

task.spawn(function()
 local all=game:GetDescendants()
 for i,o in ipairs(all) do
  inspect(o);patchSound(o)
  if i%250==0 then task.wait() end
 end
end)

keep(game.DescendantAdded:Connect(function(o)
 task.defer(function()
  if env[KEY]~=state or not o.Parent then return end
  inspect(o);patchSound(o)
 end)
end))

task.spawn(function()
 while env[KEY]==state do
  local n=0
  while head<=#queue and n<8 do
   local x=queue[head];head+=1;n+=1
   local o,p,r=x[1],x[2],x[3]
   if o and o.Parent then pcall(function()o[p]=r end) end
  end
  if head>1000 then
   local nq={}
   for i=head,#queue do nq[#nq+1]=queue[i] end
   queue=nq;head=1
  end
  task.wait(.10)
 end
end)

pcall(function()
 game:GetService("StarterGui"):SetCore("SendNotification",{
  Title="Pearlescent iPad",Text="Adaptive Pearlescent pack loaded",Duration=6
 })
end)
print("[Pearlescent iPad] loaded")
