QBCore = exports['qb-core']:GetCoreObject()

local IsSelling = false
local CurrentRadiusBlip = {}
local CurrentLocation = {
    ['Name'] = 'Fish1',
    ['Coords'] = {['X'] = 241.00, ['Y'] = 3993.00, ['Z'] = 30.40},
}
local CurrentBlip = {}
local LastLocation = nil  

local LoggedIn = false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    Citizen.SetTimeout(750, function() 
        SetRandomLocation()
        Citizen.Wait(250)
        LoggedIn = true
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    LoggedIn = false
end)

-- Code

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          Citizen.Wait(1000 * 60 * 4)
          SetRandomLocation()
        end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(15000)
    while true do
        Citizen.Wait(4)
        if LoggedIn then
          NearFishArea = false
          local PlayerCoords = GetEntityCoords(PlayerPedId())
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CurrentLocation['Coords']['X'], CurrentLocation['Coords']['Y'], CurrentLocation['Coords']['Z'], true)
          if Distance <= 75.0 then
              NearFishArea = true
              Config.CanFish = true
          end
          if not NearFishArea then
              Citizen.Wait(1500)
              Config.CanFish = false
          end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(4)
        if LoggedIn then
            NearArea = false
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                if not IsSelling then
                  DrawText3D(Config.Locations['Sell']['X'], Config.Locations['Sell']['Y'], Config.Locations['Sell']['Z'], '~g~E~s~ - Sell Fish')
                  if IsControlJustReleased(0, 38) then
                      IsSelling = true
                      QBCore.Functions.Notify('Selling..', 'info')
                      TriggerServerEvent('qb-fishing:server:sell:items')
                      Citizen.SetTimeout(15000, function()
                          IsSelling = false
                      end)
                  end
                end
            end

            local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], true)
            if Distance <= 2.0 then
                NearArea = true
                DrawMarker(2, Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 48, 255, 58, 255, false, false, false, 1, false, false, false)
                DrawText3D(Config.Locations['Boat']['X'], Config.Locations['Boat']['Y'], Config.Locations['Boat']['Z'] + 0.15, '~g~E~s~ - Rent Boat ~g~€~s~500')
                if IsControlJustReleased(0, 38) then
                    QBCore.Functions.TriggerCallback("qb-fishing:server:can:pay", function(DidPay)
                        if DidPay then
                            SpawnFishBoat()
                        end
                    end, Config.BoatPrice)
                end
            end

            if not NearArea then
                Citizen.Wait(1500)
            end
        end
    end
end)

RegisterNetEvent('qb-fishing:client:rod:anim')
AddEventHandler('qb-fishing:client:rod:anim', function()
    exports['qb-assets']:AddProp('FishingRod')
    exports['qb-assets']:RequestAnimationDict('amb@world_human_stand_fishing@idle_a')
    TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_a", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
end)

RegisterNetEvent('qb-fishing:client:use:fishingrod')
AddEventHandler('qb-fishing:client:use:fishingrod', function()
  Citizen.SetTimeout(1000, function()
      if not Config.UsingRod then
       if Config.CanFish then
          if not IsPedInAnyVehicle(PlayerPedId()) then
           if not IsEntityInWater(PlayerPedId()) then
               Config.UsingRod = true
               FreezeEntityPosition(PlayerPedId(), true)
               local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
               local SucceededAttempts = 0
               local NeededAttempts = math.random(2, 5)
               TriggerEvent('qb-fishing:client:rod:anim')
               Skillbar.Start({
                   duration = math.random(500, 1300),
                   pos = math.random(10, 30),
                   width = math.random(10, 20),
               }, function()
                   if SucceededAttempts + 1 >= NeededAttempts then
                       -- Finish
                       FreezeEntityPosition(PlayerPedId(), false)
                       exports['qb-assets']:RemoveProp()
                       Config.UsingRod = false
                       SucceededAttempts = 0
                       --QBCore.Functions.TriggerCallback('qb-fishing:server:fish:reward')
                       TriggerServerEvent('qb-fishing:server:fish:reward')
                       StopAnimTask(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
                   else
                       -- Repeat
                       Skillbar.Repeat({
                           duration = math.random(500, 1300),
                           pos = math.random(10, 40),
                           width = math.random(5, 13),
                       })
                       SucceededAttempts = SucceededAttempts + 1
                   end
               end, function()
                   -- Fail
                   FreezeEntityPosition(PlayerPedId(), false)
                   exports['qb-assets']:RemoveProp()
                   Config.UsingRod = false
                   QBCore.Functions.Notify('Je faalde..', 'error')
                   SucceededAttempts = 0
                   StopAnimTask(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_a", 1.0)
               end)
           else
               QBCore.Functions.Notify('You are swimming.', 'error')
           end
          else
              QBCore.Functions.Notify('You are in a vehicle.', 'error')
          end
       else
           QBCore.Functions.Notify('You are not in the fishing area.', 'error')
       end
      end
  end)
end)

function SetRandomLocation()
    RandomLocation = Config.FishLocations[math.random(1, #Config.FishLocations)]
    if CurrentLocation['Name'] ~= RandomLocation['Name'] then
     if CurrentBlip ~= nil and CurrentRadiosBlip ~= nil then
      RemoveBlip(CurrentBlip)
      RemoveBlip(CurrentRadiosBlip)
     end
     Citizen.SetTimeout(250, function()
         CurrentRadiosBlip = AddBlipForRadius(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'], 75.0)        
         SetBlipRotation(CurrentRadiosBlip, 0)
         SetBlipColour(CurrentRadiosBlip, 19)
     
         CurrentBlip = AddBlipForCoord(RandomLocation['Coords']['X'], RandomLocation['Coords']['Y'], RandomLocation['Coords']['Z'])
         SetBlipSprite(CurrentBlip, 68)
         SetBlipDisplay(CurrentBlip, 4)
         SetBlipScale(CurrentBlip, 0.7)
         SetBlipColour(CurrentBlip, 0)
         SetBlipAsShortRange(CurrentBlip, true)
         BeginTextCommandSetBlipName('STRING')
         AddTextComponentSubstringPlayerName('Fish Area')
         EndTextCommandSetBlipName(CurrentBlip)
         CurrentLocation = RandomLocation
     end)
    else
        SetRandomLocation()
    end
end

function SpawnFishBoat()
    local CoordTable = {x = 1517.25, y = 3836.86, z = 29.60, a = 37.31}
    QBCore.Functions.SpawnVehicle('dinghy', function(vehicle)
     TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
     exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(vehicle), true)
     Citizen.Wait(100)
     exports['qb-fuel']:SetFuelLevel(vehicle, GetVehicleNumberPlateText(vehicle), 100, true)
     QBCore.Functions.Notify('You have recieved your boat.', 'success')
    end, CoordTable, true, true)
end

-- // Functions \\ --

function DrawText3D(x, y, z, text)
  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)
  SetTextEntry("STRING")
  SetTextCentre(true)
  AddTextComponentString(text)
  SetDrawOrigin(x,y,z, 0)
  DrawText(0.0, 0.0)
  ClearDrawOrigin()
end