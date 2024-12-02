--// Serviços \\--
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

--// Funções Auxiliares \\--
local function enviarNotificacao(titulo, texto, duracao)
    StarterGui:SetCore("SendNotification", {
        Title = titulo,
        Text = texto,
        Duration = duracao
    })
end

local function copiarParaAreaDeTransferencia(texto)
    if setclipboard then
        setclipboard(texto)
        enviarNotificacao("Copiado!", "Texto copiado para a área de transferência.", 3)
    else
        enviarNotificacao("Erro", "Seu executor não suporta copiar texto.", 3)
    end
end

local function teleportarParaLugar(placeId)
    TeleportService:Teleport(placeId, Players.LocalPlayer)
end

local function obterInformacoesDoJogo()
    local placeId = game.PlaceId
    local universeId = game.GameId
    local success, relatedGamesData = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(placeId)))
    end)

    return {
        placeId = placeId,
        universeId = universeId,
        relatedGames = success and relatedGamesData or nil
    }
end

--// Criar Interface Gráfica Avançada \\--
local function criarPainel()
    -- Tela principal
    local screenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    screenGui.Name = "AdvancedGamePanel"
    screenGui.ResetOnSpawn = false

    -- Frame principal
    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 600, 0, 400)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0

    -- Adicionar gradiente dinâmico
    local gradient = Instance.new("UIGradient", mainFrame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
    })
    gradient.Rotation = 45

    -- Adicionar sombra
    local shadow = Instance.new("ImageLabel", mainFrame)
    shadow.Size = UDim2.new(1, 50, 1, 50)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = 0

    -- Título com animação
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Text = "Painel Avançado do Jogo"
    titleLabel.Size = UDim2.new(1, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.TextTransparency = 1

    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(1, Enum.EasingStyle.Sine), {TextTransparency = 0})
    titleTween:Play()

    -- Adicionar botão de fechar com animação
    local closeButton = Instance.new("TextButton", mainFrame)
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.AnchorPoint = Vector2.new(0.5, 0.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.ZIndex = 2
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    local buttonCorner = Instance.new("UICorner", closeButton)
    buttonCorner.CornerRadius = UDim.new(0, 5)

    -- Informações dinâmicas
    local infoContainer = Instance.new("ScrollingFrame", mainFrame)
    infoContainer.Size = UDim2.new(1, -20, 0.8, 0)
    infoContainer.Position = UDim2.new(0, 10, 0.1, 10)
    infoContainer.BackgroundTransparency = 1
    infoContainer.CanvasSize = UDim2.new(0, 0, 5, 0)

    -- Preenchendo informações do jogo e jogadores
    local info = obterInformacoesDoJogo()
    local yPos = 0
    local function criarLinha(texto, placeId)
        local lineFrame = Instance.new("Frame", infoContainer)
        lineFrame.Size = UDim2.new(1, 0, 0, 40)
        lineFrame.Position = UDim2.new(0, 0, 0, yPos)
        lineFrame.BackgroundTransparency = 1

        local label = Instance.new("TextLabel", lineFrame)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = texto
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left

        local copyButton = Instance.new("TextButton", lineFrame)
        copyButton.Size = UDim2.new(0.15, -5, 0.8, 0)
        copyButton.Position = UDim2.new(0.7, 5, 0.1, 0)
        copyButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        copyButton.Text = "Copiar"
        copyButton.Font = Enum.Font.GothamBold
        copyButton.TextSize = 14
        copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        local tpButton = Instance.new("TextButton", lineFrame)
        tpButton.Size = UDim2.new(0.15, -5, 0.8, 0)
        tpButton.Position = UDim2.new(0.85, 5, 0.1, 0)
        tpButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
        tpButton.Text = "TP"
        tpButton.Font = Enum.Font.GothamBold
        tpButton.TextSize = 14
        tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)

        copyButton.MouseButton1Click:Connect(function()
            copiarParaAreaDeTransferencia(tostring(placeId))
        end)

        tpButton.MouseButton1Click:Connect(function()
            teleportarParaLugar(placeId)
        end)

        yPos = yPos + 50
    end

    -- Preenchendo IDs
    criarLinha("ID do Lugar: " .. info.placeId, info.placeId)
    criarLinha("ID do Universo: " .. info.universeId, info.universeId)

    if info.relatedGames then
        for _, game in ipairs(info.relatedGames) do
            criarLinha("Jogo: " .. game.name, game.placeId)
        end
    end
end

-- Inicia a criação do painel
criarPainel()
