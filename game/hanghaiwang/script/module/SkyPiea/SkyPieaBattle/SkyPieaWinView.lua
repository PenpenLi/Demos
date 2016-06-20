-- FileName: SkyPieaWinView.lua
-- Author: menghao
-- Date: 2015-1-15
-- Purpose: 空岛战斗胜利面板view


module("SkyPieaWinView", package.seeall)


-- UI控件引用变量 --
local m_UIMain


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaWinView"] = nil
end


function moduleName()
	return "SkyPieaWinView"
end


function create( tbInfo )
	m_UIMain = g_fnLoadUI("ui/air_win.json")

	local tbBaseRewardInfo = SkyPieaModel.getBaseRewardInfo()
	local starLv, pointX, starNumX = SkyPieaModel.getStarLv(tbInfo.hpGrade)

	local imgRainBow = m_fnGetWidget(m_UIMain, "IMG_RAINBOW")
	local imgTitle = m_fnGetWidget(m_UIMain, "IMG_TITLE")
	-- 上方三棵星星
	local layHard3 = m_fnGetWidget(m_UIMain, "LAY_HARD3")
	local imgStar1 = m_fnGetWidget(m_UIMain, "IMG_STAR1")
	local imgStar2 = m_fnGetWidget(m_UIMain, "IMG_STAR2")
	local imgStar3 = m_fnGetWidget(m_UIMain, "IMG_STAR3")

	local imgScorebg = m_fnGetWidget(m_UIMain, "img_score_bg")
	local imgStarbg = m_fnGetWidget(m_UIMain, "img_star_bg")
	-- local btnSure = m_fnGetWidget(m_UIMain, "BTN_CONFIRM")
	local LAY_FIT = m_fnGetWidget(m_UIMain, "LAY_FIT")
	imgScorebg:setVisible(false)
	imgStarbg:setVisible(false)
	LAY_FIT:setTouchEnabled(false)

	local tbWidgets = {imgScorebg, imgStarbg}
	local function onCallback()
		AudioHelper.resetAudioState()
		palyPropertyEffect(tbWidgets,function()
				LAY_FIT:setTouchEnabled(true)
				LAY_FIT:addTouchEventListener(function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCloseEffect()
						LayerManager.removeLayout()
						EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
						AudioHelper.playMainMusic()
					end
				end)
			end)
	end
	-- local function onCallback()
	-- 	local function playAction( i )
	-- 		if (i > #tbWidgets) then
	-- 			LAY_FIT:setTouchEnabled(true)
	-- 			LAY_FIT:addTouchEventListener(function ( sender, eventType )
	-- 				if (eventType == TOUCH_EVENT_ENDED) then
	-- 					AudioHelper.playCloseEffect()
	-- 					LayerManager.removeLayout()
	-- 					EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	-- 					AudioHelper.playMainMusic()
	-- 				end
	-- 			end)
	-- 			return
	-- 		end

	-- 		tbWidgets[i]:setEnabled(true)
	-- 		tbWidgets[i]:setScaleY(0)

	-- 		local actionArr = CCArray:create()
	-- 		actionArr:addObject(CCScaleTo:create(10 / 60, 1, 1.6))
	-- 		actionArr:addObject(CCScaleTo:create(5 / 60, 1, 1))
	-- 		actionArr:addObject(CCCallFunc:create(function ( ... )
	-- 			playAction(i + 1)
	-- 		end))
	-- 		tbWidgets[i]:runAction(CCSequence:create(actionArr))
	-- 	end

	-- 	playAction(1)

	-- end
	local winAnimation = EffBattleWin:new({
		imgTitle = imgTitle, imgRainBow = imgRainBow, tbStars = {imgStar1,imgStar2,imgStar3}, starLv = starLv, callback = onCallback})

	-- 积分相关
	local tfdBase = m_fnGetWidget(m_UIMain, "tfd_base")
	local tfdBaseNum = m_fnGetWidget(m_UIMain, "TFD_BASE_NUM")
	tfdBase:setText(gi18n[5426])
	tfdBaseNum:setText(tbBaseRewardInfo[tbInfo.degree].base)


	local tfdStar = m_fnGetWidget(m_UIMain, "TFD_STAR")
	local tfdStarNum = m_fnGetWidget(m_UIMain, "TFD_STAR_NUM")
	tfdStar:setText(gi18nString(5427, starLv))
	tfdStarNum:setText(pointX)

	local tfdFinalScore = m_fnGetWidget(m_UIMain, "tfd_final_score")
	-- local labnFinalScoreNum = m_fnGetWidget(m_UIMain, "LABN_FINAL_SCORE_NUM")
	local tfdFinalScoreNum = m_fnGetWidget(m_UIMain, "TFD_FINAL_SCORE_NUM")
	tfdFinalScore:setText(gi18n[5428])
	tfdFinalScoreNum:setText(tbBaseRewardInfo[tbInfo.degree].base * tonumber(pointX) .. "")

	-- 星数相关
	local tfdClean = m_fnGetWidget(m_UIMain, "tfd_clean")
	local tfdCleanNum = m_fnGetWidget(m_UIMain, "TFD_CLEAN_NUM")
	local imgGetStar1 = m_fnGetWidget(m_UIMain, "img_star_1")
	tfdClean:setText(gi18n[5429])
	tfdCleanNum:setText(starLv)

	local tfdGetStar = m_fnGetWidget(m_UIMain, "tfd_get_star")
	local tfdGetStarNum = m_fnGetWidget(m_UIMain, "TFD_GET_STAR_NUM")
	tfdGetStar:setText(gi18n[5430])
	tfdGetStarNum:setText(tbBaseRewardInfo[tbInfo.degree].star)

	local tfdFinalStar = m_fnGetWidget(m_UIMain, "tfd_final_star")
	-- local labnFinalStarNum = m_fnGetWidget(m_UIMain, "LABN_FINAL_STAR_NUM")
	local labnFinalStarNum = m_fnGetWidget(m_UIMain, "TFD_FINAL_STAR_NUM")
	local imgGetStar2 = m_fnGetWidget(m_UIMain, "img_star_1")
	tfdFinalStar:setText(gi18n[5431])
	labnFinalStarNum:setText(starLv * tonumber(tbBaseRewardInfo[tbInfo.degree].star) .. "")

	local armature2 = UIHelper.createArmatureNode({
			filePath = "images/effect/worldboss/fadein_continue.ExportJson",
			animationName = "fadein_continue",
			loop = 1,
		})
	armature2:setAnchorPoint(ccp(m_UIMain.img_txt:getAnchorPoint().x, m_UIMain.img_txt:getAnchorPoint().y))
	armature2:setPosition(ccp(m_UIMain.img_txt:getPositionX(), m_UIMain.img_txt:getPositionY()))
	m_UIMain:addNode(armature2)
	
	return m_UIMain
end

