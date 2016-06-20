-- FileName: MainRewardInfoExtraView.lua
-- Author:  wangming
-- Date: 2014-12-25
-- Purpose: 签到物品界面展示(vip补签)
--[[TODO List]]

module("MainRewardInfoExtraView", package.seeall)

require "script/module/registration/MainRegistrationData"
require "script/module/public/ItemUtil"
require "script/model/user/UserModel"
require "script/module/guide/GuideCtrl"
require "script/module/public/UIHelper"
require "script/module/config/AudioHelper"
require "db/i18n"
 -- 资源文件
local reward_sign = "ui/sign_reward_extra.json" 

-- 模块局部变量 --
local m_fnGetWidget                 = g_fnGetWidgetByName
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
    package.loaded["MainRewardInfoExtraView"] = nil
end

function moduleName()
    return "MainRewardInfoExtraView"
end

--增加描边和国际化
function appendEffect( layBg )
 
    local fd_leiji          =    m_fnGetWidget(layBg, "tfd_leiji")
    local tfd_huode         =    m_fnGetWidget(layBg, "tfd_huode")
     tfd_huode:setText(m_i18n[2617])
    fd_leiji:setText(m_i18n[2624])
    
    local tfd_shengdao      =    m_fnGetWidget(layBg,"tfd_shengdao")
    local tfd_kelingqu      =    m_fnGetWidget(layBg,"tfd_kelingqu")
    local LABN_VIP_NUM      =    m_fnGetWidget(layBg,"LABN_VIP_NUM")

    tfd_shengdao:setText(m_i18n[2635])
    tfd_kelingqu:setText(m_i18n[2636])
    LABN_VIP_NUM:setStringValue(UserModel.getVipLevel().."")

    
end

function create(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid,sppend)
    local layout 
    sppends  = sppend
    getTip   = nil
    m_CurVip = UserModel.getUserInfo().vip
    
    layout = createView(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid)  
    LayerManager.addLayout(layout)

end

function createView(color,typeName,reward_des,time,des,bget,alreadySign,goodNum,imagePath,imageIcon,goodType,goodid,info,vipLevel,beishu,rewardid)
    local layBg     =   g_fnLoadUI(reward_sign)
    local btnClose  = m_fnGetWidget(layBg, "BTN_CLOSE") 
    local btnGet  = m_fnGetWidget(layBg, "BTN_SURE") 
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


    UIHelper.titleShadow(btnGet ,m_i18n[2628])
    m_getReward = 1
    btnGet:addTouchEventListener(getReward)
        
    
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

    local pBei = tonumber(m_CurBei) - 1
    pBei = pBei > 0 and pBei or 1
    nums = tonumber(nums) * pBei
    num:setText(tostring(nums))

    local goodInfo  = nil 
    if (goodType==7) then 
        goodInfo = ItemUtil.getItemById(goodid)
    end 

    local name = g_fnGetWidgetByName(layBg, "TFD_ITEM_NAME")
    name:setColor(g_QulityColor[qualitys])
    name:setText(reward_des)
    local mainDes = g_fnGetWidgetByName(layBg, "TFD_ITEM_DESC")
    
    if des == nil then 
        local nNum = 1
        -- if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
        --     nNum = nNum * pBei
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

local function fnDoClose( ... )
    require "script/module/guide/GuideModel"
    require "script/module/guide/GuideSignView"
    if (GuideModel.getGuideClass() == ksGuideSignIn and GuideSignView.guideStep == 3) then
        GuideCtrl.removeGuide()
    end
    LayerManager.removeLayout()
    
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
        DataCache.getNorSignCurInfo().last_vip = UserModel.getVipLevel()
        MainRegistrationView.refreshListView()
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
    local pBei = 1
    if(m_CurBei~= nil) then
        local pNum = (m_CurBei - 1)
        pBei = pNum > 0 and pNum or 1
    end
    if tonumber(goodType) == 7 then 
        local array = string.split(infoResult,"|") 
        if array[2] ~= nil then  
            nNum =  array[2]
        else 
            nNum = 1
        end 
        if m_CurBei~= nil and tonumber(m_CurVip) >= tonumber(m_vipLevel) then 
            nNum = nNum * pBei
        end
        getTip = m_i18n[2632] .. "[" ..reward_dess .. "]" .."×" .. nNum 
    elseif tonumber(goodType) == 1 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * pBei
        end
        UserModel.addSilverNumber( tonumber(infoResult))
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum
    elseif  tonumber(goodType) == 3 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * pBei
        end
        UserModel.addGoldNumber( tonumber(infoResult))
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    elseif tonumber(goodType) == 5 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * pBei
        end
        UserModel.addStaminaMaxNumber(  tonumber(infoResult)  )
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    elseif tonumber(goodType) == 4 then 
        if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
            nNum = nNum * pBei
        end
        UserModel.addEnergyValue(  tonumber(infoResult)   )
        getTip = m_i18n[2632] .. "[" ..infoResult .. reward_dess .. "]" .."×" .. nNum  
    -- elseif tonumber(goodType) == 2 then -- zhangqi, 2015-01-10, 去经验石
    --     if m_CurBei~= nil and tonumber(m_CurVip)>= tonumber(m_vipLevel) then 
    --         nNum = nNum * pBei
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
    -- local   layout                             =  Layout:create()
        
    -- m_listview:setItemModel(refCell) -- 设置默认的cell
    daysRewardArr ,daysRewardType,daysRewardName ,daysRewardQuality=  readInfo(sign_reward)

    -- m_listview:setTouchEnabled(true)
    -- m_listview:removeAllItems()-- 初始化清空列表ß 
    -- local nAbleTosee        
    -- if tonumber(#daysRewardArr) == 1 then 
    --     nAbleTosee = 1
    --     m_listview:setPosition(ccp(-235,-62)) 
    -- elseif tonumber(#daysRewardArr) == 2 then 
    --     nAbleTosee = 2
    --     m_listview:setPosition(ccp(-235,-125))
    --     main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height +140))
    --     mlistViewBack:setSize(CCSizeMake(mlistViewBack:getSize().width,mlistViewBack:getSize().height +130))
    --     mlistViewBack:setPositionPercent(ccp(0,0.15))
    -- elseif tonumber(#daysRewardArr) > 2 then 
    --     nAbleTosee = 2.5
    --     m_listview:setPosition(ccp(-235,-155))
    --     main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height +240))
    --     mlistViewBack:setSize(CCSizeMake(mlistViewBack:getSize().width,mlistViewBack:getSize().height +200))
    --     mlistViewBack:setPositionPercent(ccp(0,0.15)) 
    --     if (m_getReward == 0  or m_vip ~= 3) then 
    --         main_back:setSize(CCSizeMake(main_back:getSize().width,main_back:getSize().height -40))
    --         mlistViewBack:setPositionPercent(ccp(0,0.1))
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

 