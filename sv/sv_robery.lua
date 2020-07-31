local yrpf = ImportPackage("yrpf")
local npc = {}
npc[4] = "Appu"

npc_hitted_loc = {}

AddEvent("OnPackageStart", function()
    -- Add translations
    yrpf.AddI18nKey("fr", "plugin.test.violent_robery", "Violent")
    yrpf.AddI18nKey("fr", "plugin.police.calm_robery", "Calme")

end)



function playerWinMoney(player)
    money = math.random(100, 500)                             
    AddPlayerChat(player,"Le caisse est vide, vous avez récupéré " ..tostring(money).. " €")
    yrpf.AddItem(player,2,money)
end

function setCooldown(player, time)
    SetPlayerPropertyValue(player, "cooldown", true)   
    Delay(time, function()
        SetPlayerPropertyValue(player, "cooldown", false)   
    end)	
end


AddEvent("OnPlayerJoin", function(player)
    SetPlayerPropertyValue(player, "isRobering", false, true)
    SetPlayerPropertyValue(player, "cooldown", false, true)
end)



function OnPlayerWeaponShot(player, weapon, hittype, hitid, hitx, hity, hitz, startx, starty, startz, normalx, normaly, normalz, BoneName)
    local action = {
        "in the air",
        "at player",
        "at vehicle",
        "an NPC",
        "at object",
        "on ground",
        "in water"
    }

    print(GetPlayerName(player).."("..player..") shot "..action[hittype].." (ID "..hitid..") using weapon ("..weapon..")") 
    if(hittype == HIT_NPC) then        
        npc_hitted_loc['x'] = hitx
        npc_hitted_loc['y'] = hity 
        npc_hitted_loc['z'] = hitz
        -- CallRemoteEvent(player, "checkDistance")
        
        if (GetPlayerPropertyValue(player, "isRobering") == false and GetPlayerPropertyValue(player, "cooldown") == false) then
            local time = 0
            currentRobery = CreateTimer(function()
                time = time + 1
                if (time == 10) then
                    playerWinMoney(player)
                    DestroyTimer(currentRobery)
                    SetPlayerPropertyValue(player, "isRobering", false, true)
                    setCooldown(player, 5000)
                end
                x, y, z = GetPlayerLocation(player)
                nx, ny, nz = GetNPCLocation(hitid)
                local distance = GetDistance3D(x, y, z, nx, ny, nz)
                print(distance)
                if distance > 600 then
                    AddPlayerChat(player, "Tu t'es trop éloigné de " ..npc[hitid] .. " ! La police est alerté !")
                    SetPlayerPropertyValue(player, "isRobering", false, true)
                    DestroyTimer(currentRobery)
                end
            end, 1000)   
            SetPlayerPropertyValue(player, "isRobering", true, true)   
            AddPlayerChat(player, "Tu viens de tirer sur " .. npc[hitid] .." ! Le braquage commence...")
            -- Delay(10000, function()
            --     playerWinMoney(player)
            --     DestroyTimer(timer)
            --     SetPlayerPropertyValue(player, "isRobering", false, true)
            -- end)
            setCooldown(player, 5000)
        elseif(GetPlayerPropertyValue(player, "isRobering") == true) then
            AddPlayerChat(player, npc[hitid] .. " est déjà assez effrayé comme ça !")			
        elseif(GetPlayerPropertyValue(player, "isRobering") == false and GetPlayerPropertyValue(player, "cooldown") == true) then
            AddPlayerChat( player, "Vous ne pouvez braquer tout de suite !")		
        end
    end    
end
AddEvent("OnPlayerWeaponShot", OnPlayerWeaponShot)


-- AddEvent("OnGameTick", function(player)
--     print(GetPlayerPropertyValue(player, "isRobering"))
--     if(GetPlayerPropertyValue(player, "isRobering") == true) then
--         local x, y, z = GetPlayerLocation(player)            
--         print(GetDistance2D(x, y, npc_hitted_loc['x'], npc_hitted_loc['y']))
--         -- if (distX < 10 and distY < 10) then
--         --     SetPlayerPropertyValue(player, "isRobering", false, true)
--         --     AddPlayerChat(player,"Tu t'es trop éloigné ! La police est alerté !")
--         --     setCooldown(player, 5000)
--         -- end 
--     end
-- end)

-- Commande register --

function cmd_w(player, weapon, slot, ammo)
	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "Usage: /w <weapon> <slot> <ammo>")
	end

	SetPlayerWeapon(player, weapon, ammo, true, slot, true)
end
AddCommand("w", cmd_w)
AddCommand("weapon", cmd_w)



AddCommand("test", function(player)

    yrpf.ShowMenu(menuId)
end)