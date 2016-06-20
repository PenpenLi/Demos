-- 基于四叉树的点击管理(目前只支持单个目标)
module("BattleTouchMananger",package.seeall)

local touchRoot = nil
local quadTree = nil
local listeners = nil
local selectedTargets = nil


function updateTargets( list )
	for k,target in pairs(list or {}) do
		-- if(target and target.getAABBBox) then
		if(target) then

			local quadData,index = find(target)
			if(quadData) then
				removeTouchLister(target)
				local newQuadData 		= getTargetTargetQuadTreeData(target)

				-- print("befor update target:")
				-- quadData.box:debug()
				-- print("after update target:")
				-- newQuadData.box:debug()
				-- print("=====================")

				
				newQuadData.call  		= quadData.call
				newQuadData.autoUpdate = quadData.autoUpdate
				newQuadData.priority   = quadData.priority
				quadTree:insert(newQuadData)
				table.insert(listeners,newQuadData)
			end
			
		else
			error("BattleTouchMananger.updateTargets target not contain getAABBBox function")
		end
	end
end
debugDraw = nil
function onTouchEvent( eventType, x,y )
	-- print("-------- touch 0")
	if(listeners and #listeners > 0) then
		-- print("-------- touch 1")
		 	 if(eventType == "began") then
		 	 	 -- 获取点击到的物体
				 local touchTargets = quadTree:getInterectObects(x,y)
				 local topTarget = nil
				 local zMax 	 = nil
				 local oderMax   = nil
				 local maxpriority = nil
				 for k,quadData in pairs(touchTargets or {}) do
				 	local z = quadData.target:getZOrder()
				 	local oder = quadData.target:getOrderOfArrival()
				 	-- 如果目标为空, 或者z值更大
			 		if(topTarget == nil or quadData.priority >= maxpriority) then
				 			topTarget = quadData
				 			maxpriority = quadData.priority
			 			
			 		end

				 end

				 if(topTarget) then
				 	-- print("-------- touch2")
				 	table.insert(selectedTargets,topTarget)
				 	return topTarget.call(eventType, x,y)
				 end

			  elseif(eventType == "moved") then
			  	-- print("-------- touch 3")
			  	 local removeTouchs = {}
			  	 for index,targetData in pairs(selectedTargets or {}) do
			  	 	local re = targetData.call(eventType, x,y)
			  	 end


			  else
			  	 for k,targetData in pairs(selectedTargets or {}) do
			  	 	targetData.call(eventType, x,y)
			  	 	if(targetData.autoUpdate == true) then
			  	 		addTouchListener(targetData.target,targetData.call,targetData.autoUpdate)
			  	 	end
			  	 end
			  	 selectedTargets = {}
			  end

	end
end

function ini( root )
	local onTouch = function ( ... )
		-- print("-------- onTouch")
	end
	touchRoot = root
	touchRoot:setTouchEnabled(true)
	-- touchRoot:registerScriptTouchHandler(onTouch,false,g_tbTouchPriority.battleLayer,true)
	touchRoot:setTouchMode(kCCTouchesOneByOne)
	touchRoot:setTouchPriority(g_tbTouchPriority.battleLayer - 1)

	quadTree = require(BATTLE_CLASS_NAME.QuadTreeNode).new()
	quadTree:create(0,0,g_winSize.width,g_winSize.height,5)
	setTouchLevel()

	listeners = {}
	selectedTargets = {}
	-- print("------- BattleTouchMananger ini complete")
end

function enableTouch( ... )
	if(touchRoot) then
		touchRoot:setTouchEnabled(true)
		touchRoot:registerScriptTouchHandler(onTouchEvent,false,g_tbTouchPriority.battleLayer,true)
		touchRoot:setTouchMode(kCCTouchesOneByOne)
		touchRoot:setTouchPriority(g_tbTouchPriority.battleLayer - 1)
	end
end
function disableTouch( ... )
	if(touchRoot) then
		touchRoot:setTouchEnabled(false)
		touchRoot:unregisterScriptHandler()
	end
end
function getTargetTargetQuadTreeData( node )
	if(node) then
		local box

		if(node.getAABBBox) then
			box = node:getAABBBox()
		else
			box = ObjectTool.getTargetAABBBox(node)
		end
		 
		-- box:debug()
		local quadData = {}
		quadData.box 		= box
		quadData.target 	= node
		
		return quadData
	end
end
function setTouchLevel( ... )
	local run = CCDirector:sharedDirector():getRunningScene()
	if (run:getChildByTag(99999990)) then
		return
	end
	
	local dispSize = CCDirector:sharedDirector():getVisibleSize()
	local tbPoss = {}
	tbPoss[1] = CCRectMake(dispSize.width/2-50, dispSize.height-100, 100, 100)
	tbPoss[2] = CCRectMake(dispSize.width/2-50, 0, 100, 100)
	tbPoss[3] = CCRectMake(0, dispSize.height/2-200, 100, 400)
	tbPoss[4] = CCRectMake(dispSize.width-100, dispSize.height/2-200, 100, 400)
	tbPoss[5] = CCRectMake(dispSize.width/2-200, dispSize.height/2-200, 400, 400)

	local tbTouch = {}

	local topNode = CCLayer:create()
	topNode:setTouchEnabled(true)
	topNode:registerScriptTouchHandler(function ( eventType, x, y )
		if (eventType == "began") then
			tbTouch[#tbTouch+1] = ccp(x,y)
			if (#tbTouch >= 5) then
				for k, v in ipairs(tbPoss) do
					if (not v:containsPoint(tbTouch[k])) then
						break
					end
					if (k == 5) then
						local node = CCLabelTTF:create()
						node:setString("OnePiece for world ")
						node:setFontSize(64)
						node:setColor(ccc3(0xff, 0x00, 0x00))
						node:setPosition(ccp(dispSize.width/2, dispSize.height/2))
						run:addChild(node, 999999901, 999999901)
					end
				end
			end
		end
	end,
	false, g_tbTouchPriority.touchEffect-10)
	run:addChild(topNode, 10009990, 10009990)
end

-- 为指定节点添加事件(未测试UIWidget)
	-- node:点击注册对象
	-- fun:事件回调
	-- priority:回调权值
	-- autoUpdate:是否在点击前自动刷新目标包围盒(不要多用,耗性能),用于动态物体
	-- [todo] needBubble: 点击事件是否需要冒泡.当为true时只要目标在点击区域就会被触发点击(一般情况只会触发最上面的)
function addTouchListener(node,fun,priority,autoUpdate)
	if(node and fun) then
		local quadData 		= getTargetTargetQuadTreeData(node)
		quadData.call  		= fun
		quadData.autoUpdate = autoUpdate
		quadData.priority   = priority or 0
		if(hasTarget(node)) then
			removeTouchLister(node)
		end
		quadTree:insert(quadData)
		table.insert(listeners,quadData)
	-- if(node and node.getAABBBox) then
	-- 	local box = node:getAABBBox()
	-- 	-- box:debug()
	-- 	local quadData
	-- 	-- 如果没有我们需要创建数据
	-- 	if(not hasTarget(node)) then
	-- 		quadData = {}
	-- 		quadData.box 		= box
	-- 		quadData.target 	= node
	-- 		quadData.call 		= fun
	-- 		quadData.priority 	= priority
	-- 		quadData.autoUpdate = autoUpdate
	-- 	-- 如果已经添加我们就删除再添加一次
	-- 	else

	-- 		quadData = find(node)
	-- 		removeTouchLister(node)
	-- 		if(quadData) then
	-- 			quadData.box 	= box
	-- 			quadData.target = node
	-- 			quadData.call 	= fun
	-- 			quadData.autoUpdate = autoUpdate
	-- 		end
			
	-- 	end
	-- 	quadTree:insert(quadData)
	-- 	table.insert(listeners,quadData)

	else
		error("addTouchListener target is nil or callback function is nil")
	end
	-- local box = ObjectTool.getBoundingBox(node)
	
	
end

function removeTouchLister( node )
	local quadData,index = find(node)
	if(quadData) then
			-- print("remove success")
			quadTree:remove(quadData)
			table.remove(listeners,index)
	end
end

 
function find( target )
	for index,quadData in pairs(listeners or {}) do
		if(quadData.target == target) then
			return quadData,index
		end
	end
	return nil
end

function hasTarget( target )
	for k,quadData in pairs(listeners or {}) do
		if(quadData.target == target) then
			return true
		end
	end
	return false
end



