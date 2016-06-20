-- FileName: MReleaseUtil.lua
-- Author: sunyunpeng
-- Date: 2015-12-02
-- Purpose: function description of module
--[[TODO List]]

module("MReleaseUtil", package.seeall)

-- UI控件引用变量 --
local tbReatainObj = {}
local tbReatainNoReleaseObj = {}

-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["MReleaseUtil"] = nil
end

function moduleName()
    return "MReleaseUtil"
end

function create(...)

end

--[[
layGroup:界面名称
kindGroupName；缓存的obj组
obj：被缓存的
]]
function insertRetainObj( layGroupName, kindGroupName ,obj )
	local layGroupRetain = tbReatainObj[layGroupName]
	if (layGroupRetain) then
		local kindGroupRetain = layGroupRetain[kindGroupName]
		if (kindGroupRetain) then
			obj:retain()
			table.insert(kindGroupRetain,obj)
		else
			layGroupRetain[kindGroupName] = {}
			local kindGroupRetain = layGroupRetain[kindGroupName]
			obj:retain()
			table.insert(kindGroupRetain,obj)
		end
	else
		tbReatainObj[layGroupName] = {}
		local layGroupRetain = tbReatainObj[layGroupName]
		layGroupRetain[kindGroupName] = {}
		local kindGroupRetain = layGroupRetain[kindGroupName]
		obj:retain()
		table.insert(kindGroupRetain,obj)
	end
end

function insertRetainNOReleaseObj( layGroupName, kindGroupName ,obj ,objName)
	local layGroupRetain = tbReatainNoReleaseObj[layGroupName]
	if (layGroupRetain) then
		local kindGroupRetain = layGroupRetain[kindGroupName]
		if (kindGroupRetain) then
			if (not kindGroupRetain[objName]) then
				obj:retain()
				kindGroupRetain[objName] = obj
			end
		else
			layGroupRetain[kindGroupName] = {}
			local kindGroupRetain = layGroupRetain[kindGroupName]
			if (not kindGroupRetain[objName]) then
				obj:retain()
				kindGroupRetain[objName] = obj
			end
		end
	else
		tbReatainNoReleaseObj[layGroupName] = {}
		local layGroupRetain = tbReatainNoReleaseObj[layGroupName]
		layGroupRetain[kindGroupName] = {}
		local kindGroupRetain = layGroupRetain[kindGroupName]
		if (not kindGroupRetain[objName]) then
			obj:retain()
			kindGroupRetain[objName] = obj
		end
	end
end

function getRetainNOReleaseObj( layGroupName, kindGroupName  ,objName)
	local layGroupRetain = tbReatainNoReleaseObj[layGroupName]
	if (layGroupRetain) then
		local kindGroupRetain = layGroupRetain[kindGroupName]
		logger:debug({getRetainNOReleaseObj = kindGroupRetain})
		local noRealseObj = kindGroupRetain[objName]
		return noRealseObj
	end
end


function getRetainNOReleaseObjGroup( layGroupName, kindGroupName )
	local layGroupRetain = tbReatainNoReleaseObj[layGroupName]
	if (layGroupRetain) then
		local kindGroupRetain = layGroupRetain[kindGroupName]
		return kindGroupRetain
	end
end


--[[
layGroup:界面名称
kindGroupName；缓存的obj组
]]
function releaseObj( layGroupName, kindGroupName  )
	local layGroupRetain = tbReatainObj[layGroupName]
	if (layGroupRetain) then
		local kindGroupRetain = layGroupRetain[kindGroupName]
		for i,v in ipairs(kindGroupRetain or {}) do
			local reatainObj = kindGroupRetain[i]
			reatainObj:release()
			reatainObj = nil
		end
		layGroupRetain[kindGroupName] = nil
	end
end

--[[
 释放所有
]]
function releaseAllObj( ... )
	for _,layGroup in pairs(tbReatainObj) do
		if (layGroup) then
			for _,kindGroupRetain in pairs(layGroup) do
				if (kindGroupRetain) then
					for i,v in ipairs(kindGroupRetain) do
						local reatainObj = kindGroupRetain[i]
						reatainObj:release()
						reatainObj = nil
					end
				end
				kindGroupRetain = nil
			end
		end
		layGroup = nil
	end
	tbReatainObj = {}
end
