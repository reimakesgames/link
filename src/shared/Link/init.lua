local REMOTE_PREFIX = "REMOTE_"
local REMOTE_SUFFIX = ""

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EventLink = require(script.EventLink)
local QuickInstance = require(script.QuickInstance)

local Folder = ReplicatedStorage:FindFirstChild("__Link") or QuickInstance("Folder", ReplicatedStorage, {Name = "__Link"})

local Link = {
	Connections = {}
}

function Link.CreateEvent(Name: string)
	local NewConnection = EventLink.new(REMOTE_PREFIX .. Name .. REMOTE_SUFFIX, Folder)
	table.insert(Link.Connections, NewConnection)
	return NewConnection
end

function Link.ConnectTo(Name: string)
	return Folder:WaitForChild(REMOTE_PREFIX .. Name .. REMOTE_SUFFIX).OnClientEvent
end

return Link
