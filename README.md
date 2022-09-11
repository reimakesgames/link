# Link
A simple, lightweight, networking Library.

## Why Link?
Link is an easily extensible networking library.
It supports middleware to enable features like serialization and deserialization, without the need to complicate your inputted data.

## Features
* Middleware(s)
* Serialization
* Deserialization
* Pseudo-remotes to allow easier VSCode integration

# API
## Link
<details>
<summary>Methods</summary>
<br>

**Link.CreateEvent(name: *string*): *[Connection](#connection)***

---

**Link.FindEvent(name: *string*):  *[Connection](#connection) | nil***

Finds the event within the Connections table

---

`Yields`
**Link.WaitEvent(name: *string*, timeout: *number*): *[Connection](#connection)***

Waits for the event in the Connections table

</details>

<details>
<summary>Properties</summary>
<br>

**Link.Connections: { [*string*]: *[Connection](#connection)* }**

The dictionary where the connections are stored

example:
| Key | Value |
| ---- | ---- |
| Prefix_Name_Suffix | [Connection](#connection) |
| REMOTE_Name | [Connection](#connection) |

</details>

## Connection
### Event
<details>
<summary>Methods</summary>
<br>

`ServerOnly` **Connection.FireClient(player: *Player*, ...*any*): *nil***

Fires the provided player, just like the stock ROBLOX RemoteEvents

`ServerOnly` **Connection.FireAllClients(...*any*): *nil***

Fires every player within the game

`ServerOnly` **Connection.FireSelectedClients(selectedPlayers: *Array\<Players\>*, whitelist: *boolean*, ...*any*): *nil***

Fires the selected players within the array<br>
If whitelist is true, then it fires the players within the array,<br>
And if it isn't, then it fires every other player than the ones in the array.

`ClientOnly` **Connection.FireServer(...*any*): *nil***

Fires to the server with the provided parameters

</details>

<details>
<summary>Properties</summary>
<br>

**Connection.Event: *[FastSignal.Class](https://github.com/RBLXUtils/FastSignal/blob/main/src/ReplicatedStorage/FastSignal/Deferred.lua#L26-L29)***

Signal you can connect to.<br>
this is .OnServerEvent/.OnClientEvent merged onto one property

</details>

### Function

Soon... :3