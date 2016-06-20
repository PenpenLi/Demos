-- FileName: ActivityView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: 活动模块视图，界面处理
--[[TODO List]]

module("MainActivityView", package.seeall)

-- 资源文件
local activity_list = "ui/activity_list.json"  

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString

TAG_CELL_MINE = 999
TAG_CELL_IMPEL = 1000

-- UI控件引用变量 --

local listView



local function init(...)

end

function destroy(...)
	package.loaded["MainActivityView"] = nil
end

function moduleName()
    return "MainActivityView"
end

function create(tbEvent)
    local layBg =  g_fnLoadUI(activity_list)

    local img_bg = m_fnGetWidget(layBg,"img_bg")
    img_bg:setScale(g_fScaleX)
    local IMG_BLACK = m_fnGetWidget(layBg, "IMG_BLACK")
    IMG_BLACK:setScale(g_fScaleX)
    
    listView  = m_fnGetWidget(layBg,"LSV_MAIN")

    local lay_Rob   = m_fnGetWidget(layBg,"LAY_ROB")
    
    lay_Rob:setSize(CCSizeMake(lay_Rob:getSize().width * g_fScaleX ,lay_Rob:getSize().height * g_fScaleX) ) 
     
    local IMG_ROB_BG = m_fnGetWidget(lay_Rob,"IMG_ROB_BG")
    IMG_ROB_BG:setScale(g_fScaleX)
      -- 按钮 以及注册回调

    UIHelper.initListView(listView)

    --[[
        @desc: 修改Cell
        @param     cell  type: layout
        @param     cellData  type: table
        @param     index  type: number
    —]]
    local function loadCell(cell,cellData,index)
        local btnSender = m_fnGetWidget(cell, "BTN_ROB")
        local imgLOCK = m_fnGetWidget(cell, "IMG_LOCK")
        local tfdSwitch = m_fnGetWidget(cell, "TFD_SWITCH")
        local imgInfo = m_fnGetWidget(cell, "IMG_INFO")

        btnSender:loadTextureNormal(cellData.n)
        btnSender:loadTexturePressed(cellData.h)

        btnSender:addTouchEventListener(tbEvent.onAction)

        btnSender:setTag(index)

        imgLOCK:setEnabled(false)
        tfdSwitch:setEnabled(false)
        
        local itemImage = ImageView:create()
        --itemImage:setAnchorPoint(ccp(0.5, 0.5))
        itemImage:loadTexture(cellData.p)
        --itemImage:setPosition(ccp(-imgInfo:getContentSize().width/2, imgInfo:getContentSize().height/2))
        imgInfo:addChild(itemImage)

        local imgtip = m_fnGetWidget(cell, "IMG_TIP")
        imgtip:setVisible(false)

        if (cellData.key == "rob") then  -- 夺宝置灰
           if(not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure,false)) then
                btnSender:setGray(true)

                UIHelper.setWidgetGray(cell,true)
                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchRobTreasure)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           end

        end
        if (cellData.key=="arena") then  --竞技场置灰
           if(not SwitchModel.getSwitchOpenState(ksSwitchArena,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchArena)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           end

        end
        if (cellData.key=="acopy") then  -- 活动副本置灰
           if(not SwitchModel.getSwitchOpenState(ksSwitchActivityCopy,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchActivityCopy)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           end

        end
        if (cellData.key=="skypiea") then  -- 空岛爬塔置灰
           if(not SwitchModel.getSwitchOpenState(ksSwitchTower,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchTower)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           end

        end

        if (cellData.key=="mine") then  -- 资源矿
            cell:setTag(TAG_CELL_MINE)
           if(not SwitchModel.getSwitchOpenState(ksSwitchResource,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchResource)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
            else
                if (MineModel.isTips()) then
                    imgtip:setVisible(true)
                    local lbtip = m_fnGetWidget(cell, "LABN_TIP_NUM")
                    lbtip:setStringValue(1)
                end
           end
        end



        if (cellData.key=="boss") then  -- 世界boss
           if(not SwitchModel.getSwitchOpenState(ksSwitchWorldBoss,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchWorldBoss)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           end
        end

        if (cellData.key=="impel") then  -- 深海监狱
           cell:setTag(TAG_CELL_IMPEL) 
           if(not SwitchModel.getSwitchOpenState(ksSwitchImpelDown,false)) then
                btnSender:setGray(true)

                imgLOCK:setEnabled(true)
                tfdSwitch:setEnabled(true)

                local switchInfo = DB_Switch.getDataById(ksSwitchImpelDown)
                local str = m_i18nString(1204,switchInfo.level)
                tfdSwitch:setText(str)
           else
                require "script/module/impelDown/ImpelDownMainModel"
                local hasNoGainReward = ImpelDownMainModel.isNoGainSweepReward()
                local hasFreeRefreshChance = ImpelDownMainModel.isHasFreeRefresh()
                if (hasNoGainReward or hasFreeRefreshChance) then
                    imgtip:setVisible(true)
                    local lbtip = m_fnGetWidget(cell, "LABN_TIP_NUM")
                    lbtip:setStringValue(1)
                else
                    imgtip:setVisible(false)
                end
            end
        end


        if (cellData.key=="acopy") then
            require "script/module/copyActivity/MainCopyModel"
            local num=MainCopyModel.getAllAtackNums()
            if (num>0) then
                imgtip:setVisible(true)
                local lbtip = m_fnGetWidget(cell, "LABN_TIP_NUM")
                lbtip:setStringValue(num)
            else
                imgtip:setVisible(false)
            end
        end
        if (cellData.key == "explore") then
            setExplorRedByBtn(cell)
        end

        imgInfo:setGray(false)
    end
    


    local nIdx
    for i,cellData in ipairs( MainActivityCtrl.tBtnImgs or {}) do
        listView:pushBackDefaultItem()  
        nIdx = i - 1
        local cell = listView:getItem(nIdx)  -- cell 索引从 0 开始
        loadCell(cell,cellData,i)
    end


     performWithDelay(layBg, function(...)
        local cell = listView:getItem(0)
        local img = m_fnGetWidget(cell, "IMG_ROB_BG")
        local pos = img:getWorldPosition()
        pos = ccp(pos.x, pos.y + img:getSize().height*0.5*g_fScaleX)
        addGuideView(pos)
     end, 0.1)



	-- Xufei 2015-10-15 ---begin
    local function fnRefreshImpelTip( ... )
        require "script/module/impelDown/ImpelDownMainModel"
        local hasNoGainReward = ImpelDownMainModel.isNoGainSweepReward()
        local hasFreeRefreshChance = ImpelDownMainModel.isHasFreeRefresh()
        local cellImpel = listView:getChildByTag(TAG_CELL_IMPEL)
        local cellTip = m_fnGetWidget(cellImpel, "IMG_TIP")
        if (hasNoGainReward or hasFreeRefreshChance) then
            cellTip:setVisible(true)
            local lbtip = m_fnGetWidget(cellImpel, "LABN_TIP_NUM")
            lbtip:setStringValue(1)
        else
            cellTip:setVisible(false)
        end
    end

    local function fnRefreshMineTip( ... )
        local cellImpel = listView:getChildByTag(TAG_CELL_MINE)
        local cellTip = m_fnGetWidget(cellImpel, "IMG_TIP")
        if (MineModel.isTips()) then
            cellTip:setVisible(true)
            local lbtip = m_fnGetWidget(cellImpel, "LABN_TIP_NUM")
            lbtip:setStringValue(1)
        else
            cellTip:setVisible(false)
        end
    end

    UIHelper.registExitAndEnterCall(layBg,
        function()
            GlobalNotify.removeObserver("IMPEL_DOWN_UPDATE_TIP", "IMPEL_DOWN_END_SWEEP_UPDATE_RED_POINT") 
            GlobalNotify.removeObserver(MineModel._MSG_.CB_REFRESH_TIP, moduleName())
        end,
        function()
            GlobalNotify.addObserver("IMPEL_DOWN_UPDATE_TIP", fnRefreshImpelTip, nil, "IMPEL_DOWN_END_SWEEP_UPDATE_RED_POINT")
            GlobalNotify.addObserver(MineModel._MSG_.CB_REFRESH_TIP, fnRefreshMineTip, nil, moduleName())
        end
    ) 
    -- Xufei 2015-10-15 ---end

  return layBg
end

function addGuideView( pos)
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuideArenaView"
    if (GuideModel.getGuideClass() == ksGuideArena and GuideArenaView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createArenaGuide(2,nil,pos)  
        listView:setTouchEnabled(false)
    end 

    require "script/module/guide/GuideSkyPieaView"
    if (GuideModel.getGuideClass() == ksGuideSkypiea and GuideSkyPieaView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createSkyPieaGuide(2) 
        listView:setTouchEnabled(false)
    end 
    require "script/module/guide/GuideAcopyView"
    if (GuideModel.getGuideClass() == ksGuideAcopy and GuideAcopyView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createAcopyGuide(2,nil, nil, pos) 
        listView:setTouchEnabled(false)
    end 

    require "script/module/guide/GuideResView"
    if (GuideModel.getGuideClass() == ksGuideResource and GuideResView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createResGuide(2,nil, pos) 
        listView:setTouchEnabled(false)
    end 


    require "script/module/guide/GuideBossView"
    if (GuideModel.getGuideClass() == ksGuideBoss and GuideBossView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createBossGuide(2,nil, pos) 
        listView:setTouchEnabled(false)
    end 


    logger:debug("GuideImpelDownView.guideStep = %s", GuideImpelDownView.guideStep)
    require "script/module/guide/GuideImpelDownView"
    if (GuideModel.getGuideClass() == ksGuideImpelDown and GuideImpelDownView.guideStep == 1) then  
        require "script/module/guide/GuideCtrl"
        GuideCtrl.createImpelDownGuide(2,nil, pos) 
        listView:setTouchEnabled(false)
    end     
end

--探索红点
function setExplorRedByBtn(explorBtn)
    require "script/module/copy/ExplorData"
    local function updateExploreRed()
        local explorRed = m_fnGetWidget(explorBtn, "IMG_TIP")
        local status,num=ExplorData.getRedStatus()
        explorRed:setVisible(status)
        local redTip = m_fnGetWidget(explorBtn, "LABN_TIP_NUM")
        redTip:setStringValue(num)
    end
    schedule(explorBtn,updateExploreRed,0.5)
    updateExploreRed()
end

 
