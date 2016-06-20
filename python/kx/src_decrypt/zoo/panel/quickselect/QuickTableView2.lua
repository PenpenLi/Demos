QuickTableView = class(Layer)
local ADD_SPEED = 6000
QuickTableViewEventType = {
	kTapTableView = "tapTableView",
}

QuickSelectAnimation = {
	{id = 3, frameNum = 10},
	{id = 8, frameNum = 10},
	{id = 13, frameNum = 10},
	{id = 17, frameNum = 10},
	{id = 19, frameNum = 10},
	{id = 23, frameNum = 10},
	{id = 30, frameNum = 10},
	{id = 43, frameNum = 14},
	{id = 46, frameNum = 20},
	{id = 50, frameNum = 16},
}
function QuickTableView:create( width, height, renderClass)
	-- body
	local s = QuickTableView.new()
	s:init(width, height, renderClass)
	return s
end

function QuickTableView:ctor( )
	-- body
	Layer.initLayer(self)
	self.name = "QuickTableView"
	self.displayList = {}

	self.lastY = 0
	self.lastX = 0

	self.moveStartX = 0
	self.moveStarty = 0

	self.renderWidth = 0
	self.renderHeight = 0

	self.isTouching = false

	self.isAutoMoving = false --自由滑动
	self.isAutoMovingBegin = false --自由滑动状态的touchbegin

	self.minY  = 0
	self.maxY  = 0

	self.animationPos = nil --动画的位置

	self.offsetY = 0
end

function QuickTableView:init( width, height, renderClass )
	-- body
	
	self.width = width
	self.height = height
	self.renderClass = renderClass
	self:changeWidthAndHeight(width, height)

	-- local touchLayer = LayerColor:create()
	local touchLayer = LayerColor:createWithColor(ccc3(255, 0, 0),self.width,self.height)
	touchLayer:changeWidthAndHeight(width, height)
	touchLayer:setOpacity(0)	
	touchLayer:setTouchEnabled(true, 0, true)
	self:addChild(touchLayer)

	-- local view_content = SpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/quick_select_level.png"), 200)
	local view_content = LayerColor:createWithColor(ccc3(0, 255, 0))
	view_content:setOpacity(0)	
	view_content:changeWidthAndHeight(200, 200)
	self.view_content = view_content
	self:addChild(view_content)

	local function onTouchEvent( evt )
		-- print("----->touch <-----",evt.name)
		-- body
		if evt.name == DisplayEvents.kTouchBegin then
			self:onTouchBegin(evt)
		elseif evt.name == DisplayEvents.kTouchMove then
			self:onTouchMove(evt)
		elseif evt.name == DisplayEvents.kTouchEnd then
			self:onTouchEnd(evt)
		elseif evt.name == DisplayEvents.kTouchTap then
			self:onTouchTap(evt)
		end
	end
	
	touchLayer:ad(DisplayEvents.kTouchBegin, onTouchEvent)
	touchLayer:ad(DisplayEvents.kTouchMove, onTouchEvent)
	touchLayer:ad(DisplayEvents.kTouchEnd, onTouchEvent)
	touchLayer:ad(DisplayEvents.kTouchTap, onTouchEvent)


	local function __getPosition( ... )
		-- body
		return ccp(self.lastX, self.lastY)
	end
	self.speedometers = {}
	self.speedometers[1] = VelocityMeasurer:create(1/60, __getPosition)
	self.speedometers[2] = VelocityMeasurer:create(2/60, __getPosition)
	self.speedometers[3] = VelocityMeasurer:create(4/60, __getPosition)
end

function QuickTableView:updateData( dataList )
	-- body
	if dataList ~= self.dataList then
		self.dataList = dataList
		for k, v in pairs(dataList) do 
			self:updateViewByIndex(k, v)
		end
	end
end

function QuickTableView:updateViewByIndex( index, data )
	-- body
	if not self.displayList[index] then
		local wSize = Director:sharedDirector():getWinSize()
		local height = 106	-- TablevelArea.height / 5 = 106
		local width = 585
		self.renderHeight = height
		self.renderWidth = width
		local render = self.renderClass:create(width, height, data)
		self.displayList[index] = render
		self.view_content:addChild(render)
		local y = (index - 1) * height
		if self.maxY < -y then self.maxY = -y end
		if self.minY > -y then self.minY = -y end

		local x = wSize.width/2
		render:setPositionXY(self.width/2,y)
	end
end

function QuickTableView:onTouchBegin( evt )
	-- body

	self.touchBeginTime = os.clock()
	if self.animation then
		self.animation:removeFromParentAndCleanup(true)
		self.animation = nil
	end

	local pos = evt.globalPosition
	self.view_content:stopAllActions()
	-- print("x = ".. pos.x.." , ".."y = "..pos.y.."")
	self.moveStartX = pos.x 
	self.moveStartY = pos.y

	self.lastX = pos.x
	self.lastY = pos.y

	self.isTouching = true

	for k, v in pairs(self.speedometers) do 
		v:setInitialPos(self.lastX, self.lastY)
		v:startMeasure()
	end

	if self.isAutoMoving then 
		self.isAutoMovingBegin = true
	else
		self.isAutoMovingBegin = false
	end

	local function _updateScale( )
		-- body
		self:updateScale()
	end
	self:unscheduleUpdate()
	-- self:scheduleUpdateWithPriority(_updateScale, 0) -- 不再需要改变scale
end

function QuickTableView:onTouchMove( evt )
	-- body
	self.isTouching = true
	local pos = evt.globalPosition
	-- print("x = ".. pos.x.." , ".."y = "..pos.y.."")

	local pos_view = self.view_content:getPosition()
	local detY = pos.y - self.lastY
	self:MoveTo(ccp(pos_view.x, pos_view.y + detY))

	self.lastX = pos.x
	self.lastY = pos.y
end

function QuickTableView:onTouchEnd( evt )
	-- body
	local pos = evt.globalPosition
	self.touchEndTime = os.clock()
	-- print("x = ".. pos.x.." , ".."y = "..pos.y.."")
	self.isTouching = false
	local pos_view = self.view_content:getPosition()
	local detY = pos.y - self.lastY
	if detY > 0 then 
		self.isUP = true
	elseif detY < 0 then 
		self.isUP = false
	end

	self.speed = 0
	for k, v in pairs(self.speedometers) do 
		v:stopMeasure()
		local speedY = v:getMeasuredVelocityY()
		if speedY and speedY~= 0 then
			-- print(speedY)
			if math.abs(speedY) > self.speed then 
				self.speed = speedY
			end
		end
	end

	self:MoveTo(ccp(pos_view.x, pos_view.y + detY))

	self.lastX = 0
	self.lastY = 0
end

function QuickTableView:getIndexByGlobalPos( globalPosition )
	-- body
	local pos_view = self.view_content:getPosition()
	local node_pos = self.view_content:convertToNodeSpace(globalPosition)
	-- 原先代码
	-- local p = ccp(globalPosition.x + pos_view.x, globalPosition.y - pos_view.y - self.renderHeight/2)
	-- local index = math.floor(p.y / self.renderHeight) + 1
	-- print("tap index = "..index)

	local p = ccp(node_pos.x , node_pos.y)
	local index = math.floor(p.y / self.renderHeight) + 1

	-- 调到这里快哭了，终于对了。。。
	-- print("pos_view",pos_view.x,pos_view.y,"node_pos",node_pos.x,node_pos.y," >>>>> raw index ",index)
	if index > #self.displayList or index < 0 then
	else
		local render
		--检查下限
		if index > 0 then
			render = self.displayList[index]
			local _height = render:getGroupBounds().size.height / 2 
			if p.y - (index - 1) * self.renderHeight <= _height then
				local _width = render:getGroupBounds().size.width
				local x_o = render:getPositionX()
				if p.x >= x_o - _width / 2 and p.x <= x_o + _width / 2 then
					return index
				end
			end
		end

		--检查上限
		if index + 1 <= #self.displayList then
			render = self.displayList[index + 1]
			local _height = render:getGroupBounds().size.height / 2
			if index * self.renderHeight - p.y <= _height  then
			 	local _width = render:getGroupBounds().size.width
				local x_o = render:getPositionX()
				if p.x >= x_o - _width / 2 and p.x <= x_o + _width / 2 then
					return index + 1
				end
			end
		end

	end
	return nil
end

function QuickTableView:onTouchTap( evt )
	-- body
	local del_time = self.touchEndTime - self.touchBeginTime
	if del_time >= 0.8 or self.isAutoMovingBegin then
		return 
	end

	local pos = evt.globalPosition
	local index = self:getIndexByGlobalPos(pos)
	-- print("QuickTableView:onTouchTap x = ".. pos.x.." , ".."y = "..pos.y.."","index",index)

	local data = {index = index}
	local evt = Event.new(QuickTableViewEventType.kTapTableView, data, self)
	self:dispatchEvent(evt)
end

function QuickTableView:fixPos( pos )
	-- print("======= before fixPos ",pos.x,pos.y)
	-- body
	local tempY = pos.y
	local det_s = 0
	if not self.isTouching then
		--速度导致的位移校正
		local t = self.speed / ADD_SPEED
		-- print("time = "..t.." self.speed = "..self.speed.." ")
		det_s = (self.speed * self.speed)/(2*ADD_SPEED)
		if self.speed ~= 0 then
			det_s = det_s*(self.speed/math.abs(self.speed))
		end
		--定位校正
		local index = (self.height /2 - pos.y - det_s) / self.renderHeight
		if index + 0.5 > math.ceil(index) then
			index = math.ceil(index)
		else
			index = math.floor(index)
		end
		tempY = self.height /2  - index * self.renderHeight
		det_s = tempY - pos.y
	end
	--边界校正
	--  上边界
	-- local offset_det_min = self.isTouching and 0 or self.height/2
	local offset_det_min = self.isTouching and (self.height/2 -self.renderHeight/2 + 5 )  or (self.height -self.renderHeight/2 + 5)
	-- 下边界
	-- local offset_det_max = self.isTouching and self.height or self.height/2
	local offset_det_max = self.isTouching and self.height/2 or self.bottomY-5
	
	if tempY < self.minY + offset_det_min then
		det_s = self.minY + offset_det_min - pos.y
	elseif tempY > self.maxY + offset_det_max then 
		det_s = self.maxY + offset_det_max - pos.y
	end

	-- if tempY < self.minY + self.height/2 then
	-- 	det_s = self.minY + self.height/2 - pos.y
	-- elseif tempY > self.maxY + self.height/2 then 
	-- 	det_s = self.maxY + self.height/2 - pos.y
	-- end

	--根据最终算出的位移 和加速度 求最终的速度s = at*t／２
	local t = math.sqrt( 2 * math.abs(det_s) /ADD_SPEED )
	self.speed = t * ADD_SPEED
	if det_s < 0 then self.speed = -self.speed end

	pos.y = pos.y + det_s
	-- print("======= after fixPos========= ",pos.x,pos.y)
	return pos
end

function QuickTableView:MoveTo( pos )
	-- body
	pos = self:fixPos(pos)
	local function _moveCallback( ... )
		-- body
		self:unscheduleUpdate()
		self:updateScale(true)
		self:playAnimation()
		self.isAutoMoving = false
	end

	if self.isTouching  then 
		self.view_content:setPosition(pos)
	else
		self.isAutoMoving = true
		local action_move = CCMoveTo:create(math.abs(self.speed/ADD_SPEED), pos)
		local action_ease_out = CCEaseOut:create(action_move, 3)
		local action_callback = CCCallFunc:create(_moveCallback)
		self.view_content:runAction(CCSequence:createWithTwoActions(action_ease_out, action_callback))
		-- self.view_content:runAction(action_callback)

	end
end

function QuickTableView:initArea( index )
	-- body
	if index > 0 and index <= #self.displayList then
		local posY = self.height /2  - (index - 1) * self.renderHeight
		
		self.bottomY = self.renderHeight/2 
		self.topY = -(#self.displayList - 5) * self.renderHeight + (self.renderHeight/2 )
		-- 下面不能留空
		if ( posY >  self.bottomY) then 
			posY = self.bottomY
		-- 上面不能留空
		elseif ( posY <  self.topY) then 
			posY = self.topY
		end

		self.view_content:setPositionY(posY) 
		print("initArea view_content y:",posY,"index",index,#self.displayList)

		self.displayList[index]:changeScale(1)
		self:playAnimation()
	end
end


--不是准确的 有误差 在+2>x>-2
function QuickTableView:getCurrentIndex( pos )
	-- body
	pos = pos or self.view_content:getPosition()
	local index = math.floor((self.height/2 - pos.y) / self.renderHeight)
	return index
end

function QuickTableView:updateScale( isAll )
	-- -- body
	-- local index = self:getCurrentIndex()
	-- local pos = self.view_content:getPosition()
	-- local y_center = self.height/2 - pos.y
	-- local min = index - 3
	-- local max = index + 3
	-- if isAll then
	-- 	min = 1
	-- 	max = #self.displayList
	-- end

	-- for k = min, max do     --波及范围，特别快速的情况下检测不准，随意范围大点
	-- 	if k > 0 and k <= #self.displayList then
	-- 		local cell = self.displayList[k]
	-- 		if cell then
	-- 			local cell_pos = cell:getPosition()
	-- 			local scaleValue = math.abs(cell_pos.y - y_center)/self.renderHeight
	-- 			if  scaleValue <= 1 then
	-- 				cell:changeScale(1 - 0.2 * scaleValue)
	-- 			else
	-- 				cell:changeScale(0.8)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

local function createAnimationSelect( animateConfig )
	-- body
	local sprite = Sprite:createWithSpriteFrameName("area_animation_"..animateConfig.id.."_0000")
	local frames = SpriteUtil:buildFrames("area_animation_"..animateConfig.id.."_%04d", 0, animateConfig.frameNum)
	local animate = SpriteUtil:buildAnimate(frames, 1/24)
	sprite:play(animate)
	return sprite

end
function QuickTableView:playAnimation( ... )
	-- body
	local index = self:getCurrentIndex()
	local cell_center
	local index_center
	for k = index - 2, index + index + 2 do 
		if k > 0 and k <= #self.displayList then
			local cell = self.displayList[k]
			if cell:getScale() > 0.95 then 
				cell_center = cell 
				index_center = k
			end
		end
	end

	if self.animation then
		self.animation:removeFromParentAndCleanup(true)
		self.animation = nil
	end

	if not index_center or (not cell_center) then return end

	local animateConfig = nil
	for k, v in pairs(QuickSelectAnimation) do 
		if v.id == index_center then animateConfig = v end
	end

	if animateConfig then 
		local ani = createAnimationSelect(animateConfig)
		if not self.animationPos then
			self.animationPos = ccp(self.width/2, self.height/2)
		end
		local pos_1 = self.view_content:getPosition()
		local pos_2 = cell_center:getPosition()
		local x = pos_2.x - cell_center:getContentSize().width/2
		local y = pos_2.y - cell_center:getContentSize().height/2
		local pos_3 = cell_center.icon:getPosition()
		local pos = ccp(pos_1.x + x + pos_3.x, pos_1.y + y + pos_3.y)
		ani:setScale(0.5)
		ani:setPosition(pos)
		self:addChild(ani)
		self.animation = ani
		cell_center:hideIcon()
	end
end

function QuickTableView:dispose( ... )
	-- body
	for k, v in pairs(self.speedometers) do 
		v:stopMeasure()
	end
	Layer.dispose(self)
end


