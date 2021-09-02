RegisterNetEvent('qb-police:client:send:officer:down')
AddEventHandler('qb-police:client:send:officer:down', function(Coords, StreetName, Info, Priority)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        local Title, Callsign = 'Memur Vuruldu', '10-13B'
        if Priority == 3 then
            Title, Callsign = 'Memur Vuruldu (Acil)', '10-13A'
        end
        TriggerEvent('qb-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = Title,
            priority = Priority,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = Callsign,
        }, false)
        AddAlert(Title, 306, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:panic:button')
AddEventHandler('qb-police:client:send:alert:panic:button', function(Coords, StreetName, Info)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('qb-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Acil Durum!",
            priority = 3,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-id-badge"></i>',
                    detail = Info['Callsign']..' | '..Info['Firstname'].. ' ' ..Info['Lastname'],
                },
                [2] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-13C',
        }, false)
        AddAlert('Acil Durum!', 487, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:gunshots')
AddEventHandler('qb-police:client:send:alert:gunshots', function(Coords, GunType, StreetName, InVeh)
   if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
     local AlertMessage, CallSign = 'Ateş Edildi', '10-47A'
     if InVeh then
         AlertMessage, CallSign = 'Driveby Atış İhbarı', '10-47B'
     end
     TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 7500,
        alertTitle = AlertMessage,
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="far fa-arrow-alt-circle-right"></i>',
                detail = GunType,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = CallSign,
    }, false)
    AddAlert(AlertMessage, 313, 250, Coords, false, true)
  end
end)

RegisterNetEvent('qb-police:client:send:alert:dead')
AddEventHandler('qb-police:client:send:alert:dead', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police" or QBCore.Functions.GetPlayerData().job.name == "ambulance") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('qb-alerts:client:send:alert', {
            timeOut = 7500,
            alertTitle = "Birilerinin Yardıma İhtiyacı Var",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-30B',
        }, true)
        AddAlert('Birilerinin Yardıma İhtiyacı Var', 480, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:bank:alert')
AddEventHandler('qb-police:client:send:bank:alert', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('qb-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Fleeca Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-42A',
        }, false)
        AddAlert('Fleeca Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:big:bank:alert')
AddEventHandler('qb-police:client:send:big:bank:alert', function(Coords, StreetName)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
        TriggerEvent('qb-alerts:client:send:alert', {
            timeOut = 15000,
            alertTitle = "Pacific Bank",
            priority = 1,
            coords = {
                x = Coords.x,
                y = Coords.y,
                z = Coords.z,
            },
            details = {
                [1] = {
                    icon = '<i class="fas fa-globe-europe"></i>',
                    detail = StreetName,
                },
            },
            callSign = '10-35A',
        }, false)
        AddAlert('Pacific Bank', 108, 250, Coords, false, true)
    end
end)

RegisterNetEvent('qb-police:client:send:alert:jewellery')
AddEventHandler('qb-police:client:send:alert:jewellery', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Vangelico Mücevher Soygunu",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, false)
    AddAlert('Vangelico Mücevher Soygunu', 617, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:alert:ammunation')
AddEventHandler('qb-police:client:send:alert:ammunation', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Ammu Nation",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-42A',
    }, false)
    AddAlert('Ammu Nation', 617, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:alert:store')
AddEventHandler('qb-police:client:send:alert:store', function(Coords, StreetName, StoreNumber)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Mağaza Alarımı",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-shopping-basket"></i>',
                detail = 'Store: '..StoreNumber,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-98A',
    }, false)
    AddAlert('Mağaza Alarımı', 59, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:house:alert')
AddEventHandler('qb-police:client:send:house:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Ev Soygunu İhbarı",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-63B',
    }, false)
    AddAlert('Ev Soygunu İhbarı', 40, 250, Coords, false, false)
 end
end)

RegisterNetEvent('qb-police:client:send:banktruck:alert')
AddEventHandler('qb-police:client:send:banktruck:alert', function(Coords, Plate, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Banka Aracı Soygunu (Acil)",
        priority = 0,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-closed-captioning"></i>',
                detail = 'License Plate: '..Plate,
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-03A',
    }, false)
    AddAlert('Banka Aracı Soygunu (Acil)', 67, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:explosion:alert')
AddEventHandler('qb-police:client:send:explosion:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Patlama Sesi Duyuldu",
        priority = 2,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-02C',
    }, false)
    AddAlert('Patlama Sesi Duyuldu', 630, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:cornerselling:alert')
AddEventHandler('qb-police:client:send:cornerselling:alert', function(Coords, StreetName)
 if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then 
    TriggerEvent('qb-alerts:client:send:alert', {
        timeOut = 15000,
        alertTitle = "Uyuşturucu Ticareti (Teyit Edildi)",
        priority = 1,
        coords = {
            x = Coords.x,
            y = Coords.y,
            z = Coords.z,
        },
        details = {
            [1] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = StreetName,
            },
        },
        callSign = '10-16A',
    }, false)
    AddAlert('Uyuşturucu Ticareti (Teyit Edildi)', 465, 250, Coords, false, true)
 end
end)

RegisterNetEvent('qb-police:client:send:tracker:alert')
AddEventHandler('qb-police:client:send:tracker:alert', function(Coords, Name)
    if (QBCore.Functions.GetPlayerData().job.name == "police") and QBCore.Functions.GetPlayerData().job.onduty then
      AddAlert('Anklenecklace Yeri: '..Name, 480, 250, Coords, true, true)
    end
end)

-- // Funtions \\ --

function AddAlert(Text, Sprite, Transition, Coords, Tracker, Flashing)
 local Transition = Transition
 local Blips = AddBlipForCoord(Coords.x, Coords.y, Coords.z)
 SetBlipSprite(Blips, Sprite)
 SetBlipColour(Blips, 6)
 SetBlipDisplay(Blips, 4)
 SetBlipAlpha(Blips, transG)
 SetBlipScale(Blips, 1.0)
 SetBlipAsShortRange(Blips, false)
 if Flashing then
    SetBlipFlashes(Blips, true)
 end
 BeginTextCommandSetBlipName('STRING')
 if not Tracker then
    AddTextComponentString('Melding: '..Text)
 else
    AddTextComponentString(Text)
 end
 EndTextCommandSetBlipName(Blips)
 while Transition ~= 0 do
     Wait(180 * 4)
     Transition = Transition - 1
     SetBlipAlpha(Blips, Transition)
     if Transition == 0 then
         SetBlipSprite(Blips, 2)
         RemoveBlip(Blips)
         return
     end
 end
end