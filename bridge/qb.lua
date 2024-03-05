if GetResourceState('qb-core') == 'missing' then return end
QBCore = exports['qb-core']:GetCoreObject()

if IsDuplicityVersion() then
    function getPlayerJobName(src)
        local Player = QBCore.Functions.GetPlayer(src)

        return Player.PlayerData.job.name
    end
else
    if LocalPlayer.state.isLoggedIn then
        loadClientData()
    end
    
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', loadClientData)

    function getPlayerJobName()
        return QBCore.Functions.GetPlayerData().job.name
    end
end