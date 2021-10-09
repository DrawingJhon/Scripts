-- THIS SCRIPT IS INSPIRED ON ADONIS ADMIN

if GX_LOADED then
	error("GX Admin is alredy running!", 0)
	return
end

pcall(function() getgenv().GX_LOADED = true end)

local Players = game:GetService("Players")
local owner = Players.LocalPlayer
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextService = game:GetService("ContextActionService")
local CoreGui = (function()
	local cr
	pcall(function()
		local tcr = game:GetService("CoreGui")
		local temp = tcr:GetChildren()
		cr = tcr
	end)
	return cr or owner:findFirstChildOfClass("PlayerGui")
	
end)()


local adminVersion = "Alpha 0.6"

local Settings = {
	Prefix = ";";
	PlayerPrefix = "!";
	SpecialPrefix = "";
	SplitKey = ' ';
	PlrSeparate = ',';
	BatchKey = "|";
	SaveData = true;
	ChatCommands = true;
}

local TrackedTasks = {}
local cachePlayersId = {}
local RunningLoops = {}
local RbxEvents = {}
local SavedGuis = {}
local gTable = {}
local MaxLogs = 1000

local service, Functions, Admin, Core, Remote, Commands, Process, Variables, Assets, UI, Logs

local message = function(...) game:GetService("TestService"):Message(...) end
local Routine = function(func, ...) coroutine.resume(coroutine.create(func), ...) end

local Variables = {
	CodeName = math.random();
	Objects = {};
	RopeConstraints = {};
	Hints = {};
	Waypoints = {};
	Spinners = {};
	Tracks = {};
	Skies = {};
	MainGui = {};
	CommandLoops = {};
	MusicList = {
		{Name='jericho',ID=292340735};
		{Name='dieinafire',ID=242222291};
		{Name='beam',ID=165065112};
		{Name='myswamp',ID=166325648};
		{Name='skeletons',ID=168983825};
		{Name='russianmen',ID=173038059};
		{Name='freedom',ID=130760592};
		{Name='seatbelt',ID=135625718};
		{Name='tempest',ID=135554032};
		{Name="focus",ID=136786547};
		{Name="azylio",ID=137603138};
		{Name="caramell",ID=2303479};
		{Name="epic",ID=27697743};
		{Name="halo",ID=1034065};
		{Name="pokemon",ID=1372261};
		{Name="cursed",ID=1372257};
		{Name="extreme",ID=11420933};
		{Name="tacos",ID=142295308};
		{Name="wakemeup",ID=2599359802};
		{Name="awaken",ID=27697277};
		{Name="alone",ID=27697392};
		{Name="mario",ID=1280470};
		{Name="choir",ID=1372258};
		{Name="chrono",ID=1280463};
		{Name="dotr",ID=11420922};
		{Name="entertain",ID=27697267};
		{Name="fantasy",ID=1280473};
		{Name="final",ID=1280414};
		{Name="emblem",ID=1372259};
		{Name="flight",ID=27697719};
		{Name="gothic",ID=27697743};
		{Name="hiphop",ID=27697735};
		{Name="intro",ID=27697707};
		{Name="mule",ID=1077604};
		{Name="film",ID=27697713};
		{Name="nezz",ID=8610025};
		{Name="resist",ID=27697234};
		{Name="schala",ID=5985787};
		{Name="organ",ID=11231513};
		{Name="tunnel",ID=9650822};
		{Name="spanish",ID=5982975};
		{Name="venom",ID=1372262};
		{Name="wind",ID=1015394};
		{Name="guitar",ID=5986151};
		{Name="weapon",ID=142400410};
		{Name="derezzed",ID=142402620};
		{Name="sceptics",ID=153251489};
		{Name="pianoremix",ID=142407859};
		{Name="antidote",ID=145579822};
		{Name="overtime",ID=135037991};
		{Name="fluffyunicorns",ID=141444871};
		{Name="tsunami",ID=569900517};
		{Name="finalcountdownremix",ID=145162750};
		{Name="stereolove",ID=142318819};
		{Name="minecraftorchestral",ID=148900687};
		{Name="superbacon",ID=300872612};
		{Name="alonemarsh",ID=639750143}; -- Alone - Marshmello
		{Name="crabraveoof",ID=2590490779}; -- Crab rave oof
		{Name="rickroll",ID=4581203569};
		{Name="deathbed",ID=4966153470};
		{Name="muffinsong",ID=1753701701};
		{Name="helloworld",ID=5642549252};
		{Name="shrekophone",ID=6344613233};
		{Name="NoOnesAroundToHelp",ID=1280408510};
		{Name="caillou",ID=181768110};
		{Name="flowergarden",ID=3229605759};
		{Name="shineon",ID=4257587332};
		{Name="pizzatheme",ID=672731096};
		{Name="oldtownroad",ID=652513366};
		{Name="undertale",ID=1072410152};
	};
}

service = setmetatable({
	MarketPlace = game:GetService("MarketplaceService");
	RbxEvent = function(signal, func) local event = signal:connect(func) table.insert(RbxEvents, event) return event end;
	SelfEvent = function(signal, func) local rbxevent = service.RbxEvent(signal, function(...) func(...) end) end;
	DelRbxEvent = function(signal) for i,v in next,RbxEvents do if v == signal then v:Disconnect() table.remove(RbxEvents, i) end end end;
	Delete = function(obj,num) game:service("Debris"):AddItem(obj, (num or 0)) pcall(obj.Destroy, obj) end;
	Player = game:GetService("Players").LocalPlayer;
	New = function(class, data)
		local new = Instance.new(class)
		if data then
			if type(data) == "table" then
				local parent = data.Parent
				data.Parent = nil
				for val, prop in pairs(data) do
					new[val] = prop
				end
				if parent then
					new.Parent = parent
				end
			elseif type(data) == "userdata" then
				new.Parent = data
			end
		end
		return new
	end;
	Wait = function(mode)
		if not mode or mode == "Stepped" then
			service.RunService.Stepped:wait()
		elseif mode == "Heartbeat" then
			service.RunService.Heartbeat:wait()
		elseif mode and tonumber(mode) then
			wait(tonumber(mode))
		end
	end;
	TrackTask = function(name, func, ...)
		local index = math.random()
		local isThread = string.sub(name, 1, 7) == "Thread:"
		local data = {
			Name = name;
			Status = "Waiting";
			Function = func;
			isThread = isThread;
			Created = os.time();
			Index = index;
		}
		local function taskFunc(...)
			TrackedTasks[index] = data
			data.Status = "Running"
			data.Returns = {pcall(func, ...)}
			if not data.Returns[1] then
				data.Status = "Errored"
			else
				data.Status = "Finished"
			end
			TrackedTasks[index] = nil
			return unpack(data.Returns)
		end
		if isThread then
			data.Thread = coroutine.create(taskFunc)
			return coroutine.resume(data.Thread, ...)
		else
			return taskFunc(...)
		end
	end;
	EventTask = function(name, func)
		local newTask = service.TrackTask
		return function(...)
			return newTask(name, func, ...)
		end
	end;
	GetTasks = function()
		return TrackedTasks
	end;
	Insert = function(id, rawModel)
		local model = service.InsertService:LoadAsset(id)
		if not rawModel and model:IsA("Model") and model.Name == "Model" then
			local asset = model:GetChildren()[1]
			asset.Parent = model.Parent
			model:Destroy()
			return asset
		end
		return model
	end;
	GetUserIdFromName = function(name)
		if cachePlayersId[name] then return cachePlayersId[name] end
		local player = service.Players:findFirstChild(name)
		if player then
			cachePlayersId[name] = player.UserId
			return player.UserId
		end
		local id
		local success, err = pcall(function()
			id = service.Players:GetUserIdFromNameAsync(name)
		end)
		if success then
			cachePlayersId[name] = id
			return id
		end
	end;
	StartLoop = function(name, delay, func, noYield)
		local tab = {
			Name = name;
			Delay = delay;
			Function = func;
			Running = true;
		}

		local index = tostring(name).." - "..Functions:GetRandom()

		local function kill()
			tab.Running = true
			if RunningLoops[index] == tab then
				RunningLoops[index] = nil
			end
		end

		local function loop()
			if tonumber(delay) then
				repeat 
					func()
					wait(tonumber(delay))
				until RunningLoops[index] ~= tab or not tab.Running
				kill()
			elseif delay == "Heartbeat" then
				repeat 
					func()
					service.RunService.Heartbeat:wait()
				until RunningLoops[index] ~= tab or not tab.Running
				kill()
			elseif delay == "RenderStepped" then
				repeat 
					func()
					service.RunService.RenderStepped:wait()
				until RunningLoops[index] ~= tab or not tab.Running
				kill()
			elseif delay == "Stepped" then
				repeat 
					func()
					service.RunService.Stepped:wait()
				until RunningLoops[index] ~= tab or not tab.Running
				kill()
			else
				tab.Running = false
			end
		end

		tab.Kill = kill
		RunningLoops[index] = tab

		if noYield then
			service.TrackTask("Thread: Loop: "..name, loop)
		else
			service.TrackTask("Loop: "..name, loop)
		end

		return tab
	end;
	StopLoop = function(name)
		for ind, loop in pairs(RunningLoops) do
			if name == loop.Function or name == loop.Name then
				loop.Running = false
			end
		end
	end;
	LocalContainer = function()
		if not client.Variables.LocalContainer or not client.Variables.LocalContainer.Parent then
			client.Variables.LocalContainer = service.New("Folder")
			client.Variables.LocalContainer.Name = "__ADONIS_LOCALCONTAINER_" .. client.Functions.GetRandom()
			client.Variables.LocalContainer.Parent = service.Workspace
		end
		return client.Variables.LocalContainer
	end;
}, {
	__index = function(self, index)
		local found = Functions[index]
		if found ~= nil then
			return found
		else
			local ran, serv = pcall(game.GetService, game, index)
			if ran and serv then
				service[tostring(serv)] = serv
				return serv
			end
		end
	end;
	__tostring = "Service";
	__metatable = "Service";
})

Functions = {
	GetPlayers = function(plr, text, dontError)
		local PlayerList = {}
		local msg = type(text) == "string" and text:lower()
		if type(text) ~= "string" or text:match("^%s*$") then
			table.insert(PlayerList, plr)	
		else
			local sep = msg:split(Settings.PlrSeparate)
			for i = 1,#sep do
				local lmsg = sep[i]
				local function getplrs(msg)
					local listplrs = {}
					local plyrs = service.Players:GetPlayers()
					if msg == "me" and plr then
						table.insert(listplrs, plr)
					elseif msg == "others" and plr then
						for i, p in pairs(service.Players:GetPlayers()) do
							if p ~= plr then
								table.insert(listplrs, p)
							end
						end
					elseif msg == "random" then
						table.insert(listplrs, plyrs[math.random(1,#plyrs)])
					elseif msg == "friends" and plr then
						for i, v in pairs(service.Players:GetPlayers()) do
							if v:IsFriendsWith(plr.UserId) then
								table.insert(listplrs, v)
							end
						end
					elseif msg == "all" then
						for i, v in pairs(service.Players:GetPlayers()) do
							table.insert(listplrs, v)
						end
					elseif msg:sub(1, 1) == "#" then
						local matched = msg:match("%#(.*)")
						if matched and tonumber(matched) then
							local num = tonumber(matched)
							for i = 1, num do
								table.insert(listplrs, plyrs[math.random(1,#plyrs)])
							end
						end
					elseif msg:sub(1, 7) == "radius-" and plr then
						local matched = msg:match("radius%-(.*)")
						if matched and tonumber(matched) then
							local num = tonumber(matched)
							for i, v in next, service.Players:GetPlayers() do
								local pos1 = plr.Character and plr.Character:GetModelCFrame().p
								local pos2 = v.Character and v.Character:GetModelCFrame().p
								if (pos1 - pos2).magnitude <= num then
									table.insert(listplrs, v)
								end
							end
						end
					elseif msg:sub(1,1) == "@" then
						for i, v in pairs(service.Players:GetPlayers()) do
							if v.Name:lower():sub(1,#msg) == msg:lower():sub(2) then
								table.insert(listplrs, v)
							end
						end
					else
						local found = false
						for i, v in pairs(service.Players:GetPlayers()) do
							if v.DisplayName:lower():sub(1, #msg) == msg:lower() then
								found = true
								table.insert(listplrs, v)
							end
						end
						if not found then
							for i, v in pairs(service.Players:GetPlayers()) do
								if v.Name:lower():sub(1, #msg) == msg:lower() then
									table.insert(listplrs, v)
								end
							end
						end
					end
					return listplrs
				end
				if lmsg:match('^-') then
					local gotplrs = getplrs(lmsg:sub(2))
					for i = 1,#PlayerList do
						for z = 1,#gotplrs do
							if PlayerList[i] == gotplrs[z] then
								table.remove(PlayerList, i)
							end
						end
					end
				else
					local gotplrs = getplrs(lmsg)
					for i = 1,#gotplrs do
						table.insert(PlayerList, gotplrs[i])
					end
				end
			end
			if #PlayerList == 0 and not dontError then
				Functions.Output("No player matching "..text.." were found!", {plr})
			end
		end
		return PlayerList
	end;
	PlayAnimation = function(animId)
		if animId == 0 then return end

		local char = service.Player.Character
		local human = char and char:FindFirstChildOfClass("Humanoid")
		local animator = human and human:FindFirstChildOfClass("Animator") or human and human:WaitForChild("Animator", 9e9)
		if not animator then return end

		for _, v in ipairs(animator:GetPlayingAnimationTracks()) do v:Stop() end
		local anim = service.New('Animation', {
			AnimationId = 'rbxassetid://'..animId,
			Name = "ADONIS_Animation"
		})
		local track = animator:LoadAnimation(anim)
		track:Play()
	end;
	SetLighting = function(prop, value)
		if service.Lighting[prop] ~= nil then
			service.Lighting[prop] = value
		end
	end;
	DSKeyNormalize = function(intab, reverse)
		local tab = {}

		if reverse then
			for i,v in next,intab do
				if tonumber(i) then
					tab[tonumber(i)] = v;
				end
			end
		else
			for i,v in next,intab do
				tab[tostring(i)] = v;
			end
		end

		return tab;
	end;
	GetRandom = function(pLen)
		local Len = (type(pLen) == "number" and pLen) or math.random(5, 10)
		local Res = {}
		for Idx = 1, Len do
			Res[Idx] = string.format('%02x', math.random(126))
		end
		return table.concat(Res)
	end;
	Trim = function(str)
		return str:match("^%s*(.-)%s*$")
	end;
	Round = function(num)
		return math.floor(num + 0.5)
	end;
	CleanWorkspace = function()
		for i, v in pairs(service.Workspace:GetChildren()) do
			if v:IsA("Tool") or v:IsA("Accessory") or v:IsA("Hat") then
				v:Destroy()
			end
		end
	end;
	RemoveSeatWelds = function(seat)
		if seat ~= nil then
			for i, v in next, seat:GetChildren() do
				if v:IsA("Weld") then
					if v.Part1 ~= nil and v.Part1.Name == "HumanoidRootPart" then
						v:Destroy()
					end
				end
			end
		end
	end;
	Split = function(msg,key,num)
		if not msg or not key or not num or num <= 0 then return {} end
		if key=="" then key = " " end

		local tab = {}
		local str = ''

		for arg in msg:gmatch('([^'..key..']+)') do
			if #tab>=num then
				break
			elseif #tab>=num-1 then
				table.insert(tab,msg:sub(#str+1,#msg))
			else
				str = str..arg..key
				table.insert(tab,arg)
			end
		end

		return tab
	end;
	Hint = function(message, time)
		UI.MakeGui("Hint", {
			Message = message;
			Time = time;
		})
	end;
	Output = function(message, time)
		UI.MakeGui("Output", {
			Message = message;
			Time = time;
		})
	end;
	Message = function(title, message, tim)
		UI.MakeGui("Message", {
			Title = title;
			Message = message;
			Time = tim;
		})
	end;
	Notification = function(title, message, time)
		UI.MakeGui("Notification", {
			Title = title;
			Message = message;
			Time = time;
		})
	end;
	CreateClothingFromImageId = function(clothingtype, Id)
		local Clothing = Instance.new(clothingtype)
		Clothing.Name = clothingtype
		Clothing[clothingtype == "Shirt" and "ShirtTemplate" or clothingtype == "Pants" and "PantsTemplate" or clothingtype == "ShirtGraphic" and "Graphic"] = string.format("rbxassetid://%d", Id)
		return Clothing
	end;
	ToClipboard = function(str, silent)
		local clipBoard = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
		if clipBoard then
			clipBoard(str)
			if not silent then
				Functions.Notification('Clipboard','Copied to clipboard')
			end
		elseif not silent then
			Functions.Notification('Clipboard',"Your exploit doesn't have the ability to use the clipboard")
		end
	end;
	SetView = function(obj)
		local CurrentCamera = workspace.CurrentCamera
		
		if obj == 'reset' then
			CurrentCamera.CameraType = 'Custom'
			CurrentCamera.CameraSubject = service.Player.Character.Humanoid
			CurrentCamera.FieldOfView = 70
		else
			CurrentCamera.CameraSubject = obj
		end
	end;
}

Remote = {
	PlayerData = {}
}

Core = {
	DataCache = {};
	Cooldown = false;
	CanWriteFile = writefile and true or false;
	DefaultData = function(p)
		return {
			AdminNotes = {};
			Keybinds = {};
			Client = {};
			AdminPoints = {};
			Aliases = {};
		};
	end;
	SaveAsync = function(name, data)
		task.spawn(function()
			if not Core.Cooldown then
				Core.Cooldown = true
				writefile(name, data)
			else
				repeat wait() until not Core.Cooldown
				Core.WriteFile(name, data)
			end
			wait(3)
			Core.Cooldown = false
		end)
	end;
	GetAsync = function(name)
		return readfile(name)
	end;
	GetData = function(key)
		local ran, ret = pcall(Core.GetAsync, key)
		if ran then
			Core.DataCache[key] = ret
			return ret
		else
			return Core.DataCache[key]
		end
	end;
	GetPlayer = function(p)
		local key = tostring(p.UserId)
		local PlayerData = Core.DefaultData(p)
		if not Remote.PlayerData[key] then
			Remote.PlayerData[key] = PlayerData
			local data = Core.GetData(key)
			if data and type(data) == "table" then
				for i, v in next, data do
					PlayerData[i] = v
				end
			end
		else
			PlayerData = Remote.PlayerData[key]
		end
		return PlayerData
	end;
}

Logs = {
	Chats = {};
	Joins = {};
	Commands = {};
	Errors = {};
	ServerDetails = {};
	DateTime = {};
	TempUpdaters = {};
	
	TabToType = function(tab)
		local indToName = {
			Chats = "Chat";
			Joins = "Join";
			Commands = "Command";
			Errors = "Error";
			ServerDetails = "ServerDetails";
			DateTime = "DateTime";
		}

		for ind,t in next,client.Logs do
			if t == tab then
				return indToName[ind] or ind
			end
		end
	end;
	AddLog = function(tab, log, misc)
		if misc then tab = log log = misc end
		if type(tab) == "string" then
			tab = Logs[tab]
		end

		if type(log) == "string" then
			log = {
				Text = log;
				Desc = log;
			}
		end

		if not log.Time and not log.NoTime then
			log.Time = service.GetTime()
		end

		table.insert(tab, 1, log)
		if #tab > tonumber(MaxLogs) then
			table.remove(tab,#tab)
		end
	end;
	
}

Admin = {
	CommandCache = {};
	PrefixCache = {};
	UserIdCache = {};
	BlankPrefix = false;
	GetCommand = function(Command)
		if Admin.PrefixCache[Command:sub(1,1)] or Variables.BlankPrefix then
			local matched
			if string.find(Command, Settings.SplitKey, 1, true) then
				matched = Command:match("^(%S+)"..Settings.SplitKey)
			else
				matched = Command:match("^(%S+)")
			end
			if matched then
				local found = Admin.CommandCache[string.lower(matched)]
				if found then
					local real = Commands[found]
					if real then
						return found, real, matched
					end
				end
			end
		end
	end;
	GetArgs = function(msg, num, ...)
		local args = Functions.Split((msg:match("^.-"..Settings.SplitKey..'(.+)') or ''),Settings.SplitKey,num) or {}
		for i,v in next,{...} do table.insert(args,v) end
		return args
	end;
	RunCommand = function(coma, ...)
		local ind, com = Admin.GetCommand(coma)
		if com then
			local cmdArgs = com.Args or com.Arguments
			local args = Admin.GetArgs(coma, #cmdArgs, ...)
			local ran, err = service.TrackTask("Command: "..tostring(coma), com.Function, service.Player, args, {PlayerData = {Player = service.Player; Level = 5}})
			
		end
	end;
	FormatCommand = function(command)
		local text = command.Prefix..command.Commands[1]
		local cmdArgs = command.Args or command.Arguments
		local splitter = Settings.SplitKey
		
		for ind, arg in next, cmdArgs do
			text = text..splitter.."<"..arg..">"
		end
		
		return text
	end;
	GetPlayerGroup = function(p, group)
		local data = Core.GetPlayer(p)
		local groups = data.Groups
		local isID = type(group) == "number"
		
		if groups then
			for i,v in next, groups do
				if (isID and group == v.Id) or (not isID and group == v.Name) then
					return v
				end
			end
		end
	end;
	CacheCommands = function()
		local tempTable = {}
		local tempPrefix = {}
		for ind,data in pairs(Commands) do
			if not data.Prefix then
				data.Prefix = Settings.Prefix
			end
			if type(data) == "table" then
				for i,cmd in pairs(data.Commands) do
					if data.Prefix == "" then Variables.BlankPrefix = true end
					tempPrefix[data.Prefix] = true
					tempTable[string.lower(data.Prefix..cmd)] = ind
				end
			end
		end

		Admin.PrefixCache = tempPrefix
		Admin.CommandCache = tempTable
	end;
}

Process = {
	Command = function(p, msg, opts, noYield)
		if p ~= service.Player then return end
		local Admin = Admin
		local Functions = Functions
		local Process = Process
		local opts = opts or {}
		
		msg = Functions.Trim(msg)
		
		if msg:match(Settings.BatchKey) then
			for cmd in msg:gmatch("[^"..Settings.BatchKey.."]+") do
				local cmd = Functions.Trim(cmd)
				local waiter = Settings.PlayerPrefix.."wait"
				if cmd:lower():sub(1,#waiter) == waiter then
					local num = cmd:sub(#waiter + 1)
					if num and tonumber(num) then
						wait(tonumber(num))
					end
				else
					Process.Command(p, cmd, opts, false)
				end
			end
		else
			local index, command, matched = Admin.GetCommand(msg)

			if not command then
				if opts.Check then
					Functions.Output(msg.." is not a valid command.", {p})
				end
			else
				local allowed = true
				local isSystem = false
				local pDat = {
					Player = opts.Player or p;
					5;
				}
				
				if opts.isSystem or p == "SYSTEM" then
					isSystem = true
					p = p or "SYSTEM"
				end
				
				if allowed and opts.Chat and command.Chattable == false then
					Functions.Output("You are not permitted this in chat: ".. tostring(msg))
				end
				
				if allowed then
					if not command.Disabled then
						local cmdArgs = command.Args or command.Arguments
						local argString = msg:match("^.-"..Settings.SplitKey..'(.+)') or ''
						local args = (opts.Args or opts.Arguments) or (#cmdArgs > 0 and Functions.Split(argString, Settings.SplitKey, #cmdArgs)) or {}
						local taskName = "Command:: "..tostring(p)..": ("..msg..")"
						local commandId = "Command_"..math.random()
						local running = true
						
						if noYield then
							taskName = "Thread: "..taskName
						end
						
						local ran, error = service.TrackTask(taskName, command.Function, p, args, {PlayerData = pDat, Options = opts})
						if not opts.IgnoreErrors then
							if error and type(error) == "string" then 
								error =  (error and tostring(error):match(":(.+)$")) or error or "Unknown error"
								if not isSystem then 
									Functions.Output(error, {p})
								end 
							elseif error and type(error) ~= "string" then
								if not isSystem then 
									--Functions.Output("There was an error but the error was not a string? "..tostring(error)) 
								end 
							end
						end
					else
						if not isSystem and not opts.NoOutput then
							Functions.Output("This command has been disabled.")
						end
					end
				else
					if not isSystem and not opts.NoOutput then
						Functions.Output('You are not allowed to run '..msg)
					end
				end
			end
		end
	end;
	PlayerAdded = function(p)
		local key = tostring(p.UserId)
		local PlayerData = Core.GetPlayer(p)

		--Remote.PlayerData[key] = nil
		
		p.Chatted:Connect(function(msg)
			local ran, err = service.TrackTask(p.Name.."Chatted", Process.Chat, p, msg)
			if not ran then
				--logError(err)
			end
		end)
	end;
	Chat = function(p, msg)
		Logs.AddLog(Logs.Chat, {
			Text = p.Name..": ".. tostring(msg);
			Desc = tostring(msg);
			Player = p;
		})
		
		if Settings.ChatCommands then
			if string.sub(msg, 1, 3) == "/e " then
				msg = string.sub(msg, 4)
				Process.Command(p, msg, {Chat = true})
			elseif string.sub(msg, 1, 8) == "/system " then
				msg = string.sub(msg, 9)
				Process.Command(p, msg, {Chat = true})
			else
				Process.Command(p, msg, {Chat = true})
			end
		end
	end;
}

UI = {
	GetHolder = function()
		if UI.Holder and UI.Holder.Parent == service.PlayerGui then
			return UI.Holder
		else
			pcall(function()if UI.Holder then UI.Holder:Destroy()end end)
			local new = service.New("ScreenGui", {
				Name = Functions.GetRandom(),
				Parent = service.PlayerGui,
			});
			UI.Holder = new
			return UI.Holder
		end
	end;
	Get = function(obj,ignore,returnOne)
		local found = {};
		local num = 0
		if obj then
			for ind,g in next,client.GUIs do
				if g.Name ~= ignore and g.Object ~= ignore and g ~= ignore then
					if type(obj) == "string" then
						if g.Name == obj then
							found[ind] = g
							num = num+1
							if returnOne then return g end
						end
					elseif type(obj) == "userdata" then
						if rawequal(g.Object, obj) then
							found[ind] = g
							num = num+1
							if returnOne then return g end
						end
					elseif type(obj) == "boolean" and obj == true then
						found[ind] = g
						num = num+1
						if returnOne then return g end
					end
				end
			end
		end
		if num<1 then
			return false
		else
			return found,num
		end
	end;
	Register = function(gui, data)
		local gIndex = Functions.GetRandom()
		local gTable; gTable = {
			Object = gui;
			Name = gui.Name;
			Class = gui.ClassName;
			Index = gIndex;
			Active = true;
			Ready = function()
				if gTable.Config then gTable.Config.Parent = nil end
				local ran,err = pcall(function()
					local obj = gTable.Object;
					if gTable.Class == "ScreenGui" or gTable.Class == "GuiMain" then
						if obj.DisplayOrder == 0 then
							obj.DisplayOrder = 90000
						end

						obj.Enabled = true
						obj.Parent = CoreGui
					else
						obj.Parent = UI.GetHolder()
					end
				end);
				if ran then
					gTable.Active = true
				else
					warn("Something happened while trying to set the parent of "..tostring(gTable.Name))
					warn(tostring(err))
					gTable:Destroy()
				end
			end;
			Destroy = function()
				pcall(function()
					if gTable.CustomDestroy then
						gTable.CustomDestroy()
					else
						gTable.Object:Destroy()
					end
				end)
				gTable.Destroyed = true
				gTable.Active = false
				client.GUIs[gIndex] = nil
			end;
			Register = function(tab,new)
				if not new then new = tab end

				gTable.Class = new.ClassName

				if gTable.AncestryEvent then
					gTable.AncestryEvent:Disconnect()
				end

				gTable.AncestryEvent = new.AncestryChanged:Connect(function(c, parent)
					if client.GUIs[gIndex] then
						if rawequal(c, gTable.Object) and gTable.Class == "TextLabel" and parent == service.PlayerGui then
							wait()
							gTable.Object.Parent = UI.GetHolder()
						elseif rawequal(c, gTable.Object) and parent == nil and not gTable.KeepAlive then
							gTable:Destroy()
						elseif rawequal(c, gTable.Object) and parent ~= nil then
							gTable.Active = true
							client.GUIs[gIndex] = gTable
						end
					end
				end)
				client.GUIs[gIndex] = gTable
			end
		}
		if data then
			for i,v in next,data do
				gTable[i] = v
			end
		end
		gui.Name = Functions.GetRandom()
		gTable:Register(gui)
		
		return gTable, gIndex
	end;
	MakeGui = function(GUI, data)
		local GUIs = {
			Message = function()
				local title = data.Title
				local message = data.Message
				local scroll = data.Scroll
				local tim = data.Time
				
				local gui = service.New("ScreenGui")
				gui.Name = "MessageGui"
				gui.ResetOnSpawn = false
				local frame = service.New("Frame", gui)
				frame.BackgroundColor3 = Color3.new(0, 0, 0)
				frame.BackgroundTransparency = 1
				frame.BorderSizePixel = 1
				frame.Position = UDim2.new(0, 0, 0, -50)
				frame.Size = UDim2.new(1, 0, 1, 50)
				frame.ZIndex = 7
				local ttl = service.New("TextLabel", frame)
				ttl.Name = "Title"
				ttl.BackgroundTransparency = 1
				ttl.BorderSizePixel = 0
				ttl.Position = UDim2.new(0, 10, 0, 60)
				ttl.Size = UDim2.new(1, -20, 0, 30)
				ttl.ZIndex = 7
				ttl.Font = "ArialBold"
				ttl.Text = title
				ttl.TextColor3 = Color3.new(1, 1, 1)
				ttl.TextStrokeColor3 = Color3.fromRGB(53, 53, 53)
				ttl.FontSize = "Size24"
				ttl.TextSize = 24
				ttl.TextStrokeTransparency = 1
				ttl.TextTransparency = 1
				ttl.TextWrapped = true
				local msg = service.New("TextLabel", frame)
				msg.Name = "Message"
				msg.BackgroundTransparency = 1
				msg.BorderSizePixel = 1
				msg.Position = UDim2.new(0, 10, 0, 95)
				msg.Size = UDim2.new(1, -20, 1, -105)
				msg.ZIndex = 7
				msg.Font = "Arial"
				msg.Text = message
				msg.FontSize = "Size28"
				msg.TextSize = 28
				msg.TextStrokeTransparency = 1
				msg.TextTransparency = 1
				msg.TextColor3 = Color3.new(1, 1, 1)
				msg.TextStrokeColor3 = Color3.fromRGB(80, 80, 80)
				msg.TextWrapped = true

				local blur = service.New("BlurEffect")
				blur.Enabled = false
				blur.Size = 0
				blur.Parent = service.Workspace.CurrentCamera

				local fadeSteps = 10
				local blurSize = 10
				local textFade = 0.1
				local strokeFade = 0.5
				local frameFade = 0.3

				local blurStep = blurSize/fadeSteps
				local frameStep = frameFade/fadeSteps
				local textStep = 0.1
				local strokeStep = 0.1
				local gone = false

				coroutine.wrap(function()
					local playerGui = service.Player:findFirstChildOfClass("PlayerGui")
					local ind = tostring(service.Player.UserId)
					local sgui = SavedGuis[ind] and SavedGuis[ind].Message
					if sgui then
						sgui:Destroy()
					end
					if not SavedGuis[ind] then
						SavedGuis[ind] = {}
					end
					local gui = gui:Clone()
					SavedGuis[ind].Message = gui
					local frame = gui.Frame
					local ttl = frame.Title
					local msg = frame.Message
					gui.Parent = playerGui
					local function fadeIn()
						if not gone then
							blur.Enabled = true
							for i = 1,fadeSteps do
								if blur.Size<blurSize then
									blur.Size = blur.Size+blurStep
								end
								if msg.TextTransparency>textFade then
									msg.TextTransparency = msg.TextTransparency-textStep
									ttl.TextTransparency = ttl.TextTransparency-textStep
								end
								if msg.TextStrokeTransparency>strokeFade then
									msg.TextStrokeTransparency = msg.TextStrokeTransparency-strokeStep
									ttl.TextStrokeTransparency = ttl.TextStrokeTransparency-strokeStep
								end
								if frame.BackgroundTransparency>frameFade then
									frame.BackgroundTransparency = frame.BackgroundTransparency-frameStep
								end
								wait(1/60) --service.Wait("Stepped")
							end
						end
					end
					local function fadeOut()
						for i = 1,fadeSteps do
							if blur.Size>0 then
								blur.Size = blur.Size-blurStep
							end
							if msg.TextTransparency<1 then
								msg.TextTransparency = msg.TextTransparency+textStep
								ttl.TextTransparency = ttl.TextTransparency+textStep
							end
							if msg.TextStrokeTransparency<1 then
								msg.TextStrokeTransparency = msg.TextStrokeTransparency+strokeStep
								ttl.TextStrokeTransparency = ttl.TextStrokeTransparency+strokeStep
							end
							if frame.BackgroundTransparency<1 then
								frame.BackgroundTransparency = frame.BackgroundTransparency+frameStep
							end
							wait(1/60)
						end
						blur.Enabled = false
						blur:Destroy()
						gui:Destroy()
						gone = true
					end
					fadeIn()
					wait(tim or 5)
					if not gone then
						fadeOut()
					end
				end)()
			end;
			Output = function()
				local message = data.Message
				local time = data.Time
				
				local num = time and tonumber(time) or 5
				local frame = service.New("Frame")
				frame.Name = "Error"
				frame.Active = false
				frame.BackgroundColor3 = Color3.new(0, 0, 0)
				frame.BackgroundTransparency = 0.4
				frame.BorderSizePixel = 0
				frame.Size = UDim2.new(1, 0, 0, 45)
				local msg = service.New("TextLabel", frame)
				msg.Name = "Message"
				msg.Active = false
				msg.BackgroundColor3 = Color3.new(0, 0, 0)
				msg.BackgroundTransparency = 1
				msg.Font = "Arial"
				msg.FontSize = "Size24"
				msg.TextSize = 24
				msg.Position = UDim2.new(0, 0, 0, 4)
				msg.Size = UDim2.new(1, 0, 	1, -8)
				msg.Text = message
				msg.TextColor3 = Color3.fromRGB(255, 55, 55)
				msg.TextStrokeColor3 = Color3.fromRGB(86, 86, 86)
				msg.TextStrokeTransparency = 0.7
				msg.TextWrapped = true
				msg.ZIndex = 10
				coroutine.wrap(function()
					local ind = tostring(service.Player.UserId)
					local sgui = SavedGuis[ind] and SavedGuis[ind].Output
					if not (sgui and sgui.Parent) then
						sgui = service.New("ScreenGui")
						sgui.Name = "OutputScreenGui"
						sgui.Parent = service.Player:findFirstChildOfClass("PlayerGui")
					end
					if not SavedGuis[ind] then
						SavedGuis[ind] = {}
					end
					SavedGuis[ind].Output = sgui
					local main = frame:Clone()
					main.Position = UDim2.new(0, 0, 0.35, 0)
					for a, frame in pairs(sgui:GetChildren()) do
						if frame:IsA("Frame") then
							frame.Position = UDim2.new(0, 0, 0.35, frame.Position.Y.Offset + 45)
						end
					end
					main.Parent = sgui
					delay(num, function()
						main:Destroy()
					end)
				end)()
			end;
			Hint = function()
				local message = data.Message
				local time = data.Time
				
				local num = time and tonumber(time) or 5
				local frame = service.New("Frame")
				frame.Name = "Hint"
				frame.Active = false
				frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				frame.BackgroundTransparency = 0.5
				frame.BorderSizePixel = 0
				frame.Size = UDim2.new(1, 0, 0, 28)
				local msg = service.New("TextLabel", frame)
				msg.Name = "Message"
				msg.Active = false
				msg.BackgroundColor3 = Color3.new(0, 0, 0)
				msg.BackgroundTransparency = 1
				msg.Font = "SourceSansBold"
				msg.FontSize = "Size18"
				msg.Position = UDim2.new(0, 0, 0, 5)
				msg.Size = UDim2.new(1, 0, 	1, -10)
				msg.Text = message
				msg.TextColor3 = Color3.fromRGB(255, 255, 255)
				msg.TextStrokeColor3 = Color3.fromRGB(86, 86, 86)
				msg.TextStrokeTransparency = 0.9
				msg.TextWrapped = true
				coroutine.wrap(function()
					local ind = tostring(service.Player.userId)
					local sgui = SavedGuis[ind] and SavedGuis[ind].Hint
					if not (sgui and sgui.Parent) then
						sgui = service.New("ScreenGui")
						sgui.Name = "HintScreenGui"
						sgui.Parent = service.Player:findFirstChildOfClass("PlayerGui")
					end
					if not SavedGuis[ind] then
						SavedGuis[ind] = {}
					end
					SavedGuis[ind].Hint = sgui
					local main = sgui:findFirstChild("Main") or service.New("Frame", sgui)
					main.Name = "Main"
					main.Active = false
					main.BackgroundTransparency = 1
					main.Position = UDim2.new(0, 0, 0, 0)
					main.Size = UDim2.new(1, 0, 0, 28 * 5)
					local first = main:GetChildren()[2]
					local uiList = main:findFirstChildOfClass("UIListLayout") or service.New("UIListLayout", main)
					if #main:GetChildren() >= 5 then
						if first then
							first:Destroy()
						end
					end
					local newFrame = frame:Clone()
					newFrame.Parent = main
					delay(num, function()
						newFrame:Destroy()
					end)
				end)()
			end;
			Notification = function()
				local frame = service.New("Frame", {
					Name = "Notification";
					Active = false;
					BackgroundColor3 = Color3.fromRGB(13, 13, 13);
					BackgroundTransparency = 0.25;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 0, 1, -65);
					Size = UDim2.new(1, -5, 0, 60);
					ZIndex = 9;
				})
				
				--local uiCorner = service.New("UICorner", {
				--	CornerRadius = UDim.new(0, 8);
				--	Parent = frame;
				--})
				
				local nFrame = service.New("Frame", {
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Size = UDim2.new(1, 0, 1, 0);
					Parent = frame;
				})
				
				local main = service.New("TextButton", {
					Name = "Main";
					BackgroundTransparency = 1;
					Position = UDim2.new(0, 5, 0, 26);
					Size = UDim2.new(1, -10, 0.52, 0);
					ZIndex = 10;
					Font = "SourceSans";
					Text = "";
					TextColor3 = Color3.new(1, 1, 1);
					TextScaled = true;
					TextSize = 20;
					TextStrokeTransparency = 1;
					TextXAlignment = "Left";
					TextYAlignment = "Top";
					Parent = nFrame;
				})
				
				local uiTSC = service.New("UITextSizeConstraint", {
					MaxTextSize = 20;
					MinTextSize = 12;
					Parent = main;
				})
				
				local close = service.New("TextButton", {
					Name = "Close";
					BackgroundColor3 = Color3.fromRGB(195, 33, 35);
					BackgroundTransparency = 0.5;
					BorderSizePixel = 0;
					Position = UDim2.new(1, -25, 0, 5);
					Size = UDim2.new(0, 20, 0, 20);
					ZIndex = 10;
					Font = "SourceSansBold";
					Text = "x";
					TextColor3 = Color3.new(1, 1, 1);
					TextSize = 25;
					TextStrokeTransparency = 1;
					TextWrapped = true;
					TextYAlignment = "Bottom";
					Parent = nFrame;
				})
				
				local title = service.New("TextLabel", {
					Name = "Title";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 30, 0, 8);
					Size = UDim2.new(1, -25, 0, 15);
					ZIndex = 10;
					Font = "Arial";
					Text = "Notification";
					TextColor3 = Color3.new(1, 1, 1);
					TextSize = 18;
					TextStrokeColor3 = Color3.fromRGB(90, 90, 90);
					TextStrokeTransparency = 0.8;
					TextXAlignment = "Left";
					Parent = nFrame;
				})
				
				local timer = service.New("TextLabel", {
					Name = "Timer";
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(1, -60, 0, 5);
					Size = UDim2.new(0, 30, 0, 20);
					Visible = false;
					ZIndex = 10;
					Font = "SourceSansBold";
					Text = 60;
					TextColor3 = Color3.new(1, 1, 1);
					TextSize = 18;
					TextStrokeTransparency = 1;
					TextXAlignment = "Right";
					Parent = nFrame;
				})
				
				local iconF = service.New("ImageLabel", {
					Name = "Icon";
					BackgroundColor3 = Color3.new(1, 1, 1);
					BackgroundTransparency = 1;
					BorderSizePixel = 0;
					Position = UDim2.new(0, 5, 0, 5);
					Size = UDim2.new(0, 20, 0, 20);
					ZIndex = 10;
					Image = "rbxassetid://7510999669";
					ImageColor3 = Color3.new(1, 1, 1);
					SliceScale = 1;
					Parent = nFrame;
					
				})
				
				local gTable = UI.Register(frame)
				gTable:Ready()
				
				local name = data.Title
				local text = data.Message or data.Text or ""
				local time = data.Time
				local icon = data.Icon or "rbxassetid://7510999669"
				
				local clickfunc = data.OnClick
				local closefunc = data.OnClose
				local ignorefunc = data.OnIgnore
				
				local returner
				
				local holder = UI.Get("NotificationHolder", nil, true)
				if not holder then
					local hold = service.New("ScreenGui")
					local hTable = UI.Register(hold)
					local frame = service.New("ScrollingFrame", hold)
					hTable.Name = "NotificationHolder"
					frame.Name = "Frame"
					frame.BackgroundTransparency = 1
					frame.Size = UDim2.new(0, 200, 0.5, 0)
					frame.Position = UDim2.new(1, -210, 0.5, -10)
					frame.CanvasSize = UDim2.new(0, 0, 0, 0)
					frame.ChildAdded:Connect(function(c)
						if #frame:GetChildren() == 0 then
							frame.Visible = false
						else
							frame.Visible = true
						end
					end)

					frame.ChildRemoved:Connect(function(c)
						if #frame:GetChildren() == 0 then
							frame.Visible = false
						else
							frame.Visible = true
						end
					end)

					holder = hTable
					hTable:Ready()
				end
				
				local function moveGuis(holder,mod)
					local holdstuff = {}
					for i,v in pairs(holder:GetChildren()) do
						table.insert(holdstuff,1,v)
					end
					for i,v in pairs(holdstuff) do
						v.Position = UDim2.new(0,0,1,-75*(i+mod))
					end
					holder.CanvasSize=UDim2.new(0,0,0,(#holder:GetChildren()*75))
					local pos = (((#holder:GetChildren())*75) - holder.AbsoluteWindowSize.Y)
					if pos<0 then pos = 0 end
					holder.CanvasPosition = Vector2.new(0,pos)
				end
				
				holder = holder.Object.Frame
				title.Text = name
				main.Text = text
				iconF.Image = icon
				
				main.MouseButton1Click:Connect(function()
					if frame and frame.Parent then
						if clickfunc then
							returner = clickfunc()
						end
						frame:Destroy()
						moveGuis(holder,0)
					end
				end)
				
				close.MouseButton1Click:Connect(function()
					if frame and frame.Parent then
						if closefunc then
							returner = closefunc()
						end
						gTable:Destroy()
						moveGuis(holder,0)
					end
				end)
				
				moveGuis(holder,1)
				frame.Parent = holder
				frame:TweenPosition(UDim2.new(0,0,1,-75),'Out','Linear',0.2)

				spawn(function()
					local sound = Instance.new("Sound",service.LocalContainer())
					sound.SoundId = 'rbxassetid://'.."203785584"--client.NotificationSound
					sound.Volume = 0.2
					wait(0.1)
					sound:Play()
					wait(0.5)
					sound:Destroy()
				end)
				
				if time then
					timer.Visible = true
					spawn(function()
						repeat
							timer.Text = time
							--timer.Size=UDim2.new(0,timer.TextBounds.X,0,10)
							wait(1)
							time = time-1
						until time<=0 or not frame or not frame.Parent

						if frame and frame.Parent then
							if ignorefunc then
								returner = ignorefunc()
							end
							frame:Destroy()
							moveGuis(holder,0)
						end
					end)
				end
				
				repeat wait() until returner ~= nil or not frame or not frame.Parent
				
				return returner
			end;
		}
		
		local func = GUIs[GUI]
		if func then
			coroutine.wrap(func)()
		end
	end;
}

--// Commands

Commands = setmetatable({
	Respawn = {
		Commands = {"respawn", "re"};
		Args = {};
		Description = "Respawn you";
		FE = true;
		Function = function(plr, args)
			local char = plr.Character
			if char:FindFirstChildOfClass("Humanoid") then
				char:FindFirstChildOfClass("Humanoid"):ChangeState(15)
			end
			char:ClearAllChildren()
			local newChar = Instance.new("Model")
			newChar.Parent = workspace
			plr.Character = newChar
			wait()
			plr.Character = char
			newChar:Destroy()
		end
	};
	
	Refresh = {
		Commands = {"refresh", "ref"};
		Args = {};
		Description = "Refresh you in your last position";
		FE = true;
		Function = function(plr, args)
			local Human = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid", true)
			local pos = Human and Human.RootPart and Human.RootPart.CFrame
			local pos1 = workspace.CurrentCamera.CFrame
			Admin.RunCommand("respawn")
			plr.CharacterAdded:Wait():WaitForChild("Humanoid").RootPart.CFrame, workspace.CurrentCamera.CFrame = pos, wait() and pos1
		end
	};
	
	Kill = {
		Commands = {"kill"};
		Args = {"player"};
		Description = "Kills player (To kill another player, you need a tool)";
		FE = true;
		Function = function(plr, args)
			local target = service.GetPlayers(plr, args[1])[1]
			if target == plr then
				local humanoid = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState(15)
				end
			elseif target then
				local backpack = target:findFirstChildOfClass("Backpack")
				if backpack:findFirstChildOfClass("Tool") or (target.Character and target.Character:findFirstChildOfClass("Tool")) then
					local root = target.Character and target.Character:findFirstChild("HumanoidRootPart")
					if root then
						local NormPos = root.CFrame
						repeat
							wait()
							root.CFrame = CFrame.new(999999, workspace.FallenPartsDestroyHeight + 5,999999)
						until not target.Character:findFirstChild("HumanoidRootPart") or not plr.Character:findFirstChild("HumanoidRootPart")
						wait(1)
						plr.CharacterAdded:Wait():WaitForChild("HumanoidRootPart").CFrame = NormPos
					end
				else
					error("[Tool Required]: You need to have an item in your inventory to use this command", 0)
				end
			end
		end
	};
	
	WorkspaceGravity = {
		Commands = {"ggrav", "gamegrav", "workspacegrav"};
		Args = {"number or fix"};
		Description = "Change workspace's gravity";
		Function = function(plr, args)
			local num = tonumber(args[1])
			if num then
				workspace.Gravity = num
			else
				workspace.Gravity = 196.2
			end
		end
	};
	
	Sit = {
		Commands = {"sit", "seat"};
		Args = {};
		FE = true;
		Description = "Sit player";
		Function = function(plr, args)
			local hum = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if hum then
				hum.Sit = true
			end
		end
	};
	
	Jump = {
		Commands = {"jump"};
		Args = {};
		FE = true;
		Description = "Jump player";
		Function = function(plr, args)
			local hum = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if hum then
				hum.Jump = true
			end
		end
	};
	
	Stun = {
		Commands = {"stun"; "platformstand"};
		Args = {};
		FE = true;
		Description = "Stun player";
		Function = function(plr, args)
			local hum = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if hum then
				hum.PlatformStand = true
			end
		end
	};
	
	UnStun = {
		Commands = {"unstun", "unplatformstand"};
		Args = {};
		FE = true;
		Description = "Unstun player";
		Function = function(plr, args)
			local hum = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if hum then
				hum.PlatformStand = false
			end
		end
	};
	
	ClientTeleport = {
		Commands = {"tp"; "teleport"; "transport"};
		Args = {"player1", "player2"};
		Description = "Teleports a player (Client)";
		Function = function(plr, args)
			if args[2]:match('^waypoint%-(.*)') or args[2]:match('wp%-(.*)') then
				local m = args[2]:match('^waypoint%-(.*)') or args[2]:match('wp%-(.*)')
				local point

				for i,v in pairs(Variables.Waypoints) do
					if i:lower():sub(1,#m)==m:lower() then
						point=v
					end
				end

				for i,v in pairs(service.GetPlayers(plr,args[1])) do
					if point then
						if v.Character.Humanoid.SeatPart~=nil then
							Functions.RemoveSeatWelds(v.Character.Humanoid.SeatPart)
						end
						if v.Character.Humanoid.Sit then
							v.Character.Humanoid.Sit = false
							v.Character.Humanoid.Jump = true
						end
						wait()
						v.Character.HumanoidRootPart.CFrame = CFrame.new(point)
					end
				end

				if not point then Functions.Hint('Waypoint '..m..' was not found.',{plr}) end
			elseif args[2]:find(',') then
				local x,y,z = args[2]:match('(.*),(.*),(.*)')
				for i,v in pairs(service.GetPlayers(plr,args[1])) do
					if v.Character.Humanoid.SeatPart~=nil then
						Functions.RemoveSeatWelds(v.Character.Humanoid.SeatPart)
					end
					if v.Character.Humanoid.Sit then
						v.Character.Humanoid.Sit = false
						v.Character.Humanoid.Jump = true
					end
					wait()
					v.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(tonumber(x),tonumber(y),tonumber(z)))
				end
			else
				local target = service.GetPlayers(plr,args[2])[1]
				local players = service.GetPlayers(plr,args[1])
				if #players == 1 and players[1] == target then
					local n = players[1]
					if n.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
						if n.Character.Humanoid.SeatPart~=nil then
							Functions.RemoveSeatWelds(n.Character.Humanoid.SeatPart)
						end
						if n.Character.Humanoid.Sit then
							n.Character.Humanoid.Sit = false
							n.Character.Humanoid.Jump = true
						end
						wait()
						n.Character.HumanoidRootPart.CFrame = (target.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#players*1),0)*CFrame.new(5+.2*#players,0,0))*CFrame.Angles(0,math.rad(90),0)
					end
				else
					for k,n in pairs(players) do
						if n~=target then
							if n.Character.Humanoid.SeatPart~=nil then
								Functions.RemoveSeatWelds(n.Character.Humanoid.SeatPart)
							end
							if n.Character.Humanoid.Sit then
								n.Character.Humanoid.Sit = false
								n.Character.Humanoid.Jump = true
							end
							wait()
							if n.Character:FindFirstChild("HumanoidRootPart") and target.Character:FindFirstChild("HumanoidRootPart") then
								n.Character.HumanoidRootPart.CFrame = (target.Character.HumanoidRootPart.CFrame*CFrame.Angles(0,math.rad(90/#players*k),0)*CFrame.new(5+.2*#players,0,0))*CFrame.Angles(0,math.rad(90),0)
							end
						end
					end
				end
			end
		end,
	};
	
	To = {
		Commands = {"to"; "tpmeto"};
		Args = {"players"};
		Description = "Teleport you to the target";
		FE = true;
		Function = function(plr, args)
			for i, v in pairs(service.GetPlayers(plr, args[1])) do
				Admin.RunCommand(Settings.Prefix.."tp", plr.Name, v.Name)
			end
		end
	};
	
	FreeFall = {
		Commands = {"freefall"; "skydive"};
		Args = {"height"};
		FE = true;
		Description = "Teleport you up by <height> studs";
		Function = function(plr, args)
			local root = plr.Character and plr.Character:findFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = root.CFrame + Vector3.new(0, tonumber(args[1]), 0)
			end
		end
	};
	
	Fly = {
		Commands = {"fly"; "flight"};
		Args = {"speed"};
		FE = true;
		Description = "Lets you fly";
		Function = function(plr, args)
			local char = plr.Character
			local part = char and char:findFirstChild("HumanoidRootPart")
			if part then
				
				local oldp = part:FindFirstChild("ADONIS_FLIGHT_POSITION")
				local oldg = part:FindFirstChild("ADONIS_FLIGHT_GYRO")
				local olds = part:FindFirstChild("ADONIS_FLIGHT")
				if oldp then oldp:Destroy() end
				if oldg then oldg:Destroy() end
				if olds then olds:Destroy() end
				
				local DataFolder = service.New("Folder", {
					Name = "ADONIS_FLIGHT";
					Parent = part;
				})
				
				local sVal = Instance.new("NumberValue")
				sVal.Name = "Speed"
				sVal.Value = 2
				sVal.Parent = DataFolder


				local NoclipVal = Instance.new("BoolValue")
				NoclipVal.Name = "Noclip"
				NoclipVal.Value = true
				NoclipVal.Parent = DataFolder

				local flightPosition = Instance.new("BodyPosition")
				local flightGyro = Instance.new("BodyGyro")

				flightPosition.Name = "ADONIS_FLIGHT_POSITION"
				flightPosition.MaxForce = Vector3.new(0, 0, 0)
				flightPosition.Position = part.Position
				flightPosition.Parent = part

				flightGyro.Name = "ADONIS_FLIGHT_GYRO"
				flightGyro.MaxTorque = Vector3.new(0, 0, 0)
				flightGyro.CFrame = part.CFrame
				flightGyro.Parent = part
				
				UI.MakeGui("Notification", {
					Title = "Flight";
					Message = "You are now flying. Press E to toggle flight.";
					Time = 10;
				})
				
				local human = char:findFirstChildOfClass("Humanoid")
				
				local bPos = flightPosition
				local bGyro = flightGyro
				
				local speedVal = sVal
				local noclip = NoclipVal
				
				local Create = Instance.new
				local flying = true

				local keyTab = {}
				local dir = {}

				local antiLoop, humChanged, conn
				local Check, getCF, dirToCom, Start, Stop, Toggle, HandleInput, listenConnection

				local RBXConnections = {}
				function listenConnection(Connection, callback)
					local RBXConnection = Connection:Connect(callback)
					table.insert(RBXConnections, RBXConnection)
					return RBXConnection
				end
				
				function Check()
					if DataFolder.Parent == part then
						return true
					end
				end

				function getCF(part, isFor)
					local cframe = part.CFrame
					local noRot = CFrame.new(cframe.p)
					local x, y, z = (workspace.CurrentCamera.CoordinateFrame - workspace.CurrentCamera.CoordinateFrame.p):toEulerAnglesXYZ()
					return noRot * CFrame.Angles(isFor and z or x, y, z)
				end

				function dirToCom(part, mdir)
					local dirs = {
						Forward = ((getCF(part, true)*CFrame.new(0, 0, -1)) - part.CFrame.p).p;
						Backward = ((getCF(part, true)*CFrame.new(0, 0, 1)) - part.CFrame.p).p;
						Right = ((getCF(part)*CFrame.new(1, 0, 0)) - part.CFrame.p).p;
						Left = ((getCF(part)*CFrame.new(-1, 0, 0)) - part.CFrame.p).p;
					}

					for i,v in next,dirs do
						if (v - mdir).Magnitude <= 1.05 and mdir ~= Vector3.new(0,0,0) then
							dir[i] = true
						elseif not keyTab[i] then
							dir[i] = false
						end
					end
				end
				
				function Start()
					local curSpeed = 0
					local topSpeed = speedVal.Value
					local speedInc = topSpeed/25
					local camera = workspace.CurrentCamera
					local antiReLoop = {}
					local realPos = part.CFrame

					listenConnection(speedVal.Changed, function()
						topSpeed = speedVal.Value
						speedInc = topSpeed/25
					end)

					bPos.Position = part.Position
					bPos.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

					bGyro.CFrame = part.CFrame
					bGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

					antiLoop = antiReLoop

					if noclip.Value then
						conn = RunService.Stepped:Connect(function()
							for _,v in pairs(char:GetDescendants()) do
								if v:IsA("BasePart") then
									v.CanCollide = false
								end
							end
						end)
					end

					while flying and antiLoop == antiReLoop do
						if not Check() then
							break
						end

						local new = bGyro.cframe - bGyro.cframe.p + bPos.position
						if not dir.Forward and not dir.Backward and not dir.Up and not dir.Down and not dir.Left and not dir.Right then
							curSpeed = 1
						else
							if dir.Up then
								new = new * CFrame.new(0, curSpeed, 0)
								curSpeed = curSpeed + speedInc
							end

							if dir.Down then
								new = new * CFrame.new(0, -curSpeed, 0)
								curSpeed = curSpeed + speedInc
							end

							if dir.Forward then
								new = new + camera.CoordinateFrame.LookVector * curSpeed
								curSpeed = curSpeed + speedInc
							end

							if dir.Backward then
								new = new - camera.CoordinateFrame.LookVector * curSpeed
								curSpeed = curSpeed + speedInc
							end

							if dir.Left then
								new = new * CFrame.new(-curSpeed, 0, 0)
								curSpeed = curSpeed + speedInc
							end

							if dir.Right then
								new = new * CFrame.new(curSpeed, 0, 0)
								curSpeed = curSpeed + speedInc
							end

							if curSpeed > topSpeed then
								curSpeed = topSpeed
							end
						end

						human.PlatformStand = true
						bPos.position = new.p

						if dir.Forward then
							bGyro.cframe = camera.CoordinateFrame*CFrame.Angles(-math.rad(curSpeed*7.5), 0, 0)
						elseif dir.Backward then
							bGyro.cframe = camera.CoordinateFrame*CFrame.Angles(math.rad(curSpeed*7.5), 0, 0)
						else
							bGyro.cframe = camera.CoordinateFrame
						end

						RunService.RenderStepped:Wait()
					end

					Stop()
				end
				
				function Stop()
					flying = false
					human.PlatformStand = false

					if humChanged then
						humChanged:Disconnect()
					end

					if bPos then
						bPos.maxForce = Vector3.new(0, 0, 0)
					end

					if bGyro then
						bGyro.maxTorque = Vector3.new(0, 0, 0)
					end

					if conn then
						conn:Disconnect()
					end
				end
				
				local debounce = false
				function Toggle()
					if not debounce then
						debounce = true
						if not flying then
							flying = true
							coroutine.wrap(Start)()
						else
							flying = false
							Stop()
						end
						wait(0.5)
						debounce = false
					end
				end
				
				function HandleInput(input, isGame, bool)
					if not isGame then
						if input.UserInputType == Enum.UserInputType.Keyboard then
							if input.KeyCode == Enum.KeyCode.W then
								keyTab.Forward = bool
								dir.Forward = bool
							elseif input.KeyCode == Enum.KeyCode.A then
								keyTab.Left = bool
								dir.Left = bool
							elseif input.KeyCode == Enum.KeyCode.S then
								keyTab.Backward = bool
								dir.Backward = bool
							elseif input.KeyCode == Enum.KeyCode.D then
								keyTab.Right = bool
								dir.Right = bool
							elseif input.KeyCode == Enum.KeyCode.Q then
								keyTab.Down = bool
								dir.Down = bool
							elseif input.KeyCode == Enum.KeyCode.Space then
								keyTab.Up = bool
								dir.Up = bool
							elseif input.KeyCode == Enum.KeyCode.E and bool == true then
								Toggle()
							end
						end
					end
				end
				
				listenConnection(part.DescendantRemoving, function(Inst)
					if Inst == bPos or Inst == bGyro or Inst == speedVal or Inst == noclip then
						if conn then
							conn:Disconnect()
						end

						for _, Signal in pairs(RBXConnections) do
							Signal:Disconnect()
						end

						Stop()
					end
				end)
				
				listenConnection(InputService.InputBegan, function(input, isGame)
					HandleInput(input, isGame, true)
				end)

				listenConnection(InputService.InputEnded, function(input, isGame)
					HandleInput(input, isGame, false)
				end)

				coroutine.wrap(Start)()

				if not InputService.KeyboardEnabled then
					listenConnection(human.Changed, function()
						dirToCom(part, human.MoveDirection)
					end)

					ContextService:BindAction("Toggle Flight", Toggle, true)

					while true do
						if not Check() then
							break
						end

						RunService.Stepped:Wait()
					end

					ContextService:UnbindAction("Toggle Flight")
				end
			end
		end
	};
	
	FlySpeed = {
		Commands = {"flyspeed"; "flightspeed"};
		Args = {"speed"};
		FE = true;
		Description = "Change your flight speed";
		Function = function(plr, args)
			local speed = tonumber(args[1])
			
			local part = plr.Character and plr.Character:findFirstChild("HumanoidRootPart")
			if part then
				local scr = part:findFirstChild("ADONIS_FLIGHT")
				if scr then
					local sVal = scr:findFirstChild("Speed")
					if sVal then
						sVal.Value = speed or 2
					end
				end
			end
		end
	};
	
	UnFly = {
		Commands = {"unfly"; "ground"};
		Args = {};
		FE = true;
		Description = "Removes you the ability to fly";
		Function = function(plr, args)
			local part = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
			if part then
				local oldp = part:FindFirstChild("ADONIS_FLIGHT_POSITION")
				local oldg = part:FindFirstChild("ADONIS_FLIGHT_GYRO")
				local olds = part:FindFirstChild("ADONIS_FLIGHT")
				if oldp then oldp:Destroy() end
				if oldg then oldg:Destroy() end
				if olds then olds:Destroy() end
			end
		end,
	};
	
	SetCoreGuiEnabled = {
		Commands = {"setcoreguienabled";"setcoreenabled";"showcoregui";"setcgui";"setcore"};
		Args = {"element","true/false"};
		Description = "SetCoreGuiEnabled. Enables/Disables CoreGui elements.";
		Function = function(plr, args)
			if string.lower(args[2])=='on' or string.lower(args[3])=='true' then
				service.StarterGui:SetCoreGuiEnabled(args[1], true)
			elseif string.lower(args[2])=='off' or string.lower(args[3])=='false' then
				service.StarterGui:SetCoreGuiEnabled(args[1], false)
			end
		end
	};
	
	Execute = {
		Commands = {"execute"; "loadstring"; "exec"; "lstr"; "ls"};
		Args = {"code"};
		Description = "Executes the given code on the client";
		Function = function(plr, args)
			local func, y = loadstring(args[1])
			if func then
				local genv = getgenv()
				setfenv(func, setmetatable({}, {
					__index = function(self, index)
						return genv[index]
					end,
					__metatable  = "The metatable is locked"
				}))
				spawn(func)
			else
				error("Unable to execute: "..tostring(y), 0)
			end
		end
	};
	
	Speed = {
		Commands = {"speed"; "setspeed"; "walkspeed"; "ws"};
		Args = {"number"};
		FE = true;
		Description = "Set your WalkSpeed to <number>";
		Function = function(plr, args)
			local human = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if human then
				human.WalkSpeed = args[1] or 16
				UI.MakeGui("Notification", {
					Title = "Notification";
					Message = "Character walk speed has been set to "..human.WalkSpeed;
					Time = 15;
				})
			end
		end
	};
	
	ExitGame = {
		Commands = {"exitgame"; "leavegame"; "leave"};
		Args = {};
		Description = "Leave the game";
		Function = function(plr, args)
			game:shutdown()
		end
	};
	
	SetFOV = {
		Commands = {"fov"; "fieldofview"; "setfov"};
		Args = {"number"};
		Description = "Set yours field of view to <number>";
		Function = function(plr, args)
			assert(args[1] and tonumber(args[1]), "Argument missing or invalid")
			workspace.CurrentCamera.FieldOfView = tonumber(args[1])
		end
	};
	
	Place = {
		Commands = {"place"};
		Args = {"placeID"};
		Description = "Teleport to the desired place";
		Function = function(plr, args)
			local id = tonumber(args[1])
			local name
			pcall(function() name = game:GetService("MarketplaceService"):GetProductInfo(id).Name end)
			if id and name then
				Functions.Message("Adonis", "Teleporting to place "..name.."\nPlease wait", 10)
				service.TeleportService:Teleport(args[1], plr)
			else
				error("Invalid place ID", 0)
			end
		end
	};
	
	JoinServer = {
		Commands = {"toserver"; "joinserver"; "jserver"; "jplace"};
		Args = {"jobid"};
		Description = "Send you to a server using the server's JobId";
		Function = function(plr, args)
			local jobId = args[1]
			assert(jobId, "Argument missing or nil")
			Functions.Message("Adonis", "Teleporting to server \""..jobId.."\"\nPlease wait", 10)
			service.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, plr)
		end
	};
	
	CopyJobId = {
		Commands = {"jobid"; "copyjobid"};
		Args = {};
		Description = "Copies the game's JobId to your clipboard";
		Function = function(Plr, args)
			Functions.ToClipboard(game.JobId)
		end
	};
	
	Notification = {
		Commands = {"notify";"notification"};
		Args = {"message"};
		Description = "Send a notification";
		Function = function(plr, args)
			assert(args[1], "Argument missing or nil")
			
			UI.MakeGui("Notification", {
				Title = "Notification";
				Message = args[1];
			})
		end
	};
	
	Spin = {
		Commands = {"spin"};
		Args = {"speed"};
		FE = true;
		Description = "Makes you spin";
		Function = function(plr, args)
			local ind = tostring(plr.UserId)
			local root = plr.Character and plr.Character:findFirstChild("HumanoidRootPart")
			if root then
				local spinner = root:findFirstChild("AD_Spinner") or service.New("BodyAngularVelocity")
				spinner.Name = "AD_Spinner"
				spinner.AngularVelocity = Vector3.new(0, tonumber(args[1]) or 10, 0)
				spinner.MaxTorque = Vector3.new(0, math.huge, 0)
				spinner.P = 1250
				spinner.Parent = root
			end
		end
	};

	UnSpin = {
		Commands = {"unspin"};
		Args = {};
		FE = true;
		Description = "Makes you stop spinning";
		Function = function(plr, args)
			local root = plr.Character and plr.Character:findFirstChild("HumanoidRootPart")
			if root then
				for i, v in pairs(root:GetChildren()) do
					if v.Name == "AD_Spinner" and v:IsA("BodyAngularVelocity") then
						v:Destroy()
					end
				end
			end
		end
	};
	
	LockMap = {
		Commands = {"lockmap"; "lockws"};
		Args = {};	
		Description = "Locks the map";
		Function = function(plr, args)
			for _, obj in pairs(service.Workspace:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Locked = true
				end
			end
		end
	};
	
	UnLockMap = {
		Commands = {"unlockmap"; "unlockws"};
		Args = {};
		Description = "Unlocks the map";
		Function = function(plr, args)
			for _, obj in pairs(service.Workspace:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Locked = false
				end
			end
		end
	};
	
	View = {
		Commands = {"view"; "watch"; "nsa"; "viewplayer"};
		Args = {"player";};
		Description = "Makes you view the target player";
		Function = function(plr, args)
			for i, v in pairs(service.GetPlayers(plr, args[1])) do
				local hum = v.Character and v.Character:findFirstChildOfClass("Humanoid")
				if hum then
					Functions.SetView(hum)
				end
			end
		end
	};
	
	Unview = {
		Commands = {"unview"; "rv"; "fixview"; "resetview"; "unwatch"; "fixcam"};
		Args = {};
		Description = "Reset to view";
		Function = function(plr, args)
			Functions.SetView('reset')
		end
	};
	
	FreeCam = {
		Commands = {"freecam"};
		Args = {};
		Description = "Makes it so your cam can move around freely (Press Space or Shift+P to toggle freecam)";
		Function = function(plr, args)
			
		end
	};
	
	Animation = {
		Commands = {"animation"; "loadanim"; "animate"};
		Args = {"animationID"};
		FE = true;
		Description = "Load the animation onto the character";
		Function = function(plr, args)
			assert(tonumber(args[1]), tostring(args[1]).." is not a valid ID")
			
			Functions.PlayAnimation(args[1])
		end
	};

	Dance = {
		Commands = {"dance";};
		Args = {};
		FE = true;
		Description = "Make the character dance";
		Function = function(plr, args)
			local human = plr.Character and plr.Character:findFirstChildOfClass("Humanoid")
			if human then
				local rigType = human and (human.RigType == Enum.HumanoidRigType.R6 and "R6" or "R15") or nil
				Functions.PlayAnimation(rigType == "R6" and 27789359 or 507771019)
			end
		end
	};
	
	Waypoint = {
		Commands = {"waypoint"; "wp"; "checkpoint"};
		Args = {"name"};
		Description = "Makes a new waypoint/sets an exiting one to your current position with the name <name> that you can teleport to using :tp me waypoint-<name>";
		Function = function(plr, args)
			local name=args[1] or tostring(#Variables.Waypoints+1)
			if plr.Character:FindFirstChild('HumanoidRootPart') then
				Variables.Waypoints[name] = plr.Character.HumanoidRootPart.Position
				Functions.Hint('Made waypoint '..name..' | '..tostring(Variables.Waypoints[name]),{plr})
			end
		end
	};
	
	DeleteWaypoint = {
		Commands = {"delwaypoint";"delwp";"delcheckpoint";"deletewaypoint";"deletewp";"deletecheckpoint";};
		Args = {"name";};
		Description = "Deletes the waypoint named <name> if it exist";
		Function = function(plr,args)
			for i,v in pairs(Variables.Waypoints) do
				if string.sub(string.lower(i),1,#args[1])==string.lower(args[1]) or string.lower(args[1])=='all' then
					Variables.Waypoints[i]=nil
					Functions.Hint('Deleted waypoint '..i,{plr})
				end
			end
		end
	};
	
	Repeat = {
		Commands = {"repeat";"loop";};
		Args = {"amount";"interval";"command";};
		Description = "Repeats <command> for <amount> of times every <interval> seconds; Amount cannot exceed 50";
		Function = function(plr,args)
			local amount = tonumber(args[1])
			local timer = tonumber(args[2])
			if timer<=0 then timer=0.1 end
			if amount>50 then amount=50 end
			local command = args[3]
			local name = string.lower(plr.Name)
			assert(command, "Argument #1 needs to be supplied")
			if string.lower(string.sub(command,1,#Settings.Prefix+string.len("repeat"))) == string.lower(Settings.Prefix.."repeat") or string.sub(command,1,#Settings.Prefix+string.len("loop")) == string.lower(Settings.Prefix.."loop") or string.find(command, "^"..Settings.Prefix.."loop") or string.find(command,"^"..Settings.Prefix.."repeat") then
				error("Cannot repeat the loop command in a loop command")
				return
			end

			Variables.CommandLoops[name..command] = true
			Functions.Hint("Running "..command.." "..amount.." times every "..timer.." seconds.",{plr})
			for i = 1,amount do
				if not Variables.CommandLoops[name..command] then break end
				Process.Command(plr,command,{Check = false;})
				wait(timer)
			end
			Variables.CommandLoops[name..command] = nil
		end
	};
	
	Abort = {
		Commands = {"abort";"stoploop";"unloop";"unrepeat";};
		Args = {"username";"command";};
		Description = "Aborts a looped command. Must supply name of player who started the loop or \"me\" if it was you, or \"all\" for all loops. :abort sceleratis :kill bob or :abort all";
		Function = function(plr,args)
			local name = string.lower(args[1])
			if name=="me" then
				Variables.CommandLoops[string.lower(plr.Name)..args[2]] = nil
			elseif name=="all" then
				for i,v in pairs(Variables.CommandLoops) do
					Variables.CommandLoops[i] = nil
				end
			elseif args[2] then
				Variables.CommandLoops[name..args[2]] = nil
			end
		end
	};
	
	AbortAll = {
		Prefix = Settings.Prefix;
		Commands = {"abortall";"stoploops";};
		Args = {};
		Description = "Aborts all existing command loops";
		AdminLevel = "Moderators";
		Function = function(plr,args)
			local name = 'all'

			if name and name=="me" then
				for i,v in ipairs(Variables.CommandLoops) do
					if string.lower(string.sub(i,1,plr.Name)) == string.lower(plr.Name) then
						Variables.CommandLoops[string.lower(plr.Name)..args[2]] = nil
					end
				end
			elseif name and name=="all" then
				for i,v in ipairs(Variables.CommandLoops) do
					Variables.CommandLoops[string.lower(plr.Name)..args[2]] = nil
				end
			elseif args[2] then
				if Variables.CommandLoops[name..args[2]] then
					Variables.CommandLoops[name..args[2]] = nil
				else
					Remote.MakeGui(plr,'Output',{Title = 'Output'; Message = 'No loops relating to your search'})
				end
			else
				for i,v in ipairs(Variables.CommandLoops) do
					Variables.CommandLoops[i] = nil
				end
			end
		end
	};
	
	Rejoin = {
		Commands = {"rejoin"};
		Args = {};
		Description = "Makes you rejoin the server";
		Function = function(plr, args)
			service.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
		end
	};
	
	}, {__newindex = function(self, index, value)
		rawset(self, index, value)
		Admin.CommandCache[value.Command] = index
		Admin.PrefixCache[value.Prefix] = true
		for i, v in pairs(value.Aliases) do
			Admin.CommandCache[v] = index
		end
	end
})

--= SERVER =--
	
client = {
	Running = true,
	service = service,
	Functions = Functions,
	Admin = Admin,
	Core = Core,
	Remote = Remote,
	Commands = Commands,
	Process = Process,
	Variables = Variables,
	Logs = Logs,
	GUIs = {}
}

service.GetPlayers = Functions.GetPlayers
service.Routine = Routine

Admin.CacheCommands()

for index, player in next, service.Players:GetPlayers() do
	service.TrackTask("Thread: LoadPlayer ".. tostring(player.Name), client.Core.LoadExistingPlayer, player);
end

--// Events
service.RbxEvent(service.Players.PlayerAdded, service.EventTask("PlayerAdded", client.Process.PlayerAdded))

do

	local screen = Instance.new("ScreenGui")
	screen.Enabled = false
	screen.Name = "Console"
	screen.DisplayOrder = 5
	local frame = Instance.new("Frame", screen)
	frame.Name = "Main"
	frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	frame.BackgroundTransparency = 0.7
	frame.BorderSizePixel = 0
	frame.Position = UDim2.new(0, 0, -1, 0)
	frame.Size = UDim2.new(1, 0, 0, 40)
	local topbar = frame:Clone()
	topbar.AnchorPoint = Vector2.new(0, 1)
	topbar.Position = UDim2.new()
	topbar.Name = "TopBar"
	topbar.Parent = frame
	topbar.ZIndex = 5
	local text = Instance.new("Frame", frame)
	text.Name = "CommandBar"
	text.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	text.BackgroundTransparency = 0.5
	text.Position = UDim2.new(0, 0, 0, 8)
	text.Size = UDim2.new(1, 0, 0, 32)
	text.BorderSizePixel = 0
	local input = Instance.new("TextBox", text)
	input.BackgroundTransparency = 1
	text.ZIndex = 2
	input.Name = "TextBox"
	input.Position = UDim2.new(0, 5, 0, 0)
	input.Size = UDim2.new(1, 0, 1, 0)
	input.FontSize = "Size24"
	input.Font = "SourceSansSemibold"
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextStrokeColor3 = Color3.fromRGB(55, 55, 55)
	input.TextStrokeTransparency = 0.5	
	input.TextSize = 22
	input.TextWrapped = true
	input.TextXAlignment = "Left"
	input.Text = ""
	local bar = Instance.new("TextButton", screen)
	bar.Name = "OpenBar"
	bar.AnchorPoint = Vector2.new(1, 1)
	bar.Size = UDim2.new(0, 250, 0, 20)
	bar.Position = UDim2.new(1, 0, 1, 0)
	bar.BackgroundColor3 = Color3.fromRGB(36, 36, 37)
	bar.BorderSizePixel = 0
	bar.Transparency = 0.3
	bar.TextColor3 = Color3.fromRGB(255, 255, 255)
	bar.TextScaled = true
	bar.TextWrapped = true
	bar.Font = "SourceSans"
	bar.FontSize = "Size18"
	bar.Text = "Open command bar"
	bar.Visible = true
	bar.ZIndex = 2
	local cmdList = Instance.new("Frame", frame)
	cmdList.Name = "CmdList"
	cmdList.BackgroundColor3 = Color3.new(0, 0, 0)
	cmdList.BackgroundTransparency = 0.5
	cmdList.Size = UDim2.new(1, 0, 0, 3)
	cmdList.Position = UDim2.new(0, 0, 1, 0)
	cmdList.BorderSizePixel = 0
	cmdList.ZIndex = 2
	local scroll = Instance.new("ScrollingFrame", cmdList)
	scroll.BackgroundColor3 = Color3.new(0, 0, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ClipsDescendants = true
	scroll.ScrollingEnabled = false
	scroll.ScrollingDirection = 2
	scroll.ScrollBarThickness = 0
	scroll.Position = UDim2.new(0, 5, 0, 0)
	scroll.Size = UDim2.new(1, -130, 1, 0)
	scroll.Visible = true
	local players = scroll:Clone()
	players.Parent = frame
	players.Name = "PlayerList"
	players.CanvasSize = UDim2.new(0, 0, 0, 10000)
	players.Position = UDim2.new(1, -125, 1, 0)
	players.BackgroundTransparency = 1
	players.Size = UDim2.new(0, 120, 0, 105)
	players.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	players.ZIndex = 2
	local entry = Instance.new("TextButton", screen)
	entry.Name = "Entry"
	entry.Active = true
	entry.BackgroundTransparency = 1
	entry.BorderSizePixel = 0
	entry.Size = UDim2.new(1, -10, 0, 20)
	entry.Font = "SourceSans"
	entry.LineHeight = 1
	entry.RichText = false
	entry.Text = ";ff <player>"
	entry.TextColor3 = Color3.new(1, 1, 1)
	entry.TextSize = 18
	entry.FontSize = "Size18"
	entry.TextStrokeTransparency = 1
	entry.TextXAlignment = "Left"
	entry.AutoLocalize = false
	entry.Visible = false
	entry.ZIndex = 3
	entry.LayoutOrder = 0
	screen.Parent = CoreGui
	screen.Enabled = true
	
	local main = frame
	local splitKey = Settings.SplitKey
	local batchKey = Settings.BatchKey
	local commands = {}
	for name, data in pairs(Commands) do
		table.insert(commands, Admin.FormatCommand(data))
	end

	local mouse = service.Player:GetMouse()
	local StarterGui = game:GetService("StarterGui")
	local UIS = InputService

	local scrollOpen
	local open = false
	function openBar()
		open = true
		scrollOpen = false
		local ChatEnabled, PlrListEnabled
		bar.Visible = false
		input.Text = ''
		scroll.ScrollingEnabled = true
		players.ScrollingEnabled = true
		frame:TweenPosition(UDim2.new(), "Out", "Linear", 0, true)
		input:CaptureFocus()
		input.Text = ''
		spawn(function() input.Text = '' end)
		while input:IsFocused() do
			StarterGui:SetCoreGuiEnabled("Chat", false)
			StarterGui:SetCoreGuiEnabled("PlayerList", false)
			game:GetService("RunService").Stepped:Wait()
		end
		StarterGui:SetCoreGuiEnabled("Chat", true)
		StarterGui:SetCoreGuiEnabled("PlayerList", true)
	end

	mouse.KeyDown:Connect(function(key)
		if key == ";" and not open then
			openBar()
		end
	end)

	input.FocusLost:Connect(function(enterPressed, inputObject)
		if enterPressed and inputObject and inputObject.KeyCode == Enum.KeyCode.Return then
			if input.Text ~= '' and #input.Text > 1 then
				Process.Command(service.Player, input.Text, {Check = true}, true)
			end
		end
		main:TweenPosition(UDim2.new(0, 0, 0, -200), "In", "Sine", 0.3, true)
		bar.Visible = true
		scroll:ClearAllChildren()
		scroll.CanvasSize = UDim2.new()
		scroll.ScrollingEnabled = false
		scroll.Visible = false
		players.Visible = false
		cmdList.Size = UDim2.new(1, 0, 0, 0)
		open = false
		scrollOpen = false
	end)
	
	bar.MouseButton1Click:Connect(openBar)

	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.15)
	local scrollOpenTween = TweenService:Create(cmdList, tweenInfo, {
		Size = UDim2.new(1, 0, 0, 105)
	})
	local scrollCloseTween = TweenService:Create(cmdList, tweenInfo, {
		Size = UDim2.new(1, 0, 0, 0)
	})
	input.ZIndex = 2
	
	input.Changed:Connect(function(c)
		if c == 'Text' and input.Text ~= '' then
			scroll:ClearAllChildren()
			players:ClearAllChildren()

			local nText = input.Text
			if string.match(nText,".*"..batchKey.."([^']+)") then
				nText = string.match(nText,".*"..batchKey.."([^']+)")
				nText = string.match(nText,"^%s*(.-)%s*$")
			end
			local pNum = 0
			local pMatch = string.match(nText,".+"..splitKey.."(.*)$")
			for i,v in next, Players:GetPlayers() do
				if (pMatch and string.sub(string.lower(tostring(v)),1,#pMatch) == string.lower(pMatch)) or string.match(nText,splitKey.."$") then
					local new = entry:Clone()
					new.Text = tostring(v)
					new.TextXAlignment = "Right"
					new.Visible = true
					new.Parent = players
					new.Position = UDim2.new(0,0,0,20*pNum)
					new.MouseButton1Down:connect(function()
						input.Text = input.Text..tostring(v)
						input:CaptureFocus()
					end)
					pNum = pNum+1
				end
			end
			players.CanvasSize = UDim2.new(0, 0, 0, pNum * 20)
			players.CanvasSize = UDim2.new(0,0,0,pNum*20)

			local num = 0
			for i,v in next,commands do
				if string.sub(string.lower(v),1,#nText) == string.lower(nText) or string.find(string.lower(v), string.match(string.lower(nText),"^(.-)"..splitKey) or string.lower(nText), 1, true) then
					if not scrollOpen then
						scrollOpenTween:Play();
						scroll.Visible = true
						players.Visible = true
						scrollOpen = true
					end
					local b = entry:Clone()
					b.Visible = true
					b.Parent = scroll
					b.Text = v
					b.Position = UDim2.new(0,0,0,20*num)
					b.MouseButton1Down:connect(function()
						input.Text = b.Text
						input:CaptureFocus()
					end)
					num = num+1
				end
			end
			cmdList.Size = UDim2.new(1, 0, 0, math.clamp((num*20==0 and -5 or num*20) + 5, 0, 105))
			scroll.CanvasSize = UDim2.new(0,0,0,num*20)
		elseif c == 'Text' and input.Text == '' then
			scrollCloseTween:Play();
			scroll.Visible = false
			players.Visible = false
			scrollOpen = false
			scroll:ClearAllChildren() 
			scroll.CanvasSize = UDim2.new(0,0,0,0)
		end
	end)
end
