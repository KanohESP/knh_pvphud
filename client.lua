--[WORKING ON ESX]--

print("https://github.com/KanohESP")

--[WORKING ON ESX]--
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")
HUDserver = Tunnel.getInterface("vrp_hud")
vRPhud = {}
Tunnel.bindInterface("vrp_hud",vRPhud)

local vida = false

RegisterNetEvent('Hud:sendStatus')
AddEventHandler('Hud:sendStatus',function(level)
	local ped = PlayerPedId()
	SendNUIMessage({
		show = IsPauseMenuActive(),
		vida = vida
	})
end)


RegisterNUICallback('fechar', function(data)
	local tipo = data.id
	SendNUIMessage({show = tipo})
end)

local entityExist = false
local entityDead = false
local isInAnyVehicle = false
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false
local segundos = 0


Citizen.CreateThread(function()
    while true do
		local player = PlayerPedId()
      	entityExist = DoesEntityExist(player)
		entityDead = IsEntityDead(player)
		isInAnyVehicle = IsPedInAnyVehicle(player, true)
		vida = math.floor((GetEntityHealth(player)-100)/(GetEntityMaxHealth(player)-100)*100)
		TriggerEvent('Hud:sendStatus')
        Citizen.Wait(500)
    end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(500)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if disableShuffle and IsPedInAnyVehicle(GetPlayerPed(-1), false) then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)


Fwv = function (entity)
	local hr = GetEntityHeading(entity) + 90.0
	if hr < 0.0 then
		hr = 360.0 + hr
	end
	hr = hr * 0.0174533
	return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
end

-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local ped = PlayerPedId()
		local vida = GetEntityHealth(ped)
		if vida <= 251 and vida >= 201 and not agachar then
			RequestAnimSet("move_injured_generic")     
      		SetPedMovementClipset(ped,"move_injured_generic",true)			
		elseif vida <= 200 and vida >= 151 and not agachar then
			RequestAnimSet("move_heist_lester")  
      		SetPedMovementClipset(ped,"move_heist_lester",true)			
		elseif vida <= 150 and vida >= 101 and not agachar then
			RequestAnimSet("MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP") 
      		SetPedMovementClipset(ped,"MOVE_M@DRUNK@MODERATEDRUNK_HEAD_UP",true)			
		elseif vida <= 400  and vida >= 251 and not agachar and not movimento then
			ResetPedMovementClipset(ped,0.0)			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-- FUNCIONES NO TOCAR
-----------------------------------------------------------------------------------------------------------------------------------------

function drawTxt(x,y,scale,text,r,g,b,a)
	SetTextFont(Arial)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function drawTxt2(x,y,scale,text,r,g,b,a, font)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end