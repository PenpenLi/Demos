-- FileName: IAPView.lua
-- Author: huxiaozhou
-- Date: 2015-07-07
-- Purpose: 重置界面 和 vip 预览界面
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

IAPView = class("IAPView")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString

local tType = {kIAP = 1, kVip = 2}

function IAPView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/shop_recharge.json")
end

function IAPView:create(tbArgs)
	self.tbArgs = tbArgs
	local layMain = self.layMain
	self:initIAPData()
	self.iapLsv = self.layMain.LSV_RECHARGE
	UIHelper.initListViewCell(self.iapLsv)
	self.iconPath = "images/base/props/"
	local btnClose = layMain.BTN_CLOSE -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)
	
	self:initBase()
	if self.tbArgs.showType == "vip" then
		self:initIAP()
		self:initVIP()
	else
		self:initVIP()
		self:initIAP()
	end
	
	return layMain
end

function IAPView:initIAPData(  )
	self.iapData = IAPData.getPayListData()
end

function IAPView:getIAPCount(  )
	return table.count(self.iapData)
end

-- 初始化公用
function IAPView:initBase(  )
	self.curType = tType.kIAP
	self.layMain.LABN_VIP:setStringValue(UserModel.getVipLevel())
	local db_vip = {}
	local layDes = self.layMain.lay_vip_desc
	self.layMain.tfd_max:setText(m_i18n[5741])
	local bMax = VipData.getIsMaxVipLevel(UserModel.getVipLevel())
	if bMax then
		db_vip = DB_Vip.getDataById(UserModel.getVipLevel())
		layDes:setEnabled(false)
		self.layMain.tfd_max:setEnabled(true)
	else
		self.layMain.tfd_max:setEnabled(false)
		layDes:setEnabled(true)
		db_vip = DB_Vip.getDataById(UserModel.getVipLevel()+1)
	end
	

	local nChargeNum = DataCache.getChargeGoldNum()
	local nLevelUpNum = db_vip.rechargeValue
	local needGold = nLevelUpNum - nChargeNum

	logger:debug("nChargeNum = %s", nChargeNum)
	logger:debug("nLevelUpNum = %s", nLevelUpNum)
	logger:debug("needGold = %s", needGold)
	self.layMain.TFD_EXP:setText(nChargeNum .. "/" .. nLevelUpNum)
	UIHelper.labelNewStroke(self.layMain.TFD_EXP, ccc3(0x8e,0x46,0x00))
	local nPercent = nChargeNum / nLevelUpNum * 100
	self.layMain.LOAD_EXP:setPercent((nPercent > 100) and 100 or nPercent)

	
	layDes.tfd_recharge_again:setText(m_i18n[1413])
	layDes.TFD_RECHARGE_NUM:setText(needGold .. m_i18n[2220]) --TODO
	layDes.tfd_recharge_become:setText(m_i18n[5717])
	layDes.LABN_VIP_SMALL:setStringValue(bMax and UserModel.getVipLevel() or UserModel.getVipLevel() + 1)
end

-- 初始化VIP礼包界面
function IAPView:initVIP(  )
	self.curType = tType.kVip
	self.curVip = UserModel.getVipLevel()
	self.layMain.lay_look_vip:setEnabled(true)
	self.layMain.lay_recharge:setEnabled(false)
	local img_vip_bg = self.layMain.img_vip_bg
	self.labNum = img_vip_bg.TFD_NUM
	UIHelper.labelNewStroke(self.labNum, ccc3(0x9c,0x2c,0x00))
	self.lsv = img_vip_bg.LSV_VIP
	self.btnRight = img_vip_bg.BTN_RIGHT
	self.btnLeft = img_vip_bg.BTN_LEFT
	self.btnRight:addTouchEventListener(self.tbArgs.doRight)
	self.btnLeft:addTouchEventListener(self.tbArgs.doLeft)
	self.layMain.BTN_RECHARGE:addTouchEventListener(self.tbArgs.doChangeUI)
	UIHelper.titleShadow(self.layMain.BTN_RECHARGE, m_i18n[1412])

	self.btnRight:setTouchEnabled(true)
	self.btnRight:setGray(false)
	self.btnLeft:setTouchEnabled(true)
	self.btnLeft:setGray(false)


	self.giftCell = self.lsv.LAY_VIP_CELL
	self.giftCell:retain()
	self.lay_vip_privilege = self.lsv.lay_vip_privilege
	self.lay_vip_privilege:retain()

	self.lay_unless = self.lsv.lay_unless
	self.lay_unless:retain()
	
	self.labDesc1 = self.lsv.TFD_VIPGIFT_DESC_1
	self.labDesc1:retain()

	self.labDesc2 = self.lsv.TFD_VIPGIFT_DESC_2
	self.labDesc2:retain()

	self.lsv:removeAllItems()
	self:updateVip(UserModel.getVipLevel())
end

--  改变显示vip 特权描述 和vip礼包
function IAPView:changeVipUI( value )
	self.curVip = self.curVip + value

	self.btnRight:setTouchEnabled(true)
	self.btnRight:setGray(false)
	self.btnLeft:setTouchEnabled(true)
	self.btnLeft:setGray(false)

	if VipData.getIsMaxVipLevel(self.curVip) and value >= 0 then
		self.btnRight:setTouchEnabled(false)
		self.btnRight:setGray(true)
	end
	if self.curVip == 1 then
		self.btnLeft:setTouchEnabled(false)
		self.btnLeft:setGray(true)
	end

	self:updateVip(self.curVip)
end


function IAPView:updateVip(vipLevel)
	self.lsv:removeAllItems()
	self.labNum:setText("VIP" .. vipLevel ..  m_i18n[5718])
	local tVip = VipData.getVipData(vipLevel)
	if tVip.hasGift then -- 处理vip 礼包的显示
		local giftCell = self.giftCell:clone()
		local tfd_vip_title = giftCell.tfd_vip_title
		tfd_vip_title:setText("V" .. vipLevel .. m_i18n[1403])
		local subLsv = giftCell.LSV_VIPGIFT
		self.lsv:pushBackCustomItem(giftCell)
		UIHelper.initListView(subLsv)
		local cell, nIdx
		for i,tIcon in ipairs(tVip.gifts or {}) do
			subLsv:pushBackDefaultItem()
			nIdx = i - 1
			cell = subLsv:getItem(nIdx)  -- cell 索引从 0 开始

			local imgIcon = cell.IMG_VIPGIFT_ICON
			imgIcon:addChild(tIcon.icon)
			local labName = cell.TFD_VIPGIFT_NAME
			labName:setText(tIcon.name)
			local color =  g_QulityColor[tonumber(tIcon.quality)]
			if(color ~= nil) then
				labName:setColor(color)
			end
		end
	end
	
	local lay_vip_privilege = self.lay_vip_privilege:clone()
	lay_vip_privilege.tfd_vip_privilege:setText("V" .. vipLevel .. m_i18n[5719])
	self.lsv:pushBackCustomItem(lay_vip_privilege)

	self.lsv:pushBackCustomItem(self.lay_unless:clone())



	local labDesc1 = self.labDesc1:clone()
	labDesc1 = tolua.cast(labDesc1 , "Label")
	local contentSize = labDesc1:getContentSize()
	
	local labelttf = CCLabelTTF:create(tVip.tDesc.desc, g_sFontCuYuan, 24, CCSizeMake(510, 0), kCCTextAlignmentLeft)
	local contentSize = labelttf:getContentSize()
	labDesc1:setSize(CCSizeMake(contentSize.width, contentSize.height))

	labDesc1:setText(tVip.tDesc.desc)

	logger:debug("size.width = %s, size.height = %s", labDesc1:getSize().width, labDesc1:getSize().height)
	self.lsv:pushBackCustomItem(labDesc1)

	local labDesc2 = self.labDesc2:clone()
	labDesc2 = tolua.cast(labDesc2 , "Label")

	local labelttf2 = CCLabelTTF:create(tVip.tDesc.desc2, g_sFontCuYuan, 24, CCSizeMake(510, 0), kCCTextAlignmentLeft)
	local contentSize2 = labelttf2:getContentSize()
	labDesc2:setSize(contentSize2)
	labDesc2:setText(tVip.tDesc.desc2)
	logger:debug("size.withd = %s, size.height = %s", labDesc2:getSize().width, labDesc2:getSize().height)
	self.lsv:pushBackCustomItem(labDesc2)
end


-- 初始化 充值界面
function IAPView:initIAP( )
	self.curType = tType.kIAP
	self.layMain.lay_look_vip:setEnabled(false)
	self.layMain.lay_recharge:setEnabled(true)
	self.layMain.BTN_LOOK_VIP:addTouchEventListener(self.tbArgs.doChangeUI)
	UIHelper.titleShadow(self.layMain.BTN_LOOK_VIP, m_i18n[5720])
	self:reLoadLSV()
end

function IAPView:reLoadLSV()
	local function updateCellByIdex( lsv, idx )
		logger:debug("idx = %s", idx)
		local tIAPItem = self.iapData[idx+1]
		local cell = g_fnGetWidgetByName(lsv:getItem(idx),"LAY_RECHARGE_CELL")
		if not cell then
			logger:debug("cell is nil ")
			return
		end
		cell.BTN_RECHARGE_CELL:addTouchEventListener(self.tbArgs.doIAP)
		cell.BTN_RECHARGE_CELL.tData = tIAPItem
		cell.IMG_ICON:loadTexture(self.iconPath .. tIAPItem.icon)

		local layNow = cell.lay_now
		local ti18nCom = { m_i18n[5745],tIAPItem.consume_grade , m_i18n[2220]}
		for i,v in ipairs(ti18nCom) do
			layNow["tfd_now_" .. i]:setText(v)
		end
		local layBack = cell.lay_back
		if tIAPItem.bVipCard then
			cell.TFD_GOLD_NUM:setText(m_i18n[5748])
			cell.img_tip:setEnabled(tIAPItem.bVipCard)
			local ti18nVC = { m_i18n[5722], tIAPItem.continueTime,  m_i18n[5749], tIAPItem.rewards[1].num, m_i18n[2220]}
			for i,v in ipairs(ti18nVC) do
				layBack["tfd_back_" .. i]:setText(v)
				-- AppStore审核
				if (Platform.isAppleReview()) then
					layBack["tfd_back_" .. i]:setVisible(false)
				end
			end
			local number = VipCardModel.getRemainDays()
			cell.TFD_MONTH:setEnabled(tonumber(number)>0)
			cell.TFD_MONTH:setText(gi18nString(5747,number))
			-- AppStore审核
			if (Platform.isAppleReview()) then
				cell.TFD_MONTH:setEnabled(false)
			end
		else
			cell.TFD_MONTH:setEnabled(false)
			local ti18nVC = {}
			local bRecommend = (tonumber(tIAPItem.is_recommend) == 1)
			local bHasPay = IAPData.getHasPayById(tIAPItem.id)
			cell.img_tip:setEnabled(bRecommend and not bHasPay)
			if bRecommend then
				if bHasPay then
					ti18nVC = {m_i18n[5724], tIAPItem.gold_num, m_i18n[2220], "", ""}
				else
					ti18nVC = {m_i18n[5725], tIAPItem.special_gold_num, m_i18n[5726], "", ""}
				end
			else
				ti18nVC = {m_i18n[5724], tIAPItem.gold_num, m_i18n[2220], "", ""}
			end
			for i,v in ipairs(ti18nVC) do
				layBack["tfd_back_" .. i]:setText(v)
				-- AppStore审核
				if (Platform.isAppleReview()) then
					layBack["tfd_back_" .. i]:setVisible(false)
				end
			end
			cell.TFD_GOLD_NUM:setText(tIAPItem.consume_grade .. m_i18n[2220])
		end
		
		cell.TFD_PRICE_TXT:setText(m_i18n[5727])
		cell.TFD_PRICE:setText(tIAPItem.consume_money)
		
	end
	UIHelper.reloadListView(self.iapLsv,self:getIAPCount(),updateCellByIdex)
end

-- 刷新UI界面
function IAPView:refreshUI(tbArgs) 
	self:initBase()
	self:initIAPData()
	self:reLoadLSV()
end

-- 充值和vip 界面切换
function IAPView:changeUI(  )
	if self.curType == tType.kVip then
		self:initIAP()
	else
		self:initVIP()
		self:changeVipUI(0)
	end
end

function IAPView:release( )
	self.giftCell:release()
	self.lay_vip_privilege:release()
	self.lay_unless:release()
	self.labDesc1:release()
	self.labDesc2:release()
end
