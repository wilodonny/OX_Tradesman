local OxInventory = exports.ox_inventory
local QBCore = exports['qb-core']:GetCoreObject()
CreateThread(function()
    local hash = Config.PedProps['hash']
    local coords = Config.PedProps['location']
    QBCore.Functions.LoadModel(hash)
    local buyerPed = CreatePed(0, hash, coords.x, coords.y, coords.z-1.0, coords.w, false, false)
    TaskStartScenarioInPlace(buyerPed, 'WORLD_HUMAN_CLIPBOARD', true)
    FreezeEntityPosition(buyerPed, true)
    SetEntityInvincible(buyerPed, true)
    SetBlockingOfNonTemporaryEvents(buyerPed, true)

    exports['qb-target']:AddTargetEntity(buyerPed, {
        options = {
            {
                icon = 'fas fa-circle',
                label = 'Offer Goods',  -- CHANGE WHAT 3RD EYE TEXT SAYS HERE
                action = function()
                    local pedPos = GetEntityCoords(PlayerPedId())
                    local dist = #(pedPos - vector3(coords))
                    if dist <= 5.0 then
                        ShowMenu()
                    end
                end,
            },
        },
        distance = 2.0
    })
end)

local function getItemLabel(itemName)
    local itemData = exports['ox_inventory']:GetItemData(itemName)
    return itemData and itemData.label or nil
end

function ShowMenu()
    local registeredMenu = {
        id = 'item-menu',
        title = 'This is what i buy',  -- CHANGE SHOP HEADER HERE 
        options = {}
    }
    local itemNames = {}
    local inventoryItems = exports.ox_inventory:Items()

    if type(inventoryItems) == "table" then
        for item, data in pairs(inventoryItems) do
            itemNames[item] = data.label
        end
    end

    local options = {}
    for itemName, v in pairs(Config.Items) do
        local hasItem = exports['ox_inventory']:Search('count', itemName)

        if hasItem and type(hasItem) == "number" and hasItem > 0 then
            local itemLabel = itemNames[itemName] or itemName
            options[#options + 1] = {
                title = itemLabel,
                description = 'Cost: $'..v.price..' per',
                event = 'ox_trademan:giveinput',
                args = { item = itemName, price = v.price }
            }
        end
    end

    if #options > 0 then
        registeredMenu["options"] = options
        lib.registerContext(registeredMenu)
        lib.showContext('item-menu')
    else
        QBCore.Functions.Notify('You have nothing i want.', 'error', 4500)  -- CHANGE MESSAGE IF NO PRODUCTS IN INVENTORY THAT MATCH FOR SALE ITEMS
    end
    
end

        RegisterNetEvent('ox_trademan:giveinput', function(data)
            local itemLabel = Config.Items[data.item] and Config.Items[data.item].label or "Unknown Item"
            local header = 'Item: ' .. itemLabel 
            local input = lib.inputDialog(header, {
        { type = 'input', label = 'Sell Amount', placeholder = '10' },
        { type = 'select', label = 'Payment Method', options = {
            { value = 'cash', label = 'Cash', icon = 'fas fa-wallet' },
            { value = 'bank', label = 'Bank', icon = 'fas fa-landmark' }
        }}
    })

    if input then
        local amount = tonumber(input[1])
        local paymentMethod = input[2]
        
        if amount and paymentMethod then
            TriggerServerEvent('ox_trademan:sellitem', data.item, data.price, amount, paymentMethod)
        else
            QBCore.Functions.Notify('Invalid input.', 'error', 4500)
        end
    else
        QBCore.Functions.Notify('No amount was given.', 'error', 4500)
    end
end)


local isBlipVisible = false
local blip = nil

RegisterNetEvent('setBlip')
AddEventHandler('setBlip', function(coords, name, icon, color, size, shouldShow)
    if shouldShow then
        if not isBlipVisible then

            blip = AddBlipForCoord(coords)
            SetBlipSprite(blip, icon)
            SetBlipColour(blip, color)
            SetBlipScale(blip, size)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(name)
            EndTextCommandSetBlipName(blip)


            isBlipVisible = true
        end
    else
        if isBlipVisible then

            RemoveBlip(blip)
            isBlipVisible = false
        end
    end
end)


AddEventHandler('onResourceStart', function(resourceName)
    if resourceName == GetCurrentResourceName() then

        if Config.Blip.blipVisible then
            TriggerEvent('setBlip', Config.Blip.coords, Config.Blip.name, Config.Blip.icon, Config.Blip.color, Config.Blip.size, true)
        else
            TriggerEvent('setBlip', Config.Blip.coords, Config.Blip.name, Config.Blip.icon, Config.Blip.color, Config.Blip.size, false)
        end
    end
end)

