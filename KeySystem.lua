local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("NovaxHub - Key System", "BloodTheme")

local KeyTab = Window:NewTab("Key")
local KeySection = KeyTab:NewSection("Enter Key")

KeySection:NewTextBox("Enter Key...", "TextboxInfo", function(key)
	if key == "novaxhubisthenewgenerationofrobloxscript" then
		local GamesLists = loadstring(game:HttpGet("https://raw.githubusercontent.com/AidenNg1103/NovaxHub/main/GamesLists.lua"))
		
		for i, v in next, GamesLists do
			if i == game.GameId or i == game.PlaceId then
				loadstring(game:HttpGet(v))()
			end
		end
	end
end)
