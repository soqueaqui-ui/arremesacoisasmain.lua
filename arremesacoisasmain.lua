--[[
    PROJETO: arremesacoisas
    ARQUIVO: main.lua
    FUNCIONALIDADE: Grab & Throw com Medidor de Velocidade (SPS)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Configurações de Força
local forcaArremesso = 400 -- Aumente para jogar mais longe
local alcance = 25 -- Distância máxima para puxar um objeto
local objetoAtual = nil

-- Criando a Interface (GUI)
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "ArremessaHUB"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Permite mover o menu na tela

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "ARREMESSA COISAS"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0, 60)
btn.Position = UDim2.new(0.05, 0, 0.25, 0)
btn.Text = "PEGAR OBJETO"
btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true

local medidor = Instance.new("TextLabel", frame)
medidor.Size = UDim2.new(1, 0, 0, 40)
medidor.Position = UDim2.new(0, 0, 0.7, 0)
medidor.Text = "Velocidade: 0 SPS"
medidor.TextColor3 = Color3.fromRGB(255, 255, 0)
medidor.BackgroundTransparency = 1
medidor.TextScaled = true

-- Lógica do Ímã e Velocímetro
RunService.Heartbeat:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        -- Posição 12 studs na frente do seu rosto
        local alvoPos = (root.CFrame * CFrame.new(0, 2, -12)).Position
        
        -- Aplica a velocidade para o objeto te seguir
        objetoAtual.AssemblyLinearVelocity = (alvoPos - objetoAtual.Position) * 25
        
        -- Medidor SPS
        local vel = math.floor(objetoAtual.AssemblyLinearVelocity.Magnitude)
        medidor.Text = "Velocidade: " .. vel .. " SPS"
    end
end)

-- Botão de Ação (Mobile)
btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        local menorDist = alcance
        local parteEncontrada = nil
        
        -- Busca partes próximas que não estão ancoradas (comuns em desastres)
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p.Anchored and p.Parent ~= player.Character then
                local d = (p.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < menorDist then
                    menorDist = d
                    parteEncontrada = p
                end
            end
        end
        
        if parteEncontrada then
            objetoAtual = parteEncontrada
            btn.Text = "LANÇAR!"
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
        end
    else
        -- Arremessa na direção que você está olhando
        local direcao = player.Character.HumanoidRootPart.CFrame.LookVector
        objetoAtual.AssemblyLinearVelocity = (direcao * forcaArremesso) + Vector3.new(0, 30, 0)
        
        objetoAtual = nil
        btn.Text = "PEGAR OBJETO"
        btn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
        medidor.Text = "Velocidade: 0 SPS"
    end
end)
