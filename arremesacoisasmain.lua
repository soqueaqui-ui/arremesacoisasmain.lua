local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local forcaArremesso = 1000 -- Aumentado para arremessos épicos
local alcance = 40
local objetoAtual = nil
local bp, bg -- Variáveis para as forças

-- Interface que não reseta
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "TelecineseV4"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 130, 0, 130)
btn.Position = UDim2.new(0.75, 0, 0.4, 0)
btn.Text = "PUXAR"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.BlackOpsOne -- Estilo mais "hub"

-- Medidor de Velocidade (SPS)
local medidor = Instance.new("TextLabel", btn)
medidor.Size = UDim2.new(1, 0, 0, 30)
medidor.Position = UDim2.new(0, 0, 1, 10)
medidor.Text = "0 SPS"
medidor.TextColor3 = Color3.new(1, 1, 0)
medidor.BackgroundTransparency = 1

-- Loop de Movimentação
RunService.RenderStepped:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        local alvoPos = (root.CFrame * CFrame.new(0, 3, -12)).Position -- 12 studs na frente
        
        -- Atualiza a posição e rotação da força
        if bp and bg then
            bp.Position = alvoPos
            bg.CFrame = root.CFrame
        end
        
        -- Medidor de Velocidade
        local vel = math.floor(objetoAtual.AssemblyLinearVelocity.Magnitude)
        medidor.Text = vel .. " SPS"
    else
        medidor.Text = "0 SPS"
    end
end)

btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        local alvo = nil
        local menorDist = alcance
        
        -- Busca a peça mais próxima que NÃO está ancorada
        for _, p in pairs(workspace:GetDescendants()) do
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
            objetoAtual.CanCollide = false -- Evita bater em você
            
            -- Cria a força de posição
            bp = Instance.new("BodyPosition", objetoAtual)
            bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.P = 15000 -- Suavidade do puxão
            
            -- Cria a força de rotação (trava o bloco)
            bg = Instance.new("BodyGyro", objetoAtual)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            
            btn.Text = "LANÇAR!"
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    else
        -- LANÇAR
        if bp then bp:Destroy() end
        if bg then bg:Destroy() end
        
        local direcao = player.Character.HumanoidRootPart.CFrame.LookVector
        objetoAtual.CanCollide = true
        objetoAtual.AssemblyLinearVelocity = (direcao * forcaArremesso) + Vector3.new(0, 30, 0)
        
        objetoAtual = nil
        btn.Text = "PUXAR"
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
end)
