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

local QBCore = exports['qb-core']:GetCoreObject()

------------------CONFIG----------------------
local startX = 2388.37  --starting
local startY = 5045.8
local startZ = 46.37

local startX1 = 2391.0744  --starting
local startY1 = 5052.3901
local startZ1 = 46.37
---------------------------------------------
local portionX = 994.32806   --Portion
local portionY = -2162.437
local portionZ = 30.41061
---
local portionX2 = 975.0075   --Portion
local portionY2 = -2119.813
local portionZ2 = 31.390176
---
local packingX = 985.26623    --Pack
local packingY = -2120.646
local packingZ = 30.475364
---
local packingX2 = 981.48278   --Pack
local packingY2 = -2124.006
local packingZ2 = 30.475244


local pig1
local pig2
local pig3
local Caught1 = 0
local Caught2 = 0
local Caught3 = 0
local beef1
local beef2
local beef3
local Caught4 = 0
local Caught5 = 0
local Caught6 = 0
local andsplashed = 0
local andsplashed1 = 0
local share = false
local prop
local zapakowaneDoauta = false
local karton
local mieso
local packs = 0
local PlayerJob = {}
local isLoggedIn = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
	QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
    isLoggedIn = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    --[[ RemoveMiningBlips() ]]
    isLoggedIn = false
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
	if PlayerJob.name == "butcher" then
		
	local lapaniek = AddBlipForCoord(startX, startY, startZ)
	SetBlipSprite (lapaniek, 126)
	SetBlipDisplay(lapaniek, 4)
	SetBlipScale  (lapaniek, 0.6)
	SetBlipColour (lapaniek, 46)
	SetBlipAsShortRange(lapaniek, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Meat Farm')
	EndTextCommandSetBlipName(lapaniek)
	local rzeznia = AddBlipForCoord(portionX, portionY, portionZ)
	SetBlipSprite (rzeznia, 126)
	SetBlipDisplay(rzeznia, 4)
	SetBlipScale  (rzeznia, 0.7)
	SetBlipColour (rzeznia, 46)
	SetBlipAsShortRange(rzeznia, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('Raven Slaughterhouse')
	EndTextCommandSetBlipName(rzeznia)
	end
end)

-- RegisterNetEvent('QBCore:Client:OnJobUpdate')
-- AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
--     local OldlayerJob = PlayerJob.name
--     PlayerJob = JobInfo

--     if PlayerJob.name == "butcher" then 
--         while QBCore.Functions.GetPlayerData().job == nil do Wait(0) end
    
-- 	local lapaniek = AddBlipForCoord(startX, startY, startZ)
-- 		SetBlipSprite (lapaniek, 126)
-- 		SetBlipDisplay(lapaniek, 4)
-- 		SetBlipScale  (lapaniek, 0.6)
-- 		SetBlipColour (lapaniek, 46)
-- 		SetBlipAsShortRange(lapaniek, true)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString('Meat Farm')
-- 		EndTextCommandSetBlipName(lapaniek)
-- 	local rzeznia = AddBlipForCoord(portionX, portionY, portionZ)
-- 		SetBlipSprite (rzeznia, 126)
-- 		SetBlipDisplay(rzeznia, 4)
-- 		SetBlipScale  (rzeznia, 0.7)
-- 		SetBlipColour (rzeznia, 46)
-- 		SetBlipAsShortRange(rzeznia, true)
-- 		BeginTextCommandSetBlipName("STRING")
-- 		AddTextComponentString('Raven Slaughterhouse')
-- 		EndTextCommandSetBlipName(rzeznia)
-- 	end
-- end)

CreateThread(function()
    while true do
        pedId = PlayerPedId()
        plyId = PlayerId()
        Wait(5000)
    end
end)

CreateThread(function()
    while true do
        if pedId then
            GLOBAL_COORDS = GetEntityCoords(pedId)
        end
        Wait(200)
    end
end)



-- Citizen --
---------------------

CreateThread(function()
	while true do
		local sleep = 4
		--if isLoggedIn and QBCore ~= nil then
			if PlayerJob.name == "butcher" then
				local plyCoords = GetEntityCoords(PlayerPedId(), false)
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, startX, startY, startZ)
				local dist1 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, startX1, startY1, startZ1)
	---
				if dist <= 20.0 then
					DrawMarker(27, startX, startY, startZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
				else
					Wait(1500)
				end
					
				if dist <= 2.5 then
					DrawText3D(startX, startY, startZ, "~g~[E]~w~ To Catch Pigs")
				end
		--
				if dist <= 0.5 then
					if IsControlJustPressed(0, Keys['E']) then -- "E"
							CatchPiggy()
					end
				end

				if dist1 <= 20.0 then
					DrawMarker(27, startX1, startY1, startZ1-0.80, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
				else
					Wait(1500)
				end
					
				if dist1 <= 2.5 then
					DrawText3D(startX1, startY1, startZ1, "~g~[E]~w~ To Catch Beefs")
				end
		--
				if dist1 <= 0.5 then
					if IsControlJustPressed(0, Keys['E']) then -- "E"
							CatchBeefy()
					end
				end
			else
				sleep = 2000
			end
		--else
		--	sleep = 2000
		--end
		Wait(sleep)
	end
end)

CreateThread(function()
	while true do
	sleep = 2000
	if isLoggedIn and QBCore ~= nil then
		if PlayerJob.name == "butcher" then
				local portionMarker = vector3(portionX, portionY, portionZ)
				local portionMarkerdis = #(GLOBAL_COORDS - portionMarker)
				if portionMarkerdis <= 25.0 then
					sleep = 1
					DrawMarker(27, portionX, portionY, portionZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
					DrawMarker(27, portionX2, portionY2, portionZ2-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
					DrawMarker(27, packingX, packingY, packingZ-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
					DrawMarker(27, packingX2, packingY2, packingZ2-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
					if portionMarkerdis <= 2.5 then
						DrawText3D(portionX, portionY, portionZ, "~g~[E]~w~ To portion the pig")
						if portionMarkerdis <= 0.5 then
							if IsControlJustPressed(0, Keys['E']) then -- "E"
								portioning(1)
							end			
						end
					end
				end

				local portionMarker2 = vector3(portionX2, portionY2, portionZ2)
				local portionMarkerdis2 = #(GLOBAL_COORDS - portionMarker2)
				if portionMarkerdis2 <= 2.5 then
					sleep = 1
					DrawText3D(portionX2, portionY2, portionZ2, "~g~[E]~w~ To portion the beef")
					if portionMarkerdis2 <= 0.5 then
						if IsControlJustPressed(0, Keys['E']) then -- "E"
								portioning1(1)
						end			
					end
				end
				
				local packingMarker = vector3(packingX, packingY, packingZ)
				local packingdis = #(GLOBAL_COORDS - packingMarker)
				if packingdis <= 2.5 and packs == 0 then
					sleep = 1
					DrawText3D(packingX, packingY, packingZ, "~g~[E]~w~ To pack pig")
				elseif packingdis <= 2.5 and packs == 1 then
					sleep = 1
					DrawText3D(packingX, packingY, packingZ, "~g~[G]~w~ To stop packing")
					DrawText3D(packingX, packingY, packingZ+0.1, "~g~[E]~w~ To keep packing")
				end

				if packingdis <= 0.5 then
					sleep = 1
					if IsControlJustPressed(0, Keys['E']) then 
							packingg(1)
					elseif IsControlJustPressed(0, Keys['G']) then
							packed(1)
					end			
				end
				
				local packingMarker2 = vector3(packingX2, packingY2, packingZ2)
				local packingdis2 = #(GLOBAL_COORDS - packingMarker2)
				if packingdis2 <= 2.5 and packs == 0 then
					sleep = 1
					DrawText3D(packingX2, packingY2, packingZ2, "~g~[E]~w~ To pack beef")
				elseif packingdis2 <= 2.5 and packs == 1 then
					sleep = 1
					DrawText3D(packingX2, packingY2, packingZ2, "~g~[G]~w~ To stop packing")
					DrawText3D(packingX2, packingY2, packingZ2+0.1, "~g~[E]~w~ To keep packing")
				end

				if packingdis2 <= 0.5 then
					sleep = 1
					if IsControlJustPressed(0, Keys['E']) then -- "E"
							packingg1(1)
					elseif IsControlJustPressed(0, Keys['G']) then
							packed(1)
					end
				end
			else
				sleep = 2000
			end
		else
			sleep = 2000
		end
		Wait(sleep)
	end
end)

-- Code

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



function CatchPiggy()
	DoScreenFadeOut(500)
	Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), 2385.963, 5047.333, 46.400, 0, 0, 1)
	RequestModel(GetHashKey('a_c_pig'))
	while not HasModelLoaded(GetHashKey('a_c_pig')) do
	Wait(1)
	end
	pig1 = CreatePed(26, "a_c_pig", 2370.262, 5052.913, 46.437, 276.351, true, false)
	
	pig2 = CreatePed(26, "a_c_pig", 2372.040, 5059.604, 46.444, 223.595, true, false)
	pig3 = CreatePed(26, "a_c_pig", 2379.192, 5062.992, 46.444, 195.477, true, false)
	TaskReactAndFleePed(pig1, PlayerPedId())
	TaskReactAndFleePed(pig2, PlayerPedId())
	TaskReactAndFleePed(pig3, PlayerPedId())
	Wait(500)
	DoScreenFadeIn(500)
	share = true
end

function CatchBeefy()
	DoScreenFadeOut(500)
	Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), 2385.963, 5047.333, 46.400, 0, 0, 1)
	RequestModel(GetHashKey('a_c_cow'))
	while not HasModelLoaded(GetHashKey('a_c_cow')) do
	Wait(1)
	end
	beef1 = CreatePed(26, "a_c_cow", 2370.262, 5052.913, 46.437, 276.351, true, false)
	
	beef2 = CreatePed(26, "a_c_cow", 2372.040, 5059.604, 46.444, 223.595, true, false)
	beef3 = CreatePed(26, "a_c_cow", 2379.192, 5062.992, 46.444, 195.477, true, false)
	TaskReactAndFleePed(beef1, PlayerPedId())
	TaskReactAndFleePed(beef2, PlayerPedId())
	TaskReactAndFleePed(beef3, PlayerPedId())
	Wait(500)
	DoScreenFadeIn(500)
	share = true
end


function LoadDict(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Wait(10)
    end
end


CreateThread(function()
    while true do
    Wait(5)
	
	if share == true then
		local pig1Coords = GetEntityCoords(pig1)
		local pig2Coords = GetEntityCoords(pig2)
		local pig3Coords = GetEntityCoords(pig3)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pig1Coords.x, pig1Coords.y, pig1Coords.z)
		local dist2 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pig2Coords.x, pig2Coords.y, pig2Coords.z)
		local dist3 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pig3Coords.x, pig3Coords.y, pig3Coords.z)
		
		if andsplashed == 3 then
			Caught1 = 0
			Caught2 = 0
			Caught3 = 0
			andsplashed = 0
			share = false
				TepnijWyjscie()
			end

			
			if dist <= 1.0 then
				DrawText3D(pig1Coords.x, pig1Coords.y, pig1Coords.z+0.5, "~o~[E]~b~ Catch the pig")
			if IsControlJustPressed(0, Keys['E']) then 
				Caught1 = 1
				hewassplashed()
			end	
			elseif dist2 <= 1.0 then
				DrawText3D(pig2Coords.x, pig2Coords.y, pig2Coords.z+0.5, "~o~[E]~b~ Catch the pig")
				if IsControlJustPressed(0, Keys['E']) then 
				Caught2 = 1
				hewassplashed()
			end	
			elseif dist3 <= 1.0 then
				DrawText3D(pig3Coords.x, pig3Coords.y, pig3Coords.z+0.5, "~o~[E]~b~ Catch the pig")
				if IsControlJustPressed(0, Keys['E']) then 
				Caught3 = 1
				hewassplashed()
				end	
			end
		else
			Wait(2000)
		end
	end
end)

CreateThread(function()
    while true do
    Wait(5)
	
	if share == true then
		local beef1Coords = GetEntityCoords(beef1)
		local beef2Coords = GetEntityCoords(beef2)
		local beef3Coords = GetEntityCoords(beef3)
		local plyCoords = GetEntityCoords(PlayerPedId(), false)
		local dist4 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, beef1Coords.x, beef1Coords.y, beef1Coords.z)
		local dist5 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, beef2Coords.x, beef2Coords.y, beef2Coords.z)
		local dist6 = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, beef3Coords.x, beef3Coords.y, beef3Coords.z)
		
		if andsplashed1 == 3 then
			Caught4 = 0
			Caught5 = 0
			Caught6 = 0
			andsplashed1 = 0
			share = false
				TepnijWyjscie1()
			end


			if dist4 <= 1.0 then
				DrawText3D(beef1Coords.x, beef1Coords.y, beef1Coords.z+0.5, "~o~[E]~b~ Catch the beef")
				if IsControlJustPressed(0, Keys['E']) then 
					Caught4 = 1
					hewassplashed1()
				end	
				elseif dist5 <= 1.0 then
					DrawText3D(beef2Coords.x, beef2Coords.y, beef2Coords.z+0.5, "~o~[E]~b~ Catch the beef")
					if IsControlJustPressed(0, Keys['E']) then 
					Caught5 = 1
					hewassplashed1()
				end	
			elseif dist6 <= 1.0 then
				DrawText3D(beef3Coords.x, beef3Coords.y, beef3Coords.z+0.5, "~o~[E]~b~ Catch the beef")
				if IsControlJustPressed(0, Keys['E']) then 
					Caught6 = 1
					hewassplashed1()
				end	
			end
		else
			Wait(2000)
		end	
	end
end)


function TepnijWyjscie()
	DoScreenFadeOut(500)
	Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), startX+2, startY+2, startZ, 0, 0, 1)
	if DoesEntityExist(pig1) or DoesEntityExist(pig2) or DoesEntityExist(pig3) then
		DeleteEntity(pig1)
		DeleteEntity(pig2)
		DeleteEntity(pig3)
	end
	Wait(500)
	DoScreenFadeIn(500)
	
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
							
	local packedintothecar = true
	
	while packedintothecar do
	Wait(250)
	local vehicle   = QBCore.Functions.GetClosestVehicle()
	local coords    = GetEntityCoords(PlayerPedId())
		LoadDict('anim@heists@box_carry@')
	
	if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3 ) and packedintothecar == true then
		TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	end
	
	if DoesEntityExist(vehicle) then
		packedintothecar = false
		TriggerEvent('DoLongHudText', 'You put the pig in the vehicle!', 2)
		LoadDict('anim@heists@narcotics@trash')
		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		Wait(900)
		ClearPedTasks(PlayerPedId())
		DeleteEntity(prop)
		TriggerEvent("DoLongHudText", "Take Alived Pig To Process Area ..")
		TriggerServerEvent("qb-pig:getNewPig")
		end
	end
end

function TepnijWyjscie1()
	DoScreenFadeOut(500)
	Wait(500)
	SetEntityCoordsNoOffset(PlayerPedId(), startX+2, startY+2, startZ, 0, 0, 1)
	if DoesEntityExist(beef1) or DoesEntityExist(beef2) or DoesEntityExist(beef3) then
		DeleteEntity(beef1)
		DeleteEntity(beef2)
		DeleteEntity(beef3)
	end
	Wait(500)
	DoScreenFadeIn(500)
	
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
							
	local packedintothecar = true
	
	while packedintothecar do
	Wait(250)
	local vehicle   = QBCore.Functions.GetClosestVehicle()
	local coords    = GetEntityCoords(PlayerPedId())
		LoadDict('anim@heists@box_carry@')
	
	if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3 ) and packedintothecar == true then
		TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
	end
	
	if DoesEntityExist(vehicle) then
			packedintothecar = false
			TriggerEvent('DoLongHudText', 'You put the pig in the vehicle!', 2)
			LoadDict('anim@heists@narcotics@trash')
			TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			Wait(900)
			ClearPedTasks(PlayerPedId())
			DeleteEntity(prop)
			TriggerEvent("DoLongHudText", "Take Alived Beef To Process Area ..")
			TriggerServerEvent("qb-pig:getNewBeef")
		end
	end
end


function hewassplashed()
	LoadDict('move_jump')
	TaskPlayAnim(PlayerPedId(), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
	Wait(600)
	SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
	Wait(1000)
	ragdoll = true
	local chanceofsplashes = math.random(1,100)
		if chanceofsplashes <= 60 then
			TriggerEvent("DoLongHudText", "You managed to catch 1 pig!")
			if Caught1 == 1 then
				DeleteEntity(pig1)
				Caught1 = 0
				andsplashed = andsplashed +1
			elseif Caught2 == 1 then
				DeleteEntity(pig2)
				Caught2 = 0
				andsplashed = andsplashed +1
			elseif Caught3 == 1 then
				DeleteEntity(pig3)
				Caught3 = 0
				andsplashed = andsplashed +1
			end
		else
		TriggerEvent("DoLongHudText", "The pig escaped your arms!", 2)
	end
end

function hewassplashed1()
	LoadDict('move_jump')
	TaskPlayAnim(PlayerPedId(), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
	Wait(600)
	SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
	Wait(1000)
	ragdoll = true
	local chanceofsplashes = math.random(1,100)
		if chanceofsplashes <= 60 then
			TriggerEvent("DoLongHudText", "You managed to catch 1 cow!")
			if Caught4 == 1 then
				DeleteEntity(beef1)
				Caught4 = 0
				andsplashed1 = andsplashed1 +1
			elseif Caught5 == 1 then
				DeleteEntity(beef2)
				Caught5 = 0
				andsplashed1 = andsplashed1 +1
			elseif Caught6 == 1 then
				DeleteEntity(beef3)
				Caught6 = 0
				andsplashed1 = andsplashed1 +1
			end
		else
			TriggerEvent("DoLongHudText", "The cow escaped your arms!", 2)
	end
end


function packingg(stanowisko)
	local inventory =  QBCore.Functions.GetPlayerData()
	
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
		if result then
			SetEntityHeading(PlayerPedId(), 40.0)
			local PedCoords = GetEntityCoords(PlayerPedId())
			mieso = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(mieso, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			karton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(karton, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
			packs = 1
			LoadDict("anim@heists@ornate_bank@grab_cash_heels")
			TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
			FreezeEntityPosition(PlayerPedId(), true)
			QBCore.Functions.Progressbar("wash-", "Packing..", 12000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
			TriggerServerEvent("qb-pig:getpackedPig", 2)
			TriggerEvent("DoLongHudText", "Keep packing the pig or go to the vehicle and store it.")
			ClearPedTasks(PlayerPedId())
			DeleteEntity(karton)
			DeleteEntity(mieso)
			end, function() -- Cancel
				--isWashing = false
				ClearPedTasksImmediately(player)
				FreezeEntityPosition(player, false)
			end)
		else
		
			TriggerEvent("DoShortHudText", "You have nothing to pack!", 2)
		end
	end, 'slaughteredpig')
end

function packingg1(stanowisko)
	local inventory =  QBCore.Functions.GetPlayerData()
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
		if result then
			SetEntityHeading(PlayerPedId(), 40.0)
			local PedCoords = GetEntityCoords(PlayerPedId())
			mieso = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(mieso, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			karton = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(karton, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
			packs = 1
			LoadDict("anim@heists@ornate_bank@grab_cash_heels")
			TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
			FreezeEntityPosition(PlayerPedId(), true)
			QBCore.Functions.Progressbar("wash-", "Packing..", 12000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
			TriggerServerEvent("qb-pig:getpackedBeef", 2)
			QBCore.TriggerEvent("DoLongHudText", "Keep packing the beef or go to the vehicle and store it.")
			ClearPedTasks(PlayerPedId())
			DeleteEntity(karton)
			DeleteEntity(mieso)
			end, function() -- Cancel
				--isWashing = false
				ClearPedTasksImmediately(player)
				FreezeEntityPosition(player, false)
			end)
		else
		
		QBCore.TriggerEvent("DoShortHudText", "You have nothing to pack!", 2)
		end
	end, 'slaughteredbeef')
end


function packed(stanowisko)
	FreezeEntityPosition(PlayerPedId(), false)
	zapakowaneDoauta = true
	local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
	prop = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
	packs = 0
	while zapakowaneDoauta do
	Wait(250)
	
	local coords    = GetEntityCoords(PlayerPedId())
		LoadDict('anim@heists@box_carry@')
	
		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3 ) and zapakowaneDoauta == true then
		TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		end
		
		zapakowaneDoauta = false
		TriggerEvent("DoShortHudText", "You stopped packing!", 2)
		LoadDict('anim@heists@narcotics@trash')
		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		Wait(900)
		ClearPedTasks(PlayerPedId())
		DeleteEntity(prop)
	end
end


function portioning(position)
	local inventory =  QBCore.Functions.GetPlayerData()
	
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
		if result then
			local dict = 'anim@amb@business@coc@coc_unpack_cut_left@'
			LoadDict(dict)
			FreezeEntityPosition(PlayerPedId(),true)
			TaskPlayAnim(PlayerPedId(), dict, "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			local PedCoords = GetEntityCoords(PlayerPedId())
			nozyk = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(nozyk, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
		if position == 1 then
			SetEntityHeading(PlayerPedId(), 311.0)
			QBCore.Functions.Progressbar("Cut-", "Slaughtering..", 12000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
			
			TriggerEvent("DoShortHudText", "Now Pack slaughtered pig!")
			TriggerServerEvent("qb-pig:getcutPig", 1)
			FreezeEntityPosition(PlayerPedId(),false)
			DeleteEntity(nozyk)
			end, function() -- Cancel
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(nozyk)
				ClearPedTasks(PlayerPedId())
			end)
		end
		else
			TriggerEvent("DoShortHudText", "You dont have any pigs!", 2)
		end
	end, 'alivepig')
end

function portioning1(position)
	local inventory =  QBCore.Functions.GetPlayerData()
	
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
		if result then
			local dict = 'switch@trevor@throw_food'
			LoadDict(dict)
			FreezeEntityPosition(PlayerPedId(),true)
			TaskPlayAnim(PlayerPedId(), dict, "exit_taco", 3.0, -8, -1, 63, 0, 0, 0, 0 )
			local PedCoords = GetEntityCoords(PlayerPedId())
			nozyk = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(nozyk, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
		if position == 1 then
			SetEntityHeading(PlayerPedId(), 311.0)
			QBCore.Functions.Progressbar("Cut-", "Slaughtering..", 12000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
				TriggerEvent("DoShortHudText", "Now Pack slaughtered beef!")
				TriggerServerEvent("qb-pig:getcutBeef", 1)
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(nozyk)
			end, function() -- Cancel
				FreezeEntityPosition(PlayerPedId(),false)
				DeleteEntity(nozyk)
				ClearPedTasks(PlayerPedId())
			end)
		end
		else
			TriggerEvent("DoShortHudText", "You dont have any beefs!", 2)
		end
	end, 'alivecow')
end