QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterNetEvent("qb-rawchicken")
AddEventHandler("qb-rawchicken", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('alivechicken') ~= nil and Player.Functions.GetItemByName('alivechicken').amount >= Config.AliveToSlaughter then
	
		local info = {}
		local date = os.time(os.date("!*t"))

		if QBCore.Shared.Items["slaughteredchicken"].expire ~= nil then
			info.date = date
			info.expire = QBCore.Shared.Items["slaughteredchicken"].expire
		else
			info.quality = 100
		end
	
        Player.Functions.RemoveItem("alivechicken", Config.AliveToSlaughter)
        Player.Functions.AddItem("slaughteredchicken", Config.AliveToSlaughter, info)
        TriggerClientEvent('DoLongHudText', src, "You Slaughtered ".. Config.AliveToSlaughter .." Alive Checken")
    else
        TriggerClientEvent('DoLongHudText', src, "You dont have any Chicken to Slaughter")
    end
end)

RegisterNetEvent("qb-alivechicken")
AddEventHandler("qb-alivechicken", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	
	local info = {}
	local date = os.time(os.date("!*t"))

	if QBCore.Shared.Items["alivechicken"].expire ~= nil then
		info.date = date
		info.expire = QBCore.Shared.Items["alivechicken"].expire
	else
		info.quality = 100
	end

    Player.Functions.AddItem('alivechicken', math.random(1,2), info)
    TriggerClientEvent('DoLongHudText', src, "You got AliveChicken")
end)

RegisterNetEvent("qb-packchicken")
AddEventHandler("qb-packchicken", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('slaughteredchicken') ~= nil and Player.Functions.GetItemByName('slaughteredchicken').amount >= 2	then
	
		local info = {}
		local date = os.time(os.date("!*t"))

		if QBCore.Shared.Items["packedchicken"].expire ~= nil then
			info.date = date
			info.expire = QBCore.Shared.Items["packedchicken"].expire
		else
			info.quality = 100
		end
	
        Player.Functions.RemoveItem("slaughteredchicken", 2)
        Player.Functions.AddItem("packedchicken", Config.SlaughterToPack, info)
        TriggerClientEvent('DoLongHudText', src, "You got 2 Chicken Pieces")
    else
        TriggerClientEvent('DoLongHudText', src, "You dont have Slaughtered chicken to pack")
    end
end)

RegisterNetEvent("qb-sellchicken")
AddEventHandler("qb-sellchicken", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.Functions.GetItemByName('packedchicken') ~= nil and Player.Functions.GetItemByName('packedchicken').amount >= Config.NumberOfSellOneTime then
        Player.Functions.RemoveItem("packedchicken", Config.NumberOfSellOneTime)
        Player.Functions.AddMoney("cash", Config.SellPrice)
        TriggerClientEvent('DoLongHudText', src, "You sold ".. Config.NumberOfSellOneTime .." pack of chicken")
    else
        TriggerClientEvent('DoLongHudText', src, "You Need to have ".. Config.NumberOfSellOneTime .." pack of chicken in order to sell")
    end
end)