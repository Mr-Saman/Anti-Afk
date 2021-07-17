-- CONFIG --


-- Create And Develop By Mr.Saman#0010


ESX = nil

Citizen.CreateThread(function()

	
	while ESX == nil do
	
	  TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	
	  Citizen.Wait(0)
	
	end
	
	end)
-- AFK Kick Time Limit (in seconds)
secondsUntilKick = 300 
kickWarning = true
timelogmain = 40
-- CODE --
local afkmode = false

Citizen.CreateThread(function()
	while afkmode == false do
		Wait(1000)

		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed, true)
			if currentPos == prevPos then
				if time > 0 then
					time = time - 1
					print(time)
					if time < 10 then
						TriggerEvent("afkscript:warning" , time)
					end
				else
					TriggerEvent("afkscript:time")
					TriggerEvent("afkscript:log")
					TriggerEvent("afkscript:tpww")
				end
			else
				time = secondsUntilKick
			end

			prevPos = currentPos
		end
	end
end)

RegisterNetEvent('afkscript:warning')
AddEventHandler('afkscript:warning', function(time)

	TriggerEvent("pNotify:SendNotification",{
		text = "⚠️ Shoma Ta "..time.."s Digar [AFK] Mishavid ⚠️",
		type = "error",
		queue = "left",
		timeout = 900,
		layout = "centerRight",
		theme = "gta"
		})
end)

RegisterNetEvent('afkscript:time')
AddEventHandler('afkscript:time', function(ped)

	Citizen.CreateThread(function()
		while timelogmain ~= 0 do
			Wait(1000)
			timelogmain = timelogmain -1
		end
	end)
end)
local currentTags = {}

RegisterNetEvent('afkscript:log')
AddEventHandler('afkscript:log', function(ped)
	Citizen.CreateThread(function()
		while afkmode and timelogmain ~= 0 do
			Wait(0)
			local cx,cy,cz = table.unpack(currentPos)
			ESX.Game.Utils.DrawText3D(vector3(cx,cy,cz), "🛑 ~r~ Player Ba Esm : ~y~"..GetPlayerName(PlayerId()).." ~r~ Inja ~b~[AFK]~r~ Shod 🛑", 0.5)
		end
	end)
end)


local lastpos
local PlayerAfkTag = false
RegisterNetEvent('afkscript:tpww')
AddEventHandler('afkscript:tpww', function(ped)
	lastpos = GetEntityCoords(PlayerPedId())
	local formattedCoords = {
		x = ESX.Math.Round(lastpos.x, 1),
		y = ESX.Math.Round(lastpos.y, 1),
		z = ESX.Math.Round(lastpos.z, 1)
	}
	ESX.SetPlayerData('lastPosition', formattedCoords)
	TriggerServerEvent('esx:updateLastPosition', formattedCoords)
	afkmode = true
	SetEntityCoords(PlayerPedId(), 1646.94 , -220.03 , 544.12)
	TriggerEvent('es_admin:freezePlayer', true)
	PlayerAfkTag = true
		Citizen.CreateThread( function()
			while PlayerAfkTag do
				Citizen.Wait(2000)
				TriggerEvent("pNotify:SendNotification",{
					text = "<b style='color:Black'><center>[هستید AFK شما]</center></b><center><br /><br><b style='color:red'>به دلیل عدم اختلال در ارپی دیگران شما اینجا تلپورت و فریز شده اید</b> <br/><b style ='color : black , font-size : 12px'>[/endafk]<br/></b><b style='color:green'>جهت بازگشت به جای قبلیتان</b></center>",
					type = "alert",
					queue = "left",
					timeout = 2000,
					layout = "centerRight",
					theme = "metroui"
					})
			end
		end)
	ShowPlayerAfkTag()
end)

function DrawText3D(x,y,z, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    if onScreen then
        SetTextScale(0.0*scale, 0.80*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
function ShowPlayerAfkTag()
    Citizen.CreateThread( function()
        while PlayerAfkTag do
            Citizen.Wait(2000)
			ResetPlayerStamina(PlayerId())
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
        end
		SetEntityInvincible(GetPlayerPed(-1), false)
		SetPlayerInvincible(PlayerId(), false)
		SetPedCanRagdoll(GetPlayerPed(-1), true)
		ClearPedLastWeaponDamage(GetPlayerPed(-1))
		SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
		SetEntityCanBeDamaged(GetPlayerPed(-1), true)
    end)
	Citizen.CreateThread(function ()
        while PlayerAfkTag do
            Citizen.Wait(0)
            local currentPed = PlayerPedId()
            local currentPos = GetEntityCoords(currentPed)
            local cx,cy,cz = table.unpack(currentPos)
            cz = cz + 1.2
            ESX.Game.Utils.DrawText3D(vector3(cx,cy,cz), "~r~[AFK] | ~y~" .. "Player AFK", 1.5)
        end
    end)
end

RegisterCommand('endafk',function()
	if afkmode then
		TriggerEvent('es_admin:freezePlayer', false)
		SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z + 1)
		PlayerAfkTag = false
		afkmode = false
		lastpos = nil
		TriggerEvent("pNotify:SendNotification",{
			text = "<b style='color:Black'><center>[خارج شدید AFK شما از حالت]</center></b><center><br /><br><b style='color:red'>با آرزوی بهترین ها برای شما</b></center>",
			type = "success",
			queue = "centerRight",
			timeout = 10000,
			layout = "center",
			theme = "metroui"
			})
	else
		TriggerEvent('ShowNotification' , "Shoma Dar Halat [AFK] Nistid")
	end
end)

-- Create And Develop By Mr.Saman#0010