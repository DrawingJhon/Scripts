local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local AnimationClipProvider = game:GetService("AnimationClipProvider")

-- Better game:GetObjects() function which doesn't lag
--[[hookfunction(game.GetObjects, function(obj, asset)
	return game:GetService("UGCValidationService"):FetchAssetWithFormat(asset, "")
end)]]

local loopgostoTick = 0
local reanimTick = 0
local reanimSpeed = 1
local sbangLoop

local Vars = {
	Tracks = {};
	LoopSTO_BV = {}
}

local function Repeat(t, length)
	return math.clamp(t - math.floor(t / length) * length, 0, length)
end

local function PingPong(t, length)
	t = Repeat(t, length * 2)
	return length - math.abs(t - length)
end

local function getHit(blacklist)
	blacklist = blacklist or {}
	if player.Character then
		table.insert(blacklist, player.Character)
	end
	local unitRay = mouse.UnitRay
	local castParams = RaycastParams.new()
	castParams.FilterDescendantsInstances = blacklist
	castParams.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(unitRay.Origin, unitRay.Direction * 9999999, castParams)
	return result
end

local function align(part, parent)
	local at0 = Instance.new("Attachment", part)
	local at1 = Instance.new("Attachment", parent)

	local alignPos = Instance.new("AlignPosition")
	alignPos.Attachment0 = at0
	alignPos.Attachment1 = at1
	alignPos.MaxForce = 999999999
	alignPos.MaxVelocity = math.huge
	alignPos.ReactionForceEnabled = false
	alignPos.Responsiveness = math.huge
	alignPos.RigidityEnabled = false
	alignPos.Parent = part
	local alignOr = Instance.new("AlignOrientation")
	alignOr.Attachment0 = at0
	alignOr.Attachment1 = at1
	alignOr.Responsiveness = math.huge
	alignOr.MaxTorque = 999999999
	alignOr.Parent = part
end

local function Load(Object)
	local Modules = {}
	local SavedModules = {}
	local Scripts = {}
	local EnvList = {}

	local function fakeRequire(Script)
		if typeof(Script) ~= "Instance" then warn("Unable to require: "..tostring(Script)) return end
		if SavedModules[Script] then
			return SavedModules[Script]
		elseif Modules[Script] then
			SavedModules[Script] = Modules[Script]()
			return SavedModules[Script]
		end
		warn("Real requiring: "..Script:GetFullName())
		return require(Script)
	end
	local function NewProxyEnv(Script, Func, Err)
		if not Func then
			warn("SYNTAX ERROR ("..Script:GetFullName().."): "..(Err or "Unknown"))
		end
		local fakeEnv = {script = Script}
		local meta = {}
		meta.__index = function(self, index)
			if index == "require" then
				return fakeRequire
			end
			if index == "getfenv" then
				return function(arg)
					local typ = type(arg)
					local env
					if typ == "number" then
						env = getfenv(arg == 0 and 2 or arg + 1)
					else
						env = getfenv(arg)
					end
					if env.script == nil then
						error("Tried to get main envirionment")
					end
					return env
				end
			end
			return getfenv()[index]
		end

		return setfenv(Func, setmetatable(fakeEnv, meta))
	end
	local function LoadScripts(Script)
		if Script:IsA("Script") or Script.ClassName == "ModuleScript" then
			local func = NewProxyEnv(Script, loadstring(Script.Source, "="..Script:GetFullName()))
			if Script.ClassName == "Script" or Script.ClassName == "LocalScript" then
				Scripts[Script] = func
			elseif Script.ClassName == "ModuleScript" then
				Modules[Script] = func
			end
		end

		for i, v in pairs(Script:GetChildren()) do
			LoadScripts(v)
		end
	end
	LoadScripts(Object)
	for i, v in pairs(Scripts) do
		task.spawn(v)
	end
end

local function applyNexo()
	local char = player.Character
	local HumanDied = false

	local parts = {}

	for _, child in pairs(char:GetDescendants()) do
		if child:IsA("BasePart") then
			table.insert(parts, child)
		elseif child:IsA("Tool") then
			child.Parent = player:FindFirstChildOfClass("Backpack")
		elseif child:IsA("ForceField") then
			child:Destroy()
		end
	end

	local netless = game:GetService("RunService").Heartbeat:Connect(function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				p.MaximumSimulationRadius = 0
				sethiddenproperty(p, "SimulationRadius", 0)
			end
		end

		settings().Physics.AllowSleep = false

		for _, part in pairs(parts) do
			part.AssemblyLinearVelocity = Vector3.new(-30, 0, 0)
		end
		sethiddenproperty(player, "SimulationRadius", 999999999)
		sethiddenproperty(player, "MaximumSimulationRadius", 999999999)
		--setsimulationradius(999999999, math.huge)
	end)

	local ct = {}

	char.Archivable = true

	local reanim = char:Clone()
	reanim.Name = "Nexo "..player.Name
	local fl = Instance.new("Folder", char)
	fl.Name = "Nexo"
	reanim.Animate.Disabled = true
	--char.HumanoidRootPart:Destroy()
	--char.Humanoid:ChangeState(16)
	for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
		v:Stop()
	end
	char.Animate:Remove()

	local function create(part, parent, p, r)
		local at0 = Instance.new("Attachment",part)
		Instance.new("AlignPosition",part)
		Instance.new("AlignOrientation",part) 
		local at1 = Instance.new("Attachment",parent)
		part.AlignPosition.Attachment0 = at0
		part.AlignOrientation.Attachment0 = at0
		part.AlignPosition.Attachment1 = at1
		part.AlignOrientation.Attachment1 = at1
		at1.Position = p or Vector3.new()
		at0.Orientation = r or Vector3.new()
		part.AlignPosition.MaxForce = 999999999
		part.AlignPosition.MaxVelocity = math.huge
		part.AlignPosition.ReactionForceEnabled = false
		part.AlignPosition.Responsiveness = math.huge
		part.AlignOrientation.Responsiveness = math.huge
		part.AlignPosition.RigidityEnabled = false
		part.AlignOrientation.MaxTorque = 999999999 
	end

	-- Weird hats animations
	--[[for _, child in pairs(char:GetDescendants()) do
		if child:IsA("Accessory") then
			child.Handle:BreakJoints()
			create(child.Handle, reanim[child.Name].Handle)
		end
	end]]

	--[[char.Torso['Left Shoulder']:Destroy()
	char.Torso['Right Shoulder']:Destroy()
	char.Torso['Left Hip']:Destroy()
	char.Torso['Right Hip']:Destroy()
	char['HumanoidRootPart']:BreakJoints()
	create(char.HumanoidRootPart, reanim.HumanoidRootPart)
	create(char['Torso'],reanim['Torso'])
	create(char['Left Arm'],reanim['Left Arm'])
	create(char['Right Arm'],reanim['Right Arm'])
	create(char['Left Leg'],reanim['Left Leg'])
	create(char['Right Leg'],reanim['Right Leg'])]]

	for _, child in pairs(char:GetChildren()) do
		if child:IsA("BasePart") and child.Name ~= "Head" then
			if child.Name ~= "Torso" and child.Name ~= "UpperTorso" then
				child:BreakJoints()
			end
			create(child, reanim[child.Name])
		end
	end

	for i,v in pairs(reanim:GetDescendants()) do
		if v:IsA('BasePart') or v:IsA('Decal') then
			v.Transparency = 1
		end
	end
	reanim.Parent = fl 

	table.insert(ct, game:GetService("RunService").Stepped:Connect(function()
		for _, part in pairs(parts) do
			part.CanCollide = false
		end
	end))

	local function reset()
		if HumanDied then return end
		player.Character = char
		char:BreakJoints()
		reanim:Destroy()
		netless:Disconnect()
		HumanDied = true

		for _, v in pairs(ct) do
			v:Disconnect()
		end

		char.HumanoidRootPart.CanCollide = true
	end

	local human = reanim.Humanoid

	table.insert(ct, char.Humanoid.Died:Connect(reset))
	table.insert(ct, human.Died:Connect(reset))
	table.insert(ct, human.AncestryChanged:Connect(function()
		if not human:IsDescendantOf(workspace) or human.Parent ~= reanim then
			reset()
		end
	end))

	local cf = workspace.CurrentCamera.CFrame
	player.Character = reanim
	workspace.CurrentCamera.CameraSubject = reanim.Humanoid
	workspace.CurrentCamera.CFrame = cf
end

local function applySuperNexo()
	local char = player.Character
	char.Archivable = true
	pcall(function()
		char.Animate.Disabled = true
		for i, v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
			v:Stop()
		end
	end)
	local clone = char:Clone()
	local model = Instance.new("Model", char)

	for i, v in pairs(char:GetChildren()) do
		if v ~= model then
			v.Parent = model
		end
	end

	local temp = Instance.new("Model", workspace)
	local t1 = Instance.new("Part", temp)
	t1.Name = "Head"
	t1.Anchored = true
	t1.Transparency = 1
	t1.CanCollide = false
	Instance.new("Humanoid", temp)

	player.Character = temp
	player.Character = char
	temp:Destroy()
	task.wait(Players.RespawnTime + 0.5)

	for i, v in pairs(clone:GetChildren()) do
		v.Parent = char
	end
	for i, v in pairs(char:GetDescendants()) do
		if v:IsDescendantOf(model) then continue end
		if v:IsA("BasePart") or v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ForceField") then
			v.Visible = false
		elseif v:IsA("Sound") then
			v.Playing = false
		elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") or v:IsA("ParticleEmitter") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
	
	model:BreakJoints()

	local parts = {}
	for i, v in pairs(model:GetChildren()) do
		local part
		local rep
		if v:IsA("BasePart") then
			part = v
			rep = char[part.Name]
		elseif v:IsA("Accessory") and v:FindFirstChild("Handle") and v.Handle:IsA("BasePart") then
			part = v.Handle
			rep = char[v.Name].Handle
		end
		if part and rep then
			table.insert(parts, part)
			align(part, rep)
		end
	end

	local uncollideConn

	local function uncollide()
		if model:IsDescendantOf(workspace) then
			for i, v in pairs(parts) do
				v.CanCollide = false
			end
		elseif uncollideConn then
			uncollideConn:Disconnect()
		end
	end

	local ct = {}

	uncollideConn = game:GetService("RunService").Stepped:Connect(uncollide)
	uncollide()

	table.insert(ct, game:GetService("RunService").Heartbeat:Connect(function()
		for i, v in pairs(parts) do
			v.AssemblyLinearVelocity = Vector3.new(-30, 0, 0)
		end
		sethiddenproperty(player, "SimulationRadius", 999999999)
		sethiddenproperty(player, "MaximumSimulationRadius", math.huge)
	end))

	local hasReset = false
	local function reset()
		if hasReset then return end
		hasReset = true
		game:GetService("StarterGui"):SetCore("ResetButtonCallback", true)
		player.Character = nil
		player.Character = char
		char:BreakJoints()

		for i, v in pairs(ct) do
			v:Disconnect()
		end
	end

	local resetBindable = Instance.new("BindableEvent")
	resetBindable.Event:Connect(function()
		resetBindable:Destroy()
		reset()
	end)
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", resetBindable)
	table.insert(ct, char.Humanoid.Died:Connect(reset))
end

local function applyGod()
	local char = player.Character
	char.Archivable = true
	local realHuman = char.Humanoid
	local model = char:Clone()
	local human = model.Humanoid
	model.Parent = workspace
	model.Name = "mod"

	for _, child in pairs(model:GetDescendants()) do
		if child:IsA("BillboardGui") or child:IsA("SurfaceGui") then
			child.Enabled = false
		elseif child:IsA("BasePart") or child:IsA("Decal") then
			child.Transparency = 1
		elseif child:IsA("ForceField") then
			child.Visible = false
			child:Destroy()
		end
	end

	player.Character = model
	player.Character = char
	task.wait(5.65)
	realHuman.RequiresNeck = false
	realHuman.BreakJointsOnDeath = false
	realHuman:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	realHuman:ChangeState(Enum.HumanoidStateType.Dead)
	realHuman.Health = 0

	local function create(part, parent, p, r)
		if part:FindFirstChildOfClass("AlignPosition") then
			return
		end
		local at0 = Instance.new("Attachment",part)
		Instance.new("AlignPosition",part)
		Instance.new("AlignOrientation",part) 
		local at1 = Instance.new("Attachment",parent)
		part.AlignPosition.Attachment0 = at0
		part.AlignOrientation.Attachment0 = at0
		part.AlignPosition.Attachment1 = at1
		part.AlignOrientation.Attachment1 = at1
		at1.Position = p or Vector3.new()
		at0.Orientation = r or Vector3.new()
		part.AlignPosition.MaxForce = 999999999
		part.AlignPosition.MaxVelocity = math.huge
		part.AlignPosition.ReactionForceEnabled = false
		part.AlignPosition.Responsiveness = math.huge
		part.AlignOrientation.Responsiveness = math.huge
		part.AlignPosition.RigidityEnabled = false
		part.AlignOrientation.MaxTorque = 999999999 
	end

	local motors = {}
	local parts = {}

	for _, child in pairs(char:GetDescendants()) do
		if child:IsA("Motor6D") and child.Part1 then
			local origParent = child.Parent
			child.Parent = nil
			child.Parent = origParent
			child.Enabled = false
			local part = child.Part1
			create(part, model[part.Name])
			table.insert(parts, part)

			for _, v in pairs(model:GetDescendants()) do
				if v:IsA("Motor6D") and v.Name == child.Name then
					motors[v] = child
					break
				end
			end
		end
	end

	local ct = {}

	local hasReset = false
	local function reset()
		if hasReset then return end
		hasReset = true
		StarterGui:SetCore("ResetButtonCallback", true)
		for i, v in pairs(ct) do
			v:Disconnect()
		end

		player.Character = model
		model:Destroy()
		player.Character = char
	end

	local resetBindable = Instance.new("BindableEvent")
	resetBindable.Event:Connect(function()
		resetBindable:Destroy()
		human.Health = 0
	end)

	StarterGui:SetCore("ResetButtonCallback", resetBindable)

	local realHead = char.Head

	table.insert(ct, human.Died:Connect(reset))
	table.insert(ct, realHead.AncestryChanged:Connect(function(child)
		if not realHead:IsDescendantOf(workspace) or realHead.Parent ~= char then
			reset()
		end
	end))

	table.insert(ct, RunService.Heartbeat:Connect(function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player then
				p.MaximumSimulationRadius = 0
				sethiddenproperty(p, "SimulationRadius", 0)
			end
		end

		settings().Physics.AllowSleep = false

		for _, part in pairs(parts) do
			part.AssemblyLinearVelocity = Vector3.new(-30, 0, 0)
		end
		sethiddenproperty(player, "SimulationRadius", 999999999)
		sethiddenproperty(player, "MaximumSimulationRadius", 999999999)
	end))

	table.insert(ct, RunService.Stepped:Connect(function()
		for _, part in pairs(parts) do
			part.CanCollide = false
		end
	end))

	task.spawn(function()
		while model.Parent and human.Health > 0 and char.Parent do
			human:Move(realHuman.MoveDirection)
			human.Jump = realHuman.Jump
			human.WalkSpeed = realHuman.WalkSpeed

			for fake, real in pairs(motors) do
				fake.Transform = real.Transform
				fake.C0 = real.C0
				fake.C1 = real.C1
			end

			game:GetService("RunService").RenderStepped:Wait()
		end
		reset()
	end)

	workspace.CurrentCamera.CameraSubject = human
end

local function applyNexo2()
	local char = player.Character
	local head = char.Head
	local root = char.HumanoidRootPart

	local function create(motor)
		local parent = motor.Part0
		local part = motor.Part1

		local at0 = Instance.new("Attachment", part)
		local at1 = Instance.new("Attachment", parent)

		local ap = Instance.new("AlignPosition", part)
		local ao = Instance.new("AlignOrientation", part)

		ap.Attachment0 = at0
		ap.Attachment1 = at1
		ap.MaxForce = 999999999
		ap.MaxVelocity = math.huge
		ap.ReactionForceEnabled = false
		ap.Responsiveness = math.huge
		ap.RigidityEnabled = false
		ap.Mode = Enum.PositionAlignmentMode.TwoAttachment

		ao.Attachment0 = at0
		ao.Attachment1 = at1
		ao.Responsiveness = math.huge
		ao.MaxTorque = 999999999
		ao.Mode = Enum.OrientationAlignmentMode.TwoAttachment

		coroutine.wrap(function()
			local lastParent = motor.Parent
			motor.Parent = nil
			task.wait()
			motor.Parent = lastParent
			motor.Enabled = false
		end)()

		local ct = {}

		table.insert(ct, game:GetService("RunService").RenderStepped:Connect(function()
			at0.CFrame = motor.C1
			at1.CFrame = motor.C0 * motor.Transform
			motor.Enabled = false
		end))

		table.insert(ct, motor.AncestryChanged:Connect(function()
			if not motor:IsDescendantOf(char) or not motor:IsDescendantOf(workspace) then
				for _, v in pairs(ct) do
					v:Disconnect()
				end
			end
		end))
	end

	--root.CanCollide = false
	root.Anchored = true

	local collPart = Instance.new("Part")
	collPart.Size = root.Size
	collPart.Transparency = 1
	collPart.Massless = true
	--collPart.Parent = char
	local weld = Instance.new("Weld")
	weld.Part0 = root
	weld.Part1 = collPart
	weld.Parent = collPart

	for _, motor in pairs(char:GetDescendants()) do
		if motor:IsA("Motor6D") and motor.Part1 ~= head then
			create(motor)
		end
	end

	local parts = {}

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") and part ~= root then
			table.insert(parts, part)
			local noCol = Instance.new("NoCollisionConstraint")
			noCol.Part0 = part
			noCol.Part1 = root
			noCol.Parent = root
		end
	end

	local stepped = game:GetService("RunService").Stepped:Connect(function()
		for _, part in pairs(parts) do
			part.CanCollide = false
		end
	end)

	local netless = game:GetService("RunService").Heartbeat:Connect(function()
		setsimulationradius(999999999, math.huge)
	end)

	char.AncestryChanged:Connect(function()
		if not char.Parent then
			netless:Disconnect()
			stepped:Disconnect()
		end
	end)

	task.delay(0.1, function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.Anchored = false
	end)
end

local function replicateAnim(animInfo, loopArg)
	local character = player.Character
	if not character then
		return
	end

	local animId, kfsName = unpack(animInfo:split(':'))

	local kfs 
	pcall(function()
		kfs = game:GetObjects("rbxassetid://"..animId)[1]
	end)
	if not kfs then
		notify("Invalid ID", "Unable to get id object")
		return	
	end

	if not kfs:IsA("KeyframeSequence") then
		for i, v in pairs(kfs:GetDescendants()) do
			local kn = kfsName and kfsName:gsub("\\", " ")
			if v:IsA("KeyframeSequence") and (not kfsName or v.Name:lower():sub(1, #kn) == kn:lower()) then
				kfs = v
				break
			end
		end
	end

	if not kfs:IsA("KeyframeSequence") then
		notify("Invalid ID", "The animation id isn't valid to replicate")
		return
	end

	local looped = kfs.Loop

	if loopArg then
		if loopArg:lower() == "true" then
			looped = true
		elseif loopArg:lower() == "false" then
			looped = false
		end
	end

	local keyFrames = {}
	local duration = 0

	for _, kf in pairs(kfs:GetChildren()) do
		if not kf:IsA("Keyframe") then continue end
		duration = math.max(duration, kf.Time)
		for _, pose in pairs(kf:GetDescendants()) do
			if pose:IsA("Pose") and pose.Weight ~= 0 then
				local tab = keyFrames[pose.Name]
				if not tab then
					tab = {}
					keyFrames[pose.Name] = tab
				end

				tab[tostring(kf.Time)] = pose
			end
		end
	end

	local function getCFrameFromTime(poses, index)
		if type(index) ~= "number" then
			return
		end

		if poses[tostring(index)] then
			return poses[tostring(index)].CFrame
		end

		local first = {Time = 0}
		local last = {Time = math.huge}
		for t, p in pairs(poses) do
			t = tonumber(t)
			if t <= index and t >= first.Time then
				first = {Time = t, Pose = p}
			elseif t >= index and t <= last.Time then
				last = {Time = t, Pose = p}
			end
		end

		if not first.Pose and not last.Pose then
			return
		elseif not first.Pose then
			return
		elseif not last.Pose then
			return first.Pose.CFrame
		end

		local firstPose = first.Pose
		local lastPose = last.Pose

		local dur = last.Time - first.Time
		local tim = index - first.Time

		if firstPose.EasingStyle == Enum.PoseEasingStyle.Constant then
			return firstPose.CFrame
		else
			local val = TweenService:GetValue(tim / dur, firstPose.EasingStyle.Name, firstPose.EasingDirection.Name)
			return firstPose.CFrame:Lerp(lastPose.CFrame, val)
		end
	end

	local motors = {}

	for i, v in pairs(character:GetDescendants()) do
		if v:IsA("Motor6D") and v.Part1 and keyFrames[v.Part1.Name] then
			motors[v.Part1.Name] = v
		end
	end

	local tim = 0
	local thisReanimTick = tick()
	reanimTick = thisReanimTick

	task.spawn(function()
		while character.Parent and player.Character == character and reanimTick == thisReanimTick do
			local delta = game:GetService("RunService").RenderStepped:Wait()
			tim += delta * reanimSpeed

			if tim >= duration then
				if looped then
					tim = math.max(tim - duration, 0)
				else
					return
				end
			end

			for name, motor in pairs(motors) do
				local poses = keyFrames[name]
				local cf = getCFrameFromTime(poses, tim)

				if cf then
					motor.Transform = cf
				end
			end
		end
	end)
end

local Assets

local success, err = pcall(function()
	Assets = game:GetObjects("rbxassetid://11571145901")[1]
end)

if not success then
	warn("Unable to get S_IY assets: "..tostring(err))
end

local Plugin = {
	PluginName = "SuperCommands",
	PluginDescription = "Modified commands",
	Commands = {
		["gosto"] = {
			ListName = "gosto / sto [plr] [X Y Z] [rX rY rZ]",
			Description = "Accurate teleport to a player",
			Aliases = {"sto"},
			Function = function(args, speaker)
				local offset = CFrame.new(tonumber(args[2]) or 0, tonumber(args[3]) or 0, tonumber(args[4]) or 0)
				offset = offset * CFrame.Angles(math.rad(tonumber(args[5]) or 0), math.rad(tonumber(args[6]) or 0), math.rad(tonumber(args[7]) or 0))

				for i, v in pairs(getPlayer(args[1], speaker)) do
					local plyr = Players[v]
					if plyr.Character then
						local humanoid = speaker.Character and speaker.Character:findFirstChildOfClass("Humanoid")

						if humanoid and humanoid.SeatPart then
							humanoid.Sit = false
							wait(0.1)
						end

						getRoot(speaker.Character).CFrame = getRoot(plyr.Character).CFrame * offset
					end
				end
			end
		};

		["loopgosto"] = {
			ListName = "loopgosto / loopsto [plr] [X Y Z] [rX rY rZ]",
			PluginDescription = "Accurate loop teleport to a player",
			Aliases = {"loopsto"},
			Function = function(args, speaker)
				local name = getPlayer(args[1], speaker)[1]
				local offset = CFrame.new(tonumber(args[2]) or 0, tonumber(args[3]) or 0, tonumber(args[4]) or 0)
				offset = offset * CFrame.Angles(math.rad(tonumber(args[5]) or 0), math.rad(tonumber(args[6]) or 0), math.rad(tonumber(args[7]) or 0))
				if name then
					local plr = Players[name]
					local mTick = tick()
					loopgostoTick = mTick

					local conn; conn = game:GetService("RunService").Heartbeat:Connect(function()
						if loopgostoTick ~= mTick then
							conn:Disconnect()
							return
						end

						local victimRoot = plr.Character and getRoot(plr.Character)
						local speakerRoot = speaker.Character and getRoot(speaker.Character)
						local humanoid = speaker.Character and speaker.Character:findFirstChildOfClass("Humanoid")

						if humanoid then
							humanoid.PlatformStand = true

							if humanoid.SeatPart then
								humanoid.Sit = false
								return
							end
						end

						if speakerRoot then
							if not speakerRoot:FindFirstChild("LoopSTO_BV") then
								local bv = Instance.new("BodyVelocity")
								bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								bv.Velocity = Vector3.new(0, 0, 0)
								bv.Name = "LoopSTO_BV"
								bv.Parent = loopgostoTick == mTick and speakerRoot or nil
							end
							if victimRoot then
								speakerRoot.CFrame = victimRoot.CFrame * offset
							end
						end
					end)

					local cn; cn = plr.AncestryChanged:Connect(function()
						if loopgostoTick ~= mTick then
							cn:Disconnect()
							return
						end
						if plr.Parent == nil then
							cn:Disconect()
							execCmd("unloopgosto")
						end
					end)
				end
			end
		};

		["unloopgosto"] = {
			ListName = "unloopgosto / unloopsto",
			PluginDescription = "Stop accurate loop teleport",
			Aliases = {"unloopsto"},
			Function = function(args, speaker)
				if loopgostoTick ~= 0 then
					loopgostoTick = 0
					local humanoid = speaker.Character and speaker.Character:findFirstChildOfClass("Humanoid")
					local root = speaker.Character and getRoot(speaker.Character)
					if humanoid then
						humanoid.PlatformStand = false
					end
					if root then
						for i, v in pairs(root:GetChildren()) do
							if v:IsA("BodyVelocity") and v.Name == "LoopSTO_BV" then
								v:Destroy()
							end
						end
					end
				end
			end
		};

		["sbang"] = {
			ListName = "sbang [plr] [X Y Z] [rX rY rZ]",
			PluginDescription = "Super bangs a player",
			Aliases = {"srape"},
			Function = function(args, speaker)
				local name = getPlayer(args[1], speaker)[1]
				local plr = name and Players[name] or nil

				local speed = 6
				local offset = CFrame.new(tonumber(args[2]) or 0, tonumber(args[3]) or 0, tonumber(args[4]) or 0)
				offset = offset * CFrame.Angles(math.rad(tonumber(args[5]) or 0), math.rad(tonumber(args[6]) or 0), math.rad(tonumber(args[7]) or 0))

				if plr then
					if sbangLoop then
						sbangLoop:Disconnect()
					end

					local thisSbangLoop = game:GetService("RunService").Heartbeat:Connect(function()
						local n = PingPong(tick() * speed, 1)

						local speakerRoot = speaker.Character and getRoot(speaker.Character)
						local victimRoot = plr.Character and getRoot(plr.Character)
						local humanoid = speaker.Character and speaker.Character:findFirstChildOfClass("Humanoid")

						if humanoid then
							humanoid.PlatformStand = true

							if humanoid.SeatPart then
								humanoid.Sit = false
								return
							end
						end

						if speakerRoot then
							if not speakerRoot:FindFirstChild("LoopSBANG_BV") then
								local bv = Instance.new("BodyVelocity")
								bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
								bv.Velocity = Vector3.new(0, 0, 0)
								bv.Name = "LoopSBANG_BV"
								bv.Parent = speakerRoot
							end

							if victimRoot then
								speakerRoot.CFrame = (victimRoot.CFrame * CFrame.new(0, 0, 0.5)):Lerp(victimRoot.CFrame * CFrame.new(0, 0, 3), n) * offset
							end
						end
					end)

					sbangLoop = thisSbangLoop

					local cn; cn = plr.AncestryChanged:Connect(function()
						if not thisSbangLoop.Connected or sbangLoop ~= thisSbangLoop then
							cn:Disconnect()
							return
						end
						if plr.Parent == nil then
							cn:Disconnect()
							execCmd("unsbang")
						end
					end)
				end
			end
		};

		["unsbang"] = {
			ListName = "unsbang",
			PluginDescription = "Unsuper-bang player",
			Aliases = {"unsrape"},
			Function = function(args, speaker)
				if sbangLoop then
					sbangLoop:Disconnect()

					local char = speaker.Character
					if char then
						local humanoid = char:findFirstChildOfClass("Humanoid")
						local root = getRoot(char)

						if humanoid then
							humanoid.PlatformStand = false
						end

						if root then
							for i, v in ipairs(root:GetChildren()) do
								if v:IsA("BodyVelocity") and v.Name == "LoopSBANG_BV" then
									v:Destroy()
								end
							end
						end
					end
				end
			end
		};

		["clicktp"] = {
			ListName = "clicktp / ctp / ct",
			PluginDescription = "Click to teleport",
			Aliases = {"ctp", "ct"},
			Function = function(args, speaker)
				local tool = Instance.new("Tool")
				tool.Name = "ClickTeleport"
				tool.CanBeDropped = false
				tool.RequiresHandle = false
				tool.Parent = player:findFirstChildOfClass("Backpack")

				local useInputService = false
				local ignoreInvisibleParts = false

				if game.PlaceId == 653205701 then
					useInputService = true
				end

				local canClick = true
				local enabled = false

				local gui = Assets.UI.ClickTP_GUI:Clone()
				gui.Enabled = false
				gui.Parent = CoreGui

				local menu = gui.Menu
				local expandButton = gui.ExpandButton

				menu.Visible = false

				local function isInZone(frame)
					local pos = frame.AbsolutePosition
					local size = frame.AbsoluteSize

					if frame.Visible and mouse.X >= pos.X and mouse.X <= pos.X + size.X and mouse.Y >= pos.Y and mouse.Y <= pos.Y + size.Y then
						return true
					end
					return false
				end

				local function onClicked()
					if not enabled then return end

					if isInZone(menu) or isInZone(expandButton) then
						return
					end

					local tempList = {}
					local ray = {Position = mouse.Hit.Position}

					local max_tries = 1000

					for i = 1, max_tries do
						local _ray = getHit(tempList)
						if ignoreInvisibleParts and _ray and _ray.Instance and _ray.Instance:IsA("BasePart") and _ray.Instance.Transparency == 1 then
							table.insert(tempList, ray.Instance)
							ray = _ray
						else
							if typeof(ray) == "RaycastResult" then
								ray = _ray
							end
							break
						end
					end

					local pos = ray.Position
					local torso = getRoot(player.Character)
					if torso then
						local cf = torso.CFrame
						local angle = cf - cf.Position
						torso.CFrame = CFrame.new(pos.x, pos.y + 3, pos.z) * angle
					end
				end

				local ct = {}

				table.insert(ct, uis.InputBegan:Connect(function(input)
					if useInputService and canClick and input.UserInputType == Enum.UserInputType.MouseButton1 then
						onClicked()
					end
				end))

				table.insert(ct, tool.Activated:Connect(function()
					if not useInputService then
						onClicked()
					end
				end))

				local function controlCheckBox(switch, isChecked, onChanged)
					local checkButton = switch.CheckButton
					local checkImage = switch.CheckBox.check
					checkImage.ImageTransparency = isChecked and 0 or 1

					table.insert(ct, checkButton.MouseButton1Click:Connect(function()
						isChecked = not isChecked
						checkImage.ImageTransparency = isChecked and 0 or 1
						onChanged(isChecked)
					end))
				end

				table.insert(ct, expandButton.MouseButton1Click:Connect(function()
					menu.Visible = not menu.Visible
				end))

				table.insert(ct, menu.Changed:Connect(function()
					if menu.Visible then
						expandButton.ImageLabel.Rotation = 180
					else
						expandButton.ImageLabel.Rotation = 0
					end
				end))

				table.insert(ct, tool.Equipped:Connect(function()
					enabled = true
					menu.Visible = false
					gui.Enabled = true
				end))

				table.insert(ct, tool.Unequipped:Connect(function()
					enabled = false
					menu.Visible = false
					gui.Enabled = false
				end))

				controlCheckBox(menu.Switch, useInputService, function(bool)
					useInputService = bool
				end)

				controlCheckBox(menu.Switch2, ignoreInvisibleParts, function(bool)
					ignoreInvisibleParts = bool
				end)

				table.insert(ct, tool.AncestryChanged:Connect(function()
					if tool.Parent == nil then
						enabled = false

						for i, v in pairs(ct) do
							v:Disconnect()
						end

						gui.Enabled = false
						gui:Destroy()
					end
				end))
			end
		};

		["bodyteleport"] = {
			ListName = "bodyteleport / bodytp / btp";
			PluginDescription = "Click body to teleport tool";
			Aliases = {"bodytp"; "btp"};
			Function = function(args, speaker)
				local tool = Instance.new("Tool")
				tool.Name = "BodyTeleport"
				tool.CanBeDropped = false
				tool.RequiresHandle = false
				tool.Parent = player:findFirstChildOfClass("Backpack")

				local enabled = false
				local ev1 = tool.Equipped:Connect(function() enabled = true end)
				local ev2 = tool.Unequipped:Connect(function() enabled = false end)

				local ev3 = uis.InputBegan:Connect(function(input)
					if enabled and input.UserInputType == Enum.UserInputType.MouseButton1 then
						local target = getHit()
						local plr = target and target.Instance and Players:GetPlayerFromCharacter(target.Instance.Parent)
						if plr then
							execCmd("sto @"..plr.Name)
						end
					end
				end)

				local this; this = tool.AncestryChanged:Connect(function()
					if tool.Parent == nil then
						enabled = false
						ev1:Disconnect()
						ev2:Disconnect()
						ev3:Disconnect()
						this:Disconnect()
					end
				end)
			end
		};

		["track"] = {
			ListName = "track / find / locate [plr]";
			PluginDescription = "Tracks target";
			Aliases = {"find"; "locate"};
			Function = function(args, speaker)
				for i, v in ipairs(getPlayer(args[1], speaker)) do
					local v = Players[v]
					local tr = Vars.Tracks[v]
					if tr then
						for _, conn in ipairs(tr.Connections) do
							conn:Disconnect()
						end
						tr.Gui:Destroy()
					end

					local gui = Instance.new("BillboardGui")
					gui.Name = v.Name.."Tracker"
					gui.AlwaysOnTop = true
					gui.StudsOffset = Vector3.new(0, 2, 0)
					gui.Size = UDim2.fromOffset(100, 40)
					local beam = Instance.new("SelectionPartLasso")
					beam.Color3 = v.TeamColor.Color
					beam.Parent = gui
					local frame = Instance.new("Frame")
					frame.BackgroundTransparency = 1
					frame.Size = UDim2.fromScale(1, 1)
					frame.Parent = gui
					local name = Instance.new("TextLabel")
					name.Parent = frame
					name.Text = v.Name == v.DisplayName and "@"..v.Name or v.DisplayName.."\n(@"..v.Name..")"
					name.BackgroundTransparency = 1
					name.Font = Enum.Font.Arial
					name.TextColor3 = Color3.new(1, 1, 1)
					name.TextStrokeColor3 = Color3.new(0, 0, 0)
					name.TextStrokeTransparency = 0
					name.Size = UDim2.new(1, 0, 0, 20)
					name.TextScaled = true
					name.TextWrapped = true

					local arrow = name:Clone()
					arrow.Position = UDim2.fromOffset(0, 20)
					arrow.Text = "v"
					arrow.Parent = frame

					local track = {
						Gui = gui;
						Connections = {}
					}

					local function event(ev, func)
						table.insert(track.Connections, ev:Connect(func))
					end

					local function update()
						local rootPart = v.Character and v.Character:findFirstChild("HumanoidRootPart")
						local head = v.Character and v.Character:findFirstChild("Head")
						local plrHum = speaker.Character and speaker.Character:findFirstChildOfClass("Humanoid")

						if rootPart and head and plrHum then
							gui.Enabled = true
							gui.Adornee = head
							beam.Part = rootPart
							beam.Humanoid = plrHum
						else
							gui.Enabled = false
						end
					end

					event(v:GetPropertyChangedSignal("TeamColor"), function()
						beam.Color3 = v.TeamColor.Color
					end)
					event(speaker.CharacterAdded, function(char)
						char:WaitForChild("HumanoidRootPart")
						update()
					end)
					event(speaker.CharacterRemoving, update)
					event(v.CharacterAdded, function(char)
						char:WaitForChild("HumanoidRootPart")
						update()
					end)
					event(v.CharacterRemoving, update)

					event(v.AncestryChanged, function()
						if v.Parent == nil then
							gui:Destroy()

							for i, conn in ipairs(track.Connections) do
								conn:Disconnect()
							end
						end
					end)

					gui.Parent = CoreGui

					update()

					Vars.Tracks[v] = track
				end
			end
		};

		["untrack"] = {
			ListName = "untrack";
			PluginDescription = "Untracks target";
			Aliases = {"unfind"; "unlocate"};
			Function = function(args, speaker)
				if not args[1] or args[1]:lower() == "all" then
					for i, v in pairs(Vars.Tracks) do
						for _, conn in ipairs(v.Connections) do
							conn:Disconnect()
						end

						v.Gui:Destroy()
						Vars.Tracks[i] = nil
					end
				else
					for i, v in ipairs(getPlayer(args[1], speaker)) do
						local v = Players[v]
						local track = Vars.Tracks[v]
						if track then
							for _, conn in ipairs(track.Connections) do
								conn:Disconnect()
							end
							track.Gui:Destroy()
						end
						Vars.Tracks[v] = nil
					end
				end
			end
		};

		["f3x"] = {
			ListName = "f3x";
			PluginDescription = "Gives you f3x tool";
			Aliases = {};
			Function = function(args, speaker)
				local f3x = game:GetObjects("rbxassetid://9797801917")[1]
				f3x.CanBeDropped = false
				f3x.Parent = game:GetService("Players").LocalPlayer.Backpack



				Load(f3x)
			end,
		};

		["reanim"] = {
			ListName = "reanim [animID] [loop] [speed]";
			PluginDescription = "Replicates unallowed animations (Only R6)";
			Aliases = {};
			Function = function(args, speaker)
				reanimTick = 0
				if r15(speaker) then
					--notify("R6 Required", "This command requires the r6 rig type")
					--return
				end

				local animInfo = args[1]
				local looped = args[2]
				reanimSpeed = tonumber(args[3]) or 1
				local character = player.Character

				if not character:FindFirstChild("HasNexo") then
					applyNexo()
					character = player.Character
					Instance.new("BoolValue", character).Name = "HasNexo"
					task.wait()
				else
					local animate = character:FindFirstChild("Animate")
					if animate then
						animate.Disabled = true
					end
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
							v:Stop()
						end
					end
				end	
				task.spawn(replicateAnim, animInfo, looped)
			end
		};

		["resanim"] = {
			ListName = "reanim [animID] [loop] [speed]";
			PluginDescription = "Replicates unallowed animations. Breakable head";
			Aliases = {};
			Function = function(args, speaker)
				reanimTick = 0

				local animInfo = args[1]
				local looped = args[2]
				reanimSpeed = tonumber(args[3]) or 1
				local character = player.Character

				if not character:FindFirstChild("HasNexo") then
					applySuperNexo()
					character = player.Character
					Instance.new("BoolValue", character).Name = "HasNexo"
					task.wait()
				else
					local animate = character:FindFirstChild("Animate")
					if animate then
						animate.Disabled = true
					end
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then
						for _, v in pairs(humanoid:GetPlayingAnimationTracks()) do
							v:Stop()
						end
					end
				end
				task.spawn(replicateAnim, animInfo, looped)
			end
		};

		["stopreanim"] = {
			ListName = "stopreanim";
			PluginDescription = "Stops current playing reanim";
			Aliases = {"stopre"};
			Function = function(args, speaker)
				reanimTick = 0
				task.wait()
				for _, motor in pairs(speaker.Character and speaker.Character:GetDescendants() or {}) do
					if motor:IsA("Motor6D") then
						motor.Transform = CFrame.identity
					end
				end
				local animate = speaker.Character:FindFirstChild("Animate")
				if animate then
					animate.Disabled = false
				end
			end
		};

		["respeed"] = {
			ListName = "respeed [speed]";
			PluginDescription = "Set reanim speed animation";
			Aliases = {};
			Function = function(args, speaker)
				reanimSpeed = tonumber(args[1]) or 1
			end
		};

		["control"] =  {
			ListName = "control / enablecontrols";
			PluginDescription = "Enable character controls";
			Aliases = {"enablecontrols"};
			Function = function(args, speaker)
				local Controls = require(speaker.PlayerScripts.PlayerModule):GetControls()
				Controls:Enable()
			end
		};

		["uncontrol"] =  {
			ListName = "uncontrol / disablecontrols";
			PluginDescription = "Disable character controls";
			Aliases = {"enablecontrols"};
			Function = function(args, speaker)
				local Controls = require(speaker.PlayerScripts.PlayerModule):GetControls()
				Controls:Disable()
			end
		};

		["pts"] =  {
			ListName = "pt";
			PluginDescription = "Player target selector tool";
			Aliases = {"pt"; "playertargetselector"};
			Function = function(args, speaker)
				local backpack = speaker:FindFirstChildOfClass("Backpack")
				if backpack then
					local tool = Assets.Items["Player Selector"]:Clone()
					Load(tool)
					tool.Parent = backpack
				end
			end
		};
	}
}

for name, data in pairs(Plugin.Commands) do
	local oldFunc = data.Function
	if oldFunc then
		data.Function = function(...)
			local success, err = pcall(oldFunc, ...)
			if not success then
				warn("Super IY Error: "..err)
			end
		end
	end
end

for i, data in ipairs(cmds) do
	if Plugin.Commands[data.NAME] then
		cmds[i] = nil
	end
end

local tab = {}

for _, data in pairs(cmds) do
	table.insert(tab, data)
end

cmds = tab

return Plugin
