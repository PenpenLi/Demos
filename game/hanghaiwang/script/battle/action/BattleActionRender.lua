module("BattleActionRender",package.seeall)

 
	------------------ properties ----------------------
	actionMap											= {}
	autoReleaseTarget 									= {} -- 由render负责删除
	-- releaseLaterMap										= {} -- 延迟1帧后调用release
	local state											= STATE_IDLE
	-- local schedulerid 									= 0	
	-- local interval 										= 1/60
	local speed 										= 1
	local actionNumner 									= 0

	local actionLinkList								= nil -- action链表
	local autoReleaseLinkList							= nil -- action链表
	------------------ functions -----------------------

	STATE_IDLE											= 0
	STATE_RUNNING										= 1
	STATE_PAUSE											= 2

	
	function start()
		actionLinkList 									= require("script/battle/data/BattleLinkList").new()
		autoReleaseLinkList								= require("script/battle/data/BattleLinkList").new()
		autoReleaseLinkList.printLog 					= false
		actionLinkList.printLog							= true
		if state ~= STATE_RUNNING then 
			state 										= STATE_RUNNING
			--int nHandler, int priority)
			local scene = CCDirector:sharedDirector():getRunningScene()

			scene:scheduleUpdateWithPriorityLua(onCall,1000)
			-- schedulerid 								= CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onCall, interval, false)
			CCDirector:sharedDirector():getScheduler():setTimeScale(BattleMainData.getTimeSpeed())
		end
	end

	function stop()
		state 										= STATE_IDLE
		local scene = CCDirector:sharedDirector():getRunningScene()
		scene:unscheduleUpdate()
		CCDirector:sharedDirector():getScheduler():setTimeScale(1)
	end -- function end

   function onCall(dt)
			-- local startT=os.clock()
			-- local callTime = 0
			-- for i,action in pairs(actionMap) do
			-- 	-- --print("BattleActionRender update ->",action:instanceName())
			-- 	callTime = callTime + 1
			-- 	action:update(dt)
			-- end
			-- Logger.debug("BattleActionRender->onCall start")
			actionLinkList:update(dt)
			-- Logger.debug("BattleActionRender->onCall end")
			-- for k,v in pairs(autoReleaseTarget) do
			-- 	v:update(dt)
			-- end
			-- local endT=os.clock()
			-- print("actionRender castTime:",endT - startT)
			-- for actionName,data in pairs(releaseLaterMap) do
			-- 	data.time = data.time - 1
			-- 	if(data.time < 0 ) then
			-- 		--print("###########  later release :",actionName)
			-- 		data.target:release()
			-- 		releaseLaterMap[actionName] = nil
			-- 		actionNumner				= actionNumner - 1
			-- 	end
			-- end
		-- Logger.debug("BattleActionRender frame time ->" .. tostring(dt * 1000))
		----print("BattleActionRender call time ->",callTime)
	end

	function check()
		
		if actionNumner > 0 then
			return state ~= STATE_RUNNING and start()
		else
			stop()
		end
	end
	-- insert												= {}
	function addAction(target)
		-- local ke = target:instanceName()
		-- print("actionRender:addAction ->", ke)
		actionLinkList:add(target)
		-- --验证节点合法性
		-- insert = target
		-- local ke = target:instanceName()
		-- -- --print("actionRender:addAction ->", ke,"action:",#(target.__index))
		-- -- for kk,jj in ipairs(target) do
		-- -- 	--print("action:",jj)
		-- -- end
		
		-- if target.update ~= nil  and target:instanceName() ~= nil then
 	-- 	   if actionMap[ke] == nil then
 	-- 	   		actionMap[ke] 							= target
 	-- 	   		actionNumner							= actionNumner + 1
 	-- 	   		-- for i,v in ipairs(actionMap) do
 	-- 	   		-- 	--print("actionRender:addAction result->",v:instanceName())
 	-- 	   		-- end
 	-- 	   		-- --print("actionRender:addAction complete")
 	-- 	   	else
 	-- 	   		--print("actionRender:addAction failed at 1")
 	-- 	   	end-- if end
 	-- 	else
 	-- 		--print("actionRender:addAction failed")
		-- end -- if end
		-- --check()
	end -- function end
	-- 添加自动释放action,会被调用start
	function addAutoReleaseAction(target)
		if target.update ~= nil  and target:instanceName() ~= nil then
			-- local onComplete = function(target1,data) 
			-- 	-- --print("addAutoReleaseAction onComplete:",target1.name)
			-- 	-- autoReleaseTarget[target:instanceName()] = nil 
			-- 	autoReleaseLinkList:remove(target)
	 	-- 		target:release()
			-- end
			local ta = {}
			
			function ta:onComplete(target1,data) 
				-- --print("addAutoReleaseAction onComplete:",target1.name)
				-- autoReleaseTarget[target:instanceName()] = nil 
				autoReleaseLinkList:remove(target)
	 			target:release()
			end

			target.calllerBacker:addCallBacker(ta,ta.onComplete)
			-- autoReleaseTarget[target:instanceName()] = target
			autoReleaseLinkList:add(target)
			target:start()
		end
		
	end

	-- function onAutoReleaseActionComplete(target,data)
	--  	if target ~= nil then
	--  		-- --print("onAutoReleaseActionComplete:",target.name)
	--  		-- for k,v in pairs(target) do
	--  		-- 	--print("onAutoReleaseActionComplete property:",k," ",v)
	--  		-- end
	--  		autoReleaseTarget[target:instanceName()] = nil 
	--  		target:release()
	--  	end
	-- end

	function removeAutoReleaseAction( action )
		autoReleaseLinkList:remove(action)
		--  if autoReleaseTarget[action:instanceName()] and action:instanceName() ~= nil then   
		-- 	  -- actionNumner								= actionNumner - 1
			  
		-- 	   autoReleaseTarget[action:instanceName()]  		= nil
		-- 	   -- --print("########################## removeAction:",action:instanceName())
		-- end
		if( action ) then
			 action:release()
		end
	end

	function removeAction(action)
		

		actionLinkList:remove(action)
		-- actionLinkList:markRemove(action)

		-- if actionMap[action:instanceName()] and action:instanceName() ~= nil then   
		-- 	   actionNumner								= actionNumner - 1
		-- 	   --action:release()
		-- 	   -- if(actionMap[action:instanceName()] and actionMap[action:instanceName()].release)then
		-- 	   -- 		actionMap[action:instanceName()]:release()
		-- 	   -- end
		-- 	   actionMap[action:instanceName()]  		= nil

		-- 	   -- --print("########################## removeAction:",action:instanceName())
		-- end
		--check()
	end -- function end
	-- function addReleaseLayer(action)
		
	-- 	if releaseLaterMap[action:instanceName()] == nil and action:instanceName() ~= nil then   
			   
	-- 		releaseLaterMap[action:instanceName()]  	= {target=action,time=1}
 -- 			actionNumner								= actionNumner + 1
	-- 	elseif(action:instanceName() == nil) then

	-- 		error("PSForSetter reset error:"  .. action.__cname.. " " .. debug.traceback())
	-- 		-- error("addReleaseLayer action don't have instanceName:" .. action.__cname)
	-- 	end
	-- end
	function removeAll()
		Logger.debug("== BattleActionRender clear")
		stop()
		actionLinkList:clear(true)
		-- for i,action in ipairs(actionMap) do
		-- 	removeAction(removeAction)
		-- end
		-- actionMap = {}
		autoReleaseLinkList:clearAndRelease()
		-- for k,v in pairs(autoReleaseTarget) do
		-- 	removeAutoReleaseAction(v)
		-- end
		-- autoReleaseTarget = {}
		-- releaseLaterMap = {}
	end -- function end
