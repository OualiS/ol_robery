AddPlayerChat("Robery v1.0 | Client charged")

local yrpf = ImportPackage("yrpf")

AddEvent("OnPackageStart", function()
    -- Add translations
    yrpf.AddI18nKey("fr", "plugin.test.violent_robery", "Violent")
    yrpf.AddI18nKey("fr", "plugin.police.calm_robery", "Calme")

end)

AddCommand("copmenu", function(player)
    local menuId = yrpf.CreateMenu(player)
    yrpf.AddMenuItem(menuId, yrpf.GetI18nForPlayer(player, "plugin.police.check_plate"), "window.CallEvent(\"RemoteCallInterface\", \"PolicePlus:CheckPlate\");")
    yrpf.ShowMenu(menuId)
end)




