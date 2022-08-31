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

function Link.CreateEvent(Name: string)
	local IndexName = REMOTE_PREFIX .. Name .. REMOTE_SUFFIX
	local NewConnection = EventLink.new(IndexName, Folder)
	Link.Connections[IndexName] = NewConnection
	return NewConnection
end

function Link.ConnectTo(Name: string, Handler: (...any) -> ())
	if not Handler then
		error("where is the handler function??")
	end
	local IndexName = REMOTE_PREFIX .. Name .. REMOTE_SUFFIX

	return Link.Connections[IndexName].Event:Connect(Handler)
end

return Link
