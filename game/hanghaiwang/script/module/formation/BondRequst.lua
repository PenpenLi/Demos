-- FileName: BondRequst.lua
-- Author: yucong
-- Date: 2015-07-23
-- Purpose: 羁绊与后端交汇
--[[TODO List]]

module("BondRequst", package.seeall)

require "script/module/formation/BondManager"

-- 获得单个伙伴羁绊
function getArrUnionByHero( modelId, func )
	function cb ( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({unionData = dictData.ret})
			local data = BondData.getBondData()
			data[tonumber(modelId)] = dictData.ret
			BondData.setBondData(data)

			if (func) then
				func()
			end	
			GlobalNotify.postNotify(BondManager.BOND_MSG.CB_BOND_HERO)
		end
	end
	RequestCenter.union_getArrUnionByHero(cb, Network.argsHandlerOfTable({modelId}))
end

-- 获得阵容羁绊
function getArrUnionByFmt( func )
	function cb ( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({unionFmtData = dictData.ret})
			local ret = dictData.ret
			local data = BondData.getBondData()
			for modelId, tbonds in pairs(ret) do
				data[tonumber(modelId)] = tbonds
			end
			BondData.setBondData(data)
			logger:debug({_tbBondDatas = data})
			--activate(10031, 251)
			if (func) then
				func()
			end
			GlobalNotify.postNotify(BondManager.BOND_MSG.CB_BOND_FORMATION)
		end
	end
	RequestCenter.union_getArrUnionByFmt(cb)
end

-- 激活伙伴羁绊
function activate(modelId, unionId, func)
	function cb ( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug({activateOK = dictData.ret})
			local data = BondData.getBondData()
			local tInfo = data[tonumber(modelId)] or {}
			table.insert(tInfo, unionId)
			data[tonumber(modelId)] = tInfo
			BondData.setBondData(data)
			if (func) then
				func()
			end
			GlobalNotify.postNotify(BondManager.BOND_MSG.CB_BOND_OPEN)
		end
	end
	RequestCenter.union_activate(cb, Network.argsHandlerOfTable({modelId, unionId}))
end

