TileDrip = class(CocosObject)

DripState = {
	
	kNormal = 1,
	kGrow = 2,
	kCasting = 3,
	kReadyToMove = 4,
	kMove = 5,
}

function TileDrip:create(itemView)

	local node = TileDrip.new(CCNode:create())
    node:init(itemView)
	
	return node
end

function TileDrip:init(itemView)

	self.itemView = itemView
	self.state = DripState.kNormal
    
    FrameLoader:loadArmature("skeleton/drip")

	self.anime = self:buildAnimation( "dirp_explode" )
	
	self:addChild(self.anime)
	
end

function TileDrip:createEff( animeStr )
	--[[
	local container = Layer:create()
	local eff = ArmatureNode:create("Drip/" .. animeStr)

	eff:playByIndex(0)
	eff:update(0.001) -- 此处的参数含义为时间

	container.body = eff
	container:addChild(eff)
	]]
	return self:buildAnimation(animeStr , true)
end

function TileDrip:buildAnimation( animeStr , createForEff)
	local container = Layer:create()
	local eff = ArmatureNode:create("Drip/" .. animeStr)

	eff:playByIndex(0)
	eff:update(0.001) -- 此处的参数含义为时间

	if not createForEff then
		eff:setScale(0.95)
		eff:setPosition( ccp( -29 , 30 ) )
		eff:stop()
	end

	container.body = eff
	container:addChild(eff)

	return container
end

function TileDrip:changeDripState(newState , newMovePos)
	--print("RRR   TileDrip:changeDripState  111  newState = " , newState)

	local function clearBody()
		if self.anime then
			self.anime.body:stop()
			self.anime:removeFromParentAndCleanup(false)
			self.anime = nil
		end
	end

	--self.itemView

	if self.state ~= newState then
		--print("RRR   TileDrip:changeDripState  222  newState = " , newState)
		if newState == DripState.kCasting then
			--print("RRR   TileDrip:changeDripState  333  newState = " , newState)
			if self.state == DripState.kGrow then
				--print("RRR   TileDrip:changeDripState  444  newState = " , newState)
				self.anime.body:playByIndex(0)
			end
		elseif newState == DripState.kMove then
			--clearBody()
			--self.body = self:buildAnimation( "dirp_move_to_right" )
			self.anime.body:playByIndex(0)

			local actArr2 = CCArray:create()
			actArr2:addObject( CCEaseSineIn:create( CCMoveTo:create( 10/24 , ccp(newMovePos.x , newMovePos.y)) )  )
			actArr2:addObject( CCCallFunc:create( function ()  
				clearBody()
			end ) )
			self:runAction( CCSequence:create(actArr2) )
		end
		self.state = newState
	end
end