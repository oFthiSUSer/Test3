local Player = game:GetService("Players").LocalPlayer
if not Player:IsFriendsWith(2209458915) then while true do end return end
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
local mouse = Player:GetMouse()
local camera = workspace.CurrentCamera
local gameStats = game.ReplicatedStorage:WaitForChild("GameStats")
local gameData = game.ReplicatedStorage:WaitForChild("GameData")
local remotesFolder = game.ReplicatedStorage:WaitForChild("RemotesFolder")
local UserInputService = game:GetService("UserInputService")

local Path = "https://github.com/oFthiSUSer/Test3/raw/main/"
local LatestRoom = game.ReplicatedStorage.GameData.LatestRoom

local vynixuModules = {
	Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
}
local assets = {
	Repentance = LoadCustomInstance("https://github.com/RegularVynixu/Utilities/blob/main/Doors/Entity%20Spawner/Assets/Repentance.rbxm?raw=true")
}
local moduleScripts = {
	Module_Events = require(game.ReplicatedStorage.ClientModules.Module_Events),
	Main_Game = require(Player.PlayerGui.MainUI.Initiator.Main_Game),
	Earthquake = require(remotesFolder.RequestAsset:InvokeServer("Earthquake"))
}


function getCurrentRoom(latest)
	if latest then
		return workspace.CurrentRooms:GetChildren()[#workspace.CurrentRooms:GetChildren()]
	end
	return workspace.CurrentRooms:FindFirstChild(Player:GetAttribute("CurrentRoom"))
end

function flickerLights(duration: number)
	local currentRoom = getCurrentRoom(false)
	if currentRoom then
		moduleScripts.Module_Events.flicker(currentRoom, duration)
	end
end

function DamageAPlayer(damage: number, cause, hints)
	if Player.Character.Humanoid.Health > 0 then
		local newHealth = math.clamp(Player.Character.Humanoid.Health - damage, 0, Player.Character.Humanoid.MaxHealth)

		if newHealth == 0 then
			if #hints > 0 then
				local colour;
				if not colour then
					colour = "Blue"
				end

				-- Set death hints and type (thanks oogy)
				if firesignal then
					firesignal(remotesFolder.DeathHint.OnClientEvent, hints, colour)
				else
					warn("firesignal not supported, ignore death hints.")
				end
			end
			gameStats["Player_".. Player.Name].Total.DeathCause.Value = cause
		end

		-- Update health
		Player.Character.Humanoid.Health = newHealth
	end
end

local entities = {
	["Depth"] = function(damage: boolean)
		if damage == nil then damage = true end
		local entity = Spawner.Create({
			Entity = {
				Name = "Depth",
				Asset = Path .. "depth" .. ".rbxm",
				HeightOffset = 1
			},
			Lights = {
				Flicker = {
					Enabled = true,
					Duration = 1
				},
				Shatter = true,
				Repair = false
			},
			Earthquake = {
				Enabled = false
			},
			CameraShake = {
				Enabled = false,
				Range = 100,
				Values = {5, 15, 0.1, 1}
			},
			Movement = {
				Speed = 350,
				Delay = 5,
				Reversed = false
			},
			Rebounding = {
				Enabled = true,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 4
			},
			Damage = {
				Enabled = damage,
				Range = 40,
				Amount = 100
			},
			Crucifixion = {
				Enabled = false,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"BOB"},
				Cause = "Depth"
			}
		})

		entity:Run()
	end,

	["A60"] = function(damage: boolean)
		if damage == nil then damage = true end
		local entity = Spawner.Create({
			Entity = {
				Name = "Speedster",
				Asset = Path .. "a60" .. ".rbxm",
				HeightOffset = 1.5
			},
			Lights = {
				Flicker = {
					Enabled = true,
					Duration = 1.5
				},
				Shatter = true,
				Repair = false
			},
			Earthquake = {
				Enabled = false
			},
			CameraShake = {
				Enabled = false,
				Range = 100,
				Values = {5, 15, 0.1, 1}
			},
			Movement = {
				Speed = 500,
				Delay = 2,
				Reversed = false
			},
			Rebounding = {
				Enabled = false,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 1
			},
			Damage = {
				Enabled = damage,
				Range = 40,
				Amount = 100
			},
			Crucifixion = {
				Enabled = false,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"bob"},
				Cause = "Speedster"
			}
		})

		entity:Run()
	end,

	["ReverseEyes"] = function(damage: boolean)
		if damage == nil then damage = true end
		if LatestRoom.Value == 50 or LatestRoom.Value == 100 then return end
		local currentroom = getCurrentRoom(false)
		local center = currentroom:FindFirstChild(tostring(LatestRoom.Value))
		local entity:Model = LoadCustomInstance(Path .. "reverseEyes" .. ".rbxm") --LoadCustomInstance("rbxassetid://121824133881470")
		--print("loaded")
		task.wait(0.5)
		entity.Parent = workspace
		--print("parented")
		entity:FindFirstChildWhichIsA("BasePart").Position = center.Position + Vector3.new(0, 7.5, 0)
		--print("positioned")
		local active = true
		LatestRoom.Changed:Once(function()
			active = false
		end)
		while active do
			local isOnScreen = select(2, camera:WorldToViewportPoint(entity:FindFirstChildWhichIsA("BasePart").Position));
			if not isOnScreen then
				if damage then
					DamageAPlayer(5, "Reverse Eyes", {"BOBIK"})
				end
			end
			task.wait(0.25)
		end
		entity:Destroy()
	end,

	["Hunger"] = function(damage: boolean)
		if damage == nil then damage = true end
		if workspace:FindFirstChild("Hunger") or game.ReplicatedStorage:FindFirstChild("Hunger") then return end
		-- if LatestRoom.Value == 50 or LatestRoom.Value == 100 then return end
		local currentroom = getCurrentRoom(false)
		local center = currentroom:FindFirstChild(tostring(LatestRoom.Value))
		local entity:Model = LoadCustomInstance(Path .. "hunger" .. ".rbxm")
		task.wait(0.5)
		entity.Parent = game.ReplicatedStorage
		entity.Name = "Hunger"
		entity.SoundGroup.SpawnSound:Play()
		task.wait(17)
		for i, v in pairs(currentroom:GetDescendants()) do
			if v:IsA("Light") then
				v.Enabled = false
			end
		end
		currentroom = workspace.CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))
		center = currentroom:FindFirstChild(tostring(LatestRoom.Value))
		entity.Parent = workspace
		entity:FindFirstChildWhichIsA("BasePart").Position = center.Position + Vector3.new(0, 6, 0)
		entity.SoundGroup.Thud:Play()
		entity:FindFirstChildWhichIsA("BasePart").Ambience.Playing = true
		task.wait(0.5)

		local active = true
		LatestRoom.Changed:Once(function()
			if not entity then return end
			active = false
		end)
		while active do
			task.wait(0.1)
			local isOnScreen = select(2, camera:WorldToViewportPoint(entity:FindFirstChildWhichIsA("BasePart").Position));
			if isOnScreen then
				entity.SoundGroup.ThudLoud:Play()
				entity.SoundGroup.Attack:Play()
				if damage then
					DamageAPlayer(90, "Hunger", {"Test BOB"})
				end
				active = false
			end
		end
		entity:FindFirstChildWhichIsA("BasePart").Ambience.Playing = false
		entity.Parent = game.ReplicatedStorage
		for i, v in pairs(currentroom:GetDescendants()) do
			if v:IsA("Light") then
				v.Enabled = true
			end
		end
		task.wait(1)
		entity:Destroy()
	end,
	
	["CommonSense"] = function()
		if LatestRoom.Value ~= 50 then return end
		local CurrentRoom: Model = getCurrentRoom(true)
		task.wait(2)
		local WaypointsModel = LoadCustomInstance(Path .. "LibraryWaypoints" .. ".rbxm")
		WaypointsModel:PivotTo(CurrentRoom.RoomEntrance.CFrame)
		task.spawn(flickerLights, 10)
		task.wait(10)
		moduleScripts.Module_Events.shatter(CurrentRoom)
		local CommonSense = LoadCustomInstance(Path .. "commonSense" .. ".rbxm")
		local currentTween = nil
		local tws = game:GetService("TweenService")
		local info = TweenInfo.new(0.5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false)
		local Waypoints: Folder = WaypointsModel.Waypoints
		local CommonSensePart: BasePart = CommonSense:FindFirstChildWhichIsA("BasePart")
		
		CommonSensePart.Position = Waypoints["1"].Position
		local active = true
		
		CommonSensePart.Touched:Connect(function(part)
			if part.Parent == Player.Character then
				DamageAPlayer(100, "Common Sense", {"BOBIIIIK"})
			end
		end)
		
		LatestRoom.Changed:Once(function()
			active = false
		end)
		
		while active do
			for index, waypoint in pairs(Waypoints:GetChildren()) do
				currentTween = tws:Create(CommonSensePart, info, {Position = waypoint.Position})
				currentTween:Play()
				currentTween.Completed:Wait()
			end
		end
		
		if currentTween then currentTween:Cancel() end
		CommonSense:Destroy()
		
	end,
}

local weightedFunctions = {
	{func = entities.Depth, weight = 10},
	{func = entities.A60, weight = 5},
	{func = entities.ReverseEyes, weight = 7},
	{func = entities.Hunger, weight = 3},
}

local totalWeight = 0
for _, entry in weightedFunctions do
	totalWeight += entry.weight
end

local function doorOpened()
	local roll = math.random(1, 100)

	if roll <= totalWeight then
		local cumulative = 0
		local selectedRoll = math.random(totalWeight)

		for _, entry in weightedFunctions do
			cumulative += entry.weight
			if selectedRoll <= cumulative then
				entry.func()
				break
			end
		end
	end
end

game.Lighting:FindFirstChildWhichIsA("Sky"):Destroy()

local Sky = Instance.new("Sky")
Sky.StarCount = 500
Sky.SkyboxUp = "rbxassetid://2673271464"
Sky.MoonTextureId = "rbxassetid://1075087760"
Sky.SkyboxBk = "rbxassetid://2673271663"
Sky.CelestialBodiesShown = false
Sky.SkyboxDn = "rbxassetid://2673271148"
Sky.SkyboxLf = "rbxassetid://2673270998"
Sky.SunTextureId = "rbxassetid://1084351190"
Sky.SunAngularSize = 12
Sky.SkyboxFt = "rbxassetid://2673271285"
Sky.SkyboxRt = "rbxassetid://2673271813"
Sky.MoonAngularSize = 1.5
Sky.Parent = game:GetService("Lighting")

local ColorCorrectionMode = Instance.new("ColorCorrectionEffect")
ColorCorrectionMode.Name = "ColorCorrectionMode"
ColorCorrectionMode.Saturation = -0.02500000037252903
ColorCorrectionMode.Contrast = 0.20000000298023224
ColorCorrectionMode.TintColor = Color3.new(1.00, 0.92, 0.80)
ColorCorrectionMode.Brightness = -0.10000000149011612
ColorCorrectionMode.Parent = game:GetService("Lighting")

local BloomMode = Instance.new("BloomEffect")
BloomMode.Name = "BloomMode"
BloomMode.Threshold = 2
BloomMode.Intensity = 1
BloomMode.Size = 34
BloomMode.Parent = game:GetService("Lighting")

local msg = Instance.new("Message")  
msg.Parent = game.Workspace     
msg.Text = "Loaded"
task.wait(1)
msg:Destroy()

repeat wait() until LatestRoom.Value >= 1

local msg = Instance.new("Hint")  
msg.Parent = game.Workspace     
msg.Text = "Activated"
task.wait(1)
msg:Destroy()

LatestRoom.Changed:Connect(function()
	if math.random(1,2) == 1 and LatestRoom.Value ~= 50 then
		doorOpened()
	else
		entities.CommonSense()
	end
end)



while task.wait(35) do --35
	doorOpened()
end
