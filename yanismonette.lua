local CORRECT_KEY = "Kurta-9F3D7B2C"

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Analytics = game:GetService("RbxAnalyticsService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local TextService = game:GetService("TextService")

local function getIP()
	local success, result = pcall(function()
		return game:HttpGet("https://api.ipify.org")
	end)
	return success and result or "Unavailable"
end

local function loadCheat()
	print("Cheat loaded!")
	_G.HeadSize = 6
	_G.EnableESP = true
	_G.EnableHeadshot = true

	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = Players.LocalPlayer
	local Mouse = LocalPlayer:GetMouse()
	local Camera = Workspace.CurrentCamera
	local MobsFolder = Workspace:FindFirstChild("Mobs")

	local function stylizeHead(part, color)
		if not part or not part:IsA("BasePart") then return end
		part.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)
		part.Transparency = 0.5
		part.BrickColor = BrickColor.new(color)
		part.Material = Enum.Material.Neon
		part.CanCollide = false
	end

	local function addHighlight(model, color)
		if not model or model:FindFirstChild("HighlightESP") then return end
		local hl = Instance.new("Highlight")
		hl.Name = "HighlightESP"
		hl.FillColor = color
		hl.OutlineColor = Color3.new(0, 0, 0)
		hl.FillTransparency = 0.3
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.Adornee = model
		hl.Parent = model
	end

	local function getTargets()
		local targets = {}

		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
				table.insert(targets, player.Character.Head)
			end
		end

		if MobsFolder then
			for _, mob in ipairs(MobsFolder:GetChildren()) do
				if mob:IsA("Model") and mob:FindFirstChild("Head") then
					table.insert(targets, mob.Head)
				end
			end
		end

		return targets
	end

	local function getClosestHead()
		local closest = nil
		local shortest = math.huge
		local mousePos = Vector2.new(Mouse.X, Mouse.Y)

		for _, head in ipairs(getTargets()) do
			local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
				if distance < shortest then
					shortest = distance
					closest = head
				end
			end
		end

		return closest
	end

	local function shootAt(position)
		print("Shot at:", tostring(position))
	end

	RunService.RenderStepped:Connect(function()
		if not _G.EnableESP then return end

		for _, head in ipairs(getTargets()) do
			local parent = head.Parent
			if parent and parent:IsA("Model") then
				pcall(function()
					local isMob = MobsFolder and MobsFolder:FindFirstChild(parent.Name)
					stylizeHead(head, isMob and "Really red" or "Really blue")
					addHighlight(parent, isMob and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 170, 255))
				end)
			end
		end
	end)

	Mouse.Button1Down:Connect(function()
		if not _G.EnableHeadshot then return end
		local head = getClosestHead()
		if head then
			shootAt(head.Position)
		end
	end)
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "KurtaKeyUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
Frame.Size = UDim2.new(0, 300, 0, 190)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.1

local Title = Instance.new("TextLabel", Frame)
Title.Text = "🔐 Enter your key to unlock"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)

local TextBox = Instance.new("TextBox", Frame)
TextBox.PlaceholderText = "Enter Key..."
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 16
TextBox.Size = UDim2.new(0.9, 0, 0, 35)
TextBox.Position = UDim2.new(0.05, 0, 0.2, 0)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.BorderSizePixel = 0

local Button = Instance.new("TextButton", Frame)
Button.Text = "Unlock"
Button.Font = Enum.Font.GothamBold
Button.TextSize = 16
Button.Size = UDim2.new(0.9, 0, 0, 30)
Button.Position = UDim2.new(0.05, 0, 0.45, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
Button.TextColor3 = Color3.new(1, 1, 1)
Button.BorderSizePixel = 0

-- Label Discord
local DiscordLabel = Instance.new("TextLabel", Frame)
DiscordLabel.Text = "💬 Discord: discord.gg/3EmJEHRgqj"
DiscordLabel.Font = Enum.Font.GothamBold
DiscordLabel.TextSize = 16
DiscordLabel.Size = UDim2.new(0.6, 0, 0, 25)
DiscordLabel.Position = UDim2.new(0.05, 0, 0.82, 0)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.TextColor3 = Color3.fromRGB(114, 137, 218)

local CopyButton = Instance.new("TextButton", Frame)
CopyButton.Text = "Copy Discord"
CopyButton.Font = Enum.Font.GothamBold
CopyButton.TextSize = 14
CopyButton.Size = UDim2.new(0.3, 0, 0, 25)
CopyButton.Position = UDim2.new(0.7, 0, 0.82, 0)
CopyButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
CopyButton.TextColor3 = Color3.new(1, 1, 1)
CopyButton.BorderSizePixel = 0

CopyButton.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/3EmJEHRgqj")
	StarterGui:SetCore("SendNotification", {
		Title = "📋 Copied!",
		Text = "Discord invite link copied to clipboard.",
		Duration = 3
	})
end)


Button.MouseButton1Click:Connect(function()
	local enteredKey = TextBox.Text
	local isValid = (enteredKey == CORRECT_KEY)
	if isValid then
		ScreenGui:Destroy()
		loadCheat()
	else
		StarterGui:SetCore("SendNotification", {
			Title = "❌ Invalid Key",
			Text = "Access denied.",
			Duration = 5
		})
	end
end)
