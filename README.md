# Link
A simplistic, close to Roblox, RemoteEvent/RemoteFunction wrapper.

## Why Link?
Link is an easily extensible networking wrapper.
It can support middleware to enable features like serialization and deserialization, without the need to complicate your inputted data.

## Features
<!-- * Middleware(s) -->
<!-- * Serialization -->
<!-- * Deserialization -->
* Basic RemoteEvent/RemoteFunction features
* Pseudo-remotes to allow easier VSCode integration

# API
## Link

### Link:CreateEvent(name: *string*): *[EventLink](#connection)*
Creates a new Event.
```lua
local ExampleEvent = Link:CreateEvent("Event")
```

### Link:FindEvent(name: *string*):  *[EventLink](#connection) | nil*
Finds the event within the Connections table. Returns nil if not found. <br>
Works similarly to `Instance:FindFirstChild`.
```lua
local ExampleEvent = Link:FindEvent("EventName")
```

### Link:WaitEvent(name: *string*, timeout: *number?*): *[EventLink](#connection)*
Waits for the event in the Connections table.
> This method yields the current thread until the event is found.

```lua
local ExampleEvent = Link:WaitEvent("EventName")
local ExampleEvent = Link:WaitEvent("EventName", 5)
```

### Link:CreateFunction(name: *string*): *[FunctionLink](#connection)*
Creates a new Function.
```lua
local ExampleFunction = Link:CreateFunction("Function")
```

### Link:FindFunction(name: *string*): *[FunctionLink](#connection) | nil*
Finds the function within the Connections table. Returns nil if not found. <br>
Works similarly to `Instance:FindFirstChild`.
```lua
local ExampleFunction = Link:FindFunction("FunctionName")
```

### Link:WaitFunction(name: *string*, timeout: *number?*): *[FunctionLink](#connection)*
Waits for the function in the Connections table.
> This method yields the current thread until the function is found.

```lua
local ExampleFunction = Link:WaitFunction("FunctionName")
local ExampleFunction = Link:WaitFunction("FunctionName", 5)
```

### Link:Connections: { [*string*]: *[EventLink](#connection)* | *[FunctionLink](#connection)* }

The dictionary where the connections are stored

example:
| Key | Value |
| ---- | ---- |
| Prefix_Name_Suffix | [EventLink](#connection) |
| REMOTE_Name | [FunctionLink](#connection) |

<!-- </details> -->

## Event

### EventLink:FireClient(player: *Player*, ...*any*): *nil*
> Server -> Client

Fires the event to the specified player.
```lua
local ExampleEvent = Link:CreateEvent("Event")
ExampleEvent:FireClient(player, "Hello", "World")
```

### EventLink:FireAllClients(...*any*): *nil*
> Server -> All Clients

Fires every player within the game
```lua
local ExampleEvent = Link:CreateEvent("Event")
ExampleEvent:FireAllClients("Hello", "World")
```

### EventLink:FireClients(selectedPlayers: *Array\<Players\>*, ...*any*): *nil*
> Server -> Selected Clients

Fires the selected players within the array
```lua
local ExampleEvent = Link:CreateEvent("Event")
ExampleEvent:FireClients({player1, player2}, "Hello", "World")
```

### EventLink:FireClientsExcept(excludedPlayers: *Array\<Players\>*, ...*any*): *nil*
> Server -> All Clients Except Selected

Fires every player within the game, except the selected players within the array
```lua
local ExampleEvent = Link:CreateEvent("Event")
ExampleEvent:FireClientsExcept({player1, player2}, "Hello", "World")
```

### EventLink:FireServer(...*any*): *nil*
> Client -> Server

Fires to the server with the provided parameters
```lua
local ExampleEvent = Link:WaitEvent("Event")
ExampleEvent:FireServer("Hello", "World")
```

### EventLink.Event: *[FastSignal.Class](https://github.com/RBLXUtils/FastSignal/blob/main/src/ReplicatedStorage/FastSignal/Deferred.lua#L26-L29)*
Event you can connect to.

```lua
local Event = Link:CreateEvent("Event")
ExampleEvent.Event:Connect(function(...)
	print(...)
end)
```

## Function

### FunctionLink:InvokeClient(player: *Player*, ...*any*): *any*
> Server -> Client <br>
Yields

Considered by Roblox as unsafe. Use with caution. <br>
Invokes the specified player with the provided parameters.
```lua
local ExampleFunction = Link:CreateFunction("Function")
local result = ExampleFunction:InvokeClient(player, "Hello", "World")
```
### FunctionLink:InvokeServer(...*any*): *any*
> Client -> Server <br>
Yields

Invokes the server with the provided parameters.
```lua
local ExampleFunction = Link:WaitFunction("Function")
local result = ExampleFunction:InvokeServer("Hello", "World")
```

### FunctionLink:OnClientInvoke(callback: (...*any*) -> *any*): *nil*)
> Similar to RemoteFunction.OnClientInvoke

A setter for the OnClientInvoke callback which is called when the server invokes the client.
```lua
local ExampleFunction = Link:CreateFunction("Function")
ExampleFunction:OnClientInvoke(function(...)
	print(...)
	return true
end)
```

### FunctionLink:OnServerInvoke(callback: (player: Player, ...*any*) -> *any*): *nil*)
> Similar to RemoteFunction.OnServerInvoke

A setter for the OnServerInvoke callback which is called when the client invokes the server.
```lua
local ExampleFunction = Link:CreateFunction("Function")
ExampleFunction:OnServerInvoke(function(player, ...)
	print("Player", player.Name, "invoked the server with", ...)
	return true
end)
```
