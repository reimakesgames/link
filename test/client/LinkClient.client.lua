local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Link = require(ReplicatedStorage.Shared.Link)

Link.ConnectTo("LP", function(...)
	print(...)
end)