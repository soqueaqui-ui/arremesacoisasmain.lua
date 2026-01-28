local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Configurações
local forcaArremesso = 800
local alcance = 30
local objetoAtual = nil

-- Interface Resistente
local sg = Instance.new("ScreenGui")
sg.Name = "TelecineseHub"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 150)
btn.Position = UDim2.new(0.7, 0, 0.4, 0) -- Posição boa para o dedão no mobile
btn.Text = "PUXAR"
btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Shape = Enum.FrameShape.Circle -- Deixa o botão redondo se o seu executor suportar

-- Lógica de Flutuação (Ímã Travado)
RunService.RenderStepped:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        -- Posição alvo: 10 studs na frente e 2 acima do peito
        local alvoPos = (root.CFrame * CFrame.new(0, 2, -10)).Position
        
        -- Congela a física natural e aplica a nossa
        objetoAtual.CanCollide = false
        objetoAtual.AssemblyLinearVelocity = (alvoPos - objetoAtual.Position) * 20
        objetoAtual.AssemblyAngularVelocity = Vector3.new(0, 0, 0) -- Impede de girar
    end
end)

btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        -- BUSCAR OBJETO
        local menorDist = alcance
        local alvo = nil
        
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
            btn.Text = "LANÇAR!"
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end
    else
        -- LANÇAR OBJETO
        local direcao = player.Character.HumanoidRootPart.CFrame.LookVector
        objetoAtual.CanCollide = true
        objetoAtual.AssemblyLinearVelocity = (direcao * forcaArremesso)
        
        objetoAtual = nil
        btn.Text = "PUXAR"
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)
