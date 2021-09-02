local TotalPain = 0
local TotalBroken = 0
local LastDamage, Bone = {}
local DamageDone = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               LastDamage, Bone = GetPedLastDamageBone(PlayerPedId())
               if Bone ~= LastBone then
                  if Config.BodyParts[Bone] ~= 'NONE' then
                      ApplyDamageToBodyPart(Config.BodyParts[Bone])
                      LastBone = Bone
                  end
               else
                   Citizen.Wait(100)
               end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               for k, v in pairs(Config.BodyHealth) do
                   Citizen.Wait(10)
                   if v['Health'] <= 2 and not v['IsDead'] then
                       if not v['Pain'] then
                           v['Pain'] = true
                           TotalPain = TotalPain + 1
                       else
                           Citizen.Wait(150)
                       end
                   else
                       Citizen.Wait(150)         
                   end
               end
            end
        else
            Citizen.Wait(1500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            if not Config.IsDeath then
               for k, v in pairs(Config.BodyHealth) do
                   Citizen.Wait(25)
                   if v['Pain'] then
                      if TotalPain > 1 then
                        QBCore.Functions.Notify("You are in serious pain on several spots..", 'info')
                      else
                        QBCore.Functions.Notify("You are struggling with pain in your "..v['Name']..'..', 'info')
                      end
                      ApplyDamageToBodyPart(k)
                      HurtPlayer(TotalPain)
                      Citizen.Wait(30000)
                    elseif not v['Pain'] and v['IsDead'] then
                        if TotalBroken > 1 then
                            QBCore.Functions.Notify("Multiple broken bones..", 'error')
                        else
                            QBCore.Functions.Notify("Your "..v['Name'].. ' is broken..', 'error')
                        end
                        if k == 'HEAD' then
                            if math.random(1, 100) <= 55 then
                                BlackOut()
                            end
    
                        elseif k == 'LLEG' or k == 'RLEG' or k == 'LFOOT' or k == 'RFOOT' then
                            if math.random(1, 100) < 50 then
                                SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                            end
                        end
                        Citizen.Wait(30000)
                    end
                    Citizen.Wait(150)
               end
            else
                Citizen.Wait(1500)
            end
        end
    end
end)

-- // Events \\ -- 

RegisterNetEvent('qb-hospital:client:use:bandage')
AddEventHandler('qb-hospital:client:use:bandage', function()
  Citizen.SetTimeout(1000, function()
     exports['qb-assets']:AddProp('HealthPack')
     QBCore.Functions.Progressbar("use_bandage", "Verband omdoen..", 4000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
     	disableMouse = false,
     	disableCombat = true,
     }, {
     	animDict = "anim@amb@business@weed@weed_inspecting_high_dry@",
     	anim = "weed_inspecting_high_base_inspector",
     	flags = 49,
     }, {}, {}, function() -- Done
         exports['qb-assets']:RemoveProp()
         HealRandomBodyPart()
         TriggerServerEvent('QBCore:Server:RemoveItem', 'bandage', 1)
         TriggerEvent("qb-inventory:client:ItemBox", QBCore.Shared.Items['bandage'], "remove")
         StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
         SetEntityHealth(PlayerPedId(), GetEntityHealth(PlayerPedId()) + 10)
     end, function() -- Cancel
         exports['qb-assets']:RemoveProp()
         StopAnimTask(PlayerPedId(), "anim@amb@business@weed@weed_inspecting_high_dry@", "weed_inspecting_high_base_inspector", 1.0)
         QBCore.Functions.Notify("Failed", "error")
     end)
  end)
end)

RegisterNetEvent('qb-hospital:client:use:health-pack')
AddEventHandler('qb-hospital:client:use:health-pack', function()
    local Player, Distance = QBCore.Functions.GetClosestPlayer()
    local RandomTime = math.random(15000, 20000)
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
             TriggerServerEvent("QBCore:Server:RemoveItem", "health-pack", 1)
             TriggerEvent("qb-inventory:client:ItemBox", QBCore.Shared.Items["health-pack"], "remove")
             TriggerServerEvent('qb-hospital:server:revive:player', GetPlayerServerId(Player))
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
             QBCore.Functions.Notify("You helped the citizen!")
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), 'mini@cpr@char_a@cpr_str', "cpr_pumpchest", 1.0)
             QBCore.Functions.Notify("Failed!", "error")
         end)
        else
            QBCore.Functions.Notify("Citizen is not unconscious..", "error")
        end
    end
end)

RegisterNetEvent('qb-hospital:client:use:painkillers')
AddEventHandler('qb-hospital:client:use:painkillers', function()
    Citizen.SetTimeout(1000, function()
        if not Config.OnOxy then
        QBCore.Functions.Progressbar("use_bandage", "Taking Oxycodons..", 3000, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "mp_suicide",
            anim = "pill",
            flags = 49,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
            TriggerServerEvent("QBCore:Server:RemoveItem", "painkillers", 1)
            TriggerEvent("qb-inventory:client:ItemBox", QBCore.Shared.Items["painkillers"], "remove")
            Config.OnOxy = true
            Citizen.SetTimeout(60000, function()
                Config.OnOxy = false
             end)
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
            QBCore.Functions.Notify("Failed", "error")
        end)
       else
         QBCore.Functions.Notify("You still have remains ofoxycodon in your body..", "error")
       end 
    end)
end)

-- // Functions \\ --

function ApplyDamageToBodyPart(BodyPart)
    if not Config.OnOxy then
       if BodyPart == 'LLEG' or BodyPart == 'RLEG' or BodyPart == 'LFOOT' or BodyPart == 'RFOOT' then
           if math.random(1, 100) < 50 then
             SetPedToRagdollWithFall(PlayerPedId(), 2500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
           end
       elseif BodyPart == 'HEAD' and Config.BodyHealth['HEAD']['Health'] < 2 and not Config.BodyHealth['HEAD']['IsDead'] then
           if math.random(1, 100) < 35 then
             BlackOut()
           end
       end
   
       if Config.BodyHealth[BodyPart]['Health'] > 0 and not Config.BodyHealth[BodyPart]['IsDead'] then
           Config.BodyHealth[BodyPart]['Health'] = Config.BodyHealth[BodyPart]['Health'] - 1
       elseif Config.BodyHealth[BodyPart]['Health'] == 0 then
           if not Config.BodyHealth[BodyPart]['IsDead'] and Config.BodyHealth[BodyPart]['CanDie'] then
               Config.BodyHealth[BodyPart]['Pain'] = false
               Config.BodyHealth[BodyPart]['IsDead'] = true
               TotalPain = TotalPain - 1
               TotalBroken = TotalBroken + 1
           end
       end
    end
    while IsPedRagdoll(PlayerPedId()) do
      Citizen.Wait(10)
    end
    TriggerServerEvent('qb-police:server:CreateBloodDrop', GetEntityCoords(PlayerPedId()))
end 

function HurtPlayer(Multiplier)
  local CurrentHealth = GetEntityHealth(PlayerPedId())
  local NewHealth = CurrentHealth - math.random(1,8) * Multiplier
  if not Config.OnOxy then
    SetEntityHealth(PlayerPedId(), NewHealth)
  end
end

function BlackOut()
 if not Config.OnOxy then
    SetFlash(0, 0, 100, 4000, 100)
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    if IsPedOnFoot(PlayerPedId()) and not IsPedRagdoll(PlayerPedId()) and not IsPedSwimming(PlayerPedId()) then
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
        SetPedToRagdollWithFall(PlayerPedId(), 7500, 9000, 1, GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    Citizen.Wait(1500)
    DoScreenFadeIn(1000)
    Citizen.Wait(1000)
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do
        Citizen.Wait(0)
    end
    Citizen.Wait(500)
    DoScreenFadeIn(700)
 end
end

function HealRandomBodyPart()
  for k,v in pairs(Config.BodyHealth) do
      if not v['IsDead'] then
        if v['Pain'] then
            if v['Health'] < 4 then
                v['Health'] = v['Health'] + 1.0 
            end

            if v['Health'] == 4 then
                v['Pain'] = false
                TotalPain = TotalPain - 1
            end

        end
      end
  end
end

function ResetBodyHp()
    for k,v in pairs(Config.BodyHealth) do
        v['Health'] = Config.MaxBodyPartHealth
        v['IsDead'] = false
        v['Pain'] = false
        TotalPain = 0
        TotalBroken = 0
    end
end