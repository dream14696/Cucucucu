local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Player = Players.LocalPlayer

local ParentTarget = Player:WaitForChild("PlayerGui")
pcall(function()
	if gethui then
		ParentTarget = gethui()
	elseif CoreGui then
		ParentTarget = CoreGui
	end
end)

local MainGUI = ParentTarget:FindFirstChild("MM2_HUB_MASTER")

if not MainGUI then
	MainGUI = Instance.new("ScreenGui")
	MainGUI.Name = "MM2_HUB_POPUP_CONTAINER"
	MainGUI.ResetOnSpawn = false
	MainGUI.IgnoreGuiInset = true
	MainGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	MainGUI.DisplayOrder = 2147483647
	MainGUI.Parent = ParentTarget
end

local OldPopup = MainGUI:FindFirstChild("UpdatePopup")
if OldPopup then OldPopup:Destroy() end

local Popup = Instance.new("Frame")
Popup.Name = "UpdatePopup"
Popup.Size = UDim2.fromOffset(0, 0)
Popup.Position = UDim2.new(0.5, 0, 0.5, 0)
Popup.AnchorPoint = Vector2.new(0.5, 0.5)
Popup.BackgroundColor3 = Color3.fromRGB(6, 10, 18)
Popup.BackgroundTransparency = 0.05
Popup.BorderSizePixel = 0
Popup.Active = true
Popup.ZIndex = 2000
Popup.Parent = MainGUI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = Popup

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2
Stroke.Parent = Popup

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 35)
Title.Position = UDim2.fromOffset(15, 12)
Title.BackgroundTransparency = 1
Title.Text = "🔥 nuevas actualizaciones 🔥"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextWrapped = true
Title.ZIndex = 2001
Title.Parent = Popup

local Content = Instance.new("TextLabel")
Content.Size = UDim2.new(1, -30, 0, 230)
Content.Position = UDim2.fromOffset(15, 55)
Content.BackgroundTransparency = 1
Content.Text = "• Función de fly\n• Invisible\n• ESP de gun\n• ESP de monedas\n\nEn unas horas estará todo listo.\n\nGracias por sus sugerencias, ayudan mucho a que nuestro guión crezca."
Content.Font = Enum.Font.Gotham
Content.TextSize = 13
Content.TextColor3 = Color3.fromRGB(220, 235, 255)
Content.TextXAlignment = Enum.TextXAlignment.Left
Content.TextYAlignment = Enum.TextYAlignment.Top
Content.TextWrapped = true
Content.ZIndex = 2001
Content.Parent = Popup

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(42, 42)
CloseBtn.Position = UDim2.new(1, -52, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(15, 22, 35)
CloseBtn.BackgroundTransparency = 0.2
CloseBtn.Text = "10"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 15
CloseBtn.TextColor3 = Color3.fromRGB(150, 165, 185)
CloseBtn.Active = false
CloseBtn.ZIndex = 2002
CloseBtn.Parent = Popup

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 10)
BtnCorner.Parent = CloseBtn

local BtnStroke = Instance.new("UIStroke")
BtnStroke.Color = Color3.fromRGB(0, 125, 255)
BtnStroke.Thickness = 1
BtnStroke.Parent = CloseBtn

TweenService:Create(Popup, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.fromOffset(340, 320)
}):Play()

task.spawn(function()
	for i = 10, 1, -1 do
		CloseBtn.Text = tostring(i)
		task.wait(1)
	end
	
	CloseBtn.Text = "\u{2715}"
	CloseBtn.TextSize = 24
	CloseBtn.TextColor3 = Color3.fromRGB(255, 70, 70)
	CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 15, 20)
	CloseBtn.Active = true
	
	BtnStroke.Color = Color3.fromRGB(255, 50, 50)
end)

CloseBtn.MouseButton1Click:Connect(function()
	if not CloseBtn.Active then return end
	
	local closeTween = TweenService:Create(Popup, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.fromOffset(0, 0)
	})
	closeTween:Play()
	closeTween.Completed:Connect(function()
		Popup:Destroy()
		if MainGUI.Name == "MM2_HUB_POPUP_CONTAINER" then
			MainGUI:Destroy()
		end
	end)
end)
