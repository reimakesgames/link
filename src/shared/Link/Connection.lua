local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local FastSignal = require(Packages.fastsignal)

local IsServer = RunService:IsServer()
local IsClient = RunService:IsClient()

export type Connection = {
	__CommunicationType: "event" | "function";
	__Remote: RemoteEvent | RemoteFunction;
	Send: (any: any) -> ();
	Recieve: FastSignal.Class;
}

local Connection = {}

function Connection.Send(self, ...)
	self.__Remote:Fire(...)
end

function Connection.Recieve(self)
	return self.__Remote.OnServerEvent
end

function Connection.new()

return Connection
