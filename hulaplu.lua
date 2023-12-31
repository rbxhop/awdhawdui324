-- // Lurph macros
LPH_ENCSTR = function(...) return ... end
LPH_NO_UPVALUES = function(...) return ... end
if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(...) return(...) end;
    LPH_NO_VIRTUALIZE = function(...) return(...) end;
end
-- dont touch up

getgenv().Settings = {
["Webhook"] = "https://discord.com/api/webhooks/1121910777977245758/0k4cBERITYxdum2cO8o0xiSZwSyJPnEusRMF6h957YDWl_IJ2W1g9XsEtlu0qa6U89QN",
    ["Farm Speed"] = 0.1,
    ["KickOnCollapse"] = false,
    ["Minimum Oranges"] = 80,
    ["Maximum Oranges"] = 150,
    ["Mystic Mine"] = true,
    ["Cyber Cavern"] = true,
    ["Minimum Multiplier"] = {
        ["Giant Chest"] = 1,
        ["Other"] = 0,
    },
    ["Mailbox"] = {
        ["Enabled"] = true,
        ["Delay"] = 60,
        ["Recipient"] = "pstar7754xxz",
        ["Amount"] = 49000000000,
        ["Auto Redeem"] = false
    },
    ["Performance"] = {
        ["FPS Cap"] = 25,
        ["Disable Rendering"] = true,
        ["Downgraded Quality"] = true
    }
}
-- dont touch below pls
local Message = "HOLE HOLA"
local PERF = Settings["Performance"]
local MB = Settings["Mailbox"]
local mailing = false
local oldJob = game.JobId
local mysticEmpty = false
local cyberEmpty = false
local collectedAll = false
local sentWH = false
local TimeElapsed = 0
local GemsEarned = 0
local TotalGemsEarned = 0
local timer = coroutine.create(function()
    while 1 do
        TimeElapsed = TimeElapsed + 1
        wait(1)
    end
end)


function add_suffix(inte)
    local gems = inte
    local gems_formatted

    if gems >= 1000000000000 then  -- if gems are greater than or equal to 1 trillion
        gems_formatted = string.format("%.1ft", gems / 1000000000000)  -- display gems in trillions with one decimal point
    elseif gems >= 1000000000 then  -- if gems are greater than or equal to 1 billion
        gems_formatted = string.format("%.1fb", gems / 1000000000)  -- display gems in billions with one decimal point
    elseif gems >= 1000000 then  -- if gems are greater than or equal to 1 million
        gems_formatted = string.format("%.1fm", gems / 1000000)  -- display gems in millions with one decimal point
    elseif gems >= 1000 then  -- if gems are greater than or equal to 1 thousand
        gems_formatted = string.format("%.1fk", gems / 1000)  -- display gems in thousands with one decimal point
    else  -- if gems are less than 1 thousand
        gems_formatted = tostring(gems)  -- display gems as is
    end

    return gems_formatted
end

--if not game:IsLoaded() then game.Loaded:Wait() end
local Lib = require(game:GetService("ReplicatedStorage"):WaitForChild("Framework"):WaitForChild("Library"))
repeat task.wait() until Lib.Loaded
coroutine.resume(timer)

local webhook = Settings["Webhook"]

-- The name of the currency you want to track
-- Diamonds, Coins, Fantasy Coins, Tech Coins, Rainbow Coins, Cartoon Coins
-- Or event Currencies: Clover Coins, Gingerbread, Halloween Candy, Valentine Hearts

local currencyName = "Diamonds"

local plr = game:GetService("Players"):GetPlayerFromCharacter(script.Parent)
local JobID = tostring(game.JobId)
local unixtime = os.time()
local format = "%H:%M:%S | %a, %d %b %Y"
local timei = os.date(format, unixtime)
local username = tostring(game.Players.localPlayer.Name)


local updateDelay = 600  -- The delay between updates (in seconds)

-- Load the library
local Library = require(game.ReplicatedStorage.Library)
Library.Load()

-- Function to format a number with commas
local function formatNumber(number)
    return tostring(number):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- Function to get the current amount of the specified currency
local function getCurrentCurrencyAmount()
    local saveData = Library.Save.Get()
    if not saveData then
        return nil
    end
    return saveData[currencyName]
end

-- Function to send an update to the webhook
local function sendUpdate(currentAmount, totalAmount, deltaAmount, totalTime)
    local embed = {
        ["title"] = "Currency Update",
        ["color"] = tonumber("0x00FF00", 16), -- Green
        ["fields"] = {
            {
                ["name"] = "Current "..currencyName,
                ["value"] = formatNumber(currentAmount),
                ["inline"] = false
            },
            {
                ["name"] = "Total "..currencyName.." Earned",
                ["value"] = formatNumber(totalAmount).." / "..formatNumber(totalTime).." minutes",
                ["inline"] = true
            },
            {
                ["name"] = "Last 10 minutes",
                ["value"] = formatNumber(deltaAmount),
                ["inline"] = true
            },
            {
                ["name"] = "Username",
                ["value"] = username,
                ["inline"] = false
            },
            {
                ["name"] = "JobID",
                ["value"] = "```"..JobID.."```",
                ["inline"] = false
              }
        },
      --  ["footer"] = {text = timei}
		}
		
	(syn and syn.request or http_request or http.request) {
		Url = webhook;
		Method = 'POST';
		Headers = {
			['Content-Type'] = 'application/json';
		};
		Body = game:GetService('HttpService'):JSONEncode({
			username = "Gem Tracker", 
			avatar_url = 'https://i.imgur.com/5b6NmEo.png',
			embeds = {embed} 
		})
	}
end

-- Initialize the current and total amounts
local currentAmount = getCurrentCurrencyAmount() or 0
local totalAmount = 0 -- Initialize to 0 instead of currentAmount
local last10MinAmount = 0
local totalTime = 0

-- Send the initial update
sendUpdate(currentAmount, totalAmount, last10MinAmount, totalTime)

-- -- Start a loop to update the currency every 10 minutes
-- while wait(updateDelay) do
--     wait(updateDelay)
--     local newAmount = getCurrentCurrencyAmount() or 0
--     local deltaAmount = newAmount - currentAmount
--     totalAmount = totalAmount + deltaAmount
--     last10MinAmount = deltaAmount
--     currentAmount = newAmount
--     totalTime = totalTime + (updateDelay / 60)
--     sendUpdate(currentAmount, totalAmount, last10MinAmount, totalTime)
-- end



-- // Services //
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // PSX Libraries //
local Library = RS:WaitForChild("Library")
local ClientModule = Library:WaitForChild("Client")
local Directory = require(Library:WaitForChild("Directory"))

local Save = require(ClientModule:WaitForChild("Save"))
local Network = require(ClientModule:WaitForChild("Network"))
local WorldCmds = require(ClientModule:WaitForChild("WorldCmds"))
local PetCmds = require(ClientModule:WaitForChild("PetCmds"))
local ServerBoosts = require(ClientModule:WaitForChild("ServerBoosts"))
local StartingGems = Save.Get().Diamonds
local Teleporter = getsenv(LocalPlayer.PlayerScripts.Scripts.GUIs.Teleport)
local username = tostring(game.Players.localPlayer.Name)




LPH_NO_VIRTUALIZE(function()
local InvokeHook = hookfunction(debug.getupvalue(Network.Invoke, 1), function(...) return true end)
local FireHook = hookfunction(debug.getupvalue(Network.Fire, 1), function(...) return true end)
end)()


-- Anti AFK
for _,v in pairs(getconnections(LocalPlayer.Idled)) do
    v:Disable()
end

do -- Patching/Hooking
    if (not getgenv().hooked) then
LPH_NO_VIRTUALIZE(function()
        hookfunction(debug.getupvalue(Network.Fire, 1) , function(...) return true end)
        hookfunction(debug.getupvalue(Network.Invoke, 1) , function(...) return true end)
        FireHook = hookfunction(debug.getupvalue(Network.Fire, 1), function(...) return true end)

end)()
        getgenv().hooked = true
    end

    local function UseSignal(Content, ColorToInput)
    return Library.Signal.Fire("Notification", Content, {color = ColorToInput})
end

    local Blunder = require(RS:FindFirstChild("BlunderList", true))
    local OldGet = Blunder.getAndClear

    setreadonly(Blunder, false)

    Blunder.getAndClear = function(...)
        local Packet = ...
        for i,v in next, Packet.list do
            if v.message ~= "PING" then
                table.remove(Packet.list, i)
            end
        end
        return OldGet(Packet)
    end
LPH_NO_VIRTUALIZE(function()
    local Audio = require(RS:WaitForChild("Library"):WaitForChild("Audio"))
    hookfunction(Audio.Play, function(...)
        return {
            Play = function() end,
            Stop = function() end,
            IsPlaying = function() return false end
        }
    end)
end)()
    print("Hooked")
end

do -- Performance
    setfpscap(PERF["FPS Cap"] or 15)
    game:GetService("RunService"):Set3dRenderingEnabled(not PERF["Disable Rendering"])
    if PERF["Downgraded Quality"] then
        local lighting = game.Lighting
        lighting.GlobalShadows = false
        lighting.FogStart = 0
        lighting.FogEnd = 0
        lighting.Brightness = 0
        settings().Rendering.QualityLevel = "Level01"

        for _,v in pairs(game:GetDescendants()) do
            if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            end
        end

        for _,e in pairs(lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end
    end
end


if Settings["KickOnCollapse"] then
local v1 = Save.Get().DiamondMineData.Earned
if v1 > 50000000000 then
 --  UseSignal("Max gems made", Color3.fromRGB(0,255,0))
  -- wait(5)
           LocalPlayer:Kick("MINE COLLAPSED - TRY AGAIN LATER")
            task.wait(30)
            game:Shutdown("YES")
end
end
    

function getEquippedPets()
    local pets = PetCmds.GetEquipped()
    for i,v in pairs(pets) do pets[i] = v.uid end
    return pets
end

function getOrangeCount()
    local boosts = LocalPlayer.PlayerGui.Main.Boosts
    return boosts:FindFirstChild("Orange") and tonumber(boosts.Orange.TimeLeft.Text:match("%d+")) or 0
end

function farmCoin(coinId, petUIDs)
    local pets = (petUIDs == nil and getEquippedPets()) or (typeof(petUIDs) ~= "table" and { petUIDs }) or petUIDs
    task.spawn(function()
Network.Invoke("Join Coin", coinId, pets)
    for _,pet in pairs(pets) do
        Network.Fire("Farm Coin", coinId, pet)
    end
end)
end




function farmFruits()
    local function isFruitValid(coinObj)
        return Directory.Coins[coinObj.n].breakSound == "fruit"
    end

    local function GetFruits()
        local fruits = {}
        for i,v in pairs(Network.Invoke("Get Coins")) do
            if isFruitValid(v) and WorldCmds.HasArea(v.a) then
                v.id = i
                table.insert(fruits, v)
            end
        end
        return fruits
    end

    local function GetCoinsInPV()
        local coins = {}
        for i,v in pairs(Network.Invoke("Get Coins")) do
            if v.a == "Pixel Vault" then 
                v.id = i
                table.insert(coins, v)
            end
        end
        table.sort(coins, function(a, b) return a.h < b.h end)
        return coins
    end

    if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Pixel" then
        WorldCmds.Load("Pixel")
    end

    if WorldCmds.HasLoaded then
       --riables.Telporting = false
--LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3588, -12, 2457)
        --- Teleporter.Teleport("Pixel Vault", true)
      --  Variables.Teleporting = false
    end

    local fruits = GetFruits()
    if #fruits == 0 then fruits = GetCoinsInPV() end
    if #fruits > 0 then
        for _,pet in pairs(getEquippedPets()) do
            local b = fruits[1]
            if b ~= nil then
--LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3588, -12, 2457)
                if b.a ~= "Pixel Vault" then
                    tpd = false
                    LocalPlayer.Character:PivotTo(CFrame.new(b.p))
                elseif not tpd then
    
                    tpd = true                
                  ---  Variables.Teleporting = false
                   -- Teleporter.Teleport("Pixel Vault", true)
                 --   Variables.Teleporting = false

                 if game.Workspace:FindFirstChild("plat") then game.Workspace.plat:Destroy() end
local p = Instance.new("Part") 
p.Anchored = true
p.Name = "plat"
p.Position = Vector3.new(3588, -38, 2457)
p.Size = Vector3.new(100, 1, 100)
p.Parent = game.Workspace
local gui = Instance.new("SurfaceGui")
gui.Parent = p
gui.Face = Enum.NormalId.Top
local textLabel = Instance.new("TextLabel")
textLabel.Text = game.Players.LocalPlayer.Name --"GEM FARM"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel.TextColor3 = Color3.new(0, 0, 0)
textLabel.FontSize = Enum.FontSize.Size14
textLabel.Parent = gui
textLabel.TextScaled = true
wait(1)
LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3588, -32, 2457)
                end
                  farmCoin(b.id, { pet })
                table.remove(fruits, 1)
                task.wait(0.15)
            end
        end
    end
end


local _HopManager = HopManager or loadstring(game:HttpGet("https://raw.githubusercontent.com/Stefanuk12/ROBLOX/master/Other/HopManager.lua"))()
local HopManager = _HopManager.new({
    ServerFormat = "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true&cursor=%s",
    HopMode = "Random",
    DataRetryDelay = 5,
        MinimumPlayers = 1,
        MaximumPlayers = 3/0,
SaveLocation = "recenthops.json",
RecentHops = {},
    MassServerList = {
        Enabled = true,
        Amount = 100,
        RemoveAfterTeleport = true,
        Refresh = 40,
            MinimumServers = 25,
           SaveLocation = "massserver.json",

    }
})


-- // Hops
local function Hop()
    HopManager:Hop()
end





function farm(cframe, area)
    repeat task.wait() until WorldCmds.HasLoaded() and not mailing
    if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Diamond Mine" then
        WorldCmds.Load("Diamond Mine")
    end
    LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    task.wait()

if game.Workspace:FindFirstChild("plat") then game.Workspace.plat:Destroy() end
local p = Instance.new("Part") 
p.Anchored = true
p.Name = "plat"
p.Position = Vector3.new(9043.19140625, -38.66098690032959, 2424.636474609375)
p.Size = Vector3.new(2000, 1, 2000)
p.Parent = game.Workspace
local gui = Instance.new("SurfaceGui")
gui.Parent = p
gui.Face = Enum.NormalId.Top
local textLabel = Instance.new("TextLabel")
textLabel.Text = "GEM FARM"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
textLabel.TextColor3 = Color3.new(0, 0, 0)
textLabel.FontSize = Enum.FontSize.Size14
textLabel.Parent = gui
textLabel.TextScaled = true
--game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9043.19141, -34.3321552, 2424.63647, -0.938255966, 7.68024719e-08, 0.345941782, 8.24376656e-08, 1, 1.57588176e-09, -0.345941782, 2.99972136e-08, -0.938255966)



    local function GetChests()
        local chests = {}
        for i,v in pairs(Network.Invoke("Get Coins")) do
            local Type = string.find(v.n, "Giant Chest") and "Giant Chest" or "Other"

            if string.find(v.a, area) and (v.b and v.b.l[1].m or 1) >= Settings["Minimum Multiplier"][Type] then
                v.id = i
                table.insert(chests, v)
            end
        end
        table.sort(chests, function(a, b) return a.h > b.h end)
        return chests
    end


    local coins = GetChests()
    if #coins == 0 then
        if area == "Mystic Mine" then mysticEmpty = true else cyberEmpty = true end
        return
    end
    if #coins > 0 and not mailing then
        local c = coins[1]
        if c then
farmCoin(c.id, getEquippedPets())
--farmCoin(c.id, getEquippedPets())
--task.spawn(farmCoin, c.id, { pet })
    --                    task.spawn(farmCoin, c.id, getEquippedPets())
            table.remove(coins, 1)
            task.wait(0.4)
        end
    end
end



function sendMail()
    if not MB["Enabled"] or MB["Amount"] > Save.Get().Diamonds then return end

    local re = MB["Recipient"]
    if not re or re == "" or re == game.Players.LocalPlayer.Name then return end

    mailing = true
    task.wait(0.5)

    if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Diamond Mine" then
        WorldCmds.Load("Diamond Mine")
    end

    if WorldCmds.HasLoaded() then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9297,-14,2947)
    end

    task.wait(0.5)

    Network.Invoke("Send Mail", {
        Recipient = re,
        Diamonds = MB["Amount"],
        Pets = {},
        Message = "Hi gems"
    })

    task.wait(1)
    mailing = false
end

function claimMail()
    if not MB["Enabled"] and not MB["Auto Redeem"] then return end

    local mails = {}
    for _,v in pairs(Network.Invoke("Get Mail")["Inbox"]) do
        if v.Message == "ring ring" then
            table.insert(mails, v.uuid)
        end
    end

    mailing = true
    task.wait(0.5)

    if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Diamond Mine" then
        WorldCmds.Load("Diamond Mine")
    end

    if WorldCmds.HasLoaded() then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9298, -14, 2988)
    end

    task.wait(0.5)

    Network.Invoke("Claim Mail", mails)

    task.wait(1)
    mailing = false
end

do -- Collection
    coroutine.wrap(function() while task.wait() do
        -- // Lootbags
        for _,v in pairs(workspace["__THINGS"].Lootbags:GetChildren()) do
            Network.Fire("Collect Lootbag", v:GetAttribute("ID"), v.CFrame.p)
        end

        -- // Orbs
        local orbs = workspace["__THINGS"].Orbs:GetChildren()

        for i,v in pairs(orbs) do orbs[i] = v.Name end
        if #orbs > 0 and orbs[1] ~= nil then
            Network.Fire("Claim Orbs", orbs)
        end
        collectedAll = #orbs == 0

        -- // Gifts
        for _,v in pairs(LocalPlayer.PlayerGui.FreeGifts.Frame.Container.Gifts:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Text == "Redeem!" then
                local giftName = v.Parent.Name
                local number = string.match(giftName, "%d+")
                Network.Invoke("Redeem Free Gift", tonumber(number))
            end
        end
    end end)()
end

do -- Main
    coroutine.wrap(function()
        while task.wait(MB["Delay"]) do
            --claimMail()
if MB["Amount"] > Save.Get().Diamonds then return end
            sendMail()
        end
    end)()
end

do -- Collection
    coroutine.wrap(function() while task.wait() do
        -- // Lootbags

            for i,v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do
            v.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position)
            end

        for _,v in pairs(workspace["__THINGS"].Lootbags:GetChildren()) do
            Network.Fire("Collect Lootbag", v:GetAttribute("ID"), v.CFrame.p)
        end

        -- // Orbs
        local orbs = workspace["__THINGS"].Orbs:GetChildren()

        for i,v in pairs(orbs) do orbs[i] = v.Name end
        if #orbs > 0 and orbs[1] ~= nil then
            Network.Fire("Claim Orbs", orbs)
        end
        collectedAll = #orbs == 0

        -- // Gifts
        for _,v in pairs(LocalPlayer.PlayerGui.FreeGifts.Frame.Container.Gifts:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Text == "Redeem!" then
                local giftName = v.Parent.Name
                local number = string.match(giftName, "%d+")
                Network.Invoke("Redeem Free Gift", tonumber(number))
            end
        end
        useServerBoost("Triple Damage")
        useBoost("Triple Damage")
    end end)()
end

function useBoost(boost)
    if Save.Get().Boosts[boost] and Save.Get().Boosts[boost] > 300 then return end

    if Save.Get().BoostsInventory[boost] then
        Network.Fire("Activate Boost", boost)
    end
end

function useServerBoost(boost)
    local active = ServerBoosts.GetActiveBoosts()

    if active[boost] and active[boost]["totalTimeLeft"] > 300 then return end

    if Save.Get().BoostsInventory[boost] > 20 then
        Network.Fire("Activate Server Boost", boost)
    end
end

local myButton2 = Instance.new("TextButton")
                myButton2.Parent = game.Players.LocalPlayer.PlayerGui.Main -- Assumes the script is a child of a ScreenGui
                myButton2.Position = UDim2.new(0.64, -10, 0.1, -50) -- Set the button's position to the center of the screen
                myButton2.Size = UDim2.new(0, 75, 0, 40)
                --myButton2.TextWrapped = true
                myButton2.Draggable = true
                myButton2.Text = "Hop to Low"
                myButton2.Font = Enum.Font.SourceSansBold
                myButton2.FontSize = Enum.FontSize.Size18 -- Set a big cartoony font
                myButton2.TextColor3 = Color3.new(1, 1, 1) -- Set the button's text color to white
                myButton2.BackgroundTransparency = 0 -- Make the button fill visible
                myButton2.BackgroundColor3 = Color3.new(0.3333333, 1, 1) -- Set the button's background color to red
                myButton2.BorderColor3 = Color3.new(0, 0, 0) -- Set the button's border color to black
                myButton2.BorderSizePixel = 1 -- Set the button's border size
                
                -- Add an event listener to the button
                myButton2.MouseButton1Click:Connect(function()
                   Hop()
                end)

              

do -- Main
  coroutine.wrap(function()
        while task.wait(updateDelay) do
            --if collectedAll then
                   
                 -- wait()
    local newAmount = getCurrentCurrencyAmount() or 0
    local deltaAmount = newAmount - currentAmount
    totalAmount = totalAmount + deltaAmount
    last10MinAmount = deltaAmount
    currentAmount = newAmount
    totalTime = totalTime + (updateDelay / 60)
    sendUpdate(currentAmount, totalAmount, last10MinAmount, totalTime)
          

--            if mysticEmpty and collectedAll then
--                 if not sentWH then
--                     if not isfile("gems.txt") then
--                         writefile("gems.txt", "0")
--                     end
-- if not isfile("timetotal.txt") then
--     writefile("timetotal.txt", "0") end
-- if not isfile("timeframe.txt") then
--     writefile("timeframe.txt", "0")
-- end
--                     local EndingGems = Save.Get().Diamonds
--                     GemsEarned = EndingGems - StartingGems
--                     local fileContent = readfile("gems.txt")
--                     if fileContent then
--                         TotalGemsEarned = GemsEarned + tonumber(fileContent)
--                     end
--                     writefile("gems.txt", tostring(TotalGemsEarned))
                    
-- tt = tonumber(readfile("timetotal.txt"))
-- tt = tt + TimeElapsed
-- writefile("timeframe.txt", tostring(GemsEarned + tonumber(readfile("timeframe.txt"))))
-- writefile("timetotal.txt", tostring(tt))
-- if tt >= Settings["timeframe"] then
--     writefile("timetotal.txt", "0")
--     request({
--         Url = Settings["timeframewh"],
--         Method = "POST",
--         Headers = {
--             ["Content-Type"] = "application/json"
--         },
--         Body = game:GetService("HttpService"):JSONEncode{
--             ["content"] = "",
--             ["embeds"] = {
--                 {
-- 			      --["title"] = "Time Frame Stat Update (" .. Settings["timeframe"] .. "s)",
--                         ["title"] = "30 minutes of farming",
-- 			      ["description"] = "Gem update",
-- 			      ["color"] = tonumber(0x0f0063),
-- 			      ["fields"] = {
-- 			        {
-- 			          ["name"] = "Stats",
-- 			          ["value"] = ":gem: **Earnings:** ``".. add_suffix(tonumber(readfile("timeframe.txt"))) .."``"
-- 			        },
-- 			                    {
--                 ["name"] = "Username",
--                 ["value"] = username,
--                 ["inline"] = false
--             },
-- 			      },
-- 			      ["author"] = {
-- 			        ["name"] = "Time Farmer"
-- 			      }
-- 			    }
-- 			  }
-- 			  }
-- 	})
--     writefile("timeframe.txt", "0")
-- end
-- --wait(1)

--                     WH()
--                     sentWH = true
--                 end
-- wait(0.1)
            --    Hop()
task.wait(0.1)
            end
        
    end)()

    coroutine.wrap(function()
        while task.wait() do

if MB["Enabled"] and MB["Amount"] < Save.Get().Diamonds then
mailing = true
sendMail()
wait(1)
writefile("gems.txt", "0")
wait(1)
end
            if getOrangeCount() < Settings["Minimum Oranges"] then
                repeat
task.wait(0.05)
                    farmFruits()
                    task.wait(0.05)
                until getOrangeCount() >= Settings["Maximum Oranges"]
               -- Hop()
            else
        if Settings["Mystic Mine"] then
                repeat
                    task.wait(Settings["Farm Speed"])
                    farm(CFrame.new(9043.19141, -34.3321552, 2424.63647, -0.938255966, 7.68024719e-08, 0.345941782, 8.24376656e-08, 1, 1.57588176e-09, -0.345941782, 2.99972136e-08, -0.938255966), "Mystic Mine")
                    task.wait(0.05)
                    until mysticEmpty or getOrangeCount() < Settings["Minimum Oranges"]
                --until mysticEmpty
            end

     if Settings["Cyber Cavern"] then
               repeat
                    task.wait(Settings["Farm Speed"])
                  farm(CFrame.new(8625, -34, 3015), "Cyber Cavern")
                  task.wait(0.05)
               until cyberEmpty or getOrangeCount() < Settings["Minimum Oranges"]
          end

        end
        end
    end)()
end
