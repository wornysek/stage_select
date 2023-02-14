RegisterCommand("player_menu_up", function()
    if CurrentSelect then
        MoveSelectionUp()
    end
end)

RegisterCommand("player_menu_down", function()
    if CurrentSelect then
        MoveSelectionDown()
    end
end)

RegisterCommand("player_menu_end", function()
    if CurrentSelect then
        ResetPlayerMenu()
    end
end)

RegisterCommand("player_menu_enter", function()
    if CurrentSelect then
        SubmitPlayerMenu()
    end
end)

RegisterKeyMapping("player_menu_up", "Selection up", "keyboard", "UP")
RegisterKeyMapping("player_menu_down", "Selection down", "keyboard", "DOWN")
RegisterKeyMapping("player_menu_end", "End selection", "keyboard", "BACK")
RegisterKeyMapping("player_menu_enter", "Confirm selection", "keyboard", "RETURN")