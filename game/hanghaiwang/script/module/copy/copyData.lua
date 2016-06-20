-- FileName: copyData.lua
-- Author: xianghuiZhang
-- Date: 2014-04-02
-- Purpose: 显示公共数据

require "script/GlobalVars"
require "script/utils/LuaUtil"
require "script/model/user/UserModel"
require "script/module/public/ShowNotice"
require "script/module/public/ItemUtil"

-- 模块公共变量 --
copyElitePath = "images/copy/ecopy/"
copyNormalPath = "images/copy/ncopy/"
copyEntrancePath = "images/copy/ncopy/entranceimage/"
copyEntLinePath = "images/copy/ncopy/lineimage/" --副本路线图片

HeroheadPath = "images/base/hero/head_icon/"
fogPath = "images/copy/fog/"
armyBorderPath = "images/copy/ncopy/fortpotential/"
animationPath = "images/effect/"

blCopyStyle = 1 --副本类型1普通，2精英
local nNewBaseId = 0 --开启新据点的id
local nNewCopyId = 0 --开启新的副本

local isFirstPassCopy_1_4 = false 				-- 新手引导用
local isFirstPassCopy_1_5 = false
function setFirstPasscopy4(status)
	isFirstPassCopy_1_4 = status
end
function getFirstPasscopy4()
	return isFirstPassCopy_1_4
end
function setFirstPasscopy5(status)
	isFirstPassCopy_1_5 = status
end
function getFirstPasscopy5()
	return isFirstPassCopy_1_5
end

-- 副本数据存储
local _normalCopyCache 	= nil	-- 普通副本
local _eliteCopyCache 	= nil	-- 精英副本

-----------数据请求处理

-- 请求精英副本数据
function requestEliteData( ... )
-- RequestCenter.getEliteCopyList(getEliteCopyCallback)
end


--是否开启新据点
local function fnGetNewBase( tbNcopy,baseId,state )
	-- local newBase = true
	-- if (tbNcopy.va_copy_info ~= nil and baseId ~= nil and state ~= nil) then
	-- 	--print("tbNcopy",state)
	-- 	--print_t(tbNcopy)
	-- 	for k,v in pairs(tbNcopy.va_copy_info.baselv_info) do
	-- 		if (tonumber(k) == baseId and state["1"].status >= 3) then
	-- 			newBase = false
	-- 		end
	-- 	end
	-- end
	-- return newBase
end

--重置副本数据
function resetCopyResult( tbItemResult )
	if (tbItemResult ~= nil) then

		if( tbItemResult.normal ) then

			local newCopy = false --是否开启新副本
			local addCopyId
			local netBaseInfo
			local remoteNCopy = DataCache.getReomteNormalCopyData()

			logger:debug("new copy data =============")
			logger:debug(tbItemResult)
			logger:debug("cache copy data =============")
			logger:debug(remoteNCopy)
			
			for n_copyid, n_copydata in pairs(tbItemResult.normal) do
				if(remoteNCopy[n_copyid] == nil) then
				
					-- 将新的副本ID放在缓存中
					-- DataCache.setNewNormalCopyId(n_copyid)
					--在副本世界地图中增加对话标识
					require "script/model/user/UserModel"
					CCUserDefault:sharedUserDefault():setIntegerForKey("pass_dialogid_"..UserModel.getUserUid(), n_copyid)
				    CCUserDefault:sharedUserDefault():flush()

					newCopy = true
					nNewCopyId = tonumber(n_copyid)
				else

					logger:debug("isFirstPassCopy_1_4 = %s", getFirstPasscopy4())
					logger:debug("isFirstPassCopy_1_5 = %s", getFirstPasscopy5())
					-- 第一个副本通关
					if( tonumber(n_copyid) == 1 
						and n_copydata.va_copy_info 
						and  n_copydata.va_copy_info.baselv_info 
						and n_copydata.va_copy_info.baselv_info["1003"] 
						and tonumber(n_copydata.va_copy_info.baselv_info["1003"]["1"].status) >=3 )  then
						local temp_copy = remoteNCopy["1"]
						if( temp_copy.va_copy_info
							and  temp_copy.va_copy_info.baselv_info 
							and temp_copy.va_copy_info.baselv_info["1003"] 
							and tonumber(temp_copy.va_copy_info.baselv_info["1003"]["1"].status) <3 )  then

							setFirstPasscopy4(true) --isFirstPassCopy_1_4 = true
						end
					end
					-- 第一个副本通关
					if( tonumber(n_copyid) == 1 
						and n_copydata.va_copy_info 
						and  n_copydata.va_copy_info.baselv_info 
						and n_copydata.va_copy_info.baselv_info["1005"] 
						and tonumber(n_copydata.va_copy_info.baselv_info["1005"]["1"].status) >=3 )  then
						local temp_copy = remoteNCopy["1"]
						if( temp_copy.va_copy_info
							and  temp_copy.va_copy_info.baselv_info 
							and temp_copy.va_copy_info.baselv_info["1005"] 
							and tonumber(temp_copy.va_copy_info.baselv_info["1005"]["1"].status) <3 )  then

							setFirstPasscopy5(true) --isFirstPassCopy_1_5 = true
						end
					end

					logger:debug("isFirstPassCopy_1_4 = %s", getFirstPasscopy4())
					logger:debug("isFirstPassCopy_1_5 = %s", getFirstPasscopy5())
					require "script/module/copy/itemCopy"
					--开启新的据点
					for ka,va in pairs(n_copydata.va_copy_info.baselv_info) do
						if (va[""..itemCopy.copyDifficulty]~=nil and (remoteNCopy[""..n_copyid].va_copy_info.baselv_info[""..ka]==nil or remoteNCopy[""..n_copyid].va_copy_info.baselv_info[""..ka][""..itemCopy.copyDifficulty]==nil) ) then
							addCopyId = ka
						end
					end
					
				end
				
				if (tonumber(itemCopy.copyID)==tonumber(n_copyid)) then
					netBaseInfo = n_copydata
				end
				remoteNCopy[n_copyid] = n_copydata
				
				logger:debug("netBaseInfo copy data 1=============")
				logger:debug(netBaseInfo)
				
				logger:debug("netBaseInfo copy data 33=============")
				logger:debug(netBaseInfo)
				
			end

			DataCache.setNormalCopyList(remoteNCopy)
			--netBaseInfo=remoteNCopy[""..itemCopy.copyID]
			-- if (LayerManager.curModuleName()==MainCopy.moduleName()) then
				if (newCopy) then
					require "script/module/copy/MainCopy"
					if (MainCopy.isInMap()) then
						MainCopy.updateInit()
						MainCopy.upCopyListView()
					end
					nNewBaseId = 0
					if (itemCopy.isInItemCopy()) then
						itemCopy.initBaseLayout(netBaseInfo)
						itemCopy.showClearanceTip(nNewCopyId)
					end
					-- MainCopy.openCopyToElite(netBaseInfo.copy_id)
				else
					require "script/module/copy/itemCopy"
					if (addCopyId ~= nil) then
						nNewBaseId = tonumber(addCopyId)
					else
						nNewBaseId = 0
					end
					if (itemCopy.isInItemCopy()) then
						itemCopy.initBaseLayout(netBaseInfo,nNewBaseId)
					end
				end
			-- end
		end
		if( not table.isEmpty(tbItemResult.elite) ) then
			DataCache.setEliteCopyData(tbItemResult.elite)
		end
		if( tbItemResult.activity ) then
			DataCache.setActiveCopyData(tbItemResult.activity)
		end
	end
	logger:debug("resetCopyResult")

end
--生成天降宝物获得物品提示字符串
function createTreasureNotice(drop)
	--判断是否有宝物
	local num = 0
	if (drop) then
		for _,v in pairs(drop) do
			num=num+1
		end
	end
	if (num==0) then
		return nil
	end
	
	local tbGifts =  ItemDropUtil.getDropTreasureItem(drop)

	logger:debug(drop.item)
	local text = gi18n[1946]
	for k,v in  pairs (tbGifts) do
		text=text..string.format("【%s】*%d",v.name,v.num)
	end
	return text
end
