local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Stupid KenHang", "BloodTheme")
local AimbotTab = Window:NewTab("Aimbot")
local AimbotSection = AimbotTab:NewSection("Aimbot")

getgenv().Circle = Drawing.new("Circle")
if Circle then
	Circle.Color = Color3.fromRGB(22, 13, 56)
	Circle.Thickness = 1
	Circle.Radius = 250
	Circle.Visible = false
	Circle.NumSides = 1000
	Circle.Filled = false
	Circle.Transparency = 1
end

local ToggleAimbot = false
local AimbotWallCheck = false
local FOV = 250
local AimbotFOVEnabled = false

local Shoot, Aim
UserInputService.InputBegan:Connect(function(v)
	if v.UserInputType == Enum.UserInputType.MouseButton2 then
		Shoot = true
		Aim = true
	end
end)

UserInputService.InputEnded:Connect(function(v)
	if v.UserInputType == Enum.UserInputType.MouseButton2 then
		Shoot = false
		Aim = false
	end
end)

local NotWall = function(i, v)
	if AimbotWallCheck then
		local c = Workspace.CurrentCamera.CFrame.p
		local a = Ray.new(c, i - c)
		local f = Workspace:FindPartOnRayWithIgnoreList(a, v)
		return f == nil
	else
		return true
	end
end

local GetClosestToCursor = function()
	local Target, Mouse, IsFFA = nil, Player:GetMouse(), ReplicatedStorage.wkspc.FFA.Value
	for _, v in next, Players:GetPlayers() do
		if v ~= Player then
			if v.Team ~= Player.Team or v.Team == Player.Team and IsFFA then
				if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					if v.Character:FindFirstChildWhichIsA("Humanoid").Health ~= 0 then
						local Point, OnScreen = Workspace.CurrentCamera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
						if OnScreen and NotWall(v.Character.HumanoidRootPart.Position, {Player.Character, v.Character}) then
							local Mag = (Vector2.new(Point.X, Point.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
							if Mag <= FOV then
								Target = v
							end
						end
					end
				end
			end
		end
	end
	return Target
end

local FOVCircleToggle = AimbotSection:NewToggle("Toggle FOV Circle", "Enable/Disable FOV Circle", function(Enabled)
	AimbotFOVEnabled = Enabled
	Circle.Visible = Enabled
end)

AimbotSection:NewSlider("Aimbot FOV", "Adjust the FOV for the aimbot", 2500, 250, function(Value)
	FOV = Value
	if FOVCircleToggle then
		Circle.Radius = Value
	end
end)

AimbotSection:NewToggle("Toggle Aimbot", "Enable/Disable Aimbot", function(Enabled)
	ToggleAimbot = Enabled
end)

AimbotSection:NewToggle("Toggle Wall Check", "Enable/Disable Wall Check", function(Enabled)
	AimbotWallCheck = Enabled
end)

local GunModsTab = Window:NewTab("GunMods")
local GunModsSection = GunModsTab:NewSection("Gun Mods")

local Auto = false
local FireRate = false
local InfiniteAmmo = false
local NoSpread = false
local Recoil = false

-- Function for modifying weapon values
local ValuesTable = {}
local ChangeValue = function(NewValue, Amount, Toggle)
	for i, v in next, ReplicatedStorage.Weapons:GetChildren() do
		if not v.Model:FindFirstChild("Secondary", true) then
			if Toggle and v:FindFirstChild(NewValue) ~= nil then
				local Value1 = v:FindFirstChild(NewValue)
				ValuesTable[Value1] = Value1.Value
				Value1.Value = Amount
			elseif not Toggle and v:FindFirstChild(NewValue) ~= nil then
				local Value1 = v:FindFirstChild(NewValue)
				if table.find(ValuesTable, Value1) then
					Value1.Value = ValuesTable[Value1]
				end
			end
		end
	end
end

-- Coroutine to periodically modify weapon values
spawn(function()
	while wait(3) do
		pcall(function()
			ChangeValue("Auto", true, Auto)
			ChangeValue("Ammo", 999, InfiniteAmmo)
			ChangeValue("Spread", 0, NoSpread)
			ChangeValue("MaxSpread", 0, NoSpread)
			ChangeValue("RecoilControl", 0, Recoil)
		end)
	end
end)

-- Gun Mods toggles with logic
GunModsSection:NewToggle("Automatic Gun", "Enable/Disable Automatic Gun", function(Enabled)
	Auto = Enabled
end)

GunModsSection:NewToggle("Fast Gun FirRate", "Enable/Disable Fast Gun Fire Rate", function(Enabled)
	FireRate = Enabled
end)

GunModsSection:NewToggle("Max Ammo", "Enable/Disable Maximum Ammo", function(Enabled)
	InfiniteAmmo = Enabled
end)

GunModsSection:NewToggle("No Spread", "Enable/Disable No Spread", function(Enabled)
	NoSpread = Enabled
end)

GunModsSection:NewToggle("No Recoil", "Enable/Disable No Recoil", function(Enabled)
	Recoil = Enabled
end)

RunService.Stepped:Connect(function()
	pcall(function()
		if ToggleAimbot and Shoot then
			local ClosestPlayer = GetClosestToCursor()
			if ClosestPlayer then
				Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, ClosestPlayer.Character.Head.CFrame.Position)
			end
		end
		if AimbotFOVEnabled then
			local Mouse = UserInputService:GetMouseLocation()
			Circle.Position = Vector2.new(Mouse.X, Mouse.Y)
		end
	end)
end)
