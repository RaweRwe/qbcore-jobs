QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

-- code


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
RegisterNetEvent('qb-vehicleshop:server:buyVehicle')
AddEventHandler('qb-vehicleshop:server:buyVehicle', function(vehicleData, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    local vData = QBCore.Shared.Vehicles[vehicleData["model"]]
    local balance = pData.PlayerData.money["bank"]
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}

    if (balance - vData["price"]) >= 0 then
        local plate = GeneratePlate()
        --QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `garage`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vData["model"].."', '"..GetHashKey(vData["model"]).."', '{}', '"..plate.."', '"..garage.."')")
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vData["model"].."', '"..plate.."', 'Rode Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("QBCore:Notify", src, "Thank you! Your vehicle has been delivered", "success", 5000)
        pData.Functions.RemoveMoney('bank', vData["price"], "vehicle-bought-in-shop")
       else
		TriggerClientEvent("QBCore:Notify", src, "You dont have enough cash. You are missing: €"..format_thousand(vData["price"] - balance), "error", 5000)
    end
end)

RegisterNetEvent('qb-vehicleshop:server:buyShowroomVehicle')
AddEventHandler('qb-vehicleshop:server:buyShowroomVehicle', function(vehicle, class)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]["price"]
    --print(vehicle)
    local Model = QBCore.Shared.Vehicles[vehicle]["price"]
    local plate = GeneratePlate()

    if (balance - vehiclePrice) >= 0 then
        --QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`steam`, `citizenid`, `vehicle`, `hash`, `mods`, `plate`, `state`) VALUES ('"..pData.PlayerData.steam.."', '"..cid.."', '"..vehicle.."', '"..GetHashKey(vehicle).."', '{}', '"..plate.."', 0)")
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..vehicle.."', '"..plate.."', 'Rode Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
 
        TriggerClientEvent("QBCore:Notify", src, "Thank you! your vehicle will be with you shortly.", "success", 5000)
        TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        pData.Functions.RemoveMoney('bank', vehiclePrice, "vehicle-bought-in-showroom")
    else
        TriggerClientEvent("QBCore:Notify", src, "You dont have enough funds on your bank account. You are missing: €"..format_thousand(vehiclePrice - balance), "error", 5000)
    end
end)

function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function GeneratePlate()
    local plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
    QBCore.Functions.ExecuteSql(true, "SELECT * FROM `characters_vehicles` WHERE `plate` = '"..plate.."'", function(result)
        while (result[1] ~= nil) do
            plate = tostring(GetRandomNumber(1)) .. GetRandomLetter(2) .. tostring(GetRandomNumber(3)) .. GetRandomLetter(2)
        end
        return plate
    end)
    return plate:upper()
end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterServerEvent('qb-vehicleshop:server:setShowroomCarInUse')
AddEventHandler('qb-vehicleshop:server:setShowroomCarInUse', function(showroomVehicle, bool)
    Pepe.ShowroomVehicles[showroomVehicle].inUse = bool
    TriggerClientEvent('qb-vehicleshop:client:setShowroomCarInUse', -1, showroomVehicle, bool)
end)

RegisterServerEvent('qb-vehicleshop:server:setShowroomVehicle')
AddEventHandler('qb-vehicleshop:server:setShowroomVehicle', function(vData, k)
    Pepe.ShowroomVehicles[k].chosenVehicle = vData
    TriggerClientEvent('qb-vehicleshop:client:setShowroomVehicle', -1, vData, k)
end)

RegisterServerEvent('qb-vehicleshop:server:SetCustomShowroomVeh')
AddEventHandler('qb-vehicleshop:server:SetCustomShowroomVeh', function(vData, k)
    Pepe.ShowroomVehicles[k].vehicle = vData
    TriggerClientEvent('qb-vehicleshop:client:SetCustomShowroomVeh', -1, vData, k)
end)

QBCore.Commands.Add("sellv", "Sell vehicle from Luxery", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        if TargetId ~= nil then
            TriggerClientEvent('qb-vehicleshop:client:SellCustomVehicle', source, TargetId)
        else
            TriggerClientEvent('QBCore:Notify', source, 'You need to enter an ID!', 'error')
        end
    else
        TriggerClientEvent('QBCore:Notify', source, 'You are not a cardealer', 'error')
    end
end)

QBCore.Commands.Add("testrit", "Do a testdrive", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetId = args[1]

    if Player.PlayerData.job.name == "cardealer" then
        TriggerClientEvent('qb-vehicleshop:client:DoTestrit', source, GeneratePlate())
    else
        TriggerClientEvent('QBCore:Notify', source, 'You are not a cardealer', 'error')
    end
end)

RegisterServerEvent('qb-vehicleshop:server:SellCustomVehicle')
AddEventHandler('qb-vehicleshop:server:SellCustomVehicle', function(TargetId, ShowroomSlot)
    TriggerClientEvent('qb-vehicleshop:client:SetVehicleBuying', TargetId, ShowroomSlot)
end)

RegisterServerEvent('qb-vehicleshop:server:ConfirmVehicle')
AddEventHandler('qb-vehicleshop:server:ConfirmVehicle', function(ShowroomVehicle)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local VehPrice = QBCore.Shared.Vehicles[ShowroomVehicle.vehicle].price
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid
    
    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    local balance = pData.PlayerData.money["bank"]
    local vehiclePrice = QBCore.Shared.Vehicles[vehicle]["price"]

    --local VehicleData = QBCore.Shared.Vehicles[ShowroomVehicle]
    local plate = GeneratePlate()

    local GarageData = {garagename = 'Blokken Parking', garagenumber = 1}
    local VehicleMeta = {Fuel = 100.0, Body = 1000.0, Engine = 1000.0}
    if Player.PlayerData.money.cash >= VehPrice then
        Player.Functions.RemoveMoney('cash', VehPrice)
        TriggerClientEvent('qb-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..ShowroomVehicle.."', '"..plate.."', 'Rode Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    elseif Player.PlayerData.money.bank >= VehPrice then
        Player.Functions.RemoveMoney('bank', VehPrice)
        TriggerClientEvent('qb-vehicleshop:client:ConfirmVehicle', src, ShowroomVehicle, plate)
        QBCore.Functions.ExecuteSql(false, "INSERT INTO `characters_vehicles` (`citizenid`, `vehicle`, `plate`, `garage`, `state`, `mods`, `metadata`) VALUES ('"..pData.PlayerData.citizenid.."', '"..ShowroomVehicle.."', '"..plate.."', 'Rode Parking', 'out', '{}', '"..json.encode(VehicleMeta).."')")
    else
        if Player.PlayerData.money.cash > Player.PlayerData.money.bank then
            TriggerClientEvent('QBCore:Notify', src, 'You dont have enough cash. You are missing: ('..(Player.PlayerData.money.cash - VehPrice)..',-)')
        else
            TriggerClientEvent('QBCore:Notify', src, 'You dont have enough funds on the bank account. You are missing: ('..(Player.PlayerData.money.bank - VehPrice)..',-)')
        end
    end
end)

QBCore.Functions.CreateCallback('qb-vehicleshop:server:SellVehicle', function(source, cb, vehicle, plate)
    local VehicleData = QBCore.Shared.Vehicles[vehicle]
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            Player.Functions.AddMoney('bank', math.ceil(VehicleData["price"] / 100 * 60))
            QBCore.Functions.ExecuteSql(false, "DELETE FROM `characters_vehicles` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `plate` = '"..plate.."'")
            cb(true)
        else
            cb(false)
        end
    end)
end)