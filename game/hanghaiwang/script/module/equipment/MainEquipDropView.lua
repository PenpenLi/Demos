-- FileName: MainEquipDropView.lua
-- Author: wangming
-- Date: 2014-12-07
-- Purpose: 装备掉落模块视图层
--[[TODO List]]

module("MainEquipDropView", package.seeall)

require "db/DB_Item_fragment"
require "db/DB_Copy"
require "db/DB_Elitecopy"
require "db/DB_Stronghold"
require "script/module/copy/MainCopy"
require "script/module/copy/battleMonster"
require "script/model/hero/HeroModel"
require "script/module/public/UIHelper"
require "script/module/config/AudioHelper"
require "script/module/switch/SwitchModel"

-- 资源文件--
local equipDrop = "ui/equip_guide.json" 
-- UI控件引用变量 --
local m_fnGetWidget     			=  g_fnGetWidgetByName 
-- 模块局部变量 --
local m_qulityColor  =  g_QulityColor
local m_listview
local copyDatas
local equipDetail 
local txtTip  
local m_i18n = gi18n
local visibleViews = CCArray:create()
local layBg
local equipTid
local dropReturnInfo 

local function init(...)

end

function destroy(...)
	package.loaded["MainEquipDropView"] = nil
end

function moduleName()
    return "MainEquipDropView"
end

-- add effect and value of widget  
local function appendEffect( layBg )
  local tfdZizhi                 =    m_fnGetWidget(layBg , "tfd_quality")   
  local tfd_get                  =    m_fnGetWidget(layBg , "tfd_get")   
  --local tfd_can_recruit          =    m_fnGetWidget(layBg , "tfd_can_recruit")  
  local tfd_txt                  =    m_fnGetWidget(layBg , "TFD_TXT") 
  local tfd_title                =    m_fnGetWidget(layBg , "tfd_title") 
  
  tfdZizhi:setText(m_i18n[4901])   -- 品级
  tfd_get:setText(m_i18n[1096])    -- 集齐
  --tfd_can_recruit:setText(m_i18n[4902])  -- 个可以合成
  tfd_txt:setText(m_i18n[4903])          -- 暂不由副本，探索和神秘商店产出！
  UIHelper.labelShadowWithText(tfd_title,m_i18n[1098])  -- 获取途径
  
end



--[[desc:只显示对应类型的相关数据类
    _cell: 要修改的cell
    _tag : 要显示的tag， 1-据点，2-精英，3-探索，4-神秘商店，5-竞技商店
    return: 是否有返回值，返回值说明  
—]]
local function fnOnlyShowOne(_cell , _tag)
  local pName = {"lay_stronghold" , "lay_elite" , "lay_explore" , "lay_mysterious_shop"}

  for i=1,4 do
     local pPart = nil
    if(i == _tag) then
      pPart = m_fnGetWidget(_cell , pName[i]) or nil
      if(pPart) then
        pPart:setVisible(true)
      end
    else
      pPart = m_fnGetWidget(_cell , pName[i]) or nil
      if(pPart) then
        pPart:setVisible(false)
      end
    end
  end
end

--[[desc:获取cell通用
    _cell: 要修改的cell
    return: cell按钮 、 未开启 、 前往
—]]
local function fnGetCellNormal(_cell)
  local pBtn = m_fnGetWidget(_cell,"BTN_CELL") or nil
  local notOpen = m_fnGetWidget(_cell,"TFD_TIPS_NO_OPEN") or nil
  local alreadyOpen = m_fnGetWidget(_cell,"IMG_TIPS_GO") or nil
  return pBtn , notOpen , alreadyOpen
end



--z装入listview 里面的数据
local function refreshListView()

  local cell =  0  
  local nIdx = -1
  m_listview:removeAllItems() -- 初始化清空列表

  -- 1. 据点
  local dataArray = string.split(equipDetail.dropStrongHold, ",") or nil
  if(dataArray and #dataArray > 0) then
      txtTip:setVisible(false)


      local copy 
      local strongHold
      for i=1,#dataArray do
        logger:debug("have judian")

        local data = string.split(dataArray[i], "|")
        strongHold = DB_Stronghold.getDataById(data[1] )
        copy  =  DB_Copy.getDataById(strongHold.copy_id)
        local fightTimesArray = string.split(strongHold.fight_times,"|")        
        m_listview:pushBackDefaultItem() 
        nIdx = nIdx + 1
        cell = m_listview:getItem(nIdx)  -- cell 索引从 0 开始


        fnOnlyShowOne(cell,1)
        local btnCell,notOpen,alreadyOpen = fnGetCellNormal(cell)

        local copyName = m_fnGetWidget(cell,"TFD_COPY_NAME")
        local strongHoldName = m_fnGetWidget(cell,"TFD_STRONGHOLD_NAME")
        local holeIcon = m_fnGetWidget(cell,"IMG_STRONGHOLD_HEAD")
        local heroBg = m_fnGetWidget(cell,"img_stronghold_head_bg")
        local fightTimes = m_fnGetWidget(cell,"TFD_OWN_TIMES")
        local fightAllTimes = m_fnGetWidget(cell,"TFD_TOTAL_TIMES")
        local TFD_SIMPLE = m_fnGetWidget(cell,"TFD_SIMPLE")
        local TFD_HARD = m_fnGetWidget(cell,"TFD_HARD")


        local tfd_stronghold = m_fnGetWidget(cell,"tfd_stronghold")
        tfd_stronghold:setText(m_i18n[4906])
        local tfd_stronghold_times = m_fnGetWidget(cell,"tfd_stronghold_times")
        tfd_stronghold_times:setText(m_i18n[4907])
        -- local tfd_ci = m_fnGetWidget(cell,"tfd_ci")
        -- tfd_ci:setText(m_i18n[4909])
        TFD_SIMPLE:setText(m_i18n[4904])
        TFD_HARD:setText(m_i18n[4905])  -- 苦难

        if(tonumber(data[2]) == 1) then
          TFD_HARD:setVisible(false)
        else 
          TFD_SIMPLE:setVisible(false)
        end

        -- copyName.labelEffect(copyName , copy.name  .."("..  getCopyType(data[2]) .. ")")
        -- copyName:loadTexture("images/common/guild_treasure/shadow_guide_copy".. copy.id .. ".png")
        copyName:setText(copy.name)
        UIHelper.labelNewStroke(copyName,ccc3(0x5e,0x31,0x00))

        holeIcon:loadTexture("images/base/hero/head_icon/".. strongHold.icon)
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
                    local runningScene = CCDirector:sharedDirector():getRunningScene()
                    require "script/module/public/DropUtil"
                    local curModule = LayerManager.curModuleName()
                    logger:debug({curModule=curModule})
                    DropUtil.setSourceAndAim(curModule,curModule)
                    if (dropReturnInfo) then
                          local curModuleName = LayerManager.curModuleName()
                          DropUtil.insertRefreshInfo(curModuleName,"refreshInfo",dropReturnInfo)
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
  end

  -- 2. 精英
  local dataelite = string.split(equipDetail.dropelite, "|") or nil
  if(dataelite and #dataelite > 0) then
    
      txtTip:setVisible(false)
      
      local eliteCopyDatas = DataCache.getEliteCopyData()

      --[[desc:检测精英本是否开启
          arg1: 精英本id
          return: 是否有返回值，返回值说明  
      —]]
      local function checkEliOpen( _eliteID )
          if (not eliteCopyDatas) then
            return false
          end
          if (not eliteCopyDatas.va_copy_info) then
            return false
          end
          local progress = eliteCopyDatas.va_copy_info.progress or nil
          if (not progress) then
            return false
          end
          local pStates =  progress[tostring(_eliteID)] or nil
          if (not pStates or tonumber(pStates) < 1 ) then
            return false
          end
          return true
      end

      for i=1,#dataelite do
          m_listview:pushBackDefaultItem() 
          nIdx = nIdx + 1
          cell = m_listview:getItem(nIdx)

          local copy = DB_Elitecopy.getDataById(dataelite[i])

          fnOnlyShowOne(cell , 2)
          local btnCell,notOpen,alreadyOpen = fnGetCellNormal(cell)


          local copyName = m_fnGetWidget(cell,"TFD_ELITE_NAME")
          local holeIcon = m_fnGetWidget(cell,"IMG_COPY_ELITE")
          local fightTimes = m_fnGetWidget(cell,"TFD_OWN_ELITE")
          local fightAllTimes = m_fnGetWidget(cell,"TFD_TOTAL_ELITE")
          -- local tfd_ci = m_fnGetWidget(cell,"tfd_ci")
          local tfd_stronghold_times = m_fnGetWidget(cell,"tfd_stronghold_times")
          --local tfd_elite = m_fnGetWidget(cell,"tfd_elite")

          -- tfd_ci:setText(m_i18n[4909])
          tfd_stronghold_times:setText(m_i18n[4907])
          --tfd_elite:setText(m_i18n[4913])

          local pNum = tonumber(dataelite[i]) or 0
          pNum = pNum - 200000
          -- copyName:loadTexture("images/common/guild_armFragement/shadow_guide_copy".. copy.thumbnail)
          copyName:setText(copy.name)
          UIHelper.labelNewStroke(copyName,ccc3(0x5e,0x31,0x00)) 

          holeIcon:loadTexture("images/common/guild_copy_img/treasure_copy".. pNum .. ".png")

          local stauts = 3
          local attNum = DataCache.getEliteCopyLeftNum()

          if (not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy)) then
              attNum = 3
              fightTimes:setText(attNum)
              fightAllTimes:setText(stauts)
              alreadyOpen:setVisible(false)
              notOpen:setVisible(true) 
              btnCell:addTouchEventListener(function ( sender, eventType )
                if eventType == TOUCH_EVENT_ENDED then
                    SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,true)
                end
              end)
          else
              if (checkEliOpen(dataelite[i]))then
                  fightTimes:setText(attNum)
                  fightAllTimes:setText(stauts)
                  alreadyOpen:setVisible(true)
                  notOpen:setVisible(false) 
                  btnCell:addTouchEventListener(function ( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                      MainCopy.enterToEliteCopyBase(dataelite[i])
                    end
                  end)
              else
                  fightTimes:setText(attNum)
                  fightAllTimes:setText(stauts)
                  alreadyOpen:setVisible(false)
                  notOpen:setVisible(true) 
                  btnCell:addTouchEventListener(function ( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                      require "script/module/public/ShowNotice"
                      ShowNotice.showShellInfo(m_i18n[4914])
                    end
                  end)
              end
          end
      end
  end
  

  -- 3. 探索
  local dataExplore = string.split(equipDetail.dropexplore, "|") or nil
  if(dataExplore and #dataExplore > 0) then

      txtTip:setVisible(false)

      local exploreDatas = DataCache:getExploreInfo()


      for i=1,#dataExplore do

          
          m_listview:pushBackDefaultItem() 
          nIdx = nIdx + 1
          cell = m_listview:getItem(nIdx)

          fnOnlyShowOne(cell , 3)
          local btnCell,notOpen,alreadyOpen = fnGetCellNormal(cell)

          local copyName = m_fnGetWidget(cell,"TFD_EXPLORE_NAME")
          local holeIcon = m_fnGetWidget(cell,"IMG_COPY_ICON")
          local showinfo = m_fnGetWidget(cell,"TFD_EXPLORE_INFO")
          local tfd_explore = m_fnGetWidget(cell,"tfd_explore")
        
          tfd_explore:setText(m_i18n[4912])

          local copy = DB_Copy.getDataById(dataExplore[i])
          local entranceID = copy.entrance_id
          local s = string.format(m_i18n[4911],copy.name)
          showinfo:setText(s)

          -- copyName:loadTexture("images/common/guild_treasure/shadow_guide_copy".. dataExplore[i] .. ".png")
          copyName:setText(copy.name)
          UIHelper.labelNewStroke(copyName,ccc3(0x5e,0x31,0x00))
          holeIcon:loadTexture("images/common/guild_copy_img/treasure_copy".. entranceID .. ".png")


          if(not SwitchModel.getSwitchOpenState(ksSwitchExplore)) then
              alreadyOpen:setVisible(false)
              notOpen:setVisible(true) 
              btnCell:addTouchEventListener(function ( sender, eventType )
                  if eventType == TOUCH_EVENT_ENDED then
                    SwitchModel.getSwitchOpenState(ksSwitchExplore,true)
                  end
              end)
          else
              local pExpOpen = MainCopy.getCrossEntrance(entranceID)
              -- local pExpOpen = MainCopy.getCrossEntrance(dataExplore[i])
              if (pExpOpen) then
                  alreadyOpen:setVisible(true)
                  notOpen:setVisible(false) 
                  btnCell:addTouchEventListener(function ( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                      require "script/module/public/DropUtil"
                      if (dropReturnInfo) then
                          local curModuleName = LayerManager.curModuleName()
                          DropUtil.insertRefreshInfo(curModuleName,"refreshInfo",dropReturnInfo)
                      end

                      local funcall = DropUtil.getReturn
                      MainCopy.enterToExploreBase(dataExplore[i],funcall)
                    end
                  end)
              else
                  alreadyOpen:setVisible(false)
                  notOpen:setVisible(true) 
                  btnCell:addTouchEventListener(function ( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                      require "script/module/public/ShowNotice"
                      ShowNotice.showShellInfo(m_i18n[4915])
                    end
                  end)
              end
          end

         
      end
  end



  -- 4. 神秘商店
  local mystical = equipDetail.ismystery
  if (tostring(mystical) == "1") then 

      txtTip:setVisible(false)
  
      nIdx = nIdx + 1
      m_listview:pushBackDefaultItem() 
      cell = m_listview:getItem(nIdx)  -- cell 索引从 0 开始
      
      fnOnlyShowOne(cell , 4)
      local btnCell,notOpen,alreadyOpen = fnGetCellNormal(cell)

      local tfd_mystery_info = m_fnGetWidget(cell,"tfd_mystery_info")
      tfd_mystery_info:setText(m_i18n[4910])
    
        
      if(not SwitchModel.getSwitchOpenState(ksSwitchResolve)) then
          notOpen:setVisible(true)
          alreadyOpen:setVisible(false) 
          btnCell:addTouchEventListener(function ( sender, eventType )
              if eventType == TOUCH_EVENT_ENDED then
                SwitchModel.getSwitchOpenState(ksSwitchResolve,true)
              end
          end) 
      else
          notOpen:setVisible(false)
          alreadyOpen:setVisible(true)
          btnCell:addTouchEventListener(function ( sender, eventType  )
              if eventType == TOUCH_EVENT_ENDED then
                  require "script/module/wonderfulActivity/MainWonderfulActCtrl"
                  local act = MainWonderfulActCtrl.create("castle")
                  LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
              end
          end)
      end      
  end


end

function resetEquipOwnNum( ... )
  if (layBg) then
      local curNum = DataCache.getEquipFragNumByItemTmpid(equipTid)
      local tfdOwnNum        =   m_fnGetWidget(layBg,"TFD_NUM_OWN")
      tfdOwnNum:setText(curNum)
  -- else
  --     require "script/module/public/DropUtil"
  --     local returnInfo = DropUtil.getReturnInfo()
  --     MainEquipDropCtrl.create(returnInfo.itemInfo)
  end
end


function create(equipInfo,returnInfo)
    if (returnInfo) then
        dropReturnInfo = returnInfo
        local curModuleName = LayerManager.curModuleName()
        DropUtil.insertRefreshInfo(curModuleName,"refreshInfo",dropReturnInfo)
    end

    logger:debug({equipInfo=equipInfo})
	  copyDatas = DataCache.getNormalCopyData().copy_list
    equipTid = equipInfo.tid
	  equipInfo 					   =   equipInfo.selectEquip
    layBg 				   = 	 g_fnLoadUI(equipDrop)
    local btnClose 				 =   m_fnGetWidget(layBg,"BTN_CLOSE")
    local equipFragName		 =   m_fnGetWidget(layBg,"TFD_SHADOW_NAME")
    local zizhi 				   =   m_fnGetWidget(layBg,"TFD_QUALITY_NUM")
    --local totalNum				 =   m_fnGetWidget(layBg,"TFD_NUM")
    local iconBag 				 =   m_fnGetWidget(layBg,"IMG_ICON_BG")
    local equipIcon 			 =   m_fnGetWidget(layBg,"IMG_ICON")
    --local equipName         =   m_fnGetWidget(layBg,"TFD_EQUIP_NAME")
    local layText          =   m_fnGetWidget(layBg , "lay_txt") 
    txtTip                 =   m_fnGetWidget(layBg,"TFD_TXT")
    local tfdOwnNum        =   m_fnGetWidget(layBg,"TFD_NUM_OWN")
    local tfdOGroupNum     =   m_fnGetWidget(layBg,"TFD_NUM_GROUP")
    local tfd_title        =    m_fnGetWidget(layBg , "tfd_title") 



    equipDetail            =   DB_Item_fragment.getDataById(equipInfo.tid)

    m_listview 			       =   m_fnGetWidget(layBg,"LSV_LIST")
    
 
    layText:setVisible(true)

    --appendEffect(layBg)
    equipFragName:setText(equipDetail.name)
    equipFragName:setColor(g_QulityColor[equipDetail.quality])
    --UIHelper.labelStroke(equipName)
    local curNum = DataCache.getEquipFragNumByItemTmpid(equipInfo.tid)
    local maxNum = equipDetail.need_part_num

    tfdOwnNum:setText(curNum)
    tfdOGroupNum:setText(maxNum)
    UIHelper.labelShadowWithText(tfd_title,m_i18n[1098])  -- 获取途径
    UIHelper.labelNewStroke(tfd_title,ccc3(0x7c,0x4f,0x32))



    local LAY_NAME_CENTER = m_fnGetWidget(layBg , "LAY_NAME_CENTER")
    local LAY_NAME = m_fnGetWidget(layBg , "LAY_NAME")
    local tfd_frag = m_fnGetWidget(layBg , "tfd_frag")
    tfd_frag:setColor(g_QulityColor[equipDetail.quality])
    local pWidth = equipFragName:getContentSize().width + tfd_frag:getContentSize().width 
    LAY_NAME:setPositionType(2)
    LAY_NAME:setPositionX(LAY_NAME_CENTER:getContentSize().width*0.5 - pWidth*0.5)

      
    iconBag:loadTexture("images/base/potential/color_".. equipDetail.quality .. ".png")
    equipIcon:loadTexture("images/base/equip/small/" .. equipDetail.icon_small)
    local imgBorder = ImageView:create()
    imgBorder:loadTexture("images/base/potential/equip_".. equipDetail.quality .. ".png")
    equipIcon:addChild(imgBorder)

    -- zizhi:setText(equipDetail.sScore)
    local aimItem = equipDetail.aimItem
    local aimArmDB = DB_Item_arm.getDataById(aimItem)
    zizhi:setText(aimArmDB.base_score)
    -- totalNum:setText(equipInfo.maxNum)
    UIHelper.initListView(m_listview) 
    
    -- UIHelper.labelEffect(equipName , equipInfo.name)
    -- equipName:setColor(g_QulityColor[equipInfo.nQuality])

    local img_desc_bg = m_fnGetWidget(layBg,"img_desc_bg")
    --local tfd_get = m_fnGetWidget(layBg,"tfd_get")
    --local tfd_can_recruit = m_fnGetWidget(layBg,"tfd_can_recruit")
    --pWidth = tfd_get:getContentSize().width + totalNum:getContentSize().width + tfd_can_recruit:getContentSize().width + equipName:getContentSize().width
    layText:setPositionType(2)
    --layText:setPositionX( - pWidth*0.5)
    
    refreshListView()

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
       return "简单"
    elseif (tonumber(nType) == 2) then
       return "困难"
    elseif (tonumber(nType) == 3) then
       return "精英"
    end
end