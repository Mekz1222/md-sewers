local sewerLocks = {}
local zones = {}

function loadClientData()
    lib.callback('md-sewers:getDoorStates', false, function(doors)
        sewerLocks = doors
    end)

    for k, v in pairs(Config.Locations) do
        local zone = {
            onEnter = function()
                exports.ox_target:addModel(Config.Models, {
                    label = 'Lock/Unlock',
                    icon = 'fas fa-key',
                    canInteract = function()
                        local count = exports.ox_inventory:Search('count', Config.KeyItem)

                        return count >= 1 or getPlayerJobName() == 'police'
                    end,
                    onSelect = function()
                        if lib.progressCircle({
                            label = (sewerLocks[v.door.id] and 'Unlocking' or 'Locking') .. ' sewer hatch',
                            duration = 2000,
                            position = 'bottom',
                            useWhileDead = false,
                            canCancel = true,
                            disable = {
                                car = true,
                                move = true,
                                combat = true
                            },
                            anim = {
                                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                                clip = 'machinic_loop_mechandplayer'
                            },
                        }) then
                            TriggerServerEvent('md-sewers:setDoorState', v.door.id, not sewerLocks[v.door.id])
                        end
                    end
                })
                
                SetPedConfigFlag(PlayerPedId(), 146, true)
            end,

            onExit = function()
                exports.ox_target:removeModel(Config.Models)
                SetPedConfigFlag(PlayerPedId(), 146, false)
            end,

            inside = function()
                SetPedConfigFlag(PlayerPedId(), 146, sewerLocks[v.door.id])
            end
        }

        zone.coords = v.zone.coords
        zone.size = v.zone.size
        zone.rotation = v.zone.rotation

        zones[#zones+1] = lib.zones.box(zone)
    end
end

function unloadClientData()
    sewerLocks = {}
    exports.ox_target:removeModel(Config.Models)
    for k, v in pairs(zones) do
        v:remove()
    end
end

RegisterNetEvent('md-sewers:sewerState', function(sewer, state)
    sewerLocks[sewer] = state
end)