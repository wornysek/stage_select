local CORE = exports["stage_core"]
local selectDisabled = not CORE:HasLoaded()

CurrentSelect = nil
local ClosePlayers, CurrentCb, CurrentNotification, CurrentCheck

function GetNearbyPlayers(radius)
    local coords = GetEntityCoords(PlayerPedId())
    local currentServerId = GetPlayerServerId(PlayerId())
    local closePlayers = {}
    local CPeds = GetGamePool("CPed")

    for _, cPed in pairs(CPeds) do
        local closePlayerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(cPed))

        if closePlayerId > 0 and closePlayerId ~= currentServerId and #(GetEntityCoords(cPed) - coords) <= radius then
            table.insert(closePlayers, {
                pedId = cPed,
                playerId = closePlayerId
            })
        end
    end

    return closePlayers
end

function CheckDistance(coords, radius)
    local pedCoords = GetEntityCoords(PlayerPedId())

    return #(pedCoords - coords) <= radius
end

function DefaultCheck(check)
    return function(player) 
        local playerCoords = GetEntityCoords(player.pedId)

        return CheckDistance(playerCoords, check)
    end
end

function ResetPlayerMenu()
    CurrentSelect = nil
    ClosePlayers = nil
    CurrentCheck = nil
    CurrentCb = nil
    CurrentNotification = nil
    CoordsToDraw = nil
end

function SubmitPlayerMenu()
    if CurrentCheck(ClosePlayers[CurrentSelect]) then
        CurrentCb(ClosePlayers[CurrentSelect])
        ResetPlayerMenu()
    else
        CORE:SendNotification(CurrentNotification)
    end
end

function MoveSelectionUp()
    CurrentSelect = CurrentSelect + 1

    if CurrentSelect > #ClosePlayers then
        CurrentSelect = 1
    end
end

function MoveSelectionDown()
    CurrentSelect = CurrentSelect - 1

    if CurrentSelect == 0 then
        CurrentSelect = #ClosePlayers
    end
end

function StartPlayerMenu(radius, check, cb, notification)
    CurrentSelect = 1
    ClosePlayers = GetNearbyPlayers(radius)
    CurrentCheck = type(check) == "function" and check or DefaultCheck(check)

    CurrentCb, CurrentNotification = cb, notification

    if #ClosePlayers == 0 then 
        CORE:SendNotification(CurrentNotification, "error")
        ResetPlayerMenu()
        return
    elseif #ClosePlayers == 1 then
        SubmitPlayerMenu()
    end
end

RegisterNetEvent("player_select:StartSelect", function(radius, check, cb, notification)
    if not selectDisabled then
        StartPlayerMenu(radius, check, cb, notification)
    end
end)

CreateThread(function()
    AddTextEntry('helpText', SETTINGS.Texts.SelectionHelpText)
    while true do
        local timeToSleep = 100

        if CurrentSelect then
            timeToSleep = 0

            local coordsToDraw = GetWorldPositionOfEntityBone(ClosePlayers[CurrentSelect].pedId, 0) + vector3(0.0, 0.0, 1.5)
            DrawMarker(
                SETTINGS.Marker.Type, coordsToDraw, 
                0.0, 0.0, 0.0, 
                0.0, 0.0, 0.0, 
                0.5, 0.5, 0.5, 
                SETTINGS.Marker.Color.r, SETTINGS.Marker.Color.g, 
                SETTINGS.Marker.Color.b, SETTINGS.Marker.Color.a, 
                false, true, 2, 
                false, nil, nil, false
            )

            DisplayHelpTextThisFrame('helpText', false)
        end

        Wait(timeToSleep)
    end
end)