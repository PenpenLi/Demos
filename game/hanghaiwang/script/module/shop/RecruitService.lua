-- FileName: RecruitService.lua
-- Author: menghao
-- Date: 2014-05-29
-- Purpose: 招将网络请求后的处理


module("RecruitService", package.seeall)

require "script/module/shop/HeroDisplay"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_fnAddStroke = UIHelper.labelNewStroke
local mi18n = gi18n


local  function setNextTenLabelUI(layNextTenTxtShow,nRecruitLeft)
	layNextTenTxtShow.tfd_recruit_again_10:setText(mi18n[1428])
	layNextTenTxtShow.tfd_recruit_next_10:setText(mi18n[1429])
	layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10:setText(nRecruitLeft + 10)
	layNextTenTxtShow.tfd_recruit_purple_10:setText(mi18n[1833])
	layNextTenTxtShow.tfd_recruit_next_or_10:setText(mi18n[1222])
	layNextTenTxtShow.tfd_recruit_orange_10:setText(mi18n[1834])
	layNextTenTxtShow.tfd_recruit_next_hero_10:setText(mi18n[1467])

	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_again_10)
	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_next_10)
	m_fnAddStroke(layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10)
	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_purple_10)
	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_next_or_10)
	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_orange_10)
	m_fnAddStroke(layNextTenTxtShow.tfd_recruit_next_hero_10)
end 

function initMustBePurpleTip( UIMain ,_state)
	local nRecruitLeft, nRecruitOrangeLeft = getLeftNum()

	local layTxtZero = m_fnGetWidget(UIMain, "lay_txt_zero")
	local layTxt = m_fnGetWidget(UIMain, "lay_txt")
	local layTxtZeroPurple = m_fnGetWidget(UIMain, "lay_txt_zero_purple")
	local layTxtPurple = m_fnGetWidget(UIMain, "lay_txt_purple")

	local lay_txt_10 = m_fnGetWidget(UIMain, "lay_txt_10")
	local lay_txt_purple_10 = m_fnGetWidget(UIMain, "lay_txt_purple_10")



	layTxtZero:setEnabled(false)
	layTxt:setEnabled(false)
	layTxtZeroPurple:setEnabled(false)
	layTxtPurple:setEnabled(false)

	lay_txt_10:setEnabled(false)
	lay_txt_purple_10:setEnabled(false)

	local layTxtShow
	local layNextTenTxtShow
	logger:debug(nRecruitLeft)
	logger:debug(nRecruitOrangeLeft)
	if (nRecruitLeft == 1 or nRecruitOrangeLeft == 1) then
		-- 剩余橙色不多于紫色要显示必得橙色
		if (nRecruitLeft >= nRecruitOrangeLeft) then
			layTxtShow = layTxtZero
			layNextTenTxtShow = lay_txt_purple_10


			setNextTenLabelUI(layNextTenTxtShow,nRecruitLeft)

		else
			layTxtShow = layTxtZeroPurple
			layNextTenTxtShow = lay_txt_10

			local tfdRecruitOr = m_fnGetWidget(layTxtShow, "tfd_recruit_next_zero_or")
			tfdRecruitOr:setText(mi18n[1222])
			m_fnAddStroke(tfdRecruitOr)

			local tfdRecruitHero = m_fnGetWidget(layTxtShow, "tfd_recruit_next_zero_hero")
			tfdRecruitHero:setText(mi18n[1467])
			m_fnAddStroke(tfdRecruitHero)


			layNextTenTxtShow.tfd_recruit_again_10:setText(mi18n[1428])
			layNextTenTxtShow.tfd_recruit_next_10:setText(mi18n[1429])
			layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10:setText(nRecruitLeft + 10)
			layNextTenTxtShow.tfd_recruit_o_10:setText(mi18n[1161])

			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_again_10)
			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_next_10)
			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_o_10)
			m_fnAddStroke(layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10)


		end

		local tfdRecruitNext = m_fnGetWidget(layTxtShow, "tfd_recruit_next_zero")

		--总招募界面和招募结算面板的显示需要不一样
		if(_state) then
			tfdRecruitNext:setText(mi18n[1479])  
		else
			tfdRecruitNext:setText(mi18n[1451])
		end

		m_fnAddStroke(tfdRecruitNext)
	else
		if (nRecruitLeft >= nRecruitOrangeLeft) then
			layTxtShow = layTxt
			layNextTenTxtShow = lay_txt_purple_10

			setNextTenLabelUI(layNextTenTxtShow,nRecruitLeft)

		else
			layNextTenTxtShow = lay_txt_10

			layTxtShow = layTxtPurple
			local tfdRecruitOr = m_fnGetWidget(layTxtShow, "tfd_recruit_next_or")
			tfdRecruitOr:setText(mi18n[1222])
			m_fnAddStroke(tfdRecruitOr)

			local tfdRecruitHero = m_fnGetWidget(layTxtShow, "tfd_recruit_next_hero")
			tfdRecruitHero:setText(mi18n[1467])
			m_fnAddStroke(tfdRecruitHero)

			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_o_10)


			layNextTenTxtShow.tfd_recruit_again_10:setText(mi18n[1428])
			layNextTenTxtShow.tfd_recruit_next_10:setText(mi18n[1429])
			layNextTenTxtShow.tfd_recruit_o_10:setText(mi18n[1161])
			layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10:setText(nRecruitLeft + 10)
			
			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_again_10)
			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_next_10)
			m_fnAddStroke(layNextTenTxtShow.TFD_RECRUIT_AGAIN_NUM_10)
			m_fnAddStroke(layNextTenTxtShow.tfd_recruit_o_10)

		end

		local tfdRecruitAgain = m_fnGetWidget(layTxtShow, "tfd_recruit_again")
		tfdRecruitAgain:setText(mi18n[1428])
		m_fnAddStroke(tfdRecruitAgain)

		local tfdRecruitAgainNum = m_fnGetWidget(layTxtShow,  "TFD_RECRUIT_AGAIN_NUM")
		tfdRecruitAgainNum:setText(nRecruitLeft)
		m_fnAddStroke(tfdRecruitAgainNum)

		local tfdRecruitNext = m_fnGetWidget(layTxtShow, "tfd_recruit_next")
		tfdRecruitNext:setText(mi18n[1429])
		m_fnAddStroke(tfdRecruitNext)
	end



	layTxtShow:setEnabled(true)
	layNextTenTxtShow:setEnabled(true)
end


-- 返回必得紫还要招募的次数
function getLeftNum( ... )
	local tavernData = DB_Tavern.getDataById(3)

	local changeTimes = lua_string_split(tavernData.changeTimes, ",")
	local firstTime = tonumber(changeTimes[1])
	local afterTime =   tonumber(changeTimes[2])

	local changeTimes3 = lua_string_split(tavernData.changeTimes3, ",")
	local firstTime3 = tonumber(changeTimes3[1])
	local afterTime3 =   tonumber(changeTimes3[2])

	local shopInfo = DataCache.getShopCache()
	local nRecruitSum = tonumber(shopInfo.gold_recruit_num) + tonumber(shopInfo.gold_recruit_free)

	local nRecruitLeft = 0
	if (nRecruitSum < firstTime) then
		nRecruitLeft = firstTime - nRecruitSum - 0
	else
		nRecruitLeft = afterTime - (nRecruitSum - firstTime)%afterTime - 0
	end

	local nRecruitLeft3 = 0
	if (nRecruitSum < firstTime3) then
		nRecruitLeft3 = firstTime3 - nRecruitSum - 0
	else
		nRecruitLeft3 = afterTime3 - (nRecruitSum - firstTime3)%afterTime3 - 0
	end

	if (shopInfo.va_shop.fake) then
		nRecruitLeft = nRecruitLeft + 1
		nRecruitLeft3 = nRecruitLeft3 + 1
	end

	return nRecruitLeft, nRecruitLeft3
end


-- 返回是不是特殊影子
function isSpecialShadow( heroShadowTid )
	require "db/DB_Normal_config"
	local str = DB_Normal_config.getDataById(1).shop_drop_shadow
	local tbSpecialIDs = string.split(str, ",")
	for i=1,#tbSpecialIDs do
		if (tonumber(tbSpecialIDs[i]) == tonumber(heroShadowTid)) then
			return true
		end
	end
	return false
end


function resetShopInfo(fnCall ,needFreshRed)
	-- 获取当前商店的信息
	function shopInfoCallback( cbFlag, dictData, bRet )
		if(dictData.err ~= "ok")then
			return
		end
		local _curShopCacheInfo = dictData.ret
		logger:debug(_curShopCacheInfo)
		DataCache.setShopCache(_curShopCacheInfo)
		-- DataCache.setItemFreeNum(0)
		--神秘招募从进阶引导过来的时候，招募完之后不需要更新酒馆红点
		if(needFreshRed == nil) then
			MainShopView.updateTipTavern()
			Tavern.startScheduler()
			Tavern.setDiscountUI()
		end
		MainScene.updateShopTip()


		fnCall()
	end

	RequestCenter.shop_getShopInfo(shopInfoCallback)
end


-- 百万招募网络请求后
function lowerRecruitCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		Tavern.updateItemNum()
		
		resetShopInfo(function (  )
			LayerManager.removeLayout()
			HeroDisplay.create(dictData.ret, 1)
		end)
		
	end
end


-- 千万招募网络请求后
function mediumRecruitCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		local shopInfo = DataCache.getShopCache()
		if( tonumber(shopInfo.mediumFreeNum ) > 0 )then
			DataCache.addSiliverFreeNum(-1)
		else
			local dbMedium = DB_Tavern.getDataById(2)
			-- DataCache.changeSiliverFirstStatus()
			UserModel.addGoldNumber(-dbMedium.gold_needed)
		end

		-- MainShopView.updateTipTavern()
		-- MainScene.updateShopTip()

		-- LayerManager.removeLayout()
		-- HeroDisplay.create(dictData.ret, 2)

		-- resetShopInfo()
		resetShopInfo(function (  )
			LayerManager.removeLayout()
			HeroDisplay.create(dictData.ret, 2)
		end)

	end
end


-- 亿万招募网络请求后
function seniorRecruitCallback( cbFlag, dictData, bRet )
	if(dictData.err == "ok")then
		local shopInfo = DataCache.getShopCache()
		if( tonumber(shopInfo.seniorFreeNum ) > 0 )then
			DataCache.addGoldFreeNum(-1)
		else
			local dbSenior = DB_Tavern.getDataById(3)
			-- DataCache.changeFirstStatus()
			local nGoldCost = RecruitService.getOneCostGold()
			UserModel.addGoldNumber(-nGoldCost)
		end
		DataCache.changeGoldRecruitSum(1)

		resetShopInfo(function (  )
			LayerManager.removeLayout()
			HeroDisplay.create(dictData.ret, 3)
		end)
	end
end




local function getMysInfoCall( cbFlag, dictData, bRet ,findTid,fnCallBack)
	if (bRet) then
		if(findTid) then
			local bFind = false
			require "db/DB_Day_hero_stock"
			local mouthHeroHtid = dictData.ret.va_mystery[1]
			local fragmentTid = DB_Heroes.getDataById(mouthHeroHtid).fragment
			local findType = ItemUtil.getItemTypeByTid(findTid)

			if (fragmentTid and tonumber(fragmentTid) == tonumber(findTid)) then
				bFind = true
			end

			if (not bFind)  then
				for i=2,4 do
					local id = dictData.ret.va_mystery[i]
					local tempTid = DB_Day_hero_stock.getDataById(id).item_id
					local item_type = DB_Day_hero_stock.getDataById(id).item_type  --1为伙伴，2为宝物

					local findDB = item_type == 1 and DB_Heroes or DB_Item_exclusive
					local fragmentTid = findDB.getDataById(tempTid).fragment

					if (item_type == 2) then
						fragmentTid = lua_string_split(fragmentTid,"|")[1]
					end

					if (fragmentTid and tonumber(fragmentTid) == tonumber(findTid)) then
						bFind = true
						break
					end
					
				end
			end

			if(not bFind) then
				local m_i18n = gi18n
    			local curModuleName = LayerManager.curModuleName()
				DropUtil.destroyCallFn(curModuleName,curModuleName)
				local warningStr = findType.isShadow and m_i18n[7204] or m_i18n[7205]
        		ShowNotice.showShellInfo(warningStr)
			else
				--require "script/module/shop/MysRecruitCtrl"
				MysRecruitCtrl.create(dictData.ret,fnCallBack)
			end
		else
			--require "script/module/shop/MysRecruitCtrl"
			MysRecruitCtrl.create(dictData.ret)
		end
	end
end

function getMysClicked(findTid,fnCallBack)
	RequestCenter.shop_getRecruitInfo(function (cbFlag, dictData, bRet )
			getMysInfoCall( cbFlag, dictData, bRet,findTid,fnCallBack)
		end
		)
end


--限时福利酒馆招募打折
-- 活动期间，酒馆千万悬赏的费用（单次和十连）按照配置的折扣打折。若计算出来的值不是整数，则向下取整	
function getMidRecruitGold()
	local nGold = 0
	local nNormalGold = DB_Tavern.getDataById(3).gold_needed

	local 	nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	local 	nDiscountGOld  = math.floor(nNormalGold * nRate / 10000)

	local dd = intPercent(tonumber(nDiscountGOld),tonumber(nNormalGold))
	local sTen = dd/10

	return nDiscountGOld ,sTen
end

function getTenRecruitDiscountGold()
	local tavernData = DB_Tavern.getDataById(3)

	local nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	local ncostGoldOfTen = tonumber(lua_string_split(tavernData.gold_nums, "|")[2])

	local tenDiscountGold  = math.floor(ncostGoldOfTen * nRate / 10000) 

	local dd1 = intPercent(tonumber(tenDiscountGold),tonumber(ncostGoldOfTen))
	--折扣
	local sTen = dd1/10
	return  tenDiscountGold,sTen
end


function getOneCostGold(  )
	
	local nNormalGold = DB_Tavern.getDataById(3).gold_needed
	local 	nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	local 	nDiscountGOld  = math.floor(nNormalGold * nRate / 10000)
	local bIsOpen = isShopDiscountOk()
	if(bIsOpen) then
		return nDiscountGOld
	else
		return nNormalGold
	end
end

function getTenCostGold(  )
	-- local bIsOpen = LimitWelfareModel.isLimitWelfareOpen()
	local tavernData = DB_Tavern.getDataById(3)
	local nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	local ncostGoldOfTen = tonumber(lua_string_split(tavernData.gold_nums, "|")[2])
	local tenDiscountGold  = math.floor(ncostGoldOfTen * nRate / 10000) 
	local bIsOpen = isShopDiscountOk()
	if(bIsOpen) then
		return tenDiscountGold
	else
		return ncostGoldOfTen
	end
end

function isShopDiscountOk(  )
	local nRate = OutputMultiplyUtil.getMultiplyRateNum(8)
	logger:debug(nRate ~= 10000)
	return nRate ~= 10000
end
