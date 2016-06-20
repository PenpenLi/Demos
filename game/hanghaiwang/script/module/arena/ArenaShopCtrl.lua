-- FileName: ArenaShopCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-09
-- Purpose: 竞技场商城兑换控制界面
--[[TODO List]]



module ("ArenaShopCtrl",package.seeall)

require "script/module/arena/ArenaShopView"

local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end
local m_index
function destroy(...)
	package.loaded["ArenaShopCtrl"] = nil
end

function moduleName()
    return "ArenaShopCtrl"
end


function updateShopView(  )
	ArenaShopView.updateAfterBuy(m_index)
end

function create(  )
	ArenaData.initAllGoods()
	local tbBtnEvent = {}
	-- 兑换按钮
	tbBtnEvent.onExChange = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onExChange")
			
			local _allGoods = ArenaData.getArenaAllShopInfo()
			m_index = ArenaData.getIndexByGoodsId(sender:getTag())
			logger:debug("m_index = %s ", m_index)
			local itemInfo = _allGoods[m_index]
			require "script/module/shop/BuyPropsCtrl"

			  --限购次数
			local maxLimitNum =  tonumber(itemInfo.baseNum) - ArenaData.getBuyNumBy(itemInfo.id)
			logger:debug(maxLimitNum)
			
			if tonumber(itemInfo.highest_rank) < tonumber(ArenaData.getMinPosition()) then
			 	-- ShowNotice.showShellInfo(m_i18nString(2256, itemInfo.highest_rank))
			elseif(maxLimitNum <= 0 ) then
			   ShowNotice.showShellInfo(m_i18n[2253])
			else
				logger:debug(itemInfo)
				
				local itemType, item_id, item_num = ArenaData.getItemData(itemInfo.items)
				if itemType~=3 then
					if (item_id and ItemUtil.bagIsFullWithTid(item_id, true)) then
						AudioHelper.playCommonEffect()
						return
					end
				end
			
				--花费 1：花费类型为声望 , 2：花费类型为金币
				if(UserModel.getPrestigeNum() < itemInfo.costPrestige ) then
					ShowNotice.showShellInfo(m_i18n[2254])
					AudioHelper.playCommonEffect()
					return
				end
				local function onSure( num )
					AudioHelper.playBtnEffect("buttonbuy.mp3")
					local args = CCArray:create()
					args:addObject(CCInteger:create(itemInfo.id))
					args:addObject(CCInteger:create(num or 1))
					local function callback( cbFlag, dictData, bRet )
						UserModel.addPrestigeNum(-itemInfo.costPrestige*(num or 1))
						ArenaData.addBuyNumberBy(itemInfo.id, (num or 1))
						updateShopView()
						local itemType, item_id, item_num = ArenaData.getItemData( itemInfo.items )
						if itemType ~= 3 then
							local tItem = ItemUtil.getItemById(item_id)
							ShowNotice.showShellInfo(m_i18nString(6931, tItem.name, item_num*(num or 1)))
						else
							UserModel.addGoldNumber(item_num*(num or 1))
							ShowNotice.showShellInfo(m_i18nString(6931, m_i18n[2220], item_num*(num or 1)))
						end
					
					end
					RequestCenter.arena_buy(callback,args)
					LayerManager.removeLayout()
				end


				local item_data = nil
				local itemName = nil
				local itemQuality = nil
				local hasNum = 0
				if(tonumber(itemType) ~= 3)then
					-- DB_Arena_shop表中每条数据中的 物品数据
					require "script/module/public/ItemUtil"

					item_data = ItemUtil.getCacheItemInfoBy(item_id)
					if( not table.isEmpty(item_data))then
						hasNum = item_data.item_num
					end

					local itemDesc = ItemUtil.getItemById(item_id)
					itemName = itemDesc.name
					itemQuality = itemDesc.quality
				else
					hasNum = nil
					itemName = m_i18n[2220]
					itemQuality = 5
				end
				AudioHelper.playCommonEffect()
				local tbData = {onSure = onSure,hasNumber = hasNum ,itemName = itemName, canBuyNum = maxLimitNum,
				 costType = 1, costNum = itemInfo.costPrestige, quality = itemQuality}
				require "script/module/arena/ArenaMesBatchBuy"
				local batchBuy = ArenaMesBatchBuy:new()
				local batchDlg = batchBuy:create(tbData)
				LayerManager.addLayout(batchDlg)
			end
		end
	end
	local arenaShopInfo = ArenaShopView.create(tbBtnEvent)
	return arenaShopInfo
end
