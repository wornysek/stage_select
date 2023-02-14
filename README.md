## How it works?
If there is no players, notification will be send\
If there is only one player close, callback will be called\
If there is more players close, selection will start and after it is confirmed callback will be called
## Installation
Download stage_select and stage_core from my github profile, then add both into your resources folder. Add these lines into your server.cfg:\
ensure stage_core\
ensure stage_select

## Event args:
    radius, check, cb, notification
	
In most cases, it will be fine to leave check same as radius.

## Examples:

    ```lua
    selectCallback = function(player)
        if player then
            print(string.format("Does entity of selected player %s exist? - ", player.playerId) .. DoesEntityExist(player.pedId))
        end
    end

    TriggerEvent("player_select:StartSelect", 2.0, 2.0, selectCallback, "Nobody is close to you!")
    ```

    ```lua
    local billLabel = "Testing"
    local billAmount = 69

    local playerJob = "police" -- ESX.PlayerData.job.name or whatever you want
    local society = "society_" .. playerJob

    selectCallback = function(player)
        if player then
            TriggerServerEvent('esx_billing:sendBill', player.playerId, society, billLabel, billAmount)
        end
    end

    TriggerEvent("player_select:StartSelect", 2.0, 2.0, selectCallback, "Nobody is close to you!")
    ```