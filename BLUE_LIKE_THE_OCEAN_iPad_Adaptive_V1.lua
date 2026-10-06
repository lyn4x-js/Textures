-- BLUE LIKE THE OCEAN - iPad / Delta adaptive pack
-- Generated from uploaded JSON
local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")
local getasset = getcustomasset or getsynasset
if not writefile or not getasset then warn("[Ocean] Missing writefile/getcustomasset") return end

local function rid(v) return tostring(v or ""):match("(%d+)") end
local function fetch(url,file)
  local ok,data=pcall(function() return game:HttpGet(url) end)
  if not ok or type(data)~="string" or #data<20 then return nil end
  if not pcall(function() writefile(file,data) end) then return nil end
  local aok,a=pcall(function() return getasset(file) end)
  if aok then return a end
end

local replacements = {}
local a1=fetch("https://files.catbox.moe/p5gctx.png","ocean_1.png")
if a1 then
  replacements["133917828562858"]=a1
  replacements["121503061771505"]=a1
end
local a2=fetch("https://files.catbox.moe/7kg09i.png","ocean_2.png")
if a2 then
  replacements["16802957270"]=a2
end
local a3=fetch("https://files.catbox.moe/wsi3i5.otf","ocean_3.otf")
if a3 then
  replacements["12187323909"]=a3
  replacements["12187323909"]=a3
  replacements["12187320363"]=a3
  replacements["12187354260"]=a3
  replacements["12187342816"]=a3
  replacements["12187280273"]=a3
  replacements["12187303601"]=a3
  replacements["12187262242"]=a3
  replacements["12187288714"]=a3
  replacements["12187341500"]=a3
  replacements["12187271237"]=a3
  replacements["12187341020"]=a3
end
local a4=fetch("https://files.catbox.moe/waok98.png","ocean_4.png")
if a4 then
  replacements["7658055825"]=a4
end
local a5=fetch("https://files.catbox.moe/ljyeby.png","ocean_5.png")
if a5 then
  replacements["106623367501544"]=a5
  replacements["131795064007344"]=a5
  replacements["73543520622815"]=a5
end
local a6=fetch("https://files.catbox.moe/9cmcjo.png","ocean_6.png")
if a6 then
  replacements["80716950169934"]=a6
  replacements["136100661820261"]=a6
  replacements["107898816876115"]=a6
end
local a7=fetch("https://files.catbox.moe/h37gqg.png","ocean_7.png")
if a7 then
  replacements["134520747948636"]=a7
  replacements["114166096331502"]=a7
  replacements["90039594400813"]=a7
end
local a8=fetch("https://files.catbox.moe/9k8jsx.png","ocean_8.png")
if a8 then
  replacements["133903971285645"]=a8
  replacements["82834564754747"]=a8
  replacements["73345783863790"]=a8
end
local a9=fetch("https://files.catbox.moe/iapbog.png","ocean_9.png")
if a9 then
  replacements["113997689031026"]=a9
  replacements["88059506918419"]=a9
  replacements["112183171942172"]=a9
end
local a10=fetch("https://files.catbox.moe/jkd3k2.png","ocean_10.png")
if a10 then
  replacements["104871954739030"]=a10
  replacements["109012386782238"]=a10
  replacements["127982903682334"]=a10
end
local a11=fetch("https://files.catbox.moe/4eo69y.png","ocean_11.png")
if a11 then
  replacements["116941545385923"]=a11
end
local a12=fetch("https://files.catbox.moe/z9mzj8.png","ocean_12.png")
if a12 then
  replacements["133793956251748"]=a12
end
local a13=fetch("https://files.catbox.moe/oovg4o.png","ocean_13.png")
if a13 then
  replacements["13854780042"]=a13
end
local a14=fetch("https://files.catbox.moe/33haiw.png","ocean_14.png")
if a14 then
  replacements["13854780213"]=a14
end
local a15=fetch("https://files.catbox.moe/n96ylm.png","ocean_15.png")
if a15 then
  replacements["17175092502"]=a15
  replacements["17094014569"]=a15
end

local directIds = {
  ["17697682466"]="rbxassetid://100081814360953",
  ["17733314783"]="rbxassetid://100081814360953",
}

local queue,head={},1
local function enqueue(o,p,newv) queue[#queue+1]={o,p,newv} end
local function inspect(o)
  local props={}
  if o:IsA("Texture") or o:IsA("Decal") then props={"Texture"}
  elseif o:IsA("MeshPart") then props={"TextureID"}
  elseif o:IsA("ImageLabel") or o:IsA("ImageButton") then props={"Image"}
  elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Beam") then props={"Texture"}
  elseif o:IsA("Sound") then props={"SoundId"} end
  for _,p in ipairs(props) do
    local ok,v=pcall(function() return o[p] end)
    if ok then local k=rid(v); local n=k and (replacements[k] or directIds[k]); if n then enqueue(o,p,n) end end
  end
end

for i,o in ipairs(game:GetDescendants()) do pcall(inspect,o); if i%250==0 then task.wait() end end
game.DescendantAdded:Connect(function(o) task.defer(function() pcall(inspect,o) end) end)
task.spawn(function() while true do local n=0; while head<=#queue and n<8 do local it=queue[head]; head+=1; n+=1; if it[1] and it[1].Parent then pcall(function() it[1][it[2]]=it[3] end) end end; task.wait(.10) end end)

local snd1=fetch("https://files.catbox.moe/ub7f65.mp3","ocean_sound_1.mp3")
local sndids1={
 ["16530229616"]=true,
 ["16530229541"]=true,
 ["16530229695"]=true,
}
if snd1 then
 local function ps(s)
  if not s:IsA("Sound") then return end
  if sndids1[rid(s.SoundId)] then pcall(function() s.SoundId=snd1 end) end
 end
 for _,s in ipairs(game:GetDescendants()) do pcall(ps,s) end
 game.DescendantAdded:Connect(function(s) task.defer(function() pcall(ps,s) end) end)
end

-- Six-face sky
local sky_bk=fetch("https://files.catbox.moe/qkq4l5.tex","ocean_sky_bk.tex")
local sky_dn=fetch("https://files.catbox.moe/b7jt17.tex","ocean_sky_dn.tex")
local sky_ft=fetch("https://files.catbox.moe/m1pkri.tex","ocean_sky_ft.tex")
local sky_lf=fetch("https://files.catbox.moe/0bijwb.tex","ocean_sky_lf.tex")
local sky_rt=fetch("https://files.catbox.moe/krfi08.tex","ocean_sky_rt.tex")
local sky_up=fetch("https://files.catbox.moe/tj733n.tex","ocean_sky_up.tex")
if sky_bk and sky_dn and sky_ft and sky_lf and sky_rt and sky_up then
 local sk=Lighting:FindFirstChild("BlueOceanSky") or Instance.new("Sky")
 sk.Name="BlueOceanSky"; sk.Parent=Lighting
 local function applySky()
  pcall(function() sk.SkyboxBk=sky_bk; sk.SkyboxDn=sky_dn; sk.SkyboxFt=sky_ft; sk.SkyboxLf=sky_lf; sk.SkyboxRt=sky_rt; sk.SkyboxUp=sky_up end)
 end
 applySky()
 for _,d in ipairs({.5,1.5,3,6,10}) do task.delay(d,applySky) end
end

pcall(function() StarterGui:SetCore("SendNotification",{Title="Blue Like The Ocean",Text="Pack loaded",Duration=6}) end)