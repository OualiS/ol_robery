local yrpf = ImportPackage("yrpf")
local npc = {}
npc[4] = "Appu"

npc_hitted_loc = {}

AddEvent("OnPackageStart", function()
    print("# ol_robery charged | made by d3Ex2 #")
end)


-- Fonction qui donne une certaine somme d'argent au joueur
function playerWinMoney(player)
    money = math.random(100, 500)                             
    AddPlayerChat(player,"Le caisse est vide, vous avez récupéré " ..tostring(money).. " €")
    yrpf.AddItem(player,2,money)
end

-- Fonction qui update la valeur de cooldown afin de d'imposer un délai avant de pouvoir braquer à nouveau
function setCooldown(player, time)
    SetPlayerPropertyValue(player, "cooldown", true)   
    Delay(time, function()
        SetPlayerPropertyValue(player, "cooldown", false)   
    end)	
end

-- Event ou l'on initialise des nouvelles property pour l'objet joueurs
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
            -- Timer qui encapsule les mécaniques d'annulation et de success du braquage
            currentRobery = CreateTimer(function()
                time = time + 1
                -- si la durée du braquage est atteinte
                if (time == 10) then
                    playerWinMoney(player)
                    DestroyTimer(currentRobery)
                    SetPlayerPropertyValue(player, "isRobering", false, true)
                    setCooldown(player, 5000)
                end
                x, y, z = GetPlayerLocation(player)
                nx, ny, nz = GetNPCLocation(hitid)
                local distance = GetDistance3D(x, y, z, nx, ny, nz)
                -- check si le joueurs ne s'éloigne pas trop
                if distance > 600 then
                    AddPlayerChat(player, "Tu t'es trop éloigné de " ..npc[hitid] .. " ! La police est alerté !")
                    SetPlayerPropertyValue(player, "isRobering", false, true)
                    DestroyTimer(currentRobery)
                end
            end, 1000)   
            SetPlayerPropertyValue(player, "isRobering", true, true)   
            AddPlayerChat(player, "Tu viens de tirer sur " .. npc[hitid] .." ! Le braquage commence...")
            setCooldown(player, 5000)
        elseif(GetPlayerPropertyValue(player, "isRobering") == true) then
            AddPlayerChat(player, npc[hitid] .. " est déjà assez effrayé comme ça !")			
        elseif(GetPlayerPropertyValue(player, "isRobering") == false and GetPlayerPropertyValue(player, "cooldown") == true) then
            AddPlayerChat( player, "Vous ne pouvez braquer tout de suite !")		
        end
    end    
end
AddEvent("OnPlayerWeaponShot", OnPlayerWeaponShot)

-- Commande register --

function cmd_w(player, weapon, slot, ammo)
	if (weapon == nil or slot == nil or ammo == nil) then
		return AddPlayerChat(player, "Usage: /w <weapon> <slot> <ammo>")
	end
	SetPlayerWeapon(player, weapon, ammo, true, slot, true)
end
AddCommand("w", cmd_w)
AddCommand("weapon", cmd_w)
