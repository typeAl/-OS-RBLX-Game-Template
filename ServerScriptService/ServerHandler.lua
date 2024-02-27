debug.profilebegin("Main Loader")
debug.setmemorycategory("Main Loader")

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local ServerModules = ServerStorage:WaitForChild("Modules")

local Managers = ServerModules:WaitForChild("Managers")
local Libraries = ServerModules:WaitForChild("Libraries")

local Client = Remotes:WaitForChild("Client")

local DataManager = require(Managers:WaitForChild("DataManager"))
local StatusManager = require(Managers:WaitForChild("StatusManager"))

local CachedModules = {};

Players.PlayerAdded:Connect(function(Player)
	DataManager:PlayerAdded(Player)
	
	Player.CharacterAdded:Connect(function(Character)
		StatusManager.new(Character)
	end)
end)

Players.PlayerRemoving:Connect(function(Player)
	DataManager:PlayerRemoving(Player)
	
	Player.CharacterRemoving:Connect(function(Character)
		StatusManager:EntityRemoval(Character)
	end)
end)

game:BindToClose(function()
	print("Insert your logic here.")
end)

Client.OnServerEvent:Connect(function(Player, Args)
	if typeof (Args) ~= "table" then
		return
	end
	
	local Module = Args.Module
	local Function = Args.Function
	local Information = Args.Information

	if CachedModules[Module] and CachedModules[Module][Function] then
		pcall(function()
			CachedModules[Module][Function](Player, Information)
		end)
	end
end)

for _, Module in ipairs(ServerModules.Loaders:GetDescendants()) do
	if Module:IsA("ModuleScript") then
		CachedModules[Module.Name] = require(Module)
	end
end

debug.profileend()
