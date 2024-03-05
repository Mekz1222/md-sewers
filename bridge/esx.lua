if GetResourceState('es_extended') == 'missing' then return end
ESX = exports.es_extended:getSharedObject()

if IsDuplicityVersion() then
    function getPlayerJobName(src)
        local xPlayer = ESX.GetPlayerFromId(src)

        return xPlayer.job.name
    end
else
    if ESX.IsPlayerLoaded() then
        loadClientData()
    end

    RegisterNetEvent('esx:playerLoaded', loadClientData)

    function getPlayerJobName()
        return ESX.GetPlayerData().job.name
    end
end