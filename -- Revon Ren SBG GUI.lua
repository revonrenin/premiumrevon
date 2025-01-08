-- RevonRenin Hub
local Player = game.Players.LocalPlayer
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- Kullanıcıya giriş bildirimi
OrionLib:MakeNotification({
    Name = "Logged in!",
    Content = "You are logged in as " .. Player.Name,
    Image = "rbxassetid://4483345998",
    Time = 5
})

_G.Key = "revonitsbestlol"  -- Burada keyi belirliyoruz
_G.KeyInput = ""  -- Kullanıcının girdiği keyi saklamak için

-- RevonRen Hub'ı açan fonksiyon
function MakeScriptHub()
    -- RevonRen Hub GUI'si oluşturuluyor
    local scriptHubWindow = OrionLib:MakeWindow({
        Name = "RevonRen Hub",
        HidePremium = false,
        SaveConfig = true,
        IntroEnabled = false
    })

    local PlayerTab = scriptHubWindow:MakeTab({
        Name = "Player Settings",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    -- Walkspeed Slider
    PlayerTab:AddSlider({
        Name = "Walkspeed",
        Min = 16,
        Max = 120,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Speed",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })

    -- Jump Height Slider
    PlayerTab:AddSlider({
        Name = "Jump Height",
        Min = 16,
        Max = 120,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "Height",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    })

    -- Wall Visibility Toggle
    PlayerTab:AddToggle({
        Name = "Wall",
        Default = false,
        Callback = function(Value)
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    -- Highlight effect
                    if Value then
                        if not player.Character:FindFirstChild("Highlight") then
                            local highlight = Instance.new("Highlight")
                            highlight.Parent = player.Character
                            highlight.FillColor = Color3.fromRGB(0, 0, 255) -- Blue color
                            highlight.FillTransparency = 0.5 -- Semi-transparent
                            highlight.OutlineTransparency = 1 -- No outline
                        end
                    else
                        local highlight = player.Character:FindFirstChild("Highlight")
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                end
            end
        end
    })

    -- Aimbot Toggle
    PlayerTab:AddToggle({
        Name = "Aimbot",
        Default = false,
        Callback = function(Value)
            local aimbotEnabled = Value
            local UserInputService = game:GetService("UserInputService")
            local camera = workspace.CurrentCamera
            local localPlayer = game.Players.LocalPlayer

            local targetPlayer = nil

            local function getClosestPlayer()
                local closestPlayer = nil
                local shortestDistance = math.huge

                for _, player in ipairs(game.Players:GetPlayers()) do
                    if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local targetPos = player.Character.HumanoidRootPart.Position
                        local screenPos, onScreen = camera:WorldToScreenPoint(targetPos)
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local distance = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                            if distance < shortestDistance then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end

                return closestPlayer
            end

            UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton1 then -- Sol tık başladı
                    targetPlayer = getClosestPlayer()
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then -- Sol tık bırakıldı
                    targetPlayer = nil
                end
            end)

            game:GetService("RunService").RenderStepped:Connect(function()
                if aimbotEnabled and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    camera.CFrame = CFrame.new(camera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
                end
            end)
        end
    })

    -- FE Animations Button
    PlayerTab:AddButton({
        Name = "FE Animations",
        Callback = function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Energize-10408"))()  -- FE Animations scriptini yükler
        end
    })
end

-- Key Sistemi GUI'si
local Window = OrionLib:MakeWindow({
    Name = "Key System",
    HidePremium = false,
    SaveConfig = true,
    IntroEnabled = false
})

local Tab = Window:MakeTab({
    Name = "Revon Hub Key System",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab:AddTextbox({
    Name = "Enter Key",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
        _G.KeyInput = Value
    end
})

Tab:AddButton({
    Name = "Check Key",
    Callback = function()
        if _G.KeyInput == _G.Key then
            OrionLib:MakeNotification({
                Name = "Success",
                Content = "Key is correct! Access granted.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            MakeScriptHub()  -- Key doğrulandıktan sonra RevonRen Hub açılır.
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Key is incorrect! Access denied.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end
})

-- Discord Davet Linki
Tab:AddButton({
    Name = "Join for Key",  -- Buton adı "Join for Key" olarak değiştirildi
    Callback = function()
        OrionLib:MakeNotification({
            Name = "Join the Server",
            Content = "To get the key, join the Discord server!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
        -- Discord davet linkini açma
        setclipboard("https://discord.gg/V2eERrCh2x")  -- Linki panoya kopyalar
    end
})
