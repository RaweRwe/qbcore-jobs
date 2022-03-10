Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

QBCore = exports['qb-core']:GetCoreObject()
isLoggedIn = false

PlayerJob = {}

--- CODE

local inVehicleShop = false

vehicleCategorys = {
    ["coupes"] = {
        label = "Coupes",
        vehicles = {}
    },
    ["sedans"] = {
        label = "Sedans",
        vehicles = {}
    },
    ["muscle"] = {
        label = "Muscle",
        vehicles = {}
    },
    ["suvs"] = {
        label = "SUVs",
        vehicles = {}
    },
    ["compacts"] = {
        label = "Compacts",
        vehicles = {}
    },
    ["vans"] = {
        label = "Vans",
        vehicles = {}
    },
    ["super"] = {
        label = "Super",
        vehicles = {}
    },
    ["sports"] = {
        label = "Sports",
        vehicles = {}
    },
    ["sportsclassics"] = {
        label = "Sports Classics",
        vehicles = {}
    },
    ["motorcycles"] = {
        label = "Motoren",
        vehicles = {}
    },
    ["offroad"] = {
        label = "Offroad",
        vehicles = {}
    },
}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if v["shop"] == "pdm" then
            for cat,_ in pairs(vehicleCategorys) do
                if QBCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(vehicleCategorys[cat].vehicles, QBCore.Shared.Vehicles[k])
                end
            end
        end
    end
end)

function openVehicleShop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        ui = bool
    })
end

function setupVehicles(vehs)
    SendNUIMessage({
        action = "setupVehicles",
        vehicles = vehs
    })
end

RegisterNUICallback('GetCategoryVehicles', function(data)
    setupVehicles(shopVehicles[data.selectedCategory])
end)

RegisterNUICallback('exit', function()
    openVehicleShop(false)
end)

RegisterNUICallback('buyVehicle', function(data)
    local vehicleData = data.vehicleData
    local garage = data.garage

    TriggerServerEvent('qb-vehicleshop:server:buyVehicle', vehicleData, garage)
    openVehicleShop(false)
end)

RegisterNetEvent('qb-vehicleshop:client:spawnBoughtVehicle')
AddEventHandler('qb-vehicleshop:client:spawnBoughtVehicle', function(vehicle)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetEntityHeading(veh, Pepe.SpawnPoint.h)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    end, Pepe.SpawnPoint, true)
end)

-- Citizen.CreateThread(function()
--     Citizen.Wait(100)
--     while true do
--         local ped = PlayerPedId()
--         local pos = GetEntityCoords(ped)

--         if isLoggedIn then
--             for k, v in pairs(Pepe.VehicleShops) do
--                 local dist = GetDistanceBetweenCoords(pos, Pepe.VehicleShops[k].x, Pepe.VehicleShops[k].y, Pepe.VehicleShops[k].z)
--                 if dist <= 15 then
--                     DrawMarker(2, Pepe.VehicleShops[k].x, Pepe.VehicleShops[k].y, Pepe.VehicleShops[k].z + 0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
--                     if dist <= 1.5 then
--                         QBCore.Functions.DrawText3D(Pepe.VehicleShops[k].x, Pepe.VehicleShops[k].y, Pepe.VehicleShops[k].z + 1.3, '~g~E~w~ - Premium Deluxe Motorsports')
--                         if IsControlJustPressed(0, 51) then
--                             openVehicleShop(true)
--                         end
--                     end
--                 end
--             end
--         end

--         Citizen.Wait(0)
--     end
-- end)

Citizen.CreateThread(function()
    for k, v in pairs(Pepe.VehicleShops) do
        Dealer = AddBlipForCoord(Pepe.VehicleShops[k].x, Pepe.VehicleShops[k].y, Pepe.VehicleShops[k].z)

        SetBlipSprite (Dealer, 326)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Premium Deluxe Motorsports")
        EndTextCommandSetBlipName(Dealer)
    end
end)

Citizen.CreateThread(function()
    QuickSell = AddBlipForCoord(Pepe.QuickSell.x, Pepe.QuickSell.y, Pepe.QuickSell.z)

    SetBlipSprite (QuickSell, 108)
    SetBlipDisplay(QuickSell, 4)
    SetBlipScale  (QuickSell, 0.55)
    SetBlipAsShortRange(QuickSell, true)
    SetBlipColour(QuickSell, 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("PDM Quick Sell")
    EndTextCommandSetBlipName(QuickSell)
end)