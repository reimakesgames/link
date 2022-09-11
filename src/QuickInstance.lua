return function(class, parent, props)
	local NewInstance = Instance.new(class)
	for k, v in pairs(props) do
		NewInstance[k] = v
	end
	if parent then
		NewInstance.Parent = parent
	end
	return NewInstance
end
