ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('sokin_paste:getItem')
AddEventHandler('sokin_paste:getItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == 'item_standard' then
		TriggerEvent('esx_addoninventory:getInventory', 'sokin_paste', xPlayer.identifier, function(inventory)
			local inventoryItem = inventory.getItem(item)
			if count > 0 and inventoryItem.count >= count then
				if count > 0 and inventoryItem.count >= count then
					inventory.removeItem(item, count)
					xPlayer.addInventoryItem(item, count)
				else
                    TriggerClientEvent("FeedM:showNotification", xPlayer.source, 'Nie możesz posiadać więcej tego przedmiotu!', 5000, 'primary')
				end
			else
                TriggerClientEvent("FeedM:showNotification", xPlayer.source, 'Nie posiadasz tyle!', 5000, 'primary')
			end
		end)
	elseif type == 'item_account' then
		TriggerEvent('esx_addonaccount:getAccount', 'sokin_paste_' .. item, xPlayer.identifier, function(account)
			if account.money >= count then
				account.removeMoney(count)
				xPlayer.addAccountMoney(item, count)
			else
                TriggerClientEvent("FeedM:showNotification", xPlayer.source, 'Nieprawidłowa ilość', 5000, 'primary')
			end
		end)
	end
end)

RegisterNetEvent('sokin_paste:putItem')
AddEventHandler('sokin_paste:putItem', function(type, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == 'item_standard' then
		local playerItemCount = xPlayer.getInventoryItem(item).count

		if playerItemCount >= count and count > 0 then
			TriggerEvent('esx_addoninventory:getInventory', 'sokin_paste', xPlayer.identifier, function(inventory)
				xPlayer.removeInventoryItem(item, count)
				inventory.addItem(item, count)
			end)
		else
            TriggerClientEvent("FeedM:showNotification", xPlayer.source, 'Niepoprawna ilość.', 5000, 'primary')
		end
	elseif type == 'item_account' then
		if xPlayer.getAccount(item).money >= count and count > 0 then
			xPlayer.removeAccountMoney(item, count)

			TriggerEvent('esx_addonaccount:getAccount', 'sokin_paste_' .. item, xPlayer.identifier, function(account)
				account.addMoney(count)
			end)
		else
            TriggerClientEvent("FeedM:showNotification", xPlayer.source, 'Niepoprawna ilość.', 5000, 'primary')
		end
	end
end)

ESX.RegisterServerCallback('sokin_paste:getPropertyInventory', function(source, cb)
    local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = 0
	local items      = {}
	TriggerEvent('esx_addonaccount:getAccount', 'sokin_paste_black_money', xPlayer.identifier, function(account)
		blackMoney = account.money
	end)

	TriggerEvent('esx_addoninventory:getInventory', 'sokin_paste', xPlayer.identifier, function(inventory)
		items = inventory.items
	end)

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)

ESX.RegisterServerCallback('sokin_paste:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local blackMoney = xPlayer.getAccount('black_money').money
	local items      = xPlayer.inventory

	cb({
		blackMoney = blackMoney,
		items      = items,
	})
end)