-- FileName: SkyPieaStrenthMain.lua
-- Author: liweidong
-- Date: 2015-02-27
-- Purpose: 空岛贝强化主界面
--[[TODO List]]

module("SkyPieaStrenthMain", package.seeall)
require "script/module/conch/ConchStrength/SkyPleaModel"

-- UI控件引用变量 --
local m_effPath = "images/effect"
local layoutMain
local m_getWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local mModel = SkyPleaModel
local mUI = UIHelper
local mItemUtil = ItemUtil
--local cellitem=nil
local listview=nil
-- 模块局部变量 --
local listData
local pageType
local conchData
local selectAllBtnStatus=1 --全选按钮状态 1为全选 0为取消全选

local addExpAllNum=0
local formationData={}
local ACT_TICK_TAG = 1000

------------add By wangming------------
local m_newConch
local m_selectNum
local isRunningAni
local waitToFresh
local mBlueProgress
local lvActing
local expActing
local zhizhenActing
local cellActing
local m_mainIcon
local m_levelChange
local backExp
local backLv
local cellActCount

local function init(...)
	backExp = 0
	backLv = 0
	m_levelChange = 0
	m_newConch = nil
	m_selectNum = 0
	addExpAllNum = 0
	isRunningAni = false
	waitToFresh = false
	lvActing = false
	expActing = false
	zhizhenActing = false
	cellActing = false
	cellActCount = 0
end

function destroy(...)
	package.loaded["SkyPieaStrenthMain"] = nil
end

function moduleName()
    return "SkyPieaStrenthMain"
end

--判断列表是否没有选择任何空岛贝
local function isEmptySelectConch()
	return m_selectNum == 0
end

--获取列表数量
local function getListCount()
	local listCount=math.modf(#listData/5)
	if (#listData%5~=0) then
		listCount=listCount+1
	end
	return listCount
end

--拼接动画文件路径字符串
local function fnGetAniName( str )
    return string.format("%s/%s/%s.ExportJson",m_effPath,str,str)
end

local function fnNeedWait( ... )
	if(lvActing or expActing) then
		return true
	end
	return false
end

local function showFlyAni( sender )
	local pPosSender = ccp(sender:getPositionX(),sender:getPositionY())
	local pStartPos = sender:getParent():convertToWorldSpace(pPosSender)
	local pSize = sender:getSize()
	local pTag = sender:getTag()
	local pSprite = mItemUtil.createBtnByTemplateId(listData[pTag].item_template_id)

	pSprite:setPositionX(pStartPos.x + pSize.width*0.5)
	pSprite:setPositionY(pStartPos.y + pSize.height*0.5)
	pSprite:setScale(0.8)
	layoutMain:addChild(pSprite)

	if(not m_FinalPos) then
		local pBg = m_getWidget(layoutMain, "img_progress_bg")
		local pPos = ccp(pBg:getPositionX(),pBg:getPositionY())
		m_FinalPos = pBg:getParent():convertToWorldSpace(pPos)
	end
	
	local pArr = CCArray:create()
	local pTime = 22/60
	local pmove = CCMoveTo:create(pTime,m_FinalPos)
	local pscale = CCScaleTo:create(pTime,0.3)
	local pSpawn = CCSpawn:createWithTwoActions(pmove,pscale)
	pArr:addObject(pSpawn)
	pArr:addObject(CCCallFuncN:create(
		function( ... )
			pSprite:removeFromParentAndCleanup(true)
		end))
	pSprite:runAction(CCSequence:create(pArr))
end

--Armature动画移除
local function overCallBack( armature,movementType,movementID )
    if(movementType == EVT_COMPLETE) then
        armature:removeFromParentAndCleanup(true)
    end
end 

--创建动画
local function fnCreateAni( strInfo, callback, keyFrame , ploop)
    local pName = strInfo.name
    if(not pName) then
    	return nil
    end
    local pPath = strInfo.path or pName
    local pAniName = strInfo.aniName or pName
    local pFilePath = string.format("images/effect/%s/%s.ExportJson", tostring(pPath), tostring(pName))
    local pAni = mUI.createArmatureNode({
        filePath = pFilePath,
        animationName = pAniName,
        loop = ploop or 0,
        fnMovementCall = callback or overCallBack,
        fnFrameCall = keyFrame,
    })
    return pAni
end

-- 强化成功显示等级动画
local function addAnimationLvAttr( ... )
    if(not m_levelChange or m_levelChange <= 0) then
    	lvActing = false
    	if(not fnNeedWait() and waitToFresh) then
        	resetAll()
        end
        return
    end

    local pAni
    local lv = m_levelChange
    local pName = ""
    local pNum100,pNum10,pNum1 = 0,0,0

    pNum100 = math.modf(lv/100) or 0
    local pr = lv - pNum100*100 or 0
    pNum10 =  math.modf(pr/10) or 0
    local pr2 = lv - pNum100*100 - pNum10*10 or 0
    pNum1 = pr2

    if( lv >= 100 ) then
        pName = "qh3_3_3"
    elseif( lv >= 10 ) then
        pName = "qh3_3_2"
    else
        pName = "qh3_3_1"
    end

    local function lvCallBack( armature,movementType,movementID )
	    if(movementType == EVT_COMPLETE) then
	        armature:removeFromParentAndCleanup(true)
	        lvActing = false
	        if(not fnNeedWait() and waitToFresh) then
	        	resetAll()
	        end
	    end
	end
	local pStrInfo = {name = "qh3_3", path = "forge/qh3_3", aniName = pName}
	pAni = fnCreateAni(pStrInfo,lvCallBack)

    local function changeNum( _boneName , _num )
        local mBone = pAni:getBone(_boneName)
        local numFile = string.format("images/effect/forge/number/no%d.png", _num)
        local ccSkin = CCSkin:create(numFile)
        ccSkin:setAnchorPoint(ccp(0.5, 0.5)) -- 设置锚点和强化动画的锚点一致
        mBone:addDisplay(ccSkin,0) -- 替换
    end

    if(lv >= 100) then
        changeNum("no9_2_Copy7",pNum100)
        changeNum("no9_Copy6",pNum10)
        changeNum("no9_Copy4",pNum1)
    elseif( lv >= 10 ) then
        changeNum("no9_2",pNum10)
        changeNum("no9",pNum1)
    else
        changeNum("no9_2",pNum1)
    end

    pAni:setPosition(ccp(g_winSize.width*0.5, g_winSize.height*0.7 - 100))
    layoutMain:addNode(pAni)
end

 -- 强化成功
local function addAnimationSuccess( )
	local function succFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
    	if(frameEventName == "1") then
	        addAnimationLvAttr()
	    end
	end

    AudioHelper.playEffect("audio/effect/texiao_jinjie_chenggong.mp3")
    local pStrInfo = {name = "qh3", path = "forge/qh3"}
	local pAni = fnCreateAni(pStrInfo,lvCallBack,succFrameCallBack)

    local visibleSize = CCDirector:sharedDirector():getVisibleSize()
    pAni:setAnchorPoint(ccp(0.5,0.5))
    pAni:setPosition(ccp(visibleSize.width*0.5, visibleSize.height*0.7))
    layoutMain:addNode(pAni,100)
end

--播放强化成功的光特效
local function addAnimationGuang(  )
	lvActing = true

	local function createZhiZhen( sender, call )
		local pPosSender = ccp(sender:getPositionX(),sender:getPositionY())
		local pRealPos = sender:getParent():convertToWorldSpace(pPosSender)
		local pStrInfo = {name = "jinjie_shuzi"}
		local pAni = fnCreateAni(pStrInfo,call)
		pAni:setPositionX(pRealPos.x)
		pAni:setPositionY(pRealPos.y)
		layoutMain:addNode(pAni)
	end

	local function guangFrameCallBack( bone,frameEventName,originFrameIndex,currentFrameIndex )
		if(frameEventName == "1") then
	       	--lv,number 数字光特效
	       	if(m_levelChange and m_levelChange > 0) then
	       		zhizhenActing = true
	       		local tfdLvEff = m_getWidget(layoutMain, "TFD_LEVEL_EFFECT")
				createZhiZhen(tfdLvEff)
				performWithDelay(layoutMain,function()
					local tfdAffixEff = m_getWidget(layoutMain, "TFD_AFFIX_EFFECT")
					createZhiZhen(tfdAffixEff,function ( ... )
						zhizhenActing = false
						local min , max = mModel.getExpOnConchUpgrade(m_newConch)
						updateNumBaseInfo(m_newConch)
					end)
				end,5/60)
	       	end
	    end
	end

	local function guangOverCallBack(  armature,movementType,movementID )
	    if(movementType == EVT_COMPLETE) then
	    	armature:removeFromParentAndCleanup(true)
	    	local arr = CCArray:create()
	    	arr:addObject(CCDelayTime:create(10/60))
	    	arr:addObject(CCCallFuncN:create(function( ... )
	    		addAnimationSuccess()
	    	end))
	    	layoutMain:runAction(CCSequence:create(arr))
	    end
	end 

    AudioHelper.playEffect("audio/effect/texiao01_qianghua.mp3")
    local pStrInfo = {name = "qh", path = "forge/UI_15"}
	local pAni = fnCreateAni(pStrInfo,guangOverCallBack,guangFrameCallBack)
    -- pAni:setPosition(m_mainIcon:getSize().width/2, m_mainIcon:getSize().height / 2)
    m_mainIcon:addNode(pAni)
end

local function addAnimationExp( ... )
	expActing = true

	local min , max = mModel.getExpOnConchUpgrade(conchData)
	local pNow = min / max * 100
	pNow = (pNow > 100) and 100 or pNow
	min , max = mModel.getExpOnConchUpgrade(m_newConch)
	local pNew = min / max * 100
	pNew = (pNew > 100) and 100 or pNew

	local expLeft = m_getWidget(layoutMain, "LABN_LEFT")
	expLeft:setVisible(false)
	local expRight = m_getWidget(layoutMain, "LABN_RIGHT")
	expRight:setVisible(false)
	local img_slant = m_getWidget(layoutMain, "img_slant")
	img_slant:setVisible(false)
	local haveExpBar = m_getWidget(layoutMain, "LOAD_PROGRESS_GREEN")
	haveExpBar:setVisible(false)
	local addLb = m_getWidget(layoutMain, "TFD_ADD")
	addLb:setVisible(false)

	mUI.fnPlayExpChangeAni(mBlueProgress, m_levelChange, pNow, pNew, function( ... )
		expActing = false
		if(not zhizhenActing) then
			updateNumBaseInfo(m_newConch)
			local expLeft = m_getWidget(layoutMain, "LABN_LEFT")
			expLeft:setVisible(true)
			local expRight = m_getWidget(layoutMain, "LABN_RIGHT")
			expRight:setVisible(true)
			local img_slant = m_getWidget(layoutMain, "img_slant")
			img_slant:setVisible(true)
		end
		if(not fnNeedWait() and waitToFresh) then
        	resetAll()
        end
        local mainLayout = layoutMain
        local img_max = m_getWidget(mainLayout, "img_max")
		img_max:setVisible(false)
		local pMaxlv = tonumber(mModel.getMaxLevel(conchData)) or 0
		if (tonumber(conchData.va_item_text.level) >= pMaxlv) then
			mainLayout.img_max:setVisible(true)
			mainLayout.img_slant:setVisible(false)
			mainLayout.LABN_LEFT:setVisible(false)
			mainLayout.LABN_RIGHT:setVisible(false)
			mainLayout.TFD_ADD:setVisible(false)
			mainLayout.TFD_LEVEL_EFFECT:setVisible(false)
			mainLayout.TFD_AFFIX_EFFECT:setVisible(false)
			mBlueProgress:setPercentage(100)
		end	--播放完动画必刷新 liweidong
	end)
end

--初始化列表数据
local function setListData()
	local tbConchs = DataCache.getBagInfo().conch
	local heroConch = mItemUtil.getConchFromHeroByItemId(conchData.item_id)
	if (heroConch) then
		conchData=heroConch
	else
		for _,v in pairs(tbConchs) do
			if v.item_id==conchData.item_id then
				conchData=v
			end
		end
	end
	
	listData={}
	local tmpData={}
	table.hcopy(tbConchs,tmpData)
	for _,v in pairs(tmpData) do
		v.chooseStatus=0
		v.addExp=mModel.getExpOfConchSuplly(v)
		if v.item_id~=conchData.item_id then
			table.insert(listData,v)
		end
	end
	-- conchData.itemDesc = DB_Item_conch.getDataById(conchData.item_template_id)
	-- conchData.itemDesc.desc = conchData.itemDesc.info
	mModel.sortStrengthConch(listData)
end

local function pLayCellAni( ... )
	isRunningAni = true

	addAnimationGuang()
	addAnimationExp()

	cellActCount = 0
	local function playCallback( ... )
		cellActCount = cellActCount - 1
		if(cellActCount > 0) then
			return
		end
		cellActing = false
		if(waitToFresh) then
			logger:debug("wm---CallbackOver")
			setListData()
			mUI.reloadListView(listview,getListCount(),updateCellByIdex)
		end
	end
	
	local pNumber = getListCount()-1
	for i=0, pNumber do
		local p = listview:getItem(i)
		if(p.refreshstatus == 1) then
			for j=1,5 do
				local cellItem = m_getWidget(p, "LAY_ITEM_"..j)
				local pData = listData[i*5+j]
				if(pData and pData.chooseStatus == 1) then
					local IMG_LIGHT = m_getWidget(cellItem, "IMG_LIGHT")
					IMG_LIGHT:setVisible(false)
					local IMG_TICK = m_getWidget(cellItem, "IMG_TICK")
					IMG_TICK:setVisible(false)
					local posx = IMG_TICK:getPositionX()
					local posy = IMG_TICK:getPositionY()
					local anchor = IMG_TICK:getAnchorPoint()
					local pSp = CCSprite:create("ui/highlight_2.png")
					pSp:setPosition(ccp(posx,posy))
					pSp:setAnchorPoint(ccp(anchor.x,anchor.y))
					IMG_TICK:getParent():addNode(pSp)
					pSp:setTag(ACT_TICK_TAG)
					local pArr = CCArray:create()
					-- pArr:addObject(CCFadeIn:create(0.8))
					pArr:addObject(CCFadeOut:create(25/60))
         	 		pArr:addObject(CCCallFuncN:create(
         	 			function( ... )
         	 				pSp:removeFromParentAndCleanup(true)
         	 				playCallback()
            			end)
         	 		)
         	 		pSp:runAction(CCSequence:create(pArr))

				    local pStrInfo = {name = "highlight"}
					local pAni = fnCreateAni(pStrInfo)
			        local pSize = cellItem:getSize()
			        pAni:setPosition(ccp(pSize.width*0.5,pSize.height*0.5 + 12))
			        cellItem:addNode(pAni,-1)
			        cellActCount = cellActCount + 1
			        cellActing = true
				end
			end
		end
	end
	return true
end

--判断添加经验后是否满足当前最大等级
local function fnCheckExpFull( addExp )
	local pConch = mModel.getAfterAddExpConch(conchData,addExp)
	return pConch.va_item_text.level >= mModel.getMaxLevel(conchData)
end

--更新提升属性
local function updateAddProperty()
	local mainLayout=layoutMain
	local addLb = m_getWidget(mainLayout, "TFD_ADD")
	if(addExpAllNum>0) then
		addLb:setText(addExpAllNum)
		mUI.labelNewStroke(addLb)
		addLb:setVisible(true)
	else
		addLb:setVisible(false)
	end

	-- exp
	local min,max=mModel.getExpOnConchUpgrade(conchData)
	min=min+addExpAllNum
	local haveExpBar = m_getWidget(mainLayout, "LOAD_PROGRESS_GREEN")
	haveExpBar:setVisible(true)
	local nPercent = min / max * 100
  	haveExpBar:setPercent((nPercent > 100) and 100 or nPercent)

  	--增加经验后临时空岛贝
  	logger:debug("wm----addExpAllNum : " .. addExpAllNum)
  	m_newConch = mModel.getAfterAddExpConch(conchData,addExpAllNum) or conchData
  	local addLv = 0
  	if(m_newConch and m_newConch.va_item_text and m_newConch.va_item_text.level) then
  		addLv = tonumber(m_newConch.va_item_text.level) - tonumber(conchData.va_item_text.level)
  	end
  	m_levelChange = addLv

  	local pAttrInfoOld
  	local pAttrInfoNew
	if (mItemUtil.fnIsExpConchType(conchData.itemDesc.type) ) then -- 如果是经验空岛贝
        local pNum = mModel.getExpOfConchSuplly(conchData)
        pAttrInfoOld = {{name = m_i18n[1975], num = pNum},}
		pNum = mModel.getExpOfConchSuplly(m_newConch)
        pAttrInfoNew = {{name = m_i18n[1975], num = pNum},}
	else
		pAttrInfoOld = mItemUtil.getConchNumerialByItemId(conchData.item_id)
		pAttrInfoNew = mItemUtil.getConchNumerialByItemId(-990,true,m_newConch) --传入conch计算属性，id要传入一个不存在的，需要有第二个参数
	end

  	local addProperty = pAttrInfoNew[1].num-pAttrInfoOld[1].num

	local addLvLb = m_getWidget(layoutMain, "TFD_LEVEL_EFFECT")
	local pstr = addLv<=0 and "" or "+"..addLv
	addLvLb:setText(pstr)
	addLvLb:setVisible(true)
	local addPropery = m_getWidget(layoutMain, "TFD_AFFIX_EFFECT")
	pstr = addProperty<=0 and "" or "+"..addProperty
	addPropery:setText(pstr)
	addPropery:setVisible(true)
end

function updateNumBaseInfo( pConch )
	local mainLayout=layoutMain

	local tfdLv = m_getWidget(mainLayout, "TFD_LEVEL_NUM")
	tfdLv:setText(pConch.va_item_text.level)

	local pAttrInfo
	if (mItemUtil.fnIsExpConchType(pConch.itemDesc.type) ) then -- 如果是经验空岛贝
        local pNum = mModel.getExpOfConchSuplly(pConch)
        pAttrInfo = {{name = m_i18n[1975], num = pNum},}
	else
		pAttrInfo = mItemUtil.getConchNumerialByItemId(-990,true,pConch)
	end

	if(table.count(pAttrInfo) > 0) then
		local tfdAffix = m_getWidget(mainLayout, "TFD_AFFIX")
		tfdAffix:setText(pAttrInfo[1].name .. "：")
		local tfdAffixNum = m_getWidget(mainLayout, "TFD_AFFIX_NUM")
		tfdAffixNum:setText(pAttrInfo[1].num)
	else
		local imgAffixBg = m_getWidget(mainLayout, "img_affix_bg_1")
		imgAffixBg:setVisible(false)
	end
	--exp
	local min,max = mModel.getExpOnConchUpgrade(pConch)
	local expLeft = m_getWidget(mainLayout, "LABN_LEFT")
	expLeft:setStringValue(min)
	if(not expActing) then
		expLeft:setVisible(true)
	end
	local expRight = m_getWidget(mainLayout, "LABN_RIGHT")
	expRight:setStringValue(max)
	if(not expActing) then
		expRight:setVisible(true)
	end
	if(not expActing) then
		local img_slant = m_getWidget(mainLayout, "img_slant")
		img_slant:setVisible(true)
	end

	local haveExpBar = m_getWidget(mainLayout, "LOAD_PROGRESS_GREEN")
	haveExpBar:setVisible(false)
	local addLb = m_getWidget(mainLayout, "TFD_ADD")
	addLb:setVisible(false)
	local addLvLb = m_getWidget(layoutMain, "TFD_LEVEL_EFFECT")
	addLvLb:setVisible(false)
	local addPropery = m_getWidget(layoutMain, "TFD_AFFIX_EFFECT")
	addPropery:setVisible(false)

	return min,max
end

--更新基本信息
local function updateBaseInfo()
	local mainLayout=layoutMain
	local haveBelly = m_getWidget(layoutMain, "LABN_OWN_BELLY")
	haveBelly:setStringValue(UserModel.getSilverNumber())
	
	local conchName = m_getWidget(layoutMain, "TFD_CONCH_NAME")
	conchName:setText(conchData.itemDesc.name)
	conchName:setColor(HeroPublicUtil.getLightColorByStarLv(conchData.itemDesc.quality))

	local imgType = m_getWidget(layoutMain, "IMG_TYPE_NAME")
	imgType:loadTexture(mUI.fnGetConchTypeFilePath(conchData.itemDesc.type))

	local imgStar
	for i=1,6 do
		if(i > conchData.itemDesc.quality) then
			imgStar = m_getWidget(layoutMain, "IMG_STAR_" .. i)
			imgStar:setVisible(false)
		end
	end	

	local min , max = updateNumBaseInfo(conchData)

	-- local haveExpBar = m_getWidget(mainLayout, "LOAD_PROGRESS_BLUE")
	local nPercent = min / max * 100
	nPercent = (nPercent > 100) and 100 or nPercent
  	-- haveExpBar:setPercent(nPercent)
  	
	if(not mBlueProgress) then
		local haveExpBar = m_getWidget(mainLayout, "LOAD_PROGRESS_BLUE")
		haveExpBar:setPercent(0)
		mBlueProgress = mUI.fnGetProgress()
		haveExpBar:addNode(mBlueProgress)
	end
	mBlueProgress:setPercentage(nPercent)

	-- pProgress:stopAllActions()
 --  	local pr = CCProgressTo:create(2 , 70)
 --  	pProgress:runAction(pr)
end

--设置全选按钮
local function setSelectAllBtn()
	local btnCancel = m_getWidget(layoutMain, "BTN_CANCEL")
	local btnSelectAll = m_getWidget(layoutMain, "BTN_ALL")
	if (conchData.itemDesc.quality<=1) then
		btnSelectAll:setTitleText(m_i18n[5515])
	elseif (conchData.itemDesc.quality<=2) then
		btnSelectAll:setTitleText(m_i18n[5503])
	else
		btnSelectAll:setTitleText(m_i18n[5502])
	end
	if (selectAllBtnStatus==1) then
		btnCancel:setEnabled(false)
		btnSelectAll:setVisible(true)
	else
		btnCancel:setEnabled(true)
		btnSelectAll:setVisible(false)
	end
end

--返回不能升级提示信息
function getUpgradeTipStr(conch)
	local pMax1 = tonumber(conch.itemDesc.maxLevel) or 0
	if (tonumber(conch.va_item_text.level)>=pMax1) then
		return m_i18n[5512]
	end
	return string.format(m_i18n[5533],math.modf(UserModel.getHeroLevel()/5)*5+5)
end
--选择或取消选择空岛贝
local function selectConchEvent(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	if(fnNeedWait()) then
		return
	end
	AudioHelper.playCommonEffect()
	local idx = sender:getTag()
	local pMaxlv = tonumber(mModel.getMaxLevel(conchData)) or 0
	if (tonumber(conchData.va_item_text.level) >= pMaxlv) then
		ShowNotice.showShellInfo(getUpgradeTipStr(conchData)) --(m_i18n[5512]) --强化到上线
		return
	end
	
	if (listData[idx].itemDesc.quality>conchData.itemDesc.quality) then
		ShowNotice.showShellInfo(m_i18n[5534]) --强化到上线
		return
	end

	local choose = m_getWidget(sender, "IMG_LIGHT")
	local choose2 = m_getWidget(sender, "IMG_TICK") 
	if listData[idx].chooseStatus==0 then
		if(m_selectNum ~=0 and tonumber(m_newConch.va_item_text.level) >= pMaxlv) then
			ShowNotice.showShellInfo(m_i18n[5519]) --选择经验已达上限
			return
		end
		listData[idx].chooseStatus=1
		choose:setVisible(true)
		choose2:setVisible(true)
		addExpAllNum = addExpAllNum + tonumber(listData[idx].addExp)
		m_selectNum = m_selectNum + 1
		showFlyAni(sender)
	else
        listData[idx].chooseStatus=0
		choose:setVisible(false)
		choose2:setVisible(false)
		addExpAllNum = addExpAllNum - tonumber(listData[idx].addExp)
		m_selectNum = m_selectNum - 1
	end
	
	updateAddProperty()
	--当手动把所有选项都取消时，设置全选按钮可全选
	if (isEmptySelectConch()) then
		selectAllBtnStatus=1
		setSelectAllBtn()
	end
end

--更新cell某一行
function updateCellByIdex(list,idx)
	logger:debug("update cell by idex:" .. idx)
	local cell = tolua.cast(list:getItem(idx),"Widget")
	local n=1
	for i=idx*5+1,idx*5+5 do
		local cellItem=m_getWidget(cell, "LAY_ITEM_"..n)
		cellItem:setTag(i)
		if i<=#listData then
			cellItem:setEnabled(true)
			local icon = m_getWidget(cellItem, "IMG_ICON")
			--icon:loadTexture(listData[i].itemDesc.imgFullPath)
			icon:removeAllChildrenWithCleanup(true)
			local iconImg = mItemUtil.createBtnByTemplateId(listData[i].item_template_id)
			icon:addChild(iconImg)
			local name = m_getWidget(cellItem, "TFD_CONSUME_NAME")
			name:setText(listData[i].itemDesc.name)
			name:setColor(HeroPublicUtil.getLightColorByStarLv(listData[i].itemDesc.quality))
			local choose = m_getWidget(cellItem, "IMG_LIGHT")
			local choose2 = m_getWidget(cellItem, "IMG_TICK") 
			choose2:getParent():removeNodeByTag(ACT_TICK_TAG)
			if (listData[i].chooseStatus==0) then
				choose:setVisible(false)
				choose2:setVisible(false)
			else
				choose:setVisible(true)
				choose2:setVisible(true)
			end
			cellItem:addTouchEventListener(selectConchEvent)
		else
			cellItem:setEnabled(false)
		end
		n=n+1
	end
end

--闭关当前页
local function onCloseEvent(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	AudioHelper.playCloseEffect()
	if (pageType=="formation") then
		logger:debug("hero page ==="..formationData.heroPage)
		LayerManager.changeModule(MainFormation.create(formationData.heroPage), MainFormation.moduleName(), {1,3}, true)
		MainFormation.changeConch(true)
	else
		require "script/module/conch/ConchBag/MainConchCtrl"
		local layBag = MainConchCtrl.create() -- 默认显示道具列表
		if (layBag) then
		    LayerManager.changeModule(layBag, MainConchCtrl.moduleName(), {1, 3}, true)
		    PlayerPanel.addForPublic()
		end
	end
end

--全部取消
local function cancelSelectAll(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	if(fnNeedWait()) then
		return
	end
	AudioHelper.playCommonEffect()
	for _,v in pairs(listData) do
		v.chooseStatus=0
	end
	m_selectNum = 0
	addExpAllNum = 0
	mUI.reloadListView(listview,getListCount(),updateCellByIdex)
	selectAllBtnStatus=1
	setSelectAllBtn()
	updateAddProperty()
end

--全部选中
local function selectAllEvent(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end
	if(fnNeedWait()) then
		return
	end
	AudioHelper.playCommonEffect()
	local pMaxlv = tonumber(mModel.getMaxLevel(conchData))
	if (tonumber(conchData.va_item_text.level)>=pMaxlv) then
		ShowNotice.showShellInfo(getUpgradeTipStr(conchData))--(m_i18n[5512]) --强化到上线
		return
	end
	if(m_selectNum ~=0 and tonumber(m_newConch.va_item_text.level) >= pMaxlv) then
		ShowNotice.showShellInfo(m_i18n[5519]) --选择经验已达上限
		return
	end
	local quality=3
	if (conchData.itemDesc.quality<=1) then
		quality=1
	elseif (conchData.itemDesc.quality<=2) then
		quality=2
	else
		quality=3
	end
	local isSelected=false
	for _,v in pairs(listData) do
		if (v.itemDesc.quality<=quality) then
			isSelected = true
			if(v.chooseStatus ~= 1) then
				v.chooseStatus = 1
				addExpAllNum = addExpAllNum + v.addExp
				m_selectNum = m_selectNum + 1
			end
			
			if(fnCheckExpFull(addExpAllNum) ) then
				break
			end
		end
	end
	if (not isSelected) then
		local starStr
		if quality==1 then
			starStr="1"
		else
			starStr="1-"..quality
		end
		ShowNotice.showShellInfo(string.format(m_i18n[5513],starStr))
		return
	end
	mUI.reloadListView(listview,getListCount(),updateCellByIdex)
	selectAllBtnStatus=0
	setSelectAllBtn()
	updateAddProperty()
end

--确认升级提交数据
local function confirmRequest()
	local function strengthCallback( cbFlag, dictData, bRet)
		if(dictData.err=="ok") then
			local data=dictData.ret
			logger:debug({conchQH = conchData})
			backExp = data.va_item_text.exp
			backLv = data.va_item_text.level
			pLayCellAni()
			conchData.va_item_text.exp = backExp
			conchData.va_item_text.level = backLv
			require "script/module/conch/ConchBag/MainConchCtrl"
			MainConchCtrl.replaceConchDataByGid(conchData.gid,conchData)

			-- 强化后推送红点背包，在伙伴身上穿的不用推送
			if (conchData.hid == nil) then
				logger:debug("空岛贝强化红点推送")
				ItemUtil.pushitemCallback(data, 3)
			end
			resetAll()
			if (conchData.hid ~= nil) then
				UserModel.setInfoChanged(true)
				UserModel.updateFightValue({[conchData.hid]={HeroFightUtil.FORCEVALUEPART.CONCH}})
			end
		end
	end


	local function bagCangeEvent()
		if(isRunningAni) then
			waitToFresh = true
			if(not cellActing) then
				logger:debug("wm---pushSetListData")
				setListData()
				mUI.reloadListView(listview,getListCount(),updateCellByIdex)
			end
		else
			resetAll()
		end
	end

	local params = CCArray:create()
	params:addObject(CCInteger:create(tonumber(conchData.item_id)))
	local ids=CCArray:create()
	for _,v in pairs(listData) do
		if (v.chooseStatus==1) then
			ids:addObject(CCInteger:create(tonumber(v.item_id)))
		end
	end
	params:addObject(ids)
	PreRequest.setBagDataChangedDelete(bagCangeEvent)
	RequestCenter.upgradeConch(strengthCallback,params)
end

--确认升级
local function confirmEvent(sender, eventType)
	if (eventType ~= TOUCH_EVENT_ENDED) then
		return
	end

	if(fnNeedWait()) then
		return
	end

	-- local pTest = true
	-- if(pTest) then
	-- 	pLayCellAni()
	-- 	return
	-- end

	AudioHelper.playCommonEffect()
	if (isEmptySelectConch()) then
		ShowNotice.showShellInfo(m_i18n[5514])
		return
	end
	for _,v in pairs(listData) do
		if (v.chooseStatus==1 and v.itemDesc.quality>=4) then
			local dlg1 = mUI.createCommonDlg(m_i18n[5517],nil, function ( sender, eventType)
						if (eventType == TOUCH_EVENT_ENDED) then
							if(fnNeedWait()) then
								return
							end
							AudioHelper.playCommonEffect()
							confirmRequest()
							LayerManager.removeLayout()
						end
					
					end)
			LayerManager.addLayout(dlg1)
			return
		end
	end 
	confirmRequest()
end

--刷新界面和数据
function resetAll( ... )
	logger:debug("wm----resetAll")
	setListData() --断线重连后conchData指向不对，
	init()
	mUI.reloadListView(listview,getListCount(),updateCellByIdex)
	updateAddProperty()
	updateBaseInfo()
	selectAllBtnStatus=1
	setSelectAllBtn()
end

--conchInfo 空岛贝信息 enterType 进入类型 “bag” 从背包进入 "formation" 从整容进入
function create(conchInfo,enterType)
	logger:debug("conch info:")
	logger:debug(conchInfo)
	m_FinalPos = nil
	m_mainIcon = nil
	mBlueProgress = nil
	selectAllBtnStatus=1
	pageType=enterType
	conchData=conchInfo
	formationData.heroPage = conchData.heroPage
	formationData.hid = conchData.hid
	formationData.pos = conchData.pos
	formationData.equipType = conchData.equipType

	--LayerManager.hideAllLayout(moduleName()) --changemodule，不能用
	init()
	setListData()
	layoutMain = Layout:create()
	if (layoutMain) then
		mUI.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
					--LayerManager.remuseAllLayoutVisible(moduleName())
				end,
				function()
				end
			)

		local mainLayout = g_fnLoadUI("ui/conch_strengthen.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		setSelectAllBtn()
		local btnConfirm = m_getWidget(layoutMain, "BTN_YES")
		btnConfirm:addTouchEventListener(confirmEvent)

		local img_bg = m_getWidget(layoutMain, "img_bg")
		img_bg:setScale(g_fScaleX)

		local img_fazhen = m_getWidget(layoutMain, "img_fazhen")
		local icon = m_getWidget(img_fazhen, "IMG_ICON")
		m_mainIcon = mItemUtil.createBtnByTemplateId(conchData.item_template_id)
		icon:addChild(m_mainIcon)
		mUI.runFloatAction(m_mainIcon)

		local addLv = m_getWidget(layoutMain, "TFD_LEVEL_EFFECT")
		local addLvNode = tolua.cast(addLv:getVirtualRenderer(), "CCNode")
		mUI.fadeInAndOutUI(addLvNode,1,1)

		local addProperty = m_getWidget(layoutMain, "TFD_AFFIX_EFFECT")
		local addPropertyNode = tolua.cast(addProperty:getVirtualRenderer(), "CCNode")
		mUI.fadeInAndOutUI(addPropertyNode,1,1)

		
		local addExp = m_getWidget(layoutMain, "TFD_ADD")
		local addExpNode = tolua.cast(addExp:getVirtualRenderer(), "CCNode")
		mUI.fadeInAndOutUI(addExpNode,1,1)

		local addExpBar = m_getWidget(layoutMain, "LOAD_PROGRESS_GREEN")
		local addExpBarNode = tolua.cast(addExpBar:getVirtualRenderer(), "CCNode")
		mUI.fadeInAndOutUI(addExpBarNode,1,1)

		local backBtn = m_getWidget(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(onCloseEvent)

		local btnCancel = m_getWidget(layoutMain, "BTN_CANCEL")
		btnCancel:addTouchEventListener(cancelSelectAll)
		local btnSelectAll = m_getWidget(layoutMain, "BTN_ALL")
		btnSelectAll:addTouchEventListener(selectAllEvent)
		
		listview = m_getWidget(layoutMain, "LSV_MAIN")
		mUI.initListViewCell(listview)
		mUI.reloadListView(listview,getListCount(),updateCellByIdex)
		updateBaseInfo()
		updateAddProperty()
		
        local img_max = m_getWidget(mainLayout, "img_max")
		img_max:setVisible(false)
		local pMaxlv = tonumber(mModel.getMaxLevel(conchData)) or 0
		if (tonumber(conchData.va_item_text.level) >= pMaxlv) then
			mainLayout.img_max:setVisible(true)
			mainLayout.img_slant:setVisible(false)
			mainLayout.LABN_LEFT:setVisible(false)
			mainLayout.LABN_RIGHT:setVisible(false)
			mainLayout.TFD_ADD:setVisible(false)
			mainLayout.TFD_LEVEL_EFFECT:setVisible(false)
			mainLayout.TFD_AFFIX_EFFECT:setVisible(false)
			mainLayout.LOAD_PROGRESS_BLUE:setPercent(100)
		end
	end
	
	LayerManager.changeModule(layoutMain, moduleName(), {1,3}, true)

	local function changepPaomao( ... )
		local pmdBg=m_getWidget(layoutMain, "lay_main")
	    LayerManager.setPaomadeng(pmdBg,0)
	    mUI.registExitAndEnterCall(pmdBg, function ( ... )
	        LayerManager.resetPaomadeng()
	    end)
	end
	changepPaomao()
end
