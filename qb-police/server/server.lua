local QBCore = exports['qb-core']:GetCoreObject()

local Casings = {}
local HairDrops = {}
local BloodDrops = {}
local SlimeDrops = {}
local FingerDrops = {}
local PlayerStatus = {}
local Objects = {}

RegisterServerEvent('qb-police:server:UpdateBlips')
AddEventHandler('qb-police:server:UpdateBlips', function()
    local src = source
    local dutyPlayers = {}
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if ((Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "ambulance") and Player.PlayerData.job.onduty) then
                table.insert(dutyPlayers, {
                    source = Player.PlayerData.source,
                    label = Player.PlayerData.metadata["callsign"]..' | '..Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname,
                    job = Player.PlayerData.job.name,
                })
            end
        end
    end
    TriggerClientEvent("qb-police:client:UpdateBlips", -1, dutyPlayers)
end)

-- // Loops \\ --

Citizen.CreateThread(function()
  while true do 
    Citizen.Wait(0)
    local CurrentCops = GetCurrentCops()
    TriggerClientEvent("qb-police:SetCopCount", -1, CurrentCops)
    Citizen.Wait(1000 * 60 * 3)
  end
end)

-- // Functions \\ --

function GetCurrentCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    return amount
end

-- // Evidence Events \\ --

RegisterServerEvent('qb-police:server:CreateCasing')
AddEventHandler('qb-police:server:CreateCasing', function(weapon, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local casingId = CreateIdType('casing')
    local weaponInfo = exports['qb-weapons']:GetWeaponList(weapon)
    local serieNumber = nil
    if weaponInfo ~= nil then 
        local weaponItem = Player.Functions.GetItemByName(weaponInfo["IdName"])
        if weaponItem ~= nil then
            if weaponItem.info ~= nil and weaponItem.info ~= "" then 
                serieNumber = weaponItem.info.serie
            end
        end
    end
    TriggerClientEvent("qb-police:client:AddCasing", -1, casingId, weapon, coords, serieNumber)
end)


RegisterServerEvent('qb-police:server:impound:vehicle')
AddEventHandler('qb-police:server:impound:vehicle', function(vehicle)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
    TriggerEvent("qb-garages:server:set:in:impound", vehicle)
end)

RegisterServerEvent('qb-police:server:CreateBloodDrop')
AddEventHandler('qb-police:server:CreateBloodDrop', function(coords)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
 local bloodId = CreateIdType('blood')
 BloodDrops[bloodId] = Player.PlayerData.metadata["bloodtype"]
 TriggerClientEvent("qb-police:client:AddBlooddrop", -1, bloodId, Player.PlayerData.metadata["bloodtype"], coords)
end)

RegisterServerEvent('qb-police:server:CreateFingerDrop')
AddEventHandler('qb-police:server:CreateFingerDrop', function(coords)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
 local fingerId = CreateIdType('finger')
 FingerDrops[fingerId] = Player.PlayerData.metadata["fingerprint"]
 TriggerClientEvent("qb-police:client:AddFingerPrint", -1, fingerId, Player.PlayerData.metadata["fingerprint"], coords)
end)

RegisterServerEvent('qb-police:server:CreateHairDrop')
AddEventHandler('qb-police:server:CreateHairDrop', function(coords)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
 local HairId = CreateIdType('hair')
 HairDrops[HairId] = Player.PlayerData.metadata["haircode"]
 TriggerClientEvent("qb-police:client:AddHair", -1, HairId, Player.PlayerData.metadata["haircode"], coords)
end)

RegisterServerEvent('qb-police:server:CreateSlimeDrop')
AddEventHandler('qb-police:server:CreateSlimeDrop', function(coords)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
 local SlimeId = CreateIdType('slime')
 SlimeDrops[SlimeId] = Player.PlayerData.metadata["slimecode"]
 TriggerClientEvent("qb-police:client:AddSlime", -1, SlimeId, Player.PlayerData.metadata["slimecode"], coords)
end)

RegisterServerEvent('qb-police:server:AddEvidenceToInventory')
AddEventHandler('qb-police:server:AddEvidenceToInventory', function(EvidenceType, EvidenceId, EvidenceInfo)
 local src = source
 local Player = QBCore.Functions.GetPlayer(src)
 if Player.Functions.RemoveItem("empty_evidence_bag", 1) then
    if Player.Functions.AddItem("filled_evidence_bag", 1, false, EvidenceInfo) then
        RemoveDna(EvidenceType, EvidenceId)
        TriggerClientEvent("qb-police:client:RemoveDnaId", -1, EvidenceType, EvidenceId)
        TriggerClientEvent("qb-inventory:client:ItemBox", src, QBCore.Shared.Items["filled_evidence_bag"], "add")
    end
 else
    TriggerClientEvent('QBCore:Notify', src, "Kanıt çantasına ihtiyacın var", "error")
 end
end)

-- // Finger Scanner \\ --

RegisterServerEvent('qb-police:server:show:machine')
AddEventHandler('qb-police:server:show:machine', function(PlayerId)
    local Player = QBCore.Functions.GetPlayer(PlayerId)
    TriggerClientEvent('qb-police:client:show:machine', PlayerId, source)
    TriggerClientEvent('qb-police:client:show:machine', source, PlayerId)
end)

RegisterServerEvent('qb-police:server:showFingerId')
AddEventHandler('qb-police:server:showFingerId', function(FingerPrintSession)
 local Player = QBCore.Functions.GetPlayer(source)
 local FingerId = Player.PlayerData.metadata["fingerprint"] 
 if math.random(1,25)  <= 15 then
 TriggerClientEvent('qb-police:client:show:fingerprint:id', FingerPrintSession, FingerId)
 TriggerClientEvent('qb-police:client:show:fingerprint:id', source, FingerId)
 end
end)

RegisterServerEvent('qb-police:server:set:tracker')
AddEventHandler('qb-police:server:set:tracker', function(TargetId)
    local Target = QBCore.Functions.GetPlayer(TargetId)
    local TrackerMeta = Target.PlayerData.metadata["tracker"]
    if TrackerMeta then
        Target.Functions.SetMetaData("tracker", false)
        TriggerClientEvent('QBCore:Notify', TargetId, 'İzleyici Çıkarıldı.', 'error', 5000)
        TriggerClientEvent('QBCore:Notify', source, 'İzleyici Çıkarıldı '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('qb-police:client:set:tracker', TargetId, false)
    else
        Target.Functions.SetMetaData("tracker", true)
        TriggerClientEvent('QBCore:Notify', TargetId, 'Mahkeme tarafından bir ceza aldınız.', 'error', 5000)
        TriggerClientEvent('QBCore:Notify', source, 'Takıldı '..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname, 'error', 5000)
        TriggerClientEvent('qb-police:client:set:tracker', TargetId, true)
    end
end)

RegisterServerEvent('qb-police:server:send:tracker:location')
AddEventHandler('qb-police:server:send:tracker:location', function(Coords, RequestId)
    local Target = QBCore.Functions.GetPlayer(RequestId)
    local AlertData = {title = "Enkelband Locatie", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Anklebracelet location of: "..Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname}
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('qb-police:client:send:tracker:alert', -1, Coords, Target.PlayerData.charinfo.firstname.." "..Target.PlayerData.charinfo.lastname)
end)

-- // Update Cops \\ --
RegisterServerEvent('qb-police:server:UpdateCurrentCops')
AddEventHandler('qb-police:server:UpdateCurrentCops', function()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police" and Player.PlayerData.job.onduty) then
                amount = amount + 1
            end
        end
    end
    TriggerClientEvent("qb-police:SetCopCount", -1, amount)
end)

RegisterServerEvent('qb-police:server:UpdateStatus')
AddEventHandler('qb-police:server:UpdateStatus', function(data)
    local src = source
    PlayerStatus[src] = data
end)

RegisterServerEvent('qb-police:server:ClearDrops')
AddEventHandler('qb-police:server:ClearDrops', function(Type, List)
    local src = source
    if Type == 'casing' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("qb-police:client:RemoveDnaId", -1, 'casing', v)
                Casings[v] = nil
            end
        end
    elseif Type == 'finger' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("qb-police:client:RemoveDnaId", -1, 'finger', v)
                FingerDrops[v] = nil
            end
        end
    elseif Type == 'blood' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("qb-police:client:RemoveDnaId", -1, 'blood', v)
                BloodDrops[v] = nil
            end
        end
    elseif Type == 'Hair' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("qb-police:client:RemoveDnaId", -1, 'hair', v)
                HairDrops[v] = nil
            end
        end
    elseif Type == 'Slime' then
        if List ~= nil and next(List) ~= nil then 
            for k, v in pairs(List) do
                TriggerClientEvent("qb-police:client:RemoveDnaId", -1, 'slime', v)
                HairDrops[v] = nil
            end
        end
    end
end)

QBCore.Functions.CreateCallback('qb-police:GetImpoundedVehicles', function(source, cb)
    local vehicles = {}
    exports.oxmysql:execute('SELECT * FROM characters_vehicles WHERE garage = @garage', {['@garage'] = "Police"}, function(result)
        if result[1] ~= nil then
            vehicles = result
        end
        cb(vehicles)
    end)
end)

function RemoveDna(EvidenceType, EvidenceId)
 if EvidenceType == 'hair' then
     HairDrops[EvidenceId] = nil
 elseif EvidenceType == 'blood' then
     BloodDrops[EvidenceId] = nil
 elseif EvidenceType == 'finger' then
     FingerDrops[EvidenceId] = nil
 elseif EvidenceType == 'slime' then
     SlimeDrops[EvidenceId] = nil
 elseif EvidenceType == 'casing' then
     Casings[EvidenceId] = nil
 end
end

-- // Functions \\ --

function CreateIdType(Type)
    if Type == 'casing' then
        if Casings ~= nil then
	    	local caseId = math.random(10000, 99999)
	    	while Casings[caseId] ~= nil do
	    		caseId = math.random(10000, 99999)
	    	end
	    	return caseId
	    else
	    	local caseId = math.random(10000, 99999)
	    	return caseId
        end
    elseif Type == 'finger' then
        if FingerDrops ~= nil then
            local fingerId = math.random(10000, 99999)
            while FingerDrops[fingerId] ~= nil do
                fingerId = math.random(10000, 99999)
            end
            return fingerId
        else
            local fingerId = math.random(10000, 99999)
            return fingerId
        end
    elseif Type == 'blood' then
        if BloodDrops ~= nil then
            local bloodId = math.random(10000, 99999)
            while BloodDrops[bloodId] ~= nil do
                bloodId = math.random(10000, 99999)
            end
            return bloodId
        else
            local bloodId = math.random(10000, 99999)
            return bloodId
        end
    elseif Type == 'hair' then
        if HairDrops ~= nil then
            local hairId = math.random(10000, 99999)
            while HairDrops[hairId] ~= nil do
                hairId = math.random(10000, 99999)
            end
            return hairId
        else
            local hairId = math.random(10000, 99999)
            return hairId
        end
    elseif Type == 'slime' then
        if SlimeDrops ~= nil then
            local slimeId = math.random(10000, 99999)
            while SlimeDrops[slimeId] ~= nil do
                slimeId = math.random(10000, 99999)
            end
            return slimeId
        else
            local slimeId = math.random(10000, 99999)
            return slimeId
        end
   end
end

-- // Commands \\ --

QBCore.Commands.Add("cuff", "toggle handcuffs (Admin)", {{name="ID", help="PlayerId"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args ~= nil then
     local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
       if TargetPlayer ~= nil then
         TriggerClientEvent("qb-police:client:get:cuffed", TargetPlayer.PlayerData.source, Player.PlayerData.source)
       end
    end
end, "admin")

QBCore.Commands.Add("sethighcommand", "Chef Ata", {{name="ID", help="PlayerId"}, {name="Status", help="True/False"}}, true, function(source, args)
  if args ~= nil then
    local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayer ~= nil then
      if args[2]:lower() == 'true' then
          TargetPlayer.Functions.SetMetaData("ishighcommand", true)
          TriggerClientEvent('QBCore:Notify', TargetPlayer.PlayerData.source, 'Artık bir yöneticisiniz!', 'success')
          TriggerClientEvent('QBCore:Notify', source, 'Artık Siz Sorumlusunuz!', 'success')
      else
          TargetPlayer.Functions.SetMetaData("ishighcommand", false)
          TriggerClientEvent('QBCore:Notify', TargetPlayer.PlayerData.source, 'Artık yetkili sen değilsin.!', 'error')
          TriggerClientEvent('QBCore:Notify', source, 'Artık Siz Sorumlu Değilsiniz!', 'error')
      end
    end
  end
end, "god")

QBCore.Commands.Add("setpolice", "Polis Ata", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('QBCore:Notify', TargetPlayer.PlayerData.source, 'İşle Alındın Başarılar!', 'success')
          TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'Sahipsin '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' hired as an agent!', 'success')
          TargetPlayer.Functions.SetJob('police')
      end
    end
end)

QBCore.Commands.Add("firepolice", "Polisi Çıkar", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if Player.PlayerData.metadata['ishighcommand'] then
      if TargetPlayer ~= nil then
          TriggerClientEvent('QBCore:Notify', TargetPlayer.PlayerData.source, 'Sen Atıldın!!', 'error')
          TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, 'Artık '..TargetPlayer.PlayerData.charinfo.firstname..' '..TargetPlayer.PlayerData.charinfo.lastname..' quit!', 'success')
          TargetPlayer.Functions.SetJob('unemployed')
      end
    end
end)

QBCore.Commands.Add("callsign", "Kodları Değiştir", {{name="Numara", help="Servis numarası"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
         Player.Functions.SetMetaData("callsign", args[1])
         TriggerClientEvent('QBCore:Notify', source, 'Servis numarası başarıyla değiştirildi. Sen şimdi: ' ..args[1], 'success')
        else
            TriggerClientEvent('QBCore:Notify', source, 'Bu sadece acil servisler içindir..', 'error')
        end
    end
end)

QBCore.Commands.Add("setplate", "Vardiya plaka numaranızı değiştirin", {{name="Number", help="Service number"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] ~= nil then
        if Player.PlayerData.job.name == 'police' or Player.PlayerData.job.name == 'ambulance' and Player.PlayerData.job.onduty then
           if args[1]:len() == 8 then
             Player.Functions.SetDutyPlate(args[1])
             TriggerClientEvent('QBCore:Notify', source, 'Plaka başarıyla uyarlandı. Servis kayıt numaranız: ' ..args[1], 'success')
           else
               TriggerClientEvent('QBCore:Notify', source, 'Tam olarak 8 karakter uzunluğunda olmalı..', 'error')
           end
        else
            TriggerClientEvent('QBCore:Notify', source, 'Bu sadece acil servisler içindir ..', 'error')
        end
    end
end)

QBCore.Commands.Add("kluis", "Açık kanıt güvenli", {{"bsn", "BSN Number"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if args[1] ~= nil then 
    if ((Player.PlayerData.job.name == "police") and Player.PlayerData.job.onduty) then
        TriggerClientEvent("qb-police:client:open:evidence", source, args[1])
    else
        TriggerClientEvent('QBCore:Notify', source, "Bu eylem için polis memuru olmanız gerekiyor", "error")
    end
  else
    TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Tüm argümanları doldur")
 end
end)

QBCore.Commands.Add("setdutyvehicle", "İş Aracı Verin", {{name="Id", help="Server ID"}, {name="Vehicle", help="Standaard / Audi / Heli / Motor / Unmarked"}, {name="state", help="True / False"}}, true, function(source, args)
    local SelfPlayerData = QBCore.Functions.GetPlayer(source)
    local TargetPlayerData = QBCore.Functions.GetPlayer(tonumber(args[1]))
    if TargetPlayerData ~= nil then
        local TargetPlayerVehicleData = TargetPlayerData.PlayerData.metadata['duty-vehicles']
        if SelfPlayerData.PlayerData.metadata['ishighcommand'] then
           if args[2]:upper() == 'STANDAARD' then
               if args[3] == 'true' then
                   VehicleList = {Standard = true, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = false, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end
           elseif args[2]:upper() == 'AUDI' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = true, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = false, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end
           elseif args[2]:upper() == 'UNMARKED' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = true}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = TargetPlayerVehicleData.Motor, Unmarked = false}
               end 
            elseif args[2]:upper() == 'MOTOR' then
                if args[3] == 'true' then
                    VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = true, Unmarked = TargetPlayerVehicleData.Unmarked}
                else
                    VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = TargetPlayerVehicleData.Heli, Motor = false, Unmarked = TargetPlayerVehicleData.Unmarked}
                end 
           elseif args[2]:upper() == 'HELI' then
               if args[3] == 'true' then
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = true, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               else
                   VehicleList = {Standard = TargetPlayerVehicleData.Standard, Audi = TargetPlayerVehicleData.Audi, Heli = false, Motor = TargetPlayerVehicleData.Motor, Unmarked = TargetPlayerVehicleData.Unmarked}
               end 
           end
           local PlayerCredentials = TargetPlayerData.PlayerData.metadata['callsign']..' | '..TargetPlayerData.PlayerData.charinfo.firstname..' '..TargetPlayerData.PlayerData.charinfo.lastname
           TargetPlayerData.Functions.SetMetaData("duty-vehicles", VehicleList)
           TriggerClientEvent('qb-radialmenu:client:update:duty:vehicles', TargetPlayerData.PlayerData.source)
           if args[3] == 'true' then
               TriggerClientEvent('QBCore:Notify', TargetPlayerData.PlayerData.source, 'Araç  aldınız: ('..args[2]:upper()..')', 'success')
               TriggerClientEvent('QBCore:Notify', SelfPlayerData.PlayerData.source, 'Verilmiş ('..args[2]:upper()..') uzmanlık '..PlayerCredentials, 'success')
           else
               TriggerClientEvent('QBCore:Notify', TargetPlayerData.PlayerData.source, 'Senin Aracın ('..args[2]:upper()..') İptal Edildi..', 'error')
               TriggerClientEvent('QBCore:Notify', SelfPlayerData.PlayerData.source, 'Araç Kaldırıldı ('..args[2]:upper()..') from '..PlayerCredentials, 'error')
           end
        end
    end
end)

QBCore.Commands.Add("bill", "Para Cezası Uygula", {{name="id", help="Player id"},{name="geld", help="Hoeveel"}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    local TargetPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
    local Amount = tonumber(args[2])
    if TargetPlayer ~= nil then
       if Player.PlayerData.job.name == "police" then
         if Amount > 0 then
          TriggerClientEvent("qb-police:client:bill:player", TargetPlayer.PlayerData.source, Amount)
	   	  TriggerEvent('qb-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Politie', 'invoice')  
         else
             TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Miktarın 0 Büyük Olması Gerekiyor! ")
         end
       elseif Player.PlayerData.job.name == "realestate" then
        if Amount > 0 then
               TriggerEvent('qb-phone:server:add:invoice', TargetPlayer.PlayerData.citizenid, Amount, 'Makelaar', 'realestate')  
           else
               TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Miktarın 0 Büyük Olması Gerekiyor")
           end
       else
           TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Bu Komut Polisler İçindir")
       end
    end
end)

QBCore.Commands.Add("paylaw", "Avukata Ödeme Yap", {{name="id", help="ID "}, {name="amount", help="Hoeveel?"}}, true, function(source, args)
	local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "judge" then
        local playerId = tonumber(args[1])
        local Amount = tonumber(args[2])
        local OtherPlayer = QBCore.Functions.GetPlayer(playerId)
        if OtherPlayer ~= nil then
            if OtherPlayer.PlayerData.job.name == "lawyer" then
                OtherPlayer.Functions.AddMoney("bank", Amount, "police-lawyer-paid")
                TriggerClientEvent('chatMessage', OtherPlayer.PlayerData.source, "SYSTEM", "warning", "Aldın €"..Amount..",- Hizmet Karşılığı")
                TriggerClientEvent('QBCore:Notify', source, 'Avukata ödeme yaptınız')
            else
                TriggerClientEvent('QBCore:Notify', source, 'Kişi Avukat Değil', "error")
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Bu Komut Polis Memurları İçindir.")
    end
end)

QBCore.Commands.Add("911", "Yardım çağrısı gönder", {{name="message", help="Memurlara göndermek istediğiniz mesajı yazın"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent('qb-police:client:send:alert', source, Message, false)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Telefonun Yok..', 'error')
    end
end)

QBCore.Commands.Add("911a", "Memurlara gizli çağrı gönder", {{name="message", help="Memurlara göndermek istediğiniz mesajı yazın"}}, true, function(source, args)
    local Message = table.concat(args, " ")
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName("phone") ~= nil then
        TriggerClientEvent("qb-police:client:call:anim", source)
        TriggerClientEvent('qb-police:client:send:alert', -1, Message, true)
    else
        TriggerClientEvent('QBCore:Notify', source, 'Telefonun Yok..', 'error')
    end
end)

QBCore.Commands.Add("bracelet", "Konum Bilgisi Al", {{name="bsn", help="BSN "}}, true, function(source, args)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if args[1] ~= nil then
            local citizenid = args[1]
            local Target = QBCore.Functions.GetPlayerByCitizenId(citizenid)
            local Tracking = false
            if Target ~= nil then
                if Target.PlayerData.metadata["tracker"] and not Tracking then
                    Tracking = true
                    TriggerClientEvent("qb-police:client:send:tracker:location", Target.PlayerData.source, Target.PlayerData.source)
                else
                    TriggerClientEvent('QBCore:Notify', source, 'Bu Kişide Takip Cihazı Yok.', 'error')
                end
            end
        end
    else
        TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Bu Komut Polisler İçin")
    end
end)

QBCore.Functions.CreateUseableItem("handcuffs", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("qb-police:client:cuff:closest", source)
    end
end)

-- // HandCuffs \\ --
RegisterServerEvent('qb-police:server:cuff:closest')
AddEventHandler('qb-police:server:cuff:closest', function(SeverId)
    local Player = QBCore.Functions.GetPlayer(source)
    local CuffedPlayer = QBCore.Functions.GetPlayer(SeverId)
    if CuffedPlayer ~= nil then
        --TriggerEvent("qb-logs:server:SendLog", "cuffing", "Handcuffs", "pink", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."*) heeft zijn boeien gebruikt op: **".. GetPlayerName(SeverId) .."** (citizenid: *" ..CuffedPlayer.PlayerData.citizenid.."*)")
        TriggerClientEvent("qb-police:client:get:cuffed", CuffedPlayer.PlayerData.source, Player.PlayerData.source)
    end
end)

RegisterServerEvent('qb-police:server:set:handcuff:status')
AddEventHandler('qb-police:server:set:handcuff:status', function(Cuffed)
	local Player = QBCore.Functions.GetPlayer(source)
	if Player ~= nil then
		Player.Functions.SetMetaData("ishandcuffed", Cuffed)
	end
end)

RegisterServerEvent('qb-police:server:escort:closest')
AddEventHandler('qb-police:server:escort:closest', function(SeverId)
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(SeverId)
    if EscortPlayer ~= nil then
        if (EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"]) then
            TriggerClientEvent("qb-police:client:get:escorted", EscortPlayer.PlayerData.source, Player.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Kişi ölü değil yada kelepçelenmedi")
        end
    end
end)

RegisterServerEvent('qb-police:server:set:out:veh')
AddEventHandler('qb-police:server:set:out:veh', function(ServerId)
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("qb-police:client:set:out:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Kişi ölü değil yada kelepçelenmedi")
        end
    end
end)

RegisterServerEvent('qb-police:server:set:in:veh')
AddEventHandler('qb-police:server:set:in:veh', function(ServerId)
    local Player = QBCore.Functions.GetPlayer(source)
    local EscortPlayer = QBCore.Functions.GetPlayer(ServerId)
    if EscortPlayer ~= nil then
        if EscortPlayer.PlayerData.metadata["ishandcuffed"] or EscortPlayer.PlayerData.metadata["isdead"] then
            TriggerClientEvent("qb-police:client:set:in:veh", EscortPlayer.PlayerData.source)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Kişi ölü değil yada kelepçelenmedi")
        end
    end
end)

QBCore.Functions.CreateCallback('qb-police:server:is:player:dead', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["isdead"])
end)

QBCore.Functions.CreateCallback('qb-police:server:is:inventory:disabled', function(source, cb, playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    cb(Player.PlayerData.metadata["inventorydisabled"])
end)

RegisterServerEvent('qb-police:server:SearchPlayer')
AddEventHandler('qb-police:server:SearchPlayer', function(playerId)
    local src = source
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        TriggerClientEvent('chatMessage', source, "SYSTEM", "warning", "Kişinin Cebinde €"..SearchedPlayer.PlayerData.money["cash"]..",- Var..")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Aranıyorsun")
    end
end)

RegisterServerEvent('qb-police:server:rob:player')
AddEventHandler('qb-police:server:rob:player', function(playerId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local SearchedPlayer = QBCore.Functions.GetPlayer(playerId)
    if SearchedPlayer ~= nil then 
        local money = SearchedPlayer.PlayerData.money["cash"]
        Player.Functions.AddMoney("cash", money, "police-player-robbed")
        SearchedPlayer.Functions.RemoveMoney("cash", money, "police-player-robbed")
        TriggerClientEvent('QBCore:Notify', SearchedPlayer.PlayerData.source, "Soydular boşa gitti €"..money.."")
    end
end)

RegisterServerEvent('qb-police:server:send:call:alert')
AddEventHandler('qb-police:server:send:call:alert', function(Coords, Message)
 local Player = QBCore.Functions.GetPlayer(source)
 local Name = Player.PlayerData.charinfo.firstname..' '..Player.PlayerData.charinfo.lastname
 local AlertData = {title = "112 Melding - "..Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname .. " ("..source..")", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = Message}
 TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
 TriggerClientEvent('qb-police:client:send:message', -1, Coords, Message, Name)
end)

RegisterServerEvent('qb-police:server:spawn:object')
AddEventHandler('qb-police:server:spawn:object', function(type)
    local src = source
    local objectId = CreateIdType('casing')
    Objects[objectId] = type
    TriggerClientEvent("qb-police:client:place:object", -1, objectId, type, src)
end)

RegisterServerEvent('qb-police:server:delete:object')
AddEventHandler('qb-police:server:delete:object', function(objectId)
    local src = source
    TriggerClientEvent('qb-police:client:remove:object', -1, objectId)
end)

-- // Police Alerts Events \\ --

RegisterServerEvent('qb-police:server:send:alert:officer:down')
AddEventHandler('qb-police:server:send:alert:officer:down', function(Coords, StreetName, Info, Priority)
   TriggerClientEvent('qb-police:client:send:officer:down', -1, Coords, StreetName, Info, Priority)
end)

RegisterServerEvent('qb-police:server:send:alert:panic:button')
AddEventHandler('qb-police:server:send:alert:panic:button', function(Coords, StreetName, Info)
    local AlertData = {title = "Assistence Collegue", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Acil Durum Kullanıldı "..Info['Callsign'].." "..Info['Firstname']..' '..Info['Lastname'].." bij "..StreetName}
    TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
    TriggerClientEvent('qb-police:client:send:alert:panic:button', -1, Coords, StreetName, Info)
end)

RegisterServerEvent('qb-police:server:send:alert:gunshots')
AddEventHandler('qb-police:server:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
    local AlertData = {title = "Schoten Gelost",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Yakınlarda ateş açıldı ' ..StreetName}
    if InVeh then
      AlertData = {title = "Schoten Gelost",coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = 'Yakındaki bir araçtan ateş açıldı ' ..StreetName}
    end
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:alert:gunshots', -1, Coords, GunType, StreetName, InVeh)
end)

RegisterServerEvent('qb-police:server:send:alert:dead')
AddEventHandler('qb-police:server:send:alert:dead', function(Coords, StreetName)
   local AlertData = {title = "Gewonde Burger", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Kişi yere düştü "..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:alert:dead', -1, Coords, StreetName)
end)

RegisterServerEvent('qb-police:server:send:bank:alert')
AddEventHandler('qb-police:server:send:bank:alert', function(Coords, StreetName, CamId)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Bankadan kaçma alarmı şu anda tetiklendi "..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:bank:alert', -1, Coords, StreetName, CamId)
end)

RegisterServerEvent('qb-police:server:send:big:bank:alert')
AddEventHandler('qb-police:server:send:big:bank:alert', function(Coords, StreetName)
   local AlertData = {title = "Bank Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Pasifik Bankası alarmı şu adreste tetiklendi: "..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:big:bank:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('qb-police:server:send:alert:jewellery')
AddEventHandler('qb-police:server:send:alert:jewellery', function(Coords, StreetName)
   local AlertData = {title = "Juwelier Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Vangelico mücevher alarmı Konum: "..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:alert:jewellery', -1, Coords, StreetName)
end)

RegisterServerEvent('qb-police:server:send:alert:store')
AddEventHandler('qb-police:server:send:alert:store', function(Coords, StreetName, StoreNumber)
   local AlertData = {title = "Store Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Mağaza alarmı: "..StoreNumber..' şu anda etkinleştirildi '..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:alert:store', -1, Coords, StreetName, StoreNumber)
end)

RegisterServerEvent('qb-police:server:send:house:alert')
AddEventHandler('qb-police:server:send:house:alert', function(Coords, StreetName)
   local AlertData = {title = "Huis Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Ev Soygunu Alarımı Etkinleştirildi "..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:house:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('qb-police:server:send:banktruck:alert')
AddEventHandler('qb-police:server:send:banktruck:alert', function(Coords, Plate, StreetName)
   local AlertData = {title = "Bank Truck Alarm", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Banka kamyonu soygunu bildirildi. Plaka numarası: "..Plate..'. near '..StreetName}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:banktruck:alert', -1, Coords, Plate, StreetName)
end)

RegisterServerEvent('qb-police:server:alert:explosion')
AddEventHandler('qb-police:server:alert:explosion', function(Coords, StreetName)
   local AlertData = {title = "Explosie Melding", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Yakınlarda patlama olduğu bildirildi: "..StreetName.."."}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:explosion:alert', -1, Coords, StreetName)
end)

RegisterServerEvent('qb-police:server:alert:cornerselling')
AddEventHandler('qb-police:server:alert:cornerselling', function(Coords, StreetName)
   local AlertData = {title = "Verdachte Situatie", coords = {x = Coords.x, y = Coords.y, z = Coords.z}, description = "Yakınlarda şüpheli bir durum var.: "..StreetName.."."}
   TriggerClientEvent("qb-phone:client:addPoliceAlert", -1, AlertData)
   TriggerClientEvent('qb-police:client:send:cornerselling:alert', -1, Coords, StreetName)
end)

