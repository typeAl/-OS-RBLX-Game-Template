--[ Never intended to be completed. Users need to add their own logic into this module. ]--

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")

local Client = Remotes:WaitForChild("Client")

local CombatHandler = {
	["Light"] = function(Player, Args)
		Args = "Light Server"
		print(Args)
		
		Client:FireAllClients({
			Module = "CombatVFX",
			Function = "LightHit",
			Information = "Hit Client"
		})
	end,
	
	["Heavy"] = function(Player, Args)
		Args = "Heavy Server"
		print(Args)
		
		Client:FireAllClients({
			Module = "CombatVFX",
			Function = "HeavyHit",
			Information = "Hit Client"
		})
	end,
}

return CombatHandler
