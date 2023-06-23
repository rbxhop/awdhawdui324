if not game:IsLoaded() then game.Loaded:Wait() end
--[[ Very well aware... ugly :)]]
local gamelibrary = require(game:GetService("ReplicatedStorage").Framework.Library)
local Save = gamelibrary.Save.Get
local Commas = gamelibrary.Functions.Commas
local types = {}
local menus = game:GetService("Players").LocalPlayer.PlayerGui.Main.Right
for i, v in pairs(menus:GetChildren()) do
    if v.ClassName == 'Frame' and v.Name ~= 'Rank' and not string.find(v.Name, "2") then
        table.insert(types, v.Name)
    end
end
function get(thistype)
    if game.PlaceId == 10321372166 and string.find(string.lower(thistype), "coins") then
        return Save().HardcoreCurrency[thistype]
    else
        return Save()[thistype]
    end
end
            
local LayoutOrders = {
    ["Diamonds"] = 999910;
}
menus.UIListLayout.HorizontalAlignment = 2
_G.MyTypes = {}
for i,v in pairs(types) do
    if menus:FindFirstChild(v.."2") then
        menus:FindFirstChild(v.."2"):Destroy()
    end
end
for i,v in pairs(types) do
    spawn(function()
        if not menus:FindFirstChild(v.."2") then
            menus:WaitForChild(v).LayoutOrder = LayoutOrders[v]
            local tempmaker = menus:WaitForChild(v):Clone()
            tempmaker.Name = tostring(tempmaker.Name .. "2")
            tempmaker.Parent = menus
            tempmaker.Size = UDim2.new(0, 175, 0, 30)
            tempmaker.LayoutOrder = tempmaker.LayoutOrder + 1
            _G.MyTypes[v] = tempmaker
        end
    end)
end
spawn(function() menus:WaitForChild("Diamonds2").Add.Visible = false end)
-- Skidded from byte-chan:tm:
for i,v in pairs(types) do
    spawn(function()
        repeat task.wait() until _G.MyTypes[v]
        local megatable = {}
        local imaginaryi = 1
        local ptime = 0
        local last = tick()
        local now = last
        local TICK_TIME = 0.5
        while true do
            if ptime >= TICK_TIME then
                while ptime >= TICK_TIME do ptime = ptime - TICK_TIME end
                local currentbal = get(v)
                megatable[imaginaryi] = currentbal
                local diffy = currentbal - (megatable[imaginaryi-120] or megatable[1])
                imaginaryi = imaginaryi + 1
                _G.MyTypes[v].Amount.Text = tostring(Commas(diffy).." in 60s")
                _G.MyTypes[v].Amount_odometerGUIFX.Text = tostring(Commas(diffy).." in 60s")
            end
            task.wait()
            now = tick()
            ptime = ptime + (now - last)
            last = now
        end
    end)
end
