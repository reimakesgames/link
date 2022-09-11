local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Link = require(ReplicatedStorage.Packages.Link)

print("waiting...")
task.wait(5)
print("here we go!")
local Real = Link.CreateEvent("LP")
while true do
	Real:FireAllClients("One thing, I don't know why")
	print("It doesn't even matter how hard you try")
	print("keep that in mind, i designed this rhyme")
	print("to explain in due time, all i know")
	task.wait(5)
end