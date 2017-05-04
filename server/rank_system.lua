--[[
Get the player guid from /getguid
]]

Admin = {
	"steam:110000108718a42"
}
Mod = {
	"steam:110000108718a42"
}
Trusted = {
	"steam:110000108718a42"
}

-- Don't Change anything below if you don't know what you are doing.

function inArray(item, array)
	-- Loop, check if UID:v == item
	for i, v in pairs(array) do
		if v == item then
			return true
		end
	end
	return false
end


function isAdmin(id)
	local identifiers = GetPlayerIdentifiers(id)
	
	for _, v in ipairs(identifiers) do
		if inArray(v, Admin) then
			return true
		end
	end
	return false
end

function isMod(id)
	local identifiers = GetPlayerIdentifiers(id)
	
	for _, v in ipairs(identifiers) do
		if inArray(v, Mod) then
			return true
		end
	end
	return false
end

function isTrusted(id)
	local identifiers = GetPlayerIdentifiers(id)
	
	for _, v in ipairs(identifiers) do
		if inArray(v, Trusted) then
			return true
		end
	end
	return false
end