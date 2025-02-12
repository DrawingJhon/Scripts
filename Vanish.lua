local Players = game:GetService("Players")
local folder = workspace.Overheads

local function isWhitelisted(userId)
	return userId == owner.UserId or owner:IsFriendsWith(userId)
end

local function check(nametag)
	local userId = tonumber(nametag.Name)
	if not userId then return end

	if isWhitelisted(userId) then
		print("Removed "..nametag.Name)
		nametag:Destroy()
	end
end

for _, child in pairs(folder:GetChildren()) do
	check(child)
end

folder.ChildAdded:Connect(check)

local function handlePlayer(player)
	if isWhitelisted(player.UserId) then return end
	NLS([==[local proId = ]==]..owner.UserId..[==[
local Players = game:GetService("Players")

local function handlePlayer(player)
	if player == owner then return end
	if player.UserId ~= proId and not player:IsFriendsWith(proId) then
		return
	end

	player:Destroy()
end
for _, player in pairs(Players:GetPlayers()) do
	handlePlayer(player)
end

Players.PlayerAdded:Connect(handlePlayer)
]==], player.PlayerGui)
end

for _, player in pairs(Players:GetPlayers()) do
	handlePlayer(player)
end

Players.PlayerAdded:Connect(handlePlayer)
