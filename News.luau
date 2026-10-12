local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer

local ParentTarget = Player:WaitForChild("PlayerGui")
pcall(function()
	if gethui then
		ParentTarget = gethui()
	elseif game:GetService("CoreGui") then
		ParentTarget = game:GetService("CoreGui")
	end
end)

local MainGUI = ParentTarget:FindFirstChild("MM2_HUB_MASTER")
if not MainGUI then return end

local Principal = MainGUI:FindFirstChild("Principal")
if not Principal then return end

local GameScroll = Principal:FindFirstChild("ScrollingFrame") or Principal:FindFirstChildOfClass("ScrollingFrame")
local GamePage = GameScroll and GameScroll:FindFirstChildOfClass("Frame")
if not GamePage then return end

--------------------------------------------------
-- REORGANIZACIÓN DE POSICIONES
--------------------------------------------------

for _, child in ipairs(GamePage:GetChildren()) do
	if child:IsA("GuiObject") then
		child.Position = UDim2.fromOffset(0, child.Position.Y.Offset + 270)
	end
end

--------------------------------------------------
-- ESTILOS Y AUXILIARES
--------------------------------------------------

local function st(o, c, w)
	local s = Instance.new("UIStroke")
	s.Color = c
	s.Thickness = w
	s.Parent = o
	return s
end

local function cr(o, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = o
end

local function addToggleRow(labelText, yOffset, onToggle)
	local Row = Instance.new("Frame")
	Row.Name = "ExtraToggle_" .. labelText
	Row.Size = UDim2.new(1, 0, 0, 42)
	Row.Position = UDim2.fromOffset(0, yOffset)
	Row.BackgroundColor3 = Color3.fromRGB(10, 17, 28)
	Row.BackgroundTransparency = 0.2
	Row.ZIndex = 5
	Row.Parent = GamePage
	cr(Row, 9)
	st(Row, Color3.fromRGB(0, 95, 220), 1)

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -65, 1, 0)
	Label.Position = UDim2.fromOffset(12, 0)
	Label.BackgroundTransparency = 1
	Label.Text = labelText
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 11
	Label.TextColor3 = Color3.new(1, 1, 1)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.ZIndex = 6
	Label.Parent = Row

	local ToggleBg = Instance.new("Frame")
	ToggleBg.Size = UDim2.fromOffset(48, 24)
	ToggleBg.Position = UDim2.new(1, -56, 0.5, -12)
	ToggleBg.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
	ToggleBg.ZIndex = 6
	ToggleBg.Parent = Row
	cr(ToggleBg, 12)
	st(ToggleBg, Color3.fromRGB(0, 150, 255), 1)

	local ToggleKnob = Instance.new("Frame")
	ToggleKnob.Size = UDim2.fromOffset(18, 18)
	ToggleKnob.Position = UDim2.new(0, 3, 0.5, -9)
	ToggleKnob.BackgroundColor3 = Color3.new(1, 1, 1)
	ToggleKnob.ZIndex = 7
	ToggleKnob.Parent = ToggleBg
	cr(ToggleKnob, 9)

	local ToggleBtn = Instance.new("TextButton")
	ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
	ToggleBtn.BackgroundTransparency = 1
	ToggleBtn.Text = ""
	ToggleBtn.ZIndex = 8
	ToggleBtn.Parent = ToggleBg

	local state = false
	ToggleBtn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 170, 255)}):Play()
			TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
			Label.TextColor3 = Color3.fromRGB(0, 220, 255)
		else
			TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 45, 55)}):Play()
			TweenService:Create(ToggleKnob, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
			Label.TextColor3 = Color3.new(1, 1, 1)
		end
		if onToggle then onToggle(state) end
	end)

	return Row
end

--------------------------------------------------
-- SUBTÍTULO
--------------------------------------------------

local NewSectionTitle = Instance.new("TextLabel")
NewSectionTitle.Name = "NewSectionTitle"
NewSectionTitle.Size = UDim2.new(1, 0, 0, 24)
NewSectionTitle.Position = UDim2.fromOffset(0, 5)
NewSectionTitle.BackgroundTransparency = 1
NewSectionTitle.Text = "-- 🔥 nuevo 🔥 --"
NewSectionTitle.Font = Enum.Font.GothamBold
NewSectionTitle.TextSize = 11
NewSectionTitle.TextColor3 = Color3.fromRGB(255, 170, 0)
NewSectionTitle.TextXAlignment = Enum.TextXAlignment.Center
NewSectionTitle.ZIndex = 5
NewSectionTitle.Parent = GamePage

--------------------------------------------------
-- LÓGICA FLY Y CAMPO DE VELOCIDAD
--------------------------------------------------

local FlyEnabled = false
local FlySpeed = 1
local flyConn = nil
local tpwalking = false

addToggleRow("Volar (Fly)", 32, function(val)
	FlyEnabled = val
	local speaker = Player
	local chr = speaker.Character
	if not chr then return end
	local hum = chr:FindFirstChildOfClass("Humanoid")

	if val then
		tpwalking = true
		for i = 1, FlySpeed do
			task.spawn(function()
				local hb = RunService.Heartbeat
				while tpwalking and hb:Wait() and speaker.Character and hum and hum.Parent do
					if hum.MoveDirection.Magnitude > 0 then
						speaker.Character:TranslateBy(hum.MoveDirection)
					end
				end
			end)
		end

		if chr:FindFirstChild("Animate") then
			chr.Animate.Disabled = true
		end

		for _, v in ipairs(hum:GetPlayingAnimationTracks()) do
			v:AdjustSpeed(0)
		end

		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, false)
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
		hum:ChangeState(Enum.HumanoidStateType.Swimming)
	else
		tpwalking = false
		if chr:FindFirstChild("Animate") then
			chr.Animate.Disabled = false
		end
		hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Landed, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.RunningNoPhysics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.StrafingNoPhysics, true)
		hum:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)
		hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
	end
end)

local SpeedRow = Instance.new("Frame")
SpeedRow.Size = UDim2.new(1, 0, 0, 42)
SpeedRow.Position = UDim2.fromOffset(0, 79)
SpeedRow.BackgroundColor3 = Color3.fromRGB(10, 17, 28)
SpeedRow.BackgroundTransparency = 0.2
SpeedRow.ZIndex = 5
SpeedRow.Parent = GamePage
cr(SpeedRow, 9)
st(SpeedRow, Color3.fromRGB(0, 95, 220), 1)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -90, 1, 0)
SpeedLabel.Position = UDim2.fromOffset(12, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Velocidad de Fly"
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextSize = 11
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.ZIndex = 6
SpeedLabel.Parent = SpeedRow

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.fromOffset(65, 26)
SpeedBox.Position = UDim2.new(1, -75, 0.5, -13)
SpeedBox.BackgroundColor3 = Color3.fromRGB(8, 12, 18)
SpeedBox.Text = "1"
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.TextSize = 11
SpeedBox.TextColor3 = Color3.fromRGB(0, 220, 255)
SpeedBox.KeyboardType = Enum.KeyboardType.Number
SpeedBox.ZIndex = 6
SpeedBox.Parent = SpeedRow
cr(SpeedBox, 7)
st(SpeedBox, Color3.fromRGB(0, 125, 255), 1)

SpeedBox:GetPropertyChangedSignal("Text"):Connect(function()
	local filtered = SpeedBox.Text:gsub("%D", "")
	if filtered ~= SpeedBox.Text then
		SpeedBox.Text = filtered
	end
	local num = tonumber(filtered)
	if num then
		FlySpeed = math.max(1, num)
	end
end)

--------------------------------------------------
-- LÓGICA INVISIBLE
--------------------------------------------------

local IsInvisible = false
local VisibleParts = {}
local invisibleConn = nil

local function SetupCharacterParts()
	VisibleParts = {}
	local char = Player.Character
	if not char then return end
	for _, descendant in pairs(char:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant.Transparency == 0 then
			table.insert(VisibleParts, descendant)
		end
	end
end

SetupCharacterParts()
Player.CharacterAdded:Connect(function()
	task.wait(0.5)
	SetupCharacterParts()
	IsInvisible = false
end)

addToggleRow("Invisible", 126, function(val)
	IsInvisible = val
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")

	local transparency = IsInvisible and 0.5 or 0
	for _, part in pairs(VisibleParts) do
		if part and part.Parent then
			part.Transparency = transparency
		end
	end

	if val then
		invisibleConn = RunService.Heartbeat:Connect(function()
			if IsInvisible and hrp and hum then
				local OriginalCFrame = hrp.CFrame
				local OriginalCameraOffset = hum.CameraOffset

				local DownCFrame = OriginalCFrame * CFrame.new(0, -200000, 0)
				hrp.CFrame = DownCFrame
				hum.CameraOffset = DownCFrame:ToObjectSpace(CFrame.new(OriginalCFrame.Position)).Position

				RunService.RenderStepped:Wait()

				hrp.CFrame = OriginalCFrame
				hum.CameraOffset = OriginalCameraOffset
			end
		end)
	else
		if invisibleConn then invisibleConn:Disconnect() invisibleConn = nil end
	end
end)

--------------------------------------------------
-- LÓGICA ESP GUN Y COINS
--------------------------------------------------

local ESP_Gun_Enabled = false
local ESP_Coin_Enabled = false
local gunConn = nil
local coinConn = nil

local function clearGunESP()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v.Name == "Gun_ESP_Billboard" or v.Name == "Gun_ESP_Sphere" or v.Name == "Gun_ESP_Highlight" then
			v:Destroy()
		end
	end
end

local function updateGunESP()
	if not ESP_Gun_Enabled then
		clearGunESP()
		return
	end

	local gunDrop = workspace:FindFirstChild("GunDrop") or workspace:FindFirstChild("Gun")
	if gunDrop and gunDrop:IsA("BasePart") then
		local hl = gunDrop:FindFirstChild("Gun_ESP_Highlight")
		if not hl then
			hl = Instance.new("Highlight")
			hl.Name = "Gun_ESP_Highlight"
			hl.FillColor = Color3.fromRGB(255, 215, 0)
			hl.OutlineColor = Color3.fromRGB(255, 255, 255)
			hl.FillTransparency = 0.3
			hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			hl.Parent = gunDrop
		end

		local bb = gunDrop:FindFirstChild("Gun_ESP_Billboard")
		if not bb then
			bb = Instance.new("BillboardGui")
			bb.Name = "Gun_ESP_Billboard"
			bb.Size = UDim2.fromOffset(60, 60)
			bb.StudsOffset = Vector3.new(0, 3, 0)
			bb.AlwaysOnTop = true
			bb.Parent = gunDrop

			local arrowLabel = Instance.new("TextLabel")
			arrowLabel.Name = "Arrow"
			arrowLabel.Size = UDim2.new(1, 0, 0, 30)
			arrowLabel.BackgroundTransparency = 1
			arrowLabel.Text = "▼"
			arrowLabel.Font = Enum.Font.GothamBold
			arrowLabel.TextSize = 22
			arrowLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
			arrowLabel.TextStrokeTransparency = 0
			arrowLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			arrowLabel.Parent = bb

			local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
			TweenService:Create(arrowLabel, tweenInfo, {Position = UDim2.fromOffset(0, 10)}):Play()
		end

		local dot = gunDrop:FindFirstChild("Gun_ESP_Sphere")
		if not dot then
			dot = Instance.new("BillboardGui")
			dot.Name = "Gun_ESP_Sphere"
			dot.Size = UDim2.fromOffset(20, 20)
			dot.StudsOffset = Vector3.new(0, 0, 0)
			dot.AlwaysOnTop = true
			dot.Parent = gunDrop

			local dotLabel = Instance.new("TextLabel")
			dotLabel.Size = UDim2.new(1, 0, 1, 0)
			dotLabel.BackgroundTransparency = 1
			dotLabel.Text = "●"
			dotLabel.Font = Enum.Font.GothamBold
			dotLabel.TextSize = 16
			dotLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
			dotLabel.TextStrokeTransparency = 0
			dotLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
			dotLabel.Parent = dot
		end
	else
		clearGunESP()
	end
end

local function clearCoinESP()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v.Name == "Coin_ESP_Highlight" or v.Name == "Coin_ESP_Billboard" then
			v:Destroy()
		end
	end
end

local function updateCoinESP()
	if not ESP_Coin_Enabled then
		clearCoinESP()
		return
	end

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj.Name == "CoinContainer" or obj.Name == "Coin" or obj.Name == "CoinServer" then
			local coins = obj:IsA("BasePart") and {obj} or obj:GetChildren()
			for _, coin in ipairs(coins) do
				if coin:IsA("BasePart") and coin.Transparency < 1 then
					if not coin:FindFirstChild("Coin_ESP_Highlight") then
						local hl = Instance.new("Highlight")
						hl.Name = "Coin_ESP_Highlight"
						hl.FillColor = Color3.fromRGB(255, 223, 0)
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.FillTransparency = 0.4
						hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						hl.Parent = coin

						local bb = Instance.new("BillboardGui")
						bb.Name = "Coin_ESP_Billboard"
						bb.Size = UDim2.fromOffset(40, 20)
						bb.StudsOffset = Vector3.new(0, 1.5, 0)
						bb.AlwaysOnTop = true
						bb.Parent = coin

						local lbl = Instance.new("TextLabel")
						lbl.Size = UDim2.new(1, 0, 1, 0)
						lbl.BackgroundTransparency = 1
						lbl.Text = "🪙"
						lbl.TextSize = 12
						lbl.Parent = bb
					end
				end
			end
		end
	end
end

addToggleRow("ESP Gun Caída", 173, function(val)
	ESP_Gun_Enabled = val
	if val then
		gunConn = RunService.RenderStepped:Connect(updateGunESP)
	else
		if gunConn then gunConn:Disconnect() gunConn = nil end
		clearGunESP()
	end
end)

addToggleRow("ESP Monedas", 220, function(val)
	ESP_Coin_Enabled = val
	if val then
		coinConn = RunService.RenderStepped:Connect(updateCoinESP)
	else
		if coinConn then coinConn:Disconnect() coinConn = nil end
		clearCoinESP()
	end
end)
