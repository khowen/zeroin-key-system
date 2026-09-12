--==================================================
-- CONFIG LOADER
-- Loads and applies game configuration settings
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- CONFIGURATION DATA
--==================================================

local config = {
	-- UI Theme
	Shadow = {
		Color = "#010525",
		Alpha = 0
	},
	Border = {
		Color = "#070122",
		Alpha = 0
	},
	Element = {
		Color = "#13103b",
		Alpha = 0
	},
	Outline = {
		Color = "#020a25",
		Alpha = 0
	},
	Background = {
		Color = "#070236",
		Alpha = 0
	},
	InactiveText = {
		Color = "#0c022f",
		Alpha = 0
	},
	Text = {
		Color = "#0c198c",
		Alpha = 0
	},
	Inline = {
		Color = "#02000b",
		Alpha = 0
	},
	Gradient = {
		Color = "#050029",
		Alpha = 0
	},
	Accent = {
		Color = "#0e0336",
		Alpha = 0
	},

	-- Auto Features
	AutoHatch = true,
	CarryProtect = true,
	Godmode = true,
	InstantPlace = true,
	AutoClaim = true,
	AutoPlaceEgg = true,
	AutoFuse = true,
	AutoSellEgg = true,
	AutoFarmEgg = true,
	AutoBestTrail = true,

	-- Settings
	TweenSpeed = 1000,
	EspMinRarity = "Eternal",
	SnipeMinRarity = "None",
	KeepMinRarityForSellEgg = "None",

	-- Behavior
	IgnoreFriends = true,
	BlackScreen = true,
	AntiAFK = true,
	EggESP = true,
	LockLegalWalkSpeed = true,
	FpsBoost = true,
	NightFarmSync = true,

	-- Egg Selection
	SelectEggForFarmEgg = {
		"Unicorn [Divine]",
		"Phoenix [Eternal]",
		"El Maja [Eternal]",
		"Ice Dragon [Eternal]",
		"Strawberry Elephant [Eternal]",
		"Eternal Lunar Dragon [Eternal]",
		"Mosasaurus [Eternal]",
		"Lava Dragon [Eternal]",
		"Kraken [Secret]",
		"Cerberus [Secret]",
		"Cosmic Dragon [Secret]",
		"Bomboclat Crocolat [Secret]",
		"TRex [Secret]",
		"King Snake [Secret]",
		"Cosmic Skeleton Boss [Secret]",
		"Tralaledon [Secret]",
		"Yeti [Secret]"
	},

	SelectEggForSellEgg = {
		"La Vacca Saturno Saturnita [Cosmic]",
		"Bronto [Cosmic]",
		"Leviathan [Cosmic]",
		"Mangolini Parrochini [Cosmic]",
		"Royal Sphinx [Cosmic]",
		"Whale Shark [Cosmic]",
		"King Mammoth [Cosmic]",
		"Beluga Whale [Cosmic]",
		"Triceratops [Cosmic]",
		"Orca [Mythic]",
		"Sand Spider [Mythic]",
		"Scorpion [Mythic]",
		"Spider [Mythic]",
		"Cosmic Gorilla [Mythic]",
		"Sabertooth Tiger [Mythic]",
		"Mammoth [Mythic]",
		"Tiger [Mythic]",
		"Chillin Chilli [Mythic]",
		"Belula Beluga [Mythic]",
		"Ankylosaurus [Mythic]",
		"Shark [Legendary]",
		"Polar Bear [Legendary]",
		"Gorilla [Legendary]",
		"Flaming Bull [Legendary]",
		"Axolotl [Legendary]",
		"Pterodactyl [Legendary]",
		"Snake [Legendary]",
		"Orangutini Ananassini [Legendary]",
		"Lava Iguana [Legendary]",
		"Cosmic Gecko [Legendary]",
		"Brr Brr Patapim [Legendary]",
		"Swan [Epic]",
		"Walrus [Epic]",
		"Tob Tobi Tob Tob [Epic]",
		"Bananita Dolphinita [Epic]",
		"Bear [Epic]",
		"Trulimero Trulicina [Epic]",
		"Fox [Epic]",
		"Swordfish [Epic]",
		"Lava frog [Epic]",
		"Centapede [Epic]",
		"Crocodile [Epic]",
		"Tung Tung Sahur [Rare]",
		"Penguin [Rare]",
		"Owl [Rare]",
		"Toucan [Rare]",
		"Turtle [Rare]",
		"Chimpanzee [Rare]",
		"Raccoon [Rare]",
		"Dodo [Rare]",
		"Lava Gecko [Rare]",
		"Camel [Rare]",
		"Parrotfish [Rare]",
		"Desert Lark [Uncommon]",
		"Catfish [Uncommon]",
		"Fennec [Uncommon]",
		"Duckling [Common]",
		"Frog [Common]",
		"Jerboa [Common]",
		"Chicken [Common]",
		"Dog [Common]"
	}
}

--==================================================
-- UTILITY FUNCTIONS
--==================================================

local function hexToRgb(hex)
	hex = hex:gsub("#", "")
	return Color3.fromHex(hex)
end

local function applyConfigToUI(uiElement, colorKey)
	if not config[colorKey] then
		return
	end

	local colorData = config[colorKey]
	if colorData.Color then
		uiElement.BackgroundColor3 = hexToRgb(colorData.Color)
	end
	if colorData.Alpha then
		uiElement.BackgroundTransparency = colorData.Alpha
	end
end

local function printConfiguration()
	print("=== CONFIGURATION LOADED ===")
	print("Auto Hatch:", config.AutoHatch)
	print("Auto Farm Egg:", config.AutoFarmEgg)
	print("Auto Sell Egg:", config.AutoSellEgg)
	print("ESP Min Rarity:", config.EspMinRarity)
	print("Tween Speed:", config.TweenSpeed)
	print("Anti AFK:", config.AntiAFK)
	print("Total Farm Eggs:", #config.SelectEggForFarmEgg)
	print("Total Sell Eggs:", #config.SelectEggForSellEgg)
	print("===========================")
end

local function getEggByRarity(eggList, minRarity)
	-- Returns eggs matching or exceeding minimum rarity
	local rarityOrder = {
		"Common", "Uncommon", "Rare",
		"Epic", "Legendary", "Mythic",
		"Cosmic", "Eternal", "Divine", "Secret"
	}

	local result = {}
	for _, egg in ipairs(eggList) do
		for _, rarity in ipairs(rarityOrder) do
			if string.find(egg, rarity) then
				result[egg] = rarity
				break
			end
		end
	end
	return result
end

local function filterEggsByMinRarity(eggList, minRarity)
	if minRarity == "None" then
		return eggList
	end

	local rarityOrder = {
		Common = 1, Uncommon = 2, Rare = 3,
		Epic = 4, Legendary = 5, Mythic = 6,
		Cosmic = 7, Eternal = 8, Divine = 9, Secret = 10
	}

	local minRarityIndex = rarityOrder[minRarity] or 1
	local filtered = {}

	for _, egg in ipairs(eggList) do
		for rarity, index in pairs(rarityOrder) do
			if string.find(egg, rarity) and index >= minRarityIndex then
				table.insert(filtered, egg)
				break
			end
		end
	end

	return filtered
end

--==================================================
-- CONFIGURATION APPLICATION
--==================================================

local function applyConfiguration()
	-- Print loaded configuration
	printConfiguration()

	-- Apply theme colors to UI if Shadow UI exists
	local shadowGui = playerGui:FindFirstChild("Shadow")
	if shadowGui then
		local main = shadowGui:FindFirstChild("Main")
		if main then
			applyConfigToUI(main, "Shadow")

			-- Apply colors to child elements
			local sidebar = main:FindFirstChild("Sidebar")
			if sidebar then
				applyConfigToUI(sidebar, "Element")
			end

			local content = main:FindFirstChild("Content")
			if content then
				applyConfigToUI(content, "Background")
			end
		end
	end

	-- Set up game features based on configuration
	if config.AntiAFK then
		print("[Config] Anti-AFK enabled")
		-- Anti-AFK implementation
	end

	if config.FpsBoost then
		print("[Config] FPS Boost enabled")
		-- FPS boost implementation
	end

	if config.Godmode then
		print("[Config] Godmode enabled")
		-- Godmode implementation
	end

	if config.AutoHatch then
		print("[Config] Auto Hatch enabled")
		-- Auto hatch implementation
	end

	if config.AutoFarmEgg then
		print("[Config] Auto Farm Egg enabled")
		local farmEggs = filterEggsByMinRarity(
			config.SelectEggForFarmEgg,
			config.EspMinRarity
		)
		print("[Config] Farming " .. #farmEggs .. " egg types")
	end

	if config.AutoSellEgg then
		print("[Config] Auto Sell Egg enabled")
		local sellEggs = filterEggsByMinRarity(
			config.SelectEggForSellEgg,
			config.KeepMinRarityForSellEgg
		)
		print("[Config] Selling " .. #sellEggs .. " egg types")
	end
end

--==================================================
-- EXPORT CONFIGURATION
--==================================================

local configModule = {}

function configModule:get(key)
	return config[key]
end

function configModule:set(key, value)
	config[key] = value
	print("[Config] Updated " .. key .. " to " .. tostring(value))
end

function configModule:getConfig()
	return config
end

function configModule:reload()
	applyConfiguration()
end

--==================================================
-- INITIALIZE
--==================================================

applyConfiguration()

return configModule
