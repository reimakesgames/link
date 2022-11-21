local REMOTE_PREFIX = "REMOTE_"
local REMOTE_SUFFIX = ""
local DEFAULT_TIMEOUT = 60

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventLink = require(script.EventLink)
local FunctionLink = require(script.FunctionLink)
local QuickInstance = require(script.QuickInstance)

local IS_CLIENT = RunService:IsClient()

local Folder = ReplicatedStorage:FindFirstChild("__Link") or QuickInstance("Folder", ReplicatedStorage, {Name = "__Link"})

export type Link = {
	Connections: {[string]: EventLink.EventLink | FunctionLink.FunctionLink};
	CreateEvent: (any, name: string) -> (EventLink.EventLink);
	WaitEvent: (any, name: string, timeout: number?) -> (EventLink.EventLink?);
	FindEvent: (any, name: string) -> (EventLink.EventLink?);
	CreateFunction: (any, name: string) -> (FunctionLink.FunctionLink);
	WaitFunction: (any, name: string, timeout: number?) -> (FunctionLink.FunctionLink?);
	FindFunction: (any, name: string) -> (FunctionLink.FunctionLink?);
}

local Link = {
	Connections = {}
}

if IS_CLIENT then
	Folder.ChildAdded:Connect(function(child)
		if child:IsA("RemoteEvent") then
			local NewConnection = EventLink.__newclient(child)
			Link.Connections[child.Name] = NewConnection
		elseif child:IsA("RemoteFunction") then
			local NewConnection = FunctionLink.__newclient(child)
			Link.Connections[child.Name] = NewConnection
		end
	end)

	for _, child in Folder:GetChildren() do
		if child:IsA("RemoteEvent") then
			local NewConnection = EventLink.__newclient(child)
			Link.Connections[child.Name] = NewConnection
		elseif child:IsA("RemoteFunction") then
			local NewConnection = FunctionLink.__newclient(child)
			Link.Connections[child.Name] = NewConnection
		end
	end
end

function Link:CreateEvent(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	if Link.Connections[IndexName] then
		error("Duplicate connection found for >>".. name .."<<. Consider making a new unique name. Your Event was not created.")
	end
	local NewConnection = EventLink.new(IndexName, Folder)
	Link.Connections[IndexName] = NewConnection
	return NewConnection
end

function Link:WaitEvent(name: string, timeout: number?)
	local Start = time()
	local Timeout = Start + (timeout or DEFAULT_TIMEOUT)
	repeat
		local Connection = Link:FindEvent(name)
		if Connection then
			return Connection
		end
		RunService.Heartbeat:Wait()
	until Timeout <= time()
end

function Link:FindEvent(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	return Link.Connections[IndexName]
end

function Link:CreateFunction(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	if Link.Connections[IndexName] then
		error("Duplicate connection found for >>".. name .."<<. Consider making a new unique name. Your Function was not created.")
	end
	local NewConnection = FunctionLink.new(IndexName, Folder)
	Link.Connections[IndexName] = NewConnection
	return NewConnection
end

function Link:WaitFunction(name: string, timeout: number?)
	local Start = time()
	local Timeout = Start + (timeout or DEFAULT_TIMEOUT)
	repeat
		local Connection = Link:FindFunction(name)
		if Connection then
			return Connection
		end
		RunService.Heartbeat:Wait()
	until Timeout <= time()
end

function Link:FindFunction(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	return Link.Connections[IndexName]
end


return Link
