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
