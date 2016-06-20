


module("db_shareTextureList_util",package.seeall)

require "db/DB_ShareTextureList"

local list = nil

function ini()
	list = {}
	for k,item in pairs(DB_ShareTextureList.ShareTextureList or {}) do
		list[item[2]] = item[3]
	end
end

function getShareName( animationName )
	if(animationName and list) then
		return list[animationName]
	end
end


function release()
	_G["db_shareTextureList_util"] = nil
	package.loaded["db_shareTextureList_util"] = nil
	-- package.loaded["db/DB_shareTextureList"] = nil
	list = {}
end