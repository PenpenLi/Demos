-- FileName: DropLVUtil.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

DropLVUtil = class("DropLVUtil",StuffDrop)
-- UI控件引用变量 --
-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n

-- 模块局部变量 --
function DropLVUtil:ctor( ... )
    self.mainLayout =  g_fnLoadUI("ui/property_getway.json")
    self.refLsv = self.mainLayout.LSV_LIST
	-- body
end

-- dropListBg 引导界面的主画布
-- guidStuffDB   引导物品的DB信息
-- copyType   副本类型 1 主副本 2 觉醒副本
function DropLVUtil:create( dropListBg,GuidInfo,copyType,DropCallback )
	self.dropListBg = dropListBg
	self.mListView = dropListBg.LSV_LIST
	self.guidStuffDB = GuidInfo.guidStuffDB
    self.stuffTid = GuidInfo.stuffTid
	self.copyType = copyType
    self.DropCallback = DropCallback

    self:initMaps()
    require "script/module/public/UIHelper"
    -- listview 初始化，设置默认cell
    -- UIHelper.initListViewByRefLsv(self.mListView,self.refLsv) 
    local refCell = assert(self.refLsv:getItem(0), "refCell of " .. self.refLsv:getName() .. " is nil") -- 获取编辑器中的默认cell
    self.refCell = refCell
    self.noPassCellTb = {}

	self:createListView()
end

-- 初始化副本据点DB信息
function DropLVUtil:initCopyData( strongHoldFeild,copyType )
    local DBReference
    local copyDatas 
    if (copyType == 1) then
       copyDatas = DataCache.getNormalCopyData().copy_list
       DBReference = DB_Copy
    elseif (copyType == 2)  then
       copyDatas = DataCache.getAwakeCopyData().copy_list
       DBReference = DB_Disillusion_copy
    end
    self.copyDatas = copyDatas
    self.DBReference = DBReference

    local strongHolds = string.split(strongHoldFeild, ",") 
    local tbStrongHoldsInfo = {}
    for i,v in ipairs(strongHolds) do
        local strongHoldsInfo = {}
        local strongHoldTb = string.split(v, "|")
        local strongHoldDB = DB_Stronghold.getDataById(strongHoldTb[1] )
        local copyDB = DBReference.getDataById(strongHoldDB.copy_id)
        strongHoldsInfo.strongHoldTb = strongHoldTb
        strongHoldsInfo.strongHoldDB = strongHoldDB
        strongHoldsInfo.copyDB = copyDB
        table.insert( tbStrongHoldsInfo, strongHoldsInfo )
    end
    self.tbStrongHoldsInfo = tbStrongHoldsInfo
end



-- 检查可以攻打的剩余次数
local function checkeLeftTimes( copyDatas,strongHoldTb, strongHoldDB,copyDB,copyType)
    local fightTimesArray = string.split(strongHoldDB.fight_times,"|")    
    logger:debug({fightTimesArray=fightTimesArray})    
    local totalTimes  = fightTimesArray[2]
    local leftTimes = fightTimesArray[2]
    local canGo = false

    if (copyDatas["".. copyDB.id] ~= nil)  then
        if (copyType == 1)  then
            totalTimes = fightTimesArray[tonumber(strongHoldTb[2])]
            leftTimes = totalTimes
            local  stauts , attNum = battleMonster.fnGetAttedInfoForYing(strongHoldTb[1],copyDatas[""..copyDB.id].va_copy_info,strongHoldTb[2])
            leftTimes =  (tonumber(stauts) >=2) and attNum or totalTimes
            canGo = tonumber(stauts) >=2

        elseif (copyType == 2) then
            totalTimes = tonumber(fightTimesArray[1])
            leftTimes = totalTimes
            leftTimes = copyAwakeModel.getHoldAttackInfo(copyDB.id,strongHoldTb[1])
            local stauts = copyAwakeModel.getStrongHoldStatus(copyDB.id,strongHoldTb[1])
            logger:debug({checkeLeftTimes = stauts})
            logger:debug({checkeLeftTimes_leftTimes = leftTimes})
            canGo = stauts ~= -1 
        end
    else
        totalTimes = tonumber(fightTimesArray[1])
        leftTimes = totalTimes
        canGo = false
    end
    return totalTimes,leftTimes,canGo

end 

function getCopyType( nType )
    if (tonumber(nType) == 1) then
       return m_i18n[4904]
    elseif (tonumber(nType) == 2) then
       return m_i18n[4905]
    elseif (tonumber(nType) == 3) then
       return m_i18n[4917]

    end
    return m_i18n[4904]
end


-- 据点
function DropLVUtil:creatStrongHold(mListView, initIndex ,strongHoldFeild,copyType)
    self:initCopyData(strongHoldFeild,copyType)

    local copyDatas = self.copyDatas
    local tbStrongHoldsInfo = self.tbStrongHoldsInfo 

    local refCell = self.refCell
    local mListView = self.mListView

	local cellNUms = 0
	for i,v in ipairs(tbStrongHoldsInfo) do
		local strongHoldTb = v.strongHoldTb
		local strongHoldDB = v.strongHoldDB
        local copyDB = v.copyDB

        -- mListView:pushBackDefaultItem() 
        initIndex = initIndex + 1
        cellNUms = cellNUms + 1
        -- local holdCell = mListView:getItem(initIndex -  1)  -- cell 索引从 0 开始
        local holdCell = refCell:clone()

        -- 探索描述隐藏
        local tfdDes = holdCell.tfd_des
        tfdDes:setVisible(false)
        local imgGetwayFrame = holdCell.img_getway_frame
        imgGetwayFrame:loadTexture("ui/activity_frame_bg.png")
        --
        local holeIcon  = holdCell.IMG_GETWAY_ICON
        holeIcon:loadTexture("images/base/hero/head_icon/".. strongHoldDB.icon)
        --
        local imgBOTTOM  = holdCell.IMG_BOTTOM
        imgBOTTOM:loadTexture("ui/activity_frame.png")

        -- 据点名字
        local tfdCopyName = holdCell.TFD_GETWAY_NAME
        tfdCopyName:setText(copyDB.name)
        UIHelper.labelNewStroke(tfdCopyName,ccc3(0x5e,0x31,0x00))

        -- 据点等级(简单 普通 困难)
        local tfdCopyLevle = holdCell.TFD_LEVEL
        if (#strongHoldTb >= 2) then
            tfdCopyLevle:setText(getCopyType(strongHoldTb[2]))
        else
            tfdCopyLevle:setEnabled(false)
        end
        -- 据点英雄名字
        local layStrongHoldName = holdCell.LAY_STRONGHOLD_NAME
        local tfdStrongHoldHeroName = layStrongHoldName.tfd_stronghold
        tfdStrongHoldHeroName:setText(m_i18n[4906])

        local tfdStrongHoldHeroName = layStrongHoldName.TFD_NAME
        UIHelper.labelEffect(tfdStrongHoldHeroName , strongHoldDB.name)
        -- 剩余次数
        local layHold = holdCell.LAY_ELITE_TIMES_FIT 
        local tfd_stronghold_times = layHold.tfd_stronghold_times 
    	tfd_stronghold_times:setText(m_i18n[4907])

        local tfdLefttimes = layHold.TFD_OWN_ELITE
        local tfdTotaltimes = layHold.TFD_TOTAL_ELITE

        local alreadyOpen = holdCell.BTN_DROP_GO
        local notOpen = holdCell.tfd_drop_nogo 
        local btnCell = holdCell.BTN_CELL


        local function refreshLeftTimesFn( ... )
            local totalTimesVale,leftTimesValue,canGo = checkeLeftTimes( copyDatas,strongHoldTb,strongHoldDB, copyDB,copyType)
            tfdLefttimes:setText(leftTimesValue)
        end 

        local totalTimesVale,leftTimesValue,canGo = checkeLeftTimes(copyDatas,strongHoldTb,strongHoldDB, copyDB,copyType)

        if ( canGo ) then
            tfdLefttimes:setText(leftTimesValue)
            tfdTotaltimes:setText(totalTimesVale)
            alreadyOpen:setEnabled(true)
            notOpen:setEnabled(false)

            local function goEvent( sender, eventType )
                 if eventType == TOUCH_EVENT_ENDED then 
                    AudioHelper.playCommonEffect()
                    local runningScene = CCDirector:sharedDirector():getRunningScene()
                    require "script/module/public/DropUtil"
                    local curModule = LayerManager.curModuleName()
                    DropUtil.setSourceAndAim(curModule,curModule)

                    local DropCallback =  self.DropCallback
                    if (DropCallback) then
                        DropCallback()
                    end

                    local refreshOwnFragNumFn = function ( ... )
                        refreshLeftTimesFn()

                    end

                    local curModuleName = LayerManager.curModuleName()
                    DropUtil.insertCallFn(curModuleName,refreshOwnFragNumFn)

                    local callback = function ( )   -- 从副本回到影子列表的方法回调
                        DropUtil.getReturn(curModule)
                        -- 去据点用的是Addlayout方法 所有返回来的时候模块名字要改回来
                        LayerManager.setCurModuleName(curModule)
                    end

                    if (copyType == 1) then
                        MainCopy.heroFragToCopyBase(copyDB.id,strongHoldTb[1],copyDatas["".. copyDB.id],strongHoldTb[2],callback)
                    elseif (copyType == 2) then
                        require "script/module/copyAwake/copyAwakeCtrl"
                        copyAwakeCtrl.enterCopyAndBase(copyDB.id,strongHoldTb[1],callback)
                    end

                end
            end 

            btnCell:addTouchEventListener(goEvent)
            alreadyOpen:addTouchEventListener(goEvent)
            mListView:pushBackCustomItem(holdCell)

        else 
            alreadyOpen:setEnabled(false)
            notOpen:setEnabled(true) 
            tfdLefttimes:setText(leftTimesValue) 
            tfdTotaltimes:setText(totalTimesVale)

            local function ShowWarningNotice( sender, eventType )
                if eventType == TOUCH_EVENT_ENDED then
                   require "script/module/public/ShowNotice"
                   AudioHelper.playCommonEffect()
                   ShowNotice.showShellInfo(gi18nString(1918))
                end
            end 

            btnCell:addTouchEventListener(ShowWarningNotice)
            table.insert(self.noPassCellTb,holdCell)
        end

	end
	return cellNUms

end

--[[desc:检测精英本是否开启
          arg1: 精英本id
          return: 是否有返回值，返回值说明  
      —]]
local function checkEliOpen( eliteCopyDatas,_eliteID )
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



-- 精英
function DropLVUtil:creatElit( mListView,initIndex ,strongHoldFeild)

	local cellNUms = 0
	local dataelite = string.split(strongHoldFeild, "|") 

    local eliteCopyDatas = DataCache.getEliteCopyData()
    local refCell = self.refCell
    local mListView = self.mListView

	for i=1,#dataelite do
        -- mListView:pushBackDefaultItem() 
        initIndex = initIndex + 1
        cellNUms = cellNUms + 1
        -- local elitCell = mListView:getItem(initIndex -  1)
        local elitCell = refCell:clone()

        local copyDB = DB_Elitecopy.getDataById(dataelite[i])

         -- 探索描述隐藏
        local tfdDes = elitCell.tfd_des
        tfdDes:setVisible(false)
        local tfdCopyLevle = elitCell.TFD_LEVEL
        tfdCopyLevle:setVisible(false)
        --
        local imgGetwayFrame = elitCell.img_getway_frame
        imgGetwayFrame:setEnabled(false)
        -- imgGetwayFrame:loadTexture("ui/activity_frame_bg.png")
        local holeIcon  = elitCell.IMG_GETWAY_ICON
        holeIcon:loadTexture("images/copy/ncopy/entranceimage/normalImg/".. "copy_n_" .. copyDB.thumbnail)
        holeIcon:setScale(0.5)
        --
        local imgBOTTOM  = elitCell.IMG_BOTTOM
        imgBOTTOM:setEnabled(false)
        -- imgBOTTOM:loadTexture("ui/activity_frame.png")

        local tfdCopyName = elitCell.TFD_GETWAY_NAME
        tfdCopyName:setText(copyDB.name)
        UIHelper.labelNewStroke(tfdCopyName,ccc3(0x5e,0x31,0x00))
        -- 据点名字
        local tfdStrongHoldHeroName = elitCell.TFD_NAME
        UIHelper.labelEffect(tfdStrongHoldHeroName , copyDB.name)

         -- 剩余次数
        local layHold = elitCell.LAY_ELITE_TIMES_FIT 
        local tfd_stronghold_times = layHold.tfd_stronghold_times
    	tfd_stronghold_times:setText(m_i18n[4907])

        local tfdLefttimes = layHold.TFD_OWN_ELITE
        local tfdTotaltimes = layHold.TFD_TOTAL_ELITE 

        local alreadyOpen = elitCell.BTN_DROP_GO
        local notOpen = elitCell.tfd_drop_nogo 
        local btnCell = elitCell.BTN_CELL


        local stauts = 3
        local attNum = DataCache.getEliteCopyLeftNum()

        local function getSwitchOpen( sender, eventType )
            if eventType == TOUCH_EVENT_ENDED then
                AudioHelper.playCommonEffect()
               SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,true)
            end
        end 

        local function enterToExploreBase( sender, eventType )
             if eventType == TOUCH_EVENT_ENDED then
                AudioHelper.playCommonEffect()
                MainCopy.enterToEliteCopyBase(dataelite[i])
            end
        end 

        local function ShowWarningNotice( sender, eventType )
            if eventType == TOUCH_EVENT_ENDED then
               require "script/module/public/ShowNotice"
               AudioHelper.playCommonEffect()
               ShowNotice.showShellInfo(m_i18n[4914])
            end
        end 

        if (not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy)) then
            attNum = 3
            tfdLefttimes:setText(attNum)
            tfdTotaltimes:setText(stauts)
            alreadyOpen:setEnabled(false)
            notOpen:setEnabled(true) 
            btnCell:addTouchEventListener(getSwitchOpen)
       	else
            if (checkEliOpen(eliteCopyDatas,dataelite[i]))then
                tfdLefttimes:setText(attNum)
                tfdTotaltimes:setText(stauts)
                alreadyOpen:setEnabled(true)
                notOpen:setEnabled(false) 
                alreadyOpen:addTouchEventListener(enterToExploreBase)
                btnCell:addTouchEventListener(enterToExploreBase)
            else
                tfdLefttimes:setText(attNum)
                tfdTotaltimes:setText(stauts)
                alreadyOpen:setEnabled(false)
                notOpen:setEnabled(true) 
                alreadyOpen:addTouchEventListener( ShowWarningNotice )
                btnCell:addTouchEventListener( ShowWarningNotice )
            end
        end
    end
    return cellNUms
end

-- 探索
function DropLVUtil:createExplor(mListView, initIndex ,dropEliteFeild)
	local cellNUms = 0
	local dataExplore = string.split(dropEliteFeild, "|") 
    local exploreDatas = DataCache:getExploreInfo()

    local refCell = self.refCell
    local mListView = self.mListView

    for i=1,#dataExplore do
        -- mListView:pushBackDefaultItem() 
        initIndex = initIndex + 1
        cellNUms = cellNUms + 1
        -- local explorCell = mListView:getItem(initIndex -  1)
        local explorCell = refCell:clone()

        local copyDB = DB_Copy.getDataById(dataExplore[i])
        -- 据点信息隐藏
        local tfd_stronghold = explorCell.tfd_stronghold
        tfd_stronghold:setVisible(false)
        local TFD_NAME = explorCell.TFD_NAME
        TFD_NAME:setVisible(false)
        local TFD_OWN_ELITE = explorCell.TFD_OWN_ELITE
        TFD_OWN_ELITE:setVisible(false)
        local tfd_slant = explorCell.tfd_slant
        tfd_slant:setVisible(false)
        local TFD_TOTAL_ELITE = explorCell.TFD_TOTAL_ELITE
        TFD_TOTAL_ELITE:setVisible(false)
        local tfd_stronghold_times = explorCell.tfd_stronghold_times
        tfd_stronghold_times:setVisible(false)
        local tfdCopyLevle = explorCell.TFD_LEVEL
        tfdCopyLevle:setVisible(false)
        local imgGetwayFrame = explorCell.img_getway_frame
        imgGetwayFrame:setEnabled(false)
        -- 据点名字
        local tfdCopyName = explorCell.TFD_GETWAY_NAME
        tfdCopyName:setText(copyDB.name)
        UIHelper.labelNewStroke(tfdCopyName,ccc3(0x5e,0x31,0x00))
        -- 探索描述
        local entranceID = copyDB.id
        local showinfo = string.format(m_i18n[4911],copyDB.name)
        local tfdDes = explorCell.tfd_des
        tfdDes:setText(showinfo)
        -- 据点图标
        local holeIcon = explorCell.IMG_GETWAY_ICON
        holeIcon:loadTexture("images/common/guild_copy_img/treasure_copy".. copyDB.entrance_id .. ".png")
         -- 剩余次数
        local layElit = explorCell.LAY_ELITE_TIMES_FIT 

        local alreadyOpen = explorCell.BTN_DROP_GO
        local notOpen = explorCell.tfd_drop_nogo
        local btnCell = explorCell.BTN_CELL

        if(not SwitchModel.getSwitchOpenState(ksSwitchExplore)) then
            alreadyOpen:setEnabled(false)
            notOpen:setEnabled(true) 
            btnCell:addTouchEventListener(function ( sender, eventType )
                if eventType == TOUCH_EVENT_ENDED then
                    AudioHelper.playCommonEffect()
                    SwitchModel.getSwitchOpenState(ksSwitchExplore,true)
                end
            end)
            table.insert(self.noPassCellTb,explorCell)

        else
            local pExpOpen = MainCopy.fnCrossCopy(entranceID)
            logger:debug({entranceID=entranceID})
            if (pExpOpen) then
                alreadyOpen:setEnabled(true)
                notOpen:setEnabled(false) 

                local function getExplore( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                        AudioHelper.playCommonEffect()
                        require "script/module/public/DropUtil"

                        local DropCallback = self.DropCallback
                        if (DropCallback) then
                            DropCallback()
                        end

                        local refreshOwnFragFn = function ( ... )
  
                            -- self:refreshNum()
                        end

                        if (refreshOwnFragFn) then
                            local curModuleName = LayerManager.curModuleName()
                            DropUtil.insertCallFn(curModuleName,refreshOwnFragFn)
                        end

                        local funcall = DropUtil.getReturn
                        MainCopy.enterToExploreBase(dataExplore[i],funcall)
                    end
                end 
                btnCell:addTouchEventListener(getExplore )
                alreadyOpen:addTouchEventListener(getExplore )
                mListView:pushBackCustomItem(explorCell)
            else
                alreadyOpen:setEnabled(false)
                notOpen:setEnabled(true) 

                local function ShowWarningNotice( sender, eventType )
                    if eventType == TOUCH_EVENT_ENDED then
                        require "script/module/public/ShowNotice"
                        AudioHelper.playCommonEffect()
                        ShowNotice.showShellInfo(m_i18n[4915])
                    end
                end 
                btnCell:addTouchEventListener(ShowWarningNotice )
                table.insert(self.noPassCellTb,explorCell)
            end
        end
         
    end
    return cellNUms
end


function DropLVUtil:createListView( ... )
	local cellIndex = 0
	self.mListView:removeAllItems() -- 初始化清空列表

    -- 创建其他途径（功能模块）
    local dropMysteryFeild = self.guidStuffDB.item_getway

    if (dropMysteryFeild) then
        local getWays =  lua_string_split(dropMysteryFeild, "|")
        local addCellNums = self:createOtherSource(self.mListView,cellIndex,getWays)
        cellIndex = cellIndex + addCellNums
    end

	-- -- 创建副本引导

	local strongHoldFeild = self.guidStuffDB.dropStrongHold

	if (strongHoldFeild) then
		local addCellNums = self:creatStrongHold(self.mListView, cellIndex,strongHoldFeild,self.copyType or 1)
		cellIndex = cellIndex + addCellNums
	end

	-- 创建精英引导
	local dropEliteFeild = self.guidStuffDB.dropelite

	if (dropEliteFeild) then
		local addCellNums = self:creatElit(self.mListView,cellIndex,dropEliteFeild)
		cellIndex = cellIndex + addCellNums
	end

	-- 创建探索引导
	local dropExploreFeild = self.guidStuffDB.dropexplore

	if (dropExploreFeild) then
		local addCellNums = self:createExplor(self.mListView,cellIndex,dropExploreFeild)
		cellIndex = cellIndex + addCellNums
	end

    -- 插入没有开通的
    local noPassCellTb = self.noPassCellTb
    for i,v in ipairs(noPassCellTb) do
        self.mListView:pushBackCustomItem(v)
    end
    -- 

  	-- 是否有引导
    local dropListBg = self.dropListBg
    local  tfdTxt= dropListBg.TFD_TXT
	if ( cellIndex ~= 0 ) then
        logger:debug({tfdTxt=tfdTxt})
        tfdTxt:setVisible(false)
	else
        tfdTxt:setVisible(true)
        tfdTxt:setText(m_i18n[7201])
    end
end
-----------------------------------------------------------------------------------------------------------------------------------
function getPicPath( v )
    local tbWonderfullAct = {1,2,5,21,22,28}  -- "images/wonderfullAct/"
    local tbProps = {3,23}                       -- "images/base/props/"
    local tbAcopy = {17}                      -- "images/copy/acopy/"
    local tbDrop = {}
    local function tableContain( numTable,num )
        for i,v in ipairs(numTable) do
            if (tonumber(num) == tonumber(v)) then
                return true
            end
        end
        return false
    end
    if (tableContain(tbWonderfullAct,v)) then
        picPath =  "images/wonderfullAct/"
    elseif (tableContain(tbProps,v)) then
        picPath =  "images/base/props/"
    elseif (tableContain(tbAcopy,v)) then
        picPath =  "images/copy/acopy/"
    else
        picPath =  "images/drop/"
    end
    
    return picPath
end

-- 检查该引导是否需要被插进去
function checkIsInsert( sourceType )
    local canInsert = true
    if (tonumber(sourceType) == 21) then -- 开发礼包
        canInsert = AccSignModel.accIconNeedShow()
    elseif (tonumber(sourceType) == 22) then -- 等级礼包
        canInsert = LevelRewardCtrl.getCurRewardInfo()
    end 
    return canInsert
end


function DropLVUtil:createOtherSource( mListView,cellIndex,getWays )
    require "db/DB_Getway"
    local sourceNums = 0
    local refCell = self.refCell
    local mListView = self.mListView

    for i,v in ipairs(getWays) do
        local sourceType = tonumber(v) 
        local canInsert = checkIsInsert(sourceType)
        if (canInsert) then  -- 如果可以插进去
            logger:debug({getWays=sourceType})
            local sorurceDB = DB_Getway.getDataById(sourceType)
            -- mListView:pushBackDefaultItem() 
            cellIndex = cellIndex + 1
            sourceNums = sourceNums + 1

            -- local rowCell = mListView:getItem(cellIndex - 1)  
            local rowCell = refCell:clone()
            --
            local imgGetwayFrame = rowCell.img_getway_frame
            imgGetwayFrame:loadTexture("ui/activity_frame_bg.png")

            local imgGetWayIcon = rowCell.IMG_GETWAY_ICON 
            local picPath = getPicPath(v)
            imgGetWayIcon:loadTexture(picPath .. sorurceDB.getway_icon)

            local tfdGetWayName = rowCell.TFD_GETWAY_NAME 
            tfdGetWayName:setText(sorurceDB.getway_name)
            UIHelper.labelNewStroke(tfdGetWayName,ccc3(0x5e,0x31,0x00)) 

            local tfdDes = rowCell.tfd_des
            tfdDes:setText(sorurceDB.getway_desc)

            local pBtn = rowCell.BTN_CELL

            local btnDrop = rowCell.BTN_DROP_GO
            local btnNoGo = rowCell.tfd_drop_nogo 
            local PROPERTYSOURCETYPE = self.PROPERTYSOURCETYPE
            logger:debug({PROPERTYSOURCETYPE=PROPERTYSOURCETYPE})
            local dropType = PROPERTYSOURCETYPE[v]

            -- 隐藏装备，伙伴碎片部分UI
            local tfdLev = rowCell.TFD_LEVEL 
            tfdLev:setVisible(false)
            local tfdStrongHoldTimes = rowCell.tfd_stronghold_times 
            tfdStrongHoldTimes:setVisible(false)
            local layEleitTimesFit = rowCell.LAY_ELITE_TIMES_FIT
            layEleitTimesFit:setVisible(false)  
            local tfd_stronghold = rowCell.tfd_stronghold
            tfd_stronghold:setVisible(false)    
            local TFD_NAME = rowCell.TFD_NAME
            TFD_NAME:setVisible(false)

            local SwitchOpenState = self.SwitchOpenState
            local switchOpenState = SwitchOpenState[dropType]
            logger:debug({switchOpenState=switchOpenState})
            if (not switchOpenState) then
                break
            end
            local callFun =  switchOpenState.gofuncall
            local doSomeThing = (tonumber(sorurceDB.type) == 1) and true or false
            if (not doSomeThing) then
                btnDrop:setEnabled(false)
                btnNoGo:setVisible(false)
                table.insert(self.noPassCellTb,rowCell)
            else
                if (not switchOpenState.openState or SwitchModel.getSwitchOpenState(switchOpenState.openState)) then        -- 如果改模块功能开启
                    btnNoGo:setVisible(false)
                    btnDrop:setEnabled(true)

                    local function dropGuild( ... )
                        AudioHelper.playCommonEffect()
                        local DropCallback =  self.DropCallback
                        if (DropCallback) then
                            DropCallback()
                        end
                        callFun()
                    end

                    pBtn:addTouchEventListener(function (  sender, eventType )
                        if (eventType == TOUCH_EVENT_ENDED) then
                            dropGuild()
                        end
                    end)

                    btnDrop:addTouchEventListener(function (  sender, eventType )
                        if (eventType == TOUCH_EVENT_ENDED) then
                            dropGuild()
                        end
                    end)
                    mListView:pushBackCustomItem(rowCell)             
                else
                    btnDrop:setEnabled(false)
                    btnNoGo:setVisible(true)
                    pBtn:addTouchEventListener(function (  sender, eventType )
                        if (eventType == TOUCH_EVENT_ENDED) then
                            AudioHelper.playCommonEffect()
                            SwitchModel.getSwitchOpenState(switchOpenState.openState,true)
                            -- ShowNotice.showShellInfo( sorurceDB.getway_name ..  m_i18n[4316])   
                        end
                    end)
                    table.insert(self.noPassCellTb,rowCell)
                end
            end
        end
    end

    return sourceNums

end
