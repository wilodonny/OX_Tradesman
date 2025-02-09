local OxInventory = exports.ox_inventory
local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('QBCore:Server:AddMoney', function(source, account, amount)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddMoney(account, amount)
    end
end)

RegisterNetEvent('ox_trademan:sellitem', function(item, price, itemAmount, payMethod)
    local PlayerId = source
    
    local hasItem = OxInventory:GetItemCount(PlayerId, item)

    if hasItem >= itemAmount then
        OxInventory:RemoveItem(PlayerId, item, itemAmount)

        local pay = itemAmount * price
        TriggerClientEvent('ox_inventory:client:ItemBox', PlayerId, item, "remove", itemAmount)

    if payMethod == 'cash' then
        TriggerEvent('QBCore:Server:AddMoney', PlayerId, 'cash', pay)
    elseif payMethod == 'bank' then
        TriggerEvent('QBCore:Server:AddMoney', PlayerId, 'bank', pay)
        QBCore.Functions.Notify(PlayerId, ('You have received $%s in your bank account.'):format(pay), 'success')
    end

    else
        TriggerClientEvent('QBCore:Notify', PlayerId, 'Not enough items!', 'error')
    end
end)

Config = Config or {}

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if Config.Blip.blipVisible then
            TriggerClientEvent('setBlip', -1, Config.Blip.coords, Config.Blip.name, Config.Blip.icon, Config.Blip.color, Config.Blip.size, true)
        else
            TriggerClientEvent('setBlip', -1, Config.Blip.coords, Config.Blip.name, Config.Blip.icon, Config.Blip.color, Config.Blip.size, false)
        end
    end
end)


