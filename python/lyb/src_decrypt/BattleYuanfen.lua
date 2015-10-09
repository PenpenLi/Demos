BattleYuanfen = class(Layer);

function BattleYuanfen:ctor()
	self.class = BattleYuanfen;  
end

function BattleYuanfen:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    BattleYuanfen.superclass.dispose(self);
end

function BattleYuanfen:refreshYuanFen()
	if not self.blackLayer then
		self.blackLayer = LayerColorBackGround:getBlackBackGround();
		self.blackLayer:setScale(1.6)
		self.blackLayer:setPositionX(-40)
		self.blackLayer:setAlpha(1)
		self:addChild(self.blackLayer)
	else
		self.blackLayer:setVisible(true)
	end

	self.yuanFenBg = cartoonPlayer("94",0,0,3,nil,2,nil,nil)
	self.yuanFenBg:setAnchorPoint(CCPointMake(0,0));
	self:addChild(self.yuanFenBg)

	self:cardsAction()
end

--GameConfig.STAGE_HEIGHT*0.3
function BattleYuanfen:cardsAction()
	self.imageIcon1 = Image.new()
	self.imageIcon1:loadByArtID(6)
	self.imageIcon1:setScale(0.5)
	self.imageIcon1:setPositionXY(GameConfig.STAGE_WIDTH*0.15,GameConfig.STAGE_HEIGHT);
	self:addChild(self.imageIcon1)

	self.imageIcon2 = Image.new()
	self.imageIcon2:loadByArtID(8)
	self.imageIcon2:setScale(0.5)
	self.imageIcon2:setPositionXY(GameConfig.STAGE_WIDTH*0.65,0);
	self:addChild(self.imageIcon2)

	local function removeYuanfenBg()
		self:removeChild(self.yuanFenBg)
		self.yuanFenBg = nil
		self:removeChild(self.imageIcon1)
		self.imageIcon1 = nil
		self:removeChild(self.imageIcon2)
		self.imageIcon2 = nil
		self.blackLayer:setVisible(false)
	end

	local moveUp1 = CCMoveTo:create(0.3, ccp(GameConfig.STAGE_WIDTH*0.15,GameConfig.STAGE_HEIGHT*0.3));
    local moveEaseOut1 = CCEaseOut:create(moveUp1,0.3);
    local moveUp3 = CCMoveTo:create(0.2, ccp(GameConfig.STAGE_WIDTH*0.15,-self.imageIcon2:getContentSize().height));
    local moveEaseSineIn3 = CCEaseSineIn:create(moveUp3,0.2);
    local array1 = CCArray:create();
    array1:addObject(moveEaseOut1)
    array1:addObject(CCMoveBy:create(1, ccp(0,-70)))
    array1:addObject(moveEaseSineIn3)
	self.imageIcon1:runAction(CCSequence:create(array1))

	local moveUp2 = CCMoveTo:create(0.3, ccp(GameConfig.STAGE_WIDTH*0.65,GameConfig.STAGE_HEIGHT*0.3));
    local moveEaseOut2 = CCEaseOut:create(moveUp2,0.3);
    local moveUp4 = CCMoveTo:create(0.2, ccp(GameConfig.STAGE_WIDTH*0.65,GameConfig.STAGE_HEIGHT));
    local moveEaseSineIn4 = CCEaseSineIn:create(moveUp4,0.2);
    local callBack = CCCallFunc:create(removeYuanfenBg);
    local array2 = CCArray:create();
    array2:addObject(moveEaseOut2)
    array2:addObject(CCMoveBy:create(1, ccp(0,70)))
    array2:addObject(moveEaseSineIn4)
    array2:addObject(callBack)
	self.imageIcon2:runAction(CCSequence:create(array2))
end