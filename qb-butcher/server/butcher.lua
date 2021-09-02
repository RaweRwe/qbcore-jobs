QBCore= nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore= obj end)

RegisterServerEvent('qb-pig:getNewPig')
AddEventHandler('qb-pig:getNewPig', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Received 3 Alive pig!") then
          Player.Functions.AddItem('alivepig', 3)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['alivepig'], "add")
      end
end)

RegisterServerEvent('qb-pig:getcutPig')
AddEventHandler('qb-pig:getcutPig', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "Well! You slaughtered pig.") then
          Player.Functions.RemoveItem('alivepig', 1)
          Player.Functions.AddItem('slaughteredpig', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['alivepig'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredpig'], "add")
      end
end)

RegisterServerEvent('qb-pig:getpackedPig')
AddEventHandler('qb-pig:getpackedPig', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Packed Slaughtered pig .") then
          Player.Functions.RemoveItem('slaughteredpig', 1)
          Player.Functions.AddItem('packedpig', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredpig'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['packagedpig'], "add")
      end
end)

RegisterServerEvent('qb-pig:getNewBeef')
AddEventHandler('qb-pig:getNewBeef', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Received 3 Alive cow!") then
          Player.Functions.AddItem('alivecow', 3)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['alivecow'], "add")
      end
end)

RegisterServerEvent('qb-pig:getcutBeef')
AddEventHandler('qb-pig:getcutBeef', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "Well! You slaughtered beef.") then
          Player.Functions.RemoveItem('alivecow', 1)
          Player.Functions.AddItem('slaughteredbeef', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['alivecow'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredbeef'], "add")
      end
end)

RegisterServerEvent('qb-pig:getpackedBeef')
AddEventHandler('qb-pig:getpackedBeef', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local pick = ''

      if TriggerClientEvent('DoShortHudText', src, "You Packed Slaughtered beef .") then
          Player.Functions.RemoveItem('slaughteredbeef', 1)
          Player.Functions.AddItem('packedbeef', 1)
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['slaughteredbeef'], "remove")
          TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['packagedbeef'], "add")
      end
end)
