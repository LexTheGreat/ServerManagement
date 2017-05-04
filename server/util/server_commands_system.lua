--[[

Copyright (c) 2016 FiveReborn

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

]]

local MAX_COMMANDS = 1000
local MAX_EXCLUDED_CMDS 	= MAX_COMMANDS
local CMDDEBUG_MODE 		= true
local excludedPlayerCMDS 	= {}
--new
local allCommands = {{},{},{}} --Three dimensional
local CMD_NAME = 1

--Command exit codes (Made these global since other scripts may use them)
CMD_EXIT_CODE_ERROR, CMD_EXIT_CODE_SUCCESS, CMD_EXIT_CODE_PREPROC_NOT_ALLOWED = 0, 1, 2

AddEventHandler('onResourceStart', function(resource)
	print('Command resource started!')
	--[[
	for i = 1, 32 do
		excludeCMDForPlayer(i, "CMD_vehicle") --Exclude this command for every single player..
	end
	]]
end)

AddEventHandler('chatMessage', function(source, name, message)
	if(string.sub(message, 1, 1) == "/" and string.len(message) >= 2) then
		chatCommandEntered(source, message)
		CancelEvent()
	end
end)


function chatCommandEntered(source, fullcommand) -- Event handler for when a command is entered,
	if source == nil then
		print('[commands]: Got a nil source! (error)')
	end

    fullcommand = string.gsub(fullcommand, "/", "")
	local command = stringsplit_command(fullcommand, " ") -- Converts the command arguments into an array for easy usage.
	local cmdname = command[1]
	local success = ProcessedCMD(source, command)
	if OnPlayerCommandProcessed then
		OnPlayerCommandProcessed(source, cmdname, success)
	end
end

--[[
--These functions can be in any given file but they can only be implemented once
--This function gets called after a command is executed
function OnPlayerCommandProcessed(source, cmdname, success)
	if success == CMD_EXIT_CODE_ERROR then
		TriggerClientEvent('chatMessage', source, '', { 0, 0, 0 }, 'Invalid command: ' .. '"/' .. cmdname .. '".')
	end
end

--This function can prevent a command from being executed if it returns 0
function OnPlayerPreProcessCMD(source, command)
	--TriggerClientEvent('chatMessage', source, '', { 0, 0, 0 }, 'OnPlayerPreProcessCMD: Entered command: ' .. '"/' .. command .. '".')
	return 1
end
]]

function ProcessedCMD(source, command) --This function evaluates if a command can be processed or not. Todo: add a table with loaded commands to restrict them?
	if string.len(command[1]) then
		local cmdFunc = "CMD_" .. command[1]
		--if not isCMDExcludedForPlayer(source, cmdFunc) then
			if _G[cmdFunc] then 
				--[[if OnPlayerPreProcessCMD then --Only try and call this if the function is present in the script
					local result = OnPlayerPreProcessCMD(source, command[1])
					if result ~= 1 then
						return CMD_EXIT_CODE_PREPROC_NOT_ALLOWED
					end
				end]]
				table.remove(command, 1) --Remove the first element which is the command name prior to sending the args
			    _G[cmdFunc](source, command, false)
			    return CMD_EXIT_CODE_SUCCESS
			end
		--end
	end
	return CMD_EXIT_CODE_ERROR
end

function initCommandsArray(source)
    excludedPlayerCMDS[source] = {}
    for j = 1, MAX_EXCLUDED_CMDS do
        excludedPlayerCMDS[source][j] = 0 -- Fill the values here
    end
	print('excludedPlayerCMDS initialized for player ' .. source)
end

--simply unloads all commands
function unloadExcludedCMDSForPlayer(source)
	for j = 1, MAX_EXCLUDED_CMDS do
    	excludedPlayerCMDS[source][j] = 0
    end
end

function isCMDExcludedForPlayer(source, cmdFunc)
	if CMDDEBUG_MODE then
		print(string.format("isCMDExcludedForPlayer(%d, %s)", source, cmdFunc))
	end
	for j = 1, MAX_EXCLUDED_CMDS do
		local cmdFuncIdx = excludedPlayerCMDS[source][j]
        if cmdFuncIdx ~= 0 and cmdFuncIdx == cmdFunc then
        	return true
        end
    end
    return false
end

function excludeCMDForPlayer(source, cmdFunc)
	local index = findFreeCMDSlot(source)
	if index ~= -1 then
		excludedPlayerCMDS[source][index] = cmdFunc
	end
end

function findFreeCMDSlot(source)
	for j = 1, MAX_EXCLUDED_CMDS do
        if excludedPlayerCMDS[source][j] == 0 then
        	return j
        end
    end
    return -1
end

RegisterServerEvent("commands_onPlayerJoining")
AddEventHandler('commands_onPlayerJoining', function()
	--initCommandsArray(source) Don't need to exclude we will handle that...
	registerCommandsForPlayer(source)
end)

AddEventHandler('playerDropped', function(player)
    -- unloadExcludedCMDSForPlayer(source)
    print('Commands cleared for player ' .. player .. ' with source ' .. source)
end)

--utils needed by this script
function stringsplit_command(self, delimiter) --Moved this here so people don't have stringsplit issues and this can be packed into an all in one include
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end

function argsToLocals(args)
	local missingArgs = false
	if not #args then
		return nil
	end
	for n = 1, #args do
		if CMDDEBUG_MODE then
			print(args[n])
		end
		if cmdArg_isempty(args[n]) then
			missingArgs = true
		end
	end
	if missingArgs then
		return nil
	end
	return args
end

function cmdArg_isempty(s)
  return s == nil or s == ''
end

function getMatchVarType(vType)
	if vType == 'd' or vType == 'i' or vType == 'f' then
		return 'number'
	end
	if vType == 's' then
		return 'string'
	end
end

function stringCastToType(string) --Simply casts to a numeric value if it's convertable
	local value
	value = tonumber(string)
	if value == nil then
		value = string
	end
	return value
end

function makeTblByPattern(match, args)
	local tstrings = {}
	local output = {}
	local gotstring, cstring, forceToString
	for n = 1, #args do
		local mIndex = n-1
		cstring = stringCastToType(args[n])
		if mIndex >= #match-1 then
			if match[#match-1] == 's' then --Again, if last param is 's'
				forceToString = true
			end
		end
		if type(cstring) == 'number' and not forceToString then --If the arg is a number
			if CMDDEBUG_MODE then
				print('number got ' .. cstring)
			end
			table.insert(output, cstring)
		else 
			table.insert(tstrings, cstring)
			if CMDDEBUG_MODE then
				print('string got ' .. cstring)
			end
			if type(args[n+1]) == 'string' then --If the next arg is a string
				if CMDDEBUG_MODE then
					print("there is something like a string afterwards...")
				end
			else
				local stringy = table.concat(tstrings, " ")
				table.insert(output, stringy) --Now that we've everything, add it to output
				tstrings = {} --We're done, wipe the tstrings table now, this will assign a new mem address to it as well since gc will destroy it :/
				forceToString = false
				if CMDDEBUG_MODE then
					print('string done and wiped table, string was ' .. stringy)
				end
			end
		end
	end
	print(table.unpack(output))
	return output
end

function parseInput(specifiers, args)
	--[[
		-- Issues:
		-- String problems where numbers are not recognized as strings for string specifiers [fixed]
		-- If the specifiers are "ds", it doesn't scan for the last specifier...  [fixed]
	]]
	local matched = true
	local makeException
	local failCount = 0
	local varType
	if #args == 0 then
		return false
	end
	for n = 1, #args do
		local spIndex = n-1
		if spIndex > #specifiers-1 then
			spIndex = #specifiers-1 --dumb fix
		end

		varType = type(stringCastToType(args[n]))
		
		--In special cases, when the last specifier isn't "s" (which happens if we go past that last specifier which is impossible, look above...)
		if spIndex >= #specifiers-1 then
			if specifiers[#specifiers-1] == 's' then --Again, if last param is 's'
				varType = "string"
			end
		end

		if not makeException then --If the last param doesn't equal 's' and we're not making an exception we can safely scan since we still have matches...
			if varType ~= getMatchVarType(specifiers[spIndex]) and spIndex <= #specifiers-1 then
				if CMDDEBUG_MODE then
					print(string.format("[parseInput] Error: %s (%s index: %d) does not match specifier %s (%s index: %d)", varType, args[n], n, getMatchVarType(specifiers[spIndex]), specifiers[spIndex], spIndex))
				end
				failCount = failCount + 1
			elseif #args ~= #specifiers then --If we don't have the same amount of specifiers
				if specifiers[#specifiers-1] == 's' then --And the last specifier is 's'
					if failCount == 0 and spIndex == #specifiers-1 then --And we're at the last one... (in the case specifiers are "ds", the spIndex should be 1 for "s")
						if CMDDEBUG_MODE then
							print('[parseInput] Making exception in args, specifiers')
						end
						makeException = true --Here's your cookie
					else --We're not on the last one but on the first one being "d"
						if failCount > 0 then
							::failure::
							matched = false
							if CMDDEBUG_MODE then
								print('[parseInput] number of args (1): ' .. #args .. ' does not equal specifier ' .. #specifiers ..  ' failCount: ' .. failCount .. ' spIndex: ' .. spIndex .. '.')
							end
							break
						else
							if #args < #specifiers then
								failCount = failCount + 1
								goto failure --Cannot have less args than specifiers, which would mean one of the next args is unset
							end
						end
					end
				else
					matched = false
					if CMDDEBUG_MODE then
						print('[parseInput] number of args (2): ' .. #args .. ' does not equal specifier ' .. #specifiers .. '.')
					end
					break
				end
			end
		end
	end
	if failCount > 0 then
		matched = false
	end
	return matched
end

function reloadRegisteredPlayerCommands(source)
	return registerCommandsForPlayer(source)
end

function registerCommandsForPlayer(source)
	print('Client with id ' .. source .. ' connecting, registering commands for such client...')
    allCommands[source] = {{},{}}
    local slot = 1
    for cmdName, cmdFunc in pairs(_G) do
        if type(cmdFunc) == "function" then
        	if string.sub(cmdName,1,string.len('CMD_')) == 'CMD_' then
        		--if not isCMDExcludedForPlayer(source, cmdName) then
        			if #allCommands[source][CMD_NAME] > MAX_COMMANDS then
			    		print("ERROR: Couldn't register command " .. cmdName .." too many " .. "(" .. #allCommands[source][CMD_NAME] .. ")," .. " increase MAX_COMMANDS(" .. MAX_COMMANDS .. ")!!!!!")
			    		break
			    	end
            		allCommands[source][CMD_NAME][slot] = cmdName
    				slot = slot + 1
            	--end
        	end
        end
    end
    return allCommands
end

function Command_GetNext(source, index) --Only parse registered commands
	local buffer
	if index >= 1 and index <= getRegisteredCommandCount(source) then
		if allCommands[source][CMD_NAME][index] ~= nil then
			buffer = allCommands[source][CMD_NAME][index]
		end
	end
	return buffer
end

function Command_GetNext_Wrapper(source, index)
	local buffer = Command_GetNext(source,index )
	if buffer ~= nil then
		if CMDDEBUG_MODE then
			print('buffer not nil')
		end
		local buffExplode = stringsplit_command(buffer, "_") --We only want the name
		buffer = buffExplode[2]
	end
	return buffer
end

function getRegisteredCommandCount(source)
	return #allCommands[source][CMD_NAME]
end

function getMaxCommands()
	return MAX_COMMANDS
end