local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local forcaArremesso = 1200
local alcance = 50 
local objetoAtual = nil
local attachmentPlayer, attachmentObj, rope

-- Interface Resistente
local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "MagnetoHub"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 120, 0, 120)
btn.Position = UDim2.new(0.7, 0, 0.4, 0)
btn.Text = "PESCAR"
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 150)
btn.TextColor3 = Color3.new(1, 1, 1)

-- Medidor de SPS
local medidor = Instance.new("TextLabel", btn)
medidor.Size = UDim2.new(1, 0, 0, 30)
medidor.Position = UDim2.new(0, 0, 1, 5)
medidor.Text = "0 SPS"
medidor.TextColor3 = Color3.new(0, 1, 0)
medidor.BackgroundTransparency = 1

local function limparFisica()
    if rope then rope:Destroy() end
    if attachmentPlayer then attachmentPlayer:Destroy() end
    if attachmentObj then attachmentObj:Destroy() end
    if objetoAtual then 
        objetoAtual.CanCollide = true 
        objetoAtual = nil
    end
end

RunService.RenderStepped:Connect(function()
    if objetoAtual and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        -- Mantém a peça levitando na frente
        objetoAtual.AssemblyLinearVelocity = ((root.CFrame * CFrame.new(0, 2, -12)).Position - objetoAtual.Position) * 30
        
        local vel = math.floor(objetoAtual.AssemblyLinearVelocity.Magnitude)
        medidor.Text = vel .. " SPS"
    end
end)

btn.MouseButton1Click:Connect(function()
    if not objetoAtual then
        local alvo = nil
        local menorDist = alcance
        
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
            objetoAtual.CanCollide = false
            
            -- Cria a conexão física (o servidor não consegue ignorar isso)
            attachmentPlayer = Instance.new("Attachment", player.Character.HumanoidRootPart)
            attachmentObj = Instance.new("Attachment",
