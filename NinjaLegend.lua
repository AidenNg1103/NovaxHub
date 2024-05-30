ChestRewards = {}
for _, v in pairs(game:GetService("ReplicatedStorage").chestRewards:GetDescendants()) do
	if v.Name ~= "Light Karma Chest" or v.Name ~= "Evil Karma Chest" then
		table.insert(ChestRewards, v.Name)
	end
end

Ranks = {}
for _, v in pairs(game:GetService("ReplicatedStorage").Ranks.Ground:GetDescendants()) do
	if v:FindFirstChild("rankColor") then
		table.insert(Ranks, v.Name)
	end
end

Crystal = {}
for _, v in pairs(game:GetService("Workspace").mapCrystalsFolder:GetDescendants()) do
	if v:FindFirstChild("Crystal") then
		table.insert(Crystal, v.Name)
	end
end

Boss = {}
for _, v in pairs(game:GetService("Workspace").bossFolder:GetDescendants()) do
	if v:FindFirstChild("HumanoidRootPart") then
		table.insert(Boss, v.Name)
	end
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NovaxHub - Ninja Legend", "BloodTheme")

local MainTab = Window:NewTab("Main")
local CreditsTab = Window:NewTab("Credits")
local MainSection = MainTab:NewSection("Main Section")
local CrystalSection = MainTab:NewSection("Crystal Section")
local BossSection = MainTab:NewSection("Boss Section")
local ShopSection = MainTab:NewSection("Shop Section")
local CreditsSection = CreditsTab:NewSection("Credits Section")

local AutoSwing = false
local AutoSell = false
local AutoHoops = false
local AutoCrystal = false
local AutoBoss = false
local AutoSwords = false
local AutoBelts = false
local AutoRanks = false

MainSection:NewToggle("Auto Swing", ".", function(Enabled)
	AutoSwing = Enabled
	while AutoSwing do
		wait(0.01)
		game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
	end
end)

MainSection:NewToggle("Auto Sell", ".", function(Enabled)
	AutoSell = Enabled
	while AutoSell do
		wait(1)
		firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").sellAreaCircles.sellAreaCircle16.circleInner, 0)
	end
end)

MainSection:NewToggle("Auto Hoops", ".", function(Enabled)
	AutoSell = Enabled
	while AutoSell do
		wait(1)
		firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, game:GetService("Workspace").sellAreaCircles.sellAreaCircle16.circleInner, 0)
	end
end)

CrystalSection:NewDropdown("Select Crystal", ".", Crystal, function(Selection)
	print(Selection)
end)

CrystalSection:NewToggle("Auto Crystal", ".", function(Enabled)
	AutoCrystal = Enabled
	while AutoCrystal do
		wait(0.01)
		game:GetService("ReplicatedStorage").rEvents.openCrystalRemote:InvokeServer("openCrystal", Crystal)
	end
end)

BossSection:NewDropdown("Select Boss", ".", Boss, function(Selection)
	print(Selection)
end)

BossSection:NewToggle("Auto Boss", ".", function(Enabled)
	AutoBoss = Enabled
	game:GetService("RunService").Stepped:Connect(function()
		pcall(function()
			if AutoBoss then
				game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("swingKatana")
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").bossFolder[Boss]:WaitForChild("HumanoidRootPart").CFrame
			end
		end)
	end)
end)

ShopSection:NewToggle("Auto Swords", ".", function(Enabled)
	AutoSwords = Enabled
	while AutoSwords do
		wait()
		game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllSwords", "Blazing Vortex Island")
	end
end)

ShopSection:NewToggle("Auto Belts", ".", function(Enabled)
	AutoBelts = Enabled
	while AutoBelts do
		wait()
		game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyAllBelts", "Blazing Vortex Island")
	end
end)

ShopSection:NewToggle("Auto Ranks", ".", function(Enabled)
	AutoRanks = Enabled
	while AutoRanks do
		wait()
		for i = 1, #Ranks do
			game:GetService("Players").LocalPlayer.ninjaEvent:FireServer("buyRank", jk1[i])
		end
	end
end)

CreditsSection:NewLabel("Scripter: NovaxHub (Aiden Ng)")
