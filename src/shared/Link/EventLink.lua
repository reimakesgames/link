local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Packages = ReplicatedStorage.Packages

local FastSignal = require(Packages.fastsignal)
local QuickInstance = require(script.Parent.QuickInstance)

local function IsServer(method)
	if RunService:IsClient() then
		error(method .. " can only be called on the server")
	end
end

local function IsClient(method)
	if RunService:IsServer() then
		error(method .. " can only be called on the client")
	end
end

local function FindLinkFolder()
	local LinkFolder = ReplicatedStorage:FindFirstChild("__Link")
	if not LinkFolder then
		LinkFolder = QuickInstance.new("Folder", ReplicatedStorage, {
			Name = "__Link",
		})
	end
	return LinkFolder
end

-- local function AddZero(number)
-- 	if number < 10 then
-- 		return "0" .. number
-- 	end
-- 	return number
-- end

export type Connection = {
	__CommunicationType: "event" | "function";
	__Remote: RemoteEvent | RemoteFunction;

	FireClient: (Player: Player, ...any) -> ();
	FireAllClients: (...any) -> ();
	FireSelectedClients: (Array<Player>) -> ();
	FireServer: (...any) -> ();
}

local Connection = {}
Connection.__index = Connection

function Connection:FireClient(Player: Player, ...)
	IsServer("Connection:FireClient()")
	self.__Remote:FireClient(Player, ...)
end

function Connection:FireAllClients(...)
	IsServer("Connection:FireAllClients()")
	self.__Remote:FireAllClients(...)
end

function Connection:FireSelectedClients(SelectedPlayers: Array<Player>, Whitelist: boolean, ...)
	IsServer("Connection:FireSelectedClients()")
	Whitelist = Whitelist or true
	for _, Player in Players:GetPlayers() do
		if table.find(SelectedPlayers, Player) == Whitelist then
			self.__Remote:FireClient(Player, ...)
		end
	end
end

function Connection:FireServer(...)
	IsClient("Connection:FireServer()")
	self.__Remote:FireServer(...)
end

function Connection.new(Name: string)
	IsServer("Connection.new()")
	FindLinkFolder()
	local Remote = QuickInstance.new("RemoteEvent", FindLinkFolder(), {
		-- Name = "Remote_" .. AddZero(Connections),
		Name = "Remote_" .. Name,
	})

	local self = {
		__CommunicationType = "RemoteEvent",
		__Remote = Remote,
	}
	return setmetatable(self, {__index = Connection})
end

return Connection
