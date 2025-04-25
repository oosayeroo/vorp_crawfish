
Config = {}

Config.defaultlang = "en" -- Default language ("en" English, "es" Español)

Config.SearchTimeMin = 5000 -- Minimum time, in milliseconds (1000 milliseconds = 1 second), taken to search a crawfish hole.
Config.SearchTimeMax = 10000 -- Maximum time, in milliseconds (1000 milliseconds = 1 second), taken to search a crawfish hole.
Config.SearchDelay = 600 -- Time, in seconds, before a crawfish hole can be search again.

Config.RequiredItem = 'cage'
Config.BreakRequiredChance = 50 -- or false to disable

Config.CatchableAnimals = {
	-- ['provision_meat_crustacean'] = {Amount = {1,5}}, --randomise from first to last number
	['animal_crawfish'] = {Amount = 3, Chance = 50},
}

Config.UseWeatherBoosts = true
Config.WeatherBoosts = { --using number lower than 1 will divide instead
	['rain'] = 2, --multiplies amount of item to return
	['snow'] = 0.5, -- halves amount
}

Config.HoleModel = -949094404

Config.CrawfishHoles = { -- vector3(x,y,z)
	-- Crawdad Willies
	[1] = {Coords = vector3(2021.29150390625, -1789.32958984375, 40.51888656616211),},
	[2] = {Coords = vector3(2027.25390625, -1722.359619140625, 40.6132583618164),},
	[3] = {Coords = vector3(2042.18701171875, -1885.94384765625, 40.39377975463867),},
	[4] = {Coords = vector3(2045.3292236328125, -1785.771240234375, 40.67805480957031),},
	[5] = {Coords = vector3(2058.18505859375, -1866.734619140625, 40.50119018554687),},
	[6] = {Coords = vector3(2087.13134765625, -1859.825439453125, 40.5162353515625),},
	-- Lagras/Lakay
	[7] = {Coords = vector3(2176.2734375, -693.794677734375, 40.6646499633789),},
	[8] = {Coords = vector3(2216.02978515625, -679.2449951171875, 40.62735748291015),},
	[9] = {Coords = vector3(2253.82666015625, -549.8944091796875, 40.5958137512207),},
	[10] = {Coords = vector3(2258.76611328125, -720.3011474609375, 40.47812271118164),},
	[11] = {Coords = vector3(2301.9091796875, -515.6649169921875, 40.82343673706055),},
	[12] = {Coords = vector3(2339.40478515625, -544.3302001953125, 40.8292007446289),},
	-- Extra Models
	[13] = {CreateModel = -949094404, Coords = vector3(2349.40478515625, -544.3302001953125, 40.8292007446289),},

}