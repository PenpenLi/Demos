-- FileName: FirstGift.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: function description of module
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

FirstGift = class("FirstGift")

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString

function FirstGift:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/activity_first_recharge.json")
end

function FirstGift:create(tbArgs)
	self.tbArgs = tbArgs
	local layMain = self.layMain
	layMain.img_main_bg:setScale(g_fScaleX)
	UIHelper.labelAddNewStroke(layMain.tfd_desc, m_i18n[1179], ccc3(0x28, 0x00, 0x00))
	UIHelper.labelAddNewStroke(layMain.tfd_name, m_i18n[1180], ccc3(0x28, 0x00, 0x00))
	local btnIAP = self.layMain.BTN_RECHARGE
	btnIAP:addTouchEventListener(self.tbArgs.goIAP)
	UIHelper.titleShadow(btnIAP, m_i18n[6815])
	self:updateUI()
	return layMain
end

function FirstGift:updateUI(  )

	local IMG_TIP = WonderfulActModel.tbBtnActList["firstGift"]
	local num = FirstGiftData.getRedNum()
	IMG_TIP:setVisible(num > 0 and true or false)
	IMG_TIP.LABN_TIP_EAT:setStringValue(tostring(num))

	local tRewards = FirstGiftData.getFirstGifts()
	for index,rewards in ipairs(tRewards) do
		local layout = self.layMain["IMG_CELL_" .. index]
		local colLayout = layout.LAY_FORTBV
		local colCellRef = colLayout.LAY_CLONE
		colCellRef:setEnabled(true)
		local colCellCopy = colCellRef:clone()
		colCellRef:setEnabled(false)
		local oneItemPercent = (colCellCopy:getSize().width) / colLayout:getSize().width

		layout.BTN_GET:setGray(false)
		UIHelper.titleShadow(layout.BTN_GET, m_i18n[5753])
		layout.BTN_GET:setTouchEnabled(true)


		if FirstGiftData.getHasGetFirstGiftById(index) then
			layout.BTN_GET:setGray(true)
			UIHelper.titleShadow(layout.BTN_GET, m_i18n[4372])
			layout.BTN_GET:setTouchEnabled(false)
		end
		layout.BTN_GET:removeNodeByTag(100)
		if FirstGiftData.getCanGetGiftsByIndex(index) and not FirstGiftData.getHasGetFirstGiftById(index) then
			local effect = EffFirstGiftBtn:new()
			layout.BTN_GET:addNode(effect:Armature(), 1, 100)
		end
		

		layout.BTN_GET:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				if not FirstGiftData.getCanGetGiftsByIndex(index) then
					AudioHelper.playCommonEffect()
					ShowNotice.showShellInfo(m_i18n[5754])
					return
				end
				AudioHelper.playBtnEffect("tansuo02.mp3")
				logger:debug({ tttt = RewardUtil.getItemsDataByStr(FirstGiftData.gettStrRewardsByIndex(index))})
				local tNeedBag = RewardUtil.getItemsDataByStr(FirstGiftData.gettStrRewardsByIndex(index))
				for i,v in ipairs(tNeedBag or {}) do
					if (v.type == "item" and ItemUtil.bagIsFullWithTid(v.tid, true)) then
						return
					end
				end
				
				local args = Network.argsHandlerOfTable({FirstGiftData.getPlatformType(), FirstGiftData.getKeyByIndex(index)})
				RequestCenter.user_getFirstPayReward(function ( cbFlag, dictData, bRet )
					if dictData.err == "ok" then
						FirstGiftData.setFirstReward(index)
						layout.BTN_GET:removeNodeByTag(100)
						self:updateUI()

						local dlg = UIHelper.createRewardDlg(FirstGiftData.gettRewardsByIndex(index, true))
						LayerManager.addLayoutNoScale(dlg)
					end
				end,args)
			end
		end)
		for j, rowData in ipairs(rewards) do
			for i,colData in ipairs(rowData) do
				local colCell = colCellCopy:clone()
				colCell:setPositionPercent(ccp(oneItemPercent * (i - 1), 0))
				colLayout:addChild(colCell)
				if i==1 then
					local effect = EffFirstGift:new(5)
					colData.icon:addNode(effect:Armature(), 1, 100)
				end
				self:initRowView(colData, colCell, index)
			end
		
		end
	end
end

function FirstGift:initRowView( iconData, iconCell, index)
	local imgGood = iconCell.IMG_GOODS --物品背景
	imgGood:addChild(iconData.icon)
end

