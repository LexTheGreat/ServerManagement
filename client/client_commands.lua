Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		if NetworkIsSessionStarted() then
			TriggerServerEvent('commands_onPlayerJoining')
			return
		end
	end
end)