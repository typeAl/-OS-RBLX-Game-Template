local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local ServerModules = ServerStorage:WaitForChild("Modules")

local Libraries = ServerModules:WaitForChild("Libraries")

local ServerLib = require(Libraries:WaitForChild("ServerLib"))

local ProfileService = require(script:WaitForChild("ProfileService"))
local DataTemplate = require(script:WaitForChild("DataTemplate"))
local DataStoreProperties = require(script:WaitForChild("Properties"))

local DataStore = ProfileService.GetProfileStore(DataStoreProperties.Name, DataTemplate)

local DataManager = {}

function DataManager:PlayerAdded(Player : Player)
	local success, profile = pcall(function()
		if DataStoreProperties.isMocking then
			DataStore = DataStore.Mock
			print("Mocking: " ..DataStore.Mock)
		end
		return DataStore:LoadProfileAsync("Player" .. Player.UserId)
	end)

	if success and profile then
		profile:AddUserId(Player.UserId)

		local releaseConnection
		releaseConnection = profile:ListenToRelease(function()
			ServerLib.DataProfiles[Player] = nil
			Player:Kick()
			releaseConnection:Disconnect()
		end)

		if Player:IsDescendantOf(Players) then
			ServerLib.DataProfiles[Player] = profile
			print(Player.Name .. " has joined")
			warn("Done")
		else
			profile:Release()
		end
	else
		Player:Kick("Failed to load Player profile.")
	end
end

function DataManager:PlayerRemoving(Player)
	ServerLib.DataProfiles[Player] = nil
end

return DataManager
