local Core = exports.vorp_core:GetCore()
local Holes = {}
local holes_searched = {}
local holes_searching = {}

local function InventoryCheck(_source, item, count)
	local retval = false
	local canCarry = exports.vorp_inventory:canCarryItem(_source, item, count)
	local Required = Config.RequiredItem
	local RequiredCount = exports.vorp_inventory:getItemCount(_source, nil, Required,nil)
	if RequiredCount >= 1 then
		if canCarry then
			retval = true
		else
			Core.NotifyObjective(_source, _U("inv_nospace"), 5000)
			retval = false
		end
	else
		retval = false
	end

	return retval
end

local function AbortSearch(_source)
	for k, v in ipairs(Holes) do
		if v then
			if v == _source then
				Holes[k].Searching = false
			end
		end
	end
end

local function PickRandomItem()
	local tbl = Config.CatchableAnimals
    -- Get all the keys from the table
    local keys = {}
    for key in pairs(tbl) do
        table.insert(keys, key)
    end
    
    -- Pick a random key
    local randomKey = keys[math.random(1, #keys)]
    
    -- Get the settings associated with that key
    local settings = tbl[randomKey]
    
    return randomKey, settings
end

local function BreakRequired(src, holeIndex)
	local retval = false
	if not Config.BreakRequiredChance then return false end
	local breakChance = math.random(1,100)
	if Config.BreakRequiredChance <= breakChance then
		exports.vorp_inventory:subItem(src, Config.RequiredItem, 1)
		Core.NotifyObjective(src, _U("required_broke"), 5000)
		retval = true
	else
		retval = false
	end
	return retval
end

local function GetBoostAmount(count)
	if not Config.UseWeatherBoosts then return count end
	local weather = exports.weathersync:getWeather()
	if weather == nil then return count end
	if not Config.WeatherBoosts[weather] then return count end
	if count > 1 then
		count = math.floor(count * Config.WeatherBoosts[weather])
		if count < 1 then
			count = 1
		end
	else
		if Config.WeatherBoosts[weather] < 1 then
			count = 1
		else
			count = count * Config.WeatherBoosts[weather]
		end
	end
	return count
end

RegisterServerEvent("vorp_crawfish:try_search", function(holeIndex)
	local _source = source
	local allow = true
	local curtime = os.time()
	if Holes[holeIndex].Searching then
		Core.NotifyObjective(_source, _U("searching_current"), 5000)
		return
	end
	Holes[holeIndex].Searching = _source
	if Holes[holeIndex].Searched then
		if curtime < (Holes[holeIndex].Searched + Config.SearchDelay) then
			Core.NotifyObjective(_source, _U("search_recent"), 5000)
			allow = false
		end
	end
	if not allow then
		Holes[holeIndex].Searching = false
		TriggerClientEvent("vorp_crawfish:try_search", _source)
		return
	end
	Holes[holeIndex].Searched = curtime
	local searchTime = math.random(Config.SearchTimeMin, Config.SearchTimeMax)
	TriggerClientEvent("vorp_crawfish:do_search", _source, holeIndex, searchTime)
end)

RegisterServerEvent("vorp_crawfish:do_search", function(holeIndex)
	local _source = source
	if (Holes[holeIndex].Searching or 0) ~= _source then
		TriggerClientEvent("vorp_crawfish:try_search", _source)
		return
	end
	Holes[holeIndex].Searching = false
	
	local allow = nil
	local randomItem, settings = PickRandomItem(Config.CatchableAnimals)
	local itemData = exports.vorp_inventory:getItemDB(randomItem, nil)
	local itemLabel = itemData.label
	local count = nil
	local finalCount = nil

	local catchChance = math.random(1,100)
	if not settings.Chance or catchChance < settings.Chance then

		if type(settings.Amount) == "table" then
			count = math.random(settings.Amount[1], settings.Amount[2])
		else
			count = settings.Amount
		end
		finalCount = GetBoostAmount(count)
		allow = InventoryCheck(_source, randomItem, finalCount)

		repeat
			Wait(10)
		until allow ~= nil

		if allow then
			if BreakRequired(_source, holeIndex) then
				Holes[holeIndex].Searched = false
				TriggerClientEvent("vorp_crawfish:try_search", _source)
				return
			else
				exports.vorp_inventory:addItem(_source, randomItem, finalCount)
				Core.NotifyObjective(_source, _UP("search_found", { count = finalCount, item = itemLabel }), 5000)
			end
		end
	else
		Core.NotifyObjective(_source, _U("found_nothing"), 5000)
		TriggerClientEvent("vorp_crawfish:try_search", _source)
		return
	end
end)

RegisterServerEvent("vorp_crawfish:abort_search", function()
	AbortSearch(source)
end)

AddEventHandler("playerDropped", function(reason)
	AbortSearch(source)
end)

AddEventHandler("onResourceStart", function(resourceName)
	if resourceName == GetCurrentResourceName() then
		for k, v in ipairs(Config.CrawfishHoles) do
			Holes[k] = {
				Searching = false,
				Searched = false
			}
			-- holes_searched[k] = false
			-- holes_searching[k] = false
		end
	end
end)
