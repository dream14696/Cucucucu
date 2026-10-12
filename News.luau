local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local message = "MM2 HUB Ultimate Successfully executed by dremmser"

task.spawn(function()
	task.wait(0.5) -- Pausa breve para asegurar que el chat esté cargado
	
	-- Compatibilidad con TextChatService (Nuevo sistema de chat)
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		local generalChannel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
		if generalChannel then
			generalChannel:SendAsync(message)
		end
	else
		-- Compatibilidad con DefaultChatSystem (Sistema clásico)
		local defaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		local sayMessage = defaultChat and defaultChat:FindFirstChild("SayMessageRequest")
		if sayMessage then
			sayMessage:FireServer(message, "All")
		end
	end
end)
