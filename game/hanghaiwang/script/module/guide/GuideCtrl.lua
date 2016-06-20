-- FileName: GuideCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-06-06
-- Purpose: function description of module
--[[TODO List]]
-- 新手引导控制器模块


module("GuideCtrl", package.seeall)
require "script/network/RequestCenter"
require "script/module/guide/GuideModel"
require "script/module/copy/itemCopy"
require "script/module/copy/MainCopy"
-- UI控件引用变量 --

-- 模块局部变量 --
local function init(...)

end

function destroy(...)
	package.loaded["GuideCtrl"] = nil
end

function moduleName()
    return "GuideCtrl"
end

function create(...)

end


function test( ... )
	--  调试新手引导使用 勿删
		-- GuideCtrl.setPersistenceGuide("copy2Box","17")

		-- GuideCtrl.setPersistenceGuide("shop","16")
		-- GuideCtrl.setPersistenceGuide("fmt","2")
		-- GuideModel.setGuideClass(ksGuideSmithy)
  --       GuideCtrl.createEquipGuide(1)
		-- GuideModel.setGuideClass(ksGuideExplore)
		-- GuideCtrl.createExploreGuide(1)
		-- GuideModel.setGuideClass(ksGuideTreasure)
		-- GuideCtrl.createTreasGuide(2)
		-- GuideModel.setGuideClass(ksGuideFormation)
		-- GuideCtrl.createFormationGuide(1)
		-- GuideModel.setGuideClass(ksGuideArena)
		-- GuideCtrl.createArenaGuide(1)
		-- GuideModel.setGuideClass(ksGuideAcopy)
		-- GuideCtrl.createAcopyGuide(1)
		-- GuideModel.setGuideClass(ksGuideSkypiea)
		-- GuideCtrl.createSkyPieaGuide(1)
		-- GuideModel.setGuideClass(ksGuideFiveLevelGift)
		-- 	GuideCtrl.createkFiveLevelGiftGuide(7)
		-- GuideCtrl.setPersistenceGuide("destiny","2")
		-- GuideModel.setGuideClass(ksGuideDestiny)

		-- GuideModel.setGuideClass(ksGuideResolve)
		-- GuideCtrl.createDecomGuide(1)

		-- GuideModel.setGuideClass(ksGuideResource)
		-- require "script/module/guide/GuideCtrl"
		-- GuideCtrl.createResGuide(1)
		-- require "script/module/guide/GuideModel"
		-- GuideModel.setGuideClass(ksGuideBoss)
		-- require "script/module/guide/GuideCtrl"
		-- GuideCtrl.createBossGuide(1)
		-- GuideModel.setGuideClass(ksGuideImpelDown)
		-- GuideCtrl.createImpelDownGuide(1)
		-- GuideModel.setGuideClass(ksGuideMainShip)
		-- GuideCtrl.createShipMainGuide(1)
		-- GuideModel.setGuideClass(ksGuideAwake)
		-- GuideCtrl.createAwakeGuide(1)
end

--  从0 开始
-- 获取当前阵容上 伙伴等级是否超过 或者等于 用户等级
local function getFmtHeroIsForgeByPos( pos )
	local squad = DataCache.getSquad()
	logger:debug(squad)
	-- local userLevel = UserModel.getHeroLevel()
	local pHid = tonumber(squad[tostring(pos)])
	if pHid and pHid ~= 0 then
		local tHero = HeroModel.getHeroByHid(pHid)
		local heroLevel = tonumber(tHero.level)
		-- logger:debug(tHero)
		return  heroLevel > 1
	end
	return false
end

-- 从0 开始
-- 获取阵容上有没有 根据阵容位置 
local function getFmtHasHeroByPos(pos)
	local squad = DataCache.getSquad()
	local userLevel = UserModel.getHeroLevel()
	local pHid = tonumber(squad[tostring(pos)])
	if pHid and pHid ~= 0 then
		return true
	end
	return false
end

-- 直接进入阵容 pos 从0 开始
function direct2Formation( pos )
	require "script/module/formation/MainFormation"
	if (MainFormation.moduleName() ~= LayerManager.curModuleName()) then
		local layFormation = MainFormation.create(pos)
		if (layFormation) then
			MainFormation.hideActiveEffect()
			LayerManager.changeModule(layFormation, MainFormation.moduleName(), {1,3}, true)
		end
	end
end

-- 获取阵容上的伙伴是否进阶过 pos 从0 开始
function getHeroOnFmtIsEvolvedByPos( pos )
	local squad = DataCache.getSquad()
	local userLevel = UserModel.getHeroLevel()
	local pHid = tonumber(squad[tostring(pos)])
	if pHid and pHid ~= 0 then
		local tHero = HeroModel.getHeroByHid(pHid)
		logger:debug(tHero)
		local evolve_level = tonumber(tHero.evolve_level)
		if evolve_level ~= 0 then
			return true
		end
	end
	return false
end

-- 获取是否打败第几个据点 
-- status:int        状态：0是没有开启  1是能显示  2是能攻击  3是通关
local function getIsPassCopyById( copyId )
	local normalCopyData = DataCache.getNormalCopyData()
	local sCopyId = tostring(copyId)
	if (normalCopyData.copy_list["1"].va_copy_info.baselv_info[sCopyId]["1"].status == "1" or 
			normalCopyData.copy_list["1"].va_copy_info.baselv_info[sCopyId]["1"].status == "2") then
		return false
	else
		return true
	end
end

-- sType: string (silver, gold )
-- 获取商店是不是招募过 
local function getShopHeroIsRecruitByType( sType )
	local shopInfo = DataCache.getShopCache()
	logger:debug({shopInfo = shopInfo})
	if shopInfo then
		if sType == "silver" then
			return (tonumber(shopInfo.silver_recruit_num) + tonumber(shopInfo.silver_recruit_free))
		elseif sType == "gold" then
			return tonumber(shopInfo.gold_recruit_num)
		elseif sType == "free" then
			logger:debug({shopInfo = shopInfo.va_shop.fake})
			if shopInfo.va_shop.fake then
				return 0
			else
				return 1
			end
		end
	end
	return 0
end


function setGuideLayer(  )
	--  对话层
	local talkLayer = LayerManager.getTalkLayer()
	--  新手引导层
	local guideLayer = LayerManager.getGuideLayer()
	if (talkLayer and guideLayer) then
		guideLayer:setVisible(false)
	end
end


-- sKey 当前引导 需要的类型 
-- sValue  当前引导 需要保存的第几步

function setPersistenceGuide( sKey,sValue )
	logger:debug("sKey = " .. sKey .. "sValue = " .. sValue)
	--[[
	function networkCallBack(cbFlag, dictData, bRet)
		
	end
	
	local params = CCArray:create()
	params:addObject(CCString:create("newGuide"))

	local args = CCArray:create()
	args:addObject(CCString:create(sKey))
	args:addObject(CCString:create(sValue))
	params:addObject(args)
	RequestCenter.user_setArrConfig(networkCallBack,params)
	--]]
	GuideModel.setPersistenceGuideData(sKey,sValue)
end


-- 创建 记忆性引导
function createPersistenceGuide( )
	if g_tGuideState.g_closeGuide then -- 增加一个开关 在GlobalVars.lua 中 设置成true 后就关闭引导
		return 
	end
	require "script/module/switch/SwitchModel"
	local guideCache = GuideModel.getPersistenceGuideData()
	logger:debug("guideCache = %s", guideCache)
	if(guideCache ~= nil and guideCache == "arena2" and SwitchModel.getSwitchOpenState(ksSwitchArena,false)) then -- 竞技场引导记忆
		GuideModel.setGuideClass(ksGuideArena)
		GuideCtrl.createArenaGuide(1)
	elseif(guideCache ~= nil and guideCache == "destiny2" and SwitchModel.getSwitchOpenState(ksSwitchDestiny,false)) then -- 天命引导记忆
		GuideModel.setGuideClass(ksGuideDestiny)
		GuideCtrl.createTrainGuide(1)

	elseif(guideCache ~= nil and guideCache == "astrology4" and SwitchModel.getSwitchOpenState(ksSwitchStar,false)) then -- 占星引导记忆
		GuideModel.setGuideClass(ksGuideAstrology)
		GuideCtrl.createAstrologyGuide(1)
	
	elseif (guideCache ~= nil and guideCache == "fmt2" and SwitchModel.getSwitchOpenState(ksSwitchGeneralForge,false))then -- 伙伴强化
		if getFmtHeroIsForgeByPos(0) then -- 如果强化过后就 直接到 第六步 应该进副本打1002据点
			GuideCtrl.setPersistenceGuide("fmt","6")
			createPersistenceGuide()
		else
			GuideModel.setGuideClass(ksGuideFormation)
			GuideCtrl.createFormationGuide(1)
		end
		
	elseif (guideCache ~= nil and guideCache == "fmt6" and SwitchModel.getSwitchOpenState(ksSwitchGeneralForge,false))then -- 伙伴强化
		
		if not getIsPassCopyById(1002) then -- 如果没有打败第二个据点就 应该继续这个
			GuideModel.setGuideClass(ksGuideFormation)
			GuideCtrl.createFormationGuide(6)
		else
			GuideCtrl.setPersistenceGuide("shop","2")
			createPersistenceGuide()
		end
		
	elseif (guideCache ~= nil and guideCache == "shop2" and SwitchModel.getSwitchOpenState(ksSwitchShop,false))then -- 酒馆招募
		logger:debug("getShopHeroIsRecruitByType" .. getShopHeroIsRecruitByType("free"))
		if getShopHeroIsRecruitByType("free") == 0 then -- 没有招募过千
			GuideModel.setGuideClass(ksGuideFiveLevelGift)
			GuideCtrl.createkFiveLevelGiftGuide(1)
		else --  已经招募过千万招募
			GuideCtrl.setPersistenceGuide("shop","7")
			createPersistenceGuide()
		end
		
	elseif (guideCache ~= nil and guideCache == "shop7" and SwitchModel.getSwitchOpenState(ksSwitchShop,false))then -- 酒馆招募
		if not getFmtHasHeroByPos(1) then -- 如果阵容对应的位置没有人
			GuideModel.setGuideClass(ksGuideFiveLevelGift)
			GuideCtrl.createkFiveLevelGiftGuide(5)
		else -- 如果阵容对应的位置有人
			GuideCtrl.setPersistenceGuide("shop","11")
			createPersistenceGuide()
		end		
	elseif (guideCache ~= nil and guideCache == "shop11" and SwitchModel.getSwitchOpenState(ksSwitchShop,false))then -- 酒馆招募
		if not getFmtHeroIsForgeByPos(1) then
			direct2Formation(1)
			MainFormation.setHeroPageViewTouchEnabled(false)
			GuideModel.setGuideClass(ksGuideFiveLevelGift)
			GuideCtrl.createkFiveLevelGiftGuide(9)
		else
			GuideCtrl.setPersistenceGuide("shop","15")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "shop15" and SwitchModel.getSwitchOpenState(ksSwitchShop,false))then -- 酒馆招募
		if not getIsPassCopyById(1003) then
			GuideModel.setGuideClass(ksGuideFiveLevelGift)
			GuideCtrl.createkFiveLevelGiftGuide(13)
		else
			-- GuideCtrl.setPersistenceGuide("shop","18")
			-- createPersistenceGuide()
			GuideCtrl.setPersistenceGuide("copyBox","3")
			createPersistenceGuide()
		end	
	elseif (guideCache ~= nil and guideCache == "copyBox3")then -- 第一个副本宝箱副本宝箱
			--0 --没领过 且不可以领取
			--1  --已领取
			--2  --可以领
			logger:debug("itemCopy.isCanGetCopyRewardByids(1,1,1) = %s",itemCopy.isCanGetCopyRewardByids(1,1,1))
		if itemCopy.isCanGetCopyRewardByids(1,1,1) == 2 then -- 如果可以领取
			MainCopy.extraToCopyScene(1,1)
	     	GuideModel.setGuideClass(ksGuideCopyBox)
	        GuideCtrl.createCopyBoxGuide(1)   
		elseif itemCopy.isCanGetCopyRewardByids(1,1,1) == 1 then -- 如果已经领取过
			GuideCtrl.setPersistenceGuide("copyBox","9")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copyBox9")then -- 第一个副本宝箱副本宝箱
		-- 判断有没有进阶过
		if not getHeroOnFmtIsEvolvedByPos(0) then
			GuideModel.setGuideClass(ksGuideCopyBox)
			GuideCtrl.createCopyBoxGuide(5)
		else
			GuideCtrl.setPersistenceGuide("copyBox","14")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copyBox14")then -- 酒馆招募
		if not getIsPassCopyById(1004) then
			GuideModel.setGuideClass(ksGuideCopyBox)
			GuideCtrl.createCopyBoxGuide(10)
		else
			GuideCtrl.setPersistenceGuide("copyBox","15")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copyBox15")then -- 第一个副本宝箱副本宝箱
		-- 判断有没有打过第5个据点
		if not getIsPassCopyById(1005) then -- 如果没打过
			MainCopy.extraToCopyScene(1,1)
			GuideModel.setGuideClass(ksGuideCopyBox)
			GuideCtrl.createCopyBoxGuide(14,nil, itemCopy.getHolePos())
			itemCopy.disableSCV()
		else -- 打过了 就该领取第二个副本宝箱了
			GuideCtrl.setPersistenceGuide("copy2Box","3")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copy2Box3")then -- 第2个副本宝箱副本宝箱
		if itemCopy.isCanGetCopyRewardByids(1,1,2) == 2 then -- 如果可以领取
			MainCopy.extraToCopyScene(1,1)
	     	GuideModel.setGuideClass(ksGuideCopy2Box)
	        GuideCtrl.createCopy2BoxGuide(1)    
		elseif itemCopy.isCanGetCopyRewardByids(1,1,2) == 1 then -- 如果已经领取过
			GuideCtrl.setPersistenceGuide("copy2Box","8")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copy2Box8")then -- 第2个副本宝箱副本宝箱
		if getShopHeroIsRecruitByType("gold") == 0 then --如果没有招募过亿万招募 
			GuideModel.setGuideClass(ksGuideCopy2Box)
			GuideCtrl.createCopy2BoxGuide(5)
		else
			GuideCtrl.setPersistenceGuide("copy2Box","13")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copy2Box13")then -- 第2个副本宝箱副本宝箱
		if not getFmtHasHeroByPos(2) then -- 如果阵容上没人 则引导上阵
			GuideModel.setGuideClass(ksGuideCopy2Box)
			GuideCtrl.createCopy2BoxGuide(9)
		else
			GuideCtrl.setPersistenceGuide("copy2Box","17")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copy2Box17")then -- 第2个副本宝箱副本宝箱
		if not getFmtHeroIsForgeByPos(2) then -- 看看第三个伙伴栏位的伙伴能不能强化
			direct2Formation(2)
			MainFormation.setHeroPageViewTouchEnabled(false)
			GuideModel.setGuideClass(ksGuideCopy2Box)
			GuideCtrl.createCopy2BoxGuide(13)
		else 
			GuideCtrl.setPersistenceGuide("copy2Box","19")
			createPersistenceGuide()
		end
	elseif (guideCache ~= nil and guideCache == "copy2Box19")then -- 第2个副本宝箱副本宝箱
		GuideModel.setGuideClass(ksGuideCopy2Box) -- 应该点击副本按钮
		GuideCtrl.createCopy2BoxGuide(17)
	-- elseif (guideCache ~= nil and guideCache == "equipStre2") then
	-- 	GuideModel.setGuideClass(ksGuideSmithy)
	-- 	GuideCtrl.createEquipGuide(1)
	-- elseif (guideCache ~= nil and guideCache == "equipStre5") then
	-- 	-- direct2Formation(0)
	-- 	GuideModel.setGuideClass(ksGuideSmithy)
	-- 	GuideCtrl.createEquipGuide(10)
	-- else
		
		--TDDO 其他引导
	end
end





-- 移除引导
function removeGuide( )
	GuideModel.setGuideClass()
	LayerManager:removeGuideLayer()
	GuideModel.setGuideState(false)
end

function removeGuideView( )
	LayerManager:removeGuideLayer()
end

-- 创建阵容引导 上阵 第一个伙伴引导
-- modified by zhangqi, 2014-07-15, 添加参数 pos, 副本引导中会传入当前据点的坐标
function createFormationGuide( step, pos, fnCallBack)
	require "script/module/guide/GuideFormationView"
	removeGuideView()
	GuideModel.setGuideState(true)

	UserModel.recordUsrOperation("formation", step) -- 2015-11-24, 记录3级前用户行为

	local layer = GuideFormationView.create(step,pos, fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建伙伴进阶引导 -- 暂时去掉伙伴进阶引导
-- modified by zhangqi, 2014-07-15, 添加参数 pos, 副本引导中会传入当前据点的坐标
function createPartnerAdvGuide( step, opacity, pos)
	-- require "script/module/guide/GuidePartnerAdvView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuidePartnerAdvView.create(step,opacity,pos)
	-- LayerManager.addGuideLayer(layer)
	-- setGuideLayer()
end

-- 创建5级等级礼包引导 －》 招将－》上阵 －》强化
-- modified by zhangqi, 2014-07-15, 添加参数 pos, 副本引导中会传入当前据点的坐标
function createkFiveLevelGiftGuide( step, opacity, pos, fnCallBack)
	require "script/module/guide/GuideFiveLevelGiftView"
	removeGuideView()
	GuideModel.setGuideState(true)

	UserModel.recordUsrOperation("levelReward", step) -- 2015-11-24

	local layer = GuideFiveLevelGiftView.create(step,opacity,pos, fnCallBack)
	LayerManager.addGuideLayer(layer)
	setGuideLayer()
end

-- 创建领取副本宝箱引导
function createCopyBoxGuide( step, opacity, pos, fnCallBack)
	require "script/module/guide/GuideCopyBoxView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideCopyBoxView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
	setGuideLayer()
end

--  创建装备强化引导
function createEquipGuide( step, opacity, pos)
	require "script/module/guide/GuideEquipView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideEquipView.create(step,opacity,pos)
	LayerManager.addGuideLayer(layer)
end

-- 创建夺宝引导 －》穿宝物
function createRobGuide( step, opacity, pos, fnCallBack)
	-- require "script/module/guide/GuideRobView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideRobView.create(step,opacity,pos, fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建第四个上阵伙伴引导 
function createForthFormationGuide(step, opacity, fnCallBack)
	require "script/module/guide/GuideForthFormationView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideForthFormationView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建竞技场引导
function createArenaGuide(step, opacity, pos,fnCallBack)
	require "script/module/guide/GuideArenaView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideArenaView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建精英副本引导
function createEliteGuide( step, opacity )
	require "script/module/guide/GuideEliteView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideEliteView.create(step,opacity)
	LayerManager.addGuideLayer(layer)
end

-- 创建分解室 和 神秘商店引导
function createDecomGuide( step,opacity,fnCallBack )
	require "script/module/guide/GuideDecomView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideDecomView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建天命系统引导
function createTrainGuide( step, opacity,fnCallBack)
	require "script/module/guide/GuideTrainView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideTrainView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建占星 系统引导
function createAstrologyGuide( step,opacity,fnCallBack)
	-- require "script/module/guide/GuideAstrologyView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideAstrologyView.create(step,opacity,fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建签到系统引导
function createSignGuide( step,opacity,fnCallBack ) -- 签到引导 暂时先去掉
	-- require "script/module/guide/GuideSignView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideSignView.create(step,opacity,fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建探索系统引导
function createExploreGuide(step, opacity, fnCallBack)
	require "script/module/guide/GuideExploreView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideExploreView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end


-- 创建宝物引导
function createTreasGuide(step, opacity,pos, fnCallBack) 
	-- require "script/module/guide/GuideTreasView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideTreasView.create(step, opacity, pos, fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建 伙伴，装备，宝物，重生引导 
function createRebornGuide( step, opacity, fnCallBack )
	-- require "script/module/guide/GuideRebornView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideRebornView.create(step,opacity,fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建联盟系统引导
function createGuildGuide( step, opacity, fnCallBack)
	require "script/module/guide/GuideGuildView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideGuildView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建阵容小伙伴系统引导
function createLitFmtGuide( step, opacity, fnCallBack)
	-- require "script/module/guide/GuideLitFmtView"
	-- removeGuideView()
	-- GuideModel.setGuideState(true)
	-- local layer = GuideLitFmtView.create(step,opacity,fnCallBack)
	-- LayerManager.addGuideLayer(layer)
end

-- 创建神秘空岛系统引导
function createSkyPieaGuide( step,opacity,fnCallBack)
	require "script/module/guide/GuideSkyPieaView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideSkyPieaView.create(step,opacity,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建活动副本引导
function createAcopyGuide( step, opacity, fnCallBack, pos)
	require "script/module/guide/GuideAcopyView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideAcopyView.create(step,opacity,fnCallBack, pos)
	LayerManager.addGuideLayer(layer)
end

-- 创建第二个副本宝箱引导
function createCopy2BoxGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideCopy2BoxView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideCopy2BoxView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建主船功能引导
function createShipMainGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideShipMainView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideShipMainView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建资源矿功能引导
function createResGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideResView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideResView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建海王类功能引导
function createBossGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideBossView"
	removeGuideView()
	GuideModel.setGuideState(true)
	local layer = GuideBossView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建深海监狱功能引导
function createImpelDownGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideImpelDownView"
	removeGuideView()
	GuideModel.setGuideState(true)
	logger:debug("createImpelDownGuide = %s", step)
	local layer = GuideImpelDownView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建觉醒功能引导
function createAwakeGuide( step, opacity,pos,fnCallBack)
	require "script/module/guide/GuideAwakeView"
	removeGuideView()
	GuideModel.setGuideState(true)
	logger:debug("createImpelDownGuide = %s", step)
	local layer = GuideAwakeView.create(step,opacity,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end

-- 创建觉醒功能引导
function createGCGuide( step,pos,fnCallBack)
	require "script/module/guide/GuideGCView"
	removeGuideView()
	GuideModel.setGuideState(true)
	logger:debug("createGCGuide = %s", step)
	local layer = GuideGCView.create(step,pos,fnCallBack)
	LayerManager.addGuideLayer(layer)
end
