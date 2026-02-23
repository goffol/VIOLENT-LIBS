-- [[ VIOLENT MENU API (LIBRARY VERSION) ]] --
-- V10: Converted to a Reusable UI Library (Rayfield Style)
-- Features: 100% Original Design, Auto-Layout, Camera Pan Fix, Built-in Settings.

local ViolentLibrary = {}

local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

function ViolentLibrary:CreateWindow(Config)
    Config = Config or {}
    local WindowTitle = Config.Title or "VIOLENT"
    
    local Window = {
        Menus = {},
        CurrentMenuName = "Main",
        State = {
            Visible = true,
            SelectedIndex = 1,
            MaxVisibleItems = 15,
            ScrollOffset = 0,
            ThemeIndex = 1
        },
        Theme = {
            Primary = Color3.fromRGB(0, 255, 128),
            HeaderColor = Color3.fromRGB(0, 255, 128),
            ScrollerColor = Color3.fromRGB(0, 255, 128),
            Background = Color3.fromRGB(35, 35, 35),
            HeaderBlack = Color3.fromRGB(15, 15, 15),
            TextWhite = Color3.fromRGB(240, 240, 240),
            TextBlack = Color3.fromRGB(0, 0, 0),
            ItemHeight = 22,
            Width = 260,
            TitleFont = Enum.Font.GothamBlack
        },
        ColorPalette = {
            Color3.fromRGB(0, 255, 128),   -- Neon Green
            Color3.fromRGB(255, 20, 60),   -- Crimson Red
            Color3.fromRGB(0, 150, 255),   -- Deep Blue
            Color3.fromRGB(255, 0, 255),   -- Magenta
            Color3.fromRGB(255, 165, 0),   -- Orange
            Color3.fromRGB(255, 255, 255), -- White
            Color3.fromRGB(15, 15, 15)     -- Black
        },
        FontList = {
            { Name = "Standard", Font = Enum.Font.SourceSans },
            { Name = "Pricedown", Font = Enum.Font.GothamBlack },
            { Name = "Arcade", Font = Enum.Font.Arcade }
        },
        BasePos = { X = 50, Y = 50 },
        Offsets = { X = 0, Y = 0 }
    }

    -- [[ UI GENERATION ]]
    local GuiTarget = (gethui and gethui()) or (pcall(function() return CoreGui.RobloxGui end) and CoreGui.RobloxGui) or LocalPlayer:WaitForChild("PlayerGui")
    if GuiTarget:FindFirstChild("ViolentMenu_API") then GuiTarget.ViolentMenu_API:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ViolentMenu_API"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = GuiTarget

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Main"
    MainFrame.Size = UDim2.new(0, Window.Theme.Width, 0, 500)
    MainFrame.Position = UDim2.new(0, Window.BasePos.X, 0, Window.BasePos.Y)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Parent = ScreenGui

    local MainLayout = Instance.new("UIListLayout")
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = MainFrame

    local function CreateFrame(name, height, color, parent, order)
        local f = Instance.new("Frame"); f.Name = name; f.Size = UDim2.new(1, 0, 0, height); f.BackgroundColor3 = color; f.BorderSizePixel = 0; f.LayoutOrder = order; f.Parent = parent; return f
    end

    local function CreateText(name, text, font, size, color, align, parent)
        local t = Instance.new("TextLabel"); t.Name = name; t.Size = UDim2.new(1, -16, 1, 0); t.Position = UDim2.new(0, 8, 0, 0); t.BackgroundTransparency = 1; t.Text = text; t.Font = font; t.TextSize = size; t.TextColor3 = color; t.TextXAlignment = align; t.Parent = parent; return t
    end

    local TitleBar = CreateFrame("1_TitleBar", 60, Window.Theme.HeaderColor, MainFrame, 1)
    local TitleText = CreateText("Text", WindowTitle, Window.Theme.TitleFont, 42, Window.Theme.TextWhite, Enum.TextXAlignment.Center, TitleBar)
    TitleText.TextStrokeTransparency = 0; TitleText.TextStrokeColor3 = Window.Theme.TextBlack; TitleText.Position = UDim2.new(0,0,0,5)

    local SubBar = CreateFrame("2_SubBar", 22, Window.Theme.HeaderBlack, MainFrame, 2)
    local SubText = CreateText("TextLeft", "MAIN", Enum.Font.GothamBold, 12, Window.Theme.TextWhite, Enum.TextXAlignment.Left, SubBar)
    local CountText = CreateText("TextRight", "0/0", Enum.Font.SourceSans, 14, Window.Theme.TextWhite, Enum.TextXAlignment.Right, SubBar)

    local ItemsContainer = CreateFrame("3_Items", 0, Window.Theme.Background, MainFrame, 3)
    ItemsContainer.ClipsDescendants = true
    local ItemsListLayout = Instance.new("UIListLayout")
    ItemsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ItemsListLayout.Parent = ItemsContainer

    local FooterBar = CreateFrame("4_Footer", 24, Window.Theme.HeaderBlack, MainFrame, 4)
    local FooterLine = CreateFrame("Line", 2, Window.Theme.Primary, FooterBar, 0)
    FooterLine.Position = UDim2.new(0,0,0,0)
    local VersionText = CreateText("TextLeft", "Release, API", Enum.Font.SourceSans, 13, Window.Theme.TextWhite, Enum.TextXAlignment.Left, FooterBar)
    VersionText.Position = UDim2.new(0, 8, 0, 2)
    local ArrowText = CreateText("TextCenter", "↕", Enum.Font.SourceSansBold, 14, Window.Theme.TextWhite, Enum.TextXAlignment.Center, FooterBar)
    ArrowText.Position = UDim2.new(0, 0, 0, 2)

    local ItemSlots = {}
    for i = 1, Window.State.MaxVisibleItems do
        local slot = CreateFrame("Slot_"..i, Window.Theme.ItemHeight, Window.Theme.Background, ItemsContainer, i)
        local leftText = CreateText("LeftText", "Name", Enum.Font.SourceSans, 15, Window.Theme.TextWhite, Enum.TextXAlignment.Left, slot)
        local rightText = CreateText("RightText", "Value", Enum.Font.SourceSans, 15, Window.Theme.TextWhite, Enum.TextXAlignment.Right, slot)
        local colorBox = Instance.new("Frame"); colorBox.Size = UDim2.new(0, 16, 0, 16); colorBox.Position = UDim2.new(1, -24, 0.5, -8); colorBox.BorderSizePixel = 0; colorBox.Parent = slot
        ItemSlots[i] = { Frame = slot, Left = leftText, Right = rightText, ColorBox = colorBox }
    end

    -- [[ INTERNAL LOGIC ]]
    local function GetSelectableCount(menuName)
        local count = 0
        for _, v in ipairs(Window.Menus[menuName] or {}) do
            if v.Type ~= "Header" then count = count + 1 end
        end
        return count
    end

    local function GetActualIndex()
        local count = 0
        local currentData = Window.Menus[Window.CurrentMenuName]
        if not currentData then return 0 end
        for i = 1, Window.State.SelectedIndex do
            if currentData[i] and currentData[i].Type ~= "Header" then count = count + 1 end
        end
        return count
    end

    local function ToggleFreeze(isFrozen)
        local actionName = "ViolentMenuFreeze"
        if isFrozen then
            ContextActionService:BindAction(actionName, function() return Enum.ContextActionResult.Sink end, false, unpack(Enum.PlayerActions:GetEnumItems()))
            ContextActionService:BindAction(actionName.."_Keys", function() return Enum.ContextActionResult.Sink end, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right)
        else
            ContextActionService:UnbindAction(actionName)
            ContextActionService:UnbindAction(actionName.."_Keys")
        end
    end

    local function UpdateMenu()
        ScreenGui.Enabled = Window.State.Visible
        if not Window.State.Visible then return end

        SubText.Text = string.upper(Window.CurrentMenuName)
        CountText.Text = GetActualIndex() .. "/" .. GetSelectableCount(Window.CurrentMenuName)

        TitleBar.BackgroundColor3 = Window.Theme.HeaderColor
        TitleText.Font = Window.Theme.TitleFont
        FooterLine.BackgroundColor3 = Window.Theme.ScrollerColor
        MainFrame.Position = UDim2.new(0, Window.BasePos.X + Window.Offsets.X, 0, Window.BasePos.Y + Window.Offsets.Y)

        local visibleCount = 0
        local CurrentData = Window.Menus[Window.CurrentMenuName] or {}

        for i = 1, Window.State.MaxVisibleItems do
            local dataIndex = Window.State.ScrollOffset + i
            local itemData = CurrentData[dataIndex]
            local slot = ItemSlots[i]

            if itemData then
                slot.Frame.Visible = true
                visibleCount = visibleCount + 1
                local isSelected = (dataIndex == Window.State.SelectedIndex)

                slot.Left.Text = itemData.Name
                slot.Right.Visible = false
                slot.ColorBox.Visible = false

                if itemData.Type == "Header" then
                    slot.Frame.BackgroundColor3 = Window.Theme.Background
                    slot.Left.TextColor3 = Window.Theme.TextWhite
                    slot.Left.TextXAlignment = Enum.TextXAlignment.Center
                    slot.Left.Font = Enum.Font.GothamBold
                else
                    slot.Left.Font = Enum.Font.SourceSans
                    slot.Left.TextXAlignment = Enum.TextXAlignment.Left
                    
                    if isSelected then
                        slot.Frame.BackgroundColor3 = Window.Theme.Primary
                        slot.Left.TextColor3 = Window.Theme.TextBlack
                    else
                        slot.Frame.BackgroundColor3 = Window.Theme.Background
                        slot.Left.TextColor3 = Window.Theme.TextWhite
                    end

                    if itemData.Type == "Button" or itemData.Type == "MenuLink" then
                        slot.Right.Visible = true
                        slot.Right.Text = itemData.Value or (itemData.Type == "MenuLink" and ">" or "")
                        slot.Right.TextColor3 = isSelected and Window.Theme.TextBlack or Window.Theme.TextWhite
                    elseif itemData.Type == "Toggle" then
                        slot.Right.Visible = true
                        slot.Right.Text = itemData.State and "ON" or "OFF"
                        slot.Right.TextColor3 = isSelected and Window.Theme.TextBlack or Window.Theme.TextWhite
                    elseif itemData.Type == "Selector" then
                        slot.Right.Visible = true
                        slot.Right.Text = "< " .. itemData.Options[itemData.Index] .. " >"
                        slot.Right.TextColor3 = isSelected and Window.Theme.TextBlack or Window.Theme.TextWhite
                    elseif itemData.Type == "Color" then
                        slot.ColorBox.Visible = true
                        slot.ColorBox.BackgroundColor3 = Window.ColorPalette[itemData.ColorIndex]
                    elseif itemData.Type == "Slider" then
                        slot.Right.Visible = true
                        slot.Right.Text = tostring(itemData.Value)
                        slot.Right.TextColor3 = isSelected and Window.Theme.TextBlack or Window.Theme.TextWhite
                    end
                end
            else
                slot.Frame.Visible = false
            end
        end
        ItemsContainer.Size = UDim2.new(1, 0, 0, visibleCount * Window.Theme.ItemHeight)
    end

    local function SwitchMenu(menuName)
        if not Window.Menus[menuName] then return end
        Window.CurrentMenuName = menuName
        Window.State.SelectedIndex = 1
        Window.State.ScrollOffset = 0
        UpdateMenu()
    end

    local function ScrollLogic()
        if Window.State.SelectedIndex > Window.State.ScrollOffset + Window.State.MaxVisibleItems then
            Window.State.ScrollOffset = Window.State.SelectedIndex - Window.State.MaxVisibleItems
        elseif Window.State.SelectedIndex <= Window.State.ScrollOffset then
            Window.State.ScrollOffset = Window.State.SelectedIndex - 1
        end
    end

    local function MoveSelection(step)
        local CurrentData = Window.Menus[Window.CurrentMenuName]
        if not CurrentData or #CurrentData == 0 then return end
        local newIndex = Window.State.SelectedIndex + step
        while newIndex >= 1 and newIndex <= #CurrentData do
            if CurrentData[newIndex].Type ~= "Header" then
                Window.State.SelectedIndex = newIndex
                return
            end
            newIndex = newIndex + step
        end
    end

    -- [[ INPUT HANDLER ]]
    if _G.ViolentLibConn then _G.ViolentLibConn:Disconnect() end
    _G.ViolentLibConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.F2 then
            Window.State.Visible = not Window.State.Visible
            ToggleFreeze(Window.State.Visible)
            UpdateMenu()
            return
        end

        if not Window.State.Visible then return end
        local CurrentData = Window.Menus[Window.CurrentMenuName]
        if not CurrentData or #CurrentData == 0 then return end

        if input.KeyCode == Enum.KeyCode.Down then
            MoveSelection(1); ScrollLogic(); UpdateMenu()
        elseif input.KeyCode == Enum.KeyCode.Up then
            MoveSelection(-1); ScrollLogic(); UpdateMenu()
        end

        local currentItem = CurrentData[Window.State.SelectedIndex]
        if not currentItem or currentItem.Type == "Header" then return end
        
        if input.KeyCode == Enum.KeyCode.Return then
            if currentItem.Type == "MenuLink" then
                SwitchMenu(currentItem.Target)
            elseif currentItem.Type == "Button" and currentItem.Callback then
                currentItem.Callback()
            elseif currentItem.Type == "Toggle" then
                currentItem.State = not currentItem.State
                if currentItem.Callback then currentItem.Callback(currentItem.State) end
                UpdateMenu()
            end
        end

        if input.KeyCode == Enum.KeyCode.Left then
            if currentItem.Type == "Selector" then
                currentItem.Index = currentItem.Index - 1
                if currentItem.Index < 1 then currentItem.Index = #currentItem.Options end
                if currentItem.Callback then currentItem.Callback(currentItem.Options[currentItem.Index]) end
                UpdateMenu()
            elseif currentItem.Type == "Slider" then
                currentItem.Value = math.clamp(currentItem.Value - currentItem.Step, currentItem.Min, currentItem.Max)
                if currentItem.Callback then currentItem.Callback(currentItem.Value) end
                UpdateMenu()
            elseif currentItem.Type == "Color" then
                currentItem.ColorIndex = currentItem.ColorIndex - 1
                if currentItem.ColorIndex < 1 then currentItem.ColorIndex = #Window.ColorPalette end
                if currentItem.Callback then currentItem.Callback(currentItem.ColorIndex) end
                UpdateMenu()
            elseif currentItem.Type == "Toggle" then
                currentItem.State = false
                if currentItem.Callback then currentItem.Callback(currentItem.State) end
                UpdateMenu()
            end

        elseif input.KeyCode == Enum.KeyCode.Right then
            if currentItem.Type == "Selector" then
                currentItem.Index = currentItem.Index + 1
                if currentItem.Index > #currentItem.Options then currentItem.Index = 1 end
                if currentItem.Callback then currentItem.Callback(currentItem.Options[currentItem.Index]) end
                UpdateMenu()
            elseif currentItem.Type == "Slider" then
                currentItem.Value = math.clamp(currentItem.Value + currentItem.Step, currentItem.Min, currentItem.Max)
                if currentItem.Callback then currentItem.Callback(currentItem.Value) end
                UpdateMenu()
            elseif currentItem.Type == "Color" then
                currentItem.ColorIndex = currentItem.ColorIndex + 1
                if currentItem.ColorIndex > #Window.ColorPalette end then currentItem.ColorIndex = 1 end
                if currentItem.Callback then currentItem.Callback(currentItem.ColorIndex) end
                UpdateMenu()
            elseif currentItem.Type == "Toggle" then
                currentItem.State = true
                if currentItem.Callback then currentItem.Callback(currentItem.State) end
                UpdateMenu()
            end
        end
    end)

    -- [[ API METHODS FOR USER ]]
    local MenuAPI = {}

    function MenuAPI:CreateMenu(menuName)
        Window.Menus[menuName] = {}
        if menuName ~= "Main" then
            table.insert(Window.Menus[menuName], { Type = "MenuLink", Name = "Back", Target = "Main", Value = "<" })
        end

        local TabAPI = {}
        function TabAPI:CreateHeader(props) table.insert(Window.Menus[menuName], { Type = "Header", Name = props.Name }); UpdateMenu() end
        function TabAPI:CreateMenuLink(props) table.insert(Window.Menus[menuName], { Type = "MenuLink", Name = props.Name, Target = props.Target, Value = ">" }); UpdateMenu() end
        function TabAPI:CreateButton(props) table.insert(Window.Menus[menuName], { Type = "Button", Name = props.Name, Value = "ENTER", Callback = props.Callback }); UpdateMenu() end
        function TabAPI:CreateToggle(props) table.insert(Window.Menus[menuName], { Type = "Toggle", Name = props.Name, State = props.Default or false, Callback = props.Callback }); UpdateMenu() end
        function TabAPI:CreateSlider(props) table.insert(Window.Menus[menuName], { Type = "Slider", Name = props.Name, Value = props.Default or 0, Min = props.Min or 0, Max = props.Max or 100, Step = props.Step or 1, Callback = props.Callback }); UpdateMenu() end
        function TabAPI:CreateSelector(props) table.insert(Window.Menus[menuName], { Type = "Selector", Name = props.Name, Options = props.Options, Index = props.Default or 1, Callback = props.Callback }); UpdateMenu() end
        
        -- Custom Color internal logic (hanya buat settings bawaan)
        function TabAPI:CreateInternalColor(name, defaultIdx, callback) table.insert(Window.Menus[menuName], { Type = "Color", Name = name, ColorIndex = defaultIdx, Callback = callback }); UpdateMenu() end
        
        return TabAPI
    end

    -- [[ INITIALIZE DEFAULT MENUS (MAIN & SETTINGS) ]]
    local MainTab = MenuAPI:CreateMenu("Main")
    MainTab:CreateButton({ Name = "Rejoin Server", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end })
    MainTab:CreateMenuLink({ Name = "Settings", Target = "Settings" })

    local SettingsTab = MenuAPI:CreateMenu("Settings")
    SettingsTab:CreateButton({ Name = "Premade Themes", Callback = function()
        Window.State.ThemeIndex = Window.State.ThemeIndex + 1
        if Window.State.ThemeIndex > (#Window.ColorPalette - 1) then Window.State.ThemeIndex = 1 end
        local c = Window.ColorPalette[Window.State.ThemeIndex]
        Window.Theme.Primary = c; Window.Theme.HeaderColor = c; Window.Theme.ScrollerColor = c
        -- Update color boxes visually
        for _, v in ipairs(Window.Menus["Settings"]) do
            if v.Type == "Color" and (v.Name == "Primary" or v.Name == "Secondary" or v.Name == "Header Color" or v.Name == "Scroller Color") then
                v.ColorIndex = Window.State.ThemeIndex
            end
        end
        UpdateMenu()
    end})
    SettingsTab:CreateHeader({ Name = "CUSTOMIZE" })
    SettingsTab:CreateSelector({ Name = "Title Font", Options = {"Standard", "Pricedown", "Arcade"}, Default = 2, Callback = function(val)
        for _, f in ipairs(Window.FontList) do if f.Name == val then Window.Theme.TitleFont = f.Font; break end end
    end})
    SettingsTab:CreateInternalColor("Primary", 1, function(idx) Window.Theme.Primary = Window.ColorPalette[idx] end)
    SettingsTab:CreateInternalColor("Secondary", 1, function() end)
    SettingsTab:CreateInternalColor("Title Text", 6, function() end)
    SettingsTab:CreateInternalColor("Selected Text", 7, function() end)
    SettingsTab:CreateInternalColor("Header Color", 1, function(idx) Window.Theme.HeaderColor = Window.ColorPalette[idx] end)
    SettingsTab:CreateInternalColor("Scroller Color", 1, function(idx) Window.Theme.ScrollerColor = Window.ColorPalette[idx] end)
    SettingsTab:CreateInternalColor("Footer Color", 7, function() end)
    SettingsTab:CreateHeader({ Name = "POSITION" })
    SettingsTab:CreateSlider({ Name = "X Offset", Min = -1000, Max = 1000, Default = 0, Step = 10, Callback = function(val) Window.Offsets.X = val end })
    SettingsTab:CreateSlider({ Name = "Y Offset", Min = -1000, Max = 1000, Default = 0, Step = 10, Callback = function(val) Window.Offsets.Y = val end })

    ToggleFreeze(Window.State.Visible)
    UpdateMenu()

    return MenuAPI
end

return ViolentLibrary