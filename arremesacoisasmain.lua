local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Configurações
local forcaArremesso = 600 -- Aumentei para ser mais potente
local alcance = 25 
local objetoAtual = nil

-- 1. INTERFACE QUE NÃO SOME AO MORRER
-- O segredo é o ResetOnSpawn = false
local sg = Instance.new("ScreenGui")
sg.Name = "ArremessaHUB"
sg.ResetOnSpawn = false -- ISSO impede que o menu suma quando você morre
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true -- Para você mover o botão no mobile

local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(0.9, 0, 0.8, 0)
btn.Position = UDim2.new(0.05, 0, 0.1, 0)
btn.Text = "PEGAR OBJETO"
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.TextScaled = true

-- 2. LÓGICA DE FÍSICA APRIMORADA
RunService.Stepped:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        -- Mantém o objeto 15 studs na frente e um pouco acima
        local alvoPos = (root.CFrame * CFrame.new(0, 5, -15)).Position 
        
        -- Move a peça suavemente
        objetoAtual.AssemblyLinearVelocity = (alvoPos - objetoAtual.Position) * 15
        objetoAtual.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- Anti-Arremesso Próprio: Desativa colisão enquanto segura
        objetoAtual.CanCollide = false
    end
end)

btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        local menorDist = alcance
        local parteEncontrada = nil
        
        -- Busca partes próximas (NDS tem muitas partes desancoradas)
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
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    else
        -- LANÇAMENTO
        local direcao = player.Character.HumanoidRootPart.CFrame.LookVector
        objetoAtual.CanCollide = true -- Ativa colisão para bater nos outros
        objetoAtual.AssemblyLinearVelocity = (direcao * forcaArremesso) + Vector3.new(0, 40, 0)
        
        objetoAtual = nil
        btn.Text = "PEGAR OBJETO"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    end
end)
