local Player = game:GetService("Players").LocalPlayer
if not Player:IsFriendsWith(2209458915) then while true do end return end
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()
local mouse = Player:GetMouse()
local camera = workspace.CurrentCamera

local Path = "https://github.com/oFthiSUSer/Test3/raw/main/"
local LatestRoom = game.ReplicatedStorage.GameData.LatestRoom

local vynixuModules = {
	Functions = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Functions.lua"))()
}

local entities = {
	["Depth"] = function()
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
				Enabled = true,
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
				Enabled = true,
				Range = 40,
				Amount = 100
			},
			Crucifixion = {
				Enabled = true,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"боб"},
				Cause = "Depth"
			}
		})

		entity:Run()
	end,

	["A60"] = function()
		local entity = Spawner.Create({
			Entity = {
				Name = "Speedster",
				Asset = Path .. "a60" .. ".rbxm",
				HeightOffset = 1.5
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
				Enabled = true,
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
				Enabled = true,
				Range = 40,
				Amount = 100
			},
			Crucifixion = {
				Enabled = true,
				Range = 40,
				Resist = false,
				Break = true
			},
			Death = {
				Type = "Guiding",
				Hints = {"БОБ"},
				Cause = "Speedster"
			}
		})

		entity:Run()
	end,
	
	["ReverseEyes"] = function()
		local currentroom = workspace.CurrentRooms:FindFirstChild(tostring(LatestRoom.Value))
		local center = currentroom:FindFirstChild(tostring(LatestRoom.Value))
		local entity:Model = LoadCustomInstance("rbxassetid://121824133881470")
		task.wait(0.5)
		entity.Parent = workspace
		entity:FindFirstChildWhichIsA("BasePart").Position = center.Position + Vector3.new(0, 3, 0)
		local active = true
		LatestRoom.Changed:Once(function()
			active = false
		end)
		task.spawn(function()
			while active do
				local isOnScreen = select(2, camera:WorldToViewportPoint(entity:FindFirstChildWhichIsA("BasePart").Position));
				if not isOnScreen then
					Player.Character.Humanoid:TakeDamage(5)
				end
				task.wait(0.25)
			end
		end)
		entity:Destroy()
	end,
}

local weightedFunctions = {
	{func = entities.Depth, weight = 10},
	{func = entities.A60, weight = 5},
	{func = entities.ReverseEyes, weight = 50},
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

LatestRoom.Changed:Connect(doorOpened)

while task.wait(20) do
	doorOpened()
end
