-- API (Don't mess with if you do not know what you are doing.)
PlayerVar = {}
Players = {}

PlayerVar.Player = {}
PlayerVar.Player.__index = PlayerVar.Player

setmetatable(PlayerVar.Player, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

function PlayerVar.Player.new(PlayerName, PlayerID)
  local self = setmetatable({}, PlayerVar.Player)
  self.Name = PlayerName
  self.Vars = {}
  self.Id = PlayerID
  return self
end

function PlayerVar.Player:SetVar(Name, Value)
	self.Vars[Name] = Value
	TriggerEvent('PV:updatePlayer', self.Id, Name, Value)
end

function PlayerVar.Player:GetVar(Name)
	return self.Vars[Name]
end

function PlayerVar.Player:delete()
	Players[self.Id] = nil
end


function PlayerVar:getPlayerByName(name)
	for i, v in pairs(Players) do
		if v.Name == name then
			return v.Id
		end
	end
	return false
end

-- EVents
RegisterServerEvent("PV:playerListUpdate")
RegisterServerEvent("PV:playerAdded")
RegisterServerEvent("PV:playerRemoved")
RegisterServerEvent("PV:updatePlayer")

AddEventHandler('PV:playerListUpdate', function(list)
	Players = list
end)

AddEventHandler('PV:playerAdded', function(Player)
	Players[Player.Id] = Player
end)

AddEventHandler('PV:playerRemoved', function(PlayerID)
	Players[PlayerID] = nil
end)

AddEventHandler('PV:updatePlayer', function(PlayerID, Name, Value)
	Players[PlayerID].Vars[Name] = Value
end)

-- Re/Loaded resource
function AllPlayers()
	local pls = {}
	-- GetPlayerServerId(i)
    for i = 0, 31 do
        if (GetPlayerName(i) ~= nil) then
            table.insert(pls, i)
        end
    end
    return pls
end

-- GetPlayers() Is broken duck me
local ptable = AllPlayers()
for i,v in pairs(ptable) do
	Players[i] = PlayerVar.Player(GetPlayerName(v), v)
	print("[SM] Adding " .. Players[i].Name .. " with ID " .. Players[i].Id)
end

--[[

Important Functions/Var

Player.Name > Name
Player.ID > ID from source

Player:SetVar(Name, Var)
Player:GetVar(Name)

Ex:
local Player = PlayerVar.Players[source]

Player:SetVar("Score", 100)

local Score = Player:GetVar("Score") > 100

]]