-- FileName: MainRewardInfoView.lua
-- Author:  lizy
-- Date: 2014-04-00
-- Purpose: 签到物品界面展示
--[[TODO List]]

module("MainRewardInfoView", package.seeall)

require "script/module/registration/MainRegistrationData"
require "script/module/public/ItemUtil"
require "script/model/user/UserModel"
require "script/module/guide/GuideCtrl"
require "script/module/public/UIHelper"
require "script/module/config/AudioHelper"
require "db/i18n"
 -- 资源文件
local reward_sign = "ui/sign_reward.json" 
 
-- 模块局部变量 --
local m_fnGetWidget     			= g_fnGetWidgetByName
local m_listview
-- 模块局部变量 --
local reward_dess 
local dess
local infoResult
local typeGood
local titleIcon
local infomation
local goodId
local m_i18n = gi18n
local m_qulityColor  =  g_QulityColor
local m_vipLevel
local m_beishu
local sppends 
local m_time
local m_vip
local m_getReward
local goodNums
local m_CurVip
local m_CurBei
local sign_reward
local tbGoods = {}
local getTip  = nil
local function init(...)

end

function destroy(...)
	package.loaded["MainRewardInfoView"] = nil
end

function moduleName()
    return "MainRewardInfoView"
end

local function fnDoClose( ... )

    require "script/module/guide/GuideModel"
    require "script/module/guide/GuideSignView"
    if (GuideModel.getGuideClass() == ksGuideSignIn and GuideSignView.guideStep == 3) then
        GuideCtrl.removeGuide()
    end
    LayerManager.removeLayout()
    
end

--增加描边和国际化
function appendEffect( layBg )
    local numInfo           =    m_fnGetWidget(layBg , "TFD_ITEM_NUM_WORD")  
    local fd_leiji          =    m_fnGetWidget(layBg, "tfd_leiji")
    local tfd_huode         =    m_fnGetWidget(layBg, "tfd_huode")
    local tfd_shengdao      =    m_fnGetWidget(layBg,"tfd_shengdao")
    local tfd_kelingqu      =    m_fnGetWidget(layBg,"tfd_kelingqu")
    local TFD_DOUBLE_VIP_3  =    m_fnGetWidget(layBg,"TFD_DOUBLE_VIP_3")

   
    tfd_shengdao:setText("(" .. m_i18n[2627])
    tfd_kelingqu:setText(m_i18n[1314])
    TFD_DOUBLE_VIP_3:setText(m_i18n[2620] .. ")")


    tfd_huode:setText(m_i18n[2617])
    fd_leiji:setText(m_i18n[2624])
    numInfo:setText(m_i18n[1332])
  
end

function create(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend, haveGetNormal)
    local layout 
    sppends  = sppend
    getTip   = nil
    m_CurVip = UserModel.getUserInfo().vip
    
    layout = createView(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,haveGetNormal)  
    LayerManager.addLayout(layout)

end

local btnGet
local btnLay
local function fnInitButton(isSigle, layBg ) 
    local pLay1 = m_fnGetWidget(layBg, "LAY_BTNS_1") 
    local pLay2 = m_fnGetWidget(layBg, "LAY_BTNS_2")  
    local btn1 = m_fnGetWidget(layBg, "BTN_SURE")
    local btn2 = m_fnGetWidget(layBg, "BTN_CONFIRM")
    local btnCharge = m_fnGetWidget(layBg, "BTN_CHARGE")
    if(not isSigle) then
        btn1:setTouchEnabled(false)
        btn2:setTouchEnabled(true)
        
        pLay1:setVisible(true)
        pLay2:setVisible(false)
        btnCharge:setTouchEnabled(false)

        btnLay = pLay1
        btnGet = btn2
        
    else
        btn1:setTouchEnabled(true)
        btn2:setTouchEnabled(false)

        pLay1:setVisible(false)
        pLay2:setVisible(true)
        btnCharge:setTouchEnabled(true)
        
        UIHelper.titleShadow(btnCharge ,m_i18n[1412])
        btnCharge:addTouchEventListener(fnCharges)

        btnLay = pLay2
        btnGet = btn1
    end
end

function createView(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,haveGetNormal)
    local layBg     =   g_fnLoadUI(reward_sign)
    local btnClose  = m_fnGetWidget(layBg, "BTN_CLOSE") 
    local layCenter = m_fnGetWidget(layBg,"img_item_bg")
    local times     = m_fnGetWidget(layBg, "TFD_SIGN_TIMES")
    local iconOn 

    m_CurBei = typeName
    typeGood = goodType
    infoResult = info
    btnClose:addTouchEventListener(closes)
    times:setText(time)
    reward_dess = reward_des
    dess = des 
    m_vipLevel  = vipLevel  
    m_beishu    = beishu
    m_time      = time
   
    goodNums    = goodNum
    lablePalce( vipLevel ,  beishu ,layBg)

    local pL = m_vipLevel or 0
    local b1 = tonumber(pL) > tonumber(UserModel.getVipLevel())
    local b2 = tonumber(MainRegistrationData.getSignInNum()) == tonumber(time)
    local b3 = (not haveGetNormal)
    local isVipEnough =  b1 and b2 and b3
    fnInitButton(isVipEnough,layBg)

    if ((tonumber(bget) == 1) or (tonumber(MainRegistrationData.getSignInNum())< tonumber(time)) and sppends == 0 ) then 
        UIHelper.titleShadow(btnGet ,m_i18n[2629])
        m_getReward = 0
        btnGet:addTouchEventListener(function ( sender, eventType )
            if (eventType == TOUCH_EVENT_ENDED) then
                AudioHelper.playCommonEffect() -- 2016-01-08
                fnDoClose()
            end
        end)
    else
        UIHelper.titleShadow(btnGet ,m_i18n[2628])
        m_getReward = 1
        btnGet:addTouchEventListener(getReward)
    end
    
    --------------------------- new guide sign begin -----------------------------------------
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuideSignView"
    if (GuideModel.getGuideClass() == ksGuideSignIn and GuideSignView.guideStep == 2) then
          GuideCtrl.createSignGuide(3,0)
    end
    ------------------------------ new guide sing end ----------------------------------------
    
    sign_reward = DB_Sign_reward.getDataById(rewardid)
    -- local  child = 
    initListView(layBg,sign_reward)
    -- layCenter:removeAllChildren()
    -- layCenter:addChild(child)
    appendEffect(layBg)
    return layBg
end


function lablePalce( vipLevel ,  beishu ,layBg)
    if(vipLevel==nil or beishu == nil) then
        local  layTextTwo  =  m_fnGetWidget(layBg,"LAY_TXT2")
        layTextTwo:setVisible(false)
    else
        local doubleVip       =  m_fnGetWidget(layBg,"LABN_VIP_NUM")
        local doubleBei       =  m_fnGetWidget(layBg,"TFD_DOUBLE_VIP_2")
        doubleVip:setStringValue(vipLevel)
        doubleBei:setText(beishu)
    end
    -- local doubleVip       =  m_fnGetWidget(layBg,"LABN_VIP_NUM")
    -- local doubleBei       =  m_fnGetWidget(layBg,"TFD_DOUBLE_VIP_2")
    -- local layTextOne      =  m_fnGetWidget(layBg,"LAY_TXT1")
    -- local main            =  m_fnGetWidget(layBg,"img_bg")
    -- local layMain         =  m_fnGetWidget(layBg,"LAY_MAIN")
    -- local layCenter       =  m_fnGetWidget(layBg,"img_item_bg")
    -- if(vipLevel==nil or beishu == nil) then
    --     local  layTextTwo  =  m_fnGetWidget(layBg,"LAY_TXT2")
    --     layTextTwo:setVisible(false)
    --     local layBgSize = main:getSize()
    --     ---------------调整屏幕显示宽度----------------------
    --     main:setSize(CCSize(layBgSize.width   ,layBgSize.height-50) ) 
         
    --     if (tonumber(bget) == 1) or (tonumber(MainRegistrationData.getSignInNum())< tonumber(m_time) ) then 
    --         layCenter:setPositionPercent(ccp(0,0.17))
    --         m_vip = 2
    --     else
    --         layCenter:setPositionPercent(ccp(0,0.18)) 
    --         m_vip = 1 
    --     end
    -- else
    --     doubleVip:setStringValue(vipLevel)
    --     doubleBei:setText(beishu)
    --     m_vip = 3 
    -- end
end

function returnIcon( goodType,goodid ,info)
  local iconOn
  if tonumber(goodType) == 7 then 
       
        iconOn = ItemUtil.createBtnByTemplateId(goodid)
    elseif tonumber(goodType) == 1 then 
        iconOn = ItemUtil.getSiliverIconByNum(info)
        
    elseif  tonumber(goodType) == 3 then 
        iconOn = ItemUtil.getGoldIconByNum(info)
         
    elseif tonumber(goodType) == 5 then 
        iconOn = ImageView:create()
        iconOn:loadTexture("images/base/props/naili_xiao.png")
         
    elseif tonumber(goodType) == 4 then 
        iconOn = ImageView:create()
        iconOn:loadTexture("images/base/props/tili_xiao.png")
        
    elseif tonumber(goodType) == 2 then 
        
        iconOn = ItemUtil.getSoulIconByNum(info)
     else
        iconOn = nil   
    end
    return iconOn
end

function setBaseInfoOnView( layBg , goodNum , info ,goodid ,goodType,reward_des,des,qualitys)
    local  num = m_fnGetWidget(layBg, "TFD_ITEM_NUM")

    if goodNum ~= nil then 
        num:setText("1")
    else 
        num:setVisible(false)
    end
   
    local array = string.split(info,"|") 
    local nums
    if array[2] ~= nil then  
        nums  =  array[2]
    else 
        nums  = 1
    end 
    num:setText(nums)
    local goodInfo = nil
    if (goodType==7) then    --物品   1:贝里，2:经验 ，3:金币 ，4:体力 ，5:耐力， 7:物品
        goodInfo =  ItemUtil.getItemById(goodid)
    end  

    local name = g_fnGetWidgetByName(layBg, "TFD_ITEM_NAME")

    name:setColor(g_QulityColor[qualitys])
    name:setText(reward_des)
    local mainDes = g_fnGetWidgetByName(layBg, "TFD_ITEM_DESC")
    
    if des == nil then 
        local nNum = 1
        -- if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
        --     nNum = nNum * m_CurBei
        -- end
        des = m_i18n[2615] .. nNum*info..reward_des
    end
    mainDes:setText(des)

    mainDes:setTextVerticalAlignment(kCCVerticalTextAlignmentCenter)
    local size = mainDes:getSize()
    mainDes:setSize(CCSizeMake(size.width,60))

    local icon = g_fnGetWidgetByName(layBg, "IMG_ITEM_ICON")
    icon:removeAllChildren()

    icon:setColor(m_qulityColor[qualitys])
    infomation = info
    goodId     = goodid
    iconOn = returnIcon(goodType,goodid ,info)

    icon:addChild(iconOn)
    titleIcon = iconOn

    return layBg
end

function fnCharges( sender ,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCommonEffect()
        --前往充值
        logger:debug("wm----前往充值")
        LayerManager.removeLayout()
        require "script/module/IAP/IAPCtrl"
        LayerManager.addLayout(IAPCtrl.create())
    end
end

function closes( sender ,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playCloseEffect()
        fnDoClose()
    end
end

local function getReward_callback(cbFlag, dictData, bRet )
    if(bRet) then
        local   daysRewardArr        =  {}
        local   daysRewardType       =  {}
        local   daysRewardName       =  {}
        local   layout               =  Layout:create()

        daysRewardArr ,daysRewardType,daysRewardName ,daysRewardQuality =  readInfo(sign_reward)
        for i=1,#daysRewardArr do
            changeSignResult(daysRewardType[i],daysRewardArr[i])
        end
        DataCache.getNorSignCurInfo().reward_num = tonumber(DataCache.getNorSignCurInfo().reward_num) +1 
        MainRegistrationData.setSignInNum(tonumber(DataCache.getNorSignCurInfo().reward_num)-1)
        DataCache.getNorSignCurInfo().last_vip = UserModel.getVipLevel()
        MainRegistrationView.refreshListView()
        MainRegistrationView.refreasRewardMum()

        if getTip~= nil then 
            ShowNotice.showShellInfo(getTip)
            AudioHelper.playSpecialEffect("texiao_fanpai.mp3")
        end
    end
end

function getReward( sender ,eventType )
    if (eventType == TOUCH_EVENT_ENDED) then
        AudioHelper.playBtnEffect("tansuo02.mp3")
        fnDoClose()
        local args = CCArray:create()
        args:addObject(CCInteger:create(tonumber(m_time)-1))
        RequestCenter.sign_gainNormalSignReward(getReward_callback , args ) 
    end
end

function changeSignResult( goodType ,infoResult)
    local user = UserModel.getUserInfo()
    local nNum = 1

    if tonumber(goodType) == 7 then 
        local array = string.split(infoResult,"|") 
        if array[2] ~= nil then  
            nNum =  array[2]
        else 
            nNum = 1
        end 
        if m_CurBei~= nil and tonumber(m_CurVip) >= tonumber(m_vipLevel) then 
            nNum = nNum * m_CurBei
        end
        getTip = m_i18n[2632] .. "[" ..reward_dess .. "]" .."×" .. nNum 
    elseif tonumber(goodType) == 1 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * m_CurBei
        end
        UserModel.addSilverNumber( tonumber(infoResult))
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum
    elseif  tonumber(goodType) == 3 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * m_CurBei
        end
        UserModel.addGoldNumber( tonumber(infoResult))
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    elseif tonumber(goodType) == 5 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * m_CurBei
        end
        UserModel.addStaminaMaxNumber(  tonumber(infoResult)  )
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    elseif tonumber(goodType) == 4 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * m_CurBei
        end
        UserModel.addEnergyValue(  tonumber(infoResult)   )
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    -- elseif tonumber(goodType) == 2 then -- zhangqi, 2015-01-10, 去经验石
    --     if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
    --         nNum = nNum * m_CurBei
    --     end
    --     UserModel.addSoulNum(  tonumber(infoResult)    )
    --     getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    else
        iconOn = nil   
    end
end

function readInfo( sign_reward )
    local daysRewardArr                      =  {}
    local daysRewardType                     =  {}
    local daysRewardName                     =  {}
    local daysRewardQuality                  =  {}
    if (sign_reward.value_1 ~= nil ) then 
        table.insert(daysRewardArr,sign_reward.value_1)
        table.insert(daysRewardType,sign_reward.type_1)
        table.insert(daysRewardName,sign_reward.des_1)
        table.insert(daysRewardQuality,sign_reward.quality_1)
    end
    if (sign_reward.value_2 ~= nil ) then
        table.insert(daysRewardArr,sign_reward.value_2)
        table.insert(daysRewardType,sign_reward.type_2)
        table.insert(daysRewardName,sign_reward.des_2)
        table.insert(daysRewardQuality,sign_reward.quality_2)
    end
    if (sign_reward.value_3 ~= nil ) then
        table.insert(daysRewardArr,sign_reward.value_3)
        table.insert(daysRewardType,sign_reward.type_3)
        table.insert(daysRewardName,sign_reward.des_3)
        table.insert(daysRewardQuality,sign_reward.quality_3)
    end
    if (sign_reward.value_4 ~= nil ) then
        table.insert(daysRewardArr,sign_reward.value_4)
        table.insert(daysRewardType,sign_reward.type_4)
        table.insert(daysRewardName,sign_reward.des_4)
        table.insert(daysRewardQuality,sign_reward.quality_4)
    end
    if (sign_reward.value_5 ~= nil ) then
        table.insert(daysRewardArr,sign_reward.value_5)
        table.insert(daysRewardType,sign_reward.type_5)
        table.insert(daysRewardName,sign_reward.des_5)
        table.insert(daysRewardQuality,sign_reward.quality_5)
    end
    return daysRewardArr ,daysRewardType,daysRewardName,daysRewardQuality
end

function initListView( layBg ,sign_reward)
    -- m_listview =  ListView:create()
    -- local   cell, nIdx                         =  0 
    local   daysRewardArr                      =  {}
    local   daysRewardType                     =  {}
    local   daysRewardName                     =  {}
    local   daysRewardQuality                  =  {}
    -- cell                               =  m_fnGetWidget(layBg,"img_cell_bg")  
    -- local   refCell                            =  assert(cell, "refCell of " .. cell:getName() .. " is nil") -- 获取编辑器中的默认cell
    -- local   main_back                          =  m_fnGetWidget(layBg,"img_bg") 
    -- local   mlistViewBack                      =  m_fnGetWidget(layBg,"img_item_bg") 
    -- local   layTextOne                         =  m_fnGetWidget(layBg,"LAY_TXT1")
    -- local  layTextTwo                         =  m_fnGetWidget(layBg,"LAY_TXT2")
    -- local   layout                             =  Layout:create()
    -- m_listview:setItemModel(refCell) -- 设置默认的cell
    daysRewardArr ,daysRewardType,daysRewardName ,daysRewardQuality=  readInfo(sign_reward)

    -- m_listview:setTouchEnabled(true)
    -- m_listview:removeAllItems()-- 初始化清空列表ß 
    -- local nAbleTosee        
    -- if tonumber(#daysRewardArr) == 1 then 
        -- nAbleTosee = 1
        -- m_listview:setPosition(ccp(-235,-62)) 
    -- elseif tonumber(#daysRewardArr) == 2 then 
    --     nAbleTosee = 2
    --     m_listview:setPosition(ccp(-235,-125))
    --     main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height +140))
    --     mlistViewBack:setSize(CCSizeMake(mlistViewBack:getSize().width,mlistViewBack:getSize().height +130))
    --     mlistViewBack:setPositionPercent(ccp(0,0.15))
    --     layTextOne:setPositionPercent(ccp(-0.2,-0.23)) 
    --     layTextTwo:setPositionPercent(ccp(-0.25,-0.3)) 
    -- elseif tonumber(#daysRewardArr) > 2 then 
    --     nAbleTosee = 2.5
    --     m_listview:setPosition(ccp(-235,-155))
    --     main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height +240))
    --     mlistViewBack:setSize(CCSizeMake(mlistViewBack:getSize().width,mlistViewBack:getSize().height +200))
    --     mlistViewBack:setPositionPercent(ccp(0,0.15))
    --     layTextOne:setPositionPercent(ccp(-0.2,-0.23)) 
    --     layTextTwo:setPositionPercent(ccp(-0.25,-0.3)) 
    --     if (m_getReward == 0  or m_vip ~= 3) then 
    --         main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height -40))
    --         mlistViewBack:setPositionPercent(ccp(0,0.1))
    --         layTextOne:setPositionPercent(ccp(-0.2,-0.3)) 
    --         layTextTwo:setPositionPercent(ccp(-0.25,-0.37)) 
    --     end  
    -- end
    -- m_listview:setSize(CCSizeMake(cell:getSize().width,cell:getSize().height * nAbleTosee))
            
    local cells = m_fnGetWidget(layBg,"img_cell_bg") 
    for i=1,#daysRewardArr do
        -- cell:setVisible(true)
        -- m_listview:pushBackDefaultItem()
        -- local cells  =  cell:clone()     
           
        -- nIdx = i - 1
        -- cell = m_listview:getItem(nIdx)  -- cell 索引从 0 开始
           
        -- local item  = layout:clone()
        local array      = string.split(daysRewardArr[i],"|")        
        local goodNum    = 1
        local goodInfo   = nil
        local mian_desc  = nil
        local numInfo     = m_fnGetWidget(cells , "TFD_ITEM_NUM_WORD") 
 
        UIHelper.labelEffect(numInfo , m_i18n[1332])   
        if (tonumber(daysRewardType[i]) == 7 ) then 
            goodInfo   =  ItemUtil.getItemById(array[1])
            mian_desc  =  goodInfo.desc
            table.insert(tbGoods , goodInfo.id)
        end
        if array[2] ~= nil then  
            goodNum  =  array[2]
        else 
            goodNum  = 1
        end  
        
        -- item = 
        setBaseInfoOnView( cells , goodNum , daysRewardArr[i] ,array[1] ,daysRewardType[i],daysRewardName[i],mian_desc,daysRewardQuality[i])
        -- m_listview:removeItem(nIdx)
        -- m_listview:insertCustomItem(item,nIdx)
    end
  
    -- return m_listview
end

 
