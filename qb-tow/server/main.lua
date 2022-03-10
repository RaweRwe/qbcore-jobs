local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-tow:server:get:config', function(source, cb)
    cb(Config)
end)

QBCore.Functions.CreateCallback('qb-tow:server:do:bail', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.RemoveMoney('cash', Config.BailPrice, 'bail-voertuig') then
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('qb-tow:server:add:towed')
AddEventHandler('qb-tow:server:add:towed', function(PaymentAmount)
    local Player = QBCore.Functions.GetPlayer(source)
    if Config.JobData[Player.PlayerData.citizenid] ~= nil then
        Config.JobData[Player.PlayerData.citizenid]['Payment'] = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.ceil(PaymentAmount)
    else
        Config.JobData[Player.PlayerData.citizenid]= {['Payment'] = 0 + math.ceil(PaymentAmount)}
    end
    TriggerClientEvent('qb-tow:client:add:towed', -1, Player.PlayerData.citizenid, math.ceil(PaymentAmount), 'Add')
end)

RegisterServerEvent('qb-tow:server:recieve:payment')
AddEventHandler('qb-tow:server:recieve:payment', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.AddMoney('cash', Config.JobData[Player.PlayerData.citizenid]['Payment']) then
      local AmountNetto = Config.JobData[Player.PlayerData.citizenid]['Payment'] + math.random(125, 200)
      TriggerClientEvent('chatMessage', source, "Towing LS", "warning", "You recieved your payslip: €"..AmountNetto..", bruto: €"..Config.JobData[Player.PlayerData.citizenid]['Payment'])
      Config.JobData[Player.PlayerData.citizenid]['Payment'] = 0
      TriggerClientEvent('qb-tow:client:add:towed', -1, Player.PlayerData.citizenid, 0, 'Set')
    end
end)

RegisterServerEvent('qb-tow:server:return:bail:fee')
AddEventHandler('qb-tow:server:return:bail:fee', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', Config.BailPrice)
end)
