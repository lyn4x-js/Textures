-- KnifePolice Arena ID Finder - iPad/Delta
-- Run this inside the arena. It collects texture IDs used by workspace objects.

local function getid(v)
    if type(v)~="string" then return nil end
    return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local found={}
local function add(obj,prop)
    local ok,v=pcall(function() return obj[prop] end)
    if not ok then return end
    local id=getid(v)
    if not id then return end
    local e=found[id]
    if not e then
        e={count=0,samples={}}
        found[id]=e
    end
    e.count+=1
    if #e.samples<3 then
        e.samples[#e.samples+1]=obj:GetFullName().." ["..prop.."]"
    end
end

for i,obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("Texture") or obj:IsA("Decal") then
        add(obj,"Texture")
    elseif obj:IsA("MeshPart") then
        add(obj,"TextureID")
    end
    if i%300==0 then task.wait() end
end

local rows={}
for id,e in pairs(found) do
    rows[#rows+1]={id=id,count=e.count,samples=e.samples}
end
table.sort(rows,function(a,b) return a.count>b.count end)

local lines={"=== ARENA TEXTURE IDS ==="}
for i=1,math.min(#rows,40) do
    local r=rows[i]
    lines[#lines+1]=("#%d  ID %s  count=%d"):format(i,r.id,r.count)
    for _,s in ipairs(r.samples) do lines[#lines+1]="  "..s end
end

local text=table.concat(lines,"\n")
print(text)

if setclipboard then pcall(function() setclipboard(text) end) end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title="Arena ID Finder",
        Text="Done. Open >_ console. Results copied if clipboard is supported.",
        Duration=8
    })
end)
