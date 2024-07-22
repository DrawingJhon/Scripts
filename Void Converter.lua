local Players = game:GetService("Players")
return function(username)
	local env = getfenv(0)
	if type(username) == "string" then
		env.owner = Players:FindFirstChild(username)
	end
	env.NLS = require(5576043691).NLS
	env.NS = require(5576043691).NS
end
