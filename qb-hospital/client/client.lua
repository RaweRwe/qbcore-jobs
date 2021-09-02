local BedData = nil
local BedCam = nil
local onDuty = false
local CurrentGarage = nil
isLoggedIn = false

QBCore = nil  

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(1250, function()
    TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
     Citizen.Wait(250)
      QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata["isdead"] then
         SetState('death', true)
        else
         SetEntityHealth(PlayerPedId(), PlayerData.metadata["health"])
        end
         isLoggedIn = true
         onDuty = PlayerData.job.onduty
         TriggerServerEvent("qb-police:server:UpdateBlips")
     end)
    end) 
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
 TriggerServerEvent('qb-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
 isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(Onduty)
 TriggerServerEvent("qb-police:server:UpdateBlips")
 onDuty = Onduty
end)

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            Citizen.Wait(20000)
            TriggerServerEvent('qb-hospital:server:save:health:armor', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            NearSomething = false

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], true) < 1.5) then
                if (QBCore.Functions.GetPlayerData().job.name == "ambulance") then
                  DrawMarker(2, Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if not onDuty then
                    DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, '~g~E~w~ - In Duty')
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("QBCore:ToggleDuty", true)
                    end
                else
                    DrawText3D(Config.Locations["Duty"][1]['X'], Config.Locations["Duty"][1]['Y'], Config.Locations["Duty"][1]['Z'] + 0.15, '~r~E~w~ - Off Duty')
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent("QBCore:ToggleDuty", false)
                    end
                end
                end
            end

            if onDuty then

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], true) < 1.5) then
                 if (QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
                   DrawText3D(Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'] + 0.15, '~g~E~s~ - EMS Closet')
                   DrawMarker(2, Config.Locations["Shop"][1]['X'], Config.Locations["Shop"][1]['Y'], Config.Locations["Shop"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                   NearSomething = true
                   if IsControlJustReleased(0, 38) then
                    TriggerServerEvent("qb-inventory:server:OpenInventory", "shop", "hospital", Config.Items)
                   end
                 end
             end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], true) < 1.5) then
                if (QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
                  DrawText3D(Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'] + 0.15, '~g~E~s~ - EMS Stash')
                  DrawMarker(2, Config.Locations["Storage"][1]['X'], Config.Locations["Storage"][1]['Y'], Config.Locations["Storage"][1]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                  NearSomething = true
                  if IsControlJustReleased(0, 38) then
                    local Other = {maxweight = 2000000, slots = 200}
                    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "hospital", Other)
                    TriggerEvent("qb-inventory:client:SetCurrentStash", "hospital")
                  end
                end
             end
             
            end

             if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], true) < 1.5) then
              DrawText3D(Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'] + 0.15, '~g~E~s~ - Check in (~g~€~s~500)')
              DrawMarker(2, Config.Locations["CheckIn"]['X'], Config.Locations["CheckIn"]['Y'], Config.Locations["CheckIn"]['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
             NearSomething = true
             if IsControlJustReleased(0, 38) then
                local BedSomething = GetAvailableBed()
                if BedSomething ~= nil or BedSomething ~= false then
            --         QBCore.Functions.TriggerCallback("qb-hospital:server:pay:hospital", function(HasPaid)
            --             if HasPaid then
            --                 DetachEntity(PlayerPedId(), true, false)
            --                 QBCore.Functions.Progressbar("lockpick-door", "Checking in..", 2500, false, false, {
            --                     disableMovement = true,
            --                     disableCarMovement = true,
            --                     disableMouse = false,
            --                     disableCombat = true,
            --                 }, {
            --                     animDict = "missheistdockssetup1clipboard@base",
            --                     anim = "base",
            --                     flags = 49,
            --                 }, {
            --                     model = "p_amb_clipboard_01",
            --                     bone = 18905,
            --                     coords = { x = 0.10, y = 0.02, z = 0.08 },
            --                     rotation = { x = -80.0, y = 0.0, z = 0.0 },
            --                 }, {
            --                     model = "prop_pencil_01",
            --                     bone = 58866,
            --                     coords = { x = 0.12, y = 0.0, z = 0.001 },
            --                     rotation = { x = -150.0, y = 0.0, z = 0.0 },
            --                 }, function() -- Done
            --                     TriggerEvent('qb-hospital:client:send:to:bed', BedSomething)
            --                 end, function() -- Cancel
            --                     QBCore.Functions.Notify("Process cancelled..", "error")
            --                 end)
            --             end
            --         end)
            --     else
            --         QBCore.Functions.Notify("Beds are taken..", 'error')
            --     end
            --  end
            -- end

            QBCore.Functions.TriggerCallback("qb-hospital:server:pay:hospital", function(HasPaid)
                if HasPaid then
                    TriggerEvent('animations:client:EmoteCommandStart', {"notepad"})
                    QBCore.Functions.Progressbar("lockpick-door", "Checking in..", 2500, false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        TriggerEvent('qb-hospital:client:send:to:bed', BedSomething)
                    end, function() -- Cancel
                        QBCore.Functions.Notify("Process aborted..", "error")
                    end)
                end
            end)
        else
            QBCore.Functions.Notify("All beds are taken..", 'error')
        end
     end
    end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'] + 0.15, '~g~E~s~ - Upstairs')
                DrawMarker(2, Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("qb-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'] + 0.15, '~g~E~s~ - Downstairs')
                DrawMarker(2, Config.Locations['Teleporters']['ToHospitalFirst']['X'], Config.Locations['Teleporters']['ToHospitalFirst']['Y'], Config.Locations['Teleporters']['ToHospitalFirst']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("qb-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHeli']['X'], Config.Locations['Teleporters']['ToHeli']['Y'], Config.Locations['Teleporters']['ToHeli']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'] + 0.15, '~g~E~s~ - Upstairs')
                DrawMarker(2, Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("qb-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end
            
            if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], true) < 1.5) then
                DrawText3D(Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'] + 0.15, '~g~E~s~ - Downstairs')
                DrawMarker(2, Config.Locations['Teleporters']['ToHospitalSecond']['X'], Config.Locations['Teleporters']['ToHospitalSecond']['Y'], Config.Locations['Teleporters']['ToHospitalSecond']['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                NearSomething = true
                if IsControlJustReleased(0, 38) then
                    DoScreenFadeOut(450)
                    Citizen.Wait(450)
                    TriggerEvent("qb-sound:client:play", "hospital-elevator", 0.25)
                    SetEntityCoords(PlayerPedId(), Config.Locations['Teleporters']['ToLower']['X'], Config.Locations['Teleporters']['ToLower']['Y'], Config.Locations['Teleporters']['ToLower']['Z'])
                    Citizen.Wait(250)
                    DoScreenFadeIn(450)
                end
            end

            if not NearSomething then
                Citizen.Wait(1500)
            end

        end
    end
end)

-- // Events \\ --

RegisterNetEvent('qb-hospital:client:revive')
AddEventHandler('qb-hospital:client:revive', function(UseAnim, IsAdmin)
    if Config.IsDeath then
      SetState('death', false)
      SetEntityInvincible(PlayerPedId(), false)
      NetworkResurrectLocalPlayer(GetEntityCoords(PlayerPedId(), true), true, true, false)   
    end
    ResetBodyHp()
    ResetScreenAndWalk()
    ClearPedTasks(PlayerPedId())
    SetEntityHealth(PlayerPedId(), 200)
    ClearPedBloodDamage(PlayerPedId())
    SetPlayerSprint(PlayerId(), true)
    if UseAnim then
     TriggerEvent('qb-hospital:client:revive:anim')
    end
     TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", QBCore.Functions.GetPlayerData().metadata["thirst"] + 65)
     TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", QBCore.Functions.GetPlayerData().metadata["hunger"] + 65)  

    TriggerServerEvent('qb-hud:server:remove:stress', 100)
    TriggerEvent('qb-police:client:set:escort:status:false')
    QBCore.Functions.Notify("You have been revived", 'success')
end)

RegisterNetEvent('qb-hospital:client:heal:closest')
AddEventHandler('qb-hospital:client:heal:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
        if not IsTargetDead(GetPlayerServerId(Player)) then
           HealAnim(RandomTime)
           QBCore.Functions.Progressbar("healing-citizen", "Healing Citizen..", RandomTime, false, true, {
               disableMovement = true,
               disableCarMovement = true,
               disableMouse = false,
               disableCombat = true,
           }, {}, {}, {}, function() -- Done
               TriggerServerEvent('qb-hospital:server:heal:player', GetPlayerServerId(Player))
               QBCore.Functions.Notify("Citizen healed", "success")
           end, function() -- Cancel
               QBCore.Functions.Notify("Process cancelled..", "error")
           end)
        else
            QBCore.Functions.Notify("Citizen is not unconscious..", "error")
        end
    end
end)

RegisterNetEvent('qb-hospital:client:revive:closest')
AddEventHandler('qb-hospital:client:revive:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(10000, 15000)
    if Player ~= -1 and Distance < 1.5 then
      if IsTargetDead(GetPlayerServerId(Player)) then
         QBCore.Functions.Progressbar("hospital_revive", "Helping Citizen..", RandomTime, false, true, {
             disableMovement = false,
             disableCarMovement = false,
             disableMouse = false,
             disableCombat = true,
         }, {
             animDict = 'mini@cpr@char_a@cpr_str',
             anim = 'cpr_pumpchest',
             flags = 8,
         }, {}, {}, function() -- Done
             TriggerServerEvent('qb-hospital:server:revive:player', GetPlayerServerId(Player))
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             QBCore.Functions.Notify("You have healed the citizen")
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "exit", 1.0)
             QBCore.Functions.Notify("Failed!", "error")
         end)
        else
            QBCore.Functions.Notify("Citizen is not unconscious..", "error")
        end
    end
end)

RegisterNetEvent('qb-hospital:client:take:blood:closest')
AddEventHandler('qb-hospital:client:take:blood:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(7500, 10500)
    if Player ~= -1 and Distance < 1.5 then
      HealAnim(RandomTime)
      QBCore.Functions.Progressbar("healing-citizen", "Taking blood sample..", RandomTime, false, true, {
          disableMovement = true,
          disableCarMovement = true,
          disableMouse = false,
          disableCombat = true,
      }, {}, {}, {}, function() -- Done
          TriggerServerEvent('qb-hospital:server:take:blood:player', GetPlayerServerId(Player))
          QBCore.Functions.Notify("Blood sample recieved", "success")
      end, function() -- Cancel
          QBCore.Functions.Notify("Process cancelled..", "error")
      end)
    end
end)

RegisterNetEvent('qb-hospital:client:heal')
AddEventHandler('qb-hospital:client:heal', function()
    local CurrentHealth = GetEntityHealth(PlayerPedId())
    local NewHealth = CurrentHealth + 15.0
    if CurrentHealth + 15.0 > 100.0 then
        NewHealth = 100.0
    end
    ResetBodyHp()
    ClearPedTasks(PlayerPedId())
    ClearPedBloodDamage(PlayerPedId())
    SetEntityHealth(PlayerPedId(), NewHealth)
end)

RegisterNetEvent('qb-hospital:client:revive:anim')
AddEventHandler('qb-hospital:client:revive:anim', function()
 exports['qb-assets']:RequestAnimationDict("random@crash_rescue@help_victim_up")
 TaskPlayAnim(PlayerPedId(), "random@crash_rescue@help_victim_up", "helping_victim_to_feet_victim", 8.0, 1.0, -1, 49, 0, 0, 0, 0 )
 Citizen.Wait(1850)
 ClearPedSecondaryTask(PlayerPedId())
end)

RegisterNetEvent('qb-hospital:client:set:bed:state')
AddEventHandler('qb-hospital:client:set:bed:state', function(BedData, bool)
  Config.Beds[BedData]['Busy'] = bool
end)

RegisterNetEvent('qb-hospital:client:send:to:bed')
AddEventHandler('qb-hospital:client:send:to:bed', function(BedId)
    Citizen.SetTimeout(50, function()
        EnterBedCam(BedId)
        QBCore.Functions.Notify('You are recieving medical attention..', 'info')
        Citizen.Wait(25000)
        TriggerEvent('qb-hospital:client:revive', false, false)
        LeaveBed()
    end)
end)

RegisterNetEvent('qb-hospital:client:spawn:vehicle')
AddEventHandler('qb-hospital:client:spawn:vehicle', function(VehicleName)
    if VehicleName ~= 'AmbulanceHeli' then
        local RandomCoords = Config.Locations['Garage'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['Garage'][CurrentGarage]['Spawns'])]
        local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
        QBCore.Functions.SpawnVehicle(VehicleName, function(Vehicle)
          Citizen.Wait(25)
          exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
          exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
          exports['qb-emergencylights']:SetupEmergencyVehicle(Vehicle)
          QBCore.Functions.Notify('Duty vehicle parked on the parkingspot', 'info')
          CurrentGarage = nil
         end, CoordTable, true, false)
      else
          local CoordTable = {x = 352.17, y = -587.87, z = 74.16, a = 90.57}
          QBCore.Functions.SpawnVehicle('AmbulanceHeli', function(Vehicle)
           Citizen.Wait(25)
           exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
           exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
           QBCore.Functions.Notify('Helicopter is landed on the roof!', 'info')
           CurrentGarage = nil
          end, CoordTable, true, false)
      end
end)

-- // Functions \\ --

function NearGarage()
  for k, v in pairs(Config.Locations['Garage']) do
      local PlayerCoords = GetEntityCoords(PlayerPedId())
      if (GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true) < 10.0) then
          CurrentGarage = k
          return true
      end
  end
end

function EnterBedCam(BedId)
    Config.IsInBed = true
    BedData = BedId
    TriggerServerEvent('qb-hospital:server:set:bed:state', BedData, true)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(100)
    end
    BedObject = GetClosestObjectOfType(Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'], 1.0, Config.Beds[BedData]['Hash'], false, false, false)
    SetEntityCoords(PlayerPedId(), Config.Beds[BedData]['X'], Config.Beds[BedData]['Y'], Config.Beds[BedData]['Z'] + 0.02)
    Citizen.Wait(500)
    FreezeEntityPosition(PlayerPedId(), true)
    exports['qb-assets']:RequestAnimationDict("misslamar1dead_body")
    TaskPlayAnim(PlayerPedId(), "misslamar1dead_body", "dead_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'])
    BedCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(BedCam, true)
    RenderScriptCams(true, false, 1, true, true)
    AttachCamToPedBone(BedCam, PlayerPedId(), 31085, 0, 1.0, 1.0 , true)
    SetCamFov(BedCam, 100.0)
    SetCamRot(BedCam, -45.0, 0.0, GetEntityHeading(PlayerPedId()) + 180, true)
    DoScreenFadeIn(1000)
end

function LeaveBed()
    exports['qb-assets']:RequestAnimationDict('switch@franklin@bed')
    FreezeEntityPosition(PlayerPedId(), false)
    SetEntityInvincible(PlayerPedId(), false)
    SetEntityHeading(PlayerPedId(), Config.Beds[BedData]['H'] + 90)
    TaskPlayAnim(PlayerPedId(), 'switch@franklin@bed', 'sleep_getup_rubeyes', 100.0, 1.0, -1, 8, -1, 0, 0, 0)
    Citizen.Wait(4000)
    ClearPedTasks(PlayerPedId())
    RenderScriptCams(0, true, 200, true, true)
    DestroyCam(BedCam, false)
    TriggerServerEvent('qb-hospital:server:set:bed:state', BedData, false)
end

function HealAnim(time)
  time = time / 1000
  exports['qb-assets']:RequestAnimationDict("weapons@first_person@aim_rng@generic@projectile@thermal_charge@")
  TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor" ,3.0, 3.0, -1, 16, 0, false, false, false)
  Healing = true
  Citizen.CreateThread(function()
      while Healing do
          TaskPlayAnim(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
          Citizen.Wait(2000)
          time = time - 2
          if time <= 0 then
              Healing = false
              StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
          end
      end
  end)
end

function ResetScreenAndWalk() 
    Citizen.SetTimeout(1500, function()
        SetFlash(false, false, 450, 3000, 450)
        Citizen.Wait(350)
        ClearTimecycleModifier()
        ResetPedMovementClipset(PlayerPedId(), 0)
    end)
end

function GetAvailableBed()
    for k, v in pairs(Config.Beds) do
        if not v['Busy'] then
            return k
        end
    end
end

function IsTargetDead(playerId)
 local IsDead = false
  QBCore.Functions.TriggerCallback('qb-police:server:is:player:dead', function(result)
    IsDead = result
  end, playerId)
  Citizen.Wait(100)
  return IsDead
end

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