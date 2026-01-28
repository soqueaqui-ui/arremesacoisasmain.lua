local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local forcaArremesso = 800
local alcance = 35 
local objetoAtual = nil

-- Criando a UI que não some
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "TelecineseFinal"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 120, 0, 120)
btn.Position = UDim2.new(0.7, 0, 0.4, 0)
btn.Text = "BUSCAR"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1, 1, 1)

-- Função para forçar a posse do objeto (Network Ownership)
local function tomarPosse(part)
    if part:IsA("BasePart") then
        part.CanCollide = false
        -- Tenta forçar a física para você
        task.spawn(function()
            while objetoAtual == part do
                if part:FindFirstChildOfClass("BodyPosition") == nil then
                    part.Velocity = Vector3.new(0, 0.1, 0) -- Pequena força para acordar a física
                end
                task.wait(0.1)
            end
        end)
    end
end

RunService.Heartbeat:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local alvoPos = (root.CFrame * CFrame.new(0, 3, -12)).Position
        
        -- Move o objeto
        objetoAtual.AssemblyLinearVelocity = (alvoPos - objetoAtual.Position) * 25
        objetoAtual.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        local menorDist = alcance
        local alvo = nil
        
        for _, p in pairs(workspace:GetDescendants()) do
            -- NDS: Só pega partes que não estão presas (Anchored = false)
            if p:IsA("BasePart") and not p.Anchored and p.Parent ~= player.Character then
                local d = (p.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if d < menorDist then
                    menorDist = d
                    alvo = p
                end
            end
        end
        
        if alvo then
            objetoAtual = alvo
            tomarPosse(objetoAtual)
            btn.Text = "LANÇAR!"
            btn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    else
        -- Arremessa
        local direcao = player.Character.HumanoidRootPart.CFrame.LookVector
        objetoAtual.CanCollide = true
        objetoAtual.AssemblyLinearVelocity = (direcao * forcaArremesso) + Vector3.new(0, 20, 0)
        
        objetoAtual = nil
        btn.Text = "BUSCAR"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)
