local url = "https://raw.githubusercontent.com/goffol/VIOLENT-LIBS/main/ViolentUiLib.lua"
local success, result = pcall(function() return game:HttpGet(url) end)
if not success then return warn("[ERROR] Failed to connect to GitHub!") end
local loadFunc, loadErr = loadstring(result)
if not loadFunc then return warn("[ERROR] Syntax Error: \n" .. tostring(loadErr)) end
local ViolentLib = loadFunc()

---------------------------------------------------------
-- [[ YOUR SCRIPT STARTS HERE ]]
---------------------------------------------------------
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = game:GetService("Players").LocalPlayer

local Window = ViolentLib:CreateWindow({ Title = "VIOLENT" })

-- 1. Create the Menus to be used (Including default Setting access)
local MainTab = Window:CreateMenu("Main")
local VisualsTab = Window:CreateMenu("Visuals")
local MiscTab = Window:CreateMenu("Misc")
local SettingsTab = Window:CreateMenu("Settings") -- Calling this API will allow you to add items to the default Settings menu

-- 2. Set Menu Position / Order on the Main Page ("Main")
-- You can move the order of these CreateMenuLink calls to place Settings or Misc above/below Visuals
MainTab:CreateMenuLink({ Name = "Visuals", Target = "Visuals" })
MainTab:CreateMenuLink({ Name = "Misc", Target = "Misc" })
MainTab:CreateMenuLink({ Name = "Settings", Target = "Settings" })

-- 3. Populate Visuals Menu
VisualsTab:CreateToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(State)
        print("ESP enabled:", State)
    end
})

-- 4. Populate Misc Menu (Includes Rejoin Server)
MiscTab:CreateHeader({ Name = "MISC" })
MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})
