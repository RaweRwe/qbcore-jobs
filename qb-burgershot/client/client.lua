local QBCore = exports['qb-core']:GetCoreObject()

local CurrentWorkObject = {}
local LoggedIn = false
local InRange = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  Citizen.SetTimeout(1250, function()
    Citizen.Wait(450)
    LoggedIn = true
  end)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
	RemoveWorkObjects()
  LoggedIn = false
end)

-- Code

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(4)
      if LoggedIn then
          local PlayerCoords = GetEntityCoords(PlayerPedId())
          local Distance = GetDistanceBetweenCoords(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, -1193.70, -892.50, 13.99, true)
          InRange = false
          if Distance < 40.0 then
              InRange = true
              if not Config.EntitysSpawned then
                  Config.EntitysSpawned = true
                  SpawnWorkObjects()
              end
          end
          if not InRange then
              if Config.EntitysSpawned then
                Config.EntitysSpawned = false
                RemoveWorkObjects()
              end
              CheckDuty()
              Citizen.Wait(1500)
          end
      end
  end
end)

-- // Events \\ --

RegisterNetEvent('qb-burgershot:client:refresh:props')
AddEventHandler('qb-burgershot:client:refresh:props', function()
  if InRange and Config.EntitysSpawned then
     RemoveWorkObjects()
     Citizen.SetTimeout(1000, function()
        SpawnWorkObjects()
     end)
  end
end)

RegisterNetEvent('qb-burgershot:client:open:payment')
AddEventHandler('qb-burgershot:client:open:payment', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenPayment', payments = Config.ActivePayments})
end)

RegisterNetEvent('qb-burgershot:client:open:register')
AddEventHandler('qb-burgershot:client:open:register', function()
  SetNuiFocus(true, true)
  SendNUIMessage({action = 'OpenRegister'})
end)

RegisterNetEvent('qb-burgershot:client:sync:register')
AddEventHandler('qb-burgershot:client:sync:register', function(RegisterConfig)
  Config.ActivePayments = RegisterConfig
end)

RegisterNetEvent('qb-burgershot:client:open:box')
AddEventHandler('qb-burgershot:client:open:box', function(BoxId)
    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", 'burgerbox_'..BoxId, {maxweight = 5000, slots = 3})
    TriggerEvent("qb-inventory:client:SetCurrentStash", 'burgerbox_'..BoxId)
end)

RegisterNetEvent('qb-burgershot:client:open:cold:storage')
AddEventHandler('qb-burgershot:client:open:cold:storage', function()
    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "burger_storage", {maxweight = 1000000, slots = 10})
    TriggerEvent("qb-inventory:client:SetCurrentStash", "burger_storage")
end)

RegisterNetEvent('qb-burgershot:client:open:hot:storage')
AddEventHandler('qb-burgershot:client:open:hot:storage', function()
    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "warmtebak", {maxweight = 1000000, slots = 10})
    TriggerEvent("qb-inventory:client:SetCurrentStash", "warmtebak")
end)

RegisterNetEvent('qb-burgershot:client:open:tray')
AddEventHandler('qb-burgershot:client:open:tray', function(Numbers)
    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "foodtray"..Numbers, {maxweight = 100000, slots = 3})
    TriggerEvent("qb-inventory:client:SetCurrentStash", "foodtray"..Numbers)
end)

RegisterNetEvent('qb-burgershot:client:create:burger')
AddEventHandler('qb-burgershot:client:create:burger', function(BurgerType)
  QBCore.Functions.TriggerCallback('qb-burgershot:server:has:burger:items', function(HasBurgerItems)
    if HasBurgerItems then
       MakeBurger(BurgerType)
    else
      QBCore.Functions.Notify("You are missing ingredients to make this sandwich..", "error")
    end
  end)
end)

RegisterNetEvent('qb-burgershot:client:create:drink')
AddEventHandler('qb-burgershot:client:create:drink', function(DrinkType)
    MakeDrink(DrinkType)
end)

RegisterNetEvent('qb-burgershot:client:bake:fries')
AddEventHandler('qb-burgershot:client:bake:fries', function()
  QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
    if HasItem then
       MakeFries()
    else
      QBCore.Functions.Notify("You miss pattatekes..", "error")
    end
  end, 'burger-potato')
end)

RegisterNetEvent('qb-burgershot:client:bake:meat')
AddEventHandler('qb-burgershot:client:bake:meat', function()
  QBCore.Functions.TriggerCallback('QBCore:HasItem', function(HasItem)
    if HasItem then
       MakePatty()
    else
      QBCore.Functions.Notify("Je mist vlees..", "error")
    end
  end, 'burger-raw')
end)

-- // functions \\ --

function SpawnWorkObjects()
  for k, v in pairs(Config.WorkProps) do
    exports['qb-assets']:RequestModelHash(v['Prop'])
    WorkObject = CreateObject(GetHashKey(v['Prop']), v["Coords"]["X"], v["Coords"]["Y"], v["Coords"]["Z"], false, false, false)
    SetEntityHeading(WorkObject, v['Coords']['H'])
    if v['PlaceOnGround'] then
    	PlaceObjectOnGroundProperly(WorkObject)
    end
    if not v['ShowItem'] then
    	SetEntityVisible(WorkObject, false)
    end
    SetModelAsNoLongerNeeded(WorkObject)
    FreezeEntityPosition(WorkObject, true)
    SetEntityInvincible(WorkObject, true)
    table.insert(CurrentWorkObject, WorkObject)
    Citizen.Wait(50)
  end
end

function MakeBurger(BurgerName)
  Citizen.SetTimeout(750, function()
    TriggerEvent('qb-inventory:client:set:busy', true)
    exports['qb-assets']:RequestAnimationDict("mini@repair")
    TaskPlayAnim(PlayerPedId(), "mini@repair", "fixing_a_ped" ,3.0, 3.0, -1, 8, 0, false, false, false)
    QBCore.Functions.Progressbar("open-brick", "Hamburger Making..", 7500, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('qb-burgershot:server:finish:burger', BurgerName)
        TriggerEvent('qb-inventory:client:set:busy', false)
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end, function()
        TriggerEvent('qb-inventory:client:set:busy', false)
        QBCore.Functions.Notify("Canceled..", "error")
        StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
    end)
  end)
end

function MakeFries()
  TriggerEvent('qb-inventory:client:set:busy', true)
  TriggerEvent("qb-sound:client:play", "baking", 0.7)
  exports['qb-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  QBCore.Functions.Progressbar("open-brick", "Baking fries.", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {
      model = "prop_cs_fork",
      bone = 28422,
      coords = { x = -0.005, y = 0.00, z = 0.00 },
      rotation = { x = 175.0, y = 160.0, z = 0.0 },
  }, {}, function() -- Done
      TriggerServerEvent('qb-burgershot:server:finish:fries')
      TriggerEvent('qb-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
      TriggerEvent('qb-inventory:client:set:busy', false)
      QBCore.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakePatty()
  TriggerEvent('qb-inventory:client:set:busy', true)
  TriggerEvent("qb-sound:client:play", "baking", 0.7)
  exports['qb-assets']:RequestAnimationDict("amb@prop_human_bbq@male@base")
  TaskPlayAnim(PlayerPedId(), "amb@prop_human_bbq@male@base", "base" ,3.0, 3.0, -1, 8, 0, false, false, false)
  QBCore.Functions.Progressbar("open-brick", "Burger Baking..", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {
      model = "prop_cs_fork",
      bone = 28422,
      coords = { x = -0.005, y = 0.00, z = 0.00},
      rotation = { x = 175.0, y = 160.0, z = 0.0},
  }, {}, function() -- Done
      TriggerServerEvent('qb-burgershot:server:finish:patty')
      TriggerEvent('qb-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end, function()
      TriggerEvent('qb-inventory:client:set:busy', false)
      QBCore.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@prop_human_bbq@male@base", "base", 1.0)
  end)
end

function MakeDrink(DrinkName)
  TriggerEvent('qb-inventory:client:set:busy', true)
  TriggerEvent("qb-sound:client:play", "pour-drink", 0.4)
  exports['qb-assets']:RequestAnimationDict("amb@world_human_hang_out_street@female_hold_arm@idle_a")
  TaskPlayAnim(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a" ,3.0, 3.0, -1, 8, 0, false, false, false)
  QBCore.Functions.Progressbar("open-brick", "Drink Tapping..", 6500, false, true, {
      disableMovement = true,
      disableCarMovement = false,
      disableMouse = false,
      disableCombat = true,
  }, {}, {}, {}, function() -- Done
      TriggerServerEvent('qb-burgershot:server:finish:drink', DrinkName)
      TriggerEvent('qb-inventory:client:set:busy', false)
      StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end, function()
      TriggerEvent('qb-inventory:client:set:busy', false)
      QBCore.Functions.Notify("Canceled..", "error")
      StopAnimTask(PlayerPedId(), "amb@world_human_hang_out_street@female_hold_arm@idle_a", "idle_a", 1.0)
  end)
end

function CheckDuty()
  if QBCore.Functions.GetPlayerData().job.name =='burger' and QBCore.Functions.GetPlayerData().job.onduty then
     TriggerServerEvent('QBCore:ToggleDuty')
     QBCore.Functions.Notify("You're too late from work while clocked in!", "error")
  end
end

function RemoveWorkObjects()
  for k, v in pairs(CurrentWorkObject) do
  	 DeleteEntity(v)
  end
end

function GetActiveRegister()
  return Config.ActivePayments
end

RegisterNUICallback('Click', function()
  PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('ErrorClick', function()
  PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
end)

RegisterNUICallback('AddPrice', function(data)
  TriggerServerEvent('qb-burgershot:server:add:to:register', data.Price, data.Note)
end)

RegisterNUICallback('PayReceipt', function(data)
  TriggerServerEvent('qb-burgershot:server:pay:receipt', data.Price, data.Note, data.Id)
end)

RegisterNUICallback('CloseNui', function()
  SetNuiFocus(false, false)
end)