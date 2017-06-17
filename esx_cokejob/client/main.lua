--<-.(`-')               _                         <-. (`-')_  (`-')  _                          (`-')              _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
-- __( OO)      .->     (_)        .->                \( OO) ) ( OO).-/    <-.          .->   <-.(OO )     <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--'-'---.\  ,--.'  ,-.  ,-(`-') ,---(`-')  .----.  ,--./ ,--/ (,------. (`-')-----.(`-')----. ,------,) (`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--| .-. (/ (`-')'.'  /  | ( OO)'  .-(OO ) /  ..  \ |   \ |  |  |  .---' (OO|(_\---'( OO).-.  '|   /`. ' (OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
--| '-' `.)(OO \    /   |  |  )|  | .-, \|  /  \  .|  . '|  |)(|  '--.   / |  '--. ( _) | |  ||  |_.' |  / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
--| /`'.  | |  /   /)  (|  |_/ |  | '.(_/'  \  /  '|  |\    |  |  .--'   \_)  .--'  \|  |)|  ||  .   .'  \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--| '--'  / `-/   /`    |  |'->|  '-'  |  \  `'  / |  | \   |  |  `---.   `|  |_)    '  '-'  '|  |\  \    `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--`------'    `--'      `--'    `-----'    `---''  `--'  `--'  `------'    `--'       `-----' `--' '--'    `--'    `--'       `-'     `------' `------'  `------'    `-'    
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local PID          = 0
local GUI          = {}
GUI.ControlsShowed = false
GUI.Time           = 0

local hasAlreadyEnteredMarker = false;
local lastZone                = nil;

function Notification(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end

RegisterNetEvent('esx_cokejob:showNotification')
AddEventHandler('esx_cokejob:showNotification', function(notify)
	Notification(notify)
end)

AddEventHandler('playerSpawned', function(spawn)
	PID = GetPlayerServerId(PlayerId())
end)

AddEventHandler('esx_cokejob:hasEnteredMarker', function(zone)

	GUI.ControlsShowed = true
	
	local message

	if zone == 'PlantationCock' then
		message = 'Ramasser Feuilles de coca'
	elseif zone == 'GarageCoke' then
		message = 'Tranformer Feuilles de coca en jus'
	elseif zone == 'EntrepotCoke' then
		message = 'Tranformer Jus de coca en pâte'
	elseif zone == 'AppartementCoke' then
		message = 'Tranformer Pâte de coca en cocaïne'
	elseif zone == 'StripclubCoke' then
		message = 'Vendre Cocaïne'
	end

	SendNUIMessage({
		showControls = true,
		message      = message
	})

end)

AddEventHandler('esx_cokejob:hasExitedMarker', function(zone)

	GUI.ControlsShowed = false

	SendNUIMessage({
		showControls = false
	})

	TriggerServerEvent('esx_cokejob:stopHarvestFcoke')
	TriggerServerEvent('esx_cokejob:stopTransformFcoke')
	TriggerServerEvent('esx_cokejob:stopTransformJcoke')
	TriggerServerEvent('esx_cokejob:stopTransformPcoke')
	TriggerServerEvent('esx_cokejob:stopSellCoke')
end)

-- Render markers
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end

	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		
		Wait(0)
		
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < Config.ZoneSize.x / 2) then
				isInMarker  = true
				currentZone = k
			end
		end

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone                = currentZone
			TriggerEvent('esx_cokejob:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_cokejob:hasExitedMarker', lastZone)
		end

	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do

  	Wait(0)

  	if GUI.ControlsShowed and IsControlPressed(0, Keys['ENTER']) and (GetGameTimer() - GUI.Time) > 1000 then

			SendNUIMessage({
				showControls = false
			})

  		GUI.ControlsShowed = false
	  	GUI.Time           = GetGameTimer()

			if lastZone == 'PlantationCock' then
				TriggerServerEvent('esx_cokejob:startHarvestFcoke')
			elseif lastZone == 'GarageCoke' then
				TriggerServerEvent('esx_cokejob:startTransformFcoke')
			elseif lastZone == 'EntrepotCoke' then
				TriggerServerEvent('esx_cokejob:startTransformJcoke')
			elseif lastZone == 'AppartementCoke' then
				TriggerServerEvent('esx_cokejob:startTransformPcoke')
			elseif lastZone == 'StripclubCoke' then
				TriggerServerEvent('esx_cokejob:startSellCoke')
			end

    end

  end
end)
