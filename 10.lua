if not game:IsLoaded() then game.Loaded:Wait() end
local webhook = "https://discord.com/api/webhooks/1121910777977245758/0k4cBERITYxdum2cO8o0xiSZwSyJPnEusRMF6h957YDWl_IJ2W1g9XsEtlu0qa6U89QN"

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
        ["footer"] = {text = timei}
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

-- Start a loop to update the currency every 10 minutes
while true do
    wait(updateDelay)
    local newAmount = getCurrentCurrencyAmount() or 0
    local deltaAmount = newAmount - currentAmount
    totalAmount = totalAmount + deltaAmount
    last10MinAmount = deltaAmount
    currentAmount = newAmount
    totalTime = totalTime + (updateDelay / 60)
    sendUpdate(currentAmount, totalAmount, last10MinAmount, totalTime)
end
