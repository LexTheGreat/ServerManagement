description 'Server Management Tools'

-- Client
client_script 'client/client_commands.lua'

-- Server
server_scripts 'server/util/utils.lua'
server_scripts 'server/util/PlayerVarAPI.lua'
server_scripts 'server/rank_system.lua'
server_scripts 'server/util/server_commands_system.lua'

server_scripts 'server/commands/server_management_commands.lua'
server_scripts 'server/commands/resource_management_commands.lua'
server_scripts 'server/commands/help_command.lua'
