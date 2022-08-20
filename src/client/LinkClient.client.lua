local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Link = require(ReplicatedStorage.Shared.Link)

local Real = Link.ConnectTo("LP")
Real:Connect(function(...)
	print(...)
end)