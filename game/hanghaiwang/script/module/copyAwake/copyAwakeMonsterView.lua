-- FileName: copyAwakeMonsterView.lua
-- Author: liweidong
-- Date: 2015-11-18
-- Purpose: 挑战据点预览界面
--[[TODO List]]

module("copyAwakeMonsterView", package.seeall)

-- UI控件引用变量 --
local _layoutMain = nil
-- 模块局部变量 --
local _copyId = nil
local _baseId = nil
local _baseItemInfo = nil --据点信息
local m_i18n = gi18n
local ndropCount = 5

local function init(...)

end

function destroy(...)
	package.loaded["copyAwakeMonsterView"] = nil
end

function moduleName()
    return "copyAwakeMonsterView"
end
--更新扫荡按钮状态
function updateTenAtkBtnStatus()
	local attack10Btn = _layoutMain.BTN_ATTACK101
	local attkNum,allNum = copyAwakeModel.getHoldAttackInfo(_copyId,_baseId)
	_layoutMain.IMG_SWEEP_GOLD_BG:setVisible(false)
	_layoutMain.TFD_CD1:setVisible(false)
	local nCurAtkNum = attkNum > 10 and 10 or attkNum
	if (nCurAtkNum<=0) then
		if (allNum>10) then
			nCurAtkNum = 10
		else
			nCurAtkNum = allNum
		end
	end
	_layoutMain.TFD_ATTACK101:setText(string.format(gi18n[1307],nCurAtkNum))
	if (UserModel.getHeroLevel() < 20) then --25级扫荡
		attack10Btn:setBright(false)
		_layoutMain.IMG_SWITCH:setVisible(true)
	else
		attack10Btn:setBright(true)
		_layoutMain.IMG_SWITCH:setVisible(false)
	end
	attack10Btn:addTouchEventListener(function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				copyAwakeCtrl.onTenAttack(_copyId,_baseId)
			end
		end)
end
--更新挑战次数widget
function fnShowBattleNum( attkNum )
	local strAttkNum,allNum = copyAwakeModel.getHoldAttackInfo(_copyId,_baseId)
	logger:debug("attack info :")
	logger:debug(strAttkNum)
	logger:debug(allNum)
	_layoutMain.TFD_LIMIT_NUM:setText(strAttkNum)
	_layoutMain.TFD_LIMIT_NUM3:setText(allNum)
	if (tonumber(strAttkNum) <= 0) then
		_layoutMain.TFD_LIMIT_NUM:setColor(ccc3(0xd5,0x41,0x00))
	else
		_layoutMain.TFD_LIMIT_NUM:setColor(ccc3(0x00,0x93,0x11))
	end
end
function updateUI()
	fnShowBattleNum()
	updateTenAtkBtnStatus()
end
function setUIStyleAndI18n(base)
	base.tfd_drop:setText(m_i18n[1305])
	base.tfd_power:setText(m_i18n[4311])
	base.tfd_pass_reward:setText(m_i18n[5959])--TODO
	base.BTN_ATTACK1:setTitleText(m_i18n[1308])
	base.tfd_limit:setText(m_i18n[1303]) --TODO
	-- UIHelper.labelNewStroke( base.TFD_LIMIT_NUM2, ccc3(0x28,0x00,0x00), 2 )
	UIHelper.titleShadow(base.BTN_ATTACK1)
	base.tfd_switch:setText(m_i18n[1370])
	UIHelper.labelShadow(base.TFD_ATTACK101)
end
-- 显示顶部信息中的星数
local function fnTopInfoStar( baseStar )
	local star1 = nil
	local star2 = nil
	local star3 = nil
	local nStarNum =3 
	local baseStaus = 2+baseStar
	print("baseStausbaseStaus"..baseStaus.."nStarNum"..nStarNum)
	if(nStarNum > 2) then
		star3 = _layoutMain.IMG_STAR3
	end
	if(nStarNum > 1) then
		star2 = _layoutMain.IMG_STAR2
	end
	if(nStarNum > 0) then
		star1 = _layoutMain.IMG_STAR1
	end

	local tbStarArr = {}
	if(star3) then
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
			table.insert(tbStarArr,star2)
			table.insert(tbStarArr,star3)
		elseif(baseStaus < 4) then
			table.insert(tbStarArr,star2)
			table.insert(tbStarArr,star3)
		elseif(baseStaus < 5) then
			table.insert(tbStarArr,star3)
		end
	elseif(star2) then
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
			table.insert(tbStarArr,star2)
		elseif(baseStaus < 4) then
			table.insert(tbStarArr,star2)
		end
	else
		if(baseStaus < 3) then
			table.insert(tbStarArr,star1)
		end
	end
	for _,v in pairs(tbStarArr) do
		UIHelper.setWidgetGray(v,true)
	end
end
--掉落预览
function fnDropPreview( ... )
	logger:debug("item reward===")
	logger:debug(_baseItemInfo["reward_item_id_simple"])
	if (_baseItemInfo["reward_item_id_simple"] ~= nil) then

		local _,otherRewardIds = OutputMultiplyUtil.getAdditionalDrop( )
		local dropIdArr = lua_string_split(_baseItemInfo["reward_item_id_simple"],",")
		if (otherRewardIds) then
			for _,id in ipairs(otherRewardIds) do
				dropIdArr[#dropIdArr+1] = id
			end
		end
		-- local reward = RewardUtil.parseRewards(baseItemInfo[rewardKey])
		local cm,cd = math.modf(#dropIdArr/ndropCount)
		local cellCount = cm+(cd>0 and 1 or 0)
		local allCount = #dropIdArr
		if (cellCount>1) then
			_layoutMain.img_num_reward:setSize(CCSizeMake(_layoutMain.img_num_reward:getSize().width,_layoutMain.img_num_reward:getSize().height+_layoutMain.LSV_DROP:getSize().height))
			_layoutMain.img_bg:setSize(CCSizeMake(_layoutMain.img_bg:getSize().width,_layoutMain.img_bg:getSize().height+_layoutMain.LSV_DROP:getSize().height))
			_layoutMain.LSV_DROP:setSize(CCSizeMake(_layoutMain.LSV_DROP:getSize().width,_layoutMain.LSV_DROP:getSize().height*2))
		end
		UIHelper.initListView(_layoutMain.LSV_DROP)
		UIHelper.initListWithNumAndCell(_layoutMain.LSV_DROP,cellCount)
		for idx=1,cellCount do
			local cell = _layoutMain.LSV_DROP:getItem(idx-1)
			for n=1,5 do
				local i = (idx-1)*ndropCount+n
				local layDrop = cell["LAY_DROP"..n]
				if(i <= #dropIdArr) then
					local dropIds = lua_string_split(dropIdArr[i],"|")
					if (dropIds[1] ~= nil) then
						local layImage = layDrop["IMG_"..n]
						local soulItem,soulInfo = ItemUtil.createBtnByTemplateId(dropIds[1],
														function ( sender,eventType )
															if (eventType == TOUCH_EVENT_ENDED) then
																PublicInfoCtrl.createItemInfoViewByTid(tonumber(dropIds[1]))
															end
														end)
						soulItem:setTag(i)
						layImage:addChild(soulItem)
						local goodsTitle = layDrop["TFD_NAME_"..n]
						if (goodsTitle) then
							UIHelper.labelEffect(goodsTitle,soulInfo.name)
							if (soulInfo.quality ~= nil) then
								local color =  g_QulityColor[tonumber(soulInfo.quality)]
								if(color ~= nil) then
									goodsTitle:setColor(color)
								end
							end
						end
					end
				else
					layDrop:setVisible(false)
				end
			end
		end
	else
		_layoutMain.img_bg_drop:setVisible(false)
	end
end
--初始化UI
function initUI()
	_layoutMain = g_fnLoadUI("ui/dcopy_drop.json")
	UIHelper.registExitAndEnterCall(_layoutMain,
			function()
				_layoutMain=nil
			end,
			function()
			end
		) 
	setUIStyleAndI18n(_layoutMain)
	--头像框
	local normalTable = copy.models.normal
	for i,values in pairs(normalTable) do
		local armyId = values.looks.look.armyID
		local modelUrl = values.looks.look.modelURL
		if (tonumber(armyId) == tonumber(_baseItemInfo.id) and modelUrl ~= nil) then
			local nimgModel = lua_string_split(modelUrl,".swf")
			_layoutMain.IMG_FRAME:loadTexture("images/copy/ncopy/fortpotential/"..nimgModel[1]..".png")
			_layoutMain.IMG_FRAME:setPositionType(POSITION_ABSOLUTE)
			if (tonumber(nimgModel[1])==1) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -10))
			elseif  (tonumber(nimgModel[1])==2) then
				_layoutMain.IMG_FRAME:setPosition(ccp(0, -5))
			else
				_layoutMain.IMG_FRAME:setPosition(ccp(0, 1))
			end
			break
		end
	end
	--头像
	_layoutMain.IMG_HEAD:loadTexture("images/base/hero/head_icon/".._baseItemInfo.icon)

	_layoutMain.TFD_NAME:setText(_baseItemInfo.name)
	_layoutMain.TFD_POWER_NUM:setText(_baseItemInfo.cost_energy_simple)
	_layoutMain.TFD_NUM_MONEY1:setText(math.floor(_baseItemInfo.coin_simple*OutputMultiplyUtil.getMultiplyRateNum(2)/10000))
	_layoutMain.TFD_EXP_NUM:setText(math.floor(_baseItemInfo.exp_simple*UserModel.getHeroLevel()*OutputMultiplyUtil.getMultiplyRateNum(2)/10000))

	fnDropPreview()
	local starNum = copyAwakeModel.getHoldStarNumber(_copyId,_baseId)
	fnTopInfoStar(starNum)

	_layoutMain.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)

	_layoutMain.BTN_ATTACK1:addTouchEventListener(
		function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				copyAwakeCtrl.onClickBattle(_copyId,_baseId)
			end
		end
		)
	updateUI()
	_layoutMain.BTN_REPORT:addTouchEventListener(function( sender, eventType )
				if (eventType ~= TOUCH_EVENT_ENDED) then
					return
				end
				AudioHelper.playStrategy()
				local baseDb = _baseItemInfo
				local baseName = baseDb.name
				tbData={
			        type=3,-- 类型 普通副本＝1，精英副本＝2，觉醒副本＝3，深海＝4，世界boss＝5,
			        name = baseName, --据点名称（世界boss传boss名称，深海传当前层：第xx层）,
			        param1 = _copyId, --普通副本，精英副本，觉醒副本传副本ID；深海传当前层数，世界boss传boss ID
			        param2 = _baseId, --普通副本，觉醒副本传据点id ，其他模块不用传
			        param3 = nil, --普通副本 传据点难度，其他不需要
			        callback1 = nil,--攻略页面点查看战报时调用，可传nil，,   (用于世界boss处理音乐)
			        callback2 = nil, --查看战报战斗播放结束，结算面板关闭时调用，可传nil, (用于世界boss处理音乐)
			    }
				StrategyCtrl.create( tbData )
			end)
	return _layoutMain
end
function create(copyId,baseId)
	_copyId = copyId
	_baseId = baseId
	_baseItemInfo = DB_Stronghold.getDataById(_baseId)
	require "script/module/guide/GuideAwakeView"
    if(GuideModel.getGuideClass() == ksGuideAwake and GuideAwakeView.guideStep == 9) then
        require "script/module/guide/GuideCtrl"
        GuideCtrl.removeGuide()
    end

	return initUI()
end
