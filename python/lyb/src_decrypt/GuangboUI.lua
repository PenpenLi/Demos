
GuangboUI = class(Layer)

function GuangboUI:ctor()
	self.class = GuangboUI
	self.isScrolling = false
end

function GuangboUI:dispose()
  
end

function GuangboUI:dispose4End()
  if self.isDisposed then
   	return;
  end
  if self.timerHandler then
    Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
  end
  if self.guangboText then
  	self.guangboText:stopAllActions();
  end
  self:removeAllEventListeners();
  self:removeChildren();
  GuangboUI.superclass.dispose(self);
  if self.movieClip then
  		self.movieClip:dispose()
  		self.movieClip = nil;
  end
  BitmapCacher:removeUnused();
end

function GuangboUI:init(userProxy)
    self:initLayer();

	self.touchEnabled = false;
	self.touchChildren = false;	


    self.userProxy=userProxy;
    local movieClip = MovieClip.new();
    movieClip:initFromFile("main_ui", "guangboGroup");
	self.movieClip = movieClip;

	self.winsize = Director:sharedDirector():getWinSize()
	-- local layerColor = LayerColor.new();
	-- layerColor:initLayer();
	-- layerColor:changeWidthAndHeight(self.winsize.width,50);
	-- layerColor:setColor(ccc3(0,0,0));
	-- layerColor:setOpacity(175);
	-- layerColor:setPositionXY(0,-layerColor:getContentSize().height)
	-- self:addChild(layerColor)
	
	self.guangbo_bg = movieClip.factory:getBoneTextureDisplay("guangbo_bg");
	self.guangbo_bg:setPositionXY(0,-45)
	self:addChild(self.guangbo_bg)
	--layerColor--
	-- 广播
	self.guangbo_bg.touchEnabled = false;
	self.guangbo_bg.touchChildren = false;	

	self:setPositionXY(0,540 + GameData.uiOffsetY);
	local function timerLoop()
		self:addScene();
		self:playGuangbo();
	end
	self.timerHandler=Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop,0.2,false);
end

function GuangboUI:scrollText()
	if self.guangboText and 0==self.guangboText:numberOfRunningActions() then
		local x=self.guangboText:getPositionX();
		if 0>x then
			x=self.guangboTextWidth+x;
		else
			x=800+self.guangboTextWidth-x;
		end
		local t=15*x/(800+self.guangboTextWidth);
		self.guangboTextWidth = self.guangboText:getContentSize().width
		local sequArr = CCArray:create()
		local moveTo = CCMoveTo:create(t, ccp(0-self.guangboTextWidth,-40))
		local function playComplete()
			self.isScrolling=false;
			self:scrollText();
		end
		sequArr:addObject(moveTo);
		sequArr:addObject(CCCallFunc:create(playComplete));
		self.guangboText:runAction(CCSequence:create(sequArr))
	end
	if self.isScrolling then
		return;
	end
	if 0==table.getn(self.userProxy.guangboData) then
		self:dispatchEvent(Event.new("REMOVE_GUANGBO",nil,self));
		self:dispose4End();
		return;
	end
	self.isScrolling = true;

	local text_name = self.userProxy.guangboData[1]
	if self.guangboText then
		self:removeChild(self.guangboText);
		self.guangboText = nil
	end
	-- text_name = '<content><font color="#00FF00">进入</font><font color="#FF0000">游戏</font></content>'
	self.guangboText = MultiColoredLabel.new(text_name, "fonts/Microsoft YaHei.ttf", 24);

	self.guangboText:setPositionXY(self.winsize.width,-40)
	self.guangboText.touchEnabled = false;
	self.guangboText.touchChildren = false;
	self:addChild(self.guangboText);

	self.guangboTextWidth = self.guangboText:getContentSize().width

	local sequArr = CCArray:create()
	local moveTo = CCMoveTo:create(15, ccp(0-self.guangboTextWidth,-40))
	local function playComplete()
		self.isScrolling=false;
		self:scrollText();
	end
	sequArr:addObject(moveTo);
	sequArr:addObject(CCCallFunc:create(playComplete));
	self.guangboText:runAction(CCSequence:create(sequArr))
	table.remove(self.userProxy.guangboData,1)
end 

-- 播广播
function GuangboUI:playGuangbo()
    --print(content)
	self.guangbo_bg:setVisible(true)
	
	if self.userProxy.guangboData then
		local oldLength = table.getn(self.userProxy.guangboData)
		table.insert(self.userProxy.guangboData,oldLength + 1,content)
	else
		self.userProxy.guangboData = {}
		self.userProxy.guangboData[1] = content
	end
	
	local guangboTextWidth
	if self.isScrolling == false then
		local text_name = self.userProxy.guangboData[1]
		text_name = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
		self.guangboText = MultiColoredLabel.new(text_name, "fonts/Microsoft YaHei.ttf", 24);
		self.guangboText:setPositionXY(800, 9)
		self.guangboText.touchEnabled = false;
		self.guangboText.touchChildren = false;
		self:addChild(self.guangboText);
		self.guangboTextWidth = self.guangboText:getContentSize().width
	end
	
	if self.isScrolling == false then
		self:setPositionXY(0, self.winsize.height - 46)
		self:addScene();
		self:scrollText()
	end
	if self:getParent4u() then
		self:scrollText();
	end
end

function GuangboUI:addScene()
	local parent=self.parent;
	local parent4u=self:getParent4u();
    --if  self.parent then
          --self.parent:removeChild(self,false);
    --end
	
	if not parent4u then
	  if self.guangboText then
  		self.guangboText:stopAllActions();
  		self:removeChild(self.guangboText);
		self.guangboText=nil;
		self.isScrolling=false;
		table.remove(self.userProxy.guangboData,1)
  	  end
  	  return;
	end
	if parent==parent4u then
		return;
	end
	if parent then
		parent:removeChild(self,false);
	end
	parent4u:addChild(self);
	self:scrollText();
end

function GuangboUI:getParent4u()
	-- local scene = Director.sharedDirector():getRunningScene();
	-- local parent4u=nil;
	-- if scene then
	-- 	if scene.name == GameConfig.MAIN_SCENE then
	-- 		if sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS) then
	-- 			parent4u=sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS);
	-- 		end
	-- 	elseif scene.name == GameConfig.BATTLE_SCENE then
	-- 		if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN) then
	-- 			parent4u=sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN);
	-- 		end
	-- 	else
	-- 		parent4u=scene;
	-- 	end
	-- end
	-- return parent4u;
	return sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS);
end