-- VALORANT HANDS ONLY - iPad/Delta Test V1
local env=(getgenv and getgenv()) or _G
local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not(write and custom)then warn("[VAL HANDS] APIs unavailable")return end
local items={
["12307734932"]={"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-leftV2.obj","val_left.obj"},
["12307583853"]={"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/valorant-rightV2.obj","val_right.obj"},
["144076357"]={"https://raw.githubusercontent.com/engnyg/123f1/refs/heads/main/valorant/arm/FP_Wushu_S0_DF.png","val_hands.png"}
}
local map={}
for id,x in pairs(items)do
 local ok,a=pcall(function()local b=game:HttpGet(x[1]);write(x[2],b);return custom(x[2])end)
 if ok then map[id]=a else warn("[VAL HANDS] download failed "..id)end
 task.wait(.12)
end
local function gid(v)if type(v)~="string"then return end return v:match("rbxassetid://(%d+)")or v:match("[?&]id=(%d+)")or v:match("(%d+)")end
local q,h={},1
local function qp(o,p)local ok,v=pcall(function()return o[p]end);local a=ok and map[gid(v)];if a then q[#q+1]={o,p,a}end end
local function inspect(o)
 if o:IsA("MeshPart")then qp(o,"MeshId");qp(o,"TextureID")
 elseif o:IsA("SpecialMesh")then qp(o,"MeshId");qp(o,"TextureId")
 elseif o:IsA("Texture")or o:IsA("Decal")then qp(o,"Texture")
 elseif o:IsA("ImageLabel")or o:IsA("ImageButton")then qp(o,"Image")end
end
for i,o in ipairs(game:GetDescendants())do inspect(o);if i%250==0 then task.wait()end end
game.DescendantAdded:Connect(function(o)task.defer(function()inspect(o);task.wait(.25);if o.Parent then inspect(o)end;task.wait(.75);if o.Parent then inspect(o)end end)end)
task.spawn(function()while true do local n=0;while h<=#q and n<8 do local x=q[h];h+=1;n+=1;if x[1]and x[1].Parent then pcall(function()x[1][x[2]]=x[3]end)end end;task.wait(.10)end end)
pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="Valorant Hands Test",Text="Hands-only replacement loaded",Duration=6})end)
