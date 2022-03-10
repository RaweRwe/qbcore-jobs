local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-taxi:server:NpcPay', function(source, cb, Payment)
	local fooi = math.random(1, 5)
    local r1, r2 = math.random(1, 5), math.random(1, 5)

    if fooi == r1 or fooi == r2 then
        Payment = Payment + math.random(5, 10)
    end

    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.AddMoney('cash', Payment)
end)

QBCore.Commands.Add("meter", "Open meter", {}, false, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "taxi" then
        TriggerClientEvent("qb-taxi:client:toggleMeter", source)
    end
end)