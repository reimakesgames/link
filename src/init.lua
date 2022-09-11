local REMOTE_PREFIX = "REMOTE_"
local REMOTE_SUFFIX = ""

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventLink = require(script.EventLink)
local QuickInstance = require(script.QuickInstance)

local IsClient = RunService:IsClient()

local Folder = ReplicatedStorage:FindFirstChild("__Link") or QuickInstance("Folder", ReplicatedStorage, {Name = "__Link"})

local Link = {
	Connections = {}
}

if IsClient then
	Folder.ChildAdded:Connect(function(Child)
		local NewConnection = EventLink.__newclient(Child)
		Link.Connections[Child.Name] = NewConnection
	end)

	for _, Remote in Folder:GetChildren() do
		local NewConnection = EventLink.__newclient(Remote)
		Link.Connections[Remote.Name] = NewConnection
	end
end

function Link.CreateEvent(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	local NewConnection = EventLink.new(IndexName, Folder)
	Link.Connections[IndexName] = NewConnection
	return NewConnection
end

function Link.WaitEvent(name: string, timeout: number)
	local Start = time()
	local Timeout = Start + (timeout or 86400)
	repeat
		local Connection = Link.FindConnection(name)
		if Connection then
			return Connection
		end
		RunService.Heartbeat:Wait()
	until Timeout <= time()
	return nil
end

function Link.FindEvent(name: string)
	local IndexName = REMOTE_PREFIX .. name .. REMOTE_SUFFIX
	return Link.Connections[IndexName]
end

return Link
