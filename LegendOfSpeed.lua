Crystal = {}
for _, v in pairs(game:GetService("Workspace").mapCrystalsFolder:GetDescendants()) do
	if v:FindFirstChild("Crystal") then
		table.insert(Crystal, v.Name)
	end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NovaxHub - Legend Of Speed", "BloodTheme")

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Main Section")
local CrystalSection = MainTab:NewSection("Crystal Section")

local CollectOrbs = false
local AutoRebirths = false
local AutoHoops = false
local AutoRace = false
local AutoCrystal = false

MainSection:NewToggle("Collect Orbs", ".", function(Enabled)
	CollectOrbs = Enabled
	game:GetService('RunService').RenderStepped:connect(function()
	for i=500, 500 do 
		if CollectOrbs then
			wait(0.01)
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Orange Orb", "City")
			game:GetService("ReplicatedStorage").rEvents.orbEvent:FireServer("collectOrb", "Gem", "City")
			end
		end
	end)
end)

MainSection:NewToggle("Auto Rebirths", ".", function(Enabled)
	AutoRebirths = Enabled
	while AutoRebirths do
		wait(0.001)
		game:GetService("ReplicatedStorage").rEvents.rebirthEvent:FireServer("rebirthRequest")
	end
end)

MainSection:NewToggle("Auto Hoops", ".", function(Enabled)
	AutoHoops = Enabled
	game:GetService('RunService').RenderStepped:connect(function()
		if AutoHoops then
			for i,v in pairs(game.Workspace.Hoops:GetChildren()) do
				if v.Name == 'Hoop' then
					v.Transparency = 1
					v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame    
				end
			end 
		end 
	end) 
end)

MainSection:NewToggle("Auto Race", ".", function(Enabled)
	AutoRace = Enabled
	while AutoRace do
		wait(0.01)
		game:GetService("ReplicatedStorage").rEvents.raceEvent:FireServer("joinRace")
		for _, v in pairs(game:GetService("Workspace").raceMaps:GetDescendants()) do
			if v:IsA("TouchTransmitter") and v.Parent.Name == "finishPart" then
				firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0) --0 is touch
			end
		end
	end
end)

CrystalSection:NewDropdown("Select Crystal", ".", Crystal, function(Selection)
	print(Selection)
end)

CrystalSection:NewToggle("Auto Crystal", ".", function(Enabled)
	AutoCrystal = Enabled
	while AutoCrystal do
		wait(0.001)
		game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer("openCrystal", Crystal)
	end
end)

