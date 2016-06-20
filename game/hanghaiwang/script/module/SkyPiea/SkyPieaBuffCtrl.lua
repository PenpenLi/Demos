-- FileName: SkyPieaBuffCtrl.lua
-- Author: zhangjunwu
-- Date: 2015-1-14
-- Purpose: 空岛buff层选择buff Ctrl


module("SkyPieaBuffCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBuffView"
require "script/module/SkyPiea/SkyPieaBattle/SkyPieaFormationCtrl"

-- UI控件引用变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18nString = gi18nString
-- 模块局部变量 --
local m_tbBuffInfo = nil
local m_buffIndex  = 0    --buff的下表

local function init(...)
	m_buffIndex = 0
end


function destroy(...)
	package.loaded["SkyPieaBuffCtrl"] = nil
end


function moduleName()
	return "SkyPieaBuffCtrl"
end

--[[desc:--发送购买buff的请求
    arg1: hids:buff作用所有武将的hid，buffId：buff的下表index ，updataUICallBack网络回调
    return: 是否有返回值，返回值说明  
—]]

local function doDealBuff(hids , buffId, updataUICallBack)
	local args = CCArray:create()
	local curLayerNum = SkyPieaModel.getCurFloor()
	args:addObject(CCInteger:create(curLayerNum))
	args:addObject(CCInteger:create(m_buffIndex - 1))

	local subArg = CCArray:create()

	--buff作用的伙伴hid
	for i = 1,#hids do
		subArg:addObject(CCInteger:create(hids[i]))
	end

	args:addObject(subArg)
	RequestCenter.skyPieaDealBuff(updataUICallBack,args)
end

--购买buff后更新本地数据
local function setBuffStateBy(buffIndex)
	m_tbBuffInfo[buffIndex].status = 1

	--属性buff
	if(m_tbBuffInfo[buffIndex].buffType == SkyPieaModel.BUFFTYPE.ATTR_BUFF) then
		local tbBuffBought = SkyPieaModel.getBuffInfoBought() or {}
		logger:debug("如果此buff是属性buff，那么当前选择的buff是否已经被购买过了？--------------" )
		logger:debug(tbBuffBought)

		local isFind = false
		for k,v in pairs(tbBuffBought) do
			--
			if(tonumber(k) == m_tbBuffInfo[buffIndex].attrType) then
				v = v + m_tbBuffInfo[buffIndex].attrValue * SkyPieaModel.BUFF_RATIO
				tbBuffBought[k]  = v
				isFind = true
				break
			end
		end

		if(isFind == false) then
			tbBuffBought[m_tbBuffInfo[buffIndex].attrType] = m_tbBuffInfo[buffIndex].attrValue * SkyPieaModel.BUFF_RATIO
		end

		logger:debug(tbBuffBought)
		--更新已经购买buff的数据
		SkyPieaModel.setBuffInfoBought(tbBuffBought)
		--更新已经购买的buffUI
		SkyPieaBuffView.setBuffUI()
		MainSkyPieaView.setBuffUI()
	end
end

--p、判断是否所有的三个buff都已经购买
local function fnIsAllBuffBought()

	local isAllBuffBuy = true

	for i,v in ipairs(m_tbBuffInfo) do
		if(tonumber(v.status) == 0) then
			isAllBuffBuy = false
			break
		end
	end

	return isAllBuffBuy
end

--离开buff的网络请求
local function fnConfirmClose()
	--是否三个buff都已经被购买，如果三个buff都被购买了，则不需要发送请求
	local isAllBuffBuy = fnIsAllBuffBought()
	if(isAllBuffBuy == false) then
		local args = CCArray:create()
		local curLayerNum = SkyPieaModel.getCurFloor()
		args:addObject(CCInteger:create(curLayerNum))
		args:addObject(CCInteger:create(999))
		local subArg = CCArray:create()
		args:addObject(subArg)
		RequestCenter.skyPieaDealBuff(function (cbFlag, dictData, bRet)
			if(bRet) then

				SkyPieaUtil.fnContinue()

			end
		end
		,args)
	else
		SkyPieaUtil.fnContinue()
	end
end

--点击关闭按钮的事件处理
local function fnClose()
	local nStarCount = SkyPieaModel.getStarNum()
	logger:debug("拥有的星数为%s" , nStarCount)
	logger:debug("次层的buff数据为:-------------------------------------")
	logger:debug(m_tbBuffInfo)

	--是否有buff还没有处理过
	local isAllowLeave = true
	for i,v in ipairs(m_tbBuffInfo) do
			--是否处理过此buff
			local _bDealed = tonumber(v.status) == 0
			--购买此buff所需要的星数是否足够
			local _bEnoughStar = tonumber(v.costStarNum) < tonumber(nStarCount)

			--复活buff
			if(tonumber(v.buffType) ==  SkyPieaModel.BUFFTYPE.REBORN_BUFF) then
				local isHeroDead = SkyPieaUtil.isHeroDead()
				if(isHeroDead == true and _bDealed and _bEnoughStar) then
					isAllowLeave = false
					break
				end
			--回复血量的buff
			elseif(tonumber(v.buffType) ==  SkyPieaModel.BUFFTYPE.RECOVER_HP_BUFF) then
				local needBuff = SkyPieaUtil.isSomeHeroNeedHP()
				if(needBuff == true and _bDealed and _bEnoughStar) then
					isAllowLeave = false
					break
				end
			elseif( _bDealed and _bEnoughStar) then
				isAllowLeave = false
				break
			end
	end

	if(isAllowLeave == false) then
		local tips = m_i18nString(5450) 				-- [5450] = "尚有未购买的buff，确定要离开么？",

		local dlg  = UIHelper.createCommonDlg(tips, nil, function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				LayerManager.removeLayout()
				AudioHelper.playCloseEffect()
				fnConfirmClose()
			end
		end , 2)

		LayerManager.addLayout(dlg)

	else
		fnConfirmClose()
	end
end

--判断是否需要自动离开buff层
local function fnAutoLeave( )
	--是否三个buff都已经被购买，如果三个buff都被购买了，则z直接离开buff层
	local isAllBuffBuy = fnIsAllBuffBought()

	if(isAllBuffBuy == true) then
		SkyPieaUtil.fnContinue()
	else
		logger:debug("还有buff没有购买哦。不会在动退出buff层")
	end
end

--[[
	@desc: 获取要绑定的function
    @return: tb  type: table
—]]
function getBtnBindingFuctions(  )
	local tbEvent = {}

	-- 关闭按钮事件
	tbEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onClose")
			AudioHelper.playCloseEffect()

			if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
			 	return 
			end
			-- SkyPieaBuffView.testFn()
			fnClose()

		end
	end
	-- 继续挑战按钮事件
	tbEvent.onGoOn = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onGoOn")
			AudioHelper.playCommonEffect()
			if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
			 	return 
			end
			fnClose()
		end
	end
	-- buff选择按钮事件
	tbEvent.onBuff = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onBuff")
			AudioHelper.playCommonEffect()
			if(SkyPieaUtil.isShowRewardTimeAlert() == true) then
			 	return 
			end
			
			m_buffIndex= sender:getTag()
			local buffId = m_tbBuffInfo[m_buffIndex].buffType

			local tbBuffInfo = m_tbBuffInfo[m_buffIndex]
			if(tonumber(SkyPieaModel.getStarNum()) < tonumber(tbBuffInfo.costStarNum)) then

				ShowNotice.showShellInfo(m_i18nString(5451)) --	[5451] = "星数不足，无法购买此增益buff",
				return
			end

			--购买buff后的UI帅刷新以及数据更新
			local function doDealBuffCall( cbFlag, dictData, bRet )
				if(bRet) then
					--更新次buff的数据
					setBuffStateBy(m_buffIndex)

					local curStarNum = tonumber(SkyPieaModel.getStarNum()) - tonumber(tbBuffInfo.costStarNum)
					SkyPieaModel.setStarNum(curStarNum)
					--设置当前可用星数的UI
					SkyPieaBuffView.setStarLabelValue()
					MainSkyPieaView.upPointAndStarNum()
					-- SkyPieaBuffView.setBtnBuffGray(sender)
					
					--更新界面，设置次buff为已购买
					SkyPieaBuffView.updateBoughtBuffView(m_buffIndex)

					--判断是否需要自动离开buff层
					fnAutoLeave()
				end
			end

			tbBuffInfo.fnDealBuff = function ( hids)
				if(#hids == 0 ) then
					-- ShowNotice.showShellInfo("没有给任何武将加buff")
					LayerManager.removeLayout()
				else
					--发送请求
					doDealBuff(hids, m_buffIndex , doDealBuffCall)
					LayerManager.removeLayout()
				end
			end

			--加属性buff
			if(tonumber(buffId) ==  SkyPieaModel.BUFFTYPE.ATTR_BUFF) then
				local hidsArg = {}
				doDealBuff(hidsArg, m_buffIndex , doDealBuffCall)

				ShowNotice.showShellInfo(tbBuffInfo.des)
			--复活buff
			elseif(tonumber(buffId) ==  SkyPieaModel.BUFFTYPE.REBORN_BUFF) then
				local isHeroDead = SkyPieaUtil.isHeroDead()
				if(isHeroDead == true) then
					SkyPieaFormationCtrl.create(0,tbBuffInfo)
				else
					ShowNotice.showShellInfo(m_i18nString(5452))  				--[5452] = "没有伙伴死亡，无法购买此buff",
				end
			--回复血量的buff
			elseif(tonumber(buffId) ==  SkyPieaModel.BUFFTYPE.RECOVER_HP_BUFF) then

				local needBuff = SkyPieaUtil.isSomeHeroNeedHP()
				if(needBuff == true) then
					SkyPieaFormationCtrl.create(0,tbBuffInfo)
				else
					ShowNotice.showShellInfo(m_i18nString(5453))				 --	[5453] = "没有伙伴损血，无法购买此buff",

				end
			--加怒气buff
			elseif(tonumber(buffId) ==  SkyPieaModel.BUFFTYPE.RECOVER_RAGE_BUFF) then
				SkyPieaFormationCtrl.create(0,tbBuffInfo)
			end

		end
	end

	return tbEvent
end


function create(...)
	local function getBuffInfoCallBack(cbFlag, dictData, bRet)
		if(bRet) then
			m_tbBuffInfo = SkyPieaModel.parseBuffData(dictData.ret)
			local tbEvent = getBtnBindingFuctions()
			local view = SkyPieaBuffView.create(tbEvent,m_tbBuffInfo)
			if view then
				LayerManager.addLayout(view)
			end
		else
			logger:debug("获取buff信息出错")
		end

	end

	local args = CCArray:create()
	local curLayerNum = SkyPieaModel.getCurFloor()
	args:addObject(CCInteger:create(curLayerNum))
	RequestCenter.skyPieaGetBuffInfo(getBuffInfoCallBack,args)
end

