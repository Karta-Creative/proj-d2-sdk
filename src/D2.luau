local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local GAME_ID = 1

--[=[
	@interface Profile
	@within D2

	@field id string
	@field avatar_url string
	@field full_name string
	@field username string
	@field is_walking boolean
	@field steps_all_time number
	@field steps_today number
	@field updated_at string
]=]
type Profile = {
	id: string,
	avatar_url: string,
	full_name: string,
	username: string,
	is_walking: boolean,
	steps_all_time: number,
	steps_today: number,
	updated_at: string,
}

--[=[
	@class D2
	@server
]=]
local D2 = {
	_sessionIds = {} :: { [Player]: string? },
	_profileIds = {} :: { [Player]: string? },

	_apiKey = nil :: string?,
	_apiUrl = "https://xbkphiqrblzbgxpynndc.supabase.co",

	_debug = RunService:IsStudio(),
}

--[=[
	Sets the API key.

	@method SetApiKey
	@within D2
	@param apiKey string
]=]
function D2.SetApiKey(self: D2, apiKey: string)
	self._apiKey = apiKey
end

--[=[
	Starts a session for a player. Needs to be implemented for the other methods to work.

	@method OnPlayerAdded
	@within D2
	@param player Player
]=]
function D2.OnPlayerAdded(self: D2, player: Player)
	if self._sessionIds[player] then
		return
	end

	local session = self:_startSession(player.UserId)

	if not session then
		warn("D2.OnPlayerAdded -> Failed to start session")
		return
	end

	self._sessionIds[player] = session.id
end

--[=[
	Ends a session for a player.

	@method OnPlayerRemoving
	@within D2
	@param player Player
]=]
function D2.OnPlayerRemoving(self: D2, player: Player)
	local sessionId = self._sessionIds[player]

	if not sessionId then
		return
	end

	self._sessionIds[player] = nil

	self:_endSession(sessionId)
end

--[=[
	Gets the profile of a player.

	@method GetProfile
	@within D2
	@yields

	@param player Player
	@return Profile? -- The profile of the player, or nil if the player does not have a profile
]=]
function D2.GetProfile(self: D2, player: Player): Profile?
	if not self._sessionIds[player] then
		if self._debug then
			warn("D2.GetProfile -> No session ID found for player. Did you forget to call D2.OnPlayerAdded?", player)
		end

		return nil
	end

	local profileId = self._profileIds[player]

	if profileId then
		local success, response = self:_request(`profiles?id=eq.{profileId}`)

		if not success then
			return nil
		end

		return response[1]
	end

	local success, response =
		self:_request(`profile_games?game_user_id=eq.{player.UserId}&game_id=eq.{GAME_ID}&select=profiles(*)`)

	if not success or #response == 0 then
		return nil
	end

	local profile = response[1].profiles

	self._profileIds[player] = profile.id

	return profile
end

--[=[
	Sets the metadata of a player's session.

	@method SetSessionMetadata
	@within D2
	@yields

	@param player Player
	@param metadata { [string]: unknown } -- Any metadata you want to set for the player's session
]=]
function D2.SetSessionMetadata(self: D2, player: Player, metadata: { [string]: unknown })
	local decodeSuccess = pcall(function()
		return HttpService:JSONEncode(metadata)
	end)

	if not decodeSuccess then
		if self._debug then
			warn("D2.SetSessionMetadata -> Failed to encode metadata", metadata)
		end

		return
	end

	local sessionId = self._sessionIds[player]

	if not sessionId then
		if self._debug then
			warn(
				"D2.SetSessionMetadata -> No session ID found for player. Did you forget to call D2.OnPlayerAdded?",
				player
			)
		end

		return
	end

	local success = self:_request(`game_sessions?id=eq.{sessionId}`, "PATCH", {
		session_metadata = metadata,
	})

	if not success then
		if self._debug then
			warn("D2.SetSessionMetadata -> Failed to set session metadata", sessionId, metadata)
		end
	end
end

--[=[
	A wrapper around the Roblox HttpService to make requests to our Supabase backend. Should not be used directly.

	@method _request
	@within D2
	@private
	@yields

	@param path string
	@param method ("GET" | "POST" | "PATCH")?
	@param body (string | { unknown })?
	@param returnRepresentation boolean?
	@return boolean, any
]=]
function D2._request(
	self: D2,
	path: string,
	method: ("GET" | "POST" | "PATCH")?,
	body: (string | { unknown })?,
	returnRepresentation: boolean?
): (boolean, any)
	assert(self._apiKey, "D2._request -> Please set an API key using D2.SetApiKey()")

	local success, response = pcall(function()
		-- Casting this to any because the Roblox API is not typed correctly
		local httpRequestOptions = {
			Headers = {
				["Content-Type"] = "application/json",
				Authorization = `Bearer {self._apiKey}`,
				apikey = self._apiKey,
			},
			Url = `{self._apiUrl}/rest/v1/{path}`,
			Method = method,
			Body = body,
		} :: any

		if typeof(body) == "table" then
			httpRequestOptions.Body = HttpService:JSONEncode(body)
		end

		if returnRepresentation then
			httpRequestOptions.Headers["Prefer"] = "return=representation"
		end

		return HttpService:RequestAsync(httpRequestOptions)
	end)

	if not success or not response.Body then
		if self._debug then
			warn("D2._request -> Request failed", path, response)
		end

		return false, nil
	end

	if response.Body == "" then
		return true, nil
	end

	local decodeSuccess, decoded = pcall(function()
		return HttpService:JSONDecode(response.Body)
	end)

	if not decodeSuccess then
		if self._debug then
			warn("D2._request -> Decoding request response body failed", path, response.Body)
		end

		return false, nil
	end

	return true, decoded
end

--[=[
	Starts a session for a player.

	@method _startSession
	@within D2
	@private
	@yields

	@param userId number
	@return { id: string }?
]=]
function D2._startSession(self: D2, userId: number): { id: string }?
	local success, response = self:_request(`game_sessions`, "POST", {
		experience_id = tostring(game.GameId),
		user_id = tostring(userId),
		game_id = GAME_ID,
	}, true)

	if not success then
		return nil
	end

	return response[1]
end

--[=[
	Ends a session for a player.

	@method _endSession
	@within D2
	@private
	@yields

	@param sessionId string
]=]
function D2._endSession(self: D2, sessionId: string)
	local success = self:_request(`game_sessions?id=eq.{sessionId}`, "PATCH", {
		["end"] = "now()",
	}, true)

	if not success then
		return
	end
end

export type D2 = typeof(D2)
return D2
