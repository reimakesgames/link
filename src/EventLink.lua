local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Packages = script.Parent.Parent

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

export type EventLink = {
	__CommunicationType: "event" | "function";
	__Remote: RemoteEvent | RemoteFunction;

	FireClient: (Player: Player, ...any) -> ();
	FireAllClients: (...any) -> ();
	FireSelectedClients: (Array<Player>) -> ();
	FireServer: (...any) -> ();
	Event: FastSignal.Class
}

local EventLink = {}
EventLink.__index = EventLink

function EventLink:FireClient(player: Player, ...)
	IsServer("Connection:FireClient()")
	self.__Remote:FireClient(player, ...)
end

function EventLink:FireAllClients(...)
	IsServer("Connection:FireAllClients()")
	self.__Remote:FireAllClients(...)
end

function EventLink:FireSelectedClients(selectedPlayers: Array<Player>, whitelist: boolean, ...)
	IsServer("Connection:FireSelectedClients()")
	for _, Player in Players:GetPlayers() do
		local Selected = typeof(table.find(selectedPlayers, Player)) == "number"
		if Selected == whitelist then
			self.__Remote:FireClient(Player, ...)
		end
	end
end

function EventLink:FireServer(...)
	IsClient("Connection:FireServer()")
	self.__Remote:FireServer(...)
end

function EventLink.new(name: string, where: Folder)
	IsServer("Connection.new()")
	local Remote = QuickInstance("RemoteEvent", where, {
		-- Name = "Remote_" .. AddZero(Connections),
		Name = name,
	})

	local self = {
		__CommunicationType = "RemoteEvent",
		__Remote = Remote,

		Event = FastSignal.new(),
	}
	self.__Remote.OnServerEvent:Connect(function(Player, ...)
		self.Event:Fire(Player, ...)
	end)
	return setmetatable(self, {__index = EventLink})
end

function EventLink.__newclient(remote)
	local self = {
		__CommunicationType = "RemoteEvent",
		__Remote = remote,

		Event = FastSignal.new(),
	}
	self.__Remote.OnClientEvent:Connect(function(...)
		self.Event:Fire(...)
	end)
	return setmetatable(self, {__index = EventLink})
end

return EventLink
