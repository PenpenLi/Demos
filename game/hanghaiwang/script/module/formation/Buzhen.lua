-- FileName: Buzhen.lua 
-- Author: zhaoqiangjun 
-- Date: 14-3-29 
-- Purpose: function description of module 

require "script/module/formation/FormationData"
require "script/utils/LuaUtil"
require "db/DB_Heroes"
require "script/module/public/UIHelper"
require "script/battle/data/db_hero_offset_util"

module("Buzhen", package.seeall)

local  m_i18n = gi18n
local m_i18nString = gi18nString
local  m_fnGetWidget = g_fnGetWidgetByName
local  heroSelected = nil
local  selectedPos = nil
local  selectedImg = nil
local  selectedHeroHid = nil

local selectImgPos = nil
local headPos = ccp(-0.55, -0.89)
local headHeight = 148
local oHeadPos = ccp(0, -0.34)
local heroSelectPos = nil

local m_fnClickBtnBack
local  touchLayer

local  jsonforbuzhen = "ui/formation_buzhen.json"

local  widgetBuzhen

local  fData 
local  fBenchData

local  img_zhenxing_table = {}
local  tbRestWidget = {}
local  tblHeroSprite = {}
local touchBeginPoint = nil
local m_nType -- 如果为2来于竞技场 如果是3来自于副本

local notifyBuZhen = "Buzhen" --布阵的全局回掉名称

local isExit = false

--[[desc:清空formation上的小伙伴
    return: void 
—]]
function  fnCleanupFormation( ... )

    for k ,v in pairs(tbRestWidget) do 
        v = nil
    end
    for k ,v in pairs(tblHeroSprite) do 
        v = nil
    end
    for k,v in pairs(img_zhenxing_table) do
        v = nil
    end
    tbRestWidget = {}
    tblHeroSprite = {}
    img_zhenxing_table = {}
    selectImgPos = nil
    
    heroSelected = nil
    selectedImg = nil
    heroSelectPos = nil
end

local function fnInitBuzhen( ... )
   for k ,v in pairs(tblHeroSprite) do 
        tblHeroSprite[k] = nil
    end
    widgetBuzhen = nil
    tblHeroSprite = {}
    FormationData.init()
    fnCleanupFormation()
end

--[[
    desc:返回按钮事件处理
—]]
local  function onClickBtnBack( sender, eventType )
    -- print("onClickBtnBack :  " .. eventType)
    if (eventType == TOUCH_EVENT_ENDED) then
        --AudioHelper.playBackEffect()
        AudioHelper.playCloseEffect()
        
        fnCleanupFormation()
        LayerManager.removeLayout()
        if (m_nType == 1) then -- 默认是1 整容界面 从竞技场进入布阵是 2 不需要刷新 add by huxiaozhou
            if(FormationData.fnBenchChanged()) then
                FormationData.fnUpdateMainFormation()
                require "script/module/partner/MainPartner"
                MainPartner.refreshYingZiListView()
            end
            MainFormation.showWidgetMain()
            --更新小伙伴界面阵型
            require "script/module/formation/FormLitFriScrollView" 
            FormLitFriScrollView.refreshFormView()
        end
        GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, notifyBuZhen)
    end

end




--[[
    desc:注册所有按钮的回调事件
    arg1: 
    return:
-—]]
local function fnAllBuzhenButtonEvent( ... )
    
    -- print("fnAllBuzhenButtonEvent")
    local btnBuZhen = m_fnGetWidget(widgetBuzhen, "BTN_BACK")
    if (btnBuZhen) then
        if (m_fnClickBtnBack ~= nil and m_nType == 2 ) then
            btnBuZhen:addTouchEventListener(m_fnClickBtnBack)
        elseif(m_fnClickBtnBack ~= nil and m_nType == 3) then
            btnBuZhen:addTouchEventListener(m_fnClickBtnBack)
        else
            btnBuZhen:addTouchEventListener(onClickBtnBack)
        end
        UIHelper.titleShadow(btnBuZhen, "")
    end
end 




local function fnAddBuzhenEvent( ... )

    -- print("fnAllBuzhenButtonEvent") 
	local headList = tolua.cast(UIHelper:seekWidgetByName(widgetBuzhen, "LSV_LITTLE_HERO"), "ListView")
	if (headList) then
    	for i = 1, 3 do
        	local btn = Button:create()
        	btn:loadTextureNormal("test/formation-2/lock.png")
        	if (btn) then
            	headList:pushBackCustomItem(btn)
            	btn:setName("head-" .. i)
            	btn:addTouchEventListener(
            		function()
            		 -- print("btnName: " .. btn:getName())
            		end)
        	end
    	end
	end
end


--[[
    desc:某个位置是否开启
    arg1: m_pos：start with 0
    return: BOOL
-—]]
function isOpenedByPosition( m_pos )
    m_pos = tonumber(m_pos)
    require "db/DB_Formation"
    require "script/model/user/UserModel"
    local m_Level = UserModel.getHeroLevel()
    local f_data = DB_Formation.getDataById(1)

    local pLevel = 100
    local needShow = true
    if(m_pos < 6) then
        local f_open_nums = lua_string_split(f_data.openSort, ",")
        local f_open_levels = lua_string_split(f_data.openPositionLv, ",")
        for k, v_pos in pairs(f_open_nums) do
            if(tonumber(v_pos) == m_pos) then
                pLevel = f_open_levels[k]
                break
             end
        end
    else
        local pPos = m_pos - 6 + 1
        local f_openInfo = lua_string_split(f_data.openBenchByLv, ",")
        for k,v in pairs(f_openInfo) do
            local pLpInfo = lua_string_split(v, "|")
            if(tonumber(pLpInfo[2]) == pPos) then
                pLevel = pLpInfo[1]
                break
            end
        end
        local f_displayInfo = lua_string_split(f_data.bench_display, ",")
        for k,v in pairs(f_displayInfo) do
            local pLdInfo = lua_string_split(v, "|")
            if(tonumber(pLdInfo[2]) == tonumber(pPos)) then
                needShow = tonumber(m_Level) >= tonumber(pLdInfo[1])
                break
            end
        end
    end

    return  ( tonumber(m_Level) >= tonumber(pLevel) ) , tonumber(pLevel) , needShow
end

--[[
    desc:交换两个位置的英雄，任意一个都可以是空位置，只做移动处理 ，处理数据，数据层重新刷新UI显示
    arg1: pos  start from  0
    return: 
-—]]
local function changeHeroPos(pos1 , pos2)
    if(pos1 < 7 and pos2 < 7) then
        return FormationData.changePos(pos1, pos2)
    elseif(pos1 > 6 and pos2 > 6) then
        return FormationData.fnChangeBench(pos1 - 6 - 1, pos2 - 6 - 1)
    else
        return FormationData.fnSwapForBen(pos1 , pos2)
    end
end

local function onTouchBegan(x, y)
    touchBeginPoint =  ccp(x,y)

    -- zhangqi, 20140627, 如果已经有点击选中的武将，则返回
    -- 避免点选了武将不放开同时点击另一处，引起begin方法重入，heroSelected为nil, 导致移动武将操作卡死
    if (heroSelected) then

        return
    end

    -- heroSelected = nil -- comment by zhangqi, 20140627

    for pos , img_zhen in pairs( img_zhenxing_table ) do

        print ("pos"..pos)
        local imgPosX , imgPosY = img_zhen:getPosition()
        imgPos = img_zhen:getParent():convertToWorldSpace(ccp(imgPosX,imgPosY))
        print("imgPos " ..imgPos.x .."  ".. imgPos.y.. "  size "..img_zhen:getContentSize().width .."  "..img_zhen:getContentSize().height)

        local max_x = imgPos.x + img_zhen:getContentSize().width*0.5
        local min_x = imgPos.x - img_zhen:getContentSize().width*0.5
        local max_y = imgPos.y + img_zhen:getContentSize().height*0.5
        local min_y = imgPos.y - img_zhen:getContentSize().height*0.5

        if (x >= min_x and x <= max_x and y >= min_y and y <= max_y) then
            
            selectedPos = pos

            local herosp = tblHeroSprite[pos]
            logger:debug({tblHeroSprite = tblHeroSprite})
            if (herosp) then 
                heroSelectPos   = herosp:getPositionPercent() 
                selectedImg     = img_zhen
                heroSelected    = herosp
                heroSelected:retain()
                heroSelected:removeFromParent()
                touchLayer:addChild(herosp)
                heroSelected:setPosition(ccp(x - heroSelected:getContentSize().width/2, y - heroSelected:getContentSize().height/2))
                heroSelected:release()

                selectImgPos = imgPos

                AudioHelper.playBtnEffect("tuodong.mp3")
            end
            return true
        end       
    end

    return false
end

local function onTouchMoved(x, y)
    if  heroSelected then
        heroSelected:setPosition(ccp(x - heroSelected:getContentSize().width/2,y - heroSelected:getContentSize().height/2))
    end
end

local function onTouchEnded(x, y)

    if ( selectedPos == nil  or heroSelected == nil )then
        return
    end
    AudioHelper.playCommonEffect()
    local isGetPos = false

    local touchEndPoint = ccp(x , y)
    -- 遍历是否end到某一个小伙伴上了
    for pos , img_zhen in pairs( img_zhenxing_table ) do
        local imgPosX , imgPosY = img_zhen:getPosition()
        imgPos = img_zhen:getParent():convertToWorldSpace(ccp(imgPosX,imgPosY))
        local max_x = imgPos.x + img_zhen:getContentSize().width*0.5
        local min_x = imgPos.x - img_zhen:getContentSize().width*0.5
        local max_y = imgPos.y + img_zhen:getContentSize().height*0.5
        local min_y = imgPos.y - img_zhen:getContentSize().height*0.5

        if (x >= min_x and x <= max_x and y >= min_y and y <= max_y) then
            isOpen , needLevel = isOpenedByPosition(pos-1)
            if (not isOpen ) then
                break
            end

            local endPos = pos
            --检查位置是否发生了变化.
            if selectedPos == endPos then
                isGetPos = false
            else
                local result = changeHeroPos(selectedPos , endPos)
                if (result) then
                    tblHeroSprite[selectedPos] = nil
                end
                isGetPos = true
            end
        end  --- if (x >= min_x and 
    end -- for pos , img_zhen

    if (not isGetPos) and heroSelected then
        heroSelected:retain()
        heroSelected:setPosition(ccp(0.5, 0.5))
        heroSelected:removeFromParent()
        selectedImg:addChild(heroSelected)
        heroSelected:release()

        heroSelected = nil
        selectedImg = nil
        heroSelectPos = nil
    end

    selectedPos  = nil
end


local function  onTouchHandler( touchType , x , y)

    if ( touchType ==  "began" ) then
        return onTouchBegan(x, y)
    elseif ( touchType ==  "moved" ) then
         onTouchMoved(x, y)
    elseif (touchType == "ended" ) then
         onTouchEnded(x, y)
    end

end



--[[
    desc:根据hid生成一个伙伴ImageView
    arg1: hid
    return: ImageView 
-—]]
function createHeroSprite( herohid )
    require "script/model/hero/HeroModel"
    local heroInfo = HeroModel.getHeroByHid(herohid)
    local herotid = heroInfo.htid
    local heroData = DB_Heroes.getDataById(herotid)

    heroSprite  = ImageView:create()
    heroSprite:loadTexture("images/base/hero/body_img/" .. heroData.body_img_id )

    return heroSprite
end

function getHeroHeadImgAndOffset( herohid )
    
    require "script/model/hero/HeroModel"
    local heroInfo = HeroModel.getHeroByHid(herohid)
    local herotid = heroInfo.htid
    local heroData = DB_Heroes.getDataById(herotid)

    local heroOffset = db_hero_offset_util.getHeroImgOffset(heroData.action_module_id)

    return "images/base/hero/action_module/" .. heroData.action_module_id ,heroOffset
end

local function getHeroName(heroInfo)
    require "script/model/user/UserModel"

    local heroname

    local heroId = heroInfo.model_id
    if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        heroname = UserModel.getUserName()
    else
        heroname = heroInfo.name
    end

    return heroname
end

local function onEnterCall( ... )
    
    isExit = true
end

local function onExitCall( ... )
    GlobalNotify.removeObserver(GlobalNotify.RECONN_OK, notifyBuZhen)

    isExit = false
end

--[[
    desc: 根据数据创建阵型UI
    arg1: 暂时无用
    return: 无 
-—]]
function createFromation( formation_table )

    if (not widgetBuzhen) then
        widgetBuzhen = g_fnLoadUI(jsonforbuzhen)

        UIHelper.registExitAndEnterCall(widgetBuzhen, onExitCall, onEnterCall)
        if(m_nType == 1) then
            MainFormation.hideWidgetMain()
            LayerManager.addLayout(widgetBuzhen)
        elseif (m_nType == 2) then
            LayerManager.addLayout(widgetBuzhen)
        elseif (m_nType == 3) then
            LayerManager.addLayout(widgetBuzhen)
        end

        --获取touch
        touchLayer = CCLayer:create()
        touchLayer:setTouchMode(kCCTouchesOneByOne)
        touchLayer:registerScriptTouchHandler(onTouchHandler, false, -127, false)
        touchLayer:setTouchEnabled(true)
        widgetBuzhen:addNode(touchLayer)
        touchLayer:setPosition(ccp(0,0))

        fnAllBuzhenButtonEvent()
    end

    fData , fBenchData = FormationData.getData()

    if(not fData) then
        assert(fData,"err : 阵型数据为空")
        return
    end
    --- 锁定块
    local lock_img =  g_fnGetWidgetByName(widgetBuzhen, "IMG_ZHENXING_LOCK")
    lock_img:setVisible(false)
 
    local imgCount = table.count(img_zhenxing_table)
    local pos = 1

    while pos <= 9 do

        local imgZhen
        local label_lv 
        local img_card  
        local img_head 
        local tfd_name  
        local lay_total
        local lab_level

        if imgCount ~= 0 then
            imgZhen = img_zhenxing_table[pos]

            local tbWidget = tbRestWidget[pos]

            --label_lv    =  tbWidget["lv"]
            img_card    = tbWidget["card"]
            img_head    = tbWidget["head"]
            tfd_name    = tbWidget["name"] 
            lay_total   = tbWidget["total"]
            --lab_level   = tbWidget["level"]
            --img_lvbg    = tbWidget["lvbg"]
            img_name    = tbWidget["namebg"]
        else
            -- 获取人物图像背景
            local img_zhenxing
            if(pos <= 6)then
                img_zhenxing  = "IMG_ZHENXING"..tostring(pos)
            else
                img_zhenxing  = "IMG_TIBU"..tostring(pos - 6)
            end
            --local label_lv_name = "TFD_LV" 
            -- local img_lv_num = "IMG_LV"..tostring(pos)
            local img_cardStr   = "IMG_CARD"
            local img_headStr   = "IMG_HERO"
            local tfd_nameStr   = "TFD_NAME"
            local lay_totalStr  = "LAY_TOTAL"
            --local lab_levelStr  = "tfd_level"
            --local img_lvbgStr   = "img_zhenxinglv"
            local img_nameStr = "img_zhenxingname" 

            imgZhen = g_fnGetWidgetByName(widgetBuzhen, img_zhenxing)
            --label_lv =  g_fnGetWidgetByName(imgZhen, label_lv_name)
            
            img_card  = g_fnGetWidgetByName(imgZhen, img_cardStr)
            img_head  = g_fnGetWidgetByName(imgZhen, img_headStr)
            tfd_name  = g_fnGetWidgetByName(imgZhen, tfd_nameStr) 
            lay_total = g_fnGetWidgetByName(imgZhen, lay_totalStr)
            --lab_level = g_fnGetWidgetByName(imgZhen, lab_levelStr)
            --img_lvbg  = g_fnGetWidgetByName(imgZhen, img_lvbgStr)
            img_name  = g_fnGetWidgetByName(imgZhen, img_nameStr)

            local tbWidget  = {}
            tbWidget["card"]    = img_card
            --tbWidget["lv"]      = label_lv
            tbWidget["head"]    = img_head
            tbWidget["name"]    = tfd_name
            tbWidget["total"]   = lay_total
            --tbWidget["level"]   = lab_level
            --tbWidget["lvbg"]    = img_lvbg
            tbWidget["namebg"]  = img_name

            tbRestWidget[pos] = tbWidget
        end


        --lay_total:setPositionPercent(headPos)

        local  x ,y = imgZhen:getPosition() 
        local anpoint = imgZhen:getAnchorPoint();

        if (imgZhen == nil) then
            assert(imgZhen, "ERR: seekWidgetByName:"..img_zhenxing)
        else
            local isOpen = false
            local needLevel = 0
            local needShow = true
            
            img_zhenxing_table[pos] = imgZhen
            isOpen , needLevel , needShow = isOpenedByPosition(pos-1)
            logger:debug(isOpen)
            if(needShow) then
                local my_lock_img = imgZhen.IMG_ZHENXING_LOCK
                if (not isOpen )then
                    my_lock_img:setVisible(true)
                    if(my_lock_img) then
                        local label_need_lv = g_fnGetWidgetByName(my_lock_img, "TFD_JIKAIQI_LV")
                        local label_need_lv_str = g_fnGetWidgetByName(my_lock_img, "TFD_JIKAIQI")
                        if ( label_need_lv ) then
                            label_need_lv:setText(tostring(needLevel))
                            label_need_lv_str:setText(m_i18n[5027])
                            -- UIHelper.labelShadow(label_need_lv)
                            -- UIHelper.labelNewStroke(label_need_lv , ccc3( 0x00, 0x0 , 0x0) , 4)
                            -- UIHelper.labelShadow(label_need_lv_str)
                            -- UIHelper.labelNewStroke(label_need_lv_str , ccc3( 0x00, 0x0 , 0x0) , 4)
                        end
                    end
                else
                    --if(pos > 6) then
                        --local my_lock_img = g_fnGetWidgetByName(imgZhen, "IMG_ZHENXING_LOCK")
                        my_lock_img:setVisible(false)
                    --end
                end

                -- 创建人物图
                local herohid
                if(pos < 7) then
                    herohid = fData[pos]
                else
                    local TempP = pos - 6 - 1
                    herohid = fBenchData[TempP .. ""]
                end
                
                --该位置无伙伴
                if (tonumber(herohid) == 0 or tonumber(herohid) == nil or tonumber(herohid) == -1) then
                    img_card:setVisible(false)
                    img_head:setVisible(false)
                    --img_lvbg:setVisible(false)
                    img_name:setVisible(false)
                    tfd_name:setText("")
                    --label_lv:setText("")
                    --lab_level:setText("")

                    if heroSelected == lay_total and heroSelected then
                        heroSelected:retain()
                        heroSelected:setPosition(heroSelectPos)
                        heroSelected:removeFromParent()
                        selectedImg:addChild(heroSelected, 10)
                        heroSelected:release()

                        img_head:setPositionPercent(ccp(oHeadPos.x, oHeadPos.y))
                    end   

                --位置上有伙伴            
                else 
                    img_card:setVisible(true)
                    img_head:setVisible(true)
                    --img_lvbg:setVisible(true)
                    img_name:setVisible(true)
                    --lab_level:setText("Lv.")
                    local heroInfo = HeroModel.getHeroByHid(herohid)

                    --label_lv:setText(tostring(heroInfo.level))
                    
                    local heroImg, heroOff   = getHeroHeadImgAndOffset(herohid)
                    local herotid   = heroInfo.htid
                    local heroData  = DB_Heroes.getDataById(herotid)

                    local quality   = heroData.star_lv
                    local qualityStr    = "images/battle/card/card_raw_"..tostring(quality)..".png"
                    -- yucong 2015-12-14 卡修改为icon
                    -- img_card:loadTexture(qualityStr)
                    -- img_head:loadTexture(heroImg)
                    local heroIcon = HeroUtil.createHeroIconBtnByHtid(herotid)
                    img_card:addChild(heroIcon)
                    
                    --在这里检查,如果对上了内容就换位置。
                    if heroSelected == lay_total and heroSelected then
                        heroSelected:retain()
                        heroSelected:setPosition(heroSelectPos)
                        heroSelected:removeFromParent()
                        selectedImg:addChild(heroSelected, 10)
                        heroSelected:release()
                    end    
                    -- yucong 2015-12-14 卡修改为icon            
                    -- local imgSize = img_head:getContentSize()
                    -- img_head:setPositionPercent(ccp(oHeadPos.x + heroOff[1]/imgSize.width, oHeadPos.y + heroOff[2]/headHeight))

                    local name = getHeroName(heroData)
                    tfd_name:setText(name)
                    tfd_name:setColor(g_QulityColor[tonumber(quality)])
                    tblHeroSprite[pos] = lay_total
                    local p_x , p_y = imgZhen:getParent():getPosition()
                end  
                --UIHelper.labelStroke(label_lv)
            else 
                imgZhen:setVisible(false)
            end
        end
        
        pos = pos + 1
    end 
    -- 网络数据在touchbegan后touchmove前回来  会刷新ui导致野指针
    heroSelected = nil
    selectedImg = nil
    heroSelectPos = nil
end

function reConCallBack( ... )
    
    createFromation()
end

function init( ... )
    if isExit == false then
        m_nType = 1 -- 从阵容进来
        fnInitBuzhen()
        GlobalNotify.addObserver(GlobalNotify.RECONN_OK, fnInitBuzhen, true, notifyBuZhen)
    end
end

function create( _fncallBack )
    --从竞技场进入
    m_fnClickBtnBack = _fncallBack
    m_nType = 2
    fnInitBuzhen()
    GlobalNotify.addObserver(GlobalNotify.RECONN_OK, fnInitBuzhen, true, notifyBuZhen)
end
--从副本进入
function createForCopy( _fncallBack )
    m_fnClickBtnBack = _fncallBack
    m_nType = 3
    fnInitBuzhen()
    GlobalNotify.addObserver(GlobalNotify.RECONN_OK, fnInitBuzhen, true, notifyBuZhen)
end

function  destroy( ... )
    fnCleanupFormation()
end



