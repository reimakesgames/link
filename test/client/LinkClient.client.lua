local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Link = require(ReplicatedStorage.Packages.Link)

local Connection = Link.WaitConnection("LP", 10)

Connection.Event:Connect(function(...)
	print(...)
end)
