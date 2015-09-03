require "zoo.config.TileMetaData"
require "zoo.config.TileConfig"

require "zoo.gamePlay.GamePlayConfig"

GameBoardData = class()

GameBoardFallType = table.const
{
	kNone = 0,
	kCannonAll = 5,				----初始为空
	kCannonAnimal = 39,			----纯动物掉落口
	kCannonIngredient = 40,		----豆荚掉落口
	kCannonBlock = 41,			----障碍掉落口
	kCannonCoin = 124,
	kCannonCrystallBall = 125,
	kCannonBalloon = 126,
	kCannonHoneyBottle = 127,
	kCannonGreyCuteBall = 128,
	kCannonBrownCuteBall = 129,
	kCnanonBlackCuteBall = 130,
}

TileRoadType = table.const{
	kLine = 1,
	kCorner = 2,
	kStartPoint = 3, 
	kEndPoint = 4,
}

TransmissionType = table.const{
	kNone = 0,
	kRoad = 1,-- 转角分顺、逆时针8个方向
	kCorner_UR = 2, -- up right
	kCorner_RD = 3, -- right down
	kCorner_DL = 4, -- down left
	kCorner_LU = 5, -- left up
	kCorner_LD = 6,
	kCorner_DR = 7,
	kCorner_RU = 8,
	kCorner_UL = 9,
	kStart = 10,
	kEnd = 11,
}

TransmissionDirection = table.const{
	kNone = 0,
	kRight = 1, 
	kDown = 2, 
	kLeft = 3,
	kUp = 4
}

TransmissionColor = table.const{
	kNone = 0,
	kRed = 1,
	kGreen = 2,
	kBlue = 3
}


function GameBoardData:ctor()
	self.isUsed = false; 	--是否可用
	self.isMoveTile = false; -- 是否是移动地块
	self.isProducer = false;	--是否可以掉落出东西（生产）
	self.iceLevel = 0;		--冰层厚度
	self.passType = 0;		--没有通道，1=上方有[出口]，2=下方有[入口]，3=上方有[出口]且下方有[入口]
	self.passExitPoint_x = 0;
	self.passExitPoint_y = 0;	--连接的通道出口位置
	self.passEnterPoint_x = 0;
	self.passEnterPoint_y = 0;	--连接的通道入口位置
	self.isCollector = false; --能否掉出豆荚--收集口
	self.ropetype = 0;		--没有绳子 1=上方 2=下方 4=左方 8=右方<待定>
	self.isBlock = false;	--是block类型<毒液、雪花、牢笼>
	self.tileBlockType = 0;   --特殊地格类型 0=普通地格 1 = 翻转地格
	self.isReverseSide = false    --所在地块是否被翻转
	self.reverseCount = nil
	self.sandLevel = 0 	-- 流沙等级

	self.snailRoadType = 0   --蜗牛轨迹
	self.isSnailProducer = false --蜗牛生成口
	self.isSnailCollect  = false --蜗牛收集口
	self.nextSnailRoad = nil
	self.isSnailRoadBright = false
	self.snailTargetCount = 0
	self.snailRoadViewRotation = nil
	self.snailRoadViewType = nil

	self.isRabbitProducer = false -- 兔子生成口

	self.transType = TransmissionType.kNone
	self.transColor =TransmissionColor.kNone
	self.transDirect  = TransmissionDirection.kNone
	self.transLink = nil


	self.x = 0;
	self.y = 0;
	self.w = GamePlayConfig_Tile_Width;
	self.h = GamePlayConfig_Tile_Height;

	self.gameModeId = nil
	self.seaAnimalType = nil

	self.isNeedUpdate = false;
	self.theGameBoardFallType = {};
	self.isMagicTileAnchor = false
	self.magicTileId = nil
	self.remainingHit = nil
	self.chains = {}
	self.showType = 0
	self.honeySubSelect = false
end

function GameBoardData:resetDatas()
	self.isUsed = false; 	--是否可用
	self.isMoveTile = false; -- 是否是移动地块
	self.isProducer = false;	--是否可以掉落出东西（生产）
	self.iceLevel = 0;		--冰层厚度
	self.passType = 0;		--没有通道，1=上方有[出口]，2=下方有[入口]，3=上方有[出口]且下方有[入口]
	self.passExitPoint_x = 0;
	self.passExitPoint_y = 0;	--连接的通道出口位置
	self.passEnterPoint_x = 0;
	self.passEnterPoint_y = 0;	--连接的通道入口位置
	self.isCollector = false; --能否掉出豆荚--收集口
	self.ropetype = 0;		--没有绳子 1=上方 2=下方 4=左方 8=右方<待定>
	self.isBlock = false;	--是block类型<毒液、雪花、牢笼>
	self.tileBlockType = 0;   --特殊地格类型 0=普通地格 1 = 翻转地格
	self.isReverseSide = false    --所在地块是否被翻转
	self.reverseCount = nil
	self.sandLevel = 0 	-- 流沙等级

	self.snailRoadType = 0   --蜗牛轨迹
	self.isSnailProducer = false --蜗牛生成口
	self.isSnailCollect  = false --蜗牛收集口
	self.nextSnailRoad = nil
	self.isSnailRoadBright = false
	self.snailTargetCount = 0
	self.snailRoadViewRotation = nil
	self.snailRoadViewType = nil

	self.isRabbitProducer = false -- 兔子生成口

	self.transType = TransmissionType.kNone
	self.transColor =TransmissionColor.kNone
	self.transDirect  = TransmissionDirection.kNone
	self.transLink = nil

	self.gameModeId = nil
	self.seaAnimalType = nil

	self.isNeedUpdate = false;
	self.theGameBoardFallType = {};
	self.isMagicTileAnchor = false
	self.magicTileId = nil
	self.remainingHit = nil
	self.chains = {}
	self.showType = 0
	self.honeySubSelect = false
	self.tileMoveCountDown = 0
	self.tileMoveReverse = false
	self.tileMoveMeta = nil
end

function GameBoardData.copyDatasFrom(toData, fromData)
	if type(fromData) ~= "table" then return end
	
	toData.isUsed 		= fromData.isUsed
	toData.isMoveTile 	= fromData.isMoveTile
	toData.isProducer		= fromData.isProducer
	toData.iceLevel		= fromData.iceLevel
	toData.passType		= fromData.passType
	toData.passEnterPoint_x	= fromData.passEnterPoint_x
	toData.passEnterPoint_y	= fromData.passEnterPoint_y
	toData.passExitPoint_x	= fromData.passExitPoint_x
	toData.passExitPoint_y	= fromData.passExitPoint_y
	toData.isCollector	= fromData.isCollector
	toData.ropetype		= fromData.ropetype
	toData.isBlock		= fromData.isBlock
	toData.tileBlockType = fromData.tileBlockType
	toData.isReverseSide = fromData.isReverseSide
	toData.reverseCount  = fromData.reverseCount
	toData.sandLevel		= fromData.sandLevel

	toData.isNeedUpdate = fromData.isNeedUpdate
	toData.theGameBoardFallType = {}

	toData.snailRoadType = fromData.snailRoadType   --蜗牛轨迹
	toData.isSnailProducer = fromData.isSnailProducer
	toData.isSnailCollect = fromData.isSnailCollect
	toData.snailTargetCount = fromData.snailTargetCount
	toData.snailRoadViewRotation = fromData.snailRoadViewRotation
	toData.snailRoadViewType = fromData.snailRoadViewType

	toData.isRabbitProducer = fromData.isRabbitProducer -- 兔子生成口
	toData.transType = fromData.transType
	toData.transDirect = fromData.transDirect
	toData.transLink = fromData.transLink
	toData.transColor = fromData.transColor
	
	for k, fallType in pairs(fromData.theGameBoardFallType) do
		toData.theGameBoardFallType[k] = fallType
	end

	toData.gameModeId = fromData.gameModeId
	toData.seaAnimalType = fromData.seaAnimalType
	toData.isMagicTileAnchor = fromData.isMagicTileAnchor
	toData.magicTileId = fromData.magicTileId
	toData.remainingHit = fromData.remainingHit
	toData.isHitThisRound = fromData.isHitThisRound

	toData.chains = {}
	for dir, chain in pairs(fromData.chains) do
		toData.chains[dir] = {direction = dir, level = chain.level}
	end

	toData.showType = fromData.showType
	toData.honeySubSelect = fromData.honeySubSelect
	toData.tileMoveCountDown = fromData.tileMoveCountDown
	toData.tileMoveReverse = fromData.tileMoveReverse
	toData.tileMoveMeta = fromData.tileMoveMeta
end

function GameBoardData:copy()
	local v = GameBoardData.new()
	v:initData()

	v.x = self.x
	v.y = self.y
	v.w = self.w
	v.h = self.h

	v:copyDatasFrom(self)
	return v
end

function GameBoardData:dispose()
end

function GameBoardData:create()
	local v = GameBoardData.new()
	v:initData()
	return v
end

function GameBoardData:initData()

end

function GameBoardData:initByConfig(tileDef)
	self.x = tileDef.x;
	self.y = tileDef.y;

	if tileDef:hasProperty(TileConst.kEmpty) then self.isUsed = false else self.isUsed = true end	--是否可用		--1
	if tileDef:hasProperty(TileConst.kCannonAnimal)then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonAnimal) end	--是否是生成口	--39
	if tileDef:hasProperty(TileConst.kCannonIngredient)then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonIngredient) end	--是否是生成口	--40
	if tileDef:hasProperty(TileConst.kCannonBlock)then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonBlock) end	--是否是生成口	--41
	if tileDef:hasProperty(TileConst.kCannonCoin) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonCoin) end 
	if tileDef:hasProperty(TileConst.kCannonCrystallBall) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonCrystallBall) end 
	if tileDef:hasProperty(TileConst.kCannonBalloon) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonBalloon) end 
	if tileDef:hasProperty(TileConst.kCannonHoneyBottle) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonHoneyBottle) end 
	if tileDef:hasProperty(TileConst.kCannonGreyCuteBall) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonGreyCuteBall) end 
	if tileDef:hasProperty(TileConst.kCannonBrownCuteBall) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonBrownCuteBall) end 
	if tileDef:hasProperty(TileConst.kCnanonBlackCuteBall) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCnanonBlackCuteBall) end 
	if #self.theGameBoardFallType <= 0 and tileDef:hasProperty(TileConst.kCannon) then self.isProducer = true table.insert(self.theGameBoardFallType, GameBoardFallType.kCannonAll) end	--是否是生成口	--5
	
	if tileDef:hasProperty(TileConst.kBlocker) then self.isBlock = true end							--是否为阻挡物	--6
	if tileDef:hasProperty(TileConst.kLock) then self.isBlock = true end							--牢笼也是阻挡物--8
	if tileDef:hasProperty(TileConst.kCollector) then self.isCollector = true end					--豆荚掉落出口	--10

	if tileDef:hasProperty(TileConst.kPortalEnter) then self.passType = self.passType + 2 end						--通道入口		--11
	if tileDef:hasProperty(TileConst.kPortalExit) then self.passType = self.passType + 1 end						--通道出口		--12

	if tileDef:hasProperty(TileConst.kWallUp) then self.ropetype = bit.bor(self.ropetype, 0x01) end			--绳子类型		--25\26\27\28\29
	if tileDef:hasProperty(TileConst.kWallDown) then self.ropetype = bit.bor(self.ropetype, 0x02) end		
	if tileDef:hasProperty(TileConst.kWallLeft) then self.ropetype = bit.bor(self.ropetype, 0x04) end		
	if tileDef:hasProperty(TileConst.kWallRight) then self.ropetype = bit.bor(self.ropetype, 0x08) end		

	if tileDef:hasProperty(TileConst.kSnailSpawn) then
		self.isSnailProducer = true self.snailRoadViewType = TileRoadType.kStartPoint self.snailRoadViewRotation = 0
	elseif tileDef:hasProperty(TileConst.kSnailCollect) then
		self.isSnailCollect  = true self.snailRoadViewType = TileRoadType.kEndPoint self.snailRoadViewRotation = 0
	end

	if tileDef:hasProperty(TileConst.kRabbitProducer) then 
		self.isRabbitProducer = true
	end

	if tileDef:hasProperty(TileConst.kMagicLamp) then
		self.isBlock = true
	end

	if tileDef:hasProperty(TileConst.kMagicTile) then
		self.isMagicTileAnchor = true
		self.isHitThisRound = false
		self.remainingHit = 7
	end

	if tileDef:hasProperty(TileConst.kSand) then -- 流沙
  		self.sandLevel = 1 
  	end

  	if tileDef:hasProperty(TileConst.kHoney_Sub_Select) then 
  		self.honeySubSelect = true
  	end
  	-- chains
  	local chainsMeta = tileDef:getChainsMeta()
  	self.chains = {}
  	if chainsMeta then
  		for _, v in pairs(chainsMeta) do
	  		self.chains[v.direction] = v
	  	end
  	end
  	
  	if tileDef:hasProperty(TileConst.kMoveTile) then self.isMoveTile = true end

	if tileDef:hasProperty(TileConst.kTileBlocker) then 
		self.tileBlockType = 1 self.reverseCount = 3 
	elseif tileDef:hasProperty(TileConst.kTileBlocker2) then
		self.tileBlockType = 1 self.reverseCount = 3 self.isReverseSide = true
	end  --翻转地格
end

function GameBoardData:onUseMoves()
	self.tileMoveCountDown = self.tileMoveCountDown - 1
end

function GameBoardData:resetMoveTileData()
	self.tileMoveCountDown = self.tileMoveMeta.moveCountDown or 1
end

function GameBoardData:checkTileCanMove()
	return self.isMoveTile and self.tileMoveCountDown <= 0
end

function GameBoardData:setTransmissionConfig(transType, transDirection, transColor, link)
	self.transType = transType
	self.transDirect = transDirection
	self.transColor = transColor or 0
	self.transLink = link
end

function GameBoardData:changeDataAfterTrans(gameBoardData)
	self.iceLevel = gameBoardData.iceLevel
	self.sandLevel = gameBoardData.sandLevel
	self.isNeedUpdate = true
end

function GameBoardData:initTileMoveByConfig(tileMoveConfig)
	if tileMoveConfig then
		local tileMoveMeta = tileMoveConfig:findTileMoveMetaByPos(self.y, self.x)
		-- print("initTileMoveByConfig:", self.y, self.x, table.tostring(tileMoveMeta))
		self.tileMoveMeta = tileMoveMeta
		self:resetMoveTileData()
	end
end

function GameBoardData:initSnailRoadDataByConfig( tileDef )
	-- body
	if tileDef then 
		if tileDef:hasProperty(RouteConst.kUp) then
			self.snailRoadType = RouteConst.kUp
		elseif tileDef:hasProperty(RouteConst.kDown) then
			self.snailRoadType = RouteConst.kDown
		elseif tileDef:hasProperty(RouteConst.kLeft) then
			self.snailRoadType = RouteConst.kLeft
		elseif tileDef:hasProperty(RouteConst.kRight) then
			self.snailRoadType = RouteConst.kRight
		end

	end

end

function GameBoardData:setPreSnailRoad( preSnailRoadType)
	-- body
	if self.snailRoadViewType and self.snailRoadViewType == TileRoadType.kEndPoint then ----collect point
	elseif self.snailRoadViewType and self.snailRoadViewType == TileRoadType.kStartPoint then  --product point
	elseif not preSnailRoadType or self.snailRoadType == preSnailRoadType then   --line
		if self.snailRoadType == RouteConst.kRight or self.snailRoadType == RouteConst.kLeft then
			self.snailRoadViewRotation = 0 self.snailRoadViewType = TileRoadType.kLine
		elseif self.snailRoadType == RouteConst.kUp or self.snailRoadType == RouteConst.kDown then
			self.snailRoadViewRotation = 90 self.snailRoadViewType = TileRoadType.kLine
		end
	else                                                            --corner
		self.snailRoadViewType = TileRoadType.kCorner
		if preSnailRoadType == RouteConst.kDown then
			self.snailRoadViewRotation = self.snailRoadType == RouteConst.kLeft and 0 or 90
		elseif preSnailRoadType == RouteConst.kUp then
			self.snailRoadViewRotation = self.snailRoadType == RouteConst.kLeft and 270 or 180
		elseif preSnailRoadType == RouteConst.kLeft then
			self.snailRoadViewRotation = self.snailRoadType == RouteConst.kUp and 90 or 180
		elseif preSnailRoadType == RouteConst.kRight then
			self.snailRoadViewRotation = self.snailRoadType == RouteConst.kUp and 0 or 270
		end
	end
end

function GameBoardData:getSnailRoadViewType( ... )
	-- body
	return self.snailRoadViewType
end

function GameBoardData:getSnailRoadRotation( ... )
	-- body
	return self.snailRoadViewRotation
end

function GameBoardData:getNextSnailRoad( ... )
	-- body
	if not self.nextSnailRoad then
		if self.snailRoadType == RouteConst.kUp then
			self.nextSnailRoad = IntCoord:create(self.y -1, self.x)
		elseif self.snailRoadType == RouteConst.kDown then
			self.nextSnailRoad = IntCoord:create(self.y + 1, self.x)
		elseif self.snailRoadType == RouteConst.kLeft then
			self.nextSnailRoad = IntCoord:create(self.y, self.x - 1)
		elseif self.snailRoadType == RouteConst.kRight then
			self.nextSnailRoad = IntCoord:create(self.y, self.x + 1 )
		end
	end
	return self.nextSnailRoad
end

function GameBoardData:isHasPreSnailRoad( ... )
	-- body
	if self.snailRoadType > 0 or self.isSnailCollect then 
		return true
	else
		return false
	end
end

function GameBoardData:hasSameChains(otherBoard)
	if not otherBoard then return false end
	return self:chainsInNumber() == otherBoard:chainsInNumber()
end

function GameBoardData:chainsInNumber()
	local ret = 0
	for _,v in pairs(self.chains) do
		ret = ret + v.level * (math.pow(10, v.direction - 1))
	end
	return ret
end

function GameBoardData:hasChains()
	for _,v in pairs(self.chains) do
		if v.level > 0 then
			return true
		end
	end
	return false
end

function GameBoardData:decChainsInDirections(dirs)
	local breakLevels = {}
	if dirs then
		for _, dir in pairs(dirs) do
			local breakLevel = self:decChainInDirection(dir)
			breakLevels[dir] = breakLevel
		end
	end
	return breakLevels
end

function GameBoardData:decChainInDirection(dir)
	local originLevel = 0
	local chain = self:getChainInDirection(dir)
	if chain and chain.level > 0 then
		originLevel = chain.level 
		chain.level = chain.level - 1
	end
	return originLevel
end

function GameBoardData:getChainInDirection(dir)
	return self.chains[dir]
end

-- dir in ChainDirConfig
function GameBoardData:hasChainInDirection(dir)
	local chain = self:getChainInDirection(dir)
	if chain and chain.level > 0 then
		return true
	else
		return false
	end
end

function GameBoardData:initLightUp(tileDef)
	if tileDef:hasProperty(TileConst.kLight1)then self.iceLevel = 1									--冰层厚度		--3\4\30
	elseif tileDef:hasProperty(TileConst.kLight2)then self.iceLevel = 2
	elseif tileDef:hasProperty(TileConst.kLight3)then self.iceLevel = 3
	end
end

function GameBoardData:addPassEnterInfo(x, y)
	self.passExitPoint_x = x;
	self.passExitPoint_y = y;
end

function GameBoardData:addPassExitInfo(x, y)
	self.passEnterPoint_x = x;
	self.passEnterPoint_y = y;
end

function GameBoardData:hasRope()
	return self.ropetype ~= 0
end

function GameBoardData:hasLeftRopeProperty()
	return bit.band(self.ropetype, 0x04) ~= 0
end

function GameBoardData:hasRightRopeProperty()
	return bit.band(self.ropetype, 0x08) ~= 0
end

function GameBoardData:hasTopRopeProperty()
	return bit.band(self.ropetype, 0x01) ~= 0
end

function GameBoardData:hasBottomRopeProperty()
	return bit.band(self.ropetype, 0x02) ~= 0
end

function GameBoardData:hasLeftRope()
	return self:hasLeftRopeProperty() or self:hasChainInDirection(ChainDirConfig.kLeft)
end

function GameBoardData:hasRightRope()
	return self:hasRightRopeProperty() or self:hasChainInDirection(ChainDirConfig.kRight)
end

function GameBoardData:hasTopRope()
	return self:hasTopRopeProperty() or self:hasChainInDirection(ChainDirConfig.kUp)
end

function GameBoardData:hasBottomRope()
	return self:hasBottomRopeProperty() or self:hasChainInDirection(ChainDirConfig.kDown)
end

function GameBoardData:hasPortal()
	return self.passType > 0
end

--是否是翻转地格
function GameBoardData:isRotationTileBlock( ... )
	-- body
	return self.tileBlockType == 1
end

-- 含有传送门入口，即格子下边缘的传送门视图
function GameBoardData:hasEnterPortal()
	return self.passType == 2 or self.passType == 3
end

-- 含有传送门出口，即格子上边缘的传送门视图
function GameBoardData:hasExitPortal()
	return self.passType == 1 or self.passType == 3
end

function GameBoardData:initSeaAnimal(seaAnimalType)
	self.seaAnimalType = seaAnimalType
end

function GameBoardData:setGameModeId(gameModeId)
	self.gameModeId = gameModeId
end

function GameBoardData:initUnlockAreaDropDownModeInfo( ... )
	-- body
	if self.isCollector then 
		self.showType = IngredientShowType.kAcorn
	end
end

function GameBoardData:isBigMonsterEffectPrior1( ... )
	-- body
	if 	self.iceLevel > 0  
		or self.sandLevel > 0 then 
		return true
	else
		return false
	end
end

function GameBoardData:isBigMonsterEffectPrior2( ... )
	-- body
	if self:hasChains() 
		or self.snailRoadType > 0 then
		return true
	else
		return false
	end
end

function GameBoardData:isBigMonsterEffectPrior3( ... )
	-- body
	return false
end