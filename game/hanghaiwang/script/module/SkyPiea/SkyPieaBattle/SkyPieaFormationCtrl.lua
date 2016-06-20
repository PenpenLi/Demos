-- FileName: SkyPieaFormationCtrl.lua
-- Author: menghao
-- Date: 2015-1-14
-- Purpose: 空岛阵容ctrl


module("SkyPieaFormationCtrl", package.seeall)


require "script/module/SkyPiea/SkyPieaBattle/SkyPieaFormationView"

local m_i18n = gi18n
-- UI控件引用变量 --


-- 模块局部变量 --
local m_nDegree


local function init(...)

end


function destroy(...)
	package.loaded["SkyPieaFormationCtrl"] = nil
end


function moduleName()
	return "SkyPieaFormationCtrl"
end


function afterBattle( data )
	logger:debug("看看有什么数据")
	logger:debug(data)

	--[[
	va_pass = {
		opponentInfo = {},
		union ={
			10032160 = {15 = "2700",14 = "2700"}
		},

		chestShow = {},
		heroInfo = {
			10032160 = {
				currHp = "10000000",
				currRage ="7",
				equipInfo ={
					arming ={
						2 ="0",
						4 ="0",
						1 ="0",
						3 ="0",
						},
						
					treasure ={
						},
						
					daimonApple ={
						1 ={
							item_template_id ="205008",
							item_num ="1",
							va_item_text ={
								},
								
							item_id ="1022423",
							item_time ="1421674914.000000",
							},
							
						},
						
					}	,
				}	,			
			},
			
		formation ={
			1 ="10065416",
			2 ="10032162",
			3 ="10032160",
			4 ="10065526",
			5 ="10066028",
			6 ="0",
			},
			
		buffShow ={
			},
			
		bench ={
			1 ="10032163",
			2 ="10066034",
			3 ="0",
			},
			
		}

	star_star = "25"
	point = "750"
	cur_base = "2"
		
	uid ="25034"
	appraisal ="SSS"
	hpGrade = "10000"
	point = "750"
	star_star = "25"
	cur_base = "2"

	--]]
	logger:debug(data.cur_base)
	SkyPieaModel.setCurFloor(data.cur_base)
	SkyPieaModel.setPoint(data.point)
	SkyPieaModel.setStarNum(data.star_star)
	SkyPieaModel.setHeroInfo(data.va_pass.heroInfo)
	DataCache.setSkypieaData(data)
	SkyPieaModel.setFormationAndBench(data.va_pass.formation, data.va_pass.bench)

	MainSkyPieaView.upPointAndStarNum()
end


function enterBattle( cbFlag, dictData, bRet )
	logger:debug(dictData)
	if (dictData.err ~= "ok") then
		ShowNotice.showShellInfo("attack 出错了")
		return
	end

	LayerManager.removeLayout()

	local tbInfo = {hpGrade = dictData.ret.hpGrade, degree = m_nDegree}

	require "script/battle/BattleModule"
	BattleModule.playSkyPiea( dictData.ret.fightStr, function ( ... )
		afterBattle(dictData.ret)
	end, tbInfo)
end


function onStartFight( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("start_fight.mp3")

		-- modife zhangjunwu 前后端统一去掉战斗的背包判断 2015-03-09
		-- if (ItemUtil.isBagFull(true)) then
		-- 	return
		-- end

		if (SkyPieaUtil.isShowRewardTimeAlert() == true) then
			return
		end
		local nCurFloor  = SkyPieaModel.getCurFloor()

		local function onFight(sender, eventType)
			if (eventType == TOUCH_EVENT_ENDED) then
					local args = Network.argsHandler(nCurFloor, m_nDegree)
					local arrFormation = CCArray:create()
					local arrBench = CCArray:create()
					if (not SkyPieaModel.getIsFormationLock()) then
						local tbFormationInfo = SkyPieaModel.getFormationInfo()
						for i=1,9 do
							local hid = tbFormationInfo[i]
							if (i <= 6) then
								arrFormation:addObject(CCInteger:create(hid))
							else
								arrBench:addObject(CCInteger:create(hid))
							end
						end
					end
					args:addObject(arrFormation)

					args:addObject(arrBench)


					if(sender ~= nil) then
						LayerManager.removeLayout()
					end
					RequestCenter.skyPieaAttack(enterBattle, args)

			end
		end
		logger:debug(nCurFloor)
		if(tonumber(nCurFloor) == 1) then
			logger:debug(nCurFloor)
			local sAlert = m_i18n[5480]

			local layDlg = UIHelper.createCommonDlg(sAlert, nil, onFight)
    		LayerManager.addLayout(layDlg)
		else
			onFight(nil,TOUCH_EVENT_ENDED)
		end

		
	end
end


function create( degree,tbBuffInfo)
	m_nDegree = degree
	local layMain = SkyPieaFormationView.create(onStartFight,tbBuffInfo)
	LayerManager.addLayout(layMain)
end

