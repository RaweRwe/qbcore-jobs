local DutyBlips = {}
local ShopItems = {}
local ObjectList = {}
local NearPoliceGarage = false
local NearPoliceImpound = false
local CurrentGarage = nil
local Locaties = {["Politie"] = {[1] = {["x"] = 473.78, ["y"] = -992.64, ["z"] = 26.27, ["h"] = 0.0}, [2] = {["x"] = -445.87, ["y"] = 6013.88, ["z"] = 31.71, ["h"] = 0.0}}}
local FingerPrintSession = nil
PlayerJob = {}
isLoggedIn = false
onDuty = false

QBCore = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
      Citizen.Wait(450)
      QBCore.Functions.GetPlayerData(function(PlayerData)
      PlayerJob, onDuty = PlayerData.job, PlayerData.job.onduty 
      if PlayerJob.name == 'police' and PlayerData.job.onduty then
       TriggerEvent('qb-radialmenu:client:update:duty:vehicles')
       TriggerEvent('qb-police:client:set:radio')
       TriggerServerEvent("qb-police:server:UpdateBlips")
       TriggerServerEvent("qb-police:server:UpdateCurrentCops")
      end
      isLoggedIn = true 
      SpawnIncheckProp()
      end)
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    Citizen.SetTimeout(500, function()
     TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)  
     Citizen.Wait(3500)
     QBCore.Functions.GetPlayerData(function(PlayerData)
        if PlayerData.metadata['tracker'] then
          TriggerEvent('qb-police:client:set:tracker', true)
        end
        if PlayerData.metadata['ishandcuffed'] then
            TriggerServerEvent('qb-sound:server:play:distance', 2.0, 'handcuff', 0.2)
            Config.IsHandCuffed = true
        end
        isLoggedIn = true 
     end)
    end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
    if PlayerJob.name == 'police' then
      TriggerServerEvent("QBCore:ToggleDuty", false)
      TriggerServerEvent("qb-police:server:UpdateCurrentCops")
      if DutyBlips ~= nil then 
        for k, v in pairs(DutyBlips) do
            RemoveBlip(v)
        end
        DutyBlips = {}
      end
    end
    ClearPedTasks(PlayerPedId())
    DetachEntity(PlayerPedId(), true, false)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    TriggerServerEvent("qb-police:server:UpdateBlips")
    if (PlayerJob ~= nil) and PlayerJob.name ~= "police" or PlayerJob.name ~= 'ambulance' then
        if DutyBlips ~= nil then
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
    end
end)

RegisterNetEvent('QBCore:Client:SetDuty')
AddEventHandler('QBCore:Client:SetDuty', function(Onduty)
TriggerServerEvent("qb-police:server:UpdateBlips")
 if not Onduty then
    if PlayerJob.name == 'police' or PlayerJob.name == 'ambulance' then
     for k, v in pairs(DutyBlips) do
         RemoveBlip(v)
     end
     DutyBlips = {}
    end
 end
 onDuty = Onduty
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if isLoggedIn then
            if PlayerJob.name == "police" then
               NearAnything = false
               local PlayerCoords = GetEntityCoords(PlayerPedId())

               for k, v in pairs(Config.Locations['checkin']) do 
                local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                if Area < 2.0 then
                    NearAnything = true
                    DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                    if not onDuty then
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~g~E~w~ - Mesai')
                        if IsControlJustReleased(0, Config.Keys['E']) then
                            TriggerServerEvent("QBCore:ToggleDuty", true)
                            TriggerEvent('qb-radialmenu:client:update:duty:vehicles')
                            TriggerServerEvent("qb-police:server:UpdateCurrentCops")
                        end
                    else
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~r~E~w~ - Mesai Dışı')
                        if IsControlJustReleased(0, Config.Keys['E']) then
                            TriggerServerEvent("QBCore:ToggleDuty", false)
                            TriggerEvent('qb-radialmenu:client:update:duty:vehicles')
                            TriggerServerEvent("qb-police:server:UpdateCurrentCops")
                        end
                    end
                end
            end
            
               if onDuty then

                for k, v in pairs(Config.Locations['fingerprint']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 3.3 then
                        NearAnything = true
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 50, 107, 168, 255, false, false, false, 1, false, false, false)
                    end
                    if Area < 2.0 then
                        NearAnything = true
                         DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, '~b~E~w~ - Parmak İzi Tarayıcı')
                         if IsControlJustReleased(0, Config.Keys['E']) then
                            local Player, Distance = QBCore.Functions.GetClosestPlayer()
                            if Player ~= -1 and Distance < 2.5 then
                                 TriggerServerEvent("qb-police:server:show:machine", GetPlayerServerId(Player))
                            else
                                QBCore.Functions.Notify("Etrafında kimse yok", "error")
                            end
                        end
                    end
                end
                NearPoliceGarage = false
                for k, v in pairs(Config.Locations['garage']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 5.5 then
                        NearAnything = true
                        NearPoliceGarage = true
                        CurrentGarage = k
                    end
                end

                
                NearPoliceBossMenu = false

                for k, v in pairs(Config.Locations['boss']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 2.0 then
                        NearAnything = true
                        NearPoliceBossMenu = true

                        DrawText3D(v['X'], v['Y'], v['Z'], "~r~E~w~ Boss Menu")
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            TriggerServerEvent("qb-bossmenu:server:openMenu")
                        end
                    end
                end

                
                NearPoliceImpound = false
                for k, v in pairs(Config.Locations['impound']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 8.0 then
                        NearAnything = true
                        NearPoliceImpound = true
                        if Area < 1.5 then
                            if IsPedInAnyVehicle(PlayerPedId(), false) then
                                DrawText3D(v['X'], v['Y'], v['Z'], "~g~E~w~ - Depo")
                            else
                                DrawText3D(v['X'], v['Y'], v['Z'], "~g~E~w~ - Araçlar")
                            end
                            if IsControlJustReleased(0, Config.Keys["E"]) then
                                if IsPedInAnyVehicle(PlayerPedId(), false) then
                                    QBCore.Functions.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId()))
                                else
                                    MenuImpound()
                                    currentGarage = Police
                                    Menu.hidden = not Menu.hidden
                                end
                            end
                            Menu.renderGUI()
                        end 
                    end
                end


                for k, v in pairs(Config.Locations['personal-safe']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Kşisel Kasa")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                          TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "personalsafe_"..QBCore.Functions.GetPlayerData().citizenid)
                          TriggerEvent("qb-inventory:client:SetCurrentStash", "personalsafe_"..QBCore.Functions.GetPlayerData().citizenid)
                        end
                    end
                end

                for k, v in pairs(Config.Locations['work-shops']) do 
                    local Area = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, v['X'], v['Y'], v['Z'], true)
                    if Area < 1.5 then
                        NearAnything = true
                        DrawText3D(v['X'], v['Y'], v['Z'] + 0.15, "~g~E~w~ - Polis Kasası")
                        DrawMarker(2, v['X'], v['Y'], v['Z'], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.1, 0.05, 255, 255, 255, 255, false, false, false, 1, false, false, false)
                        if IsControlJustReleased(0, Config.Keys["E"]) then
                            SetWeaponSeries()
                            TriggerServerEvent("qb-inventory:server:OpenInventory", "shop", "police", Config.Items)
                        end
                    end
                end
              end
              if not NearAnything then 
                  Citizen.Wait(1500)
                  CurrentGarage = nil
              end
            else
                Citizen.Wait(1000)
            end
        end 
    end
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if Config.IsEscorted then
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 38, true)
            EnableControlAction(0, 322, true)
        end
        if Config.IsHandCuffed then
            DisableControlAction(0, 24, true) 
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 25, true) 
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
			DisableControlAction(1, 37, true)
			DisableControlAction(0, 23, true)
			DisableControlAction(0, 288, true)
            DisableControlAction(2, 199, true)
            DisableControlAction(2, 244, true)
            DisableControlAction(0, 137, true)
			DisableControlAction(0, 59, true) 
			DisableControlAction(0, 71, true) 
			DisableControlAction(0, 72, true) 
			DisableControlAction(0, 73, true) 
			DisableControlAction(2, 36, true) 
			DisableControlAction(0, 264, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 143, true)
			DisableControlAction(0, 75, true) 
            DisableControlAction(27, 75, true)
            DisableControlAction(0, 245, true)
            if (not IsEntityPlayingAnim(PlayerPedId(), "mp_arresting", "idle", 3) and not IsEntityPlayingAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3)) and not QBCore.Functions.GetPlayerData().metadata["isdead"] then
                exports['qb-assets']:RequestAnimationDict("mp_arresting")
                TaskPlayAnim(PlayerPedId(), "mp_arresting", "idle", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
        end
        if not Config.IsEscorted and not Config.IsHandCuffed then
            Citizen.Wait(2000)
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('qb-police:client:UpdateBlips')
AddEventHandler('qb-police:client:UpdateBlips', function(players)
    if PlayerJob ~= nil and (PlayerJob.name == 'police' or PlayerJob.name == 'ambulance') and onDuty then
        if DutyBlips ~= nil then 
            for k, v in pairs(DutyBlips) do
                RemoveBlip(v)
            end
        end
        DutyBlips = {}
        if players ~= nil then
            for k, data in pairs(players) do
                local id = GetPlayerFromServerId(data.source)
                if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= PlayerPedId() then
                    CreateDutyBlips(id, data.label, data.job)
                end
            end
        end
	end
end)


RegisterNetEvent('qb-police:client:bill:player')
AddEventHandler('qb-police:client:bill:player', function(price)
    SetTimeout(math.random(2500, 3000), function()
        local gender = "meneer"
        if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
            gender = "mevrouw"
        end
        local charinfo = QBCore.Functions.GetPlayerData().charinfo
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = "Los Santos Polis Departmani",
            subject = "Yeni Para Cezasi",
            message = "Sevgili " .. gender .. " " .. charinfo.lastname .. ",<br/><br />Maliye Bakanligi Devlete olan borcunuzu bankanizdan aldı.<br /><br />Para Cezasinin Toplam Tutari: <strong>€"..price.."</strong> <br><br>Lutfen Bu Tutari gun icinde odeyin <strong>14</strong> son odeme icin is gunu.<br/><br/>Saygilarimizla,<br />Mahkeme",
            button = {}
        })
    end)
end)


-- // Cuff & Escort Event \\ --
RegisterNetEvent('qb-police:client:cuff:closest')
AddEventHandler('qb-police:client:cuff:closest', function()
if not IsPedRagdoll(PlayerPedId()) then
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 1.5 then
        local ServerId = GetPlayerServerId(Player)
        if not IsPedInAnyVehicle(GetPlayerPed(Player)) and not IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerServerEvent("qb-police:server:cuff:closest", ServerId, true)
            HandCuffAnimation()
        else
            QBCore.Functions.Notify("Bir aracın içinde kelepçelenemezsin.", "error")
        end
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
  else
      Citizen.Wait(2000)
  end
end)

RegisterNetEvent('qb-police:client:get:cuffed')
AddEventHandler('qb-police:client:get:cuffed', function()
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    local NotifySend = false
    local SucceededAttempts = 0
    local NeededAttempts = 1
    if not Config.IsHandCuffed then
        GetCuffedAnimation()
        if math.random(1,3) == 2 then
            Skillbar.Start({
                duration = math.random(360, 375),
                pos = math.random(10, 30),
                width = math.random(10, 20),
            }, function()
                if SucceededAttempts + 1 >= NeededAttempts then
                    -- Finish
                    SucceededAttempts = 0
                    ClearPedTasksImmediately(PlayerPedId())
                    QBCore.Functions.Notify("Kırdın!")
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
                Config.IsHandCuffed = true
                TriggerServerEvent("qb-police:server:set:handcuff:status", true)
                SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
                ClearPedTasksImmediately(PlayerPedId())
                SucceededAttempts = 0
                if not NotifySend then
                    NotifySend = true
                    QBCore.Functions.Notify("Yumuşak Kafalısın")
                    Citizen.Wait(100)
                    NotifySend = false
                end
            end)
        else
            Config.IsHandCuffed = true
            TriggerServerEvent("qb-police:server:set:handcuff:status", true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey("weapon_unarmed"), 1)
            ClearPedTasksImmediately(PlayerPedId())
        end
    else
        Config.IsEscorted = false
        Config.IsHandCuffed = false
        DetachEntity(PlayerPedId(), true, false)
        TriggerServerEvent("qb-police:server:set:handcuff:status", false)
        ClearPedTasksImmediately(PlayerPedId())
        QBCore.Functions.Notify("Açıldı")
    end
end)

RegisterNetEvent('qb-police:client:set:escort:status:false')
AddEventHandler('qb-police:client:set:escort:status:false', function()
 if Config.IsEscorted then
  Config.IsEscorted = false
  DetachEntity(PlayerPedId(), true, false)
  ClearPedTasks(PlayerPedId())
 end
end)

RegisterNetEvent('qb-police:client:escort:closest')
AddEventHandler('qb-police:client:escort:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
          if not IsPedInAnyVehicle(PlayerPedId()) then
            TriggerServerEvent("qb-police:server:escort:closest", ServerId)
        else
         QBCore.Functions.Notify("Bir araçta eşlik edemezsin", "error")
       end
     end
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:get:escorted')
AddEventHandler('qb-police:client:get:escorted', function(PlayerId)
    if not Config.IsEscorted then
        Config.IsEscorted = true
        local dragger = GetPlayerPed(GetPlayerFromServerId(PlayerId))
        local heading = GetEntityHeading(dragger)
        SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(dragger, 0.0, 0.45, 0.0))
        AttachEntityToEntity(PlayerPedId(), dragger, 11816, 0.45, 0.45, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    else
        Config.IsEscorted = false
        DetachEntity(PlayerPedId(), true, false)
    end
end)

RegisterNetEvent('qb-police:client:PutPlayerInVehicle')
AddEventHandler('qb-police:client:PutPlayerInVehicle', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted  then
            TriggerServerEvent("qb-police:server:set:in:veh", ServerId)
        end
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:SetPlayerOutVehicle')
AddEventHandler('qb-police:client:SetPlayerOutVehicle', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local ServerId = GetPlayerServerId(Player)
        if not Config.IsHandCuffed and not Config.IsEscorted then
            TriggerServerEvent("qb-police:server:set:out:veh", ServerId)
        end
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:set:out:veh')
AddEventHandler('qb-police:client:set:out:veh', function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        TaskLeaveVehicle(PlayerPedId(), vehicle, 16)
    end
end)

RegisterNetEvent('qb-police:client:set:in:veh')
AddEventHandler('qb-police:client:set:in:veh', function()
    if Config.IsHandCuffed or Config.IsEscorted then
        local vehicle = QBCore.Functions.GetClosestVehicle()
        if DoesEntityExist(vehicle) then
			for i = GetVehicleMaxNumberOfPassengers(vehicle), -1, -1 do
                if IsVehicleSeatFree(vehicle, i) then
                    Config.IsEscorted = false
                    ClearPedTasks(PlayerPedId())
                    DetachEntity(PlayerPedId(), true, false)
                    Citizen.Wait(100)
                    SetPedIntoVehicle(PlayerPedId(), vehicle, i)
                    return
                end
            end
		end
    end
end)

RegisterNetEvent('qb-police:client:steal:closest')
AddEventHandler('qb-police:client:steal:closest', function()
    local player, distance = QBCore.Functions.GetClosestPlayer()
    if player ~= -1 and distance < 2.5 then
        local playerPed = GetPlayerPed(player)
        local playerId = GetPlayerServerId(player)
        if IsEntityPlayingAnim(playerPed, "missminuteman_1ig_2", "handsup_base", 3) or IsEntityPlayingAnim(playerPed, "mp_arresting", "idle", 3) or IsTargetDead(playerId) then
            QBCore.Functions.TriggerCallback('qb-police:server:is:inventory:disabled', function(IsDisabled)
                if not IsDisabled then
                    QBCore.Functions.Progressbar("robbing_player", "Stealing stuff..", math.random(5000, 7000), false, true, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "random@shop_robbery",
                        anim = "robbery_action_b",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        local plyCoords = GetEntityCoords(playerPed)
                        local pos = GetEntityCoords(PlayerPedId())
                        local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, plyCoords.x, plyCoords.y, plyCoords.z, true)
                        if dist < 2.5 then
                            StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                            TriggerServerEvent("qb-inventory:server:OpenInventory", "otherplayer", playerId)
                            TriggerEvent("qb-inventory:server:RobPlayer", playerId)
                        else
                            StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                            QBCore.Functions.Notify("Nobody nearby", "error")
                        end
                    end, function() -- Cancel
                        StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
                        QBCore.Functions.Notify("İptal Edildi..", "error")
                    end)
                else
                    QBCore.Functions.Notify("Soymaman Çok Kötü", "error")
                end
            end, playerId)
        end
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:search:closest')
AddEventHandler('qb-police:client:search:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(Player)
        TriggerServerEvent("qb-inventory:server:OpenInventory", "otherplayer", playerId)
        TriggerServerEvent("qb-police:server:SearchPlayer", playerId)
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:impound:closest')
AddEventHandler('qb-police:client:impound:closest', function() 
    local Vehicle, Distance = QBCore.Functions.GetClosestVehicle()
    if Vehicle ~= 0 and Distance < 1.7 then
        QBCore.Functions.Progressbar("impound-vehicle", "Removing vehicle..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             QBCore.Functions.DeleteVehicle(Vehicle)
             QBCore.Functions.Notify("Tamamlandı", "success")
        end, function()
            QBCore.Functions.Notify("İptal Edildi..", "error")
        end)
    else
        QBCore.Functions.Notify("No vehicle found nearby", "error")
    end
end)

RegisterNetEvent('qb-police:client:impound:hard:closest')
AddEventHandler('qb-police:client:impound:hard:closest', function() 
    local Vehicle, Distance = QBCore.Functions.GetClosestVehicle()
    local Plate = GetVehicleNumberPlateText(Vehicle)
    if Vehicle ~= 0 and Distance < 1.7 then
        QBCore.Functions.Progressbar("impound-vehicle", "El Koyulacak Araç..", math.random(10000, 15000), false, true, {
            disableMovement = true,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "random@mugging4",
            anim = "struggle_loop_b_thief",
            flags = 49,
        }, {}, {}, function() -- Done
             QBCore.Functions.DeleteVehicle(Vehicle)
             TriggerServerEvent("qb-police:server:impound:vehicle", Plate)
             QBCore.Functions.Notify("Tamamlandı", "success")
        end, function()
            QBCore.Functions.Notify("İptal Eildi..", "error")
        end)
    else
        QBCore.Functions.Notify("Etrafında Araç Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:enkelband:closest')
AddEventHandler('qb-police:client:enkelband:closest', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    if Player ~= -1 and Distance < 2.5 then
        local playerId = GetPlayerServerId(player)
        TriggerServerEvent("qb-police:server:set:tracker",  GetPlayerServerId(Player))
    else
        QBCore.Functions.Notify("Etrafında Kimse Yok", "error")
    end
end)

RegisterNetEvent('qb-police:client:set:tracker')
AddEventHandler('qb-police:client:set:tracker', function(bool)
    local trackerClothingData = {}
    if bool then
        trackerClothingData.outfitData = {["accessory"] = { item = 13, texture = 0}}
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    else
        trackerClothingData.outfitData = {["accessory"] = { item = -1, texture = 0}}
        TriggerEvent('qb-clothing:client:loadOutfit', trackerClothingData)
    end
end)

RegisterNetEvent('qb-police:client:send:tracker:location')
AddEventHandler('qb-police:client:send:tracker:location', function(RequestId)
    local Coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('qb-police:server:send:tracker:location', Coords, RequestId)
end)

RegisterNetEvent('qb-police:client:show:machine')
AddEventHandler('qb-police:client:show:machine', function(PlayerId)
    FingerPrintSession = PlayerId
    SendNUIMessage({
        type = "OpenFinger"
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('qb-police:client:show:fingerprint:id')
AddEventHandler('qb-police:client:show:fingerprint:id', function(FingerPrintId)
 SendNUIMessage({
     type = "UpdateFingerId",
     fingerprintId = FingerPrintId
 })
 PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
end)

RegisterNetEvent('qb-police:client:show:tablet')
AddEventHandler('qb-police:client:show:tablet', function()
    exports['qb-assets']:AddProp('Tablet')
    exports['qb-assets']:RequestAnimationDict('amb@code_human_in_bus_passenger_idles@female@tablet@base')
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "base", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(500)
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "databank",
    })
end)

RegisterNUICallback('ScanFinger', function(data)
    TriggerServerEvent('qb-police:server:showFingerId', FingerPrintSession)
end)

RegisterNetEvent('qb-police:client:spawn:vehicle')
AddEventHandler('qb-police:client:spawn:vehicle', function(VehicleName)
    if VehicleName ~= 'PolitieZulu' then
        local RandomCoords = Config.Locations['garage'][CurrentGarage]['Spawns'][math.random(1, #Config.Locations['garage'][CurrentGarage]['Spawns'])]
        local CoordTable = {x = RandomCoords['X'], y = RandomCoords['Y'], z = RandomCoords['Z'], a = RandomCoords['H']}    
        local CanSpawn = QBCore.Functions.IsSpawnPointClear(CoordTable, 2.0)
        if CanSpawn then
            QBCore.Functions.SpawnVehicle(VehicleName, function(Vehicle)
              SetVehicleNumberPlateText(Vehicle, QBCore.Functions.GetPlayerData().job.plate)
              Citizen.Wait(25)
              exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
              exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
              exports['qb-emergencylights']:SetupEmergencyVehicle(Vehicle)
              QBCore.Functions.Notify('Görev aracınız Park yerlerinden birine park edildi.', 'info')
            end, CoordTable, true, false)
        else
            QBCore.Functions.Notify('Bir şey yeri engelliyor...', 'info')
        end
    else
        local CoordTable = {x = 449.76, y = -980.87, z = 43.69, a = 90.57}
        local CanSpawn = QBCore.Functions.IsSpawnPointClear(CoordTable, 3.0)
        if CanSpawn then
            QBCore.Functions.SpawnVehicle('PolitieZulu', function(Vehicle)
             SetVehicleNumberPlateText(Vehicle, QBCore.Functions.GetPlayerData().job.plate)
             Citizen.Wait(25)
             exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(Vehicle), true)
             exports['qb-fuel']:SetFuelLevel(Vehicle, GetVehicleNumberPlateText(Vehicle), 100, false)
             QBCore.Functions.Notify('Helikopter çatıda hazır..', 'info')
            end, CoordTable, true, false)
        else
            QBCore.Functions.Notify('Helikopter pistinde engelleyen bir şey var.', 'info')
        end
    end
end)

RegisterNetEvent('qb-police:client:open:evidence')
AddEventHandler('qb-police:client:open:evidence', function(args)
 local Coords = GetEntityCoords(PlayerPedId())
 NearPolice = false
 for k, v in pairs(Locaties['Politie']) do
 local Gebied = GetDistanceBetweenCoords(Coords.x, Coords.y, Coords.z, v["x"], v["y"], v["z"], true)
   if Gebied <= 45.0 then
    NearPolice = true
     TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "evidencestash_"..args, {
         maxweight = 2500000,
         slots = 50,
     })
     TriggerEvent("qb-inventory:client:SetCurrentStash", "evidencestash_"..args)
   end
 end
 if not NearPolice then
    QBCore.Functions.Notify("Herhangi bir suç kaydı için güvenli bir kanıt oluşturmak için polis karakolunun yakınında olmanız gerekir.", "error")
 end
end)

RegisterNetEvent('qb-police:client:send:alert')
AddEventHandler('qb-police:client:send:alert', function(Message, Anoniem)
    local PlayerData = QBCore.Functions.GetPlayerData()
      if Anoniem then
        if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
         TriggerEvent('chatMessage', "ANONYMOUS CALL", "warning", Message)
         PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        end
      else
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent("qb-police:server:send:call:alert", PlayerCoords, Message)
        TriggerEvent("qb-police:client:call:anim")
      end
end)

RegisterNetEvent('qb-police:client:send:message')
AddEventHandler('qb-police:client:send:message', function(Coords, Message, Name)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('chatMessage', "911 CALL - " ..Name, "warning", Message)
        PlaySoundFrontend( -1, "Beep_Green", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
        AddAlert('112', 66, 250, Coords)
    end
end)

RegisterNetEvent('qb-police:client:call:anim')
AddEventHandler('qb-police:client:call:anim', function()
    local isCalling = true
    local callCount = 5
    exports['qb-assets']:RequestAnimationDict("cellphone@")
    TaskPlayAnim(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 3.0, -1, -1, 49, 0, false, false, false)
    Citizen.Wait(1000)
    Citizen.CreateThread(function()
        while isCalling do
            Citizen.Wait(1000)
            callCount = callCount - 1
            if callCount <= 0 then
                isCalling = false
                StopAnimTask(PlayerPedId(), 'cellphone@', 'cellphone_call_listen_base', 1.0)
            end
        end
    end)
end)

RegisterNetEvent('qb-police:client:spawn:object')
AddEventHandler('qb-police:client:spawn:object', function(Type)
    QBCore.Functions.Progressbar("spawn-object", "Yerleştiriliyor..", 2500, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@narcotics@trash",
        anim = "drop_front",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
        TriggerServerEvent("qb-police:server:spawn:object", Type)
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "anim@narcotics@trash", "drop_front", 1.0)
        QBCore.Functions.Notify("Cancelled..", "error")
    end)
end)

RegisterNetEvent('qb-police:client:delete:object')
AddEventHandler('qb-police:client:delete:object', function()
    local objectId, dist = GetClosestPoliceObject()
    if dist < 5.0 then
        QBCore.Functions.Progressbar("remove-object", "Kaldırılıyor..", 2500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
            anim = "plant_floor",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            TriggerServerEvent("qb-police:server:delete:object", objectId)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "weapons@first_person@aim_rng@generic@projectile@thermal_charge@", "plant_floor", 1.0)
            QBCore.Functions.Notify("Cancelled..", "error")
        end)
    end
end)

RegisterNetEvent('qb-police:client:place:object')
AddEventHandler('qb-police:client:place:object', function(objectId, type, player)
    local coords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(player)))
    local heading = GetEntityHeading(GetPlayerPed(GetPlayerFromServerId(player)))
    local forward = GetEntityForwardVector(PlayerPedId())
    local x, y, z = table.unpack(coords + forward * 0.5)
    local spawnedObj = CreateObject(Config.Objects[type].model, x, y, z, false, false, false)
    PlaceObjectOnGroundProperly(spawnedObj)
    SetEntityHeading(spawnedObj, heading)
    FreezeEntityPosition(spawnedObj, Config.Objects[type].freeze)
    ObjectList[objectId] = {
        id = objectId,
        object = spawnedObj,
        coords = {
            x = x,
            y = y,
            z = z - 0.3,
        },
    }
end)

RegisterNetEvent('qb-police:client:remove:object')
AddEventHandler('qb-police:client:remove:object', function(objectId)
    NetworkRequestControlOfEntity(ObjectList[objectId].object)
    DeleteObject(ObjectList[objectId].object)
    ObjectList[objectId] = nil
end)

RegisterNetEvent('qb-police:client:set:radio')
AddEventHandler('qb-police:client:set:radio', function()
 QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
    if HasItem then
        exports['qb-radio']:SetRadioState(true)
        exports['qb-radio']:JoinRadio(1, 1)
        QBCore.Functions.Notify("Connected with OC-01", "info", 8500)
    end
 end, "radio")
end)

-- // Functions \\ --

function CreateDutyBlips(playerId, playerLabel, playerJob)
	local ped = GetPlayerPed(playerId)
    local blip = GetBlipFromEntity(ped)
	if not DoesBlipExist(blip) then
		blip = AddBlipForEntity(ped)
		SetBlipSprite(blip, 480)
        SetBlipScale(blip, 1.0)
        if playerJob == "police" then
            SetBlipColour(blip, 38)
        else
            SetBlipColour(blip, 35)
        end
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(playerLabel)
        EndTextCommandSetBlipName(blip)
		table.insert(DutyBlips, blip)
	end
end

function HandCuffAnimation()
 exports['qb-assets']:RequestAnimationDict("mp_arrest_paired")
 Citizen.Wait(100)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "cop_p2_back_right", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
 Citizen.Wait(3500)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "exit", 3.0, 3.0, -1, 48, 0, 0, 0, 0)
end

function GetCuffedAnimation(playerId)
 local cuffer = GetPlayerPed(GetPlayerFromServerId(playerId))
 local heading = GetEntityHeading(cuffer)
 exports['qb-assets']:RequestAnimationDict("mp_arrest_paired")
 TriggerServerEvent('qb-sound:server:play:distance', 2.0, 'handcuff', 0.2)
 SetEntityCoords(PlayerPedId(), GetOffsetFromEntityInWorldCoords(cuffer, 0.0, 0.45, 0.0))
 Citizen.Wait(100)
 SetEntityHeading(PlayerPedId(), heading)
 TaskPlayAnim(PlayerPedId(), "mp_arrest_paired", "crook_p2_back_right", 3.0, 3.0, -1, 32, 0, 0, 0, 0)
 Citizen.Wait(2500)
end

function GetClosestPoliceObject()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    for id, data in pairs(ObjectList) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ObjectList[id].coords.x, ObjectList[id].coords.y, ObjectList[id].coords.z, true)
            current = id
        end
    end
    return current, dist
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

function IsTargetDead(playerId)
 local IsDead = false
  QBCore.Functions.TriggerCallback('qb-police:server:is:player:dead', function(result)
    IsDead = result
  end, playerId)
  Citizen.Wait(100)
  return IsDead
end

function GetVehicleList()
    local VehicleData = QBCore.Functions.GetPlayerData().metadata['duty-vehicles']
    local Vehicles = {}
    if VehicleData.Standard then
        table.insert(Vehicles, "police:vehicle:touran")
        table.insert(Vehicles, "police:vehicle:klasse")
        table.insert(Vehicles, "police:vehicle:vito")
        table.insert(Vehicles, "vehicle:delete")
    end
    if VehicleData.Audi then
        table.insert(Vehicles, "police:vehicle:audi")
    end
    if VehicleData.Unmarked then
        table.insert(Vehicles, "police:vehicle:velar")
        table.insert(Vehicles, "police:vehicle:bmw")
        table.insert(Vehicles, "police:vehicle:unmaked:audi")
    end
    if VehicleData.Heli then 
        table.insert(Vehicles, "police:vehicle:heli")
    end
    if VehicleData.Motor then
        table.insert(Vehicles, "police:vehicle:motor")
    end
    return Vehicles
end

function SetWeaponSeries()
 Config.Items.items[1].info.serie = QBCore.Functions.GetPlayerData().job.serial
 Config.Items.items[2].info.serie = QBCore.Functions.GetPlayerData().job.serial
 Config.Items.items[3].info.serie = QBCore.Functions.GetPlayerData().job.serial
end

function GetGarageStatus()
    return NearPoliceGarage
end

function GetEscortStatus()
    return Config.IsEscorted
end

function GetImpoundStatus()
    return NearPoliceImpound
end


function MenuImpound()
    ped = PlayerPedId();
    MenuTitle = "Ek Koyulanlar"
    ClearMenu()
    Menu.addButton("Araçlar", "ImpoundVehicleList", nil)
    Menu.addButton("Menuyü Kapat", "closeMenuFull", nil) 
end

function ImpoundVehicleList()
    QBCore.Functions.TriggerCallback("qb-police:GetImpoundedVehicles", function(result)
        ped = PlayerPedId();
        MenuTitle = "Araçlar:"
        ClearMenu()

        if result == nil then
            QBCore.Functions.Notify("El koyulan araç yok!", "error", 5000)
            closeMenuFull()
        else
            for k, v in pairs(result) do
                Menu.addButton(QBCore.Shared.Vehicles[v.vehicle]["name"], "TakeOutImpound", v, "Confiscated")
            end
        end
            
        Menu.addButton("Geri", "MenuImpound",nil)
    end)
end

function TakeOutImpound(vehicle)
    local coords = Config.Locations["impound"]
    QBCore.Functions.SpawnVehicle(vehicle.vehicle, function(veh)
       -- QBCore.Functions.TriggerCallback('qb-garage:server:GetVehicleProperties', function(properties)
            --QBCore.Functions.SetVehicleProperties(veh, properties)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, coords.h)
            closeMenuFull()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
            exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100.0, false)
            SetVehicleEngineOn(veh, true, true)
       -- end, vehicle.plate)
    end, coords['X'], coords['Y'], coords['Z'], true)
end

function closeMenuFull()
    Menu.hidden = true
    currentGarage = nil
    ClearMenu()
end

function SpawnIncheckProp()
    local SpawnModel = GetHashKey('v_ind_cs_bucket')
    exports['qb-assets']:RequestModelHash(SpawnModel)
    local Object = CreateObject(SpawnModel, 441.80, -982.02, 30.4, false, false, false)
    SetEntityHeading(Object, 265.15)
    FreezeEntityPosition(Object, true)
    SetEntityInvincible(Object, true)
    SetEntityVisible(Object, false)
end

RegisterNUICallback('CloseNui', function()
 SetNuiFocus(false, false)
 if exports['qb-assets']:GetPropStatus() then
    exports['qb-assets']:RemoveProp()
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@base", "exit", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
 end
end)