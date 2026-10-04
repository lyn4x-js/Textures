-- PSM Sky + Mahiru SFX - iPad/Delta V1
local W,A=writefile,getcustomasset or getsynasset
if not(W and A)then warn("custom asset APIs missing")return end
local function get(n,u)local ok,r=pcall(function()W(n,game:HttpGet(u));return A(n)end);if ok then return r end;warn(r)end
local U={
 ft="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_ft.png",
 lf="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_lf.png",
 rt="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_rt.png",
 dn="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_dn.png",
 bk="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_bk%20(2).png",
 up="https://raw.githubusercontent.com/sukablyst400-eng/fleasion_z7/main/sky512_up.png",
}
local P={bk="SkyboxBk",dn="SkyboxDn",ft="SkyboxFt",lf="SkyboxLf",rt="SkyboxRt",up="SkyboxUp"}
local SA={}
for _,f in ipairs({"bk","dn","ft","lf","rt","up"})do SA[f]=get("psm_"..f..".png",U[f]);task.wait(.12)end
local L=game:GetService("Lighting")
local function sky()
 local x=L:FindFirstChildOfClass("Sky")
 if not x then x=Instance.new("Sky");x.Name="PSMSky";x.Parent=L end
 for f,a in pairs(SA)do if a then pcall(function()x[P[f]]=a end)end end
end
sky();L.ChildAdded:Connect(function(x)if x:IsA("Sky")then task.delay(.2,sky)end end)
task.spawn(function()for _,t in ipairs({.5,1.5,3,6,10})do task.wait(t);sky()end end)

local kill=get("psm_mahiru_kill.mp3","https://raw.githubusercontent.com/crypt0knifer-111/Texture-mahiru/79f7b5e755740e45fa06d37d0e6a223418505d40/a-la-a-la.mp3")
local move=get("psm_mahiru_move.mp3","https://raw.githubusercontent.com/crypt0knifer-111/Mp3-s/4abce95151973a5ba6464d502712e28c980cd5f4/sounder.MP3")
local M={}
if kill then for _,i in ipairs({"16530229616","16530229541","16530229695"})do M[i]=kill end end
if move then for _,i in ipairs({"16737738420","16770456156","16492958314"})do M[i]=move end end
local function id(v)return type(v)=="string"and(v:match("rbxassetid://(%d+)")or v:match("[?&]id=(%d+)")or v:match("(%d+)"))end
local seen=setmetatable({},{__mode="k"})
local function patch(x)
 if not x:IsA("Sound")then return end
 local r=M[id(x.SoundId)];if r then pcall(function()x.SoundId=r end)end
 if not seen[x]then seen[x]=true;x:GetPropertyChangedSignal("SoundId"):Connect(function()
  local q=M[id(x.SoundId)];if q then task.defer(function()if x.Parent then pcall(function()x.SoundId=q end)end end)end
 end)end
end
for i,x in ipairs(game:GetDescendants())do patch(x);if i%300==0 then task.wait()end end
game.DescendantAdded:Connect(function(x)task.defer(function()if x.Parent then patch(x)end end)end)
pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="PSM Sky",Text="Sky + Mahiru SFX loaded",Duration=6})end)
