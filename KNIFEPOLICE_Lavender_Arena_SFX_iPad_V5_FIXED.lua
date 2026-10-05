-- KnifePolice Lavender Arena + SFX - iPad/Delta V5 FIXED
-- Uses the same paced arena replacement method as the known-working iPad texture packs.

local env=(getgenv and getgenv()) or _G
local KEY="__KNIFEPOLICE_V5_FIXED"

if env[KEY] and env[KEY].connections then
	for _,c in ipairs(env[KEY].connections) do pcall(function() c:Disconnect() end) end
end

local state={connections={},queued=setmetatable({},{__mode="k"})}
env[KEY]=state
local function keep(c) if c then table.insert(state.connections,c) end end

local write=rawget(env,"writefile") or writefile
local custom=rawget(env,"getcustomasset") or getcustomasset or getsynasset
if not (write and custom) then
	warn("[KnifePolice V5] writefile/getcustomasset missing")
	return
end

local function valid(body,ext)
	if type(body)~="string" then return false end
	if ext==".png" then
		return #body>=8 and body:sub(1,8)=="\137PNG\r\n\26\n"
	end
	return #body>40
end

local function fetch(file,url,ext)
	local ok,res=pcall(function()
		local body=game:HttpGet(url)
		if not valid(body,ext) then error("bad download: "..file) end
		write(file,body)
		local a=custom(file)
		if type(a)~="string" or a=="" then error("custom asset failed: "..file) end
		return a
	end)
	if not ok then
		warn("[KnifePolice V5] "..tostring(res))
		return nil
	end
	return res
end

-- Custom arena texture uploaded to your GitHub repo.
local arena=fetch(
	"knifepolice_lavender_arena.png",
	"https://raw.githubusercontent.com/lyn4x-js/Textures/main/lavender_cloud_blossom_tile.png",
	".png"
)
if not arena then return end

-- KnifePolice SFX
local sounds={}
local function sound(name,url,ids,ext)
	local a=fetch("kp_"..name..ext,url,ext)
	if a then
		for _,id in ipairs(ids) do sounds[tostring(id)]=a end
	end
end

sound("loadin","https://files.catbox.moe/ufjhxz.mp3",{6384899588},".mp3")
sound("kill","https://files.catbox.moe/jdntvt.mp3",{16530229616,16530229541,16530229695},".mp3")
sound("doublejump","https://files.catbox.moe/0ut9pd.wav",{16770456156},".wav")
sound("weaponswitch","https://files.catbox.moe/tjjhtd.mp3",{13158734943,13158735106,13158735037},".mp3")
sound("click","https://files.catbox.moe/d7x6vx.mp3",{177266782},".mp3")
sound("roundloss","https://files.catbox.moe/7b1g1u.mp3",{17016581922},".mp3")
sound("matchpoint","https://files.catbox.moe/ipbe38.mp3",{17026600996},".mp3")
sound("suddendeath","https://files.catbox.moe/g39j91.mp3",{17467242617},".mp3")
sound("lobby","https://files.catbox.moe/f8wr4p.mp3",{17697682466,17733314783,120824068504773,114306049661290},".mp3")
sound("roundwin","https://files.catbox.moe/oid7n6.mp3",{16810041280},".mp3")
sound("wintheme","https://files.catbox.moe/3nk8yt.mp3",{18221725850,18239670056,18221726246},".mp3")
sound("matchmaking","https://files.catbox.moe/iddabj.mp3",{18525513345},".mp3")
sound("slide","https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/sparkle.wav",{16737738420},".wav")

local TARGET="7658055825"

local function getid(v)
	if type(v)~="string" then return nil end
	return v:match("rbxassetid://(%d+)") or v:match("[?&]id=(%d+)") or v:match("(%d+)")
end

local queue={}
local head=1

local function enqueue(obj,prop)
	if not obj or not obj.Parent or state.queued[obj] then return end
	local ok,v=pcall(function() return obj[prop] end)
	if ok and getid(v)==TARGET then
		state.queued[obj]=true
		queue[#queue+1]={obj,prop}
	end
end

local function inspectTexture(obj)
	-- Arena/world only. This avoids rewriting UI/templates and is more stable on iPad.
	if not obj:IsDescendantOf(workspace) then return end

	if obj:IsA("Texture") or obj:IsA("Decal") then
		enqueue(obj,"Texture")
	elseif obj:IsA("MeshPart") then
		enqueue(obj,"TextureID")
	end
end

local watched=setmetatable({},{__mode="k"})
local function patchSound(obj)
	if not obj:IsA("Sound") then return end

	local r=sounds[getid(obj.SoundId)]
	if r then pcall(function() obj.SoundId=r end) end

	if not watched[obj] then
		watched[obj]=true
		local ok,c=pcall(function()
			return obj:GetPropertyChangedSignal("SoundId"):Connect(function()
				local rep=sounds[getid(obj.SoundId)]
				if rep then
					task.defer(function()
						if obj.Parent then pcall(function() obj.SoundId=rep end) end
					end)
				end
			end)
		end)
		if ok and c then keep(c) end
	end
end

-- Paced initial arena scan.
task.spawn(function()
	local all=workspace:GetDescendants()
	for i,obj in ipairs(all) do
		inspectTexture(obj)
		if i%250==0 then task.wait() end
	end
end)

-- Sound scan.
task.spawn(function()
	local all=game:GetDescendants()
	for i,obj in ipairs(all) do
		patchSound(obj)
		if i%400==0 then task.wait() end
	end
end)

keep(game.DescendantAdded:Connect(function(obj)
	task.defer(function()
		if env[KEY]~=state or not obj.Parent then return end
		inspectTexture(obj)
		patchSound(obj)

		-- Some RIVALS objects receive TextureID shortly after creation.
		task.wait(.25)
		if env[KEY]==state and obj.Parent then
			inspectTexture(obj)
			patchSound(obj)
		end
	end)
end))

-- The proven iPad/Delta fix: only 8 texture assignments every 0.10 sec.
task.spawn(function()
	while env[KEY]==state do
		local n=0
		while head<=#queue and n<8 do
			local item=queue[head]
			head+=1
			n+=1

			local obj,prop=item[1],item[2]
			if obj and obj.Parent then
				pcall(function()
					if getid(obj[prop])==TARGET then
						obj[prop]=arena
					end
				end)
			end
		end

		if head>1000 then
			local q={}
			for i=head,#queue do q[#q+1]=queue[i] end
			queue=q
			head=1
		end

		task.wait(.10)
	end
end)

pcall(function()
	game:GetService("StarterGui"):SetCore("SendNotification",{
		Title="KnifePolice V5",
		Text="Lavender arena + SFX loaded",
		Duration=6
	})
end)

print("[KnifePolice V5] loaded")
