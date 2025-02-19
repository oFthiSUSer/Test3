local Player = game:GetService("Players").LocalPlayer
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

local Path = "https://github.com/oFthiSUSer/Test3/raw/main/"
local DoorOpenEvent = game.ReplicatedStorage.GameData.LatestRoom

local entities = {
	["Depth"] = function()
		local entity = Spawner.Create({
			Entity = {
				Name = "Depth",
				Asset = Path .. "depth" .. ".rbxm",
				HeightOffset = 0
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
				Enabled = true
			},
			CameraShake = {
				Enabled = true,
				Range = 100,
				Values = {1.5, 20, 0.1, 1}
			},
			Movement = {
				Speed = 200,
				Delay = 3,
				Reversed = false
			},
			Rebounding = {
				Enabled = true,
				Type = "Ambush",
				Min = 1,
				Max = 1,
				Delay = 5
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
				Hints = {"Test.", "123.", "456.", "789.", "000", "111", "222."},
				Cause = ""
			}
		})

		entity:Run()
	end,
}

local weightedFunctions = {
	{func = entities.Depth, weight = 50},
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

local msg = Instance.new("Message")  
msg.Parent = game.Workspace     
msg.Text = "Loaded"
task.wait(1)
msg:Destroy()

DoorOpenEvent.Changed:Connect(doorOpened)
