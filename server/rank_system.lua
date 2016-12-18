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
	"steam:110000108718a42",
	"steam:456454654654564"
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
	return inArray(GetPlayerGuid(id), Admin)
end

function isMod(id)
	return inArray(GetPlayerGuid(id), Mod)
end

function isTrusted(id)
	return inArray(GetPlayerGuid(id), Trusted)
end