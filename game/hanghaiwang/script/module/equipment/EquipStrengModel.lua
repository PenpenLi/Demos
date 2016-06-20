-- FileName: EquipStrengModel.lua
-- Author: HuXiaozhou
-- Date: 2014-05-05
-- Purpose: 装备强化相关数据，按钮事件以及特效动画
-- Modified:
--[[
	2015-06-09, zhangqi, UI修改，代码整理，重构返回后对上级UI的刷新
]]
--[[TODO List]]

module("EquipStrengModel", package.seeall)
require "script/module/public/EffectHelper"
require "script/module/public/AttribEffectManager"
local animationManager = g_attribManager
-- UI控件引用变量 --
local m_IMG_ARM          --武器图片
local m_TFD_NAME1        --武器名字

local m_TFD_LVL_NUM_1    -- 当前等级
local m_TFD_LVL_NUM_2    -- 下一等级

local m_TFD_ATTR_1       -- 属性1
local m_labAttr1_next	 -- 下一级属性1名称
local m_TFD_ATTR_NUM_1   -- 当前值
local m_TFD_ATTR_NUM_2   -- 强化后值

local m_TFD_ATTR_2       -- 属性 2
local m_labAttr2_next	 -- 下一级属性2称
local m_TFD_ATTR_NUM_3
local m_TFD_ATTR_NUM_4

local m_TFD_SPEND_NUM    -- 出售价钱

local m_BTN_BACK         -- 返回按钮
local m_BTN_STRENGTHEN   -- 强化按钮
local m_BTN_AUTO         -- 自动强化按钮


-- 模块局部变量 --
local jsonBgtrengthen  = "ui/equip_strengthen.json"

local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString
local widgetStreng

local tBefore = {}
local tAfter = {}

local m_item_info = nil
local m_equip_desc = nil
local m_fee_data   = nil

local m_tbAttrName	-- 属性名称
local m_tbAttrValue	-- 当前属性值
local m_tbAttrValNext	-- 强化到下一等级增加的属性值

local _isCanEnhance = true   -- 动画没播放完 就暂时不让继续强化
local bStrenged 	= false --保存是否强化过装备，在离开装备强化界面是来判断是否要刷新装备背包的数据

local tShowString   = nil -- 表示本次强化是否激活了大师

local m_type -- 2015-06-09, 记录入口的类型：1，阵容；2，装备背包                     
                                   
local ccs = g_equipStrengthFrom -- zhangqi, 2015-06-19           

local  m_fnbtncallback -- 外部回调                                

--绑定按钮的指定事件
local function fnBindBtnAndCallback(localBtn,localCallBack)
	localBtn:addTouchEventListener(function (sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			localCallBack(sender)
		end
	end)
end

-- 属性的变化
local function showAttrChangeAnimation( addLv ,fnCallBack)
	local t_text = {}
	for k, strName in pairs(m_tbAttrName) do
		local o_text = {}
		o_text.txt = strName
		o_text.num = addLv* m_tbAttrValNext[k]
		table.insert(t_text, o_text)
	end

	require "script/utils/LevelUpUtil"
	LevelUpUtil.showFlyText(t_text, fnCallBack)
end

-- 显示装备信息
local function showItemInfo( ... )

	if (m_item_info == nil) then
		return
	end


	-- 获取装备数据
	require "db/DB_Item_arm"
	m_equip_desc = DB_Item_arm.getDataById(m_item_info.item_template_id)

	-- 获取强化相关数值
	local fee_id = m_equip_desc.strengthenFeeID --"" .. m_equip_desc.quality .. m_equip_desc.type

	require "db/DB_Reinforce_fee"
	m_fee_data = DB_Reinforce_fee.getDataById(tonumber(fee_id))

	-- 获得属性相关数值
	local t_numerial, t_numerial_PL = ItemUtil.getTop2NumeralByIID(tonumber(m_item_info.item_id))

	m_tbAttrName = {}		-- 属性名称
	m_tbAttrValue  = {}		-- 当前数值
	m_tbAttrValNext  = {} 		-- 强化增加

	for key,v_num in pairs(t_numerial) do
		table.insert(m_tbAttrName, g_AttrNameWithoutSign[key])
		table.insert(m_tbAttrValue, v_num)
		table.insert(m_tbAttrValNext, t_numerial_PL[key])
	end

	m_TFD_ATTR_1:setText(m_tbAttrName[1])
	m_labAttr1_next:setText(m_tbAttrName[1])
	m_TFD_ATTR_NUM_1:setText("+" .. m_tbAttrValue[1])
	m_TFD_ATTR_NUM_2:setText("+" .. m_tbAttrValNext[1]+m_tbAttrValue[1])
	if #m_tbAttrName >= 2 then
		m_TFD_ATTR_2:setText(m_tbAttrName[2])
		m_labAttr2_next:setText(m_tbAttrName[2])
		m_TFD_ATTR_NUM_3:setText("+" .. m_tbAttrValue[2])
		m_TFD_ATTR_NUM_4:setText("+" .. m_tbAttrValNext[2]+m_tbAttrValue[2])
	else
		m_TFD_ATTR_2:setVisible(false)
		m_labAttr2_next:setEnabled(false)
		m_TFD_ATTR_NUM_3:setVisible(false)
		m_TFD_ATTR_NUM_4:setVisible(false)
	end

	local itemDesc = m_item_info.itemDesc
	
	-- zhangqi, 2014-10-11, 多加一次判断，解决下面描述的问题
	-- 原地重连会引起阵容中强化装备报错（原地重连后，一键装备，然后对该装备进行强化报错）
	if (not itemDesc) then
		require "db/DB_Item_arm"
		itemDesc = DB_Item_arm.getDataById(m_item_info.item_template_id)
	end

	local equipImg			= itemDesc.icon_big
	local equipQuality 		= itemDesc.quality

	m_IMG_ARM:loadTexture("images/base/equip/big/" .. equipImg)
	m_TFD_NAME1:setText(itemDesc.name)
	local color =  g_QulityColor2[tonumber(equipQuality)]
	if(color ~= nil) then
		m_TFD_NAME1:setColor(color)
	end
	UIHelper.labelNewStroke(m_TFD_NAME1, ccc3(0x24, 0x00, 0x00))

	local maxLevel = UserModel.getAvatarLevel()*m_equip_desc.level_limit_ratio
	local nextLevel = m_item_info.va_item_text.armReinforceLevel+1
	m_TFD_LVL_NUM_1:setText(m_item_info.va_item_text.armReinforceLevel .. "/" .. maxLevel)
	m_TFD_LVL_NUM_2:setText(nextLevel .. "/" .. maxLevel )

	m_TFD_SPEND_NUM:setText(tostring(m_fee_data["coin_lv" .. (m_item_info.va_item_text.armReinforceLevel+1)]))
	local tfd_info1 = m_fnGetWidget(widgetStreng, "tfd_info1")
	local tfd_info2 = m_fnGetWidget(widgetStreng, "tfd_info2")
	local tfd_info3 = m_fnGetWidget(widgetStreng, "tfd_info3")
	logger:debug("equipQuality = %s", equipQuality)
	if(equipQuality<=2) then
		tfd_info1:setVisible(false)
		tfd_info2:setVisible(false)
		tfd_info3:setVisible(true)
	elseif (equipQuality<=4) then
		tfd_info1:setVisible(false)
		tfd_info2:setVisible(true)
		tfd_info3:setVisible(false)
	else
		tfd_info1:setVisible(true)
		tfd_info2:setVisible(false)
		tfd_info3:setVisible(false)
	end

	for i = 5, m_equip_desc.quality + 1, -1 do
		local imgStar = m_fnGetWidget(widgetStreng, "img_star_" .. i)
		if (imgStar) then
			imgStar:setVisible(false)
		end
	end

end

-- 处理装备红点
local function pushRedTip( ... )
	-- 强化后推送红点背包，在伙伴身上穿的不用推送
	if (m_item_info.hid == nil) then
		logger:debug("装备强化红点推送")
		ItemUtil.pushitemCallback(m_item_info, 1)
	end
end

-- 装备强化回调
local function doCallbackReinforce( cbFlag, dictData, bRet  )
TimeUtil.timeStart("doCallbackReinforce")
	local ret = dictData.ret
	if not ret then
		_isCanEnhance = true
		return 
	end
	local level_num = ret.level_num
	local cost_num  = ret.cost_num
	local fatal_num = ret.fatal_num

	local cost_silver = m_fee_data["coin_lv" .. (m_item_info.va_item_text.armReinforceLevel+1)]


	bStrenged = true

	if m_item_info.hid~=nil then
		TimeUtil.timeStart("MainEquipMasterCtrltBefore")
		local HtBefore = HeroModel.getHeroByHid(m_item_info.hid)
		tBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtBefore)
		TimeUtil.timeEnd("MainEquipMasterCtrltBefore")
	end

	changeArmInfo(level_num, cost_num)

	-- 处理装备红点
	pushRedTip()

	if (m_item_info.hid ~= nil) then
		TimeUtil.timeStart("MainEquipMasterCtrltAfter")
		local HtAfter = HeroModel.getHeroByHid(m_item_info.hid)
		tAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtAfter)
		TimeUtil.timeEnd("MainEquipMasterCtrltAfter")
	end



	UserModel.addSilverNumber(-cost_silver)
	tShowString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore,tAfter,1)

	addStregAnimation(fatal_num,level_num)
	TimeUtil.timeEnd("doCallbackReinforce")
end


function addGuideView(step, bMask)
	require "script/module/guide/GuideModel"
    require "script/module/guide/GuideEquipView"
    local bMask = bMask or false
    if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == step and bMask ) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.removeGuideView()
        LayerManager.addLayoutNoScale(Layout:create())
    end 

    if (GuideModel.getGuideClass() == ksGuideSmithy and GuideEquipView.guideStep == step and not bMask) then
    	LayerManager.removeLayout()
    	logger:debug("GuideCtrl.createEquipGuide(%s,0)", step+1)  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createEquipGuide(step+1,0)
        _isCanEnhance = true
    end 

end

function stopAllActions(  )
	MainFormationTools.removeFlyText()
	widgetStreng.img_fazhen:removeAllNodes()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	runningScene:removeChildByTag(1111, true)
end

-- 添加 装备强化动画
function addStregAnimation( fatal_num, level_num, delegateFunc)
	stopAllActions()
	local count = 0
	local m_arAni2
	local  m_arAni1
	local function animationCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			count = count + 1
			logger:debug("动画没播放完啦～～～～～==" .. count)

			if armature==m_arAni1 then
				-- if not tShowString then
					_isCanEnhance = true
				-- end
			end
			armature:removeFromParentAndCleanup(true)
			if (delegateFunc~=nil and count>=3 and tonumber(fatal_num) == 0) then
				delegateFunc()
			elseif(delegateFunc~=nil and count>=4 and tonumber(fatal_num) > 0) then
				delegateFunc()
			end
		end
	end

	local function fnGetAniName( str )
		local qhAniPath = "images/effect/hero_qh"
    	return  string.format("%s/%s/%s.ExportJson",qhAniPath,str,str)
	end
	function fnQhDa( ... )
		local heChengDaAni = UIHelper.createArmatureNode({
            filePath = fnGetAniName("qh_hecheng_da"),
            loop = 0,
            fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
            	if frameEventName == "1" then
            		addAnimation3()
					addAnimation4()
            	end
        	end,
            fnMovementCall = function ( sender, MovementEventType, movementID )
                if(MovementEventType == 1) then
                    sender:removeFromParentAndCleanup(true)
                end
            end,
        })

		widgetStreng.img_fazhen:addNode(heChengDaAni,2)
		heChengDaAni:getAnimation():play("qh_hecheng_da_1", -1, -1, 0)
	end
	function shakeScreen(  )
		local runningScene = CCDirector:sharedDirector():getRunningScene()
		local arr = CCArray:create()
		arr:addObject(CCMoveBy:create(2/60, ccp(0, -14)))
		arr:addObject(CCMoveBy:create(2/60, ccp(0, 14)))
		arr:addObject(CCMoveBy:create(2/60, ccp(0, -14)))
		arr:addObject(CCMoveBy:create(4/60, ccp(0, 14)))
    	local seq = CCSequence:create(arr)
	    runningScene:runAction(seq)
	end
	-- 锤子动画
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	AudioHelper.playEffect("audio/effect/texiao02_chuizi.mp3")
	m_arAni1 = animationManager:createHammerEffect({
		fnMovementCall = animationCallBack,
		fnFrameCall = {
			function(  )
			fnQhDa()
			if m_item_info.hid~=nil then
					showAttrChangeAnimation(level_num,function (  )
					MainFormationTools.fnShowFightForceChangeAni()
					if tShowString then
						local guruAni = animationManager:createEquipStrMasterEffect({
								level = tAfter[tonumber(1)],
								fnMovementCall = function (armature,movementType,movementID)
									if movementType == 1 then
										armature:removeFromParentAndCleanup(true)
										-- 如果在伙伴身上则 需要增加判断 强化大师 增加的飘字效果
										local node = MainEquipMasterCtrl.fnGetMasterFlyInfo(tShowString, nil, function (  )
											 _isCanEnhance = true
										end)
										if node then
											local runningScene = CCDirector:sharedDirector():getRunningScene()
											runningScene:addChild(node, 99999)
										end
									end
								end
							})
								if widgetStreng.img_fazhen then
									widgetStreng.img_fazhen:addNode(guruAni,2)
								end
							end
						end)
					else
						showAttrChangeAnimation(level_num)
					end
				showItemInfo()
			end
		,function (  )
			shakeScreen()
		end}
	})
	widgetStreng.img_fazhen:addNode(m_arAni1,3)
	m_arAni1:setPositionY(100)

 	-- 锤子敲下去 火花
	function addAnimation2(  )
		AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
		m_arAni2 = animationManager:createSparkEffect({
			fnMovementCall = animationCallBack,
			fnFrameCall = function (  )
			end
		})

		widgetStreng.img_fazhen:addNode(m_arAni2,2)
		m_arAni2:setPositionY(100)
	end

    -- 强化成功
	function addAnimation3( )
	    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
		local arAni3 = animationManager:createStrenOKEffect({
			fnMovementCall = animationCallBack,
		})

		arAni3:setScale(g_fScaleX)
		arAni3:setPositionY(230)
		widgetStreng.img_fazhen:addNode(arAni3,2)
	end

   --  提升几级
	function addAnimation4(  )

		AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
		local arAni4 =  animationManager:createAddLevelEffect({
			fnMovementCall = animationCallBack,
			level = level_num
		})

		widgetStreng.img_fazhen:addNode(arAni4,3)
		arAni4:setPositionY(100)
	end

	-- 暴击
	function addAnimation5(  )
		AudioHelper.playEffect("audio/effect/texiao02_chuizi.mp3")
			local arAni5 =  animationManager:createCritEffect({
			fnMovementCall = animationCallBack,
			fnFrameCall = function ( ... )
				addAnimation4()
			end
		})

		widgetStreng.img_fazhen:addNode(arAni5,2)
		arAni5:setPositionY(100)
	end
end

-- 添加装备自动强化动画
function addAutoStrengthAnimation( autoData)

	if (type(autoData) ~= "table") then
		assert("应该是一个强化 table")
	end
	local function beginAutoAnimation( ... )
			
		local fatal_num = autoData.fatal_num
		local level_num = autoData.level_num
		local cost_silver = autoData.cost_num
		UserModel.addSilverNumber(-cost_silver)
		
		addStregAnimation(fatal_num,level_num, function (  )
			addGuideView(8)
			addGuideView(7)
			addGuideView(6)
		end)
	end
	beginAutoAnimation()
end

function changeArmInfo( level_num, cost_silver )
	logger:debug("hxz level_num = %s", level_num)
	if(m_item_info.hid~=nil)then
		-- 2014-12-18, zhangqi, m_item_info是缓存装备信息的副本，需要更新
		m_item_info.va_item_text.armReinforceLevel = m_item_info.va_item_text.armReinforceLevel+level_num

		HeroModel.setHeroEquipReinforceLevelBy(m_item_info.hid, m_item_info.item_id, m_item_info.va_item_text.armReinforceLevel)
		HeroModel.setHeroEquipReinforceLevelCostBy(m_item_info.hid, m_item_info.item_id, tonumber(cost_silver) )
		UserModel.setInfoChanged(true)
		UserModel.updateFightValue({[m_item_info.hid] = {HeroFightUtil.FORCEVALUEPART.ARM, HeroFightUtil.FORCEVALUEPART.MASTER},})
	else
		m_item_info.va_item_text.armReinforceLevel = m_item_info.va_item_text.armReinforceLevel+level_num

		DataCache.setArmReinforceLevelBy(m_item_info.item_id , m_item_info.va_item_text.armReinforceLevel)
		DataCache.changeArmReinforceCostBy(m_item_info.item_id, tonumber(cost_silver))
	end
	ItemUtil.setEquipEnchantLevel(m_item_info.item_id)

end

-- 自动强化回调
local function doCallbackAutoReinforce( cbFlag, dictData, bRet  )
	logger:debug(dictData)
	if( table.isEmpty(dictData.ret))then
		return
	end

	bStrenged = true

	local t_cost = 0
	local t_addLv = 0
	local fatal_num = 0

	for k, enhance_data in pairs(dictData.ret) do
		if tonumber(enhance_data.fatal_num) > 0 then
			fatal_num = fatal_num+1
		end
		t_cost = t_cost + tonumber(enhance_data.cost_num)
		t_addLv = t_addLv + tonumber(enhance_data.level_num)
	end
	local tbReinforce = {}
	tbReinforce.cost_num = t_cost
	tbReinforce.level_num = t_addLv
	tbReinforce.fatal_num = fatal_num

	if m_item_info.hid~=nil then
		local HtBefore = HeroModel.getHeroByHid(m_item_info.hid)
		tBefore = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtBefore)
	end

	-- 修改装备信息
	changeArmInfo(t_addLv, t_cost)

	-- 处理装备红点
	pushRedTip()

	if m_item_info.hid~=nil then
		local HtAfter = HeroModel.getHeroByHid(m_item_info.hid)
		tAfter = MainEquipMasterCtrl.fnGetMasterInfoByHeroInfo(HtAfter)
	end
	
	tShowString = MainEquipMasterCtrl.fnGetMasterChangeStringByHeroInfo(tBefore,tAfter,1)
	-- 添加自动强化动画
	addAutoStrengthAnimation(tbReinforce)

end

--[[
	desc:强化按钮事件  reinforce
	function forge_reinforce(fn_cb, params)
-—]]
local function onBtnStreng( sender , userData )
	if (not SwitchModel.getSwitchOpenState(ksSwitchWeaponForge,true)) then
		return
	end


	AudioHelper.playCommonEffect()
	if (m_item_info == nil) then
		return
	end
	local item_id = m_item_info.item_id
	local level = m_item_info.va_item_text.armReinforceLevel

	if tonumber(item_id) <= 0 then
		return
	end

	if tonumber(level) == 0 then
		level = 1
	end
	if( tonumber(m_item_info.va_item_text.armReinforceLevel) >= m_equip_desc.level_limit_ratio * UserModel.getHeroLevel())then
		ShowNotice.showShellInfo(m_i18n[1620])
		return
	elseif(m_fee_data["coin_lv" .. (m_item_info.va_item_text.armReinforceLevel+1)] > UserModel.getSilverNumber()) then
		PublicInfoCtrl.createItemDropInfoViewByTid(60406, nil, true) -- 贝里掉落界面
		ShowNotice.showShellInfo(m_i18n[1057])
		return
	end
	m_TFD_SPEND_NUM:setText(tostring(m_fee_data["coin_lv" .. (m_item_info.va_item_text.armReinforceLevel+1)]))

	logger:debug("log here _isCanEnhance = %s", _isCanEnhance)
	if (_isCanEnhance == false) then
		return
	end
	_isCanEnhance = false

	local params = CCArray:create()
	local item_id_integer = CCInteger:create(tonumber(item_id))
	local level_integer   = CCInteger:create(tonumber(1))
	params:insertObject(item_id_integer , 0)
	params:insertObject(level_integer , 1)

	RequestCenter.forge_reinforce( doCallbackReinforce , params)


end

--[[
	desc:自动强化按钮事件 autoReinforce 
	-- 装备自动强化
	function forge_autoReinforceArm(fn_cb, params)
-—]]
local function onBtnAuto( sender , userData)
	if (not SwitchModel.getSwitchOpenState(ksSwitchWeaponForge,true)) then
		return
	end
	AudioHelper.playCommonEffect()
	if (m_item_info == nil) then
		return
	end
	local item_id = m_item_info.item_id
	local level = m_item_info.va_item_text.armReinforceLevel

	if tonumber(item_id) <= 0 then
		return
	end

	if tonumber(level) == 0 then
		level = 1
	end
	if( tonumber(m_item_info.va_item_text.armReinforceLevel) >= m_equip_desc.level_limit_ratio * UserModel.getHeroLevel())then
		 ShowNotice.showShellInfo(m_i18n[1620])
		return
	elseif(m_fee_data["coin_lv" .. (m_item_info.va_item_text.armReinforceLevel+1)] > UserModel.getSilverNumber()) then
		 PublicInfoCtrl.createItemDropInfoViewByTid(60406, nil, true)  -- 贝里掉落界面
		 ShowNotice.showShellInfo(m_i18n[1617])
		return
	end
	if (_isCanEnhance == false) then
		return
	end
	_isCanEnhance = false
	local args = Network.argsHandler(item_id, 5)
	RequestCenter.forge_autoReinforceArm( doCallbackAutoReinforce , args)
	addGuideView(6, true)
	addGuideView(7, true)
	addGuideView(8, true)
end

-- 更新装备背包数据
local function updateEquipBag( ... ) 
	logger:debug({updateEquipBag_bStrenged = bStrenged})

	if (m_type == ccs.CreateType.createTypeFormation) then
		if (bStrenged) then
			require "script/module/formation/MainFormation"               
		    local pos = tonumber(m_item_info.pos) or 1                    
		    MainFormation.updateHeroEquipment(pos)                        
		    MainFormation.rememberQuality() --记录属性值, 需要修改属性值
		end
	else
		local delNum = nil
		if (m_type == ccs.CreateType.createTypeEquipList) then
			delNum = 1
		end

		logger:debug({updateEquipBag_delNum = delNum})

		if (bStrenged) then
			require "script/module/equipment/MainEquipmentCtrl"
	   		MainEquipmentCtrl.refreshArmAndArmFragList(delNum)
		end
	end

	bStrenged = false
end

-- 点击返回
local function onBack( )
	AudioHelper.playBackEffect()
	stopAllActions()
	addGuideView(9)
	-- yucong 从阵容进入，移除自己的信息条，通知强化大师界面重新添加信息条
	if (m_type == ccs.CreateType.createTypeFormation ) then
		PlayerPanel.removeCurrentPanel()
	end
	-- zhangqi, 2015-06-19, 强化大师会设置关闭的回调，恢复之前的处理
	if (m_fnbtncallback and type(m_fnbtncallback) == "function") then
		-- LayerManager.resetPaomadeng() -- zhangqi, 2015-06-26, 先恢复跑马灯的层级再关闭，否则会报错
		m_fnbtncallback()
		return
	end

	LayerManager.removeLayout() -- zhangqi, 2015-06-26, 强化大师回调里有关闭操作，如果不是强化大师打开装备强化需要调用关闭操作
end

local function onUnOpen( ... )
	local bOpen,needLvl = checkOpenForgeFive()
	ShowNotice.showShellInfo(m_i18nString(1204, needLvl))
end


--[[
    desc:绑定返回按钮，强化按钮和自动强化按钮的事件 
-—]]
local function addAllBtnEvent( ... )
	m_BTN_BACK = m_fnGetWidget(widgetStreng, "BTN_BACK" ,"Button")
	fnBindBtnAndCallback(m_BTN_BACK, onBack)

	m_BTN_STRENGTHEN = m_fnGetWidget(widgetStreng, "BTN_STRENGTHEN" ,"Button")
	fnBindBtnAndCallback(m_BTN_STRENGTHEN,onBtnStreng)

	m_BTN_AUTO = m_fnGetWidget(widgetStreng, "BTN_AUTO" ,"Button")

	local bOpen,needLvl = checkOpenForgeFive()
	if (bOpen) then
		fnBindBtnAndCallback(m_BTN_AUTO,onBtnAuto)
		m_BTN_AUTO:setGray(false)
	else
		fnBindBtnAndCallback(m_BTN_AUTO,onUnOpen)
		m_BTN_AUTO:setGray(true)
	end
	

	UIHelper.titleShadow(m_BTN_BACK, m_i18n[1019])
	UIHelper.titleShadow(m_BTN_AUTO,m_i18n[1064])

	UIHelper.labelShadowWithText(m_BTN_STRENGTHEN.TFD_STRENGTHEN, m_i18n[1007])
end

function checkOpenForgeFive(  )
	require "db/DB_Normal_config"
	local needLvl = tonumber(DB_Normal_config.getDataById(1).equip_str5_lv)
	local userLevel = tonumber(UserModel.getHeroLevel())
	if userLevel < needLvl then
		return false, needLvl
	end
	return true, needLvl
end

-- 获取所有需要的控件
local function getAllLableFormWidget( ... )

	local imgBg = m_fnGetWidget(widgetStreng, "img_bg")
	imgBg:setScale(g_fScaleX)

	m_IMG_ARM          =  m_fnGetWidget(widgetStreng, "IMG_ARM")    	--武器图片
	UIHelper.runFloatAction(m_IMG_ARM)
	m_TFD_NAME1        =  m_fnGetWidget(widgetStreng, "TFD_NAME1")    --武器名字

	m_TFD_LVL_NUM_1    =  m_fnGetWidget(widgetStreng, "TFD_LVL_NUM_1")    -- 当前等级
	m_TFD_LVL_NUM_2    =  m_fnGetWidget(widgetStreng, "TFD_LVL_NUM_2")    -- 下一等级

	m_TFD_ATTR_1       =  m_fnGetWidget(widgetStreng, "TFD_ATTR_1")    -- 属性1
	m_labAttr1_next = m_fnGetWidget(widgetStreng, "TFD_ATTR_1_AFTER")

	m_TFD_ATTR_NUM_1   =  m_fnGetWidget(widgetStreng, "TFD_ATTR_NUM_1")    -- 当前值
	m_TFD_ATTR_NUM_2   =  m_fnGetWidget(widgetStreng, "TFD_ATTR_NUM_2")    -- 强化后值

	m_TFD_ATTR_2       =  m_fnGetWidget(widgetStreng, "TFD_ATTR_2")     -- 属性 2
	m_labAttr2_next = m_fnGetWidget(widgetStreng, "TFD_ATTR_2_AFTER")
	m_TFD_ATTR_NUM_3   =  m_fnGetWidget(widgetStreng, "TFD_ATTR_NUM_3")
	m_TFD_ATTR_NUM_4   =  m_fnGetWidget(widgetStreng, "TFD_ATTR_NUM_4")

	m_TFD_SPEND_NUM    =  m_fnGetWidget(widgetStreng, "TFD_SPEND_NUM")    -- 出售价钱
end

local function init(...)
	bStrenged 	 = false 
	_isCanEnhance = true
	tShowString = nil
	m_item_info = nil
	m_equip_desc = nil
	m_fee_data   = nil	
	_realArmLevel 	= 0 		-- 真实的装备等级 自动强化用
	_realArmLevelCost 	= 0 	-- 真实的装备花费自动强化用
	widgetStreng = g_fnLoadUI(jsonBgtrengthen)
	UIHelper.registExitAndEnterCall(tolua.cast(widgetStreng, "CCNode"), function ( ... )
		GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, "EquipStrengModel")
		updateEquipBag()
			LayerManager.resetPaomadeng() -- yucong 2015-09-07 从强化大师界面进入后，点击主页，会报错

		if (m_type == ccs.CreateType.createTypeFormation ) then
			require "script/module/main/PlayerPanel"
			--PlayerPanel.removeCurrentPanel()
			-- LayerManager.resetPaomadeng() -- yucong 2015-09-07 从强化大师界面进入后，点击主页，会报错
		end
	end, function (  )
 		      LayerManager.setPaomadeng(widgetStreng, 10) -- zhangqi, 2015-06-26, 显示跑马灯
		      GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
             _isCanEnhance = true
        end,false,"EquipStrengModel")
	end)
	-- yucong 从阵容进入，首先移除强化大师上面的信息条，因为位置有偏移
	if (m_type == ccs.CreateType.createTypeFormation ) then
		PlayerPanel.removeCurrentPanel()
	end
end

function destroy(...)
	package.loaded["EquipStrengModel"] = nil
end

function moduleName()
	return "EquipStrengModel"
end

function create( itemInfo, fnbtncallback, nType )
	m_fnbtncallback = fnbtncallback
	m_type = nType

	init()
	-- 2014-12-18, zhangqi, 将 m_item_info 改为缓存装备信息的副本，避免缓存装备信息出现多次更新的问题
	m_item_info = {}
	table.hcopy(itemInfo, m_item_info)
	
	addAllBtnEvent()
	getAllLableFormWidget()
	showItemInfo()
	GuideModel.setGuideClass(ksGuideSmithy)
	addGuideView(5)
	return widgetStreng
end


