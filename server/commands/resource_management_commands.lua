-- Resource Management

function CMD_rmstart(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, 'Start a resource [/rmstart name]')
		return 1
	end
	
	if not isTrusted(source) then
		TriggerClientEvent('chatMessage', source, 'Error', { 255, 0, 0 }, 'You can not use this command.')
		return 1
	end
	
	local arguments = argsToLocals(args)
	if parseInput("s", arguments) then
		local Resource = table.unpack(arguments) 
		
		if Resource == "ServerManagement" then
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'You can\'t do that!')
			return 1
		end
		
		if StartResource(Resource) then
			TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Started resource!')
		else
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'Could not start resource!')
		end
		
	else
		TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Wrong Usage.')
	end
end

function CMD_rmstop(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, 'Stop a resource [/rmstop name]')
		return 1
	end
	
	if not isTrusted(source) then
		TriggerClientEvent('chatMessage', source, 'Error', { 0, 255, 0 }, 'You can not use this command.')
		return 1
	end
	
	local arguments = argsToLocals(args)
	if parseInput("s", arguments) then
		local Resource = table.unpack(arguments) 
		
		if Resource == "ServerManagement" then
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'You can\'t do that!')
			return 1
		end
		
		if StopResource(Resource) then
			TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Stoped resource!')
		else
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'Could not stop resource!')
		end
		
	else
		TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Wrong Usage.')
	end
end

function CMD_rmrestart(source, args, help)
	if help then
		TriggerClientEvent('chatMessage', source, 'Help', { 0, 255, 0 }, 'Restart a resource [/rmrestart name]')
		return 1
	end
	
	if not isTrusted(source) then
		TriggerClientEvent('chatMessage', source, 'Error', { 0, 255, 0 }, 'You can not use this command.')
		return 1
	end
	
	local arguments = argsToLocals(args)
	if parseInput("s", arguments) then
		local Resource = table.unpack(arguments) 
		
		if Resource == "ServerManagement" then
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'You can\'t do that!')
			return 1
		end
		
		if StopResource(Resource) then
			TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Stoped resource!')
			
			if StartResource(Resource) then
				TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Restarted resource!')
			else
				TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'Could not restart resource!')
			end
		else
			TriggerClientEvent('chatMessage', source, 'RM', { 255, 0, 0 }, 'Could not stop resource!')
		end
	else
		TriggerClientEvent('chatMessage', source, 'RM', { 0, 255, 0 }, 'Wrong Usage.')
	end
end