-- FileName: MainRegistrationView.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: 每日签到页面
--[[TODO List]]

module("MainRegistrationView", package.seeall)

-- UI控件引用变量 --
local m_LSV_View
local layMain
-- 资源文件
local reward_sign = "ui/activity_sign.json" 
require "script/module/registration/MainRewardInfoCtrl"
require "script/module/public/UIHelper"
require "db/DB_Sign"
require "db/DB_Sign_reward"
require "script/module/registration/MainRegistrationData"
require "script/module/public/UIHelper"
require "script/module/public/ItemUtil"
require "script/module/config/AudioHelper"
require "db/i18n"

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName 
local month 
local alreadySign 
local goodNum
local m_i18n = gi18n
local appendGoldNum 
local append_nums
local btnBuqian
local appendTimes
local nReceive = 0
local tfdAppend 
local today 
local daysInCurMonth
local appendFlag = 0
local nCellHeight=1


local nCellTag = 10023
	
local function init(...)

end

function destroy(...)
	package.loaded["MainRegistrationView"] = nil
end

function moduleName()
	return "MainRegistrationView"
end

local function fnGetItem(cell , time)
	local pItem = m_fnGetWidget(cell,"LAY_CLONE1")
	if(tonumber(time) == 1) then
		return pItem
	end

	local pItem2 = m_fnGetWidget(cell,"LAY_CLONE" .. time)
	local node = pItem2:getChildByTag(nCellTag)
	if (node) then 
		return node 
	end 

	node = pItem:clone()
	pItem2:addChild(node)
	node:setTag(nCellTag)
	return pItem2
end

local function fnGetIcon(type , array)
	local pType = tonumber(type) or 1
	local imagePath,iconOn,mian_desc,imageIcon = nil
	local pPath1 = "images/base/props/"
	local pPath2 = "images/base/potential/color_"
	local pFile1 = {"beili_da","jingyanshi","jinbi_zhong","tili_xiao","naili_xiao"}
	local pFile2 = {"2","4","5","5","5"}

	if(pType == 7) then
		local goodInfo = ItemUtil.getItemById(array[1])
		imagePath = pPath1 .. goodInfo.icon_small
		iconOn = ItemUtil.createBtnByTemplateId(array[1])
		iconOn:setTag(2)
		mian_desc = goodInfo.desc
		goodNum = 1
		if array[2] ~= nil then  
			goodNum = array[2]
		end   
	elseif(pType > 0 and pType < 6) then
		iconOn = ImageView:create()
		iconOn:loadTexture(pPath2 .. pFile2[pType] ..".png")
		local iconImgV = ImageView:create()
		iconImgV:loadTexture(pPath1 .. pFile1[pType] ..".png")
		local iconImgB = ImageView:create()
		iconImgB:loadTexture("images/base/potential/equip_" .. pFile2[pType] ..".png")
		iconOn:addChild(iconImgV)
		iconOn:addChild(iconImgB)
		imageIcon = iconOn
		iconOn:setTag(2)
		goodNum = array[1]
		if(pType == 2) then
			goodNum = 1
		end
	end

	return imagePath,iconOn,mian_desc,imageIcon
end 



-- 每帧刷新一个cell
function refreshListView( ... )
	MainRegistrationCtrl.freshRegistrationData()
	alreadySign = MainRegistrationData.getSignNum()
	
	m_LSV_View:removeAllItems() -- 初始化清空列表
	m_LSV_View:setTouchEnabled(true)
	local cell, nIdx=0 
	local color = nil  -- 旧版本品质框已去掉
	local vipBei = {m_i18n[2605],m_i18n[2606],m_i18n[2607],m_i18n[2608],m_i18n[2609],m_i18n[2610],m_i18n[2611],m_i18n[2612],m_i18n[2613],m_i18n[2614]}
	local signs = DB_Sign.getDataById(1) 
	local start
	local special_awards
	local endtime

	local sign_id = getSignIdFromStart()
	signs = DB_Sign.getDataById(sign_id) 
	
	special_awards = signs.special_awards
	local special = string.split(special_awards,",")  
	local daysReward = signs.days_reward      
	local daysRewardArr = string.split(daysReward, ",")  

	local time = 1
	m_LSV_View:removeAllItems() -- 初始化清空列表
	local signInfos = MainRegistrationData.getSignInfo() 
	local signInfoForToday = DataCache.getNorSignCurInfo()


	local function updateCellByIndex(idx)
		local nIdx = idx 
		cell = m_LSV_View:getItem(nIdx-1)  -- cell 索引从 0 
		nCellHeight = cell:getSize().height

		for time=1,4 do
			local reward = string.split(daysRewardArr[(nIdx-1)*4+time],"|")    --“累积天数|奖励表|vip优惠级别|vip优惠倍数”
			if ((nIdx-1)*4+time>#daysRewardArr) then 
				break
			end 

			local bei = reward[4]   --vip 优惠倍数
			local sign_reward = DB_Sign_reward.getDataById(reward[2])

			local goodInfo
			local item = fnGetItem(cell , time)

			local sppend = 0
			local bget = 0
			local nTodayFlag = 0
			local todays = 0
			local goodType = sign_reward.type_1
			local info = sign_reward.value_1
			local array = string.split(info,"|")  
			local imagePath,iconOn,mian_desc,imageIcon = fnGetIcon(sign_reward.type_1 , array)

			local name = m_fnGetWidget(item,"TFD_GOODS_NAME1") 
			name:setText(sign_reward.des_1)

			local vip = m_fnGetWidget(item,"IMG_DOUBLE_VIP")     
			local imgSpercial = m_fnGetWidget(item,"IMG_SPECIAL") 
			local imgSpercialBag = m_fnGetWidget(item,"IMG_BG_SPECIAL")  
			local imgAlready = m_fnGetWidget(item,"IMG_BG_GRAY") 
			local tfdJiaobiao = m_fnGetWidget(item,"TFD_JIAOBIAO")  --右下角数字
			local yellow = m_fnGetWidget(item,"IMG_BG_YELLOW")
			local normal = m_fnGetWidget(item,"IMG_BG_NORMAL")
			local imagReceiveBag = m_fnGetWidget(item,"IMG_BG_ALREADY")
			imagReceiveBag:setVisible(false) 
			local imgRece = m_fnGetWidget(item,"IMG_RECIEVED")    --是否已经签到
			local IMG_EXTRA = m_fnGetWidget(item,"IMG_EXTRA") 
			IMG_EXTRA:setVisible(false)

			local colorImg = m_fnGetWidget(item,"IMG_GOODS1") 
			colorImg:setColor(g_QulityColor[sign_reward.quality_1])
			colorImg:setTag(time.."") 
			if(iconOn) then
				-- iconOn:removeNodeByTag(2)
				-- iconOn:removeChildByTag(2,true)
				if(time == 1) then
					iconOn:setTag(1234)
				else
					colorImg:removeChildByTag(1234,true)
				end
				colorImg:addChild(iconOn,-1)
			end

			if(reward[3] == nil) then 
					vip:setVisible(false)
			else 
				vip:setVisible(true)
					local vip_bei = m_fnGetWidget(item,"TFD_BEI") 
					local vip_lev = m_fnGetWidget(item,"TFD_VIP_LEVEL") 
					if(bei ~= nil) then  
						vip_lev:setText(string.format("V%d",reward[3]))
						vip_bei:setText(m_i18n[2605+tonumber(bei)-1])
					end
			end 

			local timeS = m_fnGetWidget(item,"TFD_NEED_TIMES") 
			timeS:setText(reward[1])

			if(time == 1) then    
				if(tonumber(DataCache.getNorSignCurInfo().reward_num) >= tonumber(reward[1])  )then
					bget = 1
					nTodayFlag = 1
					local imgIcon = iconOn:getChildByTag(1)
					tfdJiaobiao:setVisible(false)
					imgSpercial:setVisible(false)
					imgAlready:setVisible(true)
					imagReceiveBag:setVisible(true)
					nReceive = nReceive + 1
					imgSpercialBag:setVisible(false)
					yellow:setVisible(false)
				else
					imgRece:setVisible(false)
					imgAlready:setVisible(false)
					imgSpercial:setVisible(false)
					normal:setVisible(true)
					yellow:setVisible(false)
					imgSpercialBag:setVisible(false)
					tfdJiaobiao:setVisible(true)
					if goodNum == nil then 
						goodNum = 1
					end
					tfdJiaobiao:setText("×" .. goodNum)
					yellow:setVisible(false)
					for index=1,#special do 
						if i == tonumber(special[index])  then
							normal:setVisible(false)
							imgSpercialBag:setVisible(true)
							imgSpercial:setVisible(true)
						end 
					end 
		
					if(signInfoForToday~=nil and tonumber(signInfoForToday.sign_num) > tonumber(signInfoForToday.reward_num)) then
						if (tonumber( DataCache.getNorSignCurInfo().reward_num) == tonumber(reward[1])-1 and
							tonumber( DataCache.getNorSignCurInfo().reward_num)-1 ~= tonumber(MainRegistrationData.getSignNum()) )then 
							yellow:setVisible(true)
							if today ==nil or today ~= 0 then 
								today = reward[1]
							end
							normal:setVisible(false)
							imgSpercialBag:setVisible(false)
						else
							normal:setVisible(true)
							yellow:setVisible(false)
						end
					else
						yellow:setVisible(false)
					end
				end
			elseif(time == 2) then
				if(tonumber(DataCache.getNorSignCurInfo().reward_num) >= tonumber(reward[1])  )then

					bget=1
					local imgIcon = iconOn:getChildByTag(1) 
					tfdJiaobiao:setVisible(false)
					imgSpercial:setVisible(false)
					imgAlready:setVisible(true)
					imagReceiveBag:setVisible(true)
					imgSpercialBag:setVisible(false)
					yellow:setVisible(false)
					nReceive = nReceive + 1
				else
					yellow:setVisible(false)
					imgRece:setVisible(false)
					imgAlready:setVisible(false)
					imgSpercial:setVisible(false)
					imgSpercialBag:setVisible(false)

					normal:setVisible(true)
					tfdJiaobiao:setVisible(true)
					tfdJiaobiao:setText("×" .. goodNum)
					for index=1,#special do 
						if i == tonumber(special[index])  then
							normal:setVisible(false)
							imgSpercialBag:setVisible(true)
							imgSpercial:setVisible(true)
						else
							normal:setVisible(true)
							imgSpercialBag:setVisible(false)
							imgSpercial:setVisible(false)
						end 
					end   
						
					if(signInfoForToday~=nil and tonumber(signInfoForToday.sign_num) > tonumber(signInfoForToday.reward_num)) then
						if (tonumber( DataCache.getNorSignCurInfo().reward_num) == tonumber(reward[1])-1 and (
							tonumber( DataCache.getNorSignCurInfo().reward_num)-1 ~= tonumber(MainRegistrationData.getSignNum()) or 
							tonumber( DataCache.getNorSignCurInfo().reward_num) == 1)  )then 
							yellow:setVisible(true)
							if today ==nil or today ~= 0 then 
									today = reward[1]
							end
							normal:setVisible(false)
							imgSpercialBag:setVisible(false)
						else
							yellow:setVisible(false)
							normal:setVisible(true)
						end
					else
						yellow:setVisible(false)
					end  
			 
					if today ~=nil and today ~= 0 then
						if(appendFlag ==1) then
							if (tonumber(reward[1]) <= tonumber(today)+ appendTimes and tonumber(reward[1])>tonumber(today))  or tonumber(reward[1])==tonumber(today) then
								yellow:setVisible(true)
								sppend = 1
								normal:setVisible(false)
								todays = 1
								imgSpercialBag:setVisible(false)
							else
								yellow:setVisible(false)
								normal:setVisible(true)
								sppend = 0
							end
						else
							sppend = 0
						end
					else
						sppend = 0
					end
				end
			elseif(time == 3) then
				if(tonumber(DataCache.getNorSignCurInfo().reward_num) >= tonumber(reward[1]) )then

					local imgIcon = iconOn:getChildByTag(1)
					tfdJiaobiao:setVisible(false)
					bget = 1
					imgSpercial:setVisible(false)
					imgSpercial:setVisible(false)
					imgAlready:setVisible(true)
					imagReceiveBag:setVisible(true)
					imgSpercialBag:setVisible(false)
					yellow:setVisible(false)
					nReceive = nReceive + 1
				else
					imgRece:setVisible(false)
					imgAlready:setVisible(false)
					normal:setVisible(true)
					imgSpercial:setVisible(false)
					imgSpercialBag:setVisible(false)
					tfdJiaobiao:setVisible(true)
					tfdJiaobiao:setText("×" .. goodNum)
			
					for index=1,#special do 
						if i == tonumber(special[index]) then 
							normal:setVisible(false)
							imgSpercialBag:setVisible(true)
							imgSpercial:setVisible(true)
						end 
					end 
					if(signInfoForToday~=nil and tonumber(signInfoForToday.sign_num) > tonumber(signInfoForToday.reward_num)) then
						if (tonumber( DataCache.getNorSignCurInfo().reward_num) == tonumber(reward[1])-1 and
							tonumber( DataCache.getNorSignCurInfo().reward_num)-1 ~= tonumber(MainRegistrationData.getSignNum()) )then 
							yellow:setVisible(true)
							if today ==nil or today ~= 0 then 
								today = reward[1]
							end
							normal:setVisible(false)
							imgSpercialBag:setVisible(false)
						else
							yellow:setVisible(false)
							normal:setVisible(true)
						end
					else
							yellow:setVisible(false)
					end
				end
			elseif(time == 4) then
				if (tonumber(DataCache.getNorSignCurInfo().reward_num) >= tonumber(reward[1])  )then
					bget = 1
					tfdJiaobiao:setVisible(false)
					local imgIcon = iconOn:getChildByTag(1) 
					imgSpercial:setVisible(false)
					imgSpercial:setVisible(false)
					imgAlready:setVisible(true)
					imagReceiveBag:setVisible(true)
					imgSpercialBag:setVisible(false)
					yellow:setVisible(false)
					nReceive = nReceive + 1
				else
					imgRece:setVisible(false)
					imgAlready:setVisible(false)
					imgSpercial:setVisible(false)
					imgSpercialBag:setVisible(false)
					normal:setVisible(true)
					tfdJiaobiao:setVisible(true)
					tfdJiaobiao:setText("×" .. goodNum)
					for index=1,#special do 
						if i == tonumber(special[index])  then
							imgSpercialBag:setVisible(true)
							normal:setVisible(false)
							imgSpercial:setVisible(true)
						end 
					end 

					if(signInfoForToday~=nil and tonumber(signInfoForToday.sign_num) > tonumber(signInfoForToday.reward_num)) then
						if (tonumber( DataCache.getNorSignCurInfo().reward_num) == tonumber(reward[1])-1 and
							tonumber( DataCache.getNorSignCurInfo().reward_num)-1 ~= tonumber(MainRegistrationData.getSignNum()) )then 
							yellow:setVisible(true)
							normal:setVisible(false)
							if today ==nil or today ~= 0 then 
								today = reward[1]
							end
							imgSpercialBag:setVisible(false)
						else
							yellow:setVisible(false)
							normal:setVisible(true)
						end
					else
						yellow:setVisible(false)
					end
				end    
			end

			UIHelper.labelNewStroke(tfdJiaobiao, ccc3( 0x32, 0x03, 0x03) , 2)
			UIHelper.labelShadow(tfdJiaobiao)
			

			local b1 = (not bei) 
			local b2 = (tonumber(MainRegistrationData.getSignInNum()) ~= tonumber(reward[1]) and tonumber(sppend) == 0) 
			  -- bei vip优惠倍数，   reward[1]累计天数


			if(tonumber(bget) == 1) then
				if(b1 or b2) then
					imgRece:setVisible(true)  --对勾
				else
					local pLast = tonumber(DataCache.getNorSignCurInfo().last_vip) or 0
					local mVip = tonumber(UserModel.getVipLevel()) or 0
					local pL = tonumber(reward[3]) or 0
					
					if (pL>pLast and pL<=mVip) then --vip升级，可以领取额外奖励
						imgAlready:setVisible(false)  --遮挡
						yellow:setVisible(true)  --绿板
						IMG_EXTRA:setVisible(false)  --黄板 
						imgRece:setVisible(false)  --勾兑 

						local pFillPath = animationPath .. "qiandao_lingqu/qiandao_lingqu.ExportJson"
						local m_arAni1 = UIHelper.createArmatureNode({
							filePath = pFillPath,
							animationName = "qiandao_lingqu",
							})
						m_arAni1:getAnimation():setSpeedScale(0.5)
						colorImg:addNode(m_arAni1,-1)
					elseif(pL<=pLast and pL<=mVip) then   --已经领取了多倍奖励
						imgRece:setVisible(true)   --对勾 已经领取了多倍奖励
					elseif(mVip<pL) then  --vip不够领取多倍奖励
						IMG_EXTRA:setVisible(true)  --黄板     
						imgRece:setVisible(false)  --勾兑
						imgAlready:setVisible(false)  --遮挡
					end 
				end    
			else
				if(not b2) then
					local pFillPath = animationPath .. "qiandao_lingqu/qiandao_lingqu.ExportJson"
					local m_arAni1 = UIHelper.createArmatureNode({
						filePath = pFillPath,
						animationName = "qiandao_lingqu",
						})
					m_arAni1:getAnimation():setSpeedScale(0.5)
					colorImg:addNode(m_arAni1,-1)
				end
			end
			
			local function pTouchFunc( ... )
				AudioHelper.playCommonEffect()
				showInfo(nil,
				tonumber(bei),sign_reward.des_1,
				reward[1],mian_desc,bget,imagePath,
				imageIcon,goodType,array[1],info,reward[3],
				vipBei[tonumber(bei)],reward[2],sppend)
			end

			local ptouchbutton = m_fnGetWidget(item,"BTN_TOUCH") 
			ptouchbutton:setVisible(false)
			ptouchbutton:addTouchEventListener(function ( sender ,eventType )  
				if(eventType == TOUCH_EVENT_ENDED) then   
					pTouchFunc()
				end 
			end)
		end 
		
		cell:setVisible(true)
	end


	local cellCount = math.ceil(#daysRewardArr/4)
	for i=1,cellCount do
		m_LSV_View:pushBackDefaultItem()
		local cell = m_LSV_View:getItem(i-1)
		for k=1,4 do
			if ((i-1)*4+k<#daysRewardArr) then 
				fnGetItem(cell , k)
			end 
		end
		cell:setVisible(false)
	end

	for i=1,cellCount do 
		performWithDelayFrame(m_LSV_View, function ( ... )
			updateCellByIndex(i)
		end, i+1)
	end 


	require "script/module/wonderfulActivity/WonderfulActModel"
	local pShow = MainRegistrationCtrl.fnCheckRegistrationTip()
	WonderfulActModel.tbBtnActList.registration:setVisible(pShow)

end


local function getDays( month ,year)
	local days 
	if tonumber(month) == 4 or tonumber(month) == 6 or tonumber(month) == 9 or tonumber(month) == 11 then
		days = 30
	else 
		days =31
	end
	if tonumber(month) == 2 then
		if (year % 4 ==0 and year % 100 ~= 0 ) or  (year % 400 == 0) then
			days = 29
		else
			days = 28
		end
	end  

	return days
end

function compareTime()
--  local time=os.time();
	local time = TimeUtil.getSvrTimeByOffset()
	time = tonumber(time)
	local format = "%Y%m%d%H%M%S"
	
	return TimeUtil.getLocalOffsetDate(format,time)  
end

-- 改版签到 获取签到id 起始时间2015.12.前后端都在代码里写死了。  --yangna 2015.12.23
function getSignIdFromStart( ... )
	local startTime  = {
		y = 2015,
		m = 12,
	}

	local signcircle = DB_Normal_config.getDataById(1).signcircle
	local tbSingData = string.split(signcircle,",")
	local circleLen = #tbSingData

	local time = TimeUtil.getSvrTimeByOffset()
	time = tonumber(time)
	local year = tonumber(TimeUtil.getLocalOffsetDate("%Y",time))  
	local month = tonumber(TimeUtil.getLocalOffsetDate("%m",time)) 
	local curtime = {
		y = year,
		m = month,
	}

	local monthNum = 0
	if (curtime.y==startTime.y) then 
		monthNum = curtime.m - startTime.m
	elseif (curtime.y > startTime.y) then 
		monthNum = curtime.m + 12 - startTime.m + (curtime.y - 1 - startTime.y) * 12
	else
	 	logger:debug("签到时间错误")
	end 

	monthNum = monthNum % circleLen
	local id = tbSingData[monthNum+1]

	logger:debug("获取当前签到id＝%s",id)

	return id
end


function create(...)
	layMain = g_fnLoadUI(reward_sign)
	local imgBg = m_fnGetWidget(layMain, "IMG_MAIN_BG")
	imgBg:setScale(g_fScaleX)
	UIHelper.registExitAndEnterCall(layMain, function ( ... )
		m_LSV_View = nil
		layMain = nil
	end)
	freshAll()

	return layMain
end



function freshAll()
	local  layBg = layMain

	local IMG_MAIN_BG = m_fnGetWidget(layBg, "IMG_MAIN_BG") 
	IMG_MAIN_BG:setScaleX(g_fScaleX)

	local tfdMonth = m_fnGetWidget(layBg, "TFD_MONTH_NUM") 
	tfdAppend = m_fnGetWidget(layBg,"TFD_BUQIAN_TIMES")
	appendGoldNum = m_fnGetWidget(layBg,"TFD_BUQIAN_MONEY")

	local signNum = tonumber(DataCache.getNorSignCurInfo().sign_num)
	appendTimes = 0
	nReceive = 0
	if (btnClose) then
		btnClose:addTouchEventListener(close)
	end
	
	local times = os.time();
	local timeTable = TimeUtil.getLocalOffsetDate("*t",TimeUtil.getSvrTimeByOffset()); 
	 
	
	UIHelper.labelAddStroke(tfdMonth,"" .. timeTable.month)
	UIHelper.labelShadow(tfdMonth )

	daysInCurMonth = getDays(timeTable.month , timeTable.year) 
	
	--描边效果和国际化-------
	appendEffect(layBg)
	---------------------
	if(not m_LSV_View) then
		m_LSV_View = m_fnGetWidget(layBg,"LSV_TOTAL") --listview
		UIHelper.initListView(m_LSV_View)  --使用UIListView的setItemModel 给listView先创建一个默认的cell，
	end
 
	m_LSV_View:setTouchEnabled(true)
	refreshListView()
--------------------------- new guide sign begin -----------------------------------------
	require "script/module/guide/GuideModel"
	require "script/module/guide/GuideSignView"
	if (GuideModel.getGuideClass() == ksGuideSignIn and GuideSignView.guideStep == 1) then
		require "script/module/guide/GuideCtrl"
		GuideCtrl.createSignGuide(2,0)
		m_LSV_View:setTouchEnabled(false)
	end
------------------------------ new guide sing end ----------------------------------------
end

-- 设置位置
function setContentOffset1( ... )
	performWithDelayFrame(layMain,function ( ... )
		local hScrollTo = (nCellHeight ) * ((math.ceil(nReceive/4)-1) )--  (idxRow + 1)
		local szInner = m_LSV_View:getInnerContainerSize()
		local szView = m_LSV_View:getSize()
		local percent = (hScrollTo/(szInner.height - szView.height)) * 100

		percent = percent > 100 and 100 or percent
		m_LSV_View:jumpToPercentVertical(percent)

	end,9)

end

function appendEffect( layBg )
	local tfdMonthInfo = m_fnGetWidget(layBg , "tfd_month_info")
	local tfdXie = m_fnGetWidget(layBg,"tfd_xiegang")
	local tfdCi = m_fnGetWidget(layBg , "tfd_ci")
	local time = m_fnGetWidget(layBg, "TFD_TIMES1") 

	UIHelper.labelAddNewStroke(time , DataCache.getNorSignCurInfo().reward_num, ccc3(0x28, 0x00,0x00))
	UIHelper.labelAddNewStroke(tfdCi , m_i18n[2631], ccc3(0x28, 0x00,0x00))
	UIHelper.labelAddNewStroke(tfdMonthInfo, m_i18n[2630], ccc3(0x28, 0x00,0x00))
end

-- 本月累计签到1天
function refreasRewardMum()
	if (layMain) then 
		local time = m_fnGetWidget(layMain, "TFD_TIMES1") 
		time:setText(DataCache.getNorSignCurInfo().reward_num)
	end 
end


function getMainLay( ... )
	return layMain
end

function close( ... )
	AudioHelper.playCloseEffect()
	m_LSV_View = nil
	layMain = nil
	LayerManager.removeLayout()
end


-- 页面展示
function showInfo( color,name,reward_des,time ,des,bget ,imagePaths,imageIcons,goodTypes,goodid,info,vipLevel,beishu,rewardid,sppendKind)
	local tbGoods ={}
	local nGet =1
	if (tonumber(bget) == 1) or (tonumber(MainRegistrationData.getSignInNum())< tonumber(time) and tonumber(sppendKind) == 0) then
		nGet    = 0
	end  
	if (goodTypes == 7) then 
		table.insert(tbGoods , goodid)
	end 
	
	if(tbGoods == nil) or (nGet == 0) or (not ItemUtil.bagIsFullWithTids( tbGoods,true)) then
		MainRewardInfoCtrl.create(color,name,reward_des,time, des ,bget , alreadySign,goodNum,imagePaths,imageIcons,goodTypes,goodid,info,vipLevel,beishu,rewardid,sppendKind)
	end 
end



