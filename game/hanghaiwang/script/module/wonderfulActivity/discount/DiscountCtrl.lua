-- FileName: DiscountCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-11-12
-- Purpose: 折扣活动view
--[[TODO List]]

module("DiscountCtrl", package.seeall)
require "script/module/wonderfulActivity/discount/DiscountView"
require "script/module/wonderfulActivity/discount/DiscountData"
-- UI控件引用变量 --

-- 模块局部变量 --


function destroy(...)
	package.loaded["DiscountCtrl"] = nil
end

function moduleName()
    return "DiscountCtrl"
end

function updateListViewBy(_DisName)
	local tbListData = DiscountData.getListDataByDisName(_DisName)
	logger:debug({discountName__________________________ = _DisName,
		tbListData = tbListData})
	DiscountView.createMainListViewBy(tbListData)
end

function createByName(_DisName)

	DiscountData.initDbData()

	if(DiscountData.getActivityLastTime(_DisName) <= 0) then
		ShowNotice.showShellInfo("活动已经结束了")   --todo
		return
	end

	
	function disCountInfoCallbck(cbFlag, dictData, bRet )
		if(dictData.err == "ok") then
			if(  not table.isEmpty(dictData.ret)) then
				logger:debug(dictData.ret)
				for k,v in pairs(dictData.ret) do
					if(k == _DisName) then
						--1111
						for id,info in pairs(v.globalLimitGoods or {}) do
							local nself = 0
							if(v.selfBuy == nil ) then
								nself = 0
							elseif(v.selfBuy[id] == nil) then
								nself = 0
							else
								nself = v.selfBuy[id]
							end

							local tbInfo  = {name = _DisName,rowId = tonumber(id),allBuy = tonumber(info),selfBuy = tonumber(nself), }
							DiscountData.setDisCountDataByName(tbInfo)
						end

						--如果一个全服不限购，只是个人限购
						for idd,info in pairs(v.selfBuy or {}) do
							local bFind = false
							for kkk,v in pairs(v.globalLimitGoods or {}) do
								--不包括111的情况
								if(tonumber(idd) == tonumber(kkk)) then
									bFind = true
									break

								end
							end
							if(bFind == false) then
								local tbInfo1 = {name = _DisName,rowId = tonumber(idd),allBuy = 0,selfBuy = tonumber(info)}
								DiscountData.setDisCountDataByName(tbInfo1)
							end
						end
					end
				end
			end
			local tbBtnEvent = {}
			local accView = DiscountView.create(tbBtnEvent,_DisName)
			MainWonderfulActCtrl.addLayChild(accView)
			updateListViewBy(_DisName)

			local nState = DiscountData.getDiscountNewAniState(_DisName)
			logger:debug(_DisName .."的本地缓冲是:" .. nState)
			if(nState ~= 1) then
				DiscountData.setDiscountNewAniState(_DisName,1)
				local listCell = DiscountData.getCellByName(_DisName)
				logger:debug(listCell)
				listCell:removeNodeByTag(100)
			end


		end
	end
	local tbRpcArgs = {_DisName}
	-- local tbRpcArgs = {}
	RequestCenter.discount_getInfo(disCountInfoCallbck ,Network.argsHandlerOfTable(tbRpcArgs))
end

