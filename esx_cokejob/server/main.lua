--<-.(`-')               _                         <-. (`-')_  (`-')  _                          (`-')              _           (`-') (`-')  _ _(`-')    (`-')  _      (`-')
-- __( OO)      .->     (_)        .->                \( OO) ) ( OO).-/    <-.          .->   <-.(OO )     <-.     (_)         _(OO ) ( OO).-/( (OO ).-> ( OO).-/     _(OO )
--'-'---.\  ,--.'  ,-.  ,-(`-') ,---(`-')  .----.  ,--./ ,--/ (,------. (`-')-----.(`-')----. ,------,) (`-')-----.,-(`-'),--.(_/,-.\(,------. \    .'_ (,------.,--.(_/,-.\
--| .-. (/ (`-')'.'  /  | ( OO)'  .-(OO ) /  ..  \ |   \ |  |  |  .---' (OO|(_\---'( OO).-.  '|   /`. ' (OO|(_\---'| ( OO)\   \ / (_/ |  .---' '`'-..__) |  .---'\   \ / (_/
--| '-' `.)(OO \    /   |  |  )|  | .-, \|  /  \  .|  . '|  |)(|  '--.   / |  '--. ( _) | |  ||  |_.' |  / |  '--. |  |  ) \   /   / (|  '--.  |  |  ' |(|  '--.  \   /   / 
--| /`'.  | |  /   /)  (|  |_/ |  | '.(_/'  \  /  '|  |\    |  |  .--'   \_)  .--'  \|  |)|  ||  .   .'  \_)  .--'(|  |_/ _ \     /_) |  .--'  |  |  / : |  .--' _ \     /_)
--| '--'  / `-/   /`    |  |'->|  '-'  |  \  `'  / |  | \   |  |  `---.   `|  |_)    '  '-'  '|  |\  \    `|  |_)  |  |'->\-'\   /    |  `---. |  '-'  / |  `---.\-'\   /   
--`------'    `--'      `--'    `-----'    `---''  `--'  `--'  `------'    `--'       `-----' `--' '--'    `--'    `--'       `-'     `------' `------'  `------'    `-'    
local PlayersHarvesting    = {}
local PlayersTransforming  = {}
local PlayersTransforming2 = {}
local PlayersTransforming3 = {}
local PlayersSelling       = {}

---------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Feuilles de coca----------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------
-----------Quantités/ajouts inventaire-------------
local function HarvestFcoke(source)

	SetTimeout(5000, function()

		if PlayersHarvesting[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local fcokeQuantity = xPlayer:getInventoryItem('feuille_coca').count

				if fcokeQuantity == 120 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous ne pouvez plus ramasser de feuilles de coca, votre inventaire est plein')
				else
					xPlayer:addInventoryItem('feuille_coca', 2)
					HarvestFcoke(source)
				end

			end)

		end
	end)
end
-----------Commencer à récolter-------------
RegisterServerEvent('esx_cokejob:startHarvestFcoke')
AddEventHandler('esx_cokejob:startHarvestFcoke', function()

	PlayersHarvesting[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'Ramassage en cours...')

	HarvestFcoke(source)

end)
-----------Arreter de récolter-------------
RegisterServerEvent('esx_cokejob:stopHarvestFcoke')
AddEventHandler('esx_cokejob:stopHarvestFcoke', function()

	PlayersHarvesting[source] = false

end)
----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Jus de coca----------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
-----------Transformation de feuilles en jus-------------
local function TransformFcoke(source)

	SetTimeout(5000, function()

		if PlayersTransforming[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local feuille_cocaQuantity = xPlayer:getInventoryItem('feuille_coca').count

				if feuille_cocaQuantity < 5 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez pas assez de feuilles de coca à transformer')
				else
					xPlayer:removeInventoryItem('feuille_coca', 5)
					xPlayer:addInventoryItem('jus_coca', 1)
				
					TransformFcoke(source)
				end

			end)

		end
	end)
end
-----------Commencer de transformer-------------
RegisterServerEvent('esx_cokejob:startTransformFcoke')
AddEventHandler('esx_cokejob:startTransformFcoke', function()

	PlayersTransforming[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'transformation en cours...')

	TransformFcoke(source)

end)
-----------Arreter de transformer-------------
RegisterServerEvent('esx_cokejob:stopTransformFcoke')
AddEventHandler('esx_cokejob:stopTransformFcoke', function()

	PlayersTransforming[source] = false

end)
-----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Pâte de coca----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
-----------Transformation de jus en pate-------------
local function TransformJcoke(source)

	SetTimeout(5000, function()

		if PlayersTransforming2[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local jus_cocaQuantity = xPlayer:getInventoryItem('jus_coca').count

				if jus_cocaQuantity < 1 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez pas assez de Jus de coca à transformer')
				else
					xPlayer:removeInventoryItem('jus_coca', 1)
					xPlayer:addInventoryItem('pate_coca', 1)
				
					TransformJcoke(source)
				end

			end)

		end
	end)
end
-----------Commencer de transformer-------------
RegisterServerEvent('esx_cokejob:startTransformJcoke')
AddEventHandler('esx_cokejob:startTransformJcoke', function()

	PlayersTransforming2[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'transformation en cours...')

	TransformJcoke(source)

end)
-----------Arreter de transformer-------------
RegisterServerEvent('esx_cokejob:stopTransformJcoke')
AddEventHandler('esx_cokejob:stopTransformJcoke', function()

	PlayersTransforming2[source] = false

end)
------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Cocaïne----------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
-----------Transformation de pate en poudre------------
local function TransformPcoke(source)

	SetTimeout(5000, function()

		if PlayersTransforming3[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local pate_cocaQuantity = xPlayer:getInventoryItem('pate_coca').count

				if pate_cocaQuantity < 1 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez pas assez de pâte de coca à transformer')
				else
					xPlayer:removeInventoryItem('pate_coca', 1)
					xPlayer:addInventoryItem('coca', 1)
				
					TransformPcoke(source)
				end

			end)

		end
	end)
end
-----------Commencer de transformer-------------
RegisterServerEvent('esx_cokejob:startTransformPcoke')
AddEventHandler('esx_cokejob:startTransformPcoke', function()

	PlayersTransforming3[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'transformation en cours...')

	TransformPcoke(source)

end)
-----------Arreter de transformer-------------
RegisterServerEvent('esx_cokejob:stopTransformPcoke')
AddEventHandler('esx_cokejob:stopTransformPcoke', function()

	PlayersTransforming3[source] = false

end)
----------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------Vente----------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------
local function SellCoke(source)

	SetTimeout(10000, function()

		if PlayersSelling[source] == true then

			TriggerEvent('esx:getPlayerFromId', source, function(xPlayer)

				local cocaQuantity = xPlayer:getInventoryItem('coca').count

				if cocaQuantity == 0 then
					TriggerClientEvent('esx_cokejob:showNotification', source, 'Vous n\'avez plus de cocaïne à vendre')
				else
					xPlayer:removeInventoryItem('coca', 1)
					xPlayer:addMoney(1500)
				
					SellCoke(source)
				end

			end)

		end
	end)
end

RegisterServerEvent('esx_cokejob:startSellCoke')
AddEventHandler('esx_cokejob:startSellCoke', function()

	PlayersSelling[source] = true

	TriggerClientEvent('esx_cokejob:showNotification', source, 'Vente en cours...')

	SellCoke(source)

end)

RegisterServerEvent('esx_cokejob:stopSellCoke')
AddEventHandler('esx_cokejob:stopSellCoke', function()

	PlayersSelling[source] = false

end)
