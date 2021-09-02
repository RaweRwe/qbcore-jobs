local ClosestCustomVehicle = 1
local CustomModelLoaded = true


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
Citizen.CreateThread(function()
    for k, v in pairs(Pepe.VehicleShops) do
        Dealer = AddBlipForCoord(-795.91, -220.21, 37.07)

        SetBlipSprite (Dealer, 326)
        SetBlipDisplay(Dealer, 4)
        SetBlipScale  (Dealer, 0.75)
        SetBlipAsShortRange(Dealer, true)
        SetBlipColour(Dealer, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Luxury Cars")
        EndTextCommandSetBlipName(Dealer)
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local bringcoords = {x = -768.15, y = -233.1, z = 37.07, h = 203.5, r = 1.0}
        local pos = GetEntityCoords(ped, false)
        local dist = GetDistanceBetweenCoords(pos, bringcoords.x, bringcoords.y, bringcoords.z)

        if isLoggedIn then
            if (PlayerJob ~= nil) and PlayerJob.name == "cardealer" then
                if IsPedInAnyVehicle(ped, false) then
                    if dist < 15 then
                        local veh = GetVehiclePedIsIn(ped)
                        DrawMarker(2, bringcoords.x, bringcoords.y, bringcoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.3, 0.1, 255, 0, 0, 155, false, false, false, false, false, false, false)

                        if dist < 2 then
                            DrawText3Ds(bringcoords.x, bringcoords.y, bringcoords.z, '~g~E~w~ - Deliver vehicle')
                            if IsControlJustPressed(0, Keys["E"]) then
                                QBCore.Functions.DeleteVehicle(veh)
                            end
                        end
                    end
                end
            end
        end

        Citizen.Wait(3)
    end
end)

CustomVehicleCats = {
    ["coupes"] = {
        label = "Geimporteerde Voertuigen",
        vehicles = {}
    },
        ["donos"] = {
        label = "Donatie Voertuigen",
        vehicles = {}
    },
}

CustomVehicleShop = {
	opened = false,
	title = "Vehicle Shop",
	currentmenu = "main",
	lastmenu = nil,
	currentpos = nil,
	selectedbutton = 0,
	marker = { r = 0, g = 155, b = 255, a = 250, type = 1 },
	menu = {
		x = 0.14,
		y = 0.15,
		width = 0.12,
		height = 0.03,
		buttons = 10,
		from = 1,
		to = 10,
		scale = 0.29,
		font = 0,
		["main"] = {
			title = "CATEGORIES",
			name = "main",
			buttons = {
				{name = "Voertuigen", description = ""},
				{name = "Donaties", description = ""},
			}
		},
		["vehicles"] = {
			title = "VEHICLES",
			name = "vehicles",
			buttons = {}
		},	
		["donos"] = {
			title = "DONATIES",
			name = "donos",
			buttons = {}
		},	
	}
}

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for k, v in pairs(QBCore.Shared.Vehicles) do
        if v["shop"] == "custom" then
            for cat,_ in pairs(CustomVehicleCats) do
                if QBCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(CustomVehicleCats[cat].vehicles, QBCore.Shared.Vehicles[k])
                end
            end
        end

        if v["shop"] == "donos" then
            for cat,_ in pairs(CustomVehicleCats) do
                if QBCore.Shared.Vehicles[k]["category"] == cat then
                    table.insert(CustomVehicleCats[cat].vehicles, QBCore.Shared.Vehicles[k])
                end
            end
        end
    end
    for k, v in pairs(CustomVehicleCats) do
        table.insert(CustomVehicleShop.menu["vehicles"].buttons, {
            menu = k,
            name = v.label,
            description = {}
        })

        CustomVehicleShop.menu[k] = {
            title = k,
            name = v.label,
            buttons = v.vehicles
        }
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    for i = 1, #PepeCustoms.ShowroomPositions, 1 do
        local oldVehicle = GetClosestVehicle(PepeCustoms.ShowroomPositions[i].coords.x, PepeCustoms.ShowroomPositions[i].coords.y, PepeCustoms.ShowroomPositions[i].coords.z, 3.0, 0, 70)
        if oldVehicle ~= 0 then
            QBCore.Functions.DeleteVehicle(oldVehicle)
        end

		local model = GetHashKey(PepeCustoms.ShowroomPositions[i].vehicle)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, PepeCustoms.ShowroomPositions[i].coords.x, PepeCustoms.ShowroomPositions[i].coords.y, PepeCustoms.ShowroomPositions[i].coords.z, false, false)
		SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, PepeCustoms.ShowroomPositions[i].coords.h)
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)
		SetVehicleNumberPlateText(veh, i .. "CARSALE")
		SetVehicleOnGroundProperly(veh)
    end
end)

function SetClosestCustomVehicle()
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(PepeCustoms.ShowroomPositions) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[id].coords.x, PepeCustoms.ShowroomPositions[id].coords.y, PepeCustoms.ShowroomPositions[id].coords.z, true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[id].coords.x, PepeCustoms.ShowroomPositions[id].coords.y, PepeCustoms.ShowroomPositions[id].coords.z, true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[id].coords.x, PepeCustoms.ShowroomPositions[id].coords.y, PepeCustoms.ShowroomPositions[id].coords.z, true)
            current = id
        end
    end
    if current ~= ClosestCustomVehicle then
        ClosestCustomVehicle = current
    end
end

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(PlayerPedId(), true)
        local ShopDistance = GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[1].coords.x, PepeCustoms.ShowroomPositions[1].coords.y, PepeCustoms.ShowroomPositions[1].coords.z, false)

        if isLoggedIn then
            if ShopDistance <= 100 then
                SetClosestCustomVehicle()
            end
        end
        Citizen.Wait(2000)
    end
end)

function isCustomValidMenu(menu)
    local retval = false
    for k, v in pairs(CustomVehicleShop.menu["vehicles"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped, false)
        local dist = GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.x, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.y, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.z, false)

        if isLoggedIn then
            if dist < 2 then
                if PlayerJob ~= nil then
                    if PlayerJob.name == "cardealer" then
                        DrawText3Ds(PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.x, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.y, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.z + 1.9, '~g~G~w~ - Change Vehicle')
                        DrawText3Ds(PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.x, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.y, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.z + 1.75, '~b~/sellvehicle [id]~w~ - Sell vehicle ~b~/testdrive~w~ - Testdrive')
                        
                        if not CustomVehicleShop.opened then
                            if IsControlJustPressed(0, Keys["G"]) then
                                if CustomVehicleShop.opened then
                                    CloseCustomCreator()
                                else
                                    OpenCustomCreator()
                                end
                            end
                        end

                        if CustomVehicleShop.opened then
                            local ped = PlayerPedId()
                            local menu = CustomVehicleShop.menu[CustomVehicleShop.currentmenu]
                            local y = CustomVehicleShop.menu.y + 0.12
                            buttoncount = tablelength(menu.buttons)
                            local selected = false

                            for i,button in pairs(menu.buttons) do
                                if i >= CustomVehicleShop.menu.from and i <= CustomVehicleShop.menu.to then
                                    if i == CustomVehicleShop.selectedbutton then
                                        selected = true
                                    else
                                        selected = false
                                    end
                                    drawMenuButton(button,CustomVehicleShop.menu.x,y,selected)
                                    if button.price ~= nil then
                                        drawMenuRight("€"..button.price,CustomVehicleShop.menu.x,y,selected)
                                    end
                                    y = y + 0.04
                                    if isCustomValidMenu(CustomVehicleShop.currentmenu) then
                                        if selected then
                                            if IsControlJustPressed(1, 18) then
                                                if CustomModelLoaded then
                                                    TriggerServerEvent('qb-vehicleshop:server:SetCustomShowroomVeh', button.model, ClosestCustomVehicle)
                                                end
                                            end
                                        end
                                    end
                                    if selected and (IsControlJustPressed(1,38) or IsControlJustPressed(1, 18)) then
                                        CustomButtonSelected(button)
                                    end
                                end
                            end
                        end

                        if CustomVehicleShop.opened then
                            if IsControlJustPressed(1,202) then
                                BackCustom()
                            end
                            if IsControlJustReleased(1,202) then
                                backlock = false
                            end
                            if IsControlJustPressed(1,188) then
                                if CustomModelLoaded then
                                    if CustomVehicleShop.selectedbutton > 1 then
                                        CustomVehicleShop.selectedbutton = CustomVehicleShop.selectedbutton -1
                                        if buttoncount > 10 and CustomVehicleShop.selectedbutton < CustomVehicleShop.menu.from then
                                            CustomVehicleShop.menu.from = CustomVehicleShop.menu.from -1
                                            CustomVehicleShop.menu.to = CustomVehicleShop.menu.to - 1
                                        end
                                    end
                                end
                            end
                            if IsControlJustPressed(1,187)then
                                if CustomModelLoaded then
                                    if CustomVehicleShop.selectedbutton < buttoncount then
                                        CustomVehicleShop.selectedbutton = CustomVehicleShop.selectedbutton +1
                                        if buttoncount > 10 and CustomVehicleShop.selectedbutton > CustomVehicleShop.menu.to then
                                            CustomVehicleShop.menu.to = CustomVehicleShop.menu.to + 1
                                            CustomVehicleShop.menu.from = CustomVehicleShop.menu.from + 1
                                        end
                                    end
                                end
                            end
                        end

                        if GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= nil and GetVehiclePedIsTryingToEnter(PlayerPedId()) ~= 0 then
                            ClearPedTasksImmediately(PlayerPedId())
                        end

                        DisableControlAction(0, Keys["7"], true)
                        DisableControlAction(0, Keys["8"], true)
                    else
                        if ClosestCustomVehicle ~= nil then
                            if PepeCustoms.ShowroomPositions[ClosestCustomVehicle] ~= nil then
                                if PepeCustoms.ShowroomPositions[ClosestCustomVehicle].buying then
                                    if QBCore.Shared.Vehicles[PepeCustoms.ShowroomPositions[ClosestCustomVehicle].vehicle] ~= nil then
                                        DrawText3Ds(PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.x, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.y, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.z + 1.6, '~g~7~w~ - Buy / ~r~8~w~ - Cancel - ~g~(€'..QBCore.Shared.Vehicles[PepeCustoms.ShowroomPositions[ClosestCustomVehicle].vehicle].price..',-)')
                                        
                                        if IsDisabledControlJustPressed(0, Keys["7"]) then
                                            TriggerServerEvent('qb-vehicleshop:server:ConfirmVehicle', PepeCustoms.ShowroomPositions[ClosestCustomVehicle])
                                            PepeCustoms.ShowroomPositions[ClosestCustomVehicle].buying = false
                                        end

                                        if IsDisabledControlJustPressed(0, Keys["8"]) then
                                            QBCore.Functions.Notify('Je hebt de auto NIET gekocht!')
                                            PepeCustoms.ShowroomPositions[ClosestCustomVehicle].buying = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            elseif dist > 1.8 then
                if CustomVehicleShop.opened then
                    CloseCustomCreator()
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-vehicleshop:client:SetCustomShowroomVeh')
AddEventHandler('qb-vehicleshop:client:SetCustomShowroomVeh', function(showroomVehicle, k)
    CancelEvent()
    if PepeCustoms.ShowroomPositions[k].vehicle ~= showroomVehicle then
        QBCore.Functions.DeleteVehicle(GetClosestVehicle(PepeCustoms.ShowroomPositions[k].coords.x, PepeCustoms.ShowroomPositions[k].coords.y, PepeCustoms.ShowroomPositions[k].coords.z, 3.0, 0, 70))
        CustomModelLoaded =  false
        Wait(250)
        local model = GetHashKey(showroomVehicle)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(250)
        end
        local veh = CreateVehicle(model, PepeCustoms.ShowroomPositions[k].coords.x, PepeCustoms.ShowroomPositions[k].coords.y, PepeCustoms.ShowroomPositions[k].coords.z, false, false)
        SetModelAsNoLongerNeeded(model)
        SetVehicleOnGroundProperly(veh)
        SetEntityInvincible(veh,true)
        SetEntityHeading(veh, PepeCustoms.ShowroomPositions[k].coords.h)
        SetVehicleDoorsLocked(veh, 3)

        FreezeEntityPosition(veh, true)
        SetVehicleNumberPlateText(veh, k .. "CARSALE")
        CustomModelLoaded =  true
        PepeCustoms.ShowroomPositions[k].vehicle = showroomVehicle
    end
end)

RegisterNetEvent('qb-vehicleshop:client:ConfirmVehicle')
AddEventHandler('qb-vehicleshop:client:ConfirmVehicle', function(Showroom, plate)
    QBCore.Functions.SpawnVehicle(Showroom.vehicle, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityAsMissionEntity(veh, true, true)
        SetEntityHeading(veh, PepeCustoms.VehicleBuyLocation.h)
        exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)

        if Showroom.vehicle == "urus" then
            SetVehicleExtra(veh, 1, false)
            SetVehicleExtra(veh, 2, true)
        end

    end, PepeCustoms.VehicleBuyLocation, false)
end)

RegisterNetEvent('qb-vehicleshop:client:DoTestrit')
AddEventHandler('qb-vehicleshop:client:DoTestrit', function(plate)
    if ClosestCustomVehicle ~= 0 then
        QBCore.Functions.SpawnVehicle(PepeCustoms.ShowroomPositions[ClosestCustomVehicle].vehicle, function(veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['qb-fuel']:SetFuelLevel(veh, GetVehicleNumberPlateText(veh), 100, false)
            SetVehicleNumberPlateText(veh, plate)
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, PepeCustoms.VehicleBuyLocation.h)
            exports['qb-vehiclekeys']:SetVehicleKey(GetVehicleNumberPlateText(veh), true)
            testritveh = veh

            if PepeCustoms.ShowroomPositions[ClosestCustomVehicle].vehicle == "urus" then
                SetVehicleExtra(veh, 1, false)
                SetVehicleExtra(veh, 2, true)
            end
        end, PepeCustoms.VehicleBuyLocation, false)
    end
end)

RegisterNetEvent('qb-vehicleshop:client:SellCustomVehicle')
AddEventHandler('qb-vehicleshop:client:SellCustomVehicle', function(TargetId)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local player, distance = GetClosestPlayer()

    if player ~= -1 and distance < 2.5 then
        local VehicleDist = GetDistanceBetweenCoords(pos, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.x, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.y, PepeCustoms.ShowroomPositions[ClosestCustomVehicle].coords.z)

        if VehicleDist < 2.5 then
            TriggerServerEvent('qb-vehicleshop:server:SellCustomVehicle', TargetId, ClosestCustomVehicle)
        else
            QBCore.Functions.Notify("Get closer to the vehicle", "error")
        end
    else
        QBCore.Functions.Notify("Nobody nearby", "error")
    end
end)

function GetClosestPlayer()
    local closestPlayers = QBCore.Functions.GetPlayersFromCoords()
    local closestDistance = -1
    local closestPlayer = -1
    local coords = GetEntityCoords(PlayerPedId())

    for i=1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, coords.x, coords.y, coords.z, true)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
	end

	return closestPlayer, closestDistance
end

RegisterNetEvent('qb-vehicleshop:client:SetVehicleBuying')
AddEventHandler('qb-vehicleshop:client:SetVehicleBuying', function(slot)
    PepeCustoms.ShowroomPositions[slot].buying = true
    SetTimeout((60 * 1000) * 5, function()
        PepeCustoms.ShowroomPositions[slot].buying = false
    end)
end)

function isCustomValidMenu(menu)
    local retval = false
    for k, v in pairs(CustomVehicleShop.menu["vehicles"].buttons) do
        if menu == v.menu then
            retval = true
        end
    end
    return retval
end

function drawMenuButton(button,x,y,selected)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	if selected then
		SetTextColour(0, 0, 0, 255)
	else
		SetTextColour(255, 255, 255, 255)
	end
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(button.name)
	if selected then
		DrawRect(x,y,menu.width,menu.height,255,255,255,255)
	else
		DrawRect(x,y,menu.width,menu.height,0, 0, 0,220)
	end
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function drawMenuInfo(text)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)
	SetTextColour(255, 255, 255, 255)
	SetTextCentre(0)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawRect(0.675, 0.95,0.65,0.050,0,0,0,250)
	DrawText(0.255, 0.254)
end

function drawMenuRight(txt,x,y,selected)
	local menu = CustomVehicleShop.menu
	SetTextFont(menu.font)
	SetTextProportional(0)
	SetTextScale(0.2, 0.2)
	--SetTextRightJustify(1)
	if selected then
		SetTextColour(0,0,0, 255)
	else
		SetTextColour(255, 255, 255, 255)
		
	end
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawText(x + menu.width/2 + 0.025, y - menu.height/3 + 0.0002)

	if selected then
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,255, 255, 255,250)
	else
		DrawRect(x + menu.width/2 + 0.025, y,menu.width / 3,menu.height,0, 0, 0,250) 
	end
end

function drawMenuTitle(txt,x,y)
	local menu = CustomVehicleShop.menu
	SetTextFont(2)
	SetTextProportional(0)
	SetTextScale(0.25, 0.25)

	SetTextColour(255, 255, 255, 255)
	SetTextEntry("STRING")
	AddTextComponentString(txt)
	DrawRect(x,y,menu.width,menu.height,0,0,0,250)
	DrawText(x - menu.width/2 + 0.005, y - menu.height/2 + 0.0028)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function CustomButtonSelected(button)
	local ped = PlayerPedId()
	local this = CustomVehicleShop.currentmenu
    local btn = button.name
    
	if this == "main" then
		if btn == "Voertuigen" then
			OpenCustomMenu('coupes')
        elseif btn == "Donaties" then
            OpenCustomMenu('donos')
        
		end
	end
end

function OpenCustomMenu(menu)
    CustomVehicleShop.lastmenu = CustomVehicleShop.currentmenu
    fakecar = {model = '', car = nil}
	if menu == "vehicles" then
		CustomVehicleShop.lastmenu = "main"
    elseif menu == "donos" then
		CustomVehicleShop.lastmenu = "main"
	end
	CustomVehicleShop.menu.from = 1
	CustomVehicleShop.menu.to = 10
	CustomVehicleShop.selectedbutton = 0
	CustomVehicleShop.currentmenu = menu
end

function BackCustom()
	if backlock then
		return
	end
	backlock = true
	if CustomVehicleShop.currentmenu == "main" then
		CloseCustomCreator()
	elseif isCustomValidMenu(CustomVehicleShop.currentmenu) then
		OpenCustomMenu(CustomVehicleShop.lastmenu)
	else
		OpenCustomMenu(CustomVehicleShop.lastmenu)
	end
end

function CloseCustomCreator(name, veh, price, financed)
	Citizen.CreateThread(function()
		local ped = PlayerPedId()
		CustomVehicleShop.opened = false
		CustomVehicleShop.menu.from = 1
        CustomVehicleShop.menu.to = 10
	end)
end

function OpenCustomCreator()
	CustomVehicleShop.currentmenu = "main"
	CustomVehicleShop.opened = true
    CustomVehicleShop.selectedbutton = 0
end