-- FileName: NewUpgradeView.lua
-- Author: Xufei
-- Date: 2015-07-22
-- Purpose: 升级模块改版 视图模块
--[[TODO List]]

--module("NewUpgradeView", package.seeall)
NewUpgradeView = class("NewUpgradeView")
require "script/module/upgrade/NewUpgrageModel"
-- UI控件引用变量 --
local _layMain = nil
local _listView = nil
-- 模块局部变量 --
local _i18n = gi18n
local _tbUserUpData = nil
local _tbGuideData = nil

local _tbCellEffect = {{efNowOpen=0,efLight=0},{efNowOpen=0,efLight=0},{efNowOpen=0,efLight=0}}

function NewUpgradeView:destroy(...)
	package.loaded["NewUpgradeView"] = nil
end

function NewUpgradeView:moduleName()
    return "NewUpgradeView"
end

--设置整个面板的UI效果和国际化
function NewUpgradeView:setUIStyleAndI18n(layout)
	layout.tfd_level_info:setText(_i18n[1067])					-- 等级
	layout.tfd_power_info:setText(_i18n[1304])					-- 体力
	layout.tfd_stamina_info:setText(_i18n[1359])				-- 耐力
	
	UIHelper.titleShadow(layout.BTN_GO, _i18n[4388])			
	UIHelper.titleShadow(layout.BTN_CONFIRM, _i18n[1029])		-- 确定

	layout.IMG_ALREADY_OPEN:setVisible(false)					
	layout.IMG_OPEN_LV:setVisible(false)
	layout.TFD_OPEN_LV:setVisible(false)
	layout.BTN_GO:setEnabled(false)
end


--[[desc: 显示本次升级刚好开启了这个功能，则播放一个开启的特效
    arg1: 本引导功能开启的等级
    return: 无 
—]]
function NewUpgradeView:addNowOpenEffect(cell, needLevel, cellIndex)
	if (tonumber(_tbUserUpData.newLv) == needLevel) then
		_tbCellEffect[cellIndex+1].efNowOpen = 1
		cell.IMG_ALREADY_OPEN:setVisible(false)	
	else
		_tbCellEffect[cellIndex+1].efNowOpen = 0
		cell.IMG_NOW_OPEN_EFFECT:setVisible(false)
	end
end

--[[desc: 根据参数显示或不显示发光特效
    arg1: 0不显示，1显示
    return: 无 
—]]
function NewUpgradeView:addLightEffect(cell, needShow, cellIndex)
	if (needShow == 1) then
		_tbCellEffect[cellIndex+1].efLight = 1
	else
		_tbCellEffect[cellIndex+1].efLight = 0
	end
	cell.IMG_EFFECT:setVisible(false)  ---TODO 把这个图片删掉
end

--初始化引导列表
function NewUpgradeView:createGuideList()
	local cell
	UIHelper.initListView(_listView)
	_listView:removeAllItems()
	for k,v in ipairs(_tbGuideData) do
		_listView:pushBackDefaultItem()
		cell = _listView:getItem(k-1)	--cell 索引从 0 开始

		UIHelper.labelAddNewStroke(cell.TFD_NAME, v.name, ccc3(146, 83, 27))
		cell.TFD_DESC:setText(v.desc)
		cell.img_icon:loadTexture(NewUpgrageModel.getImagePath(v.icon))
		if (tonumber(_tbUserUpData.newLv) < v.lv) then
			cell.IMG_OPEN_LV:setVisible(true)
			cell.TFD_OPEN_LV:setVisible(true)
			cell.TFD_OPEN_LV:setText(string.format(_i18n[1204], v.lv))
		elseif (v.jump == 0) then
			cell.IMG_ALREADY_OPEN:setVisible(false)
			--	cell.IMG_ALREADY_OPEN:setVisible(true)
		else
			cell.BTN_GO:setEnabled(true)
			cell.BTN_GO:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_BEGAN) then
					UIHelper.buttonCircle(sender)
				elseif (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
					UIHelper.buttonCircle(sender)
					NewUpgradeCtrl.onGotoOtherModule(v.jump)
				end
			end)
		end
		self:addNowOpenEffect(cell, v.lv, k-1)
		self:addLightEffect(cell, v.effect, k-1)
	end
end

--初始化等级体力耐力信息显示
function NewUpgradeView:initView()
	self:setUIStyleAndI18n(_layMain)
	_listView = _layMain.LSV_MAIN
	_layMain.TFD_LV:setText(_tbUserUpData.oldLv)
	_layMain.TFD_LV2:setText(_tbUserUpData.newLv)
	_layMain.TFD_POWER:setText(_tbUserUpData.oldExecu)
	_layMain.TFD_POWER2:setText(_tbUserUpData.newExecu)
	_layMain.TFD_STAMINA:setText(_tbUserUpData.oldStami)
	_layMain.TFD_STAMINA2:setText(_tbUserUpData.newStami)
	_layMain.TFD_LV2:setVisible(false)
	_layMain.TFD_POWER2:setVisible(false)
	_layMain.TFD_STAMINA2:setVisible(false)
	--探索节点开启了才会显示耐力
	_layMain.LAY_STAMINA:setVisible(_tbUserUpData.openExplore)
	_layMain.BTN_CONFIRM:addTouchEventListener(NewUpgradeCtrl.onClickConfirm)
	self:createGuideList()
end

function NewUpgradeView:ctor()
	_layMain = g_fnLoadUI("ui/new_upgrade.json") 
end

function NewUpgradeView:create()
	UIHelper.registExitAndEnterCall(_layMain,
		function()
			_layMain=nil
		end,
		function()
		end
	) 
	_tbUserUpData = NewUpgrageModel.getValueData()
	_tbGuideData = NewUpgrageModel.getGuideData()
	self:initView()
	self:showAnimation(_layMain)
end

---------------------------  animation  ------------------------------
function NewUpgradeView:showAnimation( layPop )
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY
	local imgBg = layPop.img_bg

	local imgLevelArrow = layPop.img_arrow1
	local imgPowerArrow = layPop.img_arrow2
	local imgStaminaArrow = layPop.img_arrow3

	local labNewLv = _layMain.TFD_LV2
	local labNewPower = _layMain.TFD_POWER2
	local labNewStamina = _layMain.TFD_STAMINA2

	local layout = Layout:create()
	LayerManager.addLayoutNoScale(layout)

	local function fnCreateAnimation( pName , pLoop , movementCallback, frameCallback )
		local animation = UIHelper.createArmatureNode({
			imagePath = "images/effect/"..pName.."/"..pName.."0.png",
			plistPath = "images/effect/"..pName.."/"..pName.."0.plist",
			filePath = "images/effect/"..pName.."/"..pName..".ExportJson",
			animationName = pName,
			loop = pLoop or -1,
			fnMovementCall = movementCallback or nil,
			fnFrameCall = frameCallback or nil
		})
		return animation
	end

	-- 显示light特效
	local function playLight( index )
		local cell = _listView:getItem(index-1)
		local aniLight = fnCreateAnimation("level_up_light")
		cell.img_cell_bg:addNode(aniLight)
	end

	-- 显示now特效
	local function playNowOpen( index )
		if (_tbCellEffect[index].efLight == 1) then
			local cell = _listView:getItem(index-1)
			local tbParams = {
				filePath = "images/effect/level_up_open/level_up_open.ExportJson",
				animationName = "level_up_open",
				fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					if (frameEventName == "2") then
						local aniLight = fnCreateAnimation("level_up_light")
						cell.img_cell_bg:addNode(aniLight)
					end
				end,
			}
			local aniNowOpen = UIHelper.createArmatureNode(tbParams)		
			cell.IMG_NOW_OPEN_EFFECT:addNode(aniNowOpen)
		elseif (_tbCellEffect[index].efLight == 0) then
			local cell = _listView:getItem(index-1)
			local aniNowOpen = fnCreateAnimation("level_up_open")
			cell.IMG_NOW_OPEN_EFFECT:addNode(aniNowOpen)
		end
	end

	-- 为cell添加特效
	local function addAnimationToCell( sender, MovementEventType , frameEventName )
		if ( MovementEventType == EVT_COMPLETE ) then
			for k,v in pairs(_tbCellEffect) do
				if (v.efNowOpen == 1) then
					playNowOpen(k)
				elseif (v.efNowOpen == 0) then
					if (v.efLight == 1) then
						playLight(k)
					end
				end
			end
		end
	end

	local function playNumAnimation( bone, frameEventName, originFrameIndex, currentFrameIndex )
		if ( frameEventName == "1" ) then
			AudioHelper.playEffect("audio/effect/texiao_jinjie_shuzi.mp3")
			local tbArrows = {}
			local tbLabNums = {}
			if (_tbUserUpData.openExplore) then
				tbArrows = {imgLevelArrow, imgPowerArrow, imgStaminaArrow}
				tbLabNums = {labNewLv, labNewPower, labNewStamina}
			else
				tbArrows = {imgLevelArrow, imgPowerArrow}
				tbLabNums = {labNewLv, labNewPower}
			end
			for i=1,#tbArrows do 
				local arrow = tbArrows[i]
				if(arrow) then
					local ccArray = CCArray:create()
					if (i ~= 1) then
						ccArray:addObject(CCDelayTime:create(5/60*(i-1)))
					end

					if (i ~= #tbArrows) then
						ccArray:addObject(CCCallFuncN:create(function()
							arrow:addNode(fnCreateAnimation("jinjie_zhizhen"))
							if(tbLabNums[i]) then
								tbLabNums[i]:setVisible(true)
								local aniNumber = fnCreateAnimation("jinjie_shuzi")
								aniNumber:setPositionX(-tbLabNums[i]:getContentSize().width*0.5)
								tbLabNums[i]:addNode(aniNumber)
							end
						end))
					end
					if(i == #tbArrows) then
						ccArray:addObject(CCCallFuncN:create(function()
							arrow:addNode(fnCreateAnimation("jinjie_zhizhen", 0, addAnimationToCell))
							if(tbLabNums[i]) then
								tbLabNums[i]:setVisible(true)
								local aniNumber = fnCreateAnimation("jinjie_shuzi", 0)
								aniNumber:setPositionX(-tbLabNums[i]:getContentSize().width*0.5)
								tbLabNums[i]:addNode(aniNumber)
							end
						end))
						--ccArray:addObject(CCDelayTime:create(5/60))
					end
					arrow:runAction(CCSequence:create(ccArray))
				end
			end
		end
	end

	local function playTittle( ... )
		local animationTittle = fnCreateAnimation("level_up_title", 0, nil, playNumAnimation)
		layPop.img_title:addNode(animationTittle)
		AudioHelper.playSpecialEffect("texiao_shengji03.mp3")
	end

	local function playRainBow( ... )
		local tbParams = {
			filePath = "images/effect/worldboss/new_rainbow.ExportJson",
			animationName = "new_rainbow",
		}
		local animationRainBow = UIHelper.createArmatureNode(tbParams)
		animationRainBow:setScale(fScale)
		layPop.img_rainbow:addNode(animationRainBow)	
	end

	local function showWindow( ... )
		playRainBow()

		LayerManager.lockOpacity()
		LayerManager.addLayoutNoScale(layPop)

		local acitonArray = CCArray:create()
		acitonArray:addObject(CCDelayTime:create(1 / 60))
		acitonArray:addObject(CCScaleTo:create(6 / 60, 0.72))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 1.2))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 0.95))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 1))
		imgBg:runAction(CCSequence:create(acitonArray))

		performWithDelay(imgBg, playTittle, 20/60)
	end

	showWindow()

	--todo: add mp3
end

-- （老特效代码）
-- 动画效果和MainUpgradeCtrl.lua中老代码相同
-- menghao 1031 升级动画，不要写三遍
--[[

sj 开始播放到 第14帧时 弹窗开始弹出

弹窗的帧数：

第1帧    比例 0     透明度 0%

第6帧    比例 72    透明度 100%

第10帧   比例 120   透明度 100%

第14帧   比例 95    透明度 100%

第18帧   比例 100   透明度 100%


当弹窗播放到12帧时，开始播放sj2 ； 
而当 弹窗播放到第18帧后，停留15
帧时间，再播放sj1，播放完后
再播放提升动画
然后在播放sj1里的sj1_1子文件。


function NewUpgradeView:showAnimation( layPop )
	local fScale = g_fScaleX > g_fScaleY and g_fScaleX or g_fScaleY

	layPop:retain()
	local imgTitleBG = g_fnGetWidgetByName(layPop, "img_titlebg")
	local imgBG = g_fnGetWidgetByName(layPop, "img_bg")
	local imgTitle = g_fnGetWidgetByName(layPop, "img_title")
	local x, y = imgTitle:getPosition()
	-- imgTitle:setVisible(false)

	local layout = Layout:create()
	LayerManager.addLayoutNoScale(layout)

	local function playSj1( ... )
		local tbParams = {
			filePath = "images/effect/shengji/sj1.ExportJson",
			animationName = "sj1",
			fnMovementCall = function ( sender, MovementEventType , frameEventName)
				if (MovementEventType == 1) then
					local tbParams = {
						filePath = "images/effect/shengji/sj1.ExportJson",
						animationName = "sj1_1",
					}
					local arSj = UIHelper.createArmatureNode(tbParams)
					arSj:setPosition(ccp(x, y))
					imgTitleBG:addNode(arSj)
				end
			end,
		}
		local arSj = UIHelper.createArmatureNode(tbParams)
		arSj:setPosition(ccp(x, y))
		imgTitleBG:addNode(arSj)
		AudioHelper.playSpecialEffect("texiao_shengji03.mp3")
	end

	local function playSj2( ... )
		local tbParams = {
			filePath = "images/effect/shengji/sj2.ExportJson",
			animationName = "sj2",
		}
		local arSj = UIHelper.createArmatureNode(tbParams)
		arSj:setScale(fScale)
		arSj:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
		layPop:addNode(arSj)
	end

	local function showWindow( ... )
		logger:debug("showWindow")
		LayerManager.lockOpacity()
		LayerManager.addLayoutNoScale(layPop)
		layPop:setVisible(false)
		layPop:release()

		UIHelper.widgetFadeTo(imgBG, 1 / 60, 0, function ( ... )
			layPop:setVisible(true)
			UIHelper.widgetFadeTo(imgBG, 6 / 60, 255, function ( ... )
				end)
		end)

		local acitonArray = CCArray:create()
		acitonArray:addObject(CCDelayTime:create(1 / 60))
		acitonArray:addObject(CCScaleTo:create(6 / 60, 0.72))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 1.2))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 0.95))
		acitonArray:addObject(CCScaleTo:create(4 / 60, 1))
		imgBG:runAction(CCSequence:create(acitonArray))

		performWithDelay(imgBG, playSj2, 13 / 60)
		performWithDelay(imgBG, playSj1, 34 / 60)
	end

	local function playSj( ... )
		local tbParams = {
			filePath = "images/effect/shengji/sj.ExportJson",
			animationName = "sj",
			fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
				if (frameEventName == "1") then
					showWindow()
				end
			end
		}
		local arSj = UIHelper.createArmatureNode(tbParams)
		arSj:setScale(fScale)
		arSj:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
		layout:addNode(arSj)
		AudioHelper.playSpecialEffect("texiao_shengji.mp3")
	end

	playSj()
end

--]]