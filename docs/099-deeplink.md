---
title: Using Roblox Deep-Linking
id: deep-linking
---

# Give rewards based on traffic from the D2 app

In addition to providing the D2 SDK, we've also integrated Roblox' deep linking system into our app. The short version is that we can provide users entering your Roblox experience with some data from the D2 app, you can then use that data to provide the user a special D2 item, currency or similar.

Do note that this data will be exposed client-side, so don't put any sensitive information in it, and treat this more akin to a promo code than a secure authentication method.

### How to use

Reach out to us via email [oscar.halland@karta.game](mailto:oscar.halland@karta.game) to get access to this feature. It requires some manual setup on our end, but once we've added you to the list, you can use the following code to get the data:

:::warning

The below code has to be executed on server-side!

:::

```lua
local Players = game:GetService("Players")

local function parseSourceFromLaunchData(input: any): string?
	if typeof(input) ~= "string" then
		return nil
	end

	-- Format of the valid D2 launchData should be source_<data>
	local parts = input:split("_")
	if #parts < 2 then
		return nil
	end

	-- The key is the first part of the string (source)
	local key = parts[1]

	-- If the key is not source, return
	if key ~= "source" then
		return nil
	end

	-- The value is the rest of the string after the key and the underscore (source_)
	return input:sub(#key + 2)
end

Players.PlayerAdded:Connect(function(player: Player)
	local joinData = player:GetJoinData()
	local source = parseSourceFromLaunchData(joinData.LaunchData)

	-- If the value is not d2_promotion, return
	if source ~= "d2_promotion" then
		return
	end

	-- If the value is d2_promotion, then we can give the player a reward
	warn("D2 promotion detected!")
end)
```
