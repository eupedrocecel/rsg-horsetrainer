local RSGCore = exports['rsg-core']:GetCoreObject()
local horsexp = nil
local newxp = nil
local horseid = nil

-----------------------------------------------------------------------------------

-- use horse trainer brush
RSGCore.Functions.CreateUseableItem("horsetrainingbrush", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:brushHorse', src, item.name)
end)

-- use horse trainer carrot
RSGCore.Functions.CreateUseableItem("horsetrainingcarrot", function(source, item)
    local src = source
    TriggerClientEvent('rsg-horsetrainer:client:feedHorse', src, item.name)
end)

-----------------------------------------------------------------------------------

RegisterNetEvent('rsg-horsetrainer:server:updatexp',function(action)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid
    local result = MySQL.query.await('SELECT * FROM player_horses WHERE citizenid=@citizenid AND active=@active', { ['@citizenid'] = cid, ['@active'] = 1 })
    if (result[1] ~= nil) then
        horseid = (result[1].horseid)
        horsexp = (result[1].horsexp)
    end
    if action == 'leading' then
        if horsexp <= Config.FullyTrained then
            local newxp = horsexp + Config.LeadingXpIncrease
            MySQL.update('UPDATE player_horses SET horsexp = ?  WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
            TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.xp_now')..newxp, 'success')
        end
    elseif action == 'cleaning' then
        if horsexp <= Config.FullyTrained then
            local newxp = horsexp + Config.CleaningXpIncrease
            MySQL.update('UPDATE player_horses SET horsexp = ?  WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
            TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.xp_now')..newxp, 'success')
        end
    elseif action == 'feeding' then
        if horsexp <= Config.FullyTrained then
            local newxp = horsexp + Config.FeedingXpIncrease
            MySQL.update('UPDATE player_horses SET horsexp = ?  WHERE horseid = ? AND active = ?', {newxp, horseid, 1})
            TriggerClientEvent('RSGCore:Notify', src, Lang:t('success.xp_now')..newxp, 'success')
        end
    end
end)

-----------------------------------------------------------------------------------

-- remove item
RegisterNetEvent('rsg-horsetrainer:server:deleteItem', function(item, amount)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem(item, amount)
    TriggerClientEvent("inventory:client:ItemBox", src, RSGCore.Shared.Items[item], "remove")
end)

-----------------------------------------------------------------------------------
