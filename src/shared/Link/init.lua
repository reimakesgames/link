local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Connection = require(script.Connection)

local Folder = ReplicatedStorage:WaitForChild("__Link")

local Link = {
	Connections = {}
}

function Link.CreateLink(Type: "RemoteEvent" | "RemoteFunction", Name: string)
	if Type ~= "RemoteEvent" and Type ~= "RemoteFunction" then
		error("Type must be RemoteEvent or RemoteFunction")
	end

	local NewConnection = Connection.new(Type, Name)
	table.insert(Link.Connections, NewConnection)
	return NewConnection
end

function Link.ConnectTo(Name: string)
	return Folder:WaitForChild(Name).OnClientEvent
end

return Link
