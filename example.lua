-- 1. Load the library from your GitHub
local ViolentLib = loadstring(game:HttpGet("https://github.com/goffol/VIOLENT-LIBS/raw/refs/heads/main/ViolentUiLib.lua"))()

-- 2. Create the main window
local Window = ViolentLib:CreateWindow({
Title = "VIOLENT"
})

-- 3. Gain access to the default "Main" menu (so you can add buttons there)
local MainTab = Window:CreateMenu("Main")

-- 4. Create a new folder/menu (e.g.: ESP & Visuals)
local VisualsTab = Window:CreateMenu("Visuals")

-- 5. Link the Main Menu to the Visuals Menu
MainTab:CreateMenuLink({ Name = "Visuals Settings", Target = "Visuals" })

-- [[ NOW JUST FILL IN THE MENU! ]]

VisualsTab:CreateHeader({ Name = "ESP SETTINGS" })

VisualsTab:CreateToggle({ 
Name = "Enable ESP", 
Default = false, 
Callback = function(Value) 
print("ESP Status:", Value) 
-- Enter your ESP script here 
end
})

VisualsTab:CreateSlider({ 
Name = "ESP Distance", 
Min = 0, 
Max = 1000, 
Default = 500, 
Step = 10, 
Callback = function(Value) 
print("Distance Set To:", Value) 
end
})

VisualsTab:CreateSelector({ 
Name = "Target Mode", 
Options = {"Players", "NPCs", "All"}, 
Default = 1, 
Callback = function(Value) 
print("Targeting:", Value) 
end
})

VisualsTab:CreateButton({ 
Name = "Print Info", 
Callback = function() 
print("Button Clicked via Enter!") 
end
})
