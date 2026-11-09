-- GoldmanShaq_SharedMedia.lua
-- Registers custom fonts/textures with LibSharedMedia-3.0 so every other addon can use them.
-- Works on Retail (Midnight 12.x) and WoW Forever. Edit the MEDIA table to add more media.

local addonName = ...

local LSM_NAME = "LibSharedMedia-3.0"
local ROOT = "Interface\\AddOns\\" .. addonName .. "\\"

-- Add your media here. Format: [mediaType] = { ["Display Name"] = "path", ... }
-- Use double backslashes in paths. File names must match the files on disk exactly.
local MEDIA = {
    font = {
        ["GS_Bangers"]          = ROOT .. "Fonts\\Bangers.ttf",
        ["GS_Bohgaku"]          = ROOT .. "Fonts\\Bohgaku.ttf",
        ["GS_DieDieDie"]        = ROOT .. "Fonts\\DieDieDie.ttf",
        ["GS_Expressway"]       = ROOT .. "Fonts\\Expressway.ttf",
        ["GS_GothamNarrowUltra"] = ROOT .. "Fonts\\GothamNarrowUltra.ttf",
        ["GS_HugMeTight"]       = ROOT .. "Fonts\\HugMeTight.ttf",
        ["GS_MetropolisBlack"]  = ROOT .. "Fonts\\MetropolisBlack.ttf",
        ["GS_Montserrat"]       = ROOT .. "Fonts\\Montserrat.ttf",
        ["GS_MuscleUI"]         = ROOT .. "Fonts\\MuscleUI.ttf",
        ["GS_MuscleUI2"]         = ROOT .. "Fonts\\MuscleUI2.ttf",
        ["GS_Naowh"]            = ROOT .. "Fonts\\Naowh.ttf",
    },

    statusbar = {
        ["GS_Norm"]  = ROOT .. "Textures\\GS_Norm.tga",
        ["GS_Gloss"] = ROOT .. "Textures\\GS_Gloss.tga",
    },

    -- Examples (uncomment and point at real files that exist in this addon folder):
    -- border     = { ["GS_ThinBorder"] = ROOT .. "Textures\\thin_border.tga" },
    -- background = { ["GS_DarkBG"]     = ROOT .. "Textures\\dark_bg.tga" },
    -- sound      = { ["GS_Alert"]      = ROOT .. "Sounds\\alert.ogg" },
}

local registered = false
local count = 0

-- Registers everything once LibSharedMedia is available. Safe to call repeatedly.
local function TryRegister()
    if registered then return true end

    -- Silent lookups: never throw if the library isn't loaded (yet).
    local libStub = _G.LibStub
    local LSM = libStub and libStub:GetLibrary(LSM_NAME, true)
    if not LSM then return false end

    count = 0
    for mediaType, entries in pairs(MEDIA) do
        for name, path in pairs(entries) do
            if LSM:Register(mediaType, name, path) ~= false then
                count = count + 1
            end
        end
    end

    registered = true
    return true
end

-- LibSharedMedia usually lives inside another addon that may load AFTER this one
-- (addons load alphabetically). Try now, then retry as other addons load.
TryRegister()

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self)
    if TryRegister() then
        self:UnregisterAllEvents()
    end
end)

-- /gssm : status check
SLASH_GSSM1 = "/gssm"
SlashCmdList["GSSM"] = function()
    local prefix = "|cff00ff00GoldmanShaq_SharedMedia:|r "
    if not registered then
        print(prefix .. "LibSharedMedia-3.0 was not found. Enable any addon that bundles it (Details, WeakAuras, ElvUI, etc.) or install the library.")
        return
    end
    print(prefix .. count .. " media items registered.")
end
