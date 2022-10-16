local RunService = game:GetService("RunService")

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

export type FunctionLink = {
	__CommunicationType: "event" | "function";
	__Remote: RemoteFunction;

	InvokeServer: (...any) -> (...any);
	InvokeClient: (Player: Player, ...any) -> (...any);
	OnClientInvoke: (...any) -> (...any);
	OnServerInvoke: (Player: Player, ...any) -> (...any);
}

local FunctionLink = {}
FunctionLink.__index = FunctionLink

function FunctionLink:InvokeServer(...)
	IsClient("Connection:InvokeServer()")
	return self.__Remote:InvokeServer(...)
end

function FunctionLink:InvokeClient(player: Player, ...)
	print("WARNING: You are using InvokeClient! Roblox Documentation does not recommend using InvokeClient.")
	IsServer("Connection:InvokeClient()")
	self.__Remote:InvokeClient(player, ...)
end

function FunctionLink:OnServerInvoke(callback: (player: Player, ...any) -> (...any))
	self.OnServerInvoke = callback
	self.__Remote.OnServerInvoke = self.OnServerInvoke
end

function FunctionLink:OnClientInvoke(callback: (player: Player, ...any) -> (...any))
	self.OnClientInvoke = callback
	self.__Remote.OnClientInvoke = self.OnClientInvoke
end

function FunctionLink.new(name: string, where: Folder)
	IsServer("Connection.new()")
	local Remote = QuickInstance("RemoteFunction", where, {
		-- Name = "Remote_" .. AddZero(Connections),
		Name = name,
	})

	local self = {
		__CommunicationType = "RemoteFunction",
		__Remote = Remote,
	}
	return setmetatable(self, {
		__index = FunctionLink;
	})
end

function FunctionLink.__newclient(remote)
	local self = {
		__CommunicationType = "RemoteFunction",
		__Remote = remote,
	}
	return setmetatable(self, {
		__index = FunctionLink;
	})
end

return FunctionLink
