-- FileName: ArenaReplayCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-12-13
-- Purpose: 竞技场王者对决 控制器
-- /


module("ArenaReplayCtrl", package.seeall)
require "script/module/arena/ArenaReplay"
require "script/module/arena/ArenaHighest"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["ArenaReplayCtrl"] = nil
end

function moduleName()
    return "ArenaReplayCtrl"
end

function create()
	local tbBtnEvent = {}
	-- 阵容按钮
	tbBtnEvent.onReplayBattle = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local ReplayData = ArenaData.getReplayList(  )
			-- 得到战斗串
			--  int $brid: 战报id
			function getRecord(brid, callbackFunc )
				local function requestFunc( cbFlag, dictData, bRet )
					if(bRet == true)then
						local fightRet = dictData.ret
						if (fightRet=="" or fightRet==" ") then 
							ShowNotice.showShellInfo(m_i18n[7814])
						else 
							require "script/battle/BattleModule"
							local fnCallBack = function ( ... )
							end

							BattleModule.PlayBillBoardRecord(fightRet,fnCallBack,ReplayData[sender:getTag()])
						end 
					end
				end
				-- 参数
				local args = CCArray:create()
				args:addObject(CCInteger:create(brid))
				RequestCenter.battle_getRecord(requestFunc,args)
			end
			local brid = ReplayData[sender:getTag()].replay
			getRecord(brid)
		end
	end
	-- 幸运排名按钮
	tbBtnEvent.onLuckRank = function( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onLuckRank")
			AudioHelper.playCommonEffect()
			require "script/module/arena/ArenaLuckCtrl"
			ArenaLuckCtrl.create()
		end	
	end
	local view = ArenaReplay.create(tbBtnEvent)
	return view
end
