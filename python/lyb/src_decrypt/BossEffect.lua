BossEffect = {};

function BossEffect:playBossEffect()
	--local boneCartoon = BoneCartoon.new()
	--local function callBack()
    --    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(boneCartoon)
    --end
	--boneCartoon:create("1053",1,callBack);
	--boneCartoon:setPositionXY(0,GameConfig.STAGE_HEIGHT)
    --sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(boneCartoon);
    local boneCartoon1 = BoneCartoon.new()
    local function callBack1()
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(boneCartoon1)
    end
	boneCartoon1:create("1054",1,callBack1);
	boneCartoon1:setPositionXY(GameConfig.STAGE_WIDTH*0.5,GameConfig.STAGE_HEIGHT*0.5)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(boneCartoon1);
    MusicUtils:playEffect(78,false);
end


--[[function BossEffect:playBossEffect1()

	if self.bossEffect then
		return;
	end
	
	local function removeCartoonPlayer()
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(self.bossEffect); 
        self.bossEffect = nil;
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(self.bossEffect2); 
        self.bossEffect2 = nil;
        self.bg:stopAllActions();
        self.bg:setVisible(false);

        self.ji1:setVisible(false);
        self.ji2:setVisible(false);
        self.wz1:setVisible(false);
        self.wz2:setVisible(false);
    end
    if not self.bg then
    	self.bg = makeScale9Sprite("95");
   		self.bg:setContentSize(CCSizeMake(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 
    	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.bg);
    	self.ji1 = Sprite.new(CCSprite:create(artData[99].source));
    	
		self.ji1:setScale(2);
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.ji1);

		self.ji2 = Sprite.new(CCSprite:create(artData[99].source));
		self.ji2:setScale(2);
		self.ji2.sprite:setFlipX(true);
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.ji2);

		self.wz2 = Sprite.new(CCSprite:create(artData[97].source));
		self.wz2:setPositionXY(GameConfig.STAGE_WIDTH*0.5,GameConfig.STAGE_HEIGHT*0.5);
		self.wz2:setAnchorPoint(ccp(0.5,0.5));
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.wz2);

		self.wz1 = Sprite.new(CCSprite:create(artData[97].source));
		self.wz1:setPositionXY(GameConfig.STAGE_WIDTH*0.5,GameConfig.STAGE_HEIGHT*0.5);
		self.wz1:setAnchorPoint(ccp(0.5,0.5));
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.wz1);
		local blF = ccBlendFunc();
		blF.src = 1;
		blF.dst = 1;
		self.wz1:setBlendFunc(blF);
	end
	if not self.ji1.sprite then return end
	self.ji1:setVisible(true);
    self.ji2:setVisible(true);
    self.wz1:setVisible(true);
    self.wz2:setVisible(true);
	self.bg:setVisible(true);
	local viewSize = self.ji1:getContentSize();
	local blink = CCBlink:create(1, 1); 
	local repeatForever = CCRepeatForever:create(blink);
	self.bg:runAction(repeatForever);

	self.ji1:setPositionXY(0,0);
	self.ji1:setPositionXY(-200,GameConfig.STAGE_HEIGHT*0.7);
	Tweenlite:to(self.ji1,1,200,0,255,nil,true,EaseType.CCEaseElasticOut);
	self.ji2:setPositionXY(0,0);
	self.ji2:setPositionXY(GameConfig.STAGE_WIDTH-viewSize.width*2+200,GameConfig.STAGE_HEIGHT*0.3-viewSize.height*2);
	Tweenlite:to(self.ji2,1,-200,0,255,nil,true,EaseType.CCEaseElasticOut);


	self.bossEffect = cartoonPlayer("96_1001",ccp(0,0),nil,nil,1,nil,nil);
	self.bossEffect:setPositionXY(600,GameConfig.STAGE_HEIGHT*0.7+150);
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.bossEffect)
	self.bossEffect.sprite:setFlipX(true);
	self.bossEffect:setVisible(true);
	self.bossEffect:setScale(2);

	
	self.bossEffect2 = cartoonPlayer("96_1001",ccp(0,0),nil,nil,1,nil,nil);
	self.bossEffect2:setPositionXY(GameConfig.STAGE_WIDTH-600,GameConfig.STAGE_HEIGHT*0.3);
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(self.bossEffect2)
	self.bossEffect2:setVisible(true);
	self.bossEffect2:setScale(2);
	self.wz1:setOpacity(0);
	local times = 1;
	local wz1 = self.wz1;
	local function rep()
		self.wz1:setScale(1,true);
		self.wz1:setOpacity(0);
		self.wz1:setOpacity(255);
		times = times+1;
		if times<4 then
			Tweenlite:scale(wz1,0.8,2,2,0,rep);
		else
			removeCartoonPlayer();
		end
	end
	self.wz2:setScale(3,true);
	self.wz2:setOpacity(1);
	self.wz2:setOpacity(0);
	Tweenlite:scale(self.wz2,0.3,1,1,255);
	Tweenlite:delayCall(self.wz1,0.5,rep);
end]]

