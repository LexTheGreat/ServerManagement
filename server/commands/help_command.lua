function CMD_smhelp(source, args, help)
	TriggerClientEvent('chatMessage', source, '================================', { 0, 255, 0 }, '')
	TriggerClientEvent('chatMessage', source, 'Player Commands', { 0, 255, 0 }, '')
	CMD_guid(source, args, true)
	if (isMod(source) or isAdmin(source)) then
		TriggerClientEvent('chatMessage', source, 'Server Management', { 0, 255, 0 }, '')
		CMD_kick(source, args, true)
		CMD_kickid(source, args, true)
		if isAdmin(source) then
			CMD_ban(source, args, true)
			CMD_banid(source, args, true)
		end
	end
	if isTrusted(source) then
		TriggerClientEvent('chatMessage', source, 'Resource Management', { 0, 255, 0 }, '')
		CMD_rmstart(source, args, true)
		CMD_rmstop(source, args, true)
		CMD_rmrestart(source, args, true)
	end
	TriggerClientEvent('chatMessage', source, '================================', { 0, 255, 0 }, '')
end