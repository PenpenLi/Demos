-- FileName: GuildShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-04-03	
-- Purpose: 联盟商店 控制模块
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("GuildShopCtrl", package.seeall)
require "script/module/guild/GuildDataModel"
require "script/module/guild/GuildUtil"
require "script/module/guild/shop/GuildShopView"

-- 模块局部变量 --
local tType = {spe=1, normal=2}
local curType = tType.spe

local m_i18n = gi18n
local m_i18nString = gi18nString


local function init(...)

end

function destroy(...)
	GuildShopView.destroy()
	package.loaded["GuildShopCtrl"] = nil
end

function moduleName()
    return "GuildShopCtrl"
end

function createView( fnCallBack, nKeep)
	local tbEvents = {}
	-- 关闭
	tbEvents.fnClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("fnClose")
			AudioHelper.playBackEffect()
			MainGuildCtrl.getGuildInfo()
		end
	end
	if fnCallBack then
		logger:debug("fnCallBackHere")
		tbEvents.fnClose = fnCallBack
	end

	-- 特殊商品
	tbEvents.fnSpe = function ( sender, eventType )
		if (GuildShopView.getSelectedBtnTag() == sender:getTag()) then
			GuildShopView.btnSelectFunc(sender)
		end
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvents.fnSpe")

			if (GuildShopView.getSelectedBtnTag() == sender:getTag()) then
				GuildShopView.btnSelectFunc(sender)
				return
			end
			AudioHelper.playTabEffect()
			GuildShopView.btnSelectFunc(sender)
			GuildShopView.reLoadUI(tType.spe)
			curType = tType.spe
		end
	end

	-- 日常商品
	tbEvents.fnNormal = function ( sender, eventType )
		if (GuildShopView.getSelectedBtnTag() == sender:getTag()) then
			GuildShopView.btnSelectFunc(sender)
		end
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvents.normal")

			if (GuildShopView.getSelectedBtnTag() == sender:getTag()) then
				GuildShopView.btnSelectFunc(sender)
				return
			end
			AudioHelper.playTabEffect()
			GuildShopView.btnSelectFunc(sender)
			GuildShopView.reLoadUI(tType.normal)
			curType = tType.normal
		end
	end

	-- 兑换物品
	tbEvents.fnBuy = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvents.fnBuy goodsId = %s", sender:getTag())
			
			local convertcd = GuildUtil.isShopCD()
			if convertcd ~= false then
				-- ShowNotice.showShellInfo(m_i18n[3812] )
				-- AudioHelper.playCommonEffect()
		        return
			end

			local tbBuy = {}
			local tbGoods = {}
			local goodId = sender:getTag()
			if curType == tType.spe then
				tbBuy =  GuildDataModel.getSpecialBuyNumById(goodId)
				tbGoods = GuildUtil.getSpcialGooodById(goodId)
			else
				tbBuy = GuildDataModel.getNorBuyNumById(goodId) 
				tbGoods = GuildUtil.getNormalGoodById(goodId)
			end

		

			local shoplevel = GuildDataModel.getShopLevel()
			if(shoplevel<tbGoods.needLegionLevel ) then	
		        -- ShowNotice.showShellInfo(m_i18n[3814] .. tbGoods.needLegionLevel .. m_i18n[3809])
		        -- AudioHelper.playCommonEffect()
		        return
			end

			local canBuy, tip  = canBuyGoods(tbGoods , tbBuy)
			if(canBuy== true) then
				if tbGoods.costContribution then
					if(GuildDataModel.getSigleDoante() < tonumber(tbGoods.costContribution)) then
						ShowNotice.showShellInfo(m_i18n[3815])
						AudioHelper.playCommonEffect()
		       			return
					end
				end
				
				if tbGoods.costGold then
					if(UserModel.getGoldNumber() < tonumber(tbGoods.costGold)) then
						local noGoldAlert = UIHelper.createNoGoldAlertDlg()
						LayerManager.addLayout(noGoldAlert)
						AudioHelper.playCommonEffect()
		       			return
					end
				end


				if (tbGoods.tid and ItemUtil.bagIsFullWithTid(tbGoods.tid, true)) then
					AudioHelper.playCommonEffect()
					return
				end
				AudioHelper.playBtnEffect("buttonbuy.mp3")
				local args= CCArray:create()
				args:addObject(CCInteger:create(sender:getTag()))
				args:addObject(CCInteger:create(1))
				RequestCenter.guildShop_buy(function (cbFlag, dictData, bRet)
					
					if (dictData.err ~= "ok") then
						return
					end

					local limitType= tonumber(tbGoods.limitType)

					if(limitType ==3 or limitType == 4) then
						if(dictData.ret== "failed" ) then
							ShowNotice.showShellInfo(m_i18n[3813])
							return 
						end
					end 
					local num,sum=0,0
					if(limitType ==1 or limitType == 2) then
						num=1
						sum=0
					elseif(limitType == 3 or limitType == 4) then
						num=1
						sum=1
					end
					if( curType == tType.spe) then
						GuildDataModel.addSpecialBuyNumById(tbGoods.id, sum,num)
					else
						GuildDataModel.addNorBuyNumById(tbGoods.id, sum,num)
					end
					if tbGoods.costContribution then
						GuildDataModel.addSigleDonate(-tonumber(tbGoods.costContribution))
					end
					if tbGoods.costGold  then
						UserModel.addGoldNumber(-tonumber(tbGoods.costGold))
					end

					GuildShopView.reLoadUI(curType)

					-- local tbDrop = {}
					-- tbDrop.item = {{[tbGoods.tid] = tbGoods.num}}
					-- UIHelper.showDropItemDlg(tbDrop, m_i18n[3816])
						local tItem = ItemUtil.getItemById(tbGoods.tid)
						ShowNotice.showShellInfo(m_i18nString(6931, tItem.name, tbGoods.num))
				 end, args)
			else
				-- ShowNotice.showShellInfo(tip) -- 支持 #35969
			end
		end
	end

	curType = tType.spe
	LayerManager.addUILoading()
	local view = GuildShopView.create(tbEvents)
	logger:debug("nKeep = %s",nKeep)
	LayerManager.changeModule(view,moduleName(), {1}, true, nKeep)
	PlayerPanel.addForUnionShop()

	performWithDelay(view,function()
		LayerManager.begainRemoveUILoading()
	end,10)
	
end


-- 判断是否可以购买物品
function canBuyGoods( tGoods, tBuy )
	local limitType = tonumber(tGoods.limitType)
	-- 个人购买次数
	local num=0 
	-- 军团购买次数
	local sum = 0 
	local tip= m_i18n[3813]
	if( limitType ==1 or limitType == 2) then
		num=  tGoods.personalLimit- tBuy.num
		if(num >0) then
			return true ,tip
		else
			return false, tip 
		end
	elseif(limitType ==3 or limitType == 4) then
		sum= tGoods.baseNum- tBuy.sum 
		num= tGoods.personalLimit - tBuy.num 
		if(num>0 and sum >0) then
			return true, tip
		else
			if (sum ==0)then			
				tip= m_i18n[3819] 
			else
				tip = m_i18n[3813]
			end
			return false, tip
		end
	end
end


function create(fnCallBack, nKeep)
	logger:debug("nKeep = %s",nKeep)
	RequestCenter.guildShop_getShopInfo(function ( cbFlag, dictData, bRet )
		GuildDataModel.setShopInfo(dictData.ret)
		createView(fnCallBack, nKeep)
	end)

end
