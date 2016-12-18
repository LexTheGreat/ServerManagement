function CMD_smhelp(source, args, help)
	TriggerClientEvent('chatMessage', source, '', { 0, 255, 0 }, '================')
	CMD_guid(source, args, true)
	CMD_kick(source, args, true)
	CMD_kickid(source, args, true)
	CMD_ban(source, args, true)
	CMD_banid(source, args, true)
	TriggerClientEvent('chatMessage', source, '', { 0, 255, 0 }, '================')
end

function CMD_guid(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, '/guid')
		return 1
	end
	
	TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'GUID: '.. GetPlayerGuid(source) .. ' | EP: ' .. GetPlayerEP(source))
	TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'A: '.. isAdmin(source) ..' | M: '.. isMod(source) ..' | T: '.. isTrusted(source))
end

function CMD_kick(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, '/kick playername reason (Admin/Mod)')
		return 1
	end
	
	if not (isMod(source) or isAdmin(source)) then
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'You are not staff!')
	end
	
	local arguments = argsToLocals(args)
	if parseInput("ss", arguments) then
		local playername, reason = table.unpack(arguments)
		
		
		local target = PlayerVar:getPlayerByName(playername)
		
		if target then
			TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Kicking ' .. playername)
			DropPlayer(target, reason)
			return 1
		end
		
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Incorrect Target. [' .. target .. ']')
	else
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Wrong Usage /kick playername reason.')
	end
end

function CMD_kickid(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, '/kickid id reason (Admin/Mod)')
		return 1
	end
	
	if not (isMod(source) or isAdmin(source)) then
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'You are not staff!')
	end
	
	local arguments = argsToLocals(args)
	if parseInput("i", arguments) then
		local playerid, reason = table.unpack(arguments)
		
		
		if GetPlayerName(playerid) ~= nil then
			TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Kicking ' .. playerid)
			DropPlayer(target, reason)
			return 1
		end
		
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Incorrect Target. [' .. target .. ']')
	else
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Wrong Usage /kickid id reason.')
	end
end

function CMD_ban(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, '/ban playername reason (Admin/Mod)')
		return 1
	end
	
	if not (isMod(source) or isAdmin(source)) then
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'You are not staff!')
	end
	
	local arguments = argsToLocals(args)
	if parseInput("ss", arguments) then
		local playername, reason = table.unpack(arguments)
		
		
		local target = PlayerVar:getPlayerByName(playername)
		
		if target then
			TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Ban ' .. playername)
			TempBanPlayer(target, reason)
			return 1
		end
		
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Incorrect Target. [' .. target .. ']')
	else
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Wrong Usage /banid playername reason.')
	end
end

function CMD_banid(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, '/banid id reason (Admin/Mod)')
		return 1
	end
	
	if not (isMod(source) or isAdmin(source)) then
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'You are not staff!')
	end
	
	local arguments = argsToLocals(args)
	if parseInput("is", arguments) then
		local playerid, reason = table.unpack(arguments)
		
		
		if GetPlayerName(playerid) ~= nil then
			TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Ban ' .. playerid)
			TempBanPlayer(target, reason)
			return 1
		end
		
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Incorrect Target. [' .. target .. ']')
	else
		TriggerClientEvent('chatMessage', source, 'SM', { 0, 255, 0 }, 'Wrong Usage /banid id reason.')
	end
end

function Count(t)
	count = 0
	for k,v in pairs(t) do
		 count = count + 1
	end
	
	return count
end