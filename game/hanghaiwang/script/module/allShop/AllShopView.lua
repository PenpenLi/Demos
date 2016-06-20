-- FileName: AllShopView.lua
-- Author: huxiaozhou
-- Date: 2015-09-06
-- Purpose:商店入口整合view
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

AllShopView = class("AllShopView")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString


function AllShopView:ctor()
	self.layMain = g_fnLoadUI("ui/all_shop.json")
end

function AllShopView:create()
	local layMain = self.layMain
	self:initData()
	self:initListView()
	self:reLoadLsv()
	local btnClose = layMain.BTN_CLOSE -- 关闭按钮
	btnClose:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeCommonLayout({action = true, endPos = MainShip.getRobBtnWorldPos().allShopPos})
		end
	end)
	return layMain
end

function AllShopView:initData(  )
	self.tOpenData = AllShopData.getOpenShopData()
	logger:debug(self.tOpenData)
end

function AllShopView:initListView(  )
	self.lsv = self.layMain.LSV_ALLSHOP
	local cellSize = self.lsv.lay_cell:getSize()
	local marginH = self.lsv:getItemsMargin()
	local count = table.count(self.tOpenData)
	if count>4 then
		coount = 4
	end
	self.lsv:setSize(CCSizeMake(cellSize.width, (cellSize.height+marginH)*count))
	self.layBg = self.layMain.LAY_BG
	local oldSize = self.layBg:getSize()
	self.layBg:setSize(CCSizeMake(oldSize.width, oldSize.height + (cellSize.height+marginH)*(count-1)))
	local oldSize = self.layMain.img_shops_bg:getSize()
	self.layMain.img_shops_bg:setSize(CCSizeMake(oldSize.width, oldSize.height + (cellSize.height+marginH)*(count-1)))

	UIHelper.initListView(self.lsv)
	
end

function AllShopView:reLoadLsv(  )
	local cell, nIdx = 0, 0 
	for i, itemData in ipairs(self.tOpenData or {}) do
		self.lsv:pushBackDefaultItem()	
		nIdx = i - 1
		cell = self.lsv:getItem(nIdx)  -- cell 索引从 0 开始
		self:loadCell(cell,itemData)
	end
end

function AllShopView:loadCell(cell, cellData)
	logger:debug({cellData =cellData})
	for i=1,2 do
		local btnItem = cell["BTN_CELL" .. i]
		if not cellData[i] then
			btnItem:removeFromParent()
		else
			local tData = cellData[i]
			btnItem.TFD_SHOP_NAME:setText(tData.name)
			UIHelper.labelNewStroke(btnItem.TFD_SHOP_NAME, ccc3(0x5e, 0x31, 0x00))
			btnItem.tfd_des:setText(tData.desc)
			btnItem.IMG_SHOP_ICON:loadTexture(tData.filePath)
			btnItem.img_tip:setEnabled(tData.showRed())
			if tData.num then
				btnItem.LABN_TIP:setStringValue(tData.num())
			end
			
			btnItem:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					tData.func()
				end
			end)

			UIHelper.registExitAndEnterCall(btnItem, function (  )
				if tData.type == "castle" then
					GlobalScheduler.removeCallback("castleShop")
				end
			end, function (  )
				if tData.type == "castle" then
					local max = DB_Vip.getDataById(tonumber(UserModel.getVipLevel())).mysicalShopAddTime
					logger:debug({tData = tData})
					if tonumber(tData.num()) < tonumber(max) then
						logger:debug("enter if")
						local function updateCastle(  )
							logger:debug("MysteryCastleData.getRefreshCdTime() " .. MysteryCastleData.getRefreshCdTime() )
							if (MysteryCastleData.getRefreshCdTime() <= 0 and tonumber(tData.num()) < tonumber(max)) then 
								MysteryCastleData.resetSysRefreshTimes()
								MysteryCastleData.setFreeTimes()
								btnItem.img_tip:setEnabled(true)
								logger:debug("tData.num() = " .. tData.num())
								btnItem.LABN_TIP:setStringValue(tData.num())
							end	
						end
						GlobalScheduler.addCallback("castleShop", updateCastle)
					end
					
				end
			end)
			

		end
	end
end

