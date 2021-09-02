QBCore = nil

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('qb-taco:server:start:black')
AddEventHandler('qb-taco:server:start:black', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('qb-taco:start:black:job', src)
    Player.Functions.AddItem("taco-bag", 1)
    TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['taco-bag'], 'add')
    TriggerClientEvent("hud:client:OnMoneyChange")
end)

QBCore.Functions.CreateCallback('qb-tacos:server:GetConfig', function(source, cb)
    cb(Config)
end)

RegisterServerEvent('qb-taco:server:reward:money')
AddEventHandler('qb-taco:server:reward:money', function()
--QBCore.Functions.CreateCallback('qb-taco:server:reward:money', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddMoney('cash', math.random(50, 312), "taco-shop-reward")
    TriggerClientEvent('QBCore:Notify', source, "Taco delivered! Go back to the taco shop for a new delivery")
    Player.Functions.RemoveItem('taco-bag', 1)
    TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['taco-bag'], 'remove')

end)

RegisterServerEvent('qb-tacos:server:get:stuff')
AddEventHandler('qb-tacos:server:get:stuff', function()
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.AddItem('taco-box', 1)
        TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['taco-box'], 'add')
    end
end)


RegisterServerEvent('qb-tacos:server:rem:taco')
AddEventHandler('qb-tacos:server:rem:taco', function()
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('taco', 1)
        TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['taco'], 'add')
    end
end)

RegisterServerEvent('qb-tacos:server:rem:tacobox')
AddEventHandler('qb-tacos:server:rem:tacobox', function()
    local Player = QBCore.Functions.GetPlayer(source)
    
    if Player ~= nil then
        Player.Functions.RemoveItem('taco', 1)
        TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['taco'], 'add')
    end
end)

RegisterServerEvent('qb-tacos:server:rem:stuff')
AddEventHandler('qb-tacos:server:rem:stuff', function(what)
    local Player = QBCore.Functions.GetPlayer(source)
    
   -- if Player ~= nil then
    if Player ~= nil and what == "meat" or what == "lettuce" or what == "taco-box" or what == "taco" then
        Player.Functions.RemoveItem(what, 1)
        TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['what'], 'add')
    end
end)

RegisterServerEvent('qb-tacos:server:add:stuff')
AddEventHandler('qb-tacos:server:add:stuff', function(what)
    local Player = QBCore.Functions.GetPlayer(source)
    
    --if Player ~= nil then
    if Player ~= nil and what == "meat" or what == "lettuce" or what == "taco-box" or what == "taco" then
        Player.Functions.AddItem(what, 1)
        TriggerClientEvent('qb-inventory:client:ItemBox', Player.PlayerData.source, QBCore.Shared.Items['what'], 'add')
    end
end)


RegisterServerEvent('qb-taco:server:set:taco:count')
AddEventHandler('qb-taco:server:set:taco:count', function(plusormin, stock, amount)
    local meatstock
    local lettucestock
    if plusormin == 'Min' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "tacos" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] - amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        end   
    elseif plusormin == 'Plus' then
        if stock == 'stock-meat' then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "stock-lettuce" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "tacos" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        elseif stock == "register" then
            Config.JobData[stock] = Config.JobData[stock] + amount
            TriggerClientEvent('qb-tacos:client:SetStock', -1, stock, Config.JobData[stock])
        end
    end
end)


QBCore.Functions.CreateCallback('qb-taco:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("lettuce")
    local meat = Ply.Functions.GetItemByName("meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-taco:server:get:tacobox', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local box = Ply.Functions.GetItemByName("taco-box")
    if box ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-taco:server:get:tacos', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)