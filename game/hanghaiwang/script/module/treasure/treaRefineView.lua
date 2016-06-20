-- FileName: treaRefineView.lua
-- Author: menghao
-- Date: 2014-12-09
-- Purpose: 宝物精炼view


module("treaRefineView", package.seeall)


-- UI控件引用变量 --
local _UIMain


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local mi18n = gi18n

local m_maxLv
local m_tbCostInfo
local _lackItemTid
local m_tbEvents

local _treaRefineInfo = {}


local function init(...)

end


function destroy(...)
	package.loaded["treaRefineView"] = nil
end


function moduleName()
	return "treaRefineView"
end


function getMaxLv( ... )
	return m_maxLv
end


function getLackItemTid( ... )
	return _lackItemTid
end


function getCostInfo( ... )
	return m_tbCostInfo
end


function guangzhen( img, strName )
	local armature
	if (strName == "da") then
		armature = g_attribManager:createGuangZhen_Da({
			loop = -1,
		})
	elseif (strName == "xiao") then
		armature = g_attribManager:createGuangZhen_Xiao({
			loop = -1,
		})
	elseif (strName == "xiao_wu") then
		armature = g_attribManager:createGuangZhen_XiaoWu({
			loop = -1,
		})
	elseif (strName == "xiao_wu2") then
		armature = g_attribManager:createGuangZhen_XiaoWu2({
			loop = -1,
		})
	end

	img:removeAllNodes()
	img:addNode(armature)
	return armature
end

-- 播放成功动画
function showAnimation( call )
	AudioHelper.playEffect("audio/effect/texiao_baowu_qianghua.mp3")
	local imgArm = _UIMain.IMG_ARM

	local tbPos1 = {ccp(-40,-3), ccp(40,-3), ccp(-40,3), ccp(40,3)}
	local tbPos2 = {ccp(140,105), ccp(-140,105), ccp(170,-12), ccp(-170,-12)}

	m_armatureDa:getAnimation():pause()
	local imgTreaMain = _UIMain.IMG_MAGIC_TREASURE_MAIN
	-- 强化动画，第二个参数为第62帧的事件
	EffTreaForge:new():qianghua(imgTreaMain, function ( ... )
		local actionArr = CCArray:create()
		actionArr:addObject(
			CCSpawn:createWithTwoActions(
				CCScaleTo:create(16 / 60, 1.20),
				CCMoveBy:create(16 / 60, ccp(0, 50))
			)
		)
		actionArr:addObject(CCDelayTime:create(1))
		actionArr:addObject(CCCallFunc:create(function ( ... )
			imgArm:setScale(1)
			imgArm:setPositionY(imgArm:getPositionY() - 50)
		end))
		actionArr:addObject(CCCallFunc:create(function ( ... )
			m_armatureDa:getAnimation():resume()
			call()
		end))

		imgArm:stopAllActions()
		imgArm:runAction(CCSequence:create(actionArr))
	end)
	-- performWithDelay(imgTreaMain, function ( ... )
	-- 	for i=1,#m_tbImgArms do

	-- 		local actionArr = CCArray:create()
	-- 		actionArr:addObject(CCMoveBy:create(16 / 60, tbPos1[i]))
	-- 		actionArr:addObject(CCMoveBy:create(8 / 60, tbPos2[i]))
	-- 		actionArr:addObject(CCCallFunc:create(function ( ... )
	-- 			m_tbImgArms[i]:setEnabled(false)
	-- 		end))
	-- 		actionArr:addObject(CCMoveBy:create(8 / 60, ccp(-tbPos1[i].x - tbPos2[i].x, -tbPos1[i].y - tbPos2[i].y)))
	-- 		m_tbImgArms[i]:runAction(CCSequence:create(actionArr))
	-- 	end
	-- end, 1/6)
end

-- 属性的变化
function showAttrChangeAnimation()
	require "script/utils/LevelUpUtil"
	if (m_tbTreasureInfo.equip_hid and tonumber(m_tbTreasureInfo.equip_hid)>0) then
		local tBefore, tAfter = treaRefineCtrl.getTbForMaster()
		local showString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore, tAfter, 4)
		if (showString) then
			local armature = g_attribManager:createTreaRefineMasterEffect({
				level = tAfter[tonumber(4)],
				fnMovementCall = function ( sender, MovementEventType, frameEventName )
					if MovementEventType == 1 then
						sender:removeFromParentAndCleanup(true)
						local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(showString,nil,function ( ... )
							-- 战斗力提升动画、
							MainFormationTools.fnShowFightForceChangeAni()
						end)
						if (node) then
							runningScene:addChild(node, 99999)
						end
					end
				end,
			})
			armature:setPosition(ccp(g_winSize.width / 2, g_winSize.height / 2))
			_UIMain:addNode(armature)
		else
			-- 战斗力提升动画
			logger:debug("showAttrChangeAnimation")
			MainFormationTools.fnShowFightForceChangeAni()
		end
	end
end


-- 刷新属性面板
function initAttrlay(  )
	local beforeEvolveInfo = _treaRefineInfo.tbTreaEvolveBeforeInfo
	local affterEvolveInfo = _treaRefineInfo.tbTreaEvolveAffterInfo

	local treaEvolveLv = tonumber(_treaRefineInfo.va_item_text.treasureEvolve)
	local imgAttrArrow = _UIMain.img_arrow

	--精炼前的属性
	local imgAttrBeforeBg = _UIMain.img_attr1_bg
	for i=1,3 do
		-- 名字和精炼等级
		local tfdTreaName = imgAttrBeforeBg.TFD_TREASURE_NAME
		tfdTreaName:setColor(g_QulityColor2[_treaRefineInfo.itemDesc.quality])
		tfdTreaName:setText(_treaRefineInfo.itemDesc.name)
		UIHelper.labelNewStroke(tfdTreaName)

		local tfdJinglianLvNum = imgAttrBeforeBg.TFD_JINGLIANLV
		tfdJinglianLvNum:setColor(g_QulityColor2[_treaRefineInfo.itemDesc.quality])
		UIHelper.labelNewStroke(tfdJinglianLvNum)	
		local treaEvolveShowLv = treaEvolveLv 
		tfdJinglianLvNum:setText("+" .. treaEvolveShowLv )

		-- 属性
		local attr = beforeEvolveInfo[i]
		local tfdAttrName = imgAttrBeforeBg["TFD_ATTR" .. i]
		local tfdAttrNum = imgAttrBeforeBg["TFD_ATTR" .. i .. "_NUM"]

		if (attr) then
			tfdAttrName:setEnabled(true)
			tfdAttrName:setText(attr.name .. ":")
			tfdAttrNum:setEnabled(true)
			tfdAttrNum:setText("+" ..  attr.num)
		else
			tfdAttrName:setEnabled(false)
			tfdAttrNum:setEnabled(false)
		end
	end
	--精炼后的属性
	local imgAttrAffterBg = _UIMain.img_attr2_bg
	if(tonumber(_treaRefineInfo.va_item_text.treasureEvolve) >= tonumber(_treaRefineInfo.maxLv)) then
	-- if (not affterEvolveInfo) then
		imgAttrAffterBg:setEnabled(false)
		imgAttrArrow:setEnabled(false)
	else
		-- 名字和精炼等级
		local tfdTreaName = imgAttrAffterBg.TFD_TREASURE_NAME
		tfdTreaName:setColor(g_QulityColor2[_treaRefineInfo.itemDesc.quality])
		tfdTreaName:setText(_treaRefineInfo.itemDesc.name)
		UIHelper.labelNewStroke(tfdTreaName)

		local tfdJinglianLvNum = imgAttrAffterBg.TFD_JINGLIANLV
		tfdJinglianLvNum:setColor(g_QulityColor2[_treaRefineInfo.itemDesc.quality])
		UIHelper.labelNewStroke(tfdJinglianLvNum)	
		local treaEvolveShowLv = treaEvolveLv + 1 
		tfdJinglianLvNum:setText("+" .. treaEvolveShowLv )

		for i=1,3 do
			local attr = affterEvolveInfo[i]
			local tfdAttrName = imgAttrAffterBg["TFD_ATTR" .. i]
			local tfdAttrNum = imgAttrAffterBg["TFD_ATTR" .. i .. "_NUM"]
			local imagArrow = imgAttrAffterBg["IMG_ARROW" .. i]

			if (attr) then
				tfdAttrName:setEnabled(true)
				tfdAttrName:setText(attr.name .. ":")
				tfdAttrNum:setEnabled(true)
				tfdAttrNum:setText("+" .. attr.num)
				imagArrow:setEnabled(true)
			else
				tfdAttrName:setEnabled(false)
				tfdAttrNum:setEnabled(false)
				imagArrow:setEnabled(false)
			end
		end

	end

end

--- 刷新精炼材料面板
function refreshCostLay( CostInfo )
	_lackItemTid = nil
	if (CostInfo) then
		_treaRefineInfo.tbCostInfo = CostInfo
	end

	local tbCostInfo = _treaRefineInfo.tbCostInfo
	local treaEvolveLv = tonumber(_treaRefineInfo.va_item_text.treasureEvolve)
	local costlayBg = _UIMain.img_attr_bg

	for i=1,2 do
		local lay_item = costlayBg["lay_item" .. i]
		local tbData = tbCostInfo.items[i]
		logger:debug({refreshCostLay = tbData})
		if (not tbData) then
			lay_item:setEnabled(false)
		else
			lay_item:setEnabled(true)
			local imgCost = lay_item.LAY_ITEM_ICON1
			local tfdName = lay_item.TFD_ITEM_NAME
			local tfdHaveNum = lay_item.TFD_OWN_NUM
			local tfdNeedNum = lay_item.TFD_NEED_NUM

			local tfdSlant = lay_item.tfd_slant
			local itemInfo = ItemUtil.getItemById(tbData.tid)
			-- 掉落引导回调
			local function retrueFn( ... )
				local  tbCostInfo = treaRefineCtrl.reGetCostInfo()
				_treaRefineInfo.tbCostInfo = tbCostInfo
				refreshCostLay()
			end

			require "script/module/treasure/treaRefineCtrl"
			local btnlay = ItemUtil.createBtnByItem(itemInfo,function ( ... )
				if (tonumber(tbData.tid) == 60008) then
					PublicInfoCtrl.createItemDropInfoViewByTid(60008)  -- 宝物精华不足引导界面
				else
					PublicInfoCtrl.createItemDropInfoViewByTid(tbData.tid,retrueFn)  -- 宝物不足引导界面
				end
			end)
			local btnlaySize = btnlay:getSize()

			imgCost:removeAllChildren()
			imgCost:addChild(btnlay)
			btnlay:setPosition(ccp(btnlaySize.width * 0.5,btnlaySize.height * 0.5))

			tfdName:setText(itemInfo.name )
			tfdName:setColor(g_QulityColor[itemInfo.quality])
			tfdNeedNum:setText(tbData.num)
			tfdHaveNum:setText(tbData.numHave)

			if (tonumber(tbData.num) > tbData.numHave) then
				if (not _lackItemTid) then
					_lackItemTid = tbData.tid
				end
				tfdHaveNum:setColor(ccc3(0xd8, 0x14, 0x00))
			else
				tfdHaveNum:setColor(ccc3(0x00, 0x89, 0x00))
			end

		end
	end
	local tfdBellyNum = _UIMain.TFD_BELLY_SPEND
	if(tonumber(_treaRefineInfo.va_item_text.treasureEvolve) >= tonumber(_treaRefineInfo.maxLv)) then
		tfdBellyNum:setText(0)
	else
		tfdBellyNum:setText(tbCostInfo.silver or 0)
	end
end

-- 初始化宝物模型
function initTreaModel( ... )
	local imgTreaMain = _UIMain.IMG_MAGIC_TREASURE_MAIN
	local imgArm = imgTreaMain.IMG_ARM
	imgArm:loadTexture("images/base/treas/big/" .._treaRefineInfo.itemDesc.icon_big)
	imgArm:stopAllActions()
	EffTreaForge:new():bigTreaEff(imgArm)
	m_armatureDa = guangzhen(imgTreaMain, "da")
	EffTreaForge:new():lizi(imgArm)

end


-- 初始化背景
local function initBg( ... )
	_UIMain= g_fnLoadUI("ui/treasure_refine.json")
	local imgBG = _UIMain.IMG_BG
	imgBG:setScale(g_fScaleX)
	-- 返回
	local btnClose = _UIMain.BTN_CLOSE
	btnClose:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			-- if (sender:getTag() == 39) then
			-- 	AudioHelper.playCloseEffect()
			-- else
				AudioHelper.playBackEffect()
			-- end
			treaRefineCtrl.onBack()
		end
	end)
	UIHelper.titleShadow(btnClose, mi18n[1019])
	btnClose:setTag(39)
	-- 精炼按钮
	local btnRefine = _UIMain.BTN_JINGLIAN
	btnRefine:addTouchEventListener(function ( sender,eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			treaRefineCtrl.onRefine()
		end
	end)
	local tfdJinglian = _UIMain.TFD_JINGLIAN
	tfdJinglian:setText(mi18n[1724])
	UIHelper.labelShadow(tfdJinglian)
	-- 贝里按钮
	local tfdBellyNum = _UIMain.TFD_BELLY_SPEND
	tfdBellyNum:setColor(ccc3(0x57,0x1e,0x01))

	UIHelper.registExitAndEnterCall(_UIMain,
		function()
			-- 移除战斗力提升动画
			MainFormationTools.removeFlyText()
		end,
		function()
		end
	)

end 

-- 重新设置界面内容
function resetAllLayout(  )
	local treaRefineInfo = treaRefineCtrl.getTreaRefineInfo()
	logger:debug({resetAllLayout = treaRefineInfo})
	_treaRefineInfo = table.hcopy(treaRefineInfo,_treaRefineInfo)
	initAttrlay()
	refreshCostLay()
end


function create(tbTreaInfo, nSrcType, tbEvents)
	_lackItemTid = nil
	local treaRefineInfo = treaRefineCtrl.getTreaRefineInfo()
	logger:debug({treaRefineInfo = treaRefineInfo})
	_treaRefineInfo = table.hcopy(treaRefineInfo,_treaRefineInfo)
	initBg()
	initTreaModel()
	initAttrlay()
	refreshCostLay()

	return _UIMain
end

