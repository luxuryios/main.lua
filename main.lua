-- ================================================
-- SCRIPT: LUXURY IOS - AUTO FARM TRÁI XỊN
-- Tác giả: Luxury IOS
-- Phiên bản: 5.0
-- Mô tả: Đổi server liên tục đến khi gặp trái xịn
-- ================================================

-- ============ DỊCH VỤ ============
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

-- ============ DANH SÁCH TRÁI XỊN ============
local TRAI_XIN = {
    "Dragon", "Leopard", "Kitsune", "Venom", "Dough",
    "Spirit", "Control", "Shadow", "Buddha", "Portal",
    "Rumble", "Blizzard", "Pain", "Phoenix", "Magma",
    "Gravity", "Quake", "Rubber", "Dark", "Light"
}

-- ============ CẤU HÌNH ============
local CAUHINH = {
    TuDongDoiServer = true,
    ChiNhatTraiXin = true,
    ThoiGianQuet = 3,       -- giây quét trước khi đổi server
    ThoiGianChoNhat = 5,    -- giây chờ sau khi nhặt
    ThongBaoKhiCoTrai = true,
    SoLanDoiToiDa = 0,      -- 0 = vô hạn
}

-- ============ GIAO DIỆN ============
local GiaoDien = Instance.new("ScreenGui")
GiaoDien.Name = "LuxuryIOS_AutoFarmFruit"
GiaoDien.ResetOnSpawn = false
GiaoDien.Parent = game:GetService("CoreGui")

local KhungChinh = Instance.new("Frame")
KhungChinh.Size = UDim2.new(0, 440, 0, 520)
KhungChinh.Position = UDim2.new(0.5, -220, 0.5, -260)
KhungChinh.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
KhungChinh.BorderSizePixel = 0
KhungChinh.Active = true
KhungChinh.Draggable = true
KhungChinh.Parent = GiaoDien

local BoGoc = Instance.new("UICorner")
BoGoc.CornerRadius = UDim.new(0, 14)
BoGoc.Parent = KhungChinh

local VienVang = Instance.new("UIStroke")
VienVang.Color = Color3.fromRGB(255, 215, 0)
VienVang.Thickness = 2
VienVang.Parent = KhungChinh

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 60)
Logo.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Logo.Text = "✦ LUXURY IOS ✦\nAUTO FARM TRÁI XỊN"
Logo.TextColor3 = Color3.fromRGB(255, 215, 0)
Logo.Font = Enum.Font.GothamBlack
Logo.TextSize = 18
Logo.Parent = KhungChinh

local BoGocLogo = Instance.new("UICorner")
BoGocLogo.CornerRadius = UDim.new(0, 14)
BoGocLogo.Parent = Logo

local TrangThai = Instance.new("TextLabel")
TrangThai.Size = UDim2.new(1, -20, 0, 25)
TrangThai.Position = UDim2.new(0, 10, 0, 65)
TrangThai.BackgroundTransparency = 1
TrangThai.Text = "Trạng thái: Sẵn sàng"
TrangThai.TextColor3 = Color3.fromRGB(0, 255, 100)
TrangThai.Font = Enum.Font.Gotham
TrangThai.TextSize = 12
TrangThai.TextXAlignment = Enum.TextXAlignment.Left
TrangThai.Parent = KhungChinh

local DemServer = Instance.new("TextLabel")
DemServer.Size = UDim2.new(1, -20, 0, 20)
DemServer.Position = UDim2.new(0, 10, 0, 88)
DemServer.BackgroundTransparency = 1
DemServer.Text = "Số lần đổi server: 0"
DemServer.TextColor3 = Color3.fromRGB(200, 200, 200)
DemServer.Font = Enum.Font.Gotham
DemServer.TextSize = 11
DemServer.TextXAlignment = Enum.TextXAlignment.Left
DemServer.Parent = KhungChinh

local KhungCuon = Instance.new("ScrollingFrame")
KhungCuon.Size = UDim2.new(1, -20, 1, -130)
KhungCuon.Position = UDim2.new(0, 10, 0, 115)
KhungCuon.BackgroundTransparency = 1
KhungCuon.CanvasSize = UDim2.new(0, 0, 0, 0)
KhungCuon.AutomaticCanvasSize = Enum.AutomaticSize.Y
KhungCuon.ScrollBarThickness = 4
KhungCuon.Parent = KhungChinh

local BoCuc = Instance.new("UIListLayout")
BoCuc.Padding = UDim.new(0, 6)
BoCuc.Parent = KhungCuon

local function TaoNutBatTat(ten, macDinh, hamGoi)
    local Nut = Instance.new("TextButton")
    Nut.Size = UDim2.new(1, 0, 0, 36)
    Nut.BackgroundColor3 = macDinh and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(45, 45, 55)
    Nut.Text = ten .. ": " .. (macDinh and "BẬT" or "TẮT")
    Nut.TextColor3 = Color3.fromRGB(255, 255, 255)
    Nut.Font = Enum.Font.GothamBold
    Nut.TextSize = 13
    Nut.Parent = KhungCuon

    local goc = Instance.new("UICorner")
    goc.CornerRadius = UDim.new(0, 6)
    goc.Parent = Nut

    local trangThai = macDinh
    Nut.MouseButton1Click:Connect(function()
        trangThai = not trangThai
        Nut.BackgroundColor3 = trangThai and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(45, 45, 55)
        Nut.Text = ten .. ": " .. (trangThai and "BẬT" or "TẮT")
        hamGoi(trangThai)
    end)
    return Nut
end

local function TaoTieuDe(ten)
    local TieuDe = Instance.new("TextLabel")
    TieuDe.Size = UDim2.new(1, 0, 0, 28)
    TieuDe.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
    TieuDe.Text = "▶ " .. ten
    TieuDe.TextColor3 = Color3.fromRGB(255, 215, 0)
    TieuDe.Font = Enum.Font.GothamBold
    TieuDe.TextSize = 13
    TieuDe.Parent = KhungCuon
    return TieuDe
end

-- ============ KIỂM TRA TRÁI XỊN ============
local function LaTraiXin(tenTrai)
    for _, ten in pairs(TRAI_XIN) do
        if tenTrai:lower():find(ten:lower()) then
            return true, ten
        end
    end
    return false, nil
end

-- ============ LẤY DANH SÁCH TRÁI ============
local function LayDanhSachTrai()
    local danhSach = {}
    local fruitFolder = Workspace:FindFirstChild("Fruits") or Workspace:FindFirstChild("Fruit")
    if fruitFolder then
        for _, trai in pairs(fruitFolder:GetChildren()) do
            if trai:IsA("Tool") or trai:IsA("Model") or trai:IsA("BasePart") then
                table.insert(danhSach, trai)
            end
        end
    end
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name:find("Fruit") and (obj:IsA("Tool") or obj:IsA("Model") or obj:IsA("BasePart")) then
            table.insert(danhSach, obj)
        end
    end
    return danhSach
end

-- ============ NHẶT TRÁI ============
local function NhatTrai(trai)
    if not LocalPlayer.Character then return false end
    local gocNhanVat = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not gocNhanVat then return false end

    local handle
    if trai:IsA("BasePart") then
        handle = trai
    elseif trai:FindFirstChild("Handle") then
        handle = trai.Handle
    else
        return false
    end

    gocNhanVat.CFrame = CFrame.new(handle.Position + Vector3.new(0, 3, 0))
    task.wait(0.3)

    pcall(function()
        firetouchinterest(gocNhanVat, handle, 0)
        task.wait(0.2)
        firetouchinterest(gocNhanVat, handle, 1)
    end)

    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("BuyFruit", trai.Name)
    end)

    pcall(function()
        local prompt = trai:FindFirstChildOfClass("ProximityPrompt")
        if prompt then
            prompt:InputHoldBegin()
            task.wait(0.3)
            prompt:InputHoldEnd()
        end
    end)

    return true
end

-- ============ THÔNG BÁO ============
local function ThongBao(tieuDe, noiDung, thoiGian)
    StarterGui:SetCore("SendNotification", {
        Title = tieuDe,
        Text = noiDung,
        Duration = thoiGian or 5
    })
end

-- ============ ĐỔI SERVER ============
local soLanDoi = 0

local function DoiServer()
    if not CAUHINH.TuDongDoiServer then return end
    if CAUHINH.SoLanDoiToiDa > 0 and soLanDoi >= CAUHINH.SoLanDoiToiDa then
        TrangThai.Text = "Trạng thái: Đã đạt giới hạn đổi server"
        return
    end

    soLanDoi = soLanDoi + 1
    DemServer.Text = "Số lần đổi server: " .. soLanDoi
    TrangThai.Text = "Trạng thái: Đang đổi server..."
    TrangThai.TextColor3 = Color3.fromRGB(255, 200, 0)

    local servers = {}
    pcall(function()
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
        local response = HttpService:JSONDecode(game:HttpGet(url))
        if response and response.data then
            for _, server in pairs(response.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
    end)

    if #servers > 0 then
        local serverMoi = servers[math.random(1, #servers)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, serverMoi, LocalPlayer)
    else
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
end

-- ============ VÒNG LẶP CHÍNH ============
local daNhat = {}

local function VongLapChinh()
    -- Chờ game load xong
    task.wait(5)

    while CAUHINH.TuDongDoiServer do
        TrangThai.Text = "Trạng thái: Đang quét trái..."
        TrangThai.TextColor3 = Color3.fromRGB(0, 255, 100)

        local danhSach = LayDanhSachTrai()
        local coTraiXin = false

        for _, trai in pairs(danhSach) do
            local tenTrai = trai.Name

            -- Kiểm tra trái xịn
            local laXin, tenChuan = LaTraiXin(tenTrai)

            if laXin then
                TrangThai.Text = "Trạng thái: Phát hiện " .. tenTrai .. "!"
                TrangThai.TextColor3 = Color3.fromRGB(255, 215, 0)

                if not daNhat[tenTrai] then
                    ThongBao("LUXURY IOS", "Phát hiện trái xịn: " .. tenTrai, 5)

                    local thanhCong = NhatTrai(trai)
                    if thanhCong then
                        daNhat[tenTrai] = true
                        coTraiXin = true
                        ThongBao("LUXURY IOS", "Đã nhặt: " .. tenTrai, 5)
                        task.wait(CAUHINH.ThoiGianChoNhat)
                    end
                end
                break
            elseif not CAUHINH.ChiNhatTraiXin then
                -- Nếu tắt "chỉ nhặt trái xin", nhặt mọi trái
                if not daNhat[tenTrai] then
                    NhatTrai(trai)
                    daNhat[tenTrai] = true
                    coTraiXin = true
                end
            end
        end

        -- Nếu không có trái xịn, đổi server
        if not coTraiXin then
            task.wait(CAUHINH.ThoiGianQuet)
            DoiServer()
            return
        end

        task.wait(1)
    end
end

-- ============ GẮN NÚT ============
TaoTieuDe("⚙ CÀI ĐẶT CHÍNH")
TaoNutBatTat("Tự Động Đổi Server", CAUHINH.TuDongDoiServer, function(v) CAUHINH.TuDongDoiServer = v end)
TaoNutBatTat("Chỉ Nhặt Trái Xịn", CAUHINH.ChiNhatTraiXin, function(v) CAUHINH.ChiNhatTraiXin = v end)
TaoNutBatTat("Thông Báo Khi Có Trái", CAUHINH.ThongBaoKhiCoTrai, function(v) CAUHINH.ThongBaoKhiCoTrai = v end)

TaoTieuDe("📋 DANH SÁCH TRÁI XỊN")
local labelDS = Instance.new("TextLabel")
labelDS.Size = UDim2.new(1, 0, 0, 140)
labelDS.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
labelDS.Text = table.concat(TRAI_XIN, ", ")
labelDS.TextColor3 = Color3.fromRGB(255, 255, 255)
labelDS.Font = Enum.Font.Gotham
labelDS.TextSize = 11
labelDS.TextWrapped = true
labelDS.Parent = KhungCuon

-- ============ KHỞI CHẠY ============
ThongBao("LUXURY IOS", "Script Auto Farm Trái Xịn v5.0 đã tải!", 5)

task.spawn(VongLapChinh)

LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
