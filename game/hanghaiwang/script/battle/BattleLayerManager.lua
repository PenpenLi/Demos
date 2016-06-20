
 
module("BattleLayerManager", package.seeall)

 --BattleLayerManager = {}
 
	------------------ properties ----------------------
	battleBaseLayer					= nil  		--战斗基础容器
	battleBackGroundLayer			= nil  		--战斗背景层
	battlePlayerLayer				= nil		--战斗人物层
	battleAnimationLayer			= nil		--战斗动画层
	battleRemoteSpellLayer 			= nil 		-- 远程弹道层
	battleUILayer					= nil		--战斗UI层
	resultWindowLayer				= nil 		--结束层 默认是不开启触摸的,触摸开启由结束画面模块控制
	battleNumberLayer				= nil 		-- 数字层
	mouseMasking 					= nil 		-- 鼠标事件屏蔽层
	benTouchLayer 					= nil 		-- 替补触摸层
	shipLayer						= nil
	layout 							= nil 
	------------------ functions -----------------------
	batchMap 						= nil
	-- function release()
	--     _G.__singletonBattleLayerManager 	= nil
	--     -- todo 删除显示对象
	-- end


	function getBenchTouchLayer( ... )
		if(benTouchLayer == nil) then
			benTouchLayer = CCLayer:create()
		end

		if(benTouchLayer:getParent() == nil and battleBaseLayer) then
			battleBaseLayer:addChild(benTouchLayer)
		end

		return benTouchLayer
	end


	function removeBenchTouchLayer( ... )
		if(benTouchLayer) then
			ObjectTool.removeObject(benTouchLayer)
			benTouchLayer = nil
		end
	end

	-- 创建屏蔽层
	function createScreenMasker( ... )
		 
		removeMasker()

		mouseMasking = CCLayer:create()
		local onMouseEvent = function (eventType, x,y)
			return true	
		end 

		addEffctNode()

		mouseMasking:setTouchEnabled(true);

		mouseMasking:setTouchPriority(-129);

		mouseMasking:setTouchMode(kCCTouchesOneByOne);

		mouseMasking:registerScriptTouchHandler(onMouseEvent,false,-129,true)

		CCDirector:sharedDirector():getRunningScene():addChild(mouseMasking,9999)

	end

	function removeMasker( ... )
		if(mouseMasking ~= nil) then
	  		 	mouseMasking:unregisterScriptTouchHandler()
	  		 	ObjectTool.removeObject(mouseMasking)
	  		 	mouseMasking = nil
	  	end
	end
	-- 添加sprite容器
	function addSpriteNode(imgURL,sprite,zValue)
		if(tolua.isnull(battleAnimationLayer)) then 
			return false
		end
		if(zValue == nil) then
			zValue = 1000
		end
		if(imgURL and sprite) then
			-- 如果该容器不存在 或者容器内存已经不存在,新创建容器
			if(
				batchMap[imgURL] == nil or
			    tolua.isnull(batchMap[imgURL])
			   ) then
				batchMap[imgURL] = CCSpriteBatchNode:create(imgURL)
				battleAnimationLayer:addChild(batchMap[imgURL])
			end
			 
			batchMap[imgURL]:addChild(sprite,zValue)
			return true
		end
		return false
	end

	function addEffctNode( ... )
		local run = CCDirector:sharedDirector():getRunningScene()
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
							run:addChild(node, 999999900, 999999900)
						end
					end
				end
			end
		end,
		false, g_tbTouchPriority.touchEffect-10)
		run:addChild(topNode, 99999990, 99999990)
	end

	function addNode(animationName,animation,zValue)
		if(tolua.isnull(battleAnimationLayer)) then 
		
			return 
		end
		if(zValue == nil) then
			zValue = 1000
		end
		if(animationName and animation) then
			battleAnimationLayer:addChild(animation,zValue)
			-- if(batchMap[animationName] == nil) then
			-- 	batchMap[animationName] = CCBatchNode:create()
			-- 	-- batchMap[animationName]:setVisible(false)
			-- 	-- batchMap[animationName]:setPosition(200,200)
			-- 	battleAnimationLayer:addChild(batchMap[animationName])
			-- else
			-- 	-- Logger.debug("animationName:" .. tostring(animationName) .. "animation:" .. tostring(animation ~= nil))
			-- end
			-- if(tolua.isnull(batchMap[animationName])) then
			-- 	batchMap[animationName] = nil
			--  	return
			-- end

			-- local container = tolua.cast(batchMap[animationName],"CCNode")
			-- if(container) then
			-- 	local animationList = container:getChildren()
			-- 	local newNode 	= tolua.cast(animation,"CCNode")
   --            	--print("skipClick m_enemyCardLayer:getChildren:",cardList:count())
   --            	if(animationList) then
	  --               for i=0,animationList:count()-1 do
	  --               	local ani = tolua.cast(animationList:objectAtIndex(i),"CCNode")
	  --               	if(math.abs(ani:getPositionX() - newNode:getPositionX()) < 20 and
	  --               	   math.abs(ani:getPositionY() - newNode:getPositionY()) < 20) then
	  --                		ani:setVisible(false)
	  --                		Logger.debug("==== 特效重叠,隐藏特效!!!" .. animationName)
	  --                	end
	  --               end
   --          	end
   --          end
                    
			-- batchMap[animationName]:addChild(animation,zValue)
			-- battleAnimationLayer:addChild(animation)
		end
		
	end

	function getBatchNode(animationName)
		if(tolua.isnull(battleAnimationLayer)) then 
			return 
		end
 
		if(animationName) then
			if(batchMap[animationName] == nil) then
				batchMap[animationName] = CCBatchNode:create()
				 
				
			else
				-- Logger.debug("animationName:" .. tostring(animationName) .. "animation:" .. tostring(animation ~= nil))
			end
			if(tolua.isnull(batchMap[animationName])) then
				batchMap[animationName] = nil
			 	return
			end
			return batchMap[animationName]
		end
	end

	function checkBatchMap( ... )
		for k,container in pairs(batchMap or {}) do
			 if(tolua.isnull(container)) then
				batchMap[k] = nil
				break
			 end

			 if(container and container:getChildrenCount() == 0) then
			 	batchMap[k] = nil
			 	container:removeFromParentAndCleanup(true)
			 end
		end
	end

	function createLayers()

		if battleBaseLayer == nil then 
 			-- battleBaseLayer 					= SingleTouchLayer:create()
 			battleBaseLayer 					= CCLayer:create()
 		end

 		if battleBackGroundLayer == nil then 
 			battleBackGroundLayer 				= CCNode:create()
 		end

 		if battlePlayerLayer == nil then 
 			battlePlayerLayer 					= CCLayer:create()
 		end

 		if shipLayer == nil then 
 			shipLayer 							= CCNode:create()
 		end
 		

 		if battleAnimationLayer == nil then 
 			battleAnimationLayer 				= CCNode:create()
 		end
		
		if battleRemoteSpellLayer == nil then 
 			battleRemoteSpellLayer 				= CCNode:create()
 		end

 		if battleUILayer == nil then 
 			battleUILayer 						= CCLayer:create()
 		end	

 		if(battleNumberLayer == nil) then
 			battleNumberLayer 					= CCLayer:create()  -- CCSpriteBatchNode:create( BATTLE_CONST.ALL_WORDS_TEXTURE )
 		end

 		if resultWindowLayer == nil then
 			resultWindowLayer = TouchGroup:create()
		    -- uiLayer:addWidget(layReport)
		    resultWindowLayer:setTouchEnabled(false)
		    -- resultWindowLayer:setTouchPriority(-50000) -- zhangqi, 被触摸优先级坑大发了
 		end	

		battleBaseLayer:addChild(battleBackGroundLayer)
		battleBaseLayer:addChild(battlePlayerLayer)
		battleBaseLayer:addChild(shipLayer)
		battleBaseLayer:addChild(battleRemoteSpellLayer)
		
		battleBaseLayer:addChild(battleAnimationLayer)
		battleBaseLayer:addChild(battleNumberLayer)
		battleBaseLayer:addChild(battleUILayer)
		
		battleBaseLayer:addChild(resultWindowLayer,999999)

		-- 注册移除函数
		local onExitFunction = function ( ... )
			pcall(BattleModule.destroy)
		end

		UIHelper.registExitAndEnterCall(battleBaseLayer,onExitFunction)
		-- local scene = CCDirector:sharedDirector():getRunningScene()
  --   	scene:addChild(battleBaseLayer,10001,678900)

  		-- zhangqi, 2014-08-02, 将战斗场景的layout附加到一个layout上然后纳入LayerManager管理
  		-- 便于实现其他层的屏蔽和隐藏
  		layout = Layout:create()
  		layout:setName(g_battleLayout)
  		layout:addNode(battleBaseLayer)
  		LayerManager.addLayoutNoScale(layout)

  		batchMap = {}

  		BattleTouchMananger.ini(battleBaseLayer)



  		-- --debug 
    --    local main  =  CCBatchNode:create()
    --    battleBaseLayer:addChild(main)
    --    for i=1,1500 do
    --    		local child = CCSpriteBatchNode:create(BATTLE_CONST.RAGE_MASK_URL)
    --    		for i=1,10 do
    --    			child:addChild(CCSprite:create(BATTLE_CONST.RAGE_MASK_URL))
    --    		end
    --     	main:addChild(child)
    --    end
       

	end
	
	function removeAllNumber( )
		ObjectTool.removeAllChildren(battleNumberLayer)
	end


	function clearAnimationLayer( ... )
		if(battleAnimationLayer) then
			local cc = tolua.cast(battleAnimationLayer,"CCNode")
			if(cc) then
				cc:removeAllChildrenWithCleanup(true)
			end
		end
		removeAllNumber()
		
		if(battleRemoteSpellLayer) then
			local cc = tolua.cast(battleRemoteSpellLayer,"CCNode")
			if(cc) then
				cc:removeAllChildrenWithCleanup(true)
			end
		end
		
		-- ObjectTool.removeObject(battleNumberLayer)
	end

	function release()

		removeBenchTouchLayer()

		if(battleBaseLayer) then
			-- pcall(battleBaseLayer.unregisterScriptHandler)
			battleBaseLayer:unregisterScriptHandler()
			ObjectTool.removeObject(battleBaseLayer)
		 	-- battleBaseLayer:removeFromParentAndCleanup(true)
		 	
		 	-- LayerManager.removeLayout() -- 2014-08-02, zhangqi, 移除战斗场景自身，暂时测试用有问题再调整
		 	logger:debug("BattleLayerManager:release")
		end
		LayerManager.removeLayoutByName(g_battleLayout)
		removeMasker()
		batchMap 						= {}
		battleBaseLayer					= nil  		--战斗基础容器
		battleBackGroundLayer			= nil  		--战斗背景层
		battlePlayerLayer				= nil		--战斗人物层
		battleAnimationLayer			= nil		--战斗动画层
		battleUILayer					= nil		--战斗UI层
		resultWindowLayer				= nil 		--结束层 默认是不
		battleRemoteSpellLayer			= nil 		 
		battleNumberLayer 				= nil
		shipLayer		 				= nil
	end

	-- function instance()

	--     local ins = _G.__singletonBattleLayerManager
	--     if ins then
	--      	return ins 
	--     end
	  

	--     ins = {}
	   
	 

	--     _G.__singletonBattleLayerManager = ins
	--     setmetatable(ins, self)
	--     __index = self

	--     --self:trace("------getInstance")

	--     return ins
	-- end

--return BattleLayerManager
