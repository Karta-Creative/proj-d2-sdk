---
title: Deep-linking
id: deep-linking
---

# D2 -> Roblox via deep links

In addition to providing the D2 SDK, we've also integrated Roblox' deep linking system into our app. The short version is that we can provide users entering your Roblox experience with some data from the D2 app, you can then use that data to provide the user a special D2 item, currency or similar. 

Do note that this data will be exposed client-side, so don't put any sensitive information in it, and treat this more akin to a promo code than a secure authentication method.

### How to use
Reach out to us via email [oscar.halland@karta.game](mailto:oscar.halland@karta.game) to get access to this feature. It requires some manual setup on our end, but once we've added you to the list, you can use the following code to get the data:

```lua
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

Players.PlayerAdded:Connect(function(player: Player)
    local joinData = player:GetJoinData()

    if joinData.LaunchData then
        local parsedLaunchData = HttpService:JSONDecode(joinData.LaunchData)

        if parsedLaunchData.source and parsedLaunchData.source == "d2_promotion" then
            warn("D2 promotion detected!")
        end
    end
end)
```

```lua
local TeleportService = game:GetService("TeleportService")

local teleportData = TeleportService:GetLocalPlayerTeleportData()

if teleportData then
    local parsedTeleportData = HttpService:JSONDecode(teleportData)

    if parsedTeleportData.source and parsedTeleportData.source == "d2_promotion" then
        warn("D2 promotion detected!")
    end
end
```
