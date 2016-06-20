-- FileName: CannonBallInfo.lua
-- Author: sunyunpeng
-- Date: 2016-02-04
-- Purpose: 炮弹的信息界面
--[[TODO List]]

CannonBallInfo = class("CannonBallInfo")

-- UI控件引用变量 --

-- 模块局部变量 --

function CannonBallInfo:destroy(...)
	package.loaded["CannonBallInfo"] = nil
end

function CannonBallInfo:moduleName()
    return "CannonBallInfo"
end

-- UIlable自适应高度
-- return tfdBeforeSizeWidth 之前的宽度 tfdBeforeSizeHeight 高度 affterSizeHeight变化后的高度
function CannonBallInfo:labelScaleChangedWithStr( UIlableWidet,textInfo )
    local tfdBeforeSize = UIlableWidet:getContentSize()
    local tfdBeforeSizeHeight = tfdBeforeSize.height  -- 必须把高度值单独取出来放进变量里 否则值会变
    local tfdBeforeSizeWidth = tfdBeforeSize.width  -- 必须把高度值单独取出来放进变量里 否则值会变

    -- UIlableWidet:ignoreContentAdaptWithSize(false)
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSize.width,0))
    UIlableWidet:setText(textInfo)
    local tfdAffterSize =  UIlableWidet:getVirtualRenderer():getContentSize()
    local lineHeightScale = math.ceil(tfdAffterSize.height/tfdBeforeSizeHeight)
    local affterSizeHeight = lineHeightScale * tfdBeforeSizeHeight
    UIlableWidet:setSize(CCSizeMake(tfdBeforeSizeWidth,affterSizeHeight))
    return tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight

end


-- 更换
function CannonBallInfo:changeCannonBall(  )
     LayerManager.removeLayout()

	cannonIndex = self.cannonIndex
	cannonId = self.cannonId
	-- ArmShipCtrl.changeCannonBall( cannonIndex ,cannonId)
	GlobalNotify.postNotify("changeBallOberver",cannonIndex,cannonId,1)

end

-- 卸下
function CannonBallInfo:reLoadCannonBall(  )
	cannonIndex = self.cannonIndex
	cannonId = self.cannonId

	-- ArmShipCtrl.relaondCannonBall( cannonIndex ,cannonId)
	GlobalNotify.postNotify("changeBallOberver",cannonIndex,cannonId,2)
end


function CannonBallInfo:ctor( ... )

	self.UIMain = g_fnLoadUI("ui/ship_skill_info.json")
	local UIMain = self.UIMain
	local btnClose = UIMain.BTN_CLOSE 
	btnClose:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
        	LayerManager.removeLayout()
		end
	end)

	UIHelper.registExitAndEnterCall(UIMain, function (  )
	end, function (  )
	end)

end

-- 初始参数
function CannonBallInfo:defaultAllPara( ... )
	self.cannonBallTid = nil
	self.cannonBallDB = nil
	self.cannonLel = 0

	-- body
end

-- 计算炮弹信息
function CannonBallInfo:initBallInfo( ... )
	local cannonballTid = self.cannonBallTid
	local cannonLel = self.cannonLel 

	self.cannonBallDB = DB_Ship_skill.getDataById(cannonballTid)
	local cannonAttr = ArmShipData.getCannonBallAttrByLel(cannonballTid,cannonLel)

	self.cannonAttr = cannonAttr
	logger:debug({initBallInfo = cannonAttr})

end

-- 刷新UI
function CannonBallInfo:refreshLayerUI( ... )
	local mi18n = gi18n
	local mi18nString = gi18nString
	local cannonLel = self.cannonLel 
	-- 炮弹图片
	local UIMain = self.UIMain
	local laySkillIcon = UIMain.LAY_SKILL_ICON


	local btnlay = ArmShipData.createCannonAndBallBtnByTid(self.cannonBallTid,btnLayShow,1)
	laySkillIcon:removeAllChildren()
	local laySkillIconSize = laySkillIcon:getContentSize()
	btnlay:setPosition(ccp(laySkillIconSize.width * 0.5,laySkillIconSize.height * 0.5))
	laySkillIcon:addChild(btnlay)

	-- 炮弹名字
	local tfdName = UIMain.TFD_NAME
	tfdName:setText(self.cannonBallDB.skill_name)
	tfdName:setColor(g_QulityColor[self.cannonBallDB.quality])
	
	-- 炮弹描述
	local tfdSkillDesc = UIMain.TFD_SKILL_DESC
	tfdSkillDesc:setText(self.cannonBallDB.base_desc)
	-- 炮弹属性
	local imgInfoBg = UIMain.img_info_bg

	local cannonAttr = self.cannonAttr 
	local attr = cannonAttr.attr or {}
	local attrStr = ""

	for i= 1,4 do
		local tfdAttr = imgInfoBg["TFD_ATTR" .. i]
		if (tfdAttr) then
			tfdAttr:setEnabled(true)
		end
	end


	for i,v in ipairs(attr) do
		local tfdAttr = imgInfoBg["TFD_ATTR" .. i]
		if (tfdAttr) then
			local attrStr =  v.name .. ":" .. v.beforValue 
			tfdAttr:setText(attrStr)
		end
	end

	for i=#attr + 1,4 do
		local tfdAttr = imgInfoBg["TFD_ATTR" .. i]
		if (tfdAttr) then
			tfdAttr:setEnabled(false)
		end
	end

	-- 当前
	local layNow = imgInfoBg.LAY_NOW
	local layNowSize = layNow:getContentSize()
	local layNowSizeHeight = layNowSize.height
	local tfdNow = layNow.TFD_NOW -- 当前效果
	tfdNow:setText(mi18n[7507]) --todo
	local tfdNowAttr = layNow.TFD_NOW_ATTR

	local nowAttr = ""
	local periodAttr = cannonAttr.periodAttr 

	logger:debug({refreshLayerUI_periodAttr = periodAttr})

	local beforAttr = periodAttr.beforAttr
	local beforeAddH = 0
	if (beforAttr) then
		layNow:setEnabled(true)
		nowAttr =  beforAttr.attrText
		local  tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr(tfdNowAttr,nowAttr)
		beforeAddH = beforeAddH + affterSizeHeight - tfdBeforeSizeHeight
	else 
		layNow:setEnabled(false)
	end
	logger:debug({refreshLayerUI = beforeAddH})
	
	layNow:setSize(CCSizeMake(layNowSize.width,layNowSizeHeight + beforeAddH))
	-- 下一个
	local layNext = imgInfoBg.LAY_NEXT
	local tfdNext = layNext.TFD_NOW -- 下一级效果
	local tfdNextAttr = layNext.TFD_NOW_ATTR

	local nextAttr = ""
	local aftterAttr = periodAttr.aftterAttr
	local affterAddH = 0
	if (aftterAttr) then
		layNext:setEnabled(true)
		nextAttr =  aftterAttr.attrText
		local nextClassLel = (math.floor(cannonLel / 5) + 1) * 5
		tfdNext:setText(mi18nString(7508,nextClassLel))
		local  tfdBeforeSizeWidth,tfdBeforeSizeHeight,affterSizeHeight = self:labelScaleChangedWithStr(tfdNextAttr,nextAttr)
		affterAddH = affterAddH + affterSizeHeight - tfdBeforeSizeHeight
	else
		layNext:setEnabled(false)
	end

	-- 卸下
	local btnUnload = UIMain.BTN_UNLOAD
	UIHelper.titleShadow(btnUnload,mi18n[1710])  -- 卸下
	btnUnload:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playReLoadBall()
			self:reLoadCannonBall()
		end
	end)

	-- 更换
	local btnChange = UIMain.BTN_CHANGE
	UIHelper.titleShadow(btnChange,mi18n[7509])
	btnChange:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			self:changeCannonBall()
		end
	end)

end


function CannonBallInfo:create( cannonId,cannonBallTid,cannonLel,cannonIndex)

	cannonBallTid = cannonBallTid or 10001
	cannonLel = cannonLel or 60

	self.cannonId = cannonId
	self.cannonBallTid = cannonBallTid
	self.cannonLel =  cannonLel
	self.cannonIndex = cannonIndex

	logger:debug({CannonBallInfo = cannonId})
	logger:debug({CannonBallInfo = cannonBallTid})
	logger:debug({CannonBallInfo = cannonLel})


	self:initBallInfo()
	self:refreshLayerUI()
    LayerManager.addLayout(self.UIMain)
end
