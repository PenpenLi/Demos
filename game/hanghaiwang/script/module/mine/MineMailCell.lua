-- FileName: MineMailCell.lua
-- Author:sunyunpeng
-- Date: 2014-06-02
-- Purpose: 资源矿邮件cell
--[[TODO List]]
-- 模块局部变量 --
require "script/module/public/class"
require "script/module/mine/MineMailData"
require "script/module/public/BTRichText"
-- UI控件引用变量 -
-- 模块局部变量 --
local m_requestNewMailNum = 6
local m_TagRichText = 10001

local m_i18nString = gi18nString
local m_i18n = gi18n
local _tempIdtb = MineMailData.MINEMAIlTEMPLATEID
local _textStyle = MineMailData.TEXTCOLORSTYLE


MineMailCell = class("MineMailCell")


function MineMailCell:ctor( layCell,btnCell)
	local layCell = layCell
	local btnCell = btnCell

	self.cell = tolua.cast(layCell, "Layout")
	self.btnCell = tolua.cast(btnCell, "Layout")

	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function MineMailCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mlaycell = widget:clone()
		self.mlaycell:setPosition(ccp(0,0))
		self.mlaycell:setEnabled(true)
	end
end

function MineMailCell:addMaskBtn(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("MineMailCell:addMaskBtn:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
		logger:debug("LevelRewardCell:addMaskBtn  xx = %f, yy = %f", xx, yy)
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}

	end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function MineMailCell:touchMask(point)
	logger:debug("MineMailCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	MineMailData._menuBtnCanCall = true
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
        return nil
    end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug("MineMailCell:touchMask rect:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("MineMailCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			return self.tbBtnEvent[name]
			-- return true
		end
	end
end


function MineMailCell:getGroup()
	if (self.mlaycell) then
		-- local tg = HZTouchGroup:create() -- 可接受触摸事件，传递给UIButton等UI控件
		-- tg:addWidget(self.mlaycell)
		-- return tg
		return self.mlaycell
	end
	return nil
end

-- 更多邮件按钮回调
function MineMailCell:moreMineMailBtnCallFun( sender, eventType )
	logger:debug("moreMineMailBtnCallFun")
	logger:debug(sender)
	logger:debug(eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
		-- 音效
		logger:debug("moreMineMailBtnCallFun")
		AudioHelper.playCommonEffect()
		local tag = sender:getTag()

		if(MineMailCtrl._curPage == 1)then
			--仇人信息
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data.list) == 0)then
					local str = m_i18n[5660] --"没有更多邮件可显示！"
					ShowNotice.showShellInfo(str)
					--return
				end
				local newDataCount = table.count(t_data.list) 
				local mineMailType = MineMailCtrl._curPage

				MineMailData.showMineMailData = MineMailData.addToShowMineMailData(MineMailData.showMineMailData,t_data.list,ntotleMail,mineMailType)
				MineMailView.setMailData(MineMailData.showMineMailData,newDataCount)
			end
			MineMailService.getRevengeMailList( tag ,m_requestNewMailNum,"true",createNext)
		end
		if(MineMailCtrl._curPage == 2)then
			--资源到期
			-- 创建下一步UI
			local function createNext( t_data ,ntotleMail)
				if(table.count(t_data) == 0)then
					local str = m_i18n[5660]--"没有更多邮件可显示！"
					ShowNotice.showShellInfo(str)
					--return
				end
				local newDataCount = table.count(t_data) 
				local mineMailType = MineMailCtrl._curPage
				MineMailData.showMineMailData = MineMailData.addToShowMineMailData(MineMailData.showMineMailData,t_data,ntotleMail,mineMailType)
				MineMailView.setMailData(MineMailData.showMineMailData,newDataCount)
			end
			MineMailService.getResourceExhaustMailList( tag ,m_requestNewMailNum,"true",createNext)
		end
	end

end


-- 更多邮件cell
function MineMailCell:refreshMoreBtnCell(tbData)
	local moreBtnCell = self.mlaycell.LAY_MORE
	moreBtnCell:setEnabled(true)
	
	local mid = tonumber(MineMailData.showMineMailData[#MineMailData.showMineMailData-1].mid)

	local btnMore = self.mlaycell.BTN_MORE
	btnMore:setTag(mid)
	self:addMaskBtn(btnMore, "BTN_MORE", function ( sender, eventType )
		self:moreMineMailBtnCallFun(sender, eventType)
	end)
	btnMore:setTitleText(m_i18n[2160])

end

-- 抢夺信息Tab
function MineMailCell:refreshRobLogCell(tCellValue,tbRichStr)
	local noBtnCell = self.mlaycell.LAY_CELL_NOBTNS
	noBtnCell:setEnabled(true)

	local TFD_CLASS = noBtnCell.TFD_CLASS
	TFD_CLASS:setText(tCellValue.cellTitle)  --todo

	local TFD_STATUS = noBtnCell.TFD_STATUS
	local strDay = MineMailData.getValidTime(tCellValue.rob_time)
	TFD_STATUS:setText(strDay)  --todo

	local layContent = nil
 	layContent = noBtnCell.LAY_RICH_TEXT2
 	layContent:removeAllChildrenWithCleanup(true)

 	--富文本
 	local richStr
 	--富文本的按钮回调
 	local tbEvent = {}
 	tbEvent.tag = 0   --初始化为0

 	richStr =  UIHelper.concatString({tbRichStr.nowCapture,
 										tCellValue.content[1] or "",
 										tbRichStr.preCapture,
 										tCellValue.content[2] or "",
 										tbRichStr.mineRegionType ,
 										tbRichStr.mineRegionId,
 										tCellValue.content[3] or "", 
 										tbRichStr.mineMineType})
				 	textInfo = {richStr,{_textStyle.NAME;
									 	_textStyle.NORMAL;
									 	_textStyle.NAME;
									 	_textStyle.NORMAL;
									 	_textStyle.OTHER;
									 	_textStyle.OTHER;
									 	_textStyle.NORMAL;
									 	_textStyle.OTHER;
									 	}}

 	local richText = BTRichText.create(textInfo, nil, nil)
 	richText:setSize(layContent:getSize())
 	richText:setAnchorPoint(ccp(0,0))
 	richText:setPosition(ccp(0,0))
 	layContent:addChild(richText, 10, m_TagRichText)
	
end

-- 资源到期Tab
function MineMailCell:refreshResorceExhaustCell(tCellValue,tbRichStr)
	logger:debug({refreshResorceExhaustCell_tCellValue = tCellValue})
	logger:debug({tbRichStr = tbRichStr})

	local tbEvent = {}
	tbEvent.tag = 0   --初始化为0

	local noBtnCell = self.mlaycell.LAY_CELL_NOBTNS
	noBtnCell:setEnabled(true)
	
	local TFD_CLASS = noBtnCell.TFD_CLASS
	TFD_CLASS:setText(tCellValue.cellTitle)  --todo
	local TFD_STATUS = noBtnCell.TFD_STATUS
	local strDay = MineMailData.getValidTime(tCellValue.recv_time)
	TFD_STATUS:setText(strDay)  --todo

	local layContent = nil
 	layContent = noBtnCell.LAY_RICH_TEXT2
 	layContent:removeAllChildrenWithCleanup(true)

	---1 资源矿占领期完成  占领时间结束  1
	if (tonumber(tCellValue.templateId) == _tempIdtb.ZYZLWC or tonumber(tCellValue.templateId) == _tempIdtb.ZLSJJS)  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 									  tbRichStr.captureTime,
	 									  tbRichStr.content[2] or "",
	 									  tbRichStr.gatherSilver,
	 									  tbRichStr.content[3] or ""})
				 	textInfo = {richStr,{
									 	_textStyle.NORMAL;
									 	_textStyle.OTHER;
									 	_textStyle.NORMAL;
									 	_textStyle.OTHER;
									 	_textStyle.NORMAL;
									 	}}
	---2 被别人抢夺后（对方失败）2
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.BRQDSB )  then
	 	richStr =  UIHelper.concatString({tbRichStr.nowCapture,
	 									  tbRichStr.content[1] or "",
	 									  m_i18nString(2167)})
					 	textInfo = {richStr,{
									 		_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
	---4 自己去占领别人的资源矿（成功）4
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZLBRKCG )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 									  tbRichStr.nowCapture,
	 									  tbRichStr.content[2] or "",
	 									  m_i18nString(2167)})
				 	textInfo = {richStr,{
										_textStyle.NORMAL;
										_textStyle.NAME;
										_textStyle.NORMAL;
										_textStyle.ZB;
										}}
		tbEvent.tag = tbRichStr.replay
	---5 自己去占领别人的资源矿（失败）5
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZLBRKSB )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										m_i18nString(2167)})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
	--7 --自己资源矿被强行夺走（失败）
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.QXBDZCG ) then
		richStr =  UIHelper.concatString({tbRichStr.nowCapture or "",
	 										tbRichStr.content[1] or "",
	 										m_i18nString(2167)
	 										})
					 	textInfo = {richStr,{
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay

	--8 --强行夺走别人资源矿（成功）-- todo  没replay
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.QXSBRSB ) then
		richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture or "",
	 										tbRichStr.content[2] or "",
	 										m_i18nString(2167)
	 										})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
	--9 强行夺走别人资源矿（失败)
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.QXDBRCG ) then
		richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture or "",
	 										tbRichStr.content[2] or "",
	 										m_i18nString(2167)
	 										})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
	--34 资源矿放弃 34
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZYKFQ )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[3] or ""})
					 	textInfo = {richStr,{
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	}}
	---36 主动放弃协助
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZDFQXZ )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[3] or "",
	 										})
					 	textInfo = {richStr,{
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	}}
 	---37 资源矿被占领
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZYKBZL )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[4] or "",
	 										})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											}}
		tbEvent.tag = tbRichStr.replay
	--38 资源矿被放弃
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZYKBFQ )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[4] or "",
	 										})
					 	textInfo = {richStr,{
										 	_textStyle.NORMAL;
										 	_textStyle.NAME;
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	_textStyle.OTHER;
										 	_textStyle.NORMAL;
										 	}}
 	---39 协助被抢夺
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.XZBQ )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[4] or "",
	 										m_i18nString(2167)})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
	---40 协助时间结束
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.XZSJD )  then
	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture or "",
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[4] or "",
	 										})
					 	textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											}}
	
    else
    	logger:debug("no mail")
    	logger:debug({tCellValue=tCellValue})
    end

 	local richText = BTRichText.create(textInfo, nil, nil)
 	richText:setSize(layContent:getSize())
 	richText:setAnchorPoint(ccp(0,0))
 	richText:setPosition(ccp(0,0))
 	layContent:addChild(richText, 10, m_TagRichText)

 	if(tbEvent.tag ~= 0 ) then
		tbEvent.handler = MineMailService.fnLookbatter
		BTRichText.addTouchEventHandler(tbEvent)
	end
end


function MineMailCell:refreshRevengeCell(tCellValue,tbRichStr)
	logger:debug({tCellValue=tCellValue})
	local tbEvent = {}
	tbEvent.tag = 0   --初始化为0
	local btnCell = self.mlaycell.LAY_CELL_BTNS
	btnCell:setEnabled(true)

	local BTN_1 = btnCell.BTN_1
    UIHelper.titleShadow(BTN_1,m_i18n[5659]) --todo
    --local btnTouchPriority = BTN_1:getTouchPriority()


	local popLayer = LayerManager.getCurrentPopLayer()
	local tp = popLayer:getTouchPriority()
    --logger:debug({btnTouchPriority=btnTouchPriority})

    local captureUid = nil
    local captureDomainType = nil

    local TFD_CLASS = btnCell.TFD_CLASS
	TFD_CLASS:setText(tCellValue.cellTitle)  --todo
	local layContent = nil
 	layContent = btnCell.LAY_RICH_TEXT
 	layContent:removeAllChildrenWithCleanup(true)

	local TFD_STATUS = btnCell.TFD_STATUS
	local strDay = MineMailData.getValidTime(tCellValue.recv_time)
	TFD_STATUS:setText(strDay)  --todo
	-- 3 被抢了资源矿
    if (tonumber(tCellValue.templateId) == _tempIdtb.BRQDCG)  then
	 	richStr =  UIHelper.concatString({tbRichStr.nowCapture,
	 										tbRichStr.content[1] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[3] or "",
	 										m_i18nString(2167)})
						textInfo = {richStr,{
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
		captureUid = tbRichStr.captureUid or 0
		captureDomainType = tbRichStr.domainType or 0
    end

    -- 6 自己资源矿被强行夺走（成功
    if (tonumber(tCellValue.templateId) == _tempIdtb.QXBDZSB)  then

	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										m_i18nString(2167)})
						textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
		captureUid = tbRichStr.captureUid or 0
		captureDomainType = tbRichStr.domainType or 0
    end
    -- 41 被抢了协助军
    if (tonumber(tCellValue.templateId) == _tempIdtb.XZBQTS)  then

	 	richStr =  UIHelper.concatString({tbRichStr.content[1] or "",
	 										tbRichStr.nowCapture,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[3] or "",
	 										m_i18nString(2167)})
						textInfo = {richStr,{
											_textStyle.NORMAL;
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
		captureUid = tbRichStr.captureUid or 0
		captureDomainType = tbRichStr.domainType or 0
    end
	--42 金币资源矿1小时保底银币奖励
    if (tonumber(tCellValue.templateId) == _tempIdtb.BDJL)  then   
	 	richStr =  UIHelper.concatString({tbRichStr.nowCapture,
	 										tbRichStr.content[1] or "",
	 										tbRichStr.gatherTime,
	 										tbRichStr.content[2] or "",
	 										tbRichStr.gatherSilver,
	 										tbRichStr.content[3] or "",
	 										m_i18nString(2167)}) 
						textInfo = {richStr,{
											_textStyle.NAME;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.OTHER;
											_textStyle.NORMAL;
											_textStyle.ZB;
											}}
		tbEvent.tag = tbRichStr.replay
		captureUid = tbRichStr.captureUid or 0
		captureDomainType = tbRichStr.domainType or 0
	end

 	local richText = BTRichText.create(textInfo, nil, nil,btnTouchPriority)
 	richText:setSize(layContent:getSize())
 	richText:setAnchorPoint(ccp(0,0))
 	richText:setPosition(ccp(0,0))
 	layContent:addChild(richText, 10, m_TagRichText)

	--反击按钮回调
	self:addMaskBtn(BTN_1, "BTN_1", function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("反击")
			MineMailCtrl.fnCounterAttack(captureUid,captureDomainType)
		end
	end)

	if(tbEvent.tag ~= 0 ) then
		tbEvent.handler = MineMailService.fnLookbatter
		BTRichText.addTouchEventHandler(tbEvent)
	end
	
end

-- 创建cell
function MineMailCell:refresh(tCellValue, idx)
	logger:debug({MineMailCell_tCellValue=tCellValue})
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件

	--富文本的按钮回调
	local tbRichStr = MineMailService.getCellShowAttr(tCellValue)
	logger:debug({tbRichStr=tbRichStr})
	
	if (self.mlaycell) then
		local noBtnCell = self.mlaycell.LAY_CELL_NOBTNS
		local btnCell = self.mlaycell.LAY_CELL_BTNS
		local moreBtnCell = self.mlaycell.LAY_MORE

		noBtnCell:setEnabled(false)
		btnCell:setEnabled(false)
		moreBtnCell:setEnabled(false)
        
        -- 更多邮件
		if (tCellValue.more) then
			self:refreshMoreBtnCell(tCellValue)
			return	

        -- 仇人信息cell 并且不是更多信息按钮
		elseif(tCellValue.mailType == 1 and not tCellValue.more) then    -- 仇人信息TAB

			self:refreshRevengeCell(tCellValue,tbRichStr)	

		-- 信息cell 并且不是更多信息按钮
		elseif(tCellValue.mailType == 2 and not tCellValue.more) then    -- 资源到期TAB
			self:refreshResorceExhaustCell(tCellValue,tbRichStr)
		
        -- 抢夺信息cell 并且不是更多信息按钮
		elseif(tCellValue.mailType == 3 and not tCellValue.more) then     -- 抢夺信息TAB
			self:refreshRobLogCell(tCellValue,tbRichStr)

		else
		 	btnCell:setEnabled(true)
			noBtnCell:setEnabled(false)
			moreBtnCell:setEnabled(false)
		end

	end 
end




