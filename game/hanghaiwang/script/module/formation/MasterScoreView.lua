-- FileName: MasterScoreView.lua
-- Author: yucong
-- Date: 2015-05-12
-- Purpose: 品级大师 子视图层
--[[TODO List]]

module("MasterScoreView", package.seeall)

----------------- 局部 -------------------
local _mainLayer	-- 主层
local _heroInfo		-- 伙伴信息
local _curPage = 5 	-- 页面index
local kARM_NUM = 4
local kTREASURE_NUM = 3
----------------- 局部 -------------------

----------------- 控件 -------------------
-- 左边的控件集
local _left_widgets = {
	-- 装备控件
	LAB_No_Equip = {1, 2, 3, 4},		--该伙伴没有xxx 描述
	LAB_EquipName = {1, 2, 3, 4},		--装备名
	LAB_EquipScore = {1, 2, 3, 4},		--品级描述
	IMG_EquipScore = {1, 2, 3, 4},
	IMG_EquipIcon = {1, 2, 3, 4},
	BTN_Equip = {1, 2, 3, 4},
	
	-- 宝物控件
	LAB_No_Treasure = {1, 2, 3, 4},		--该伙伴没有xxx 描述
	LAB_TreasureName = {1, 2, 3, 4},	--宝物名
	LAB_TreasureScore = {1, 2, 3, 4},	--品级描述
	IMG_TreasureScore = {1, 2, 3, 4},
	IMG_TreasureIcon = {1, 2, 3, 4},
	BTN_Treasure = {1, 2, 3, 4},
}
-- 宝物的层控件
local _treasureLayer = {
	TreasureLayer_1 = nil,
	TreasureLayer_2 = nil,
	TreasureLayer_3 = nil,
	TreasureLayer_4 = nil,
}
----------------- 控件 -------------------

------------------ 数据 -------------------
local _masterdata = {
	score_total = 0,		-- 品级总和
	score_lv = 0,			-- 品级大师等级
	score_attr_info = {},	-- 当前属性
	score_attr_afinfo = {},	-- 下一级属性
}
------------------ 数据 -------------------


local m_fnGetWidget =  g_fnGetWidgetByName 
local m_i18n = gi18n

-- 处理大师数据
local function handleDatas( ... )
	_masterdata.score_total = MainEquipMasterCtrl.fnGetNumByType(_curPage, _heroInfo) or 0
    _masterdata.score_lv = MainEquipMasterCtrl.fnGetAttrLv(_curPage, _masterdata.score_total) or 0
    _masterdata.score_attr_info = MainEquipMasterCtrl.fnGetAttrInfo(_curPage, _masterdata.score_lv)
    _masterdata.score_attr_afinfo = MainEquipMasterCtrl.fnGetAttrInfo(_curPage, _masterdata.score_lv + 1)
end

-- 刷新右边信息显示
local function reload_MasterInfo( ... )
	-- 升级前
	local bfLay = _mainLayer.LAY_BEFORE
	if (bfLay) then
		local bfLay_lv0 = _mainLayer.LAY_LV0_BEFORE
		local pAttrInfo = _masterdata.score_attr_info
		
        local pcount = table.count(pAttrInfo)
        -- 没达成任何等级的品级大师
        if (pcount == 0) then
        	bfLay:setVisible(false)
        	bfLay_lv0:setVisible(true)

        	UIHelper.labelAddNewStroke(bfLay_lv0.TFD_SCOREGURU_LV, m_i18n[5040], ccc3(0x00, 0x20, 0x68))
		    UIHelper.labelAddNewStroke(bfLay_lv0.TFD_SCOREGURU_LV_NUM, tostring(_masterdata.score_total), ccc3(0x00, 0x20, 0x68))

        	local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, 1)
            bfLay_lv0.TFD_LV0_DESC1:setText(m_i18n[5039]..pNum)
            bfLay_lv0.TFD_LV0_DESC2:setText(m_i18n[5036])
        else
        	local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage, _masterdata.score_lv)
        	bfLay:setVisible(true)
        	bfLay_lv0:setVisible(false)
        	--bfLay.TFD_SCOREGURU_LV:setVisible(true)
		    --bfLay.TFD_SCOREGURU_LV:setText("品级总和：")	-- yucong_todo
		    UIHelper.labelAddNewStroke(bfLay.TFD_SCOREGURU_LV, m_i18n[5040], ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_SCOREGURU_LV_NUM:setVisible(true)
		    --bfLay.TFD_SCOREGURU_LV_NUM:setText(tostring(_masterdata.score_total))
		    UIHelper.labelAddNewStroke(bfLay.TFD_SCOREGURU_LV_NUM, tostring(_masterdata.score_total), ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_STRGURU_LV_BEFORE:setVisible(true)
		    bfLay.TFD_STRGURU_LV_BEFORE:setText(m_i18n[5023])
		    --UIHelper.labelAddNewStroke(bfLay.TFD_STRGURU_LV_BEFORE, m_i18n[5023], ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_STRGURU_LV_BEFORE_NUM:setVisible(true)
		    bfLay.TFD_STRGURU_LV_BEFORE_NUM:setText(tostring(_masterdata.score_lv))
		    --UIHelper.labelAddNewStroke(bfLay.TFD_STRGURU_LV_BEFORE_NUM, tostring(_masterdata.score_lv), ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_JI1:setVisible(true)
		    bfLay.TFD_JI1:setText(m_i18n[3643])
		    --UIHelper.labelAddNewStroke(bfLay.TFD_JI1, m_i18n[3643], ccc3(0x00, 0x20, 0x68))
		    bfLay.TFD_LIMIT_BEFORE:setText(m_i18n[5039]..pNum)
		    -- 属性
		    for i=1, 5 do
                local tfd_attr = m_fnGetWidget(bfLay , "TFD_ATTR"..i)
                local ftd_attr_num = m_fnGetWidget(bfLay , "TFD_ATTR"..i.."_NUM")
                if(i <= pcount) then
                    local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(pAttrInfo[i][1],pAttrInfo[i][2])
                    tfd_attr:setText(affixInfo.displayName)
                    ftd_attr_num:setText("+"..displayNum)
                else
                    tfd_attr:setText("")
                    ftd_attr_num:setText("")
                end
            end
        end
		
	end

	-- 升级后
	local afLay = _mainLayer.LAY_AFTER
	if (afLay) then
		-- 下一级属性
		local pNextAttrInfo = _masterdata.score_attr_afinfo
		local pNum = MainEquipMasterCtrl.fnGetNumByLv(_curPage,_masterdata.score_lv + 1)
		
        local pcount = table.count(pNextAttrInfo)
        if (pcount == 0) then
        	afLay:setVisible(false)
        	_mainLayer.IMG_ARROW:setVisible(false)
        	
        else
        	afLay:setVisible(true)
        	_mainLayer.IMG_ARROW:setVisible(true)
		    --bfLay.TFD_STRGURU_LV_BEFORE:setVisible(true)
		    afLay.TFD_STRGURU_LV_AFTER:setText(m_i18n[5023])
		    --UIHelper.labelAddNewStroke(afLay.TFD_STRGURU_LV_AFTER, m_i18n[5023], ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_STRGURU_LV_BEFORE_NUM:setVisible(true)
		    afLay.TFD_STRGURU_LV_AFTER_NUM:setText(tostring(_masterdata.score_lv + 1))
		    --UIHelper.labelAddNewStroke(afLay.TFD_STRGURU_LV_AFTER_NUM, tostring(_masterdata.score_lv + 1), ccc3(0x00, 0x20, 0x68))
		    --bfLay.TFD_JI1:setVisible(true)
		    afLay.TFD_JI2:setText(m_i18n[3643])
		    --UIHelper.labelAddNewStroke(afLay.TFD_JI2, m_i18n[3643], ccc3(0x00, 0x20, 0x68))
		    afLay.TFD_LIMIT_AFTER:setText(m_i18n[5039]..pNum)
		    -- 属性
		    for i=1, 5 do
                local tfd_attr = m_fnGetWidget(afLay , "TFD_ATTR"..i)
                local ftd_attr_num = m_fnGetWidget(afLay , "TFD_ATTR"..i.."_NUM")
                if(i <= pcount) then
                    local affixInfo, displayNum = ItemUtil.getAtrrNameAndNum(pNextAttrInfo[i][1], pNextAttrInfo[i][2])
                    tfd_attr:setText(affixInfo.displayName)
                    ftd_attr_num:setText("+"..displayNum)
                else
                    tfd_attr:setText("")
                    ftd_attr_num:setText("")
                end
            end
        end
		
	end
end

-- 刷新装备显示
local function reload_Equip( ... )
	
	local armInfos = _heroInfo.equip.arming
    --该伙伴没有帽子、武器、项链、衣服
    local pEquipStrings = {m_i18n[5012],m_i18n[5011],m_i18n[5009],m_i18n[5013]}
    
    for i = 1, kARM_NUM do 
        --根据装备类型获取角色身上的装备
        local pID = armInfos[tostring(i)] or nil
        --没有装备对应装备
        if(not pID or tonumber(pID) == 0) then
        	_left_widgets.LAB_No_Equip[i]:setText(pEquipStrings[i])
        	_left_widgets.LAB_No_Equip[i]:setVisible(true)
        	_left_widgets.LAB_EquipName[i]:setVisible(false)
        	_left_widgets.LAB_EquipScore[i]:setVisible(false)
        	_left_widgets.IMG_EquipScore[i]:setVisible(false)
        	_left_widgets.IMG_EquipIcon[i]:setVisible(false)
            --提示 该伙伴没有xxx
            _left_widgets.BTN_Equip[i]:addTouchEventListener(function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    require "script/module/public/ShowNotice"
                    ShowNotice.showShellInfo(pEquipStrings[i])
                end
            end)
        else
        	_left_widgets.LAB_No_Equip[i]:setVisible(false)
        	_left_widgets.LAB_EquipName[i]:setVisible(true)
        	_left_widgets.LAB_EquipScore[i]:setVisible(true)
        	_left_widgets.IMG_EquipScore[i]:setVisible(true)
        	_left_widgets.IMG_EquipIcon[i]:setVisible(true)

        	local itemTemid = tonumber(pID.item_template_id)
        	-- 装备详细按钮回调
        	_left_widgets.BTN_Equip[i]:addTouchEventListener(function ( sender, eventType )
        		if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    -- if(mIsAutoEnhance) then
                    --     return
                    -- end
                    require "script/module/equipment/EquipInfoCtrl"
                    EquipInfoCtrl.createForSellEquip(pID) -- 只带一个"返回"按钮的装备信息面板
                end
        	end)
        	-- 装备信息
            local armInfo = ItemUtil.getItemById(tonumber(itemTemid))
            --armItem:setTag(m_equipTag)
            local armColor = HeroPublicUtil.getDarkColorByStarLv(armInfo.quality)
            -- 名字
            _left_widgets.LAB_EquipName[i]:setText(armInfo.name)
            _left_widgets.LAB_EquipName[i]:setColor(armColor)
            UIHelper.labelEffect(_left_widgets.LAB_EquipName[i])
            -- 头像
            _left_widgets.IMG_EquipIcon[i]:loadTexture(armInfo.iconBigPath)

            -- 品级
            local pScore = armInfo.base_score or ""
            _left_widgets.LAB_EquipScore[i]:setText(m_i18n[5041].." "..pScore)	-- yucong_todo
        end
    end
end

-- 刷新宝物显示
local function reload_Treasure( ... )
	local treasureInfo = _heroInfo.equip.treasure
	local openTreasureLvArr = FormationUtil.getTreasureOpenLvInfo()
    local pLevel = UserModel.getHeroLevel()
    --该伙伴没有魔防型宝物...
    local pTreaStrings = {m_i18n[5014],m_i18n[5015],m_i18n[5016],m_i18n[5017]}

	for i = 1, kTREASURE_NUM do
		local layer = _treasureLayer[i]
		
		--宝物
        local pID = treasureInfo[tostring(i)] or nil
        local pLv = tonumber(openTreasureLvArr[i]) or 0
        
        if(pLv > pLevel) then
            _left_widgets.LAB_No_Treasure[i]:setText(pTreaStrings[i])
        	_left_widgets.LAB_No_Treasure[i]:setVisible(false)
        	_left_widgets.LAB_TreasureName[i]:setVisible(false)
        	_left_widgets.LAB_TreasureScore[i]:setVisible(false)
        	_left_widgets.IMG_TreasureScore[i]:setVisible(false)
        	_left_widgets.IMG_TreasureIcon[i]:setVisible(false)
        	--锁
        	layer.IMG_LOCK:setVisible(true)
        	layer.TFD_UNLOCK_LV:setVisible(true)
        	layer.TFD_UNLOCK_LV:setText(tostring(pLv)..m_i18n[1201])

            _left_widgets.BTN_Treasure[i]:addTouchEventListener(function ( sender, eventType )
                if (eventType == TOUCH_EVENT_ENDED) then
                    AudioHelper.playInfoEffect()
                    -- if(mIsAutoEnhance) then
                    --     return
                    -- end
                    require "script/module/public/ShowNotice"
                    local pStr = pLv .. m_i18n[1201]
                    ShowNotice.showShellInfo(pStr)
                end
            end)
        else
        	--锁
        	layer.IMG_LOCK:setVisible(false)
        	layer.TFD_UNLOCK_LV:setVisible(false)

            if (not pID or tonumber(pID) == 0) then
                _left_widgets.LAB_No_Treasure[i]:setText(pTreaStrings[i])
	        	_left_widgets.LAB_No_Treasure[i]:setVisible(true)
	        	_left_widgets.LAB_TreasureName[i]:setVisible(false)
	        	_left_widgets.LAB_TreasureScore[i]:setVisible(false)
	        	_left_widgets.IMG_TreasureScore[i]:setVisible(false)
	        	_left_widgets.IMG_TreasureIcon[i]:setVisible(false)
                _left_widgets.BTN_Treasure[i]:addTouchEventListener(function ( sender, eventType )
                    if (eventType == TOUCH_EVENT_ENDED) then
                        AudioHelper.playInfoEffect()
                        -- if(mIsAutoEnhance) then
                        --     return
                        -- end
                        require "script/module/public/ShowNotice"
                        ShowNotice.showShellInfo(pTreaStrings[i])
                    end
                end)
            else
            	_left_widgets.LAB_No_Treasure[i]:setVisible(false)
	        	_left_widgets.LAB_TreasureName[i]:setVisible(true)
	        	_left_widgets.LAB_TreasureScore[i]:setVisible(true)
	        	_left_widgets.IMG_TreasureScore[i]:setVisible(true)
	        	_left_widgets.IMG_TreasureIcon[i]:setVisible(true)

                local itemTemid = tonumber(pID.item_template_id)
                 _left_widgets.BTN_Treasure[i]:addTouchEventListener(function ( sender, eventType )
                    if (eventType == TOUCH_EVENT_ENDED) then
                        AudioHelper.playInfoEffect()
                        -- if(mIsAutoEnhance) then
                        --     return
                        -- end
                        --wm_todo
                        require "script/module/treasure/NewTreaInfoCtrl"
                        NewTreaInfoCtrl.create(pID.item_id)
                    end
                end )
                local treaInfo = ItemUtil.getItemById(tonumber(itemTemid))
                local treaColor = HeroPublicUtil.getDarkColorByStarLv(treaInfo.quality)
                
                -- 名字
	            _left_widgets.LAB_TreasureName[i]:setText(treaInfo.name)
	            _left_widgets.LAB_TreasureName[i]:setColor(treaColor)
	            UIHelper.labelEffect(_left_widgets.LAB_TreasureName[i])
	            -- 头像
	            _left_widgets.IMG_TreasureIcon[i]:loadTexture(treaInfo.iconBigPath)

	            -- 品级
	            local pScore = treaInfo.base_score or ""
	            _left_widgets.LAB_TreasureScore[i]:setText(m_i18n[5041]..pScore)	-- yucong_todo
            end
        end
	end
end

-- 刷新接口
function reload( ... )
	-- 处理数据
	handleDatas()

	-- 装备四格
	reload_Equip()

	-- 宝物四格
	reload_Treasure()

	-- 右边属性
	reload_MasterInfo()
end

-- 创建显示框架
function createFrame( ... )
	UIHelper.labelAddNewStroke(_mainLayer.TFD_EQUIP, m_i18n[1601], ccc3(0x9c, 0x4d, 0x00))
	UIHelper.labelAddNewStroke(_mainLayer.TFD_TREASURE, m_i18n[1701], ccc3(0x9c, 0x4d, 0x00))

	for i = 1, kARM_NUM + kTREASURE_NUM do
		local pLayer = nil
		local index = i
		if (i <= kARM_NUM) then
			pLayer = m_fnGetWidget(_mainLayer.LAY_EQUIP , ("LAY_EQUIP" .. index) )
			_left_widgets.LAB_No_Equip[index] = pLayer.TFD_NO_EQUIP
			_left_widgets.LAB_EquipName[index] = pLayer.TFD_NAME
			_left_widgets.LAB_EquipScore[index] = pLayer.TFD_SCORE
			_left_widgets.IMG_EquipScore[index] = pLayer.IMG_SCORE
			_left_widgets.IMG_EquipIcon[index] = pLayer.IMG_ICON
			_left_widgets.BTN_Equip[index] = pLayer.BTN_FRAME
		else
			index = i - kARM_NUM
			pLayer = m_fnGetWidget(_mainLayer.LAY_TREASURE , ("LAY_EQUIP" .. index) )
			_left_widgets.LAB_No_Treasure[index] = pLayer.TFD_NO_EQUIP
			_left_widgets.LAB_TreasureName[index] = pLayer.TFD_NAME
			_left_widgets.LAB_TreasureScore[index] = pLayer.TFD_SCORE
			_left_widgets.IMG_TreasureScore[index] = pLayer.IMG_SCORE
			_left_widgets.IMG_TreasureIcon[index] = pLayer.IMG_ICON
			_left_widgets.BTN_Treasure[index] = pLayer.BTN_FRAME
            _treasureLayer[index] = m_fnGetWidget(_mainLayer.LAY_TREASURE, "LAY_EQUIP"..index)
		end
	end
	-- 宝物的四格层
	-- _treasureLayer[1] = _mainLayer.LAY_TREASURE.LAY_EQUIP1
	-- _treasureLayer[2] = _mainLayer.LAY_TREASURE.LAY_EQUIP2
	-- _treasureLayer[3] = _mainLayer.LAY_TREASURE.LAY_EQUIP3
	-- _treasureLayer[4] = _mainLayer.LAY_TREASURE.LAY_EQUIP4
end

local function init( parentWidget, heroInfo )
	local parLayer = tolua.cast(parentWidget,"Widget")
	_mainLayer = m_fnGetWidget(parLayer, "LAY_SCORE_GURU")
	_heroInfo = heroInfo
	createFrame()
	reload()
end

function destroy(...)
	package.loaded["MasterScoreView"] = nil
end

function moduleName()
	return "MasterScoreView"
end

function create( parentWidget, heroInfo )
	init(parentWidget, heroInfo)

	return _mainLayer
end