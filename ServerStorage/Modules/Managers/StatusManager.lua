local ServerStorage = game:GetService("ServerStorage")

local ServerModules = ServerStorage:WaitForChild("Modules")

local Libraries = ServerModules:WaitForChild("Libraries")

local ServerLib = require(Libraries:WaitForChild("ServerLib"))

local StatusManager = {}
StatusManager.__index = StatusManager

function StatusManager.new(Entity)
	if ServerLib.EntityStatus[Entity] then
		return ServerLib.EntityStatus[Entity]
	else
		ServerLib.EntityStatus[Entity] = setmetatable({
			["Attacking"] = false,
			["Blocking"] = false,
			["Combo"] = 1,
			["Stunned"] = false,
		}, StatusManager)
	end
end

function StatusManager:GetStatus(Entity, Status)
	if ServerLib.EntityStatus[Entity] then
		return ServerLib.EntityStatus[Entity][Status]
	else
		warn("Entity: " ..Entity.. " | Status: " ..Status)
	end
end

function StatusManager:SetStatus(Entity, Status, Value)
	if ServerLib.EntityStatus[Entity] and ServerLib.EntityStatus[Entity][Status] then
		return ServerLib.EntityStatus[Entity][Status][Value]
	else
		warn("Entity: " ..Entity.. " | Status: " ..Status.. " | Value: " ..Value)
	end
end

function StatusManager:EntityRemoval(Entity)
	ServerLib.EntityStatus[Entity] = nil
end

return StatusManager
