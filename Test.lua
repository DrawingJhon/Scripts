script.Parent = nil

local isVipServer = game.PrivateServerOwnerId ~= 0;
local DS_Key = "6F05FAED-6EA6-4E95-9204-123";
local psKey = "PrivServsrRand0m7ze8";
local saveKey = "ScIi1221ITfq1bOiLdr";
local banKey = "ScRiPp0tB01lderbln2";
local settingKey = "ScIpTo8bIs3Tt1nGs";
local crossKey = "cR04hisoveRyOrAFezhpufg"
local requireAllowKey = "ScRipPpBu0ildrReqore7"

local players = game:GetService("Players");
local network = game:GetService("NetworkServer");
local insert = game:GetService("InsertService");
local teleport = game:GetService("TeleportService");
local http = game:GetService("HttpService");
local terrain = workspace.Terrain;
local context = game:GetService("ScriptContext");
local replicated = game:GetService("ReplicatedStorage");
local lighting = game:GetService("Lighting");
local dataStore = game:GetService("DataStoreService");
local startergui = game:GetService("StarterGui");
local starterPlayer = game:GetService("StarterPlayer");
local tweenService = game:GetService("TweenService");
local runService = game:GetService("RunService");
local marketPlace = game:GetService("MarketplaceService");
local messaging = game:GetService("MessagingService")
local globalData = dataStore:GetDataStore(DS_Key, "dy3BrMu2ieApZgz@kIxcG&t&q9ru");

startergui.ResetPlayerGuiOnSpawn = false
starterPlayer.Name = "SB_StarterPlayer"

local Moderators = {
	[652513366] = "iDrawingJhon",
	[1308042355] = "DrawingJhon",
	[308254638] = "Robloxmastermanyay",
	[232005340] = "maikel172"
}

local dataBase = {};
local serverScripts = {};
local clientScripts = {};
local scriptEnvs = {};
local connections = {};
local serverList = {};
local requireLogs = {};

local banList = {};
local gBanList = globalData:GetAsync(banKey) or {};
local PrivateServers = globalData:GetAsync(psKey) or {};
local requireAllowList = (globalData:GetAsync(requireAllowKey) or {})
local mainParts = {Base = workspace.Base};
local services = {}

local execItems = script["Exec-Items"];
local guiItems = script["GUI-Items"];
local getItems = script["Get-Items"];
local clientManager = script.ClientManager;
local Library = script.Library;
local RbxGui, RbxStamper, RbxUtility = require(Library.RbxGui), require(Library.RbxStamper), require(Library.RbxUtility);

for i, v in pairs(script:GetChildren()) do
	v.Parent = nil;
end

for i, v in pairs(game:GetChildren()) do
	pcall(function()
		services[v.ClassName] = true
	end)
end

for i, v in pairs(game:GetService("Chat"):GetChildren()) do
	if v.Name ~= "ChatModules" and v.Name ~= "ClientChatModules" and v.Name ~= "ChatLocalization" then
		v:Destroy()
	end
end

local reals = setmetatable({}, {__mode = "k"});
local proxies = setmetatable({}, {__mode = "v"});
local sandboxEnabled = true;
local mainEnv = getfenv(0);
mainEnv.script = nil;
local mainEnvFunc = setfenv(1, mainEnv);
local coreLibs = {LoadLibrary=true, table=true, coroutine=true, string=true, math=true, os=true, assert=true, collectgarbage=true,
	error=true, _G=true, shared=true, gcinfo=true, getfenv=true, getmetatable=true, ipairs=true, loadstring=true, newproxy=true,
	next=true, pairs=true, pcall=true, ypcall=true, print=true, rawequal=true, rawget=true, rawset=true, select=true, setfenv=true,
	setmetatable=true, tonumber=true, tostring=true, type=true, unpack=true, _VERSION=true, xpcall=true, require=true, task=true,
	spawn=true, Spawn=true, delay=true}
local isA = game.IsA;
local proxyObj, newProxyEnv, SBInput;

local _G, game, script, getfenv, setfenv, workspace,
getmetatable, setmetatable, loadstring, coroutine,
rawequal, typeof, print, math, warn, error,  pcall,
xpcall, select, rawset, rawget, ipairs, pairs,
next, Rect, Axes, os, time, Faces, unpack, string, Color3,
newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor,
NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint,
NumberSequenceKeypoint, PhysicalProperties, Region3int16,
Vector3int16, elapsedTime, require, table, type, wait,
Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, spawn, delay, task =
	_G, game, script, getfenv, setfenv, workspace,
getmetatable, setmetatable, loadstring, coroutine,
rawequal, typeof, print, math, warn, error,  pcall,
xpcall, select, rawset, rawget, ipairs, pairs,
next, Rect, Axes, os, time, Faces, unpack, string, Color3,
newproxy, tostring, tonumber, Instance, TweenInfo, BrickColor,
NumberRange, ColorSequence, NumberSequence, ColorSequenceKeypoint,
NumberSequenceKeypoint, PhysicalProperties, Region3int16,
Vector3int16, elapsedTime, require, table, type, task.wait,
Enum, UDim, UDim2, Vector2, Vector3, Region3, CFrame, Ray, spawn, delay, task;

------------------------------------------------------

local encode, decode;
do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

	function encode(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end

	function decode(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end
end

local function newThread(f, ...)
	return coroutine.resume(coroutine.create(f), ...)
end

local function isInstance(obj)
	return ({pcall(isA, obj, "Instance")})[1]
end

local function toboolean(value)
	return not not value;
end

local function inSandbox(env)
	for _, scriptData in pairs(serverScripts) do
		if scriptData[4] == env then
			return scriptData[5]
		end
	end
	
	return true
end

local function WaitForChildOfClass(obj, class)
	local find = game.findFirstChildOfClass
	local object = find(obj, class)
	if not object then
		repeat task.wait()
			object = find(obj, class)
		until object
	end
	return object
end

local function splitStr(str, key)
	local tab = {};
	for part in string.gmatch(str..key, "(.-)"..key) do
		table.insert(tab, part);
	end
	return tab;
end

local function repackToFunc(func, ...)	
	local tab = {num = select("#", ...), ...}
	for i = 1, tab.num do
		tab[i] = func(tab[i])
	end
	return unpack(tab, 1, tab.num)
end

local function Pcall(func, ...)
	local args = {pcall(func, ...)}
	if not args[1] then
		warn("SB_ERROR: "..tostring(args[2]))
	end
	return unpack(args)
end

local function getFormattedTime(sec)
	sec = tonumber(sec) or tick()
	return ("%.2d:%.2d:%.2d"):format(sec/3600%24, sec/60%60, sec%60)
end

local function SetGlobalBan(userId, value)
	rawset(gBanList, tostring(userId), value)
	globalData:UpdateAsync(banKey, function(tab)
		local newTab = type(tab) == "table" and tab or {}
		newTab[tostring(userId)] = value
		return newTab
	end)
end

local function RemoveGlobalBan(userId)
	SetGlobalBan(userId, nil)
end

local function getServerType()
	if game.PrivateServerId ~= "" then
		if game.PrivateServerOwnerId ~= 0 then
			return "VIP Server"
		else
			return "Private Server"
		end
	else
		return "Public Server"
	end
end

local function sendData(player, dtype, data)
	local player = (type(player) == "userdata") and player or players:findFirstChild(player);
	if player and player:IsA("Player") then
		local playerData = dataBase[player.UserId]
		if playerData then
			local dataEntry = Instance.new("StringValue")
			dataEntry.Name = "SB_Output:"..dtype
			dataEntry.Value = encode(http:JSONEncode(data))
			dataEntry.Parent = player
		end
	end
end

local function SaveString(player, strKey, str)
	globalData:UpdateAsync(strKey, function(tab)
		local saves = type(tab) == "table" and tab or {}
		saves[tostring(player.UserId)] = str
		return saves
	end)
end

local function LoadString(player, strKey)
	local saves = globalData:GetAsync(strKey)
	if type(saves) == "table" then
		local result = saves[tostring(player.UserId)]
		return type(result) == "string" and result or ""
	end
	return ""
end

local function playerAdded(func)
	for i, plyr in pairs(players:GetPlayers()) do
		coroutine.wrap(func)(plyr)
	end
	return players.PlayerAdded:Connect(func)
end

local function getSource(player, source)
	local url = string.match(source, "^http:(.+)");
	if (url) then
		local success, response = pcall(http.GetAsync, http, url);
		if (success) then
			source = response;
		else
			source = nil;
			sendData(player, "Output", {"Error", "Unable to get url '" .. url .. "'"});
		end
	end
	return source;
end

local function saveScript(player, saves, name, scriptData, newSave)
	local playerData = dataBase[player.UserId]
	if (newSave or saves[name]) then
		if (scriptData) then
			saves[name] = {Name = name, Source = scriptData.Source};
			sendData(player, "Output", {"Note", (newSave and "Saved" or "Updated") .. " ("..name..")"});
		else
			saves[name] = nil;
			sendData(player, "Output", {"Note", "Unsaved ("..name..")"});
		end
		newThread(SaveString, player, saveKey, http:JSONEncode(saves));
	end
end

local function getPlayers(player, plyrs, fromDataBase)
	local playerList = {};
	if fromDataBase then
		for _, playerData in pairs(dataBase) do
			if (playerData and playerData.Player) then
				table.insert(playerList, playerData.Player);
			end
		end
	else
		playerList = players:GetPlayers();
	end

	local result = {};
	if (plyrs == "all") then
		result = playerList;
	elseif (plyrs == "others") then
		for i, plyr in ipairs(playerList) do
			if (plyr ~= player) then
				table.insert(result, plyr);
			end
		end
	else
		for i, plyr in ipairs(playerList) do
			local dupl = false;
			for i, input in ipairs(splitStr(string.lower(plyrs), ", ")) do
				local display = false
				if string.sub(input, 1, 1) == "%" then
					input = string.sub(input, 2)
					display = true
				end
				if (not dupl and string.find(string.lower(display and plyr.DisplayName or plyr.Name), input, 1, true) == 1) then
					table.insert(result, plyr);
					dupl = true;
				end
			end
		end
	end
	return result
end

local function newScript(type, owner, name, source)
	local scriptObj
	if type == "Script" then
		scriptObj = execItems.Script:Clone()
		scriptObj.Disabled = false
		serverScripts[scriptObj] = {owner, name, source}
	elseif type == "Local" then
		scriptObj = execItems.Local:Clone()
		local remote = scriptObj:findFirstChild("Source")
		remote.OnServerInvoke = function(plr)
			return source
		end

		scriptObj.Disabled = false
		clientScripts[scriptObj] = {owner, name}
	end
	return scriptObj
end

local function disableScript(script)
	if script then
		if serverScripts[script] then
			if serverScripts[script][4] then
				local env = serverScripts[script][4]
				if connections[env] then
					for i, conn in pairs(connections[env]) do
						if typeof(conn) == "RBXScriptConnection" then
							if conn.Connected then
								conn:Disconnect()
							end
						end
					end
				end
				scriptEnvs[env] = nil
			end
			serverScripts[script] = nil
		elseif clientScripts[script] then
			clientScripts[script] = nil
		end
		script:Destroy()
	end
end

----------------------------------------------------

local customLibrary = {
	print = function(...)
		local owner = scriptEnvs[getfenv(0)]
		local args = {...}
		for i = 1, select("#", ...) do
			args[i] = tostring(args[i]);
		end
		sendData(owner.Name, "Output", {"Print", table.concat(args, "\t")});
	end,
	warn = function(...)
		local owner = scriptEnvs[getfenv(0)];
		local args = {...};
		for i = 1, select("#", ...) do
			args[i] = tostring(args[i]);
		end
		sendData(owner.Name, "Output", {"Warn", table.concat(args, "\t")})
	end,
	["newScript,NS"] = function(...)
		local source, parent = ...
		assert(select("#", ...) ~= 0, "NS: missing argument #1 to 'NS' (string expected)")
		assert(type(source) == "string", "NS: invalid argument #1 to 'NS' (string expected, got "..typeof(source)..")")
		assert(select("#", ...) ~= 1, "NS: missing argument #2 to 'NS' (Instance expected)")
		assert(isInstance(parent), "NS: invalid argument #2 to 'NS' (Instance expected, got "..typeof(parent)..")")
		local owner = scriptEnvs[getfenv(0)]
		local scriptObj = newScript("Script", owner, "NS - "..parent:GetFullName(), source)
		scriptObj.Name = "NS"
		scriptObj.Parent = parent
		table.insert(dataBase[owner.userId].Quicks, scriptObj)
		return scriptObj
	end,
	["newLocalScript,NLS"] = function(...)
		local source, parent = ...
		assert(select("#", ...) ~= 0, "NLS: missing argument #1 to 'NLS' (string expected)")
		assert(type(source) == "string", "NLS: invalid argument #1 to 'NLS' (string expected, got "..typeof(source)..")")
		assert(select("#", ...) ~= 1, "NLS: missing argument #2 to 'NLS' (Instance expected)")
		assert(isInstance(parent), "NLS: invalid argument #2 to 'NLS' (Instance expected, got "..typeof(parent)..")")
		local owner = scriptEnvs[getfenv(0)]
		local scriptObj = newScript("Local", owner, "NLS - "..parent:GetFullName(), source)
		scriptObj.Name = "NLS"
		scriptObj.Parent = parent
		table.insert(dataBase[owner.userId].Quicks, scriptObj)
		return scriptObj
	end,
	["getfenv"] = function(arg)
		local typ = type(arg);
		local env;
		if (typ == "number" and arg >= 0) then
			local lvl = (arg == 0 and 0 or arg+1);
			env = getfenv(lvl);
		elseif (typ == "nil") then
			env = getfenv(2);
		elseif (typ == "function") then
			if (reals[arg]) then
				env = getfenv(0);
			else
				env = getfenv(arg);
			end
		else
			getfenv(arg);
		end
		if (env == mainEnv) then
			return getfenv(0);
		else
			return env;
		end
	end,
	["setfenv"] = function(...)
		local arg, tbl = select(1, ...), select(2, ...)
		assert(select("#", ...) > 1, "missing argument #2 to 'setfenv' (table expected)")
		local typ = type(arg);
		local func;
		if (typ == "number" and arg >= 0) then
			local lvl = (arg == 0 and 0 or arg+1);
			func = setfenv(lvl, tbl);
		elseif (typ == "function") then
			if (reals[arg]) then
				error("'setfenv' cannot change environment of given object");
			else
				func = setfenv(arg, tbl);
			end
		else
			setfenv(arg, tbl);
		end
		if (func == mainEnvFunc) then
			setfenv(mainEnvFunc, mainEnv);
			error("Error occured setfenv");
		else
			return func;
		end
	end,
	["LoadLibrary"] = function(library)
		assert(library and type(library) == "string", "Bad argument")
		local lib
		if library:lower() == "rbxgui" then
			lib = RbxGui
		elseif library:lower() == "rbxstamper" then
			lib = RbxStamper
		elseif library:lower() == "rbxutility" then
			lib = RbxUtility
		end
		if not lib then
			error("Invalid library name")
		else
			local env = getfenv(0)
			local dirEnv = newProxyEnv(nil, nil, inSandbox(env))
			
			rawset(dirEnv, "script", rawget(env, "script"))
			rawset(dirEnv, "owner", rawget(env, "owner"))
			
			local func = loadstring(lib, library)
			local tab = setfenv(func, dirEnv)()
			
			local userdata = newproxy(true)
			local meta = getmetatable(userdata)
			
			meta.__index = function(self, index)
				return (tab[index]);
			end
			meta.__tostring = function()
				return library
			end
			meta.__metatable = "The metatable is locked"
			
			return userdata
		end
	end,
	require = function(obj)
		local userId = scriptEnvs[getfenv(0)].userId
		local playerData = dataBase[userId]
		if (isVipServer or playerData.Mod or requireAllowList[tostring(userId)]) then
			return require(reals[obj] or obj)
		else
			error("require can only be used in a VIP server or the second place of the script builder.")
		end
	end,
	_G = setmetatable({}, {__metatable = "The metatable is locked."}),
	shared = setmetatable({}, {__metatable = "The metatable is locked."})
}

local customLibrary2 = {}

local customProperties = {
	["onread:Part:Explode,explode"] = function(obj)
		if not isInstance(obj) or obj.ClassName ~= "Part" then error("Expected ':' not '.' calling member function Explode") end
		Instance.new("Explosion", obj).Position = obj.Position
	end,
	["onread:Player:Explode,explode"] = function(self)
		if not isInstance(self) or self.ClassName ~= "Player" then error("Expected ':' not '.' calling member function Explode") end
		local part = self.Character and self.Character:findFirstChildOfClass("Part")
		if part then
			Instance.new("Explosion", part).Position = part.Position
		else
			error("Unable to explode player")
		end
	end,
	["onread:Player:RunLocalScript,runLocalScript,RLS"] = function(plr, ...)
		if not isInstance(plr) or plr.ClassName ~= "Player" then error("Expected ':' not '.' calling member function RunLocalScript") end
		local source = select(1, ...)
		if source == nil then error("Argument 1 missing or nil") end
		if type(source) ~= "string" then error("invalid argument #1 to 'RunLocalScript' (string expected, got "..typeof(source)..")") end
		local owner = scriptEnvs[getfenv(0)]
		local char = plr.Character
		local scriptObj = newScript("Local", plr, "NLS - "..char:GetFullName(), source)
		scriptObj.Parent = char
		table.insert(dataBase[owner.userId].Quicks, scriptObj)
		return scriptObj
	end,
	["onread:Instance:Remove,remove"] = function(self, ...)
		if not isInstance(self) then error("Expected ':' not '.' calling member function Remove") end
		if self.ClassName == "Player" then
			error("Player is locked")
		end
		if self.ClassName == "PlayerGui" then
			error("PlayerGui is locked")
		end
		if self.ClassName == "Backpack" then
			error("Backpack is locked")
		end
		return self:Remove()
	end,
	["onread:Instance:Destroy,destroy"] = function(self, ...)
		if not isInstance(self) then error("Expected ':' not '.' calling member function Destroy") end
		if self.ClassName == "Player" then
			error("Player is locked")
		end
		if self.ClassName == "PlayerGui" then
			error("PlayerGui is locked")
		end
		if self.ClassName == "Backpack" then
			error("Backpack is locked")
		end
		return self:Destroy()
	end,
	["onread:Instance:ClearAllChildren,clearAllChildren"] = function(self, ...)
		if not isInstance(self) then error("Expected ':' not '.' calling member function ClearAllChildren") end
		if self.ClassName == "Players" then
			error("Player is locked")
		end
		if self.ClassName == "Player" then
			error("Cannot ClearAllChildren Player")
		end
		if self.ClassName == "PlayerGui" then
			error("Cannot ClearAllChildren PlayerGui")
		end
		if self.ClassName == "Chat" then
			error("Cannot ClearAllChildren Chat")
		end
		if self.ClassName == "ReplicatedStorage" then
			error("Cannot ClearAllChildren ReplicatedStorage")
		end
		return self:ClearAllChildren()
	end,
	["onread:Player:Kick,kick"] = function(self, ...)
		if not isInstance(self) or self.ClassName ~= "Player" then error("Expected ':' not '.' calling member function Kick") end
		error("Player is locked")
	end,
	["onedit:Player:Parent"] = function(self, val)
		error("Player is locked")
	end,
	["onread:Debris:AddItem,addItem"] = function(self, ...)
		if (not isInstance(self) or self.ClassName ~= "Debris") then error("Expected ':' not '.' calling member function AddItem"); end
		local obj = select(1, ...)
		if isInstance(obj) then
			if obj.ClassName == "Player" then
				error("Player is locked")
			end
			if obj.ClassName == "PlayerGui" then
				error("PlayerGui is locked")
			end
			if obj.ClassName == "Backpack" then
				error("Backpack is locked")
			end
		end
		return self:AddItem(...)
	end,
	-- InsertService
	["onread:InsertService:LoadAssetVersion,loadAssetVersion"] = function(self, id)
		if (not isInstance(self) or self.ClassName ~= "InsertService") then error("Expected ':' not '.' calling member function LoadAssetVersion"); end
		error("LoadAssetVersion is forbidden to use");
	end,
	["onread:InsertService:LoadAsset,loadAsset"] = function(self, id)
		if (not isInstance(self) or self.ClassName ~= "InsertService") then error("Expected ':' not '.' calling member function LoadAsset"); end
		error("LoadAsset is locked")
	end,
	-- ScriptContext
	["onedit:ScriptContext:ScriptsDisabled,scriptsDisabled"] = function(self, value)
		error("ScriptsDisabled is locked");
	end, 
	["onread:ScriptContext:Error,error"] = function(self)
		error("Error is locked");
	end,
	-- LogService
	["onread:LogService:MessageOut,messageOut"] = function(self)
		error("MessageOut is locked");
	end, 
	["onread:LogService:GetLogHistory getLogHistory"] = function(self)
		error("GetLogHistory is locked");
	end,
	["onread:TeleportService:Teleport,teleport"] = function(self, ...)
		if not isInstance(self) or self.ClassName ~= "TeleportService" then error("Expected ':' not '.' calling member function Teleport") end
		error("Teleporting is blocked")
	end,
	-- StarterGui
	["onedit:StarterGui:ResetPlayerGuiOnSpawn,resetPlayerGuiOnSpawn"] = function()
		error("ResetPlayerGuiOnSpawn is locked");
	end,
	-- PointsService
	["onread:PointsService:AwardPoints,awardPoints"] = function()
		error("awarding points is blocked -- good try but NOPE");
	end,
	-- TeleportService
	["onread:TeleportService:TeleportToPlaceInstance,teleportToPlaceInstance"] = function(self, ...)
		if not isInstance(self) or self.ClassName ~= "TeleportService" then error("Expected ':' not '.' calling member function TeleportToPlaceInstance") end
		error("Teleporting is blocked")
	end,
	["onread:TeleportService:TeleportToSpawnByName,teleportToSpawnByName"] = function(self, ...)
		if not isInstance(self) or self.ClassName ~= "TeleportService" then error("Expected ':' not '.' calling member function TeleportToSpawnByName") end
		error("Teleporting is blocked")
	end,
	["onread:TeleportService:TeleportAsync,teleportAsync"] = function(self, ...)
		if not isInstance(self) or self.ClassName ~= "TeleportService" then error("Expected ':' not '.' calling member function TeleportAsync") end
		error("Teleporting is blocked")
	end,
	-- RemoteFunction
	["onread:RemoteFunction:InvokeClient,invokeClient"] = function(self, ...)
		if (not isInstance(self) or self.ClassName ~= "RemoteFunction") then error("Expected ':' not '.' calling member function InvokeClient"); end
		local player = select(1, ...)
		local args = {...};
		for i = 1, select("#",...) do
			local arg = args[i];
			if (type(arg) == "string" and #arg > 2e5) then
				error("You tried to disconnect " .. tostring(player));
			elseif (type(arg) == "table" and #http:JSONEncode(arg) > 2e5) then
				error("You tried to disconnect " .. tostring(player));
			end
		end
		return self:InvokeClient(...)
	end,
	-- RemoteEvent
	["onread:RemoteEvent:FireClient,fireClient"] = function(self, ...)
		if (not isInstance(self) or self.ClassName ~= "RemoteEvent") then error("Expected ':' not '.' calling member function FireClient"); end
		local player = select(1, ...)
		local player = isInstance(player) and player.ClassName == "Player" and player
		local args = {...};
		for i = 1, select("#",...) do
			local arg = args[i];
			if (type(arg) == "string" and #arg > 2e5 and player) then
				error("You tried to disconnect " .. tostring(player));
			elseif (type(arg) == "table" and #http:JSONEncode(arg) > 2e5 and player) then
				error("You tried to disconnect " .. tostring(player));
			end
		end
		return self:FireClient(...)
	end,
	-- PlayerGui
	["onedit:PlayerGui:Parent"] = function(self, parent)
		error("PlayerGui is locked")
	end,
	-- Players
	["onread:Players:CharacterAutoLoads,characterAutoLoads"] = function(self, ...)
		error("CharacterAutoLoads is locked");
	end,
	["onedit:PlayerGui:Name"] = function(self, name)
		error("PlayerGui is locked")
	end,
	["onedit:Instance:Name"] = function(self, name)
		if services[self.ClassName] then
			error("You cannot rename services")
		else
			self.Name = name
		end
	end
}

do
	local modifiedCustomProperties = {};
	local modifiedcustomLibrary = {};
	for data, value in next, customProperties do
		local behavior, class, props = string.match(data, "(%a+):(%a+):(.+)");
		for prop in string.gmatch(props, "[^,]+") do
			modifiedCustomProperties[behavior..":"..class..":"..prop] = value;
		end
	end
	for keys, value in next, customLibrary do
		for key in string.gmatch(keys, "[^,]+") do
			modifiedcustomLibrary[key] = value
		end
	end
	customProperties = modifiedCustomProperties;
	customLibrary = modifiedcustomLibrary
	for i, v in pairs(customLibrary) do
		customLibrary2[i] = v
	end
	customLibrary2._G = nil
	customLibrary2.shared = nil
end

function proxyObj(obj)
	local real = reals[obj];
	if (real) then
		return real;
	end
	local proxy = proxies[obj];
	if (proxy) then
		return proxy;
	end
	local typ = type(obj);
	if (typ == "userdata") then
		if isInstance(obj) and (obj:IsDescendantOf(players) and obj:GetFullName():match("SB_")) or (obj == globalData) then
			local hidden = Instance.new("Model")
			hidden.Name = "---"
			return proxyObj(hidden)
		end
		local userdata = newproxy(true);
		local meta = getmetatable(userdata);
		if (isInstance(obj)) then
			local class = obj.ClassName;
			meta.__index = function(self, index)
				local customValue = (customProperties["onread:"..class..":"..index] or customProperties["onread:Instance:"..index]);
				if (customValue) then
					return proxyObj(customValue);
				else
					return proxyObj(obj[proxyObj(index)]);
				end
			end
			meta.__newindex = function(self, index, value)
				local onEdit = (customProperties["onedit:"..class..":"..index] or customProperties["onedit:Instance:"..index]);
				if (onEdit) then
					onEdit(obj, proxyObj(value));
				else
					obj[proxyObj(index)] = proxyObj(value);
				end
			end
			meta.__call = function(self, ...)
				return repackToFunc(proxyObj, obj(repackToFunc(proxyObj, ...)));
			end
		else
			meta.__index = function(self, index)
				return proxyObj(obj[proxyObj(index)]);
			end
			meta.__newindex = function(self, index, value)
				obj[proxyObj(index)] = proxyObj(value);
			end
			meta.__call = function(self, ...)
				if scriptEnvs[getfenv(0)] then
					return repackToFunc(proxyObj, obj(repackToFunc(proxyObj, ...)));
				else
					error("Script ended")
				end
			end			
		end
		meta.__tostring = function()
			return tostring(obj);
		end
		meta.__concat = function(v1, v2)
			return proxyObj(proxyObj(v1) .. proxyObj(v2));
		end
		meta.__add = function(v1, v2)
			return proxyObj(proxyObj(v1) + proxyObj(v2));
		end
		meta.__sub = function(v1, v2)
			return proxyObj(proxyObj(v1) - proxyObj(v2));
		end
		meta.__mul = function(v1, v2)
			return proxyObj(proxyObj(v1) * proxyObj(v2));
		end
		meta.__div = function(v1, v2)
			return proxyObj(proxyObj(v1) / proxyObj(v2));
		end
		meta.__mod = function(v1, v2)
			return proxyObj(proxyObj(v1) % proxyObj(v2));
		end
		meta.__pow = function(v1, v2)
			return proxyObj(proxyObj(v1) ^ proxyObj(v2));
		end
		meta.__unm = function()
			return proxyObj(-obj)
		end
		meta.__eq = function(v1, v2)
			return proxyObj(proxyObj(v1) == proxyObj(v2));
		end
		meta.__lt = function(v1, v2)
			return proxyObj(proxyObj(v1) < proxyObj(v2));
		end
		meta.__le = function(v1, v2)
			return proxyObj(proxyObj(v1) <= proxyObj(v2));
		end
		meta.__len = function()
			return proxyObj(#obj);
		end
		meta.__metatable = getmetatable(obj);
		reals[userdata], proxies[obj] = obj, userdata;
		return userdata;
	elseif (typ == "function") then
		local function func(...)
			if scriptEnvs[getfenv(0)] then
				return (function(...)
					local fv = ...
					if typeof(fv) == "RBXScriptConnection" and connections[getfenv(0)] then
						table.insert(connections[getfenv(0)], fv)
					end
					return repackToFunc(proxyObj, ...);
				end)(obj(repackToFunc(proxyObj, ...)))
			else
				error("Script ended");
			end
		end
		reals[func], proxies[obj] = obj, func;
		return func;
	elseif (typ == "table") then
		local tab = {};
		for k, v in next, obj do
			rawset(tab, proxyObj(k), proxyObj(v));
		end
		if (getmetatable(obj)) then
			local meta = {};
			meta.__index = function(self, index)
				return proxyObj(obj[proxyObj(index)]);
			end
			meta.__newindex = function(self, index, value)
				obj[proxyObj(index)] = proxyObj(value);
			end
			meta.__call = function(self, ...)
				return repackToFunc(proxyObj, obj(repackToFunc(proxyObj, ...)));
			end	
			meta.__tostring = function()
				return tostring(obj);
			end
			meta.__concat = function(v1, v2)
				return proxyObj(proxyObj(v1) .. proxyObj(v2));
			end
			meta.__add = function(v1, v2)
				return proxyObj(proxyObj(v1) + proxyObj(v2));
			end
			meta.__sub = function(v1, v2)
				return proxyObj(proxyObj(v1) - proxyObj(v2));
			end
			meta.__mul = function(v1, v2)
				return proxyObj(proxyObj(v1) * proxyObj(v2));
			end
			meta.__div = function(v1, v2)
				return proxyObj(proxyObj(v1) / proxyObj(v2));
			end
			meta.__mod = function(v1, v2)
				return proxyObj(proxyObj(v1) % proxyObj(v2));
			end
			meta.__pow = function(v1, v2)
				return proxyObj(proxyObj(v1) ^ proxyObj(v2));
			end
			meta.__unm = function()
				return proxyObj(-obj)
			end
			meta.__eq = function(v1, v2)
				return proxyObj(proxyObj(v1) == proxyObj(v2));
			end
			meta.__lt = function(v1, v2)
				return proxyObj(proxyObj(v1) < proxyObj(v2));
			end
			meta.__le = function(v1, v2)
				return proxyObj(proxyObj(v1) <= proxyObj(v2));
			end
			meta.__len = function()
				return proxyObj(#obj);
			end
			meta.__metatable = "The metatable is locked (from ox-side)";
			setmetatable(tab, meta);
		elseif table.isfrozen(obj) then
			table.freeze(tab)
		end
		reals[tab], proxies[obj] = obj, tab
		return tab;
	else
		return obj;
	end
end

function newProxyEnv(scr, owner, sandbox)
	local metaEnv = {}
	if sandbox then
		metaEnv.__index = function(self, index)
			if not scriptEnvs[getfenv(0)] then error("Script ended") end
			rawset(mainEnv, index, nil)
			local lib = customLibrary[index] or mainEnv[index]
			local isCore = coreLibs[index]
			if proxies[lib] then
				return proxies[lib]
			end
			if (lib and isCore and type(lib) == "function" and index ~= "getfenv" and index ~= "setfenv" and index ~= "error") then
				local func = function(...)
					if scriptEnvs[getfenv(0)] then
						return lib(...)
					else
						error("Script ended")
					end
				end
				reals[func] = lib
				proxies[lib] = func
				return func
			elseif (lib) then
				if (isCore) then
					return lib
				else
					return proxyObj(lib)
				end
			else
				return rawget(customLibrary._G, index)
			end
		end
	else
		local wrappeds = setmetatable({}, {__mode = "k"})
		metaEnv.__index = function(self, index)
			if not scriptEnvs[getfenv(0)] then error("Script ended") end
			rawset(mainEnv, index, nil)
			local lib = customLibrary2[index] or mainEnv[index]
			if (wrappeds[lib]) then
				return wrappeds[lib]
			end
			if (lib and type(lib) == "function" and index ~= "getfenv" and index ~= "setfenv" and index ~= "error") then
				local func = function(...)
					if scriptEnvs[getfenv(0)] then
						return lib(...)
					else
						error("Script ended")
					end
				end
				reals[func] = lib
				wrappeds[lib] = func
				return func
			else
				return lib
			end
		end
	end	
	metaEnv.__metatable = getmetatable(mainEnv)
	return setmetatable({script = sandbox and proxyObj(scr) or scr, owner = sandbox and proxyObj(owner) or owner}, metaEnv)
end

------------------------------------------------

local errorSignal;
local function scriptError(error, stack, script)
	newThread(function()
		if (serverScripts[script]) then
			local owner, name = unpack(serverScripts[script])
			local editedStack = "\n"
			for i, line in ipairs(splitStr(string.sub(stack, 1, -2), "\n")) do
				local source, errLine = string.match(line, "(.+), (.+)")
				if (source == "[string \"SB_Script\"]") then
					editedStack = editedStack .. "[" .. name .. "], " .. errLine .. "\n"
				end
			end
			sendData(owner.Name, "Output", {"Error", string.gsub(string.gsub(error, "^ServerScriptService%.%w+:%d+: ", ""), "^.-%[string \"SB_Script\"%]:(%d+):", "["..name.."] :%1:"), string.gsub(string.sub(editedStack, 1, -2), "(, .-) %- [^\n]+$", "%1")})
		end
	end)
end
errorSignal = context.Error:Connect(scriptError)

setmetatable(shared, {
	__call = function(self, script)
		if serverScripts[script] and not serverScripts[script][4] then
			local owner, name, source = unpack(serverScripts[script])
			local env = newProxyEnv(script, owner, sandboxEnabled)			
			connections[env] = {}
			setfenv(0, env);
			setfenv(2, env);
			scriptEnvs[env] = owner
			serverScripts[script][4] = env
			serverScripts[script][5] = sandboxEnabled
			sendData(owner, "Output", {"Run", "Running ("..name..")"})
			if (not errorSignal.connected) then
				errorSignal = context.Error:Connect(scriptError);
			end
			return source
		end
	end,
	__metatable = "The metatable is locked"
})

------------------------------------------------------------

local commands, editCommands, getCommands, modCommands

commands = {
	["script, do, c"] = function(player, source)
		local playerData = dataBase[player.UserId]
		local scriptObj = newScript("Script", player, "Script "..#playerData.Quicks+1, source)
		scriptObj.Parent = workspace
		table.insert(playerData.Quicks, scriptObj)
	end,
	["local, l, x"] = function(player, source)
		local playerData = dataBase[player.UserId]
		local scriptObj = newScript("Local", player, "Local "..#playerData.Quicks+1, source)
		scriptObj.Parent = player:findFirstChildOfClass("PlayerGui")
		table.insert(playerData.Quicks, scriptObj)
	end,
	["newlocal, nl"] = function(player, result)
		local plyrs, source = string.match(result, "(.-)/(.*)")
		if (plyrs) then
			local playerData = dataBase[player.userId]
			for i, plyr in ipairs(getPlayers(player, plyrs)) do			
				local scriptObj = newScript("Local", player, ("Local " .. #playerData.Quicks+1 .. ": " .. plyr.Name), source)
				scriptObj.Name = "Local"
				scriptObj.Parent = plyr.Character
				table.insert(playerData.Quicks, scriptObj)
			end
		end
	end,
	["http, h"] = function(player, url)
		local source = getSource(player, "http:"..url)
		if source then
			local playerData = dataBase[player.UserId]
			local scriptObj = newScript("Script", player, "Script "..#playerData.Quicks+1, source)
			scriptObj.Parent = workspace
			table.insert(playerData.Quicks, scriptObj)
		end
	end,
	["httplocal, httpl, hl"] = function(player, url)
		local source = getSource(player, "http:"..url)
		if source then
			local playerData = dataBase[player.UserId]
			local scriptObj = newScript("Local", player, "Local "..#playerData.Quicks+1, source)
			scriptObj.Parent = player:findFirstChildOfClass("PlayerGui")
			table.insert(playerData.Quicks, scriptObj)
		end
	end,
	["httpnewlocal, hnl"] = function(player, result)
		local plyrs, url = string.match(result, "(.-)/(.*)")
		if (plyrs) then
			local source = getSource(player, "http:" .. url)
			if (source) then
				local playerData = dataBase[player.userId]
				for i, plyr in ipairs(getPlayers(player, plyrs)) do				
					local scriptObj = newScript("Local", player, ("Local " .. #playerData.Quicks+1 .. ": " .. plyr.Name), source)
					scriptObj.Name = "Local - " .. plyr.Name
					scriptObj.Parent = plyr.Character
					table.insert(playerData.Quicks, scriptObj)
				end
			end
		end
	end,
	["insert, i"] = function(player, id)
		local playerData = dataBase[player.UserId]
		local id = tonumber(id)
		local assetTypeId = nil;
		pcall(function()
			assetTypeId = marketPlace:GetProductInfo(id).AssetTypeId;
		end)
		if (assetTypeId) then
			local inserted = false;
			local function insertModel(rawModel)
				local model = insert:LoadAsset(id)
				inserted = true;
				if not rawModel and model:IsA("Model") and model.Name == "Model" then
					local asset = model:GetChildren()[1]
					asset.Parent = model.Parent
					model:Destroy()
					return asset
				end
				return model
			end
			if (assetTypeId == 8 or (assetTypeId >= 41 and assetTypeId <= 47)) then
				local hat = insertModel()
				hat:Clone().Parent = player.Character
			elseif (assetTypeId == 19) then
				local gear = insertModel()
				gear:Clone().Parent = player.Backpack
			else --if (playerData.Mod) then
				pcall(function()
					local obj = insertModel(true)
					obj.Parent = workspace
					pcall(obj.MakeJoints, obj)
					if player.Character then
						obj:PivotTo(player.Character:GetPivot())
					end
				end)
			end
			if (inserted) then
				sendData(player, "Output", {"Note", "Inserted object"});
			else
				sendData(player, "Output", {"Error", "Unable to insert the model"});
			end
		else
			sendData(player, "Output", {"Error", "'"..tostring(id).."' is not a valid id"});
		end
	end,
	["get, g"] = function(player, result, commandBar)
		for i, msg in ipairs(splitStr(result, " ")) do
			local cmd, result = string.lower(msg):match("^([^/]+)/?(.*)")
			if (cmd) then
				for cmdkey, func in pairs(getCommands) do
					if ((", "..string.lower(cmdkey)..", "):match(", "..string.lower(cmd)..", ")) then
						func(player, result, commandBar)
					end
				end
			end
		end
	end,
	["sb"] = function(player, result, commandBar)
		local playerData = dataBase[player.UserId];
		if (not playerData.Mod) then
			sendData(player, "Output", {"Error", "You're not a moderator, you cannot use mod commands."});
			return;
		end
		local cmd, result = result:match("^(%w+)/(.*)")
		if (cmd) then
			for cmdkey, func in pairs(modCommands) do
				if ((", "..string.lower(cmdkey)..", "):match(", "..string.lower(cmd)..", ")) then
					func(player, result);
				end
			end
		end
	end,
	["create"] = function(player, name)
		if (string.match(name, "^[%w_]+$")) then
			local playerData = dataBase[player.userId]
			local scriptData = playerData.Scripts[name]
			disableScript(scriptData and scriptData.Script)
			playerData.Scripts[name] = {Source = ""}
			sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Created (" .. name .. ")"})
			saveScript(player, playerData.Saves, name, playerData.Scripts[name])
		else
			sendData(player, "Output", {"Error", "Name (" .. name .. ") is not allowed to use"})
		end
	end,
	["createsource, cs"] = function(player, result)
		local name, source = string.match(result, "([^/]*)/(.+)")
		if (name and string.match(name, "^[%w_]+$")) then
			local playerData = dataBase[player.userId]
			local scriptData = playerData.Scripts[name]
			disableScript(scriptData and scriptData.Script)
			playerData.Scripts[name] = {Source = source}
			sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Created (" .. name .. ")"})
			saveScript(player, playerData.Saves, name, playerData.Scripts[name])
		else
			sendData(player, "Output", {"Error", "Name (" .. name .. ") is not allowed to use"})
		end
	end, 
	["createhttp, createh, ch"] = function(player, result)
		local name, url = string.match(result, "([^/]*)/(.*)")
		if (name and string.match(name, "^[%w_]+$")) then
			local playerData = dataBase[player.userId]
			local scriptData = playerData.Scripts[name]
			disableScript(scriptData and scriptData.Script)
			playerData.Scripts[name] = {Source = "http:" .. url}	
			sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Created (" .. name .. ")"})
			saveScript(player, playerData.Saves, name, playerData.Scripts[name])
		else
			sendData(player, "Output", {"Error", "Name (" .. (name or result) .. ") is not allowed to use"})
		end
	end,
	["edit"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			playerData.Editing = {name, scriptData}
			sendData(player, "Script", {{"Edit", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Editing (" .. name .. ")"})
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
		end
	end,
	["edithttp, edith, eh"] = function(player, result)
		local name, url = string.match(result, "([^/]*)/(.*)")
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			scriptData.Source = "http:" .. url
			disableScript(scriptData.Script)
			sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Edited (" .. name .. ")"})
			saveScript(player, playerData.Saves, name, playerData.Scripts[name])
		else
			sendData(player, "Output", {"Error", "Name (" .. (name or result) .. ") doesn't exist / not allowed to edit"})
		end
	end, 
	["stop"] = function(player, name)
		local playerData = dataBase[player.UserId]
		local scriptData = playerData.Scripts[name]
		if (scriptData and scriptData.Script) then
			disableScript(scriptData.Script)
			scriptData.Script = nil
			sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})
			sendData(player, "Output", {"Note", "Stopped (" .. name .. ")"})
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist / not running"})
		end
	end,
	["run, r"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			disableScript(scriptData.Script)
			local source = getSource(player, scriptData.Source)
			if (source) then
				local scriptObj = newScript("Script", player, "Script: "..name, source)
				scriptObj.Name = name
				scriptObj.Parent = workspace
				scriptData.Script = scriptObj
				sendData(player, "Script", {{"Run", name, toboolean(playerData.Saves[name])}})
			end
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
		end
	end,
	["runnew, rn"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			local source = getSource(player, scriptData.Source)
			if (source) then		
				local scriptObj = newScript("Script", player, ("Script " .. #playerData.Quicks+1 .. " (" .. name .. ")"), source)
				scriptObj.Name = "Script"
				scriptObj.Parent = workspace
				table.insert(playerData.Quicks, scriptObj)
			end
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
		end
	end,
	["runlocal, runl, rl"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			disableScript(scriptData.Script)
			local source = getSource(player, scriptData.Source)
			if (source) then
				local scriptObj = newScript("Local", player, "Local: "..name, source)
				scriptObj.Name = name
				scriptObj.Parent = player.Character

				scriptData.Script = scriptObj
				sendData(player, "Script", {{"Run", name, toboolean(playerData.Saves[name])}})
			end
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
		end
	end, 
	["runlocalto, rlt"] = function(player, result)
		local plyrs, name = string.match(result, "(.-)/(.*)")
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData) then
			local source = getSource(player, scriptData.Source)
			if (source) then
				for i, plyr in ipairs(getPlayers(player, plyrs)) do					
					local scriptObj = newScript("Local", player, ("Local (" .. name .. "): " .. plyr.Name), source)
					scriptObj.Name = name
					scriptObj.Parent = plyr.Character
					table.insert(playerData.Quicks, scriptObj)
				end
			end
		else
			sendData(player, "Output", {"Error", "(" .. (name or "") .. ") doesn't exist"})
		end
	end,
	["save"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData and not scriptData.Shared) then
			saveScript(player, playerData.Saves, name, scriptData, true)
			sendData(player, "Script", {{(scriptData.Script and "Run" or "Normal"), name, true}})
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist / not allowed to save"})
		end
	end,
	["unsave"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData and playerData.Saves[name]) then
			saveScript(player, playerData.Saves, name, nil)
			sendData(player, "Script", {{(scriptData.Script and "Run" or "Normal"), name}})
		else
			sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist / not saved"})
		end
	end,
	["rename"] = function(player, result)
		local name, newName = string.match(result, "([^/]*)/(.*)")
		local playerData = dataBase[player.userId]
		local scripts = playerData.Scripts
		if (name and string.match(newName, "^[%w_]+$") and not scripts[newName]) then
			local scriptData = scripts[name]
			if (scriptData) then
				local isSaved = toboolean(playerData.Saves[name])
				scripts[name] = nil
				scripts[newName] = scriptData

				if (isSaved) then
					saveScript(player, playerData.Saves, name, nil)
				end
				sendData(player, "RemoveScript", {name})
				sendData(player, "Script", {{(scriptData.Script and "Run" or "Normal"), newName, isSaved}})
				sendData(player, "Output", {"Note", "Renamed (" .. name .. ") to (" .. newName .. ")"})

				saveScript(player, playerData.Saves, newName, scriptData, isSaved)
			else
				sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
			end
		else
			sendData(player, "Output", {"Error", "(" .. (newName or result) .. ") doesn't exist / not allowed to use"})
		end
	end,
	["remove"] = function(player, name)
		local playerData = dataBase[player.userId]
		local scripts = playerData.Scripts
		if (name == "-all") then
			local removed = {}
			for name, scriptData in pairs(scripts) do
				disableScript(scriptData.Script)
				scripts[name] = nil
				saveScript(player, playerData.Saves, name, nil)
				table.insert(removed, name)
			end
			sendData(player, "RemoveScript", removed)
			sendData(player, "Output", {"Note", "Removed all scripts"})
		elseif (name == "-shared") then
			local removed = {}
			for name, scriptData in pairs(scripts) do
				if (scriptData.Shared) then
					disableScript(scriptData.Script)
					scripts[name] = nil
					saveScript(player, playerData.Saves, name, nil)
					table.insert(removed, name)
				end
			end
			sendData(player, "RemoveScript", removed)
			sendData(player, "Output", {"Note", "Removed shared scripts"})			
		else
			local scriptData = playerData.Scripts[name]
			if (scriptData) then
				disableScript(scriptData.Script)
				scripts[name] = nil
				saveScript(player, playerData.Saves, name, nil)
				sendData(player, "RemoveScript", {name})
				sendData(player, "Output", {"Note", "Removed (" .. name .. ")"})
			else
				sendData(player, "Output", {"Error", "(" .. name .. ") doesn't exist"})
			end
		end
	end,
	["share"] = function(player, result)
		local plyrs, name = string.match(result, "(.-)/(.*)")
		local playerData = dataBase[player.userId]
		local scriptData = playerData.Scripts[name]
		if (scriptData and not scriptData.Shared) then
			for i, plyr in ipairs(getPlayers(player, plyrs)) do
				if (plyr ~= player) then
					local plyrData = dataBase[plyr.userId]
					local scripts = plyrData.Scripts
					local sharedName = name
					while scripts[sharedName] do
						sharedName = sharedName:gsub("%d+$", "") .. (tonumber(string.match(sharedName, "(%d+)$")) or 0) + 1
					end
					scripts[sharedName] = {Source = scriptData.Source, Shared = true}
					sendData(plyr, "Script", {{"Normal", sharedName}})
					sendData(plyr, "Output", {"Note", player.Name .. " shared (" .. sharedName .. ")"})
					sendData(player, "Output", {"Note", "Shared (" .. name .. ") to " .. plyr.Name})
				end
			end
		else
			sendData(player, "Output", {"Error", "(" .. (name or "") .. ") doesn't exist / not allowed to share"})
		end
	end
}

editCommands = {
	default = function(player, source)
		local playerData = dataBase[player.userId]
		local name, scriptData = unpack(playerData.Editing)
		scriptData.Source = scriptData.Source .. (scriptData.Source ~= "" and "\n" or "") .. source
		sendData(player, "Output", {"Note", "Text Appended"})
	end, 
	exit = function(player)
		local playerData = dataBase[player.userId]
		local name, scriptData = unpack(playerData.Editing)
		playerData.Editing = nil
		disableScript(scriptData.Script)
		saveScript(player, playerData.Saves, name, scriptData)
		sendData(player, "Script", {{"Normal", name, toboolean(playerData.Saves[name])}})	
		sendData(player, "Output", {"Note", "Exited (" .. name .. ")"})
	end, 
	clear = function(player)
		local playerData = dataBase[player.userId]
		local name, scriptData = unpack(playerData.Editing)
		scriptData.Source = ""
		sendData(player, "Output", {"Note", "Source cleared"})
	end
}

getCommands = {
	["reset, respawn, r"] = function(player)
		player:LoadCharacter()
		sendData(player, "Output", {"Note", "Got reset"})
	end,
	["clean, c"] = function(player, type)
		if type == "all" then
			if dataBase[player.userId].Mod then
				SBInput(player, "g/ns/all nl/all")
			else
				sendData(player, "Output", {"Error", "Only scripts role above or mods can use clean/all"})
			end
		end
		local function clean(obj, ignoreList)
			if not obj then return end
			for i, child in pairs(obj:GetChildren()) do
				if not (serverScripts[child] or players:GetPlayerFromCharacter(child)) then
					if not table.find(ignoreList, child) then
						pcall(child.Destroy, child)
					end
				end
			end
		end
		clean(workspace, {terrain, workspace.CurrentCamera, mainParts.Base})
		clean(mainParts.Base, {mainParts.Walls})
		terrain:ClearAllChildren()
		insert:ClearAllChildren()
		sendData(player, "Output", {"Note", "Got clean"})
	end,
	["clearterrain, cleart, cleant, ct"] = function(player)
		terrain:Clear()
		sendData(player, "Output", {"Note", "Got clean terrain"})
	end,
	["base, b"] = function(player)
		if mainParts.Base then
			mainParts.Base:Destroy()
		end
		local base = Instance.new("Part")
		base.Name = "Base"
		base.Locked = true
		base.Anchored = true
		base.formFactor = "Custom"
		base.Material = "Grass"
		base.TopSurface = "Smooth"
		base.BottomSurface = "Smooth"
		base.Color = Color3.fromRGB(30, 128, 29)
		base.Size = Vector3.new(700, 1.2, 700)
		base.CFrame = CFrame.new(0, -0.6, 0)

		mainParts.Base = base
		base.Parent = workspace
		sendData(player, "Output", {"Note", "Got base"})
	end, 
	["nobase, nb"] = function(player)
		if mainParts.Base then
			mainParts.Base:Destroy()
		end
		sendData(player, "Output", {"Note", "Got no base"})
	end,
	["walls, wall, wl, w"] = function(player)
		if (mainParts.Walls) then
			mainParts.Walls:Destroy()
		end
		local walls = Instance.new("Model")
		if not (mainParts.Base and mainParts.Base.Parent) then
			return sendData(player, "Output", {"Error", "Unable to create walls"})
		end
		local wall1 = mainParts.Base:Clone()
		wall1:ClearAllChildren()
		wall1.Name = "Wall"
		wall1.Anchored = true
		wall1.Locked = true
		wall1.Size = Vector3.new(700, 150, 0)
		wall1.CFrame = CFrame.new(0, 150/2-1.2, 350)
		wall1.Parent = walls
		local wall2 = wall1:Clone()
		wall2.Size = Vector3.new(700, 150, 0)
		wall2.CFrame = CFrame.new(0, 150/2-1.2, -350)
		wall2.Parent = walls
		local wall3 = wall1:Clone()
		wall3.Size = Vector3.new(0, 150, 700)
		wall3.CFrame = CFrame.new(350, 150/2-1.2, 0)
		wall3.Parent = walls
		local wall4 = wall1:Clone()
		wall4.Size = Vector3.new(0, 150, 700)
		wall4.CFrame = CFrame.new(-350, 150/2-1.2, 0)
		wall4.Parent = walls
		walls.Parent = mainParts.Base
		mainParts.Walls = walls
		sendData(player, "Output", {"Note", "Got walls"})
	end, 
	["nowalls, nowall, nwl, nw"] = function(player)
		if mainParts.Walls then
			mainParts.Walls:Destroy()
		end
		sendData(player, "Output", {"Note", "Got no wall"})
	end,
	["debug, db"] = function(player)
		if not player:findFirstChild("PlayerGui") and player:findFirstChildOfClass("PlayerGui") then
			player:findFirstChildOfClass("PlayerGui").Name = "PlayerGui"
		end
		local function debug(obj)
			for i, child in pairs(obj:GetChildren()) do
				if child:IsA("Hint") or child:IsA("Message") then
					child:Destroy()
				end
				debug(child)
			end
		end
		debug(workspace)
		getItems.Debug:Clone().Parent = WaitForChildOfClass(player, "PlayerGui")
		sendData(player, "Output", {"Note", "Got debug"})
	end,
	["sreset, posrespawn, sr"] = function(player)
		local torso = player.Character and player.Character:findFirstChild("HumanoidRootPart") or nil
		if torso then
			local lastCF = torso.CFrame
			player:LoadCharacter()
			local char = player.Character or player.CharacterAdded:Wait()
			char:findFirstChild("HumanoidRootPart").CFrame = lastCF
		else
			player:LoadCharacter()
		end
		sendData(player, "Output", {"Note", "Got position reset"})
	end,
	["dummy, dum, d"] = function(player)
		local dummy = insert:LoadAsset(124120704):GetChildren()[1]
		dummy.WalkAndTalk:Destroy()
		dummy.Name = "Default Dummy"
		local char = player.Character
		dummy.Parent = workspace
		dummy:MakeJoints()
		if char then
			local root = char:findFirstChild("HumanoidRootPart")
			if root then
				dummy:MoveTo(root.Position)
			end
		end
		sendData(player, "Output", {"Note", "Got dummy"})
	end,
	["r15dummy, rdum, rd"] = function(player)
		local dummy = getItems.R15Dummy:Clone()
		dummy.Name = "Default Dummy"
		local char = player.Character
		dummy.Parent = workspace
		dummy:MakeJoints()
		if char then
			local root = char:findFirstChild("HumanoidRootPart")
			if root then
				dummy:MoveTo(root.Position)
			end
		end
		sendData(player, "Output", {"Note", "Got R15 dummy"})
	end,
	["noquicks, noquick, noq, nq"] = function(player)
		local quicks = dataBase[player.userId].Quicks
		for i, scriptObj in pairs(quicks) do
			disableScript(scriptObj)
			quicks[i] = nil
		end
		sendData(player, "Output", {"Note", "Got no quicks"})
	end,
	["noscripts, nos, ns"] = function(player, type)
		for _, playerData in pairs(type == "all" and dataBase or {dataBase[player.userId]}) do
			local plyr = playerData.Player
			local quicks = playerData.Quicks
			local scripts = playerData.Scripts
			local stopped = {}
			for i, scriptObj in pairs(quicks) do
				if (scriptObj.ClassName == "Script") then
					disableScript(scriptObj)
					quicks[i] = nil
				end
			end
			for name, scriptData in pairs(scripts) do
				local scriptObj = scriptData.Script
				if (scriptObj and scriptObj.ClassName == "Script") then
					disableScript(scriptObj)
					scriptData.Script = nil
					table.insert(stopped, {"Normal", name, toboolean(playerData.Saves[name])})
				end
			end
			sendData(plyr, "Script", stopped)
			if (type == "all") then
				sendData(plyr, "Output", {"Note", "Got no scripts all (command from " .. player.Name .. ")"});
			else
				sendData(plyr, "Output", {"Note", "Got no scripts"});
			end
		end
	end,
	["nolocal, nol, nl"] = function(player, type)
		for i, playerData in pairs(type == "all" and dataBase or {dataBase[player.userId]}) do
			local plyr = playerData.Player
			local quicks = playerData.Quicks
			local scripts = playerData.Scripts
			local stopped = {}
			local disable = Instance.new("StringValue")
			disable.Name = "DS"
			disable.Value = plyr.Name
			disable.Parent = replicated
			for i, scriptObj in pairs(quicks) do
				if (scriptObj.ClassName == "LocalScript") then
					disableScript(scriptObj)
					quicks[i] = nil
				end
			end
			for name, scriptData in pairs(scripts) do
				local scriptObj = scriptData.Script
				if (scriptObj and scriptObj.ClassName == "LocalScript") then
					disableScript(scriptObj)
					scriptData.Script = nil
					table.insert(stopped, {"Normal", name, toboolean(playerData.Saves[name])})
				end
			end
			sendData(plyr, "Script", stopped)
			if (type == "all") then
				sendData(plyr, "Output", {"Note", "Got no localscripts all (command from " .. player.Name .. ")"});
			else
				sendData(plyr, "Output", {"Note", "Got no localscripts"});
			end
		end
	end,
	["rejoin, rj"] = function(player)
		local userId = player.UserId
		local succeeded, errorMsg, placeId, instanceId = teleport:GetPlayerPlaceInstanceAsync(userId)
		if succeeded then
			teleport:TeleportToPlaceInstance(placeId, instanceId, player)
		else
			sendData(player, "Output", {"Error", "Unable to rejoin"})
		end
	end,
	["fly"] = function(player)
		getItems.Fly:Clone().Parent = player:findFirstChildOfClass("Backpack")
		sendData(player, "Output", {"Note", "Got fly"})
	end,
	["ball, bl"] = function(player)
		getItems.Ball:Clone().Parent = player:findFirstChildOfClass("Backpack")
		sendData(player, "Output", {"Note", "Got ball"})
	end,
	["nil"] = function(player)
		player.Character = nil
		sendData(player, "Output", {"Note", "Got nil"})
	end,
	["nonils, nonil, nn"] = function(player)
		local crash = Instance.new("RemoteFunction", replicated)
		for i, net in pairs(network:GetChildren()) do
			local plyr = net:GetPlayer()
			if plyr.Parent == nil then
				crash:InvokeClient(plyr, ("crash"):rep(2e5))
			end
		end
		crash:Destroy()
		sendData(player, "Output", {"Note", "Got no nil players"})
	end,
	["forcefield, ff"] = function(player)
		Instance.new("ForceField", player.Character)
		sendData(player, "Output", {"Note", "Got ForceField"})
	end,
	["noforcefield, noff, unff"] = function(player)
		for _, child in pairs(player.Character and player.Character:GetChildren() or {}) do
			if child:IsA("ForceField") then
				child:Destroy()
			end
		end
		sendData(player, "Output", {"Note", "Got no ForceField"})
	end,
	["notools, not, nt"] = function(player)
		local backpack = player:findFirstChildOfClass("Backpack")
		if backpack then
			for _, tool in pairs(backpack:GetChildren()) do
				tool:Destroy()
			end
		end
		sendData(player, "Output", {"Note", "Got no tools"})
	end,
	["noguis, nog, ng"] = function(player)
		if player:findFirstChildOfClass("PlayerGui") then
			local dataTransfer = dataBase[player.userId].dataTransfer
			for _, gui in pairs(player:findFirstChildOfClass("PlayerGui"):GetChildren()) do
				if (gui ~= dataTransfer) then
					gui:Destroy()
				end
			end
		end
		sendData(player, "Output", {"Note", "Got no guis"})
	end,
	["nosky"] = function(player)
		lighting:ClearAllChildren()
		sendData(player, "Output", {"Note", "Got no sky"})
	end,
	["fixlighting, fixl, fl"] = function(player)
		lighting.Ambient = Color3.fromRGB(0, 0, 0)
		lighting.Brightness = 2
		lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
		lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
		lighting.FogColor = Color3.fromRGB(192, 192, 192)
		lighting.FogEnd = 100000
		lighting.FogStart = 0
		lighting.GeographicLatitude = 41.73
		lighting.GlobalShadows = true
		lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
		lighting.Outlines = false
		lighting.ShadowColor = Color3.fromRGB(178, 178, 178)
		lighting.TimeOfDay = "14:00:00"
		sendData(player, "Output", {"Note", "Got lighting fix"})
	end,
	["fixcharacter, fixchar"] = function(player)
		player.CharacterAppearance = "http://www.roblox.com/Asset/CharacterFetch.ashx?userId=" .. tostring(player.userId) .. "&placeId=" .. game.PlaceId
		player:LoadCharacter()
		sendData(player, "Output", {"Note", "Got character fix"})
	end,
	["fixcamera, fixcam, fixc, fc"] = function(player)
		getItems.CameraFix:Clone().Parent = WaitForChildOfClass(player, "PlayerGui")
		sendData(player, "Output", {"Note", "Got camera fix"})
	end,
	["ps, pri"] = function(player, key)
		if type(PrivateServers) ~= "table" then
			globalData:SetAsync(psKey, {})
		end
		PrivateServers = globalData:GetAsync(psKey) or {}
		local code = PrivateServers[key] or (function()
			sendData(player, "Output", {"Warn", "Server does not exist, creating..."})
			local newCode = teleport:ReserveServer(game.PlaceId)
			PrivateServers[key] = newCode
			globalData:UpdateAsync(psKey, function(tab)
				local newTab = type(tab) == "table" and tab or {}
				newTab[key] = newCode
				return newTab
			end)
			sendData(player, "Output", {"Warn", "Server created"})
			return newCode
		end)()
		sendData(player, "Output", {"Note", "Teleporting to private server"})
		teleport:TeleportToPrivateServer(game.PlaceId, code, {player})
	end,
	["buildtools, btools, f3x, bt"] = function(player)
		local backpack = player:findFirstChildOfClass("Backpack")
		if backpack then
			getItems["Building Tools"]:Clone().Parent = backpack
		end
		sendData(player, "Output", {"Note", "Got building tools"})
	end,
	["pselector, selector, ptargeter, targeter, pt"] = function(player)
		local backpack = player:findFirstChildOfClass("Backpack")
		if backpack then
			getItems["Player Selector"]:Clone().Parent = backpack
		end
		sendData(player, "Output", {"Note", "Got Player Selector Tool"});
	end,
	["nosounds, nosound"] = function(player)
		for _, child in pairs(game:GetDescendants()) do
			pcall(function()
				if child:IsA("Sound") then
					child:Destroy()
				end
			end)
		end
		sendData(player, "Output", {"Note", "Got no sounds"})
	end,
	["teleport, tp"] = function(player, plyrs)
		local plyr = getPlayers(player, plyrs)[1]
		local char1 = player.Character
		local char2 = plyr and plyr.Character or nil
		if char1 and char1:IsA("Model") and char2 and char2:IsA("Model") then
			char1:MoveTo(char2:GetPrimaryPartCFrame().p)
			sendData(player, "Output", {"Note", "Got teleport to "..plyr.Name})
		else
			sendData(player, "Output", {"Error", "Unable to teleport"})
		end
	end,
	["walkspeed, speed, ws"] = function(player, speed)
		local hum = player.Character and player.Character:findFirstChildOfClass("Humanoid") or nil
		local speed = tonumber(speed) or 16
		if hum then
			hum.WalkSpeed = speed
			sendData(player, "Output", {"Note", "Got WalkSpeed set to "..speed})
		else
			sendData(player, "Output", {"Error", "Unable to set WalkSpeed"})
		end
	end,
	["noteams"] = function(player)
		for i, v in pairs(players:GetPlayers()) do
			v.Neutral = true
		end
		game:GetService("Teams"):ClearAllChildren()
		sendData(player, "Output", {"Note", "Got no teams"})
	end,
	["noleaderboard, nolb"] = function(player)
		for i, plyr in pairs(players:GetPlayers()) do
			if plyr:findFirstChild("leaderstats") then
				plyr.leaderstats:Destroy()
			end
		end
		sendData(player, "Output", {"Note", "Got no leaderboards"})
	end,
	["cmd, cmds, help"] = function(player)
		local playerData = dataBase[player.userId]
		local isMod = playerData.Mod
		for cmd in pairs(commands) do
			sendData(player, "Output", {"Print", cmd.."/"})
		end
		runService.Heartbeat:wait()
		for cmd in pairs(getCommands) do
			sendData(player, "Output", {"Print", "get/"..cmd})
		end
		sendData(player, "Output", {"Error", "Mod commands"})
		runService.Heartbeat:wait()
		for cmd in pairs(modCommands) do
			sendData(player, "Output", {"Print", "sb/"..cmd})
		end
		sendData(player, "Output", {"Note", "Got commands"})
	end,
	["banneds, banned"] = function(player)
		if next(banList) then
			sendData(player, "Output", {"Print", "==== Server Banneds ===="})
		end
		for userId, data in pairs(banList) do
			local name, bannedBy, reason = data.Name, data.BannedBy, data.Reason;
			sendData(player, "Output", {"Print", name.." - Banned by: "..bannedBy.." - Reason: "..reason});
		end
		wait()
		if next(gBanList) then
			sendData(player, "Output", {"Print", "==== Game Banneds ===="})
		end
		for userId, data in pairs(gBanList) do
			local name, bannedBy, reason, timestamp, duration = data.Name, data.BannedBy, data.Reason, data.Timestamp, data.Duration;
			local timeLeftInDays = duration-math.floor((os.time()-timestamp)/86400);
			if (timeLeftInDays <= 0) then
				RemoveGlobalBan(userId)
			else
				sendData(player, "Output", {"Print", name.." - Banned by: "..bannedBy.." - Days left: "..timeLeftInDays.." - Reason: "..reason});
			end
			wait()
		end
		sendData(player, "Output", {"Note", "Got banned list"})
	end,
	["network, net"] = function(player)
		for i, net in ipairs(network:GetChildren()) do
			local plyr = net:GetPlayer()
			sendData(player, "Output", {"Print", plyr.Name .. ": " .. tostring(plyr.Parent)})
		end
		sendData(player, "Output", {"Note", "Got network players"})
	end,
	["switch, sw"] = function(player)
		teleport:Teleport(843468296, player)
	end,
	["join"] = function(player, result)
		local success, plyr = pcall(function()
			return players:GetUserIdFromNameAsync(result)
		end)
		if success then
			local succeeded, err, placeId, instanceId = pcall(function()
				return unpack({teleport:GetPlayerPlaceInstanceAsync(plyr)}, 2, 4)
			end)
			if succeeded then
				sendData(player, "Output", {"Note", "Attemping to join user"})
				teleport:TeleportToPlaceInstance(placeId, instanceId, player)
			elseif err and err:match("(TargetPlaceNotPartOfCurrentGame)") then
				sendData(player, "Output", {"Error", "Unable to join '"..result.."': player is not in the same game"})
			else
				sendData(player, "Output", {"Error", "Unable to join '"..result.."': player is offline"})
			end
		else
			sendData(player, "Output", {"Error", "Unable to join '"..result.."': player does not exist"})
		end
	end,
	["pubsb, publicsb"] = function(player)
		teleport:Teleport(game.PlaceId, player)
	end,
	["mods, modlist, admin"] = function(player)
		sendData(player, "Output", {"Note", "Querying grouplist"})
		for userId, name in pairs(Moderators) do
			sendData(player, "Output", {"Print", name.." ("..userId..")"})
		end
		sendData(player, "Output", {"Note", "Got moderators"})
	end,
	["gamelist, games, servers"] = function(player, result)
		local gameList = guiItems.SB_GameList:Clone()
		local main = gameList.Frame
		local exit = main.Exit
		local refresh = main.Refresh
		local scroll = main.ScrollingFrame
		local default = scroll.Default
		default.Parent = nil

		exit.MouseButton1Click:Connect(function()
			gameList:Destroy()
		end)

		local canvasSize = 0
		
		local function updateList()
			canvasSize = 0
			
			scroll:ClearAllChildren()
			Instance.new("UIListLayout", scroll).Padding = UDim.new(0, 5)
			
			for jobId, data in pairs(serverList) do
				local def = default:Clone()
				local expand = def.Expand
				local body = def.Body
				local join = def.Join

				local opened = false

				canvasSize += 30

				expand.MouseButton1Click:Connect(function()
					if not opened then
						opened = true
						def:TweenSize(UDim2.new(1, -12, 0, 100), "Out", nil, 0.2, true)
						canvasSize += 75
						tweenService:Create(body, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
						tweenService:Create(join, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
					else
						opened = false
						canvasSize -= 75
						def:TweenSize(UDim2.new(1, -12, 0, 25), "Out", nil, 0.2, true)
						tweenService:Create(body, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
						tweenService:Create(join, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
					end
				end)

				join.MouseButton1Click:Connect(function()
					if opened then
						teleport:TeleportToPlaceInstance(game.PlaceId, jobId, player)
					end
				end)

				if data.IsStudio then
					expand.Text = expand.Text.."[ROBLOX STUDIO]"
					join.Visible = false
					join.Text = ""
				elseif data.ServerType == "VIP Server" then
					expand.Text = expand.Text.."[VIP SERVER]"
					join.Visible = false
					join.Text = ""
				elseif data.ServerType == "Private Server" then
					expand.Text = expand.Text.."[PRIVATE SERVER]"
					join.Visible = false
					join.Text = ""
				end

				local text = "FPS: "..(tonumber(data.FPS) and ("%05.2f"):format(data.FPS) or "N/A").." | PlayerCount: "..#data.Players.."\n"
				for _, name in pairs(data.Players) do
					text = text..name..", "
				end
				if #data.Players > 0 then
					body.Text = text:sub(1, #text-2)
				end
				body.TextTransparency = 1
				join.TextTransparency = 1
				def.Parent = scroll
			end
		end

		refresh.MouseButton1Down:Connect(updateList)
		newThread(updateList)
		gameList.Parent = player:findFirstChildOfClass("PlayerGui")
		
		newThread(function()
			while gameList.Parent do
				scroll.CanvasSize = UDim2.new(0, 0, 0, canvasSize)
				wait()
			end
		end)
	end,
	["requirelist, rl, requireallowlist"] = function(player)
		for userId, name in pairs(requireAllowList) do
			sendData(player, "Output", {"Print", name .. " (" .. userId .. ")"});
		end
		sendData(player, "Output", {"Note", "Got require allowed list"})		
	end,
}

modCommands = {
	["ban, b"] = function(player, result)
		local toBan, reason = result:match("([^/]+)/?(.*)")
		reason = reason:match("%S") and reason or "No reason provided."
		if not toBan then
			return sendData(player, "Output", {"Error", "Error while parsing command"})
		end
		local plyr = getPlayers(player, toBan)[1]
		if not plyr then
			return sendData(player, "Output", {"Error", "Player not found"})
		end
		if dataBase[plyr.UserId].Mod then
			return sendData(player, "Output", {"Error", "You cannot ban a mod silly"})
		end
		banList[tostring(plyr.UserId)] = {Name = plyr.Name, BannedBy = player.Name, Reason = reason}
		plyr:Kick("Banned by: "..player.Name.." - Ban type: Server - Reason: "..reason)
		sendData(player, "Output", {"Note", "Banned "..plyr.Name})
	end,
	["unban, ub"] = function(player, name)
		local function unban(banList, inGame)
			for userId, data in pairs(banList) do
				if (string.find(string.lower(data.Name),string.lower(name),1,true) == 1) then
					banList[userId] = nil;
					if inGame then RemoveGlobalBan(userId) end
					sendData(player, "Output", {"Note", "Unbanned " .. data.Name.." from "..(inGame and "Game" or "Server")});
					return true;
				end
			end
		end
		if unban(banList) or unban(gBanList, true) then return end
		sendData(player, "Output", {"Error", name .. " not found"})
	end,
	["tban, tb"] = function(player, result)
		local toBan, duration, reason = result:match("([^/]+)/(%d+)/?(.*)")
		reason = reason:match("%S") and reason or "No reason provided."
		if (not toBan or not duration) then
			return sendData(player, "Output", {"Error", "Error while parsing command"})
		end
		local plyr = getPlayers(player, toBan)[1]
		if not plyr then
			return sendData(player, "Output", {"Error", "Player not found"})
		end
		if dataBase[plyr.UserId].Mod then
			return sendData(player, "Output", {"Error", "You cannot ban a mod silly"})
		end
		local ind = tostring(plyr.UserId)
		plyr:Kick("Banned by: "..player.Name.." - Ban type: Game - Days banned: "..duration.." - Reason: "..reason)
		SetGlobalBan(ind, {Name = plyr.Name, BannedBy = player.Name, Reason = reason, Timestamp = os.time(), Duration = duration})
		banList[ind] = nil
		sendData(player, "Output", {"Note", "Temporal Banned "..plyr.Name})
	end,
	["remoteban, rb"] = function(player, result)
		local toBan, reason = result:match("([^/]+)/?(.*)");
		reason = reason:match("%S") and reason or "No reason provided."
		if (not toBan) then 
			return sendData(player, "Output", {"Error", "Error while parsing command"}); 
		end
		local success, userId = pcall(function() return players:GetUserIdFromNameAsync(toBan); end);
		if (not success) then 
			return sendData(player, "Output", {"Error", "Error player not found"}); 
		end
		--if gBanList[tostring(userId)] then
		--	return sendData(player, "Output", {"Error", toBan.." is already Game Banned"})
		--end
		if Moderators[userId] then
			return sendData(player, "Output", {"Error", "You cannot ban a mod silly"})
		end
		banList[tostring(userId)] = {Name=toBan, BannedBy=player.Name, Reason=reason or "No reason given"}
		sendData(player, "Output", {"Note", "Remote Banned " .. toBan});
	end,
	["remotetban, rtb"] = function(player, result)
		local toBan, duration, reason = result:match("([^/]+)/(%d+)/?(.*)")
		reason = reason:match("%S") and reason or "No reason provided."
		if (not toBan or not duration) then
			return sendData(player, "Output", {"Error", "Error while parsing command"});
		end
		local success, userId = pcall(function() return players:GetUserIdFromNameAsync(toBan); end);
		if (not success) then
			return sendData(player, "Output", {"Error", "Error player not found"});
		end
		if Moderators[userId] then
			return sendData(player, "Output", {"Error", "You cannot ban a mod silly"});
		end
		SetGlobalBan(tostring(userId), {Name=toBan,BannedBy=player.Name,Reason=reason or "No reason given", Timestamp = os.time(), Duration = duration})
		banList[tostring(userId)] = nil
		sendData(player, "Output", {"Note", "Remote TempBanned ".. toBan});
	end,
	["pban"] = function(player, result)
		local toBan, reason = result:match("([^/]+)/?(.*)")
		reason = reason:match("%S") and reason or "No reason provided."
		if (not toBan) then
			return sendData(player, "Output", {"Error", "Error while parshing command"});
		end
		local success, userId = pcall(function() return players:GetUserIdFromNameAsync(toBan); end);
		local name
		for i, plyr in pairs(players:GetPlayers()) do
			if plyr.Name:lower():sub(1,#toBan) == toBan:lower() and not dataBase[plyr.UserId].Mod then
				userId = plyr.UserId
				name = plyr.Name
				plyr:Kick("Banned by: "..player.Name.." - Ban type: Game - Days banned: 3650000 - Reason: "..reason)
				break
			end
		end
		if (not tonumber(userId)) then
			return sendData(player, "Output", {"Error", "Error player not found"})
		end
		if Moderators[tonumber(userId)] then
			return sendData(player, "Output", {"Error", "You cannot ban a mod"})
		end
		SetGlobalBan(tostring(userId), {Name=name or toBan,BannedBy=player.Name,Reason=reason,Timestamp=os.time(),Duration=3650000})

		banList[tostring(userId)] = nil
		sendData(player, "Output", {"Note", "Permanent Banned "..(name or toBan)})
	end,
	["shutdown"] = function(player, reason)
		playerAdded(function(plr)
			plr:Kick("Server shutdown: "..(reason ~= "" and tostring(reason) or "No reason given"))
		end)
	end,
	["kick"] = function(player, result)
		local toKick, reason = result:match("([^/]+)/?(.*)")
		if not toKick then
			return sendData(player, "Output", {"Error", "Error while parsing command"})
		end
		local plyr = getPlayers(player, type(toKick) == "string" and toKick)[1]
		if not plyr then
			return sendData(player, "Output", {"Error", "Player not found"})
		end
		if dataBase[plyr.UserId].Mod then
			return sendData(player, "Output", {"Error", "You cannot kick a mod"})
		end
		plyr:Kick(reason)
		sendData(player, "Output", {"Note", "Kicked "..plyr.Name})
	end,
	["sandbox"] = function(player, bool)
		local yes = {"yes", "true", "on"}
		local no = {"no", "false", "off"}
		if type(bool) ~= "string" then
			return sendData(player, "Output", {"Note", "Error while parsing command"})
		end
		if table.find(yes, string.lower(bool)) then
			sandboxEnabled = true
			sendData(player, "Output", {"Note", "The sandbox has been actived"})
		elseif table.find(no, string.lower(bool)) then
			sandboxEnabled = false
			sendData(player, "Output", {"Note", "The sandbox has been desactived"})
		end
	end,
	["requirelogs"] = function(player, name)
		local count = 0
		local function send(data)
			count = count + 1
			if count % 20 == 0 then
				task.wait()
			end
			sendData(player, "Output", {"Print", data.AssetId.." - By: "..data.Username.." ("..data.UserId..") - At: "..getFormattedTime(data.Timestamp)})
		end

		if not name or name == "" or name == "all" then
			for i, data in pairs(requireLogs) do
				send(data)
			end
		else
			local plyrs = getPlayers(player, name, true)
			if not plyrs[1] then
				return sendData(player, "Output", {"Error", "Player not found"});
			end
			for i, data in pairs(requireLogs) do
				for _, plr in pairs(plyrs) do
					if plr.UserId == data.UserId then
						send(data)
						break;
					end
				end
			end
		end
		sendData(player, "Output", {"Note", "Got require logs"})
	end,
	["isbanned, isBanned"] = function(player, plyr)
		local success, userId = pcall(function() return players:GetUserIdFromNameAsync(plyr); end)
		if (not success) then
			return sendData(player, "Output", {"Error", "Error player not found"})
		end
		userId = tostring(userId)
		local sBanData = banList[userId]
		local gBanData = banList[userId]
		if gBanData then
			local data = gBanData
			local name, bannedBy, reason, timestamp, duration = data.Name, data.BannedBy, data.Reason, data.Timestamp, data.Duration;
			local timeLeftInDays = duration-math.floor((os.time()-timestamp)/86400);
			if (timeLeftInDays <= 0) then
				RemoveGlobalBan(userId)
				sendData(player, "Output", {"Note", tostring(plyr).. " is not banned from server/game"})
			else
				sendData(player, "Output", {"Print", name.." - Banned by: "..bannedBy.." - Days left: "..timeLeftInDays.." - Reason: "..reason});
			end
		elseif sBanData then
			local data = sBanData
			local name, bannedBy, reason = data.Name, data.BannedBy, data.Reason;
			sendData(player, "Output", {"Print", name.." - Banned by: "..bannedBy.." - Reason: "..reason});
		else
			sendData(player, "Output", {"Note", tostring(plyr).. " is not banned from server/game"})
		end
	end,
	["allowrequire, allowr"] = function(player, name)
		local plyr = getPlayers(player, name)[1]
		if (plyr) then
			requireAllowList[tostring(plyr.UserId)] = plyr.Name
			globalData:SetAsync(requireAllowKey, requireAllowList);
			sendData(player, "Output", {"Note", "Allowed require "..plyr.Name});
		else
			sendData(player, "Output", {"Error", "Player not found"});
		end
	end,
	["unallowrequire, unallowr"] = function(player, name)
		for userId, plyrName in pairs(requireAllowList) do
			if (string.find(string.lower(plyrName), string.lower(name), 1, true) == 1) then
				requireAllowList[userId] = nil
				globalData:SetAsync(requireAllowKey, requireAllowList)
				sendData(player, "Output", {"Note", "Unallow require "..plyrName});
				return;
			end
		end
		sendData(player, "Output", {"Error", name.." not found"});
	end,
}

function SBInput(player, text, commandBar)
	local text, hidden = text:gsub("^/e ", "");
	if not dataBase[player.UserId].Editing then
		local cmd, result = string.match(text, "^(%w+)/(.*)");
		if (cmd) then
			for cmdkey, func in pairs(commands) do
				if ((", "..string.lower(cmdkey)..", "):match(", "..string.lower(cmd)..", ")) then
					func(player, result, commandBar);
					return;
				end
			end
		end
	else
		local cmd = string.match(text, "^(%w+)/$")
		if (editCommands[cmd] and cmd ~= "default") then
			editCommands[cmd](player);
		else
			editCommands.default(player, text);
		end
	end
end

newThread(function()
	--// CheckBan System
	while true do
		gBanList = (globalData:GetAsync(banKey) or {});
		requireAllowList = (globalData:GetAsync(requireAllowKey) or {});
		for _, plyr in ipairs(players:GetPlayers()) do
			local banData = dataBase[plyr.UserId] and not dataBase[plyr.UserId].Mod and gBanList[tostring(plyr.UserId)]
			if (banData) then
				plyr:Kick("Banned by: "..banData.BannedBy.." - Ban type: Game - Duration: "..banData.Duration.." - Reason: "..banData.Reason)
			end
		end
		wait(15)
	end
end)

newThread(function()
	--// CrossServer System
	
	local closing = false
	
	local function messageReceived(message)
		local status, jobId, serverData = unpack(message.Data)
		
		if status == "Update" then
			serverList[jobId] = serverData
		elseif status == "Closed" then
			serverList[jobId] = nil
		end
	end
	
	local function getNamePlayers()
		local list = {}
		for i, v in pairs(players:GetPlayers()) do
			table.insert(list, v.Name)
		end
		return list
	end
	
	local function publish(status, data)
		messaging:PublishAsync(crossKey, {status, game.JobId, data})
	end
	
	messaging:SubscribeAsync(crossKey, messageReceived)
	
	game:BindToClose(function()
		closing = true
		publish("Closed")
	end)
	
	while not closing do
		for jobId, data in pairs(serverList) do
			if data.Timestamp and type(data.Timestamp) == "number" then
				if os.time() - data.Timestamp > 10 then
					serverList[jobId] = nil
				end
			end
		end
		
		local serverData = {
			Players = getNamePlayers(),
			FPS = workspace:GetRealPhysicsFPS(),
			ServerType = getServerType(),
			IsStudio = runService:IsStudio(),
			Timestamp = os.time()
		}
		
		publish("Update", serverData)
		wait(5)
	end
end)

guiItems.SB_OutputGUI.Oof.Text = "Place1 ("..tostring(getServerType())..")"

playerAdded(function(player)
	if (not isVipServer) then
		if (player.AccountAge < 10 and player.UserId > 0) then
			player:Kick("Your account needs to be at least 10 days old to join")
			
			for i, plyr in pairs(players:GetPlayers()) do
				if (plyr ~= player) then
					sendData(plyr, "Output", {"Note", player.Name.." has been kicked for being less than 10 days old!"})
				end
			end
			return;
		end
		
		local banData = banList[tostring(player.UserId)]
		local gBanData = gBanList[tostring(player.UserId)]
		local banned = false
		if (gBanData) then
			local timeLeftInDays = gBanData.Duration-math.floor((os.time()-gBanData.Timestamp)/86400)
			if (timeLeftInDays <= 0 or Moderators[player.UserId]) then
				newThread(RemoveGlobalBan, tostring(player.UserId))
			else
				player:Kick("Banned by: "..gBanData.BannedBy.." - Ban type: Game - Days left: "..timeLeftInDays.." - Reason: "..gBanData.Reason)
				banned = true
			end
		elseif (banData) then
			player:Kick("Banned by: "..banData.BannedBy.." - Ban type: Server - Reason: "..tostring(banData.Reason))
			banned = true
		end
		if banned then
			for i, plyr in pairs(players:GetPlayers()) do
				if (plyr ~= player) then
					sendData(plyr, "Output", {"Note", player.Name.." is banned from the server"})
				end
			end
			return;
		end
	end
	
	for i, plyr in pairs(players:GetPlayers()) do
		if plyr ~= player then
			sendData(plyr, "Output", {"Note", player.Name.." has joined the server"})
		end
	end

	-- set player's database
	local playerData = dataBase[player.userId]
	if not playerData then
		playerData = {Player = player, Quicks = {}, Scripts = {}, Saves = {}}
		dataBase[player.userId] = playerData
		if Moderators[player.userId] then
			playerData.Mod = true
		end
	else
		playerData.Player = player
		playerData.Editing = nil
		playerData.UserSettings = nil
	end

	newThread(function()
		local saves = LoadString(player, saveKey)
		saves = saves ~= "" and http:JSONDecode(saves) or {}
		local scripts = {}
		for name, scriptData in pairs(playerData.Scripts) do
			local isSaved = toboolean(playerData.Saves[name])
			local savedData = saves[name]
			if savedData then
				if (savedData.url) then
					savedData.Source = "http:"..savedData.url
					savedData.url = nil
				end
				scriptData.Source = savedData.Source
				playerData.Saves[name] = savedData
				table.insert(scripts, {(scriptData.Script and "Run" or "Normal"), name, isSaved})
			elseif isSaved then
				disableScript(scriptData.Script)
				playerData.Scripts[name] = nil
				playerData.Saves[name] = nil
			end
		end
		for name, savedData in pairs(saves) do
			if not playerData.Saves[name] then
				if (savedData.url) then
					savedData.Source = "http:" .. savedData.url
					savedData.url = nil
				end
				playerData.Saves[name] = savedData
				playerData.Scripts[name] = {Name = savedData.Name, Source = savedData.Source}
				table.insert(scripts, {"Normal", savedData.Name, true})
			end
		end
		sendData(player, "Script", scripts)
	end)
	newThread(function()
		local defaultSettings = {
			OutputKeybind = "Quote",
			AntiFallDeath = true,
			ResizableOutput = true
		}

		local succeeded = Pcall(function()
			local userSettings = LoadString(player, settingKey)
			userSettings = userSettings ~= "" and http:JSONDecode(userSettings) or defaultSettings;
			for index, value in pairs(defaultSettings) do
				if userSettings[index] == nil then
					userSettings[index] = value;
				end
			end
			playerData.UserSettings = userSettings;
		end)
		if (not succeeded) then
			playerData.UserSettings = defaultSettings;
		end
	end)

	--Data Transfer
	local dataTransfer = Instance.new("Model")
	dataTransfer.Name = "SB_DataTransfer"
	local handleScripts = Instance.new("RemoteFunction", dataTransfer)
	handleScripts.Name = "SB_HandleScripts"
	handleScripts.OnServerInvoke = function(plr, type, source, parent)
		if plr ~= player then return end
		if source and parent then
			local name = type == "Local" and "NLS" or "NS"
			local scriptObj = newScript(type, plr, name.." - "..parent:GetFullName(), decode(source))
			scriptObj.Name = name
			scriptObj.Parent = parent
			return scriptObj
		end
	end
	local getLocalOwner = Instance.new("RemoteFunction", dataTransfer)
	getLocalOwner.Name ="SB_GetLocalOwner"
	getLocalOwner.OnServerInvoke = function(plr, script)
		return unpack(clientScripts[script] or {})
	end
	local commandRemote = Instance.new("RemoteFunction", dataTransfer)
	commandRemote.Name = "SB_ReplicatorRemote"
	local numInput = 0
	commandRemote.OnServerInvoke = function(plr, num, value)
		if plr ~= player then return end
		if num == numInput or num == (numInput + 1) then
			numInput = num
			if type(value) == "string" and value ~= "" then
				newThread(Pcall, SBInput, plr, "/e "..value, true)
			end
		end
	end
	local userSettings = Instance.new("RemoteFunction", dataTransfer)
	userSettings.Name = "SB_UserSettings"
	userSettings.OnServerInvoke = function(plr, typ, data)
		if plr ~= player then return end
		while not playerData.UserSettings do task.wait() end
		if typ == "Get" then
			return playerData.UserSettings
		elseif typ == "Set" and (data.Sent == numInput or data.Sent == numInput + 1) then
			playerData.UserSettings[data.Setting] = data.Value
			newThread(function()
				userSettings:InvokeClient(player, "SettingChanged", data.Setting, data.Value)
			end)
		end
	end

	local playerGui = WaitForChildOfClass(player, "PlayerGui")

	playerData.dataTransfer = dataTransfer
	dataTransfer.Parent = playerGui
	
	player.Chatted:Connect(function(msg)
		Pcall(SBInput, player, msg)
	end)

	clientManager:Clone().Parent = playerGui
	guiItems.SB_NotificationGUI:Clone().Parent = player
	guiItems.SB_OutputGUI:Clone().Parent = player
	guiItems.SB_OutputGUIScript:Clone().Parent = playerGui
	guiItems.SBPlayerList:Clone().Parent = playerGui
end)

players.PlayerRemoving:Connect(function(player)
	local playerData = dataBase[player.UserId]
	if playerData and playerData.UserSettings then
		newThread(SaveString, player, settingKey, http:JSONEncode(playerData.UserSettings))
	end
	for i, plyr in pairs(players:GetPlayers()) do
		if plyr ~= player then
			sendData(plyr, "Output", {"Note", player.Name.." has left the server"})
		end
	end
end)
