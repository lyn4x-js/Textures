-- Alya Textures + Rat Sky + KnifePolice SFX - iPad/Delta V1

local function run(url,name)
 local ok,err=pcall(function()
  loadstring(game:HttpGet(url))()
 end)
 if not ok then warn("["..name.."] failed: "..tostring(err)) end
end

run("https://raw.githubusercontent.com/lyn4x-js/I-pad-ez/main/Alya_iPad_Adaptive_Standalone_V1.lua","Alya Textures")
task.wait(0.5)
run("https://raw.githubusercontent.com/lyn4x-js/Textures/main/RAT_SKY_AllInOne_iPad_V1.lua","Rat Sky")
task.wait(0.5)
run("https://raw.githubusercontent.com/lyn4x-js/Textures/main/KNIFEPOLICE_SFX_ONLY_iPad_V1.lua","KnifePolice SFX")

pcall(function()
 game:GetService("StarterGui"):SetCore("SendNotification",{
  Title="Alya + Rat + KnifePolice",
  Text="Textures + sky + SFX loaded",
  Duration=6
 })
end)
