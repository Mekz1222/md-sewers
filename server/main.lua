AddEventHandler('ox_doorlock:stateChanged', function(source, doorId, state, usedItem)
    local sewerId
    local sewerState
    
    for k, v in pairs(Config.Locations) do
        if doorId == v.door.id then
            sewerId = doorId
            sewerState = state
        
            TriggerClientEvent('md-sewers:sewerState', -1, sewerId, sewerState)
        end
    end
end)

RegisterNetEvent('md-sewers:setDoorState', function(doorId, state)
    local src = source
    local count = exports.ox_inventory:Search(src, 'count', Config.KeyItem)
    if not (count >= 1 or getPlayerJobName(src) == 'police') then return end
    TriggerEvent('ox_doorlock:setState', doorId, state)
end)

lib.callback.register('md-sewers:getDoorStates', function()
    local sewerlocks = {}

    for k, v in pairs(Config.Locations) do
        sewerlocks[v.door.id] = exports.ox_doorlock:getDoor(v.door.id).state == 1 and true or false
    end

    return sewerlocks
end)