-- ALYA / Flushie Sky - iPad / Delta
-- Generated from uploaded alya.json

local Lighting = game:GetService("Lighting")
local StarterGui = game:GetService("StarterGui")

local getasset = getcustomasset or getsynasset
if not writefile or not getasset then
    warn("[Alya Sky] writefile/getcustomasset unavailable")
    return
end

local faces = {
    Bk = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/bk.tex",
    Dn = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/dn.tex",
    Ft = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/ft.tex",
    Lf = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/lt.tex",
    Rt = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/rt.tex",
    Up = "https://github.com/Ankkouu/flushie/raw/refs/heads/main/up.tex"
}

local localFiles = {
    Bk = "alya_flushie_bk.tex",
    Dn = "alya_flushie_dn.tex",
    Ft = "alya_flushie_ft.tex",
    Lf = "alya_flushie_lf.tex",
    Rt = "alya_flushie_rt.tex",
    Up = "alya_flushie_up.tex"
}

local assets = {}

for face, url in pairs(faces) do
    local ok, data = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(data) == "string" and #data > 50 then
        local file = localFiles[face]
        local wrote = pcall(function()
            writefile(file, data)
        end)

        if wrote then
            local okAsset, asset = pcall(function()
                return getasset(file)
            end)
            if okAsset and asset then
                assets[face] = asset
            end
        end
    end
end

if not (assets.Bk and assets.Dn and assets.Ft and assets.Lf and assets.Rt and assets.Up) then
    warn("[Alya Sky] One or more sky faces failed to load")
    return
end

local sky = Lighting:FindFirstChild("AlyaFlushieSky")
if not sky then
    sky = Instance.new("Sky")
    sky.Name = "AlyaFlushieSky"
    sky.Parent = Lighting
end

local function apply()
    pcall(function()
        sky.SkyboxBk = assets.Bk
        sky.SkyboxDn = assets.Dn
        sky.SkyboxFt = assets.Ft
        sky.SkyboxLf = assets.Lf
        sky.SkyboxRt = assets.Rt
        sky.SkyboxUp = assets.Up
    end)
end

apply()

for _, delayTime in ipairs({0.5, 1.5, 3, 6, 10}) do
    task.delay(delayTime, apply)
end

Lighting.ChildAdded:Connect(function(obj)
    if obj:IsA("Sky") and obj ~= sky then
        task.defer(apply)
    end
end)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "Alya Sky",
        Text = "Sky loaded",
        Duration = 6
    })
end)
