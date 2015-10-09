BattleHeroAttackArea = class(Layer);

function BattleHeroAttackArea:ctor()
	self.class = BattleHeroAttackArea;  
end

function BattleHeroAttackArea:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    BattleHeroAttackArea.superclass.dispose(self);
end

function BattleHeroAttackArea:initArea(roleVO,skillId)
	if not self.areaTmp then
		local  realKey = "key".. analysis("Jineng_Jineng",skillId,"editorid");
		local data = BattleData.screenSkillArray[realKey];
		if not data.attackShape or data.attackShape == 0 then return; end
		local attackShape = analysis("Jineng_Jinengfanweileixing",data.attackShape);
		local imageId = attackShape.xzid;
		local pointX = attackShape.cxlx == 3 and 0.5 or 0;
		local scaleXNum = 1;
		local scaleYNum = 1;
		local skewN = -GameConfig.BG_XY_R;
		self.areaImg = Image.new();
		self.areaImg:load(artData[imageId].source);
		self.areaTmp = Sprite.new(CCSprite:create());
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
		self.areaImg:setOpacity(0);
		self.areaImg:setScaleX(scaleXNum);
		self.areaImg:setScaleY(scaleYNum);
		self.areaImg:setRotation(roleVO.faceDirect and 180 or 0);
		self.areaTmp:addChild(self.areaImg);
		self.areaTmp:setSkewX(skewN);
		self:addChild(self.areaTmp);
	end
	self:PlayAction();
end

function BattleHeroAttackArea:PlayAction()
	self.areaTmp:setVisible(true)
	self.areaImg:runAction(CCFadeTo:create(0.15,255))
end

function BattleHeroAttackArea:setAreaVisible(bool,faceDirect)
	if not self.areaImg then return end
	if self.areaImg and not self.areaImg.sprite then return end
	local function backFun()
		self.areaTmp:setVisible(false)
	end
	if self.areaImg then
		-- self.areaImg:setRotation(faceDirect and 180 or 0);
		local callBack = CCCallFunc:create(backFun);
		local fadeTo2 = CCFadeTo:create(0.15,0)
		local array = CCArray:create();
		array:addObject(fadeTo2);
		array:addObject(callBack);
		self.areaImg:runAction(CCSequence:create(array))
	end
end