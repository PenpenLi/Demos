-- FileName: MainShadowdropView.lua
-- Author: lizy
-- Date: 2014-07-30
-- Purpose: 影子掉落模块视图层
--[[TODO List]]
----ererer

module("MainShadowdropView", package.seeall)

require "db/DB_Item_hero_fragment"
require "db/DB_Copy"
require "db/DB_Heroes"
require "db/DB_Stronghold"
require "script/module/copy/MainCopy"
require "script/module/copy/battleMonster"
require "script/model/hero/HeroModel"
require "script/module/public/UIHelper"
require "script/module/config/AudioHelper"

-- 资源文件--
local shadowdrop = "ui/shadow_drop.json" 
-- UI控件引用变量 --
local m_fnGetWidget     			=  g_fnGetWidgetByName 
-- 模块局部变量 --
local m_qulityColor  =  g_QulityColor
local m_listview
local copyDatas
local shadowDetail 
local txtTip   
local m_i18n = gi18n
local shadowdId
local layBg    
local dropReturnInfo

local function init(...)

end

function destroy(...)
	package.loaded["MainShadowdropView"] = nil
end

function moduleName()
    return "MainShadowdropView"
end

-- add effect and value of widget  
local function appendEffect( layBg )
  local tfdZizhi                 =    m_fnGetWidget(layBg , "tfd_quality")   
  local tfd_get                  =    m_fnGetWidget(layBg , "tfd_get")   
  local tfd_can_recruit          =    m_fnGetWidget(layBg , "tfd_can_recruit")  
  local tfd_txt                  =    m_fnGetWidget(layBg , "TFD_TXT") 
  local tfd_title                =    m_fnGetWidget(layBg , "tfd_title") 
  
  tfdZizhi:setText(m_i18n[1003])  -- 资质
  --tfd_get:setText(m_i18n[1096])  -- 集齐
  tfd_can_recruit:setText(m_i18n[1097]) -- 个可招募
  tfd_txt:setText(m_i18n[1099])  --暂不由副本或神秘商店产出！
  UIHelper.labelShadowWithText(tfd_title,m_i18n[1098])  -- 获取途径
  UIHelper.labelNewStroke(tfd_title,ccc3(0x87,0x47,0x0e))
end
--z装入listview 里面的数据
local function refreshListView( gid ,refreshInfo)
	 
	local dataArray 					    =   string.split(shadowDetail.dropStrongHold, ",")
	local mystical				        =   shadowDetail.isMystical
	local copy 
	local cell , nIdx  ,cells     =  0 
	local strongHold

	m_listview:removeAllItems() -- 初始化清空列表
     
  for i=1,#dataArray do
    local data        =  string.split(dataArray[i], "|")
   
	  strongHold 			        =  DB_Stronghold.getDataById(data[1] )
 	  copy 					          =  DB_Copy.getDataById(strongHold.copy_id)
 	  local fightTimesArray   = string.split(strongHold.fight_times,"|")        
    m_listview:pushBackDefaultItem() 
 
    nIdx                	= i - 1
    cell                	= m_listview:getItem(nIdx)  -- cell 索引从 0 开始
    -- cells					        = cell:clone()
    local copyName		    = m_fnGetWidget(cell,"TFD_COPY_NAME")
    local copyLevel       = m_fnGetWidget(cell,"TFD_LEVEL")
    local strongHoldName  = m_fnGetWidget(cell,"TFD_STRONGHOLD_NAME")
    local shop    		    = m_fnGetWidget(cell,"lay_mysterious_shop")
    local btnCell    		  = m_fnGetWidget(cell,"BTN_CELL")
    local holeIcon        = m_fnGetWidget(cell,"tfd_mysterious_shop")
    local heroBg          = m_fnGetWidget(cell,"img_stronghold_head_bg")
    -- local fightTimes      = m_fnGetWidget(cell,"_STRONGHOLD_TIMES_NUM")
    local fightTimes      = m_fnGetWidget(cell,"TFD_STRONGHOLD_TIMES_NUM")
    local fightAllTimes   = m_fnGetWidget(cell,"TFD_STRONGHOLD_TIMES_ALL_NUM")
    local notOpen         = m_fnGetWidget(cell,"TFD_TIPS_NO_OPEN")
    local alreadyOpen     = m_fnGetWidget(cell,"IMG_TIPS_GO")
    
   
    shop:setVisible(false)
    txtTip:setVisible(false)
    notOpen:setText(m_i18n[4316])
    
    -- UIHelper.labelEffect(copyName , copy.name  .."("..  getCopyType(data[2]) .. ")")
    -- copyName:loadTexture("images/common/guild_treasure/shadow_guide_copy" .. copy.id ..".png")
    UIHelper.labelShadowWithText(copyName,copy.name) 
    UIHelper.labelNewStroke(copyName,ccc3(0x5e,0x31,0x00))

    local pLevel , pColor = getCopyType(data[2])
    copyLevel:setText(pLevel)
    if(not pColor == false) then
      copyLevel:setColor(pColor)
    end
    heroBg:loadTexture("images/base/hero/head_icon/".. strongHold.icon)
    UIHelper.labelShadowWithText(holeIcon,m_i18n[1092]) 
    UIHelper.labelNewStroke(holeIcon,ccc3(0x5e,0x31,0x00))
    
    UIHelper.labelEffect(strongHoldName , strongHold.name)
    local baseStatus ,valueInfo  = nil

    local stauts , attNum
    if (copyDatas["".. copy.id] ~= nil) then
       stauts , attNum = battleMonster.fnGetAttedInfoForYing(data[1],copyDatas[""..copy.id].va_copy_info,data[2])
    end
    if ( (copyDatas["".. copy.id] ~= nil) and  (tonumber(stauts) >=2) ) then
      fightTimes:setText(attNum)
      fightAllTimes:setText(fightTimesArray[tonumber(data[2])])
      alreadyOpen:setVisible(true)
      notOpen:setVisible(false)
      btnCell:setTag(copy.id)
      btnCell:addTouchEventListener(function ( sender, eventType )
      if eventType == TOUCH_EVENT_ENDED then 
          -- require "script/module/partner/MainPartner"
          -- local callback = MainPartner.resumBagCallFn   -- 从副本回到影子列表的方法回调
          require "script/module/public/DropUtil"
          local curModule = LayerManager.curModuleName()
          logger:debug({curModule=curModule})
          DropUtil.setSourceAndAim(curModule,curModule)
          logger:debug({refreshInfo=refreshInfo})
          if (refreshInfo) then
              DropUtil.insertRefreshInfo(curModule,"refreshInfo",refreshInfo)
          end
          local callback = function ( )   -- 从副本回到影子列表的方法回调
              DropUtil.getReturn(curModule)
          end
          MainCopy.heroFragToCopyBase(sender:getTag(),data[1],copyDatas["".. sender:getTag()],data[2],callback)
        end
      end)
    else 
        alreadyOpen:setVisible(false)
        notOpen:setVisible(true) 
        fightTimes:setText(fightTimesArray[tonumber(data[2])]) 
        fightAllTimes:setText(fightTimesArray[tonumber(data[2])])
        btnCell:addTouchEventListener(function ( sender, eventType )
          if eventType == TOUCH_EVENT_ENDED then
              require "script/module/public/ShowNotice"
              ShowNotice.showShellInfo(gi18nString(1918))
          end
        end)
    end
     
  end	

  if (shadowDetail.isMystical == 1) then 
    local flag = 0
    txtTip:setVisible(false)
    --cell                 = m_listview:getItem(0)  -- cell 索引从 0 开始
    --if (cell == nil ) then 
       flag = 1 
       m_listview:pushBackDefaultItem() 
       cells                 = m_listview:getItem(#dataArray)  -- cell 索引从 0 开始
    --end
    --cells                = cell:clone()
    local  stronghold    = m_fnGetWidget(cells , "lay_stronghold")  
    local notOpen        = m_fnGetWidget(cells,"TFD_TIPS_NO_OPEN")
    local alreadyOpen    = m_fnGetWidget(cells,"IMG_TIPS_GO")     
    local shop           = m_fnGetWidget(cells,"lay_mysterious_shop")  
    -- local shopName       = m_fnGetWidget(cells,"tfd_mysterious_shop")
    local shopDesc       = m_fnGetWidget(cells,"tfd_stronghold")
    local btnCell        = m_fnGetWidget(cells,"BTN_CELL")
    local holeIcon        = m_fnGetWidget(cells,"tfd_mysterious_shop")
    local imagMysShop        = m_fnGetWidget(cells,"IMG_MYSTERIOUS_SHOP")

    stronghold:setVisible(false)
    notOpen:setText(m_i18n[4316])
    notOpen:setVisible(false)
    alreadyOpen:setVisible(true)
    shop:setVisible(true)

    shopDesc:setText(m_i18n[1017])

    
    if(not SwitchModel.getSwitchOpenState(ksSwitchResolve)) then
          notOpen:setVisible(true)
          alreadyOpen:setVisible(false) 
    end
    imagMysShop:loadTexture("images/common/icon_mystical_shop.png")
    UIHelper.labelShadowWithText(holeIcon,m_i18n[1092]) 
    UIHelper.labelNewStroke(holeIcon,ccc3(0x5e,0x31,0x00))

    btnCell:addTouchEventListener(function ( sender, eventType  )
      if eventType == TOUCH_EVENT_ENDED then
        require "script/module/switch/SwitchModel"
        logger:debug("dfadfsdafds" .. ksSwitchResolve)
        if(not SwitchModel.getSwitchOpenState(ksSwitchResolve,true)) then
            return
        else
           require "script/module/wonderfulActivity/MainWonderfulActCtrl"
          if (LayerManager.curModuleName() ~= MainWonderfulActCtrl.moduleName()) then 
              local act = MainWonderfulActCtrl.create("castle")
              LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
          else
              LayerManager.removeLayout()          -- 已在当前界面
              LayerManager.removeLayout()          
          end
        end
      end  
    end)

  end
    
end

function refreshOwnFragNum( ... )
    if (layBg) then
        local ownNum = DataCache.getHeroFragNumByItemTmpid(shadowdId)
        local tfd_haveNum          =   m_fnGetWidget(layBg,"TFD_NUM")
        tfd_haveNum:setText(ownNum)
    end
end

function create(shadowInfo,copyData,dropReturnInfo)
    dropReturnInfo = dropReturnInfo
	  copyDatas 					   =   copyData
    logger:debug("dfsadadsfsdfasdfas")
    logger:debug(shadowInfo)
    layBg 				   = 	 g_fnLoadUI(shadowdrop)
    local btnClose 				 =   m_fnGetWidget(layBg,"BTN_CLOSE")

    --local lay_shadow_name_bg  =   m_fnGetWidget(layBg,"lay_shadow_name_bg")
    local lay_shadow_name  =   m_fnGetWidget(layBg,"lay_shadow_name")
    local shadowName			 =   m_fnGetWidget(layBg,"TFD_SHADOW_NAME")
    local tfd_shadow       =   m_fnGetWidget(layBg,"tfd_shadow")

    local zizhi 				   =   m_fnGetWidget(layBg,"TFD_QUALITY_NUM")
    -- local totalNum				 =   m_fnGetWidget(layBg,"LABN_NUM")
    local iconBag 				 =   m_fnGetWidget(layBg,"IMG_ICON_BG")
    local iconBorder       =   m_fnGetWidget(layBg,"IMG_UP_BG")

    txtTip                 =   m_fnGetWidget(layBg,"TFD_TXT")

    local shadowIcon 			 =   m_fnGetWidget(layBg,"IMG_ICON")
    --local partNum          =   m_fnGetWidget(layBg,"TFD_NUM")
    --local heroName         =   m_fnGetWidget(layBg,"TFD_HERO_NAME")
    local layText          =   m_fnGetWidget(layBg , "lay_txt") 
    local tfd_Get          =   m_fnGetWidget(layBg , "TFD_NP_GET") 
    local tfd_haveNum          =   m_fnGetWidget(layBg,"TFD_NUM")
    local tfd_needNum  =   m_fnGetWidget(layBg,"TFD_HERO_NAME")


    shadowdId        =   shadowInfo.id
    local isCompose        =   shadowInfo.is_compose

    shadowDetail           =   shadowInfo
    local hero             =   DB_Heroes.getDataById(shadowDetail.aimItem)
    m_listview 			       =   m_fnGetWidget(layBg,"LSV_LIST")
    
    local pExp = tonumber(shadowDetail.isExp) or 0

    if  (pExp == 1 or tonumber(isCompose) == 0) then 
        layText:setVisible(false)
        tfd_Get:setVisible(true)
        tfd_Get:setText(m_i18n[1100])
    else 
        layText:setVisible(true)
        tfd_Get:setVisible(false)
    end


    --appendEffect(layBg)
    local tfd_title                =    m_fnGetWidget(layBg , "tfd_title") 
    UIHelper.labelShadowWithText(tfd_title,m_i18n[1098])  -- 获取途径
    UIHelper.labelNewStroke(tfd_title,ccc3(0x87,0x47,0x0e))

    local ownNum = DataCache.getHeroFragNumByItemTmpid(shadowdId)
    tfd_haveNum:setText(ownNum)

    local nMax = shadowDetail.need_part_num
    tfd_needNum:setText(nMax)
    tfd_haveNum:setColor(ccc3(0xdf, 0x01, 0x0c))

    shadowName:setText(shadowDetail.name)


    local pWidth = shadowName:getContentSize().width + tfd_shadow:getContentSize().width 
    lay_shadow_name:setPositionType(2)
    --lay_shadow_name:setPositionX(lay_shadow_name_bg:getContentSize().width*0.5 - pWidth*0.5)


  --  UIHelper.labelShadowWithText(shadowName,shadowDetail.name,CCSizeMake(4, -4))
    UIHelper.labelStroke(shadowName)
    --iconBag:setColor(g_QulityColor2[shadowInfo.nQuality]) 
      
    iconBag:loadTexture("images/base/potential/color_".. shadowDetail.quality .. ".png")
    iconBorder:loadTexture("images/base/potential/officer_".. shadowDetail.quality .. ".png")

    shadowIcon:loadTexture("images/base/hero/head_icon/" .. shadowDetail.icon_small)

    zizhi:setText(hero.heroQuality)
    -- totalNum:setStringValue(shadowInfo.nMax)
    -- partNum:setText(tostring(shadowDetail.need_part_num))
    UIHelper.initListView(m_listview) 
    
    -- UIHelper.labelEffect(heroName , hero.name)
    -- heroName:setColor(g_QulityColor[shadowDetail.quality])
    shadowName:setColor(g_QulityColor[shadowDetail.quality])
    tfd_shadow:setColor(g_QulityColor[shadowDetail.quality])




    local img_desc_bg = m_fnGetWidget(layBg,"img_desc_bg")
    local tfd_get = m_fnGetWidget(layBg,"tfd_get")
    local tfd_can_recruit = m_fnGetWidget(layBg,"tfd_can_recruit")
    --pWidth = tfd_get:getContentSize().width + partNum:getContentSize().width + tfd_can_recruit:getContentSize().width + heroName:getContentSize().width
    layText:setPositionType(2)
    --layText:setPositionX( - pWidth*0.5)
-- img_desc_bg:getContentSize().width*0.5

    refreshListView(shadowdId,dropReturnInfo)


    btnClose:addTouchEventListener(close)
    return layBg
end

function close( ... )
    dropReturnInfo = nil
    AudioHelper.playCloseEffect()
    LayerManager.removeLayout(layBg)
end
function getCopyType( nType )
    if (tonumber(nType) == 1) then
       return m_i18n[4904]  , ccc3(0x00,0x8a,0x00)  -- 简单副本
    elseif (tonumber(nType) == 2) then
       return m_i18n[4905] , ccc3(0xd8,0x14,0x00)   -- 困难副本
    elseif (tonumber(nType) == 3) then
       return m_i18n[4913] , ccc3(0xa1,0x15,0xb6)   -- 精英副本
    end
end