BattleBossAttackArea = class(Layer);

function BattleBossAttackArea:ctor()
	self.class = BattleBossAttackArea;  
end

function BattleBossAttackArea:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    BattleBossAttackArea.superclass.dispose(self);
end

function BattleBossAttackArea:refreshArea(faceDirect,realKey,guildeTime)
	local data = BattleData.screenSkillArray[realKey];
	if not data.attackShape or data.attackShape == 0 then return; end
	local attackShape = analysis("Jineng_Jinengfanweileixing",data.attackShape);
	local imageId = attackShape.BOSSXZID;
	local pointX = attackShape.cxlx == 3 and 0.5 or 0;
	local scaleXNum = 1;
	local scaleYNum = 1;
	local skewN = -GameConfig.BG_XY_R;
	if self.areaImg then
		self.areaImg:setRotation(faceDirect and 180 or 0);
		self:PlayAction(guildeTime);
		return;
	end
	self.areaImg = Image.new();
	self.areaImg:load(artData[imageId].source);
	self.areaTmp = Sprite.new(CCSprite:create());
	-- self.testImg = Image.new();
	-- self.testImg:load(artData[188].source);
	local imgH = self.areaImg:getContentSize().height;
	local imgW = self.areaImg:getContentSize().width;
	if attackShape.cxlx == 2 then--扇形
		scaleXNum = data.attackDistance/imgW;
		scaleYNum = data.attackDistance*BattleConfig.BG_YK/imgW;
	elseif attackShape.cxlx == 3 then--圆形
		scaleXNum = data.attackDistance*2/imgW;
		scaleYNum = data.attackDistance*2*BattleConfig.BG_YK/imgW;
	else--菱形
		scaleXNum = data.attackDistance/imgW;
		scaleYNum = data.attackRange*2*BattleConfig.BG_YK/imgH;
	end
	self.areaImg:setAnchorPoint(CCPointMake(pointX,0.5));
	self.areaImg:setRotation(faceDirect and 180 or 0);
	self.areaImg:setOpacity(0);
	self.areaImg:setScaleX(scaleXNum);
	self.areaImg:setScaleY(scaleYNum);
	self.areaTmp:addChild(self.areaImg);
	self.areaTmp:setSkewX(skewN);
	self:addChild(self.areaTmp);

	self.bodyEffect = cartoonPlayer("366",0, 0, 0, nil, 2);
	self.bodyEffect:setAnchorPoint(CCPointMake(0.5,0.1))
	self:addChild(self.bodyEffect)
	self:PlayAction(guildeTime);
end

function BattleBossAttackArea:PlayAction(guildeTime)
	self.areaTmp:setVisible(true)
	self.bodyEffect:setVisible(true)
	local function backFun()
		-- if not isGuilde then
			self.areaTmp:setVisible(false)
			self.bodyEffect:setVisible(false)
		-- end
	end
	local fadeTo1 = CCFadeTo:create(0.15,255)
	local callBack = CCCallFunc:create(backFun);
	local delay = CCDelayTime:create(guildeTime/1000);
	local fadeTo2 = CCFadeTo:create(0.15,0)
	local array = CCArray:create();
	array:addObject(fadeTo1);
	array:addObject(delay);
	-- if not isGuilde then
		array:addObject(fadeTo2);
	-- end
	array:addObject(callBack);
	self.areaImg:runAction(CCSequence:create(array))
end

function BattleBossAttackArea:removeAreaImg()
	if self.areaImg and self.areaImg.sprite then
		self:removeChild(self.areaImg)
		self.areaImg = nil
	end
end