QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('qb-hunt:reward')
AddEventHandler('qb-hunt:reward', function(Weight)
    local _source = source
    local xPlayer = QBCore.Functions.GetPlayer(_source)

    if Weight >= 1 then
       xPlayer.Functions.AddItem('meath', 1)
       TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['meath'], "add")
    elseif Weight >= 9 then
        xPlayer.Functions.AddItem('meath', 2)
       TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['meath'], "add")
    elseif Weight >= 15 then
        xPlayer.Functions.AddItem('meath', 3)
       TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['meath'], "add")
    end

    
	xPlayer.Functions.AddItem('meath', math.random(1, 4))
       TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['meath'], "add")
        
end)

    RegisterServerEvent('qb-hunt:sell')
    AddEventHandler('qb-hunt:sell', function()
        local Player = QBCore.Functions.GetPlayer(source)
        local SellMeat = Player.Functions.GetItemByName("meath")
        Player.Functions.RemoveItem('meath', SellMeat.amount)
        TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items['meath'], "remove")
        Player.Functions.AddMoney("cash", math.random(50, 350) * SellMeat.amount, "sold-wild-meat")
        TriggerClientEvent('QBCore:Notify', source, "You have sold " .. SellMeat.amount .. " pieces of meat. ", "success")	
    end)

RegisterServerEvent('qb-hunting:server:recieve:knife')
AddEventHandler('qb-hunting:server:recieve:knife', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("weapon_knife", 1)
    TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["weapon-knife"], "add")
end)


RegisterServerEvent('qb-hunting:server:remove:knife')
AddEventHandler('qb-hunting:server:remove:knife', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem("weapon_knife", 1)
    TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["weapon-knife"], "remove")
end)

QBCore.Functions.CreateCallback('qb-hunting:server:has:meat', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player ~= nil then
        if Player.Functions.GetItemByName("meath") ~= nil then
            cb(true)
        else
            cb(false)
        end
    end
end)