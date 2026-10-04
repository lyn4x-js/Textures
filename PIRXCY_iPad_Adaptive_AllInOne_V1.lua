-- PIRXCY TEXTURES - iPad/Delta Adaptive All-In-One V1
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then warn("[PIRXCY] file/custom asset APIs unavailable"); return end
local KEY="__PIRXCY_IPAD_V1"
if env[KEY] and env[KEY].connections then for _,c in ipairs(env[KEY].connections) do pcall(function() c:Disconnect() end) end end
local state={connections={},running=true,watched=setmetatable({}, {__mode="k"})}; env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end
local Rules={
{name="arena textures",mode="cdn",file="pirxcy_01.png",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/Screenshot_2026-09-12_215035-removebg-preview.png",ids={7658055825}},
{name="sudden death dun dun dun",mode="cdn",file="pirxcy_02.mp3",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/dun_dun_dun.mp3",ids={17467242617}},
{name="load in sound",mode="cdn",file="pirxcy_03.mp3",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/creepy-laughing-one.mp3",ids={6384899588}},
{name="font",mode="cdn",file="pirxcy_04.otf",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/minecraftfont.otf",ids={12187323909, 12187323909, 12187320363, 12187354260, 12187342816, 12187280273, 12187303601, 12187262242, 12187288714, 12187341500, 12187271237, 12187341020}},
{name="skybox.bk",mode="cdn",file="pirxcy_05.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_bk.tex",ids={2108482005, 14147881792, 135908632589654, 84214501374682, 10196550937, 12261809766}},
{name="skybox.dn",mode="cdn",file="pirxcy_06.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_dn.tex",ids={2108545280, 10196550667, 14147882149, 103020541883227, 89972436184102, 12261813110}},
{name="skybox.ft",mode="cdn",file="pirxcy_07.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_ft.tex",ids={14147882761, 12261809766, 135908632589654, 84214501374682, 10196550367, 2108482231}},
{name="skybox.lf",mode="cdn",file="pirxcy_08.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_lf.tex",ids={14147883091, 135908632589654, 84214501374682, 2108482395, 12261809766, 10196550128}},
{name="skybox.rt",mode="cdn",file="pirxcy_09.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_rt.tex",ids={14147882405, 135908632589654, 84214501374682, 2108482542, 12261809766, 10196549902}},
{name="skybox.up",mode="cdn",file="pirxcy_10.tex",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/sky512_up.tex",ids={14147881297, 72960281658487, 92138082970751, 2108482676, 10196567794, 12261813678}},
{name="kill sounds",mode="cdn",file="pirxcy_11.mp3",url="https://raw.githubusercontent.com/ohbo921yt/ohbo921onyt/refs/heads/main/saataa-andagii-osaka.mp3",ids={16530229616, 16530229541, 16530229695}},
{name="body + head hit",mode="id",value="rbxassetid://86855123090967",ids={13110130082, 16537337310, 16537449730}}
}
local map={}
for i,r in ipairs(Rules) do
 local asset=r.value
 if r.mode=="cdn" then
  local ok,res=pcall(function() local b=game:HttpGet(r.url); write(r.file,b); return custom(r.file) end)
  if ok then asset=res else warn("[PIRXCY] failed "..r.name..": "..tostring(res)) end
 end
 if asset then for _,id in ipairs(r.ids) do map[tostring(id)]=asset end end
 if i%3==0 then task.wait(.12) end
end
local function id(v) if type(v)~="string" then return end return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)") end
local function repl(v) local n=id(v); return n and map[n] end
local q,h={},1
local function qp(o,p) local ok,v=pcall(function() return o[p] end); local n=ok and repl(v); if n and n~=v then q[#q+1]={o,p,n} end end
local props={ImageLabel={"Image"},ImageButton={"Image"},Decal={"Texture"},Texture={"Texture"},MeshPart={"TextureID"},SpecialMesh={"TextureId","MeshId"},ParticleEmitter={"Texture"},Trail={"Texture"},Beam={"Texture"},Sky={"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp"}}
local function inspect(o)
 if o:IsA("Sound") then
  local function apply() if not o or not o.Parent then return end; local ok,v=pcall(function() return o.SoundId end); local n=ok and repl(v); if n and n~=v then pcall(function() o.SoundId=n end) end end
  apply()
  if not state.watched[o] then
   state.watched[o]=true
   local ok,c=pcall(function() return o:GetPropertyChangedSignal("SoundId"):Connect(function() task.defer(apply) end) end); if ok then keep(c) end
   task.spawn(function() for _,d in ipairs({.15,.5,1.2,2.5,5}) do task.wait(d); if env[KEY]~=state then return end; apply() end end)
  end
  return
 end
 for class,ps in pairs(props) do if o:IsA(class) then for _,p in ipairs(ps) do qp(o,p) end; break end end
 if o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox") then pcall(function() local f=o.FontFace; local n=repl(f.Family); if n then o.FontFace=Font.new(n,f.Weight,f.Style) end end) end
end
for i,o in ipairs(game:GetDescendants()) do inspect(o); if i%250==0 then task.wait() end end
keep(game.DescendantAdded:Connect(function(o) task.defer(function() inspect(o); task.wait(.25); if o and o.Parent then inspect(o) end end) end))
task.spawn(function() while state.running and env[KEY]==state do local n=0; while h<=#q and n<8 do local x=q[h]; h+=1; n+=1; if x[1] and x[1].Parent then pcall(function() x[1][x[2]]=x[3] end) end end; task.wait(.10) end end)
pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="PIRXCY",Text="Textures + sky + SFX loaded",Duration=6}) end)
