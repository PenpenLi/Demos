
KeyboardTestScene = class()



-- ======================================
-- ===========  一些快捷键 ==============
-- ======================================
-- bit2 = require("bit")
-- tmp = {}
-- randFactory2 = HERandomObject:create()
gHookInfo = {}
key40tick = 0
debugButtonTick = 0
velocitys = {0.25,0.5,1,2,4}
baseVelocityIndex = 3
function gKeyUp(eventType,keyCode)
	-- keyUp
	if (eventType == "257") then 
		he_log_warning("key up "..tostring(eventType).." "..tostring(keyCode))

		-- 上箭头
		if (keyCode == "38") then 
			baseVelocityIndex = baseVelocityIndex + 1
			baseVelocityIndex = math.min(baseVelocityIndex,#velocitys)			
			
			debugDoChangeVelocity(baseVelocityIndex)
		-- 下箭头
		elseif (keyCode == "40") then
			baseVelocityIndex = baseVelocityIndex - 1
			baseVelocityIndex = math.max(baseVelocityIndex,1)
			
			debugDoChangeVelocity(baseVelocityIndex)
		--  左箭头
		elseif (keyCode == "37") then 
			-- require("zoo/test/TestCCParabolaMoveTo"):createSence()
			debugDoAddMove(-1)
		--  右箭头
		elseif (keyCode == "39") then 
			debugDoAddMove(1)
		-- d
		elseif (keyCode == "68") then
			debugDoTrace()
		-- j
		elseif (keyCode == "74") then
			debugDoPrint()
		-- t
		elseif (keyCode == "84") then
			debugDoTest()
		-- shift
		elseif (keyCode == "16") then
			debugButtonTick = debugButtonTick + 1
			if (debugButtonTick % 2 == 1) then
				PreloadingSceneUI:buildDebugButton( Director:sharedDirector():getRunningScene() )
			else
				PreloadingSceneUI:removeDebugButtons()
			end
		end
	end
end

function debugDoTest()
	-- HomeScene 
	local scene = CCDirector:sharedDirector():getRunningScene()
	local rewards = {}
	local reward = {}
	reward.itemId = 10010
	reward.num = 2
	table.insert(rewards,reward)

	local param = {}
	param.reward = rewards

	-- rewards[""]
	scene:playLadyBugAnimation(99,param)
end

function debugDoChangeVelocity(type)
	CCDirector:sharedDirector():setVelocityScaler(velocitys[type])

		-- 游戏
	local scene = Director:sharedDirector():getRunningScene()
	if (not scene.gameBoardLogic) then
		-- 编辑器
		scene = _G.currentEditorLevelScene
	end

	logic = scene.gameBoardLogic
	view = scene.gameBoardView

	-- local time_cd = 1.0 / (GamePlayConfig_Action_FPS *　velocitys[type])
	-- Director:getScheduler():unscheduleScriptEntry(view.updateScheduler)
	-- view.updateScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(view.___updateGame, time_cd, false)
	view:changeGameSpeed(velocitys[type])
end

function debugDoPrint()
	for i=1,30 do
		print("")
	end
end

function debugDoAddMove(step)
	-- 游戏
	local scene = Director:sharedDirector():getRunningScene()

	if (not scene.gameBoardLogic) then
		-- 编辑器
		scene = _G.currentEditorLevelScene
	end

	logic = scene.gameBoardLogic
	view = scene.gameBoardView
	logic.theCurMoves = logic.theCurMoves  + step
	logic.PlayUIDelegate:setMoveOrTimeCountCallback(logic.theCurMoves, false)
end

function debugDoTrace()
	local cHook = debug.gethook()
	if (cHook) then
		debug.sethook()
		gHookInfo = {}
	else
		debug.sethook(function(event,line)
				line = line or "" 
				local info = debug.getinfo(2,"Sn")
			 	local s = info.short_src

			 	-- 由于打印信息太多，打印过的就不再打印了
			 	if (info.linedefined ~= -1) then
			 		local p = s .. ":" .. info.linedefined
					if ( not gHookInfo[p]) then 
						he_log_warning(p)
					end
					gHookInfo[p] = true
				end
		end,"c")
	end
end



