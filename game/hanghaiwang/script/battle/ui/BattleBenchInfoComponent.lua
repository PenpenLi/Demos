
--状态(0:隐藏状态 1:打开状态)
local STATE_HIDE 	  = 0
local STATE_SHOW_MENU = 1

-- 替补信息组件
-- ui包含:1个按钮 2.menu
-- 功能: 1.设置剩余数字 2.根据数据设置人物属性数据显示对应的人物头像和是否置灰
-- todo 替补死亡后 下一次是否会传过来呢?
require (BATTLE_CLASS_NAME.class)
local BattleBenchInfoComponent = class("BattleBenchInfoComponent",function () return CCNode:create() end)
 	------------------ properties ----------------------
 	BattleBenchInfoComponent.leftNum			= nil
 	BattleBenchInfoComponent.leftNumLabel		= nil
 	BattleBenchInfoComponent.button				= nil
 	BattleBenchInfoComponent.menuBG				= nil
 	BattleBenchInfoComponent.itemUIList			= nil
 	BattleBenchInfoComponent.state 				= nil -- 状态(0:隐藏状态 1:打开状态)
 	BattleBenchInfoComponent.itemDataList 		= nil -- 替补数据
 	BattleBenchInfoComponent.clickEffect 		= nil
 	------------------ functions -----------------------
 	function BattleBenchInfoComponent:ctor( ... )
 		
 		self.itemUIList 	= {}
 		-- self.itemDataList 	= {}
 		self.state 	  		= STATE_HIDE
 		self:createUI()

 	end

 	function BattleBenchInfoComponent:hitTest( location )
 		local localPosition
 		for k,icon in pairs(self.itemUIList) do
 			local position = icon:convertToNodeSpace(location)
 			local hitTest = icon:hitTest(position)
 			if(hitTest == true) then
 				return true,icon.id
 			end
 		end
 		return false
 	end

 	function BattleBenchInfoComponent:getNextState( ... )
 		if(self.state == STATE_HIDE ) then
 			return STATE_SHOW_MENU
 		end
 		return STATE_HIDE
 	end

 	function BattleBenchInfoComponent:setListData( value )
 		self.itemDataList = value
 		-- self:showMenuList(self.itemDataList)
 	end


 	function BattleBenchInfoComponent:setState( state )
 		if(self.state ~= state) then
 			self.state = state
 			-- 如果是隐藏状态
 			if(self.state == STATE_HIDE ) then
 				-- self.button:setFocused(false)
 				-- self:removeMenuList()
 				self:showRemoveEffect()
 			-- 如果是显示状态
 			elseif(self.state == STATE_SHOW_MENU)then
 				-- self.button:setFocused(true)
 				self:showMenuList(self.itemDataList)
 			else
 				error("BattleBenchInfoComponent -> error state type:" .. tostring(self.state))
 			end
 		end
 	end

 	function BattleBenchInfoComponent:createUI( ... )
 		
 		self:removeButton()

 		if(self.menu == nil) then
			self.menu = CCMenu:create()
		    self.menu:setAnchorPoint(CCP_ZERO)
		    self.menu:setPosition(0,0)
		    self:addChild(self.menu,0,0)
	   		self.menu:setTouchPriority(g_tbTouchPriority.battleMenu)
		end


		-- 生成按钮
 		self.button = CCMenuItemImage:create(BATTLE_CONST.BENCH_BT_NORMAL,BATTLE_CONST.BENCH_BT_DOWN)

 		-- 当开始
 		local clickfun = function ( ... )
 			-- 2016.1.8 增加按钮点击声音
			AudioHelper.playCommonEffect() 
 			local globalPosition = self.button:convertToWorldSpace(ccp(self.button:getContentSize().width/2,self.button:getContentSize().height/2))
 			if(self.clickEffect) then self.clickEffect:release() end
 			
 			self.clickEffect 				= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
 			self.clickEffect.animationName  = BATTLE_CONST.BENCH_CLICK_EFFECT
 			self.clickEffect.postionX	   	= globalPosition.x
 			self.clickEffect.postionY 	   	= globalPosition.y
 			self.clickEffect.container 		= BattleLayerManager.battleUILayer
 			BattleActionRender.addAutoReleaseAction(self.clickEffect)

 			self:setState(self:getNextState())
 		end
 		
		self.button:registerScriptTapHandler(clickfun)
		self.button:setAnchorPoint(ccp(0,0.5))
		self.menu:addChild(self.button)
		-- 添加事件
		-- self.button:addTouchEventListener(clickfun)

		-- 生成label
		if(self.leftNumLabel) then
			ObjectTool.removeObject(self.leftNumLabel)
		end
		self.leftNumLabel = CCLabelTTF:create("0",g_sFontPangWa,24)
		self:addChild(self.leftNumLabel)
		self.leftNumLabel:setPosition(self.button:getContentSize().width * 0.7,self.button:getContentSize().height * 0.2)
	    self.leftNumLabel:setColor(ccc3(255,255,255))
	    self.leftNumLabel:enableStroke(ccc3(0,0,0),2)
 		self.leftNumLabel:enableShadow(CCSizeMake(2, -2), 255, 0)


 	
 	end
 	function BattleBenchInfoComponent:refreshDeadState( ... )
 		for k,icon in pairs(self.itemUIList or {}) do
 			icon:refreshDeadState()
 		end
 	end
 	-- 显示替补数据(3个人)
 	function BattleBenchInfoComponent:showMenuList( list )
 		self:removeMenuList()

 		-- 添加背景
 		self.menuBG = CCSprite:create(BATTLE_CONST.BENCH_BT_MENU)
 		self.menuBG:setCascadeOpacityEnabled(true)
        self.menuBG:setCascadeColorEnabled(true)

 		self:addChild(self.menuBG)
 		self.menuBG:setPosition(126 * g_fScaleX,0)
 		
 		local counter = 0
 		local space   = 10
 		-- icon起始位置
 		-- local itemX   = self.button:getContentSize().width * 1.5 + 1.5 * space
 		-- local itemX   =  7 * space 
 		local itemX   =  self.menuBG:getContentSize().width * 0.56  --  space/2 * g_fScaleX
 		-- local itemY   = self.menuBG:getContentSize().height - 2 * space
 		-- local itemY   = 277/2 + 5 self.menuBG:getContentSize().height/2 + space/2
 		local itemY   = self.menuBG:getContentSize().height   -  2 * space 

 		-- 添加listui
 		for k,targetData in pairs(list or {}) do

 			if(counter < 3) then
 				-- print("BattleBenchInfoComponent",counter)
 				-- 生成头像
	 			local icon = require(BATTLE_CLASS_NAME.BattleBenchInfoIcon).new()
	 			table.insert(self.itemUIList,icon)
	 			-- self:addChild(icon)
	 			self.menuBG:addChild(icon)
	 			icon:reset(targetData)
	 			-- icon:setAnchorPoint(ccp(0.5,1))
	 			local size = icon:getSize()
	 			-- 计算位置
	 			icon:setPosition(itemX,itemY - counter * (size.height * 0.8 + space))

	 			local onMouseEvent = function ( eventType, x,y ,data )
	 				-- print("BattleBenchInfoIcon onMouseEvent",eventType,icon.id)
	 				local targetID = tonumber(icon.id)
					local targetData = BattleMainData.fightRecord:getTargetData(targetID)
					-- 判断是否死亡
					if(targetData ~= nil and targetData:isDead() == true) then
						-- print("BattleBenchInfoIcon player dead")
						EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REQUEST_REVIVE,targetID)
					end
	 			end

	 			BattleTouchMananger.addTouchListener(icon,onMouseEvent,1000)
	 		else
	 			break
	 		end
	 		counter = counter + 1
 		end

 		local actions = ObjectTool.getBenchMenuFadeIn()
 		self.menuBG:runAction(actions)

 	end

 	function BattleBenchInfoComponent:showRemoveEffect( )
 		if(self.menuBG) then
 			local onRemoveEffectComplete = function ( ... )
 				self:removeMenuList()
 			end
 			self.menuBG:setPosition(126 * g_fScaleX,0)
 			-- self.menuBG:setPosition(self.button:getContentSize().width * 1.5 + 6,0)
 			local actions = ObjectTool.getBenchMenuFadeOut(onRemoveEffectComplete)
 			self.menuBG:runAction(actions) 
 		end
 	end

 	function BattleBenchInfoComponent:removeMenuList( ... )
 		

 		-- local actions = ObjectTool.getBenchMenuFadeIn()
 		-- container:runAction(actions)


 		for k,itemUI in pairs(self.itemUIList or {}) do
 			itemUI:dispose()
 			BattleTouchMananger.removeTouchLister(itemUI)
 			ObjectTool.removeObject(itemUI)
 		end

 		-- 删除背景
 		if(self.menuBG) then
 			self.menuBG:stopAllActions()
 			ObjectTool.removeObject(self.menuBG)
 			self.menuBG = nil	
 		end
 		self.itemUIList = {}

 	end



 	-- 设置剩余数量
 	function BattleBenchInfoComponent:setLeftNum( value )
 		if(self.leftNum ~= value) then
 			self.leftNum = value
 			self.leftNumLabel:setString(tostring(value))
 			self:refreshDeadState()
 		end
 	end
 
 	-- 删除按钮
 	function BattleBenchInfoComponent:removeButton( ... )
 		if(self.button) then
 			self.button:unregisterScriptTapHandler()
 		end
 		ObjectTool.removeObject(self.button)
 	end

 	function BattleBenchInfoComponent:dispose( ... )
 		self:removeButton()
 		self:removeMenuList()
 		ObjectTool.removeObject(self.leftNumLabel)
 		ObjectTool.removeObject(self.menu)
 		BattleTouchMananger.removeTouchLister(icon)
 	end
 return BattleBenchInfoComponent