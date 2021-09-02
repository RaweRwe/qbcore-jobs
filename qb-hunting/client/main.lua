local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

QBCore = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)
Citizen.CreateThread(function()
	AddTextEntry("Hunting", "Hunting Spot")
	for k, v in pairs(Config.Hunting) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 141)
		SetBlipColour(blip, 0)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Hunt")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
	AddTextEntry("Butcher", "Butcher Shop")
	for k, v in pairs(Config.Butcher) do
		local blip = AddBlipForCoord(v)
		SetBlipSprite(blip, 463)
		SetBlipColour(blip, 25)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("Butcher")
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
 ScriptLoaded()
end)

local OnGoingHuntSession = false
local veh = nil

local cord = {x=-1492.86, y = 4971.34, z = 63.91}

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
local coords = GetEntityCoords(PlayerPedId())
local distance = Vdist(coords.x, coords.y, coords.z, cord.x, cord.y, cord.z)
if not OnGoingHuntSession and distance < 5 then
    DrawText3D(cord.x, cord.y, cord.z, "[E] Start hunting")
    DrawMarker(27, cord.x, cord.y, cord.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end
if OnGoingHuntSession and distance < 5 then
    DrawText3D(cord.x, cord.y, cord.z, "[E] Stop hunting")
    DrawMarker(27, cord.x, cord.y, cord.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end
if not OnGoingHuntSession and distance < 2 then
	if IsControlJustPressed(0, 38) then
        OnGoingHuntSession = true
		StartHuntingSession()
	    Citizen.Wait(0)
	end
end

if OnGoingHuntSession and distance < 2 then
	if IsControlJustPressed(0, 38) then
        OnGoingHuntSession = false
        RemoveBlip(AnimalBlip)
        DeleteEntity(Animal)
	Citizen.Wait(0)
end
end
	end
end)

local cordsell = {x=-66.8, y = 6237.96, z = 31.09}

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
local coords = GetEntityCoords(PlayerPedId())
local distance = Vdist(coords.x, coords.y, coords.z, cordsell.x, cordsell.y, cordsell.z)
if distance < 5 then
    DrawText3D(cordsell.x, cordsell.y, cordsell.z, "[E] Sell Meat and Leather")
    DrawMarker(27, cordsell.x, cordsell.y, cordsell.z-0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 255, 15, 150, false, false, 2, true, nil, nil, false)
end

if distance < 2 then
    if IsControlJustPressed(0, 38) then
		SellMeat()
Citizen.Wait(0)
end
end
	end
end)
				
		




function ScriptLoaded()
	Citizen.Wait(1000)
	LoadMarkers()
end

local AnimalPositions = {
	{ x = -1505.2, y = 4887.39, z = 78.38 },
	{ x = -1164.68, y = 4806.76, z = 223.11 },
	{ x = -1410.63, y = 4730.94, z = 44.0369 },
	{ x = -1377.29, y = 4864.31, z = 134.162 },
	{ x = -1697.63, y = 4652.71, z = 22.2442 },
	{ x = -1259.99, y = 5002.75, z = 151.36 },
	{ x = -960.91, y = 5001.16, z = 183.0 },
}

local AnimalsInSession = {}

local Positions = {
	['StartHunting'] = { ['hint'] = '[E] Start hunting', ['x'] = -1492.86, ['y'] = 4971.34, ['z'] = 63.91 },
	['Sell'] = { ['hint'] = '[E] Sell ​​meat', ['x'] = -66.8, ['y'] = 6237.96, ['z'] = 31.09 },
	['SpawnATV'] = { ['hint'] = '[E] Get an ATV', ['x'] = -1489.8, ['y'] = 4974.8, ['z'] = 63.75 },
}

local OnGoingHuntSession = false
local HuntCar = nil

function LoadMarkers()

	Citizen.CreateThread(function()
		for k, v in ipairs(Positions) do
			if k ~= 'SpawnATV' then
				local StartBlip = AddBlipForCoord(v.x, v.y, v.z)
				SetBlipSprite(StartBlip, 442)
				SetBlipColour(StartBlip, 75)
				SetBlipScale(StartBlip, 0.7)
				SetBlipAsShortRange(StartBlip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Hunting place')
				EndTextCommandSetBlipName(StartBlip)
			end
		end
	end)

	LoadModel('blazer')
	LoadModel('a_c_deer')
	LoadAnimDict('amb@medic@standing@kneel@base')
    LoadAnimDict('anim@gangops@facility@servers@bodysearch@')

end

function StartHuntingSession()

	if OnGoingHuntSession then

		OnGoingHuntSession = false
		TriggerServerEvent('qb-hunting:server:remove:knife')
		--[[RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"), true, true)
		RemoveWeaponFromPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"), true, true)]]--
		
		DeleteEntity(HuntCar)

		for index, value in pairs(AnimalsInSession) do
			if DoesEntityExist(value.id) then
				DeleteEntity(value.id)
			end
		end

	else
		OnGoingHuntSession = true

		TriggerServerEvent('qb-hunting:server:recieve:knife')
		--Car
		--[[HuntCar = CreateVehicle(GetHashKey('blazer'), Positions['SpawnATV'].x, Positions['SpawnATV'].y, Positions['SpawnATV'].z, 169.79, true, false)

		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_MUSKET"),0, true, false)
		GiveWeaponToPed(PlayerPedId(), GetHashKey("WEAPON_KNIFE"),0, true, false)]]--
		
		--Animals

		Citizen.CreateThread(function()

				
			for index, value in pairs(AnimalPositions) do
				local Animal = CreatePed(5, GetHashKey('a_c_deer'), value.x, value.y, value.z, 0.0, true, false)
				TaskWanderStandard(Animal, true, true)
				SetEntityAsMissionEntity(Animal, true, true)
				--Blips

				local AnimalBlip = AddBlipForEntity(Animal)
				SetBlipSprite(AnimalBlip, 153)
				SetBlipColour(AnimalBlip, 1)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString('Deer - Animal')
				EndTextCommandSetBlipName(AnimalBlip)

				table.insert(AnimalsInSession, {id = Animal, x = value.x, y = value.y, z = value.z, Blipid = AnimalBlip})
			end

			while OnGoingHuntSession do
				local sleep = 500
				for index, value in ipairs(AnimalsInSession) do
					if DoesEntityExist(value.id) then
						local AnimalCoords = GetEntityCoords(value.id)
						local PlyCoords = GetEntityCoords(PlayerPedId())
						local AnimalHealth = GetEntityHealth(value.id)
						
						local PlyToAnimal = GetDistanceBetweenCoords(PlyCoords, AnimalCoords, true)

						if AnimalHealth <= 0 then
							SetBlipColour(value.Blipid, 3)
							if PlyToAnimal < 2.0 then
								sleep = 5

								DrawText3D(AnimalCoords.x,AnimalCoords.y,AnimalCoords.z + 1, '[E] Skinn animal')

								if IsControlJustReleased(0, Keys['E']) then
                                    --if HasValidWeapon() then
										if DoesEntityExist(value.id) then
											table.remove(AnimalsInSession, index)
											SlaughterAnimal(value.id)
										end
                                    --else
                                    --Citizen.Wait(100)
                                   -- QBCore.Functions.Notify("You need to use the knife!")
									--end
								end

							end
						end
					end
				end

				Citizen.Wait(sleep)

			end
				
		end)
	end
end


function HasValidWeapon()
	local CurrentWeapon = GetSelectedPedWeapon(PlayerPedId())
	for k, v in pairs(Config.HuntWeapons) do
	  if CurrentWeapon == v then
		  return true
	  end
	end
  end
function SlaughterAnimal(AnimalId)

	TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
	TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

	Citizen.Wait(5000)

	ClearPedTasksImmediately(PlayerPedId())

	local AnimalWeight = math.random(10, 160) / 10

    QBCore.Functions.Notify('You skinned an animal. Weight: ' ..AnimalWeight.. 'kg')

	TriggerServerEvent('qb-hunt:reward', AnimalWeight)

	DeleteEntity(AnimalId)
end

function SellItems()
	TriggerServerEvent('qb-hunt:sell')
end

function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(10)
    end    
end

function LoadModel(model)
    while not HasModelLoaded(model) do
          RequestModel(model)
          Citizen.Wait(10)
    end
end

function DrawM(type, x, y, z)
	DrawMarker(type, x, y, z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, false, true, 2, false, false, false, false)
end

function DrawText3D(x, y, z, text)
	SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 400
    DrawRect(0.0, 0.0+0.0110, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function SellMeat()
    QBCore.Functions.TriggerCallback('qb-hunting:server:has:meat', function(HasMeat)
        if HasMeat then
			QBCore.Functions.Progressbar("selling-meat", "Selling meat..", 15000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function() -- Done 
				TriggerServerEvent("qb-hunt:sell")
				StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
         end, function() -- Cancel
             StopAnimTask(PlayerPedId(), "random@shop_robbery", "robbery_action_b", 1.0)
             QBCore.Functions.Notify("Cancelled..", "error")
         end)
        else
			QBCore.Functions.Notify("You have no meat to sell..", "error", 2500)
        end
    end)
end