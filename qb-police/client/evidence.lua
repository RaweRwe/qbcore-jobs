local ShotsFired = 0
local GunShotAlert = false

local Hairs = {}
local Casings = {}
local Blooddrops = {}
local SlimeDrops = {}
local Fingerprints = {}

local HairNear = {}
local CasingsNear = {}
local BlooddropsNear = {}
local SlimeDropsNear = {}
local FingerprintsNear = {}
local CurrentStatusList = {}

local CurrentHair = nil
local CurrentCasing = nil
local CurrentBlooddrop = nil
local CurrentSlimeDrop = nil
local CurrentFingerprint = nil

-- // Loops \\ --

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPedShooting(PlayerPedId()) then
			local Weapon = GetSelectedPedWeapon(PlayerPedId())
			if Weapon ~= GetHashKey("WEAPON_UNARMED") and Weapon ~= GetHashKey("WEAPON_SNOWBALL") and Weapon ~= GetHashKey("WEAPON_STUNGUN") and Weapon ~= GetHashKey("WEAPON_PETROLCAN") and Weapon ~= GetHashKey("WEAPON_FIREEXTINGUISHER") and Weapon ~= GetHashKey("WEAPON_MOLOTOV") then
				ShotsFired = ShotsFired + 1
				if ShotsFired > 5 and (CurrentStatusList == nil or CurrentStatusList["gunpowder"] == nil) then
					if math.random(1,10) <= 4 then
						TriggerServerEvent('qb-hud:server:gain:stress', math.random(1,12))
					end
					if math.random(1, 10) <= 7 then
						TriggerEvent("qb-police:client:SetStatus", "gunpowder", 200)
					end
				end
				DropBulletCasing(Weapon)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(4)
		if isLoggedIn then
		  	if IsPedShooting(PlayerPedId()) then
		   		if QBCore.Functions.GetPlayerData().job.name ~= "police" then
		  			local Weapon = GetSelectedPedWeapon(PlayerPedId())
		  			local SilentWeapon = IsWeaponSilent(Weapon)
		  			local GunCategory = GetWeaponCategory(Weapon)
		  			if not SilentWeapon then
						if not GunShotAlert then
		  					GunShotAlert = true
							TriggerServerEvent('qb-hud:server:gain:stress', math.random(1,3))
		  					TriggerServerEvent('qb-police:server:send:alert:gunshots', GetEntityCoords(PlayerPedId()), GunCategory, QBCore.Functions.GetStreetLabel(), IsPedInAnyVehicle(PlayerPedId()))
		  					Citizen.SetTimeout(20000, function()
		  					 	GunShotAlert = false
		  		 			end)
						end
		    		end
		  		end
			end
	  	else
			Citizen.Wait(1000)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if isLoggedIn then
			if CurrentStatusList ~= nil and next(CurrentStatusList) ~= nil then
				for k, v in pairs(CurrentStatusList) do
					if CurrentStatusList[k].time > 0 then
						CurrentStatusList[k].time = CurrentStatusList[k].time - 10
					else
						CurrentStatusList[k].time = 0
					end
				end
				TriggerServerEvent("qb-police:server:UpdateStatus", CurrentStatusList)
			end
			if ShotsFired > 0 then
				ShotsFired = 0
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(1)
		if isLoggedIn then
		if PlayerJob.name == "police" and onDuty then
		if CurrentCasing ~= nil then 
			local pos = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Casings[CurrentCasing].coords.x, Casings[CurrentCasing].coords.y, Casings[CurrentCasing].coords.z, true) < 1.5 then
				DrawText3D(Casings[CurrentCasing].coords.x, Casings[CurrentCasing].coords.y, Casings[CurrentCasing].coords.z, "~g~G~w~ - Kogelhuls ~b~#"..Casings[CurrentCasing].type)
				if IsControlJustReleased(0, Config.Keys["G"]) then
					-- PickUp Event
					local StreetLabel = QBCore.Functions.GetStreetLabel()
					local AmmoType = exports['qb-weapons']:GetAmmoType(Casings[CurrentCasing].type)
					local info = {label = "Kogelhuls", type = "casing", street = StreetLabel:gsub("%'", ""), ammolabel = Config.AmmoLabels[AmmoType], ammotype = Casings[CurrentCasing].type, serie = Casings[CurrentCasing].serie}
					TriggerServerEvent("qb-police:server:AddEvidenceToInventory", 'casing', CurrentCasing, info)
				end
			end
		end

		if CurrentBlooddrop ~= nil then 
			local pos = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Blooddrops[CurrentBlooddrop].coords.x, Blooddrops[CurrentBlooddrop].coords.y, Blooddrops[CurrentBlooddrop].coords.z, true) < 1.5 then
				DrawText3D(Blooddrops[CurrentBlooddrop].coords.x, Blooddrops[CurrentBlooddrop].coords.y, Blooddrops[CurrentBlooddrop].coords.z, "~g~G~w~ - Bloed Monster")
				if IsControlJustReleased(0, Config.Keys["G"]) then
					-- PickUp Event
					local StreetLabel = QBCore.Functions.GetStreetLabel()
					local info = {label = "Bloedmonster", type = "blood", street = StreetLabel:gsub("%'", ""), bloodtype = Blooddrops[CurrentBlooddrop].bloodtype}
					TriggerServerEvent("qb-police:server:AddEvidenceToInventory", 'blood', CurrentBlooddrop, info)
				end
			end
		end

		if CurrentFingerprint ~= nil then 
			local pos = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Fingerprints[CurrentFingerprint].coords.x, Fingerprints[CurrentFingerprint].coords.y, Fingerprints[CurrentFingerprint].coords.z, true) < 1.5 then
				DrawText3D(Fingerprints[CurrentFingerprint].coords.x, Fingerprints[CurrentFingerprint].coords.y, Fingerprints[CurrentFingerprint].coords.z, "~g~G~w~ - Vingerafdruk")
				if IsControlJustReleased(0, Config.Keys["G"]) then
					-- PickUp Event
					local StreetLabel = QBCore.Functions.GetStreetLabel()
					local info = {label = "Vingerafdruk", type = "fingerprint", street = StreetLabel:gsub("%'", ""), fingerprint = Fingerprints[CurrentFingerprint].fingerprint}
					TriggerServerEvent("qb-police:server:AddEvidenceToInventory", 'finger', CurrentFingerprint, info)
				end
			end
		end

		if CurrentHair ~= nil then 
			local pos = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Hairs[CurrentHair].coords.x, Hairs[CurrentHair].coords.y, Hairs[CurrentHair].coords.z, true) < 1.5 then
				DrawText3D(Hairs[CurrentHair].coords.x, Hairs[CurrentHair].coords.y, Hairs[CurrentHair].coords.z, "~g~G~w~ - Haar Monster")
				if IsControlJustReleased(0, Config.Keys["G"]) then
					-- PickUp Event
					local StreetLabel = QBCore.Functions.GetStreetLabel()
					local info = {label = "Haar Plukje", type = "hair", street = StreetLabel:gsub("%'", ""), hair = Hairs[CurrentHair].hair}
					TriggerServerEvent("qb-police:server:AddEvidenceToInventory", 'hair', CurrentHair, info)
				end
			end
		end

		if CurrentSlimeDrop ~= nil then 
			local pos = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, SlimeDrops[CurrentSlimeDrop].coords.x, SlimeDrops[CurrentSlimeDrop].coords.y, SlimeDrops[CurrentSlimeDrop].coords.z, true) < 1.5 then
				DrawText3D(SlimeDrops[CurrentSlimeDrop].coords.x, SlimeDrops[CurrentSlimeDrop].coords.y, SlimeDrops[CurrentSlimeDrop].coords.z, "~g~G~w~ - Slijm Monster")
				if IsControlJustReleased(0, Config.Keys["G"]) then
					-- PickUp Event
					local StreetLabel = QBCore.Functions.GetStreetLabel()
					local info = {label = "Slijm Monster", type = "slime", street = StreetLabel:gsub("%'", ""), slime = SlimeDrops[CurrentSlimeDrop].slime}
					TriggerServerEvent("qb-police:server:AddEvidenceToInventory", 'slime', CurrentSlimeDrop, info)
				end
			end
		end
	else
		Citizen.Wait(1000)
	end
	  else
		Citizen.Wait(1000)
	 end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if isLoggedIn then 
			if PlayerJob.name == "police" and onDuty then
				if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
					if next(Casings) ~= nil then
						local pos = GetEntityCoords(PlayerPedId(), true)
						for k, v in pairs(Casings) do
							if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 12.5 then
								CasingsNear[k] = v
								if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
									CurrentCasing = k
								end
							else
								CasingsNear[k] = nil
							end
						end
					else
						CasingsNear = {}
					end

					if next(Blooddrops) ~= nil then
						local pos = GetEntityCoords(PlayerPedId(), true)
						for k, v in pairs(Blooddrops) do
							if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 12.5 then
								BlooddropsNear[k] = v
								if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
									CurrentBlooddrop = k
								end
							else
								BlooddropsNear[k] = nil
							end
						end
					else
						BlooddropsNear = {}
					end

					if next(Fingerprints) ~= nil then
						local pos = GetEntityCoords(PlayerPedId(), true)
						for k, v in pairs(Fingerprints) do
							if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 12.5 then
								FingerprintsNear[k] = v
								if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
									CurrentFingerprint = k
								end
							else
								FingerprintsNear[k] = nil
							end
						end
					else
						FingerprintsNear = {}
					end

					if next(Hairs) ~= nil then
						local pos = GetEntityCoords(PlayerPedId(), true)
						for k, v in pairs(Hairs) do
							if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 12.5 then
								HairNear[k] = v
								if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
									CurrentHair = k
								end
							else
								HairNear[k] = nil
							end
						end
					else
						HairNear = {}
					end

					if next(SlimeDrops) ~= nil then
						local pos = GetEntityCoords(PlayerPedId(), true)
						for k, v in pairs(SlimeDrops) do
							if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 12.5 then
								SlimeDropsNear[k] = v
								if GetDistanceBetweenCoords(pos.x, pos.y, pos.z, v.coords.x, v.coords.y, v.coords.z, true) < 1.5 then
									CurrentSlimeDrop = k
								end
							else
								SlimeDropsNear[k] = nil
							end
						end
					else
						SlimeDropsNear = {}
					end
				else
					CurrentHair = nil
                    CurrentCasing = nil 
					CurrentBlooddrop = nil
					CurrentSlimeDrop = nil
                    CurrentFingerprint = nil
					Citizen.Wait(1000)
				end
			else
				Citizen.Wait(5000)
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
		if isLoggedIn then
           if FingerprintsNear ~= nil then
		    	if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
		    		if PlayerJob.name == "police" and onDuty then
		    			for k, v in pairs(FingerprintsNear) do
		    				if v ~= nil then
		    					DrawMarker(32, v.coords.x, v.coords.y, v.coords.z - 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 89, 29, 138, 255, false, false, false, true, false, false, false)
		    				end
		    			end
		    		end
		    	else
		    	  Citizen.Wait(1000)
		    	end
		    else
		      Citizen.Wait(1000)
           end

           if CasingsNear ~= nil then
            if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
				if PlayerJob.name == "police" and onDuty then
					for k, v in pairs(CasingsNear) do
						if v ~= nil then
							DrawMarker(32, v.coords.x, v.coords.y, v.coords.z - 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 50, 0, 250, 255, false, false, false, true, false, false, false)
				   		end
				   	end
				   end
			    else
			    	Citizen.Wait(1000)
               end
             else
               Citizen.Wait(1000)
		   end
		   
		   if HairNear ~= nil then
            if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
				if PlayerJob.name == "police" and onDuty then
					for k, v in pairs(HairNear) do
						if v ~= nil then
							DrawMarker(32, v.coords.x, v.coords.y, v.coords.z - 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 247, 184, 10, 255, false, false, false, true, false, false, false)
				   		end
				   	end
				   end
			    else
			    	Citizen.Wait(1000)
               end
             else
               Citizen.Wait(1000)
		   end
		   
		   if SlimeDropsNear ~= nil then
            if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
				if PlayerJob.name == "police" and onDuty then
					for k, v in pairs(SlimeDropsNear) do
						if v ~= nil then
							DrawMarker(32, v.coords.x, v.coords.y, v.coords.z - 0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 23, 173, 12, 255, false, false, false, true, false, false, false)
				   		end
				   	end
				   end
			    else
			    	Citizen.Wait(1000)
               end
             else
               Citizen.Wait(1000)
           end

           if BlooddropsNear ~= nil then
           if IsPlayerFreeAiming(PlayerId()) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("WEAPON_FLASHLIGHT") then
            if PlayerJob.name == "police" and onDuty then
                for k, v in pairs(BlooddropsNear) do
                    if v ~= nil then
                        DrawMarker(32, v.coords.x, v.coords.y, v.coords.z - 0.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.1, 0.45, 0.1, 250, 0, 50, 255, false, false, false, true, false, false, false)
                    end
                    end
                 end
               else
                   Citizen.Wait(1000)
               end
             else
             Citizen.Wait(1000)
           end
        end
    end
end)

-- // Events \\ --

RegisterNetEvent('qb-police:client:AddBlooddrop')
AddEventHandler('qb-police:client:AddBlooddrop', function(bloodId, bloodtype, coords)
    Blooddrops[bloodId] = {
		bloodtype = bloodtype,
		coords = {
			x = coords.x,
			y = coords.y, 
			z = coords.z - 0.9,
		}
	}
end)

RegisterNetEvent('qb-police:client:AddFingerPrint')
AddEventHandler('qb-police:client:AddFingerPrint', function(fingerId, fingerprint, coords)
    Fingerprints[fingerId] = {
		fingerprint = fingerprint,
		coords = {
			x = coords.x,
			y = coords.y, 
			z = coords.z - 0.9,
		}
	}
end)

RegisterNetEvent('qb-police:client:AddHair')
AddEventHandler('qb-police:client:AddHair', function(hairId, hair, coords)
    Hairs[hairId] = {
		hair = hair,
		coords = {
			x = coords.x,
			y = coords.y, 
			z = coords.z - 0.9,
		}
    }
end)

RegisterNetEvent('qb-police:client:AddSlime')
AddEventHandler('qb-police:client:AddSlime', function(slimeId, slime, coords)
    SlimeDrops[slimeId] = {
		slime = slime,
		coords = {
			x = coords.x,
			y = coords.y, 
			z = coords.z - 0.9,
		}
    }
end)

RegisterNetEvent('qb-police:client:AddCasing')
AddEventHandler('qb-police:client:AddCasing', function(casingId, weapon, coords, serie)
    Casings[casingId] = {
		type = weapon,
		serie = serie ~= nil and serie or "Serie Number niet zichtbaar..",
		coords = {
			x = coords.x,
			y = coords.y, 
			z = coords.z - 0.9,
		}
    }
end)

RegisterNetEvent("qb-police:client:RemoveDnaId")
AddEventHandler("qb-police:client:RemoveDnaId", function(Type, DnaId)
	if Type == 'casing' then
	 Casings[DnaId] = nil
	 CasingsNear[DnaId] = nil
	 CurrentCasing = nil
	elseif Type == 'finger' then
	 Fingerprints[DnaId] = nil
	 FingerprintsNear[DnaId] = nil
	 CurrentFingerprint = nil
	elseif Type == 'blood' then
	 Blooddrops[DnaId] = nil
	 BlooddropsNear[DnaId] = nil
	 CurrentBlooddrop = nil
	elseif Type == 'hair' then
	 Hairs[DnaId] = nil
	 HairNear[DnaId] = nil
	 CurrentHair = nil
	elseif Type == 'slime' then
	 SlimeDrops[DnaId] = nil
	 SlimeDropsNear[DnaId] = nil
	 CurrentSlimeDrop = nil
	end
end)

RegisterNetEvent('qb-police:client:SetStatus')
AddEventHandler('qb-police:client:SetStatus', function(statusId, time)
	if time > 0 and Config.StatusList[statusId] ~= nil then 
		if (CurrentStatusList == nil or CurrentStatusList[statusId] == nil) or (CurrentStatusList[statusId] ~= nil and CurrentStatusList[statusId].time < 20) then
			CurrentStatusList[statusId] = {text = Config.StatusList[statusId], time = time}
			TriggerEvent("chatMessage", "STATUS", "warning", CurrentStatusList[statusId].text)
		end
	elseif StatusList[statusId] ~= nil then
		CurrentStatusList[statusId] = nil
	end
	TriggerServerEvent("qb-police:server:UpdateStatus", CurrentStatusList)
end)

-- // Functions \\ --

function DropBulletCasing(Weapon)
 local RandomX = math.random() + math.random(-1, 1)
 local RandomY = math.random() + math.random(-1, 1)
 local Coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), RandomX, RandomY, 0)
 TriggerServerEvent("qb-police:server:CreateCasing", Weapon, Coords)
 Citizen.Wait(300)
end

function IsWeaponSilent(Weapon)
	local IsSilent = false
	 for k, v in pairs(Config.SilentWeapons) do
	  if GetHashKey(v) == Weapon then		
	  	IsSilent = true
	  end
	 end
 return IsSilent
end

function GetWeaponCategory(Weapon)
	local WeaponCategory = 'Onbekend'
	local WeaponGroupHash = GetWeapontypeGroup(Weapon)
	if Config.WeaponHashGroup[WeaponGroupHash] ~= nil then 
		WeaponCategory = Config.WeaponHashGroup[WeaponGroupHash]['name']
	end
	return WeaponCategory
end