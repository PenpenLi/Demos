require "zoo.animation.TileCharacter"
require "zoo.animation.TileBird"
require "zoo.animation.GamePropsAnimation"
require "zoo.animation.LinkedItemAnimation"
require "zoo.animation.TileCuteBall"
require "zoo.animation.CommonEffect"

require "zoo.itemView.ItemView"
require "zoo.gamePlay.GamePlayConfig"
require "zoo.gamePlay.GameBoardLogic"
require "zoo.gamePlay.BoardView.BoardViewAction"
require "zoo.gamePlay.BoardView.BoardViewPass"
require "zoo.gamePlay.propInteractions.InteractionController"
require "zoo.animation.TileHalloweenBoss"

GameBoardView = class(Layer)

local needCopyLayers = {
	ItemSpriteType.kTileBlocker,
	ItemSpriteType.kItem, 
	ItemSpriteType.kItemShow,
	ItemSpriteType.kRope,
	ItemSpriteType.kLock,
	ItemSpriteType.kFurBall,
	ItemSpriteType.kNormalEffect,
	ItemSpriteType.kBigMonster,
	ItemSpriteType.kDigBlocker,
}

function GameBoardView:ctor()
	self.baseMap = nil;			--地格--落稳的东西
	self.ItemFalling = nil;		--下落中的东西
	self.showPanel = nil;

	self.baseLocation = nil;
	self.PosStart = nil;		--游戏面板的起始位置--用来计算点击到哪个方块上了
	self.ItemW = GamePlayConfig_Tile_Width;
	self.ItemH = GamePlayConfig_Tile_Height;

	self.gameBoardLogic = nil;

	self.isTouchReigister = false;
	self.isRegisterUpdate = false;
	self.updateScheduler = nil;

	self.IngredientActionPos = ccp(50,800) 			----豆荚收集之后 飞向的位置
	self.moveCountPos = ccp(90, 80)				----移动步数所在位置，bonus时会飞出特效

	self.PlayUIDelegate = nil;
	self.isPaused = false;
	-- Init Base
	Layer.initLayer(self)

	-- 震动计数器
	self.viberateCounter = 0
	self.viberateDelay = 0
	self.originPos = nil

	-- 道具使用状态
	self.gamePropsType = GamePropsType.kNone
	self.debugCounter = 0
end

function GameBoardView:dispose()
	self:unRegisterAll()
	self.updateScheduler = nil;

	self.ItemFalling = nil;

	self:cleanAllItemSprite()
	self.baseMap = nil

	if self.showPanel then
		for i=1,#self.showPanel do
			if self.showPanel[i] ~= nil and self.showPanel[i]:getParent() then 
				self.showPanel[i]:removeFromParentAndCleanup(true);
			end
		end
	end
	self.showPanel = nil

	self:removeDigScrollView()

	self.gameBoardLogic = nil;
	self.baseLocation = nil;
	self.PosStart = nil;

	Layer.dispose(self)

	self.originPos = nil
end


function GameBoardView:create(isHalloween)
	local v = GameBoardView.new()
	v:initView(v, v, isHalloween)
	return v
end

function GameBoardView:createByGameBoardLogic(gameBoardLogic)
	local isHalloween = gameBoardLogic.gameMode:is(HalloweenMode)
	local theview = GameBoardView:create(isHalloween);
	theview.gameBoardLogic = gameBoardLogic;			--记录逻辑来源
	gameBoardLogic.boardView = theview

	local boardMap = gameBoardLogic:getBoardMap();
	theview:initBaseMapByData(boardMap)					--加载地图信息
	
	local itemMap = gameBoardLogic:getItemMap()
	theview:initBaseMapByItemData(itemMap)				--加载GameItem信息

	theview:initBaseMapView()												-- 初始化显示
	theview:paintBorder(boardMap)											-- 绘制棋盘边缘

	local offset = theview:resizeToFitScreen(boardMap)
	theview.bgOffset = offset

	theview:RegisterAll()

	theview:initInteractionController()

	return theview, offset													-- 棋盘适配屏幕大小并放到屏幕中央
end

function GameBoardView:initInteractionController()
	if not self.interactionController then
		self.interactionController = InteractionController:create(self)
	end
	self.interactionController:init()
end

function GameBoardView:useForceSwap(item1Pos, item2Pos)
	if self.gameBoardLogic:useProps(self.gamePropsType, item1Pos.x, item1Pos.y, item2Pos.x, item2Pos.y) then
        self:focusOnItem(nil)
        self.gamePropsType = GamePropsType.kNone
        self.PlayUIDelegate:confirmPropUsed()
    end

end

function GameBoardView:useHammer(itemPos)
	if self.gameBoardLogic:useProps(self.gamePropsType, itemPos.x, itemPos.y) then
		self.gamePropsType = GamePropsType.kNone
		self.PlayUIDelegate:confirmPropUsed(self.gameBoardLogic:getGameItemPosInView(itemPos.x, itemPos.y))
	end
end

function GameBoardView:useBrush(itemPos, direction)
	if self.gameBoardLogic:useProps(self.gamePropsType, itemPos.x, itemPos.y, direction.x, direction.y) then
        self.gamePropsType = GamePropsType.kNone
        self.PlayUIDelegate:confirmPropUsed(self.gameBoardLogic:getGameItemPosInView(itemPos.x, itemPos.y))
    end
end

function GameBoardView:useRandomBird()
	local pos = self.gameBoardLogic:getPositionForRandomBird()
	if self.gameBoardLogic:useProps(self.gamePropsType, pos.r, pos.c) then
		self.gamePropsType = GamePropsType.kNone
		self.PlayUIDelegate:confirmPropUsed(self.gameBoardLogic:getGameItemPosInView(pos.r, pos.c))
	end
end

function GameBoardView:useBroom(itemPos)
	if self.gameBoardLogic:useProps(self.gamePropsType, itemPos.r, itemPos.c) then
		self.gamePropsType = GamePropsType.kNone
		self.PlayUIDelegate:confirmPropUsed(self.gameBoardLogic:getGameItemPosInView(itemPos.r, itemPos.c))
	end
end

function GameBoardView:reInitByGameBoardLogic(gameBoardLogic)
	gameBoardLogic = gameBoardLogic or self.gameBoardLogic
	self:cleanAllItemSprite();
	local boardMap = gameBoardLogic:getBoardMap();
	self:initBaseMapByData(boardMap)					--加载地图信息
	local itemMap = gameBoardLogic:getItemMap()
	self:initBaseMapByItemData(itemMap)				--加载GameItem信息
	self:initBaseMapView()		--初始化显示
end

function GameBoardView:cleanAllItemSprite()
	for r=1,#self.baseMap do
		for c=1,#self.baseMap[r] do
			for i=ItemSpriteType.kBackground, ItemSpriteType.kLast do
				local sprite1 =self.baseMap[r][c].itemSprite[i]
				if sprite1 then 
					if sprite1:getParent() then
						sprite1:removeFromParentAndCleanup(true);
					end
					self.baseMap[r][c].itemSprite[i] = nil;
				end
			end
			self.showPanel[ItemSpriteType.kClipping]:removeChild(self.baseMap[r][c].clippingnode, true)
			self.showPanel[ItemSpriteType.kEnterClipping]:removeChild(self.baseMap[r][c].enterClippingNode, true)
			self.baseMap[r][c] = nil
		end
	end
end

function GameBoardView:TouchAt(x,y)	----返回点击的Item的xy
	----------面板偏移量
	if self.baseLocation == nil then --初始化一些东西
		--local pointadd = self.showPanel[ItemSpriteType.kBackground]:getPosition();
		--print("GameBoardView:TouchAt(x,y) pointadd x, y", pointadd.x, pointadd.y);
		--self.baseLocation = self.baseMap[1][1]:getBasePosition(1,1)
		--print("baseLocation x, y", self.baseLocation.x, self.baseLocation.y);

		--self.PosStart = ccpAdd(pointadd, self.baseLocation)
		self.PosStart = ccp(0,0);
		--if self.PosStart then print("PosStart", self.PosStart.x, self.PosStart.y) end;
		local selfpos_x = self:getPositionX();
		local selfpos_y = self:getPositionY();
		--print("selfposition x, y", selfpos_x, selfpos_y);
		self.PosStart.x = self.PosStart.x + self:getPositionX()
		self.PosStart.y = self.PosStart.y + self:getPositionY()

		self.ItemW = GamePlayConfig_Tile_Width
		self.ItemH = GamePlayConfig_Tile_Height
		--print("self.PosStart", self.PosStart, self.ItemW, self.ItemH)
		--if self.PosStart then print("PosStart", self.PosStart.x, self.PosStart.y) end;
	end
	if self.PosStart then 			----修正偏移量
		x = x - self.PosStart.x;
		y = y - self.PosStart.y;
	end

	local temp_x = math.ceil(x / self.ItemW / GamePlayConfig_Tile_ScaleX)
	local temp_y = math.ceil(GamePlayConfig_Max_Item_Y -1 - y / self.ItemH / GamePlayConfig_Tile_ScaleY)
	--print("TouchAt",x, y, temp_x, temp_y);

	--print("#self.baseMap[1] #self.baseMap", #self.baseMap[1], #self.baseMap)
	if temp_x >= 1 and temp_x <= #self.baseMap[1] 
		and temp_y >= 1 and temp_y <= #self.baseMap
		then
		--print("temp_x", temp_x, temp_y)
		--return ccp(temp_x, temp_y)
		return ccp(temp_y, temp_x)
	end
	return ccp(temp_y, temp_x)
end

function GameBoardView:onTouchBegan(x, y)
	if not (self.gameBoardLogic.isWaitingOperation and not self.gameBoardLogic.isPaused) then return end
	self.interactionController:getCurrentInteraction():handleTouchBegin(x, y)
	return true
end
function GameBoardView:onTouchMoved(x, y)
	if not (self.gameBoardLogic.isWaitingOperation and not self.gameBoardLogic.isPaused) then return end
	self.interactionController:getCurrentInteraction():handleTouchMove(x, y)
	return true
end
function GameBoardView:onTouchEnded(x, y)
	if not (self.gameBoardLogic.isWaitingOperation and not self.gameBoardLogic.isPaused) then return end
	self.interactionController:getCurrentInteraction():handleTouchEnd(x, y)
	return true
end


function GameBoardView:trySwapItem(x1,y1,x2,y2)
    local ret1 = self.gameBoardLogic:canBeSwaped(x1, y1, x2, y2);
	--可以交换的两个块
	if ret1 == 1 then
		self.gameBoardLogic:startTrySwapedItem(x1, y1, x2, y2)
		self:focusOnItem(nil)
		return true;
	elseif ret1 == 2 then
		self.gameBoardLogic:startTrySwapedItemFun(x1,y1,x2,y2)
		self:focusOnItem(nil)
		return true;
	else
		return false;
	end
end


-- isHalloween 为了兼容magic tile障碍加入一个clippingNode
function GameBoardView:initView(container, context, isHalloween)
	local showPanel = {}

	for i = ItemSpriteType.kBackground, ItemSpriteType.kLast do
		if (showPanel[i] == nil) then
			if i == ItemSpriteType.kBackground		--BatchNode
				then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/mapTiles.png"), 200));--100表示预计有100个物体
			elseif i == ItemSpriteType.kLock
				or i == ItemSpriteType.kItem
				then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/mapBaseItem.png"), 200));--100表示预计有100个物体
			elseif i == ItemSpriteType.kLight then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/mapLight.png"), 200));
			elseif i == ItemSpriteType.kPass then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/link_item.png"), 200));
			elseif i == ItemSpriteType.kLockShow then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/mapLock.png"), 100));
			elseif i == ItemSpriteType.kSnowShow then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/mapSnow.png"), 100));
			elseif i == ItemSpriteType.kItemDestroy then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/destroy_effect.png"), 200));
			elseif i == ItemSpriteType.kSnailRoad then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/snail_road.png"), 100));
			elseif i == ItemSpriteType.kDigBlocker then
				showPanel[i] = CocosObject:create()
				showPanel[i]:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/dig_block.png"), 200));
			elseif isHalloween and (i == ItemSpriteType.kTileBlocker or i == ItemSpriteType.kRope) then
				showPanel[i] = SimpleClippingNode:create()
				showPanel[i]:setContentSize(CCSizeMake(GamePlayConfig_Tile_Width * 9, GamePlayConfig_Tile_Height * 8))
			else
				showPanel[i] = CocosObject:create()
			end

			container:addChild(showPanel[i], i)
		end
	end

	context.showPanel = showPanel
	
	if self.labelBatch == nil then
		----分数展示层
		self.labelBatch = BMFontLabelBatch:create("fnt/rising_score.png",
								"fnt/rising_score.fnt",
								100)
		self:addChild(self.labelBatch);
	end

	if self.specialEffectBatch == nil then
		--直线特效显示层
		self.specialEffectBatch = CocosObject:create()
		self.specialEffectBatch:setRefCocosObj(CCSpriteBatchNode:create(SpriteUtil:getRealResourceName("flash/explode.png"),100))
		self:addChild(self.specialEffectBatch)
	end
end

function GameBoardView:RegisterAll()
	print("GameBoardView:RegisterAll()")
	------注册点击函数----
	local  context = self
	local function onTouch(eventType, x, y)
		if eventType == "began" then   
			return context:onTouchBegan(x, y)
		elseif eventType == "moved" then
			return context:onTouchMoved(x, y)
		else
			return context:onTouchEnded(x, y)
		end
	end

	if self.isTouchReigister == false then
		self.isTouchReigister = true
		--self:setTouchEnabled(true)
		self.refCocosObj:setTouchEnabled(true) 
		self:registerScriptTouchHandler(onTouch)
	end

	--注册响应函数，按帧响应
	local _execute_frames = 0
	local _execute_time = 0
	local function _updateGame(dt)
		context:updateGame(dt)
    -- wp8需要补帧
		if __WP8 then
			_execute_frames = _execute_frames + 1
			_execute_time = _execute_time + dt
			if _execute_time > 0 and (_execute_frames + 1) / _execute_time < 60 then
				context:updateGame(0)
				_execute_frames = _execute_time * 60
			end
		end
	end
	if self.isRegisterUpdate == false then
		local time_cd = 1.0 / GamePlayConfig_Action_FPS    
		self.updateScheduler = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(_updateGame, time_cd, false)
		self.isRegisterUpdate = true
		if __WP8 then
			print("clear for wp8 when begin game")
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
			collectgarbage("collect")
		end
	end
end

function GameBoardView:unRegisterAll()
	if self.isTouchReigister == true then
		self.isTouchReigister = false
		self.refCocosObj:setTouchEnabled(false) 
		self:unregisterScriptTouchHandler()
	end

	if self.isRegisterUpdate == true then
		self.isRegisterUpdate =false
		Director:getScheduler():unscheduleScriptEntry(self.updateScheduler)
		self.updateScheduler = nil;
		if __WP8 then
			print("clear for wp8 when end game")
			CCTextureCache:sharedTextureCache():removeUnusedTextures()
			collectgarbage("collect")
		end
	end
end

local ProFi = require "zoo.util.ProFi"
----游戏逻辑更新循环
function GameBoardView:updateGame(dt)
	if self.isPaused == false then 
		-- if self.debugCounter == 0 then
		-- 	ProFi:start()
		-- 	self.debugCounter = self.debugCounter + 1
		-- else
		-- 	self.debugCounter = self.debugCounter + 1
		-- 	if self.debugCounter == 100 then
		-- 		ProFi:stop()
		-- 		ProFi:writeReport("sb.txt")
		-- 		print("stop record profiler")
		-- 	end
		-- end
		-- if not self.gameBoardLogic.isWaitingOperation then
		-- 	if not self.isRecord then
		-- 		self.isRecord = true
		-- 		ProFi:start()
		-- 	end
		-- else
		-- 	if self.isRecord then
		-- 		self.isRecord = false
		-- 		self.debugCounter = self.debugCounter + 1
		-- 		ProFi:stop()
		-- 		ProFi:writeReport("profile/profileLog" .. self.debugCounter .. ".txt")
		-- 	end
		-- end
		self.gameBoardLogic:updateGame(dt) 		----游戏逻辑推进---1.runAction---2.检测掉落
		self:updateItemViewByLogic()			----界面展示刷新
		BoardViewAction:runAllAction(self)		----对应动作变化
		self:updateItemViewSelf()				----界面自我刷新

		--self:checkEmptyClippingNode();			----减少对空闲裁减区域的绘制
		--self:outputShowPanelCount() 			----性能检测
	end
end

function GameBoardView:checkEmptyClippingNode()
	-- if self and self.showPanel[ItemSpriteType.kClipping] then
	-- 	print("ItemSpriteType", ItemSpriteType.kClipping, self, self.showPanel[ItemSpriteType.kClipping]);
	-- 	--debug.debug();
	-- 	local count = self.showPanel[ItemSpriteType.kClipping]:getNumOfChildren();
	-- 	self.showPanel[ItemSpriteType.kClipping]:removeFromParentAndCleanup();
	-- 	print("count", count)
	-- 	--debug.debug();
	-- 	for i = 0, count-1 do 
	-- 		print("i",i)
	-- 		local item = self.showPanel[ItemSpriteType.kClipping]:getChildAt(i)
	-- 		print("item",item)
	-- 		--debug.debug();
	-- 		if item then
	-- 			if item:getNumOfChildren() == 0 then
	-- 				item:setVisible(false)
	-- 				print("item setVisible false",i)
	-- 			else
	-- 				item:setVisible(true)
	-- 				print("item setVisible true",i)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

local output_cd = 0
function GameBoardView:outputShowPanelCount()
	output_cd = output_cd + 1;
	if output_cd < 120 then return end 				----两秒一次
	output_cd = 0
	for i = ItemSpriteType.kBackground, ItemSpriteType.kLast do
		if (self.showPanel[i]) then
			local count = self.showPanel[i]:getNumOfChildren();
			print("outputShowPanelCount i count", i, count)
		end
	end
end


function GameBoardView:initBaseMapByData(boardmap)--初始化基本地图
	if not self.baseMap then
		self.baseMap = {}
		for i=1,9 do
			self.baseMap[i] = {}
		end
	end

	--创建地图显示用格子
	for i=1, #boardmap do
		if self.baseMap[i] == nil then self.baseMap[i] = {} end		--地图显示
		
		for j=1,#boardmap[i] do
			self.baseMap[i][j] = ItemView:create();
			self.baseMap[i][j]:initByBoardData(boardmap[i][j])
			self.baseMap[i][j]:initPosBoardDataPos(boardmap[i][j])
		end
	end
end

function GameBoardView:initBaseMapByItemData(ItemMap)--初始化基本地图
	for i=1, #ItemMap do
		if self.baseMap[i] == nil then self.baseMap[i] = {} end		--地图显示
		for j=1,#ItemMap[i] do
			if self.baseMap[i][j] == nil then self.baseMap[i][j] = ItemView:create() end
			self.baseMap[i][j].itemPanel = self.showPanel;
			self.baseMap[i][j]:initByItemData(ItemMap[i][j])
			self.baseMap[i][j]:initPosBoardDataPos(ItemMap[i][j], true)
			
		end
	end
end

function GameBoardView:updateItemViewByLogic() 			--------因为Logic的变化导致界面变化
	local boardmap = self.gameBoardLogic:getBoardMap();
	local itemMap = self.gameBoardLogic:getItemMap()

	for i = 1, #boardmap do
		for j = 1, #boardmap[i] do 
			local ts = 0
			if boardmap[i][j].isNeedUpdate == true then 			----地图数据发生变化
				ts = 1
				self.baseMap[i][j]:updateByNewBoardData(boardmap[i][j])
			end

			if itemMap[i][j].isNeedUpdate == true then 				----地图上的Item发生变化
				self.baseMap[i][j]:updateByNewItemData(itemMap[i][j])	-----更新Item的显示数据------
				ts = 2
			end

			if ts ~= 0 then
				self:updateBaseMapViewItem(i,j)							-----更新Item的Layer从属关系------
				if ts == 2 then 
					self.baseMap[i][j]:upDatePosBoardDataPos(itemMap[i][j], true)----------更新Item的显示位置-------
				end
			end
		end
	end
end

function GameBoardView:updateItemViewSelf()
	for i= 1, #self.baseMap do
		for j = 1, #self.baseMap[i] do

			if self.baseMap[i][j].isNeedUpdate == true then
				self.baseMap[i][j].isNeedUpdate = false
				self:updateBaseMapViewItem(i,j)
			end
		end
	end

	-- 棋盘震动更新
	self:viberateUpdate()
end

----更新节点从属关系
function GameBoardView:updateBaseMapViewItem(r,c)
	for k = ItemSpriteType.kBackground, ItemSpriteType.kLast do
		local itemSprite = self.baseMap[r][c]:getItemSprite(k);
		if itemSprite then
			if itemSprite:getParent() == nil then
				if (itemSprite.refCocosObj ~= nil) then
					self.showPanel[k]:addChild(itemSprite)
				else
					print("itemSprite.refCocosObj == nil  r, c, k", r, c, k)
					print("出错了！！！");
					self.baseMap[r][c].itemSprite[k] = nil;
				end
			end
		end
	end
end

function GameBoardView:initBaseMapView()
	for i=1, #self.baseMap do
		for j=1, #self.baseMap[i] do
			if self.baseMap[i][j] then
				for k = ItemSpriteType.kBackground, ItemSpriteType.kLast do
					local itemSprite = self.baseMap[i][j]:getItemSprite(k);
					if itemSprite then
						if not itemSprite:getParent() then
							if (itemSprite.refCocosObj ~= nil) then
								self.showPanel[k]:addChild(itemSprite)
							else
								print("itemSprite.refCocosObj == nil  r, c, k", r, c, k)
								print("出错了！！！");
								self.baseMap[i][j].itemSprite[k] = nil;
							end
						end
					end
				end
			end
		end
	end
end

function GameBoardView:initDigScrollView(gameItemMap, boardMap, isEightRowMode)
	self:createDigScrollView(gameItemMap, boardMap, isEightRowMode)
	self.digViewContainer:setPosition(ccp(0, self.digViewContainer.numExtraRow * GamePlayConfig_Tile_Height))
end

function GameBoardView:scrollMoreDigView(gameItemMap, boardMap, completeCallback, isEightRowMode)
	self:createDigScrollView(gameItemMap, boardMap, isEightRowMode)
	local actionList = CCArray:create()
	actionList:addObject(CCMoveTo:create(self.digViewContainer.numExtraRow * 0.3, ccp(0, self.digViewContainer.numExtraRow * GamePlayConfig_Tile_Height)))
	actionList:addObject(CCCallFunc:create(completeCallback))
	local sequenceAction = CCSequence:create(actionList)
	self.digViewContainer:runAction(sequenceAction)
end

function GameBoardView:createDigScrollView(gameItemMap, boardMap, isEightRowMode)
	local startRowIndex = 1
	local rowCount = 9
	if isEightRowMode then
		startRowIndex = 2
		rowCount = 8
	end
	local function initItemViewByData()
		for i = startRowIndex, #gameItemMap do
			if self.digBaseMap[i] == nil then self.digBaseMap[i] = {} end
			for j = 1, #gameItemMap[i] do
				if self.digBaseMap[i][j] == nil then self.digBaseMap[i][j] = ItemView:create() end
				self.digBaseMap[i][j].itemPanel = self.digContext.showPanel
				self.digBaseMap[i][j]:initByBoardData(boardMap[i][j])
				self.digBaseMap[i][j]:initByItemData(gameItemMap[i][j])
				self.digBaseMap[i][j]:initPosBoardDataPos(gameItemMap[i][j], true)
			end
		end
	end

	local function addItemViewToContainer()
		for i = startRowIndex, #self.digBaseMap do
			for j = 1, #self.digBaseMap[i] do
				if self.digBaseMap[i][j] then
					for idx, layerIdx in ipairs(needCopyLayers) do
						local itemSprite = self.digBaseMap[i][j]:getItemSprite(layerIdx)
						if itemSprite then
							if not itemSprite:getParent() then
								if (itemSprite.refCocosObj ~= nil) then
									self.digContext.showPanel[layerIdx]:addChild(itemSprite)
								else
									self.baseMap[i][j].itemSprite[layerIdx] = nil
								end
							end
						end
					end
				end
			end
		end
	end

	local clippingnode = SimpleClippingNode:create()
	clippingnode:setContentSize(CCSizeMake(GamePlayConfig_Tile_Width * 9, GamePlayConfig_Tile_Height * rowCount))
	self:addChild(clippingnode)

	local digViewContainer = CocosObject:create()
	clippingnode:addChild(digViewContainer)

	self.digClippingNode = clippingnode
	self.digViewContainer = digViewContainer
	self.digContext = {}

	self:initView(digViewContainer, self.digContext)
	self.digBaseMap = {}
	initItemViewByData()
	addItemViewToContainer()

	self.digViewContainer.numExtraRow = #gameItemMap - 9
end

function GameBoardView:removeDigScrollView()
	if self.digContext then
		for idx, layerIdx in ipairs(needCopyLayers) do
			if self.digContext.showPanel[layerIdx] and self.digContext.showPanel[layerIdx]:getParent() then
				self.digContext.showPanel[layerIdx]:removeFromParentAndCleanup(true)
				self.digContext.showPanel[layerIdx] = nil
			end
		end
		self.digContext = nil
	end

	if self.digViewContainer then
		self.digViewContainer:stopAllActions()
		self.digViewContainer:removeFromParentAndCleanup(true)
		self.digViewContainer = nil
	end

	if self.digClippingNode then
		self.digClippingNode:removeFromParentAndCleanup(true)
		self.digClippingNode = nil
	end

	if self.digBaseMap then
		self.digBaseMap = nil
	end

	if self.digContext then
		self.digContext = nil
	end
end

function GameBoardView:startScrollInitDigView(completeCallback)
	local actionList = CCArray:create()
	-- actionList:addObject(CCDelayTime:create(2))
	actionList:addObject(CCMoveTo:create(self.digViewContainer.numExtraRow * 0.3, ccp(0, 0)))
	actionList:addObject(CCCallFunc:create(completeCallback))
	local sequenceAction = CCSequence:create(actionList)
	self.digViewContainer:runAction(sequenceAction)
end

function GameBoardView:hideItemViewLayer()
	for i, layerIndex in ipairs(needCopyLayers) do
		local layerContainer = self.showPanel[layerIndex]
		layerContainer:setVisible(false)
	end
end

function GameBoardView:showItemViewLayer()
	for i, layerIndex in ipairs(needCopyLayers) do
		local layerContainer = self.showPanel[layerIndex]
		layerContainer:setVisible(true)
	end
end

--焦点转移至Item(x,y)上
function GameBoardView:focusOnItem(target)
	if self.gameBoardLogic.isWaitingOperation and self.gameBoardLogic.theGamePlayStatus == GamePlayStatus.kNormal then
		if target then
			self:playSelectEffect(target.x, target.y)
		else
			self:stopOldSelectEffect()
		end
	end
end

function GameBoardView:playSelectEffect(r, c)
	if self.oldSelectTarget and self.oldSelectTarget.r == r and self.oldSelectTarget.c == c then
		return
	end

	local itemView = self.baseMap[r][c]
	local itemData = self.gameBoardLogic.gameItemMap[r][c]

	if itemView == nil or itemData == nil 
		or not itemData.isUsed 
		or itemData.isEmpty then
		return
	end

	self:stopOldSelectEffect()
	self.oldSelectTarget = { r = r, c = c }
	itemView:playSelectEffect(itemData)
	GamePlayMusicPlayer:playEffect(GameMusicType.kKeyboard)
end

function GameBoardView:stopOldSelectEffect()
	if self.oldSelectTarget then
		print("----------stop old select effect")
		local oldSelectItemView = self.baseMap[self.oldSelectTarget.r][self.oldSelectTarget.c]
		local oldSelectItemData = self.gameBoardLogic.gameItemMap[self.oldSelectTarget.r][self.oldSelectTarget.c]
		oldSelectItemView:stopSelectEffect(oldSelectItemData)
		self.oldSelectTarget = nil
	end
end

function GameBoardView:paintBorder(boardMap)
	local sideH = GamePlayConfig_Tile_Width
	local sideV = GamePlayConfig_Tile_Height
	local sideB = GamePlayConfig_Tile_BorderWidth
	local maxHeight = sideV * (GamePlayConfig_Max_Item_Y - 1)

	for i = 1, #boardMap do
		for j = 1, #boardMap[i] do
			local function createSprite(frameName, x, y, scaleX, scaleY, rotation)
				local sprite = Sprite:createWithSpriteFrameName(frameName)
				sprite:setAnchorPoint(ccp(0, 0))
				sprite:setPosition(ccp(x, y))
				sprite:setScaleX(scaleX)
				sprite:setScaleY(scaleY)
				sprite:setRotation(rotation)
				return sprite
			end
			local x, y, w, h
			if boardMap[i][j].isUsed then
				self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("tile_center.png", 
					self.baseMap[i][j].pos_x - sideH / 2, self.baseMap[i][j].pos_y - sideV / 2, 1, 1, 0))

				if j <= 1 or not boardMap[i][j - 1].isUsed then -- 左
					self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_edge_long.png", self.baseMap[i][j].pos_x -
						sideH / 2, self.baseMap[i][j].pos_y - sideV / 2, 1, 1, 270))
				end
				if i <= 1 or not boardMap[i - 1][j].isUsed then -- 上
					local accWidth = side1
					local widthScale = 1
					if i > 1 and j < #boardMap[i] and boardMap[i - 1][j + 1].isUsed then
						widthScale = (sideH - sideB) / sideH
					end
					self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_edge_long.png", self.baseMap[i][j].pos_x -
						sideH / 2, self.baseMap[i][j].pos_y + sideV / 2, widthScale, 1, 0))
				end
				if j >= #boardMap[i] or not boardMap[i][j + 1].isUsed then -- 右
					local finY = self.baseMap[i][j].pos_y + sideV / 2
					local finHeight = sideV
					if i > 1 and j < #boardMap[i] and boardMap[i - 1][j + 1].isUsed then
					 	finY = finY - sideB
					 	finHeight = sideV - sideB
					end
					if i < #boardMap and j < #boardMap[i] and boardMap[i + 1][j + 1].isUsed then
						finHeight = finHeight - sideB
					end
					local heightScale = finHeight / sideH
					self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_edge_long.png", self.baseMap[i][j].pos_x +
						sideH / 2, finY, heightScale, 1, 90))
				end
				if i >= #boardMap or not boardMap[i + 1][j].isUsed then -- 下
					local finX = self.baseMap[i][j].pos_x + sideH / 2
					local widthScale = 1
					if i < #boardMap and j < #boardMap[i] and boardMap[i + 1][j + 1].isUsed then
						finX = finX - sideB
						widthScale = (sideH - sideB) / sideH
					end
					self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_edge_long.png", finX, self.baseMap[i][j].pos_y -
						sideV / 2,widthScale, 1, 180))
					if boardMap[i][j].isCollector then -- 豆荚收集口标志
						local sprite = Sprite:createWithSpriteFrameName("map_tile_ingr_collect.png")
						sprite:setAnchorPoint(ccp(0.5, 0))
						sprite:setPosition(ccp(self.baseMap[i][j].pos_x, self.baseMap[i][j].pos_y - sideV + GamePlayConfig_Tile_Ingr_CollectorY))
						self.showPanel[ItemSpriteType.kBackground]:addChild(sprite)
					end
				end

				if i <= 1 or j <= 1 or not boardMap[i - 1][j - 1].isUsed then -- 左上
					if (i<= 1 or not boardMap[i - 1][j].isUsed) and (j <= 1 or not boardMap[i][j - 1].isUsed) then
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_corner.png", self.baseMap[i][j].pos_x -
							sideH / 2 - sideB, self.baseMap[i][j].pos_y + sideV / 2, 1, 1, 0))
					end
				end
				if i >= #boardMap or j <= 1 or not boardMap[i + 1][j - 1].isUsed then -- 左下
					if (i >= #boardMap or not boardMap[i + 1][j].isUsed) and (j <= 1 or not boardMap[i][j - 1].isUsed) then
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_corner.png", self.baseMap[i][j].pos_x -
							sideH / 2, self.baseMap[i][j].pos_y - sideH / 2 - sideB, 1, 1, 270))
					end
				end
				if i > 1 and j < #boardMap and boardMap[i - 1][j + 1].isUsed then -- 右上
					if not boardMap[i - 1][j].isUsed then -- 右上偏上凹角
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_in_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2 - 2 * sideB, self.baseMap[i][j].pos_y + sideH / 2 + sideB, 1, 1, 0))
					end
					if not boardMap[i][j + 1].isUsed then -- 右上偏右凹角
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_in_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2 + 2 * sideB, self.baseMap[i][j].pos_y + sideH / 2 - sideB, 1, 1, 180))
					end
				else
					if (i <= 1 or not boardMap[i - 1][j].isUsed) and (j >= #boardMap[i] or not boardMap[i][j + 1].isUsed) then
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2, self.baseMap[i][j].pos_y + sideH / 2 + sideB, 1, 1, 90))
					end
				end
				if i < #boardMap and j < #boardMap[i] and boardMap[i + 1][j + 1].isUsed then -- 右下
					if not boardMap[i + 1][j].isUsed then -- 右下偏下凹角
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_in_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2 - sideB, self.baseMap[i][j].pos_y - sideH / 2 - 2 * sideB, 1, 1, 270))
					end
					if not boardMap[i][j + 1].isUsed then -- 右下偏右凹角
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_in_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2 + sideB, self.baseMap[i][j].pos_y - sideH / 2 + 2 * sideB, 1, 1, 90))
					end
				else
					if (i >= #boardMap or not boardMap[i + 1][j].isUsed) and (j >= #boardMap[i] or not boardMap[i][j + 1].isUsed) then
						self.showPanel[ItemSpriteType.kBackground]:addChild(createSprite("map_tile_corner.png", self.baseMap[i][j].pos_x +
							sideH / 2 + sideB, self.baseMap[i][j].pos_y - sideH / 2, 1, 1, 180))
					end
				end
			end
		end
	end
end

function GameBoardView:resizeToFitScreen(boardMap)
	-- 计算比例
	local winSize = CCDirector:sharedDirector():getWinSize()
	local visibleSize = CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin = CCDirector:sharedDirector():getVisibleOrigin()
	local tWidth, tHeight, bWidth = GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height, GamePlayConfig_Tile_BorderWidth
	local cHeight = GamePlayConfig_Tile_Ingr_Height
	local maxY = GamePlayConfig_Max_Item_Y
	local topHeight = GamePlayConfig_Top_Height * visibleSize.width / GamePlayConfig_Design_Width
	local bottomHeight = GamePlayConfig_Bottom_Height * visibleSize.width / GamePlayConfig_Design_Width
	local scaleX, scaleY = (visibleSize.width - 2 * GamePlayConfig_Tile_PosAddX) / (maxY - 1) / tWidth,
		(visibleSize.height - topHeight - bottomHeight) / (maxY - 1) / tHeight
	if scaleX < scaleY then
		if scaleY > GamePlayConfig_Strengh_Scale * scaleX then scaleY = GamePlayConfig_Strengh_Scale * scaleX end
	else
		if scaleX > GamePlayConfig_Strengh_Scale * scaleY then scaleX = GamePlayConfig_Strengh_Scale * scaleY end
	end
	GamePlayConfig_Tile_ScaleX = scaleX
	GamePlayConfig_Tile_ScaleY = scaleY

	-- 计算位置
	local mapWidth, mapHeight = 0, 0
	local mapLeft, mapDown = 9, 9
	for i = 1, #boardMap do
		for j = 1, #boardMap[i] do
			if boardMap[i][j].isUsed then
				if j > mapWidth then mapWidth = j end
				if j < mapLeft then mapLeft = j end
				if i > mapHeight then mapHeight = i end
				if i < mapDown then mapDown = i end
			end
		end
	end
	mapLeft = mapLeft - 1
	mapWidth = mapWidth - mapLeft
	mapDown = mapDown - 1
	mapHeight = mapHeight - mapDown
	local posX = visibleSize.width / 2 - mapWidth * tWidth * scaleX / 2 - mapLeft * tWidth * scaleX + visibleOrigin.x
	local posY = ((visibleSize.height - topHeight - bottomHeight) / 2 - mapHeight * tHeight * scaleY / 2 - (maxY -
		mapHeight - mapDown - 1) * tHeight * scaleY / 2) / scaleY + visibleOrigin.y + bottomHeight
	self.originPos = ccp(posX, posY)
	self:setPosition(self.originPos)
	self:setScaleX(scaleX)
	self:setScaleY(scaleY)
	self.gameBoardLogic.posAdd = self.originPos
	self.moveCountPos.x = visibleOrigin.x + visibleSize.width - self.moveCountPos.x
	self.moveCountPos.y = visibleOrigin.y + visibleSize.height - self.moveCountPos.y

	return ccp(posX + (mapLeft * tWidth - bWidth) * scaleX, posY + ((maxY - mapHeight - mapDown - 1) * tHeight - bWidth - cHeight) * scaleY),
		(mapWidth * tWidth + 2 * bWidth) * scaleX, (mapHeight * tHeight + 2 * bWidth + cHeight) * scaleY
end

function GameBoardView:viberate()
	self.viberateDelay = GamePlayConfig_Viberate_Delay
	self.viberateCounter = GamePlayConfig_Viberate_Count
end

function GameBoardView:viberateUpdate()
	-- debug.debug()		-- 很多报错会在这里才报出，因此暂时保留一个
	if self.viberateDelay == 0 and self.viberateCounter == -1 then return end

	if self.viberateDelay == 0 then
		if self.viberateCounter == 0 then
			self:setPosition(self.originPos)
			self.viberateCounter = -1
			return
		else
			self.viberateCounter = self.viberateCounter - 1
			local posY = GamePlayConfig_Viberate_InitY * CCDirector:sharedDirector():getWinSize().height / (GamePlayConfig_Viberate_Count - self.viberateCounter)
			local bit = require("bit")
			if bit.band(self.viberateCounter, 0x1) == 0 then posY = -posY end
			self:setPosition(ccp(self.originPos.x, posY + self.originPos.y))
			self.viberateDelay = GamePlayConfig_Viberate_Delay
		end
	else
		self.viberateDelay = self.viberateDelay - 1
	end
end

function GameBoardView:useProp(propID, needConfirm)

	if needConfirm then
		self.gamePropsType = propID
	    self.interactionController:onUseProp(propID)
		self:focusOnItem(nil)
	else
		self.gameBoardLogic:useProps(propID)
	end
end

function GameBoardView:usePropCancelled()
	self.gamePropsType = GamePropsType.kNone
	self.interactionController:onCancelUsingProp()
end

function GameBoardView:animalStartTimeScale()
	for r = 1, #self.gameBoardLogic.gameItemMap do
		for c = 1, #self.gameBoardLogic.gameItemMap[r] do
			local gameItem = self.gameBoardLogic.gameItemMap[r][c]
			if gameItem and gameItem.isUsed and 
				gameItem.ItemType == GameItemType.kAnimal 
				or gameItem.ItemType == GameItemType.kGift 
				or gameItem.ItemType == GameItemType.kCrystal 
				or gameItem.ItemType == GameItemType.kAddMove
				or gameItem.ItemType == GameItemType.kAddTime
				then
				self.baseMap[r][c]:animalStartTimeScale()
			end
		end
	end
end

function GameBoardView:maskWithFewTouch(opacity, holeArray, allow)
	print(allow)
	local wSize = CCDirector:sharedDirector():getWinSize()
	local mask = LayerColor:create()
	local selfPos = self:getPosition()
	local tWidth, tHeight = GamePlayConfig_Tile_Width, GamePlayConfig_Tile_Height
	local scaleX, scaleY = GamePlayConfig_Tile_ScaleX, GamePlayConfig_Tile_ScaleY
	local maxY = GamePlayConfig_Max_Item_Y
	mask:changeWidthAndHeight(wSize.width, wSize.height)
	mask:setColor(ccc3(0, 0, 0))
	mask:setOpacity(opacity)
	mask:setPosition(ccp(0, 0))

	for __, v in ipairs(holeArray) do
		local hole = LayerColor:create()
		hole:changeWidthAndHeight(v.countC * tWidth * scaleX, v.countR * tHeight * scaleY)
		local pos = self.gameBoardLogic:getGameItemPosInView(v.r, v.c)
		hole:setPosition(ccp(pos.x - tWidth * scaleX / 2, pos.y - tHeight * scaleY / 2))
		local blend = ccBlendFunc()
		blend.src = GL_ZERO
		blend.dst = GL_ZERO
		hole:setBlendFunc(blend)
		mask:addChild(hole)
	end

	local layer = CCRenderTexture:create(wSize.width, wSize.height)
	layer:setPosition(ccp(wSize.width / 2, wSize.height / 2))
	layer:begin()
	mask:visit()
	layer:endToLua()
	if __WP8 then layer:saveToCache() end

	mask:dispose()
  
	local obj = CocosObject.new(layer)
	local function onTouchBegin(evt)
		local position = evt.globalPosition
		position.x = position.x - selfPos.x
		position.y = position.y - selfPos.y
		if position.x > (allow.c - 1) * tWidth * scaleX and position.y > (maxY - allow.r - 1) * tHeight * scaleY and
			position.x < ((allow.c - 1) + allow.countC) * tWidth * scaleX and position.y < ((maxY - allow.r - 1) + allow.countR) * tHeight * scaleY then
			return self:onTouchBegan(position.x + selfPos.x, position.y + selfPos.y)
		end
	end
	local function onTouchMove(evt)
		local position = evt.globalPosition
		position.x = position.x - selfPos.x
		position.y = position.y - selfPos.y
		if position.x > (allow.c - 1) * tWidth * scaleX and position.y > (maxY - allow.r - 1) * tHeight * scaleY and
			position.x < ((allow.c - 1) + allow.countC) * tWidth * scaleX and position.y < ((maxY - allow.r - 1) + allow.countR) * tHeight * scaleY then
			return self:onTouchMoved(position.x + selfPos.x, position.y + selfPos.y)
		end
	end
	local function onTouchEnd(evt)
		local position = evt.globalPosition
		position.x = position.x - selfPos.x
		position.y = position.y - selfPos.y
		if position.x > (allow.c - 1) * tWidth * scaleX and position.y > (maxY - allow.r - 1) * tHeight * scaleY and
			position.x < ((allow.c - 1) + allow.countC) * tWidth * scaleX and position.y < ((maxY - allow.r - 1) + allow.countR) * tHeight * scaleY then
			return self:onTouchEnded(position.x + selfPos.x, position.y + selfPos.y)
		end
	end

	local layerSprite = layer:getSprite()

	local trueMaskLayer = Layer:create()
	trueMaskLayer:addChild(obj)
	trueMaskLayer:setTouchEnabled(true, 0, true)
	trueMaskLayer:ad(DisplayEvents.kTouchBegin, onTouchBegin)
	trueMaskLayer:ad(DisplayEvents.kTouchMove, onTouchMove)
	trueMaskLayer:ad(DisplayEvents.kTouchEnd, onTouchEnd)
	trueMaskLayer.setFadeIn = function(maskDelay, maskFade)
		layerSprite:setOpacity(0)
		layerSprite:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(maskDelay), CCFadeIn:create(maskFade)))
	end	

	return trueMaskLayer
end

function GameBoardView:getPositionFromTo(from, to)
	return self.gameBoardLogic:getGameItemPosInView(from.x, from.y), self.gameBoardLogic:getGameItemPosInView(to.x, to.y)
end

function GameBoardView:swapItemView( item1, item2 )
	-- body
	local tempSprite = nil
	local tempType = 0
	if item2.itemSprite[ItemSpriteType.kItem] then
		tempType = ItemSpriteType.kItem
		tempSprite = item2.itemSprite[ItemSpriteType.kItem]
		item2.itemSprite[ItemSpriteType.kItem] = nil
	elseif item2.itemSprite[ItemSpriteType.kItemShow] then
		tempType = ItemSpriteType.kItemShow
		tempSprite = item2.itemSprite[ItemSpriteType.kItemShow]
		item2.itemSprite[ItemSpriteType.kItemShow] = nil
	end

	if (item1.itemSprite[ItemSpriteType.kItem]) then
		item2.itemSprite[ItemSpriteType.kItem] = item1.itemSprite[ItemSpriteType.kItem]
		item1.itemSprite[ItemSpriteType.kItem] = nil
	elseif (item1.itemSprite[ItemSpriteType.kItemShow]) then
		item2.itemSprite[ItemSpriteType.kItemShow] = item1.itemSprite[ItemSpriteType.kItemShow]
		item1.itemSprite[ItemSpriteType.kItemShow] = nil
	end
	item1.itemSprite[tempType] = tempSprite

	local tempItemType = item1.oldData.ItemType
	local tempItemColorType = item1.oldData.ItemColorType
	local tempSpecialType = item1.oldData.ItemSpecialType
	local tempShowType = item1.itemShowType

	item1.oldData.ItemType = item2.oldData.ItemType
	item1.oldData.ItemColorType = item2.oldData.ItemColorType
	item1.oldData.ItemSpecialType = item2.oldData.ItemSpecialType
	item1.itemShowType = item2.itemShowType

	item2.oldData.ItemType = tempItemType
	item2.oldData.ItemColorType = tempItemColorType
	item2.oldData.ItemSpecialType = tempSpecialType
	item2.itemShowType = tempShowType
end
