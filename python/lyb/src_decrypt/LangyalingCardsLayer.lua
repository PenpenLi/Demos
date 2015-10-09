-- 琅琊令出卡
require "main.view.battleScene.function.ScreenShake"

LangyalingCardsLayer=class(ScaleLayer);

local _heroSkeleton
-- 点击类型
local _clickType
local _buyCount

function LangyalingCardsLayer:ctor(popUp)
	self.class = LangyalingCardsLayer;
	self.placeNum1 = 5
	self.placeNum2 = 2
	self.placeNum3 = 1.25
	self.popCardTime = 0.3
	self.addListItemArray = {}
	self.addRightItemArray = {}
	self.littleCardScale = 1

	self.popUp = popUp
	_clickType = popUp.clickType
	_buyCount = popUp.buyCount
	self.isPopupLayer = false
	self.oneClickTurnCardTable = {}
end

function LangyalingCardsLayer:dispose()
	if self.disPoseArmature then
		self.disPoseArmature:dispose()
		self.disPoseArmature = nil
	end
	self:removeAction1Timer()
	self:removeBoneTimer()
	self:removeAllEventListeners();
	self:removeChildren();
	LangyalingCardsLayer.superclass.dispose(self);
	self.popUp = nil
end

-- 弹选中部分
function LangyalingCardsLayer:pop_Click_Layer()
	local winSize = Director:sharedDirector():getWinSize()
	local backImage = Image.new()
	backImage:loadByArtID(StaticArtsConfig.LOADING_UI)
	backImage:setScaleX(0)
	backImage:setScaleY(1)
	backImage:setAnchorPoint(CCPointMake(0.5,0.5))
	backImage:setPositionXY(winSize.width / 2 - GameData.uiOffsetX,winSize.height / 2 - GameData.uiOffsetY)
	self:addChild(backImage)
	self.backImage = backImage
    self:changeAnchorPoint(GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2)
	local scaleY = 0
	local function action1TimerFun()
		scaleY = scaleY + 0.15
		backImage:setScaleX(scaleY)
		if scaleY >= 1 then
			backImage:setScaleX(1)
	        self:removeAction1Timer()
	        self:popClickLayer1()
        end
  	end
  	self.action1Timer = Director:sharedDirector():getScheduler():scheduleScriptFunc(action1TimerFun, 0, false)
end

-- 清空动画飞出来的东西
function LangyalingCardsLayer:cleanUI()
	
	self.oneClickTurnCardTable = {}

	if self.needCleanUI then
		self.needCleanUI:removeChildren()
	end

	if self.needCleanUI2 then
		self.needCleanUI2:removeChildren()
	end	
	
	self.goonButton:setVisible(false)
	-- self.oneClickButton:setVisible(false)
	self.hasClickedOneClick = false
	
	self.decText:setVisible(false)
	self.itemImage:setVisible(false)

end

--先缓存,防动画时卡
function LangyalingCardsLayer:popClickLayer(cardArray)

	local _length = 0
	local _cacheCardArr = {}
	for k,v in pairs(cardArray) do
		if v.isCard == 1 then
			_length = _length + 1
			_cacheCardArr[_length] = v
		end
	end
	local _number = 1;
	local function action1TimerFun()
		local data = _cacheCardArr[_number]
		if not data then return end
		-- local str = 1 == data.IsMainGeneral and "art1" or "art1d";
		if data.ConfigId then
			local artID = analysis("Kapai_Kapaiku",data.ConfigId,"art1d")
			BitmapCacher:cacheImage(artData[artID].source);
		end
		_number = _number + 1
		if _number > _length then
			self:removeAction1Timer()
			self:startPop(cardArray)
		end
  	end
  	
  	if _length == 0 then
		self:startPop(cardArray)
  	else
		self.action1Timer = Director:sharedDirector():getScheduler():scheduleScriptFunc(action1TimerFun, 0, false)
  	end

end

function LangyalingCardsLayer:startPop(cardArray)
	if self.itemArr then
		self.itemArr = cardArray

		self:cleanUI()

		local length = table.getn(self.itemArr)
		if length == 1 then
			local function _callBack()
				self.isPopupLayer = false
				self.closeButton2:addEventListener(Events.kStart, self.onUIClose, self);
				self.goonButton:setVisible(true)
				self.decText:setVisible(true)
				self.itemImage:setVisible(true)					
			end
			self:playCartoon1(1,self.itemArr[1],1,_callBack)
		elseif length == 10 or length == 11 then
			self:playCartoon11()
		end
		self:refreshCurrency()
	else
		self.itemArr = cardArray
		self:initCachCard()
		self:pop_Click_Layer()
	end
end

--得到卡
local function _getHeroCard(data)
	local returnLayer = Layer.new()
	returnLayer:initLayer()
	local scaleSlot = HeroProScaleSlot.new();
	scaleSlot:initialize(_heroSkeleton, data, makePoint(0,0));
	scaleSlot:getCard():setScale(0.165)

	local winSize = Director:sharedDirector():getWinSize()
	returnLayer:setContentSize(makeSize(winSize.width,winSize.height))
	returnLayer:setPositionXY(-1 * winSize.width / 2 ,-1 * winSize.height / 2)
	scaleSlot:addChildAt(returnLayer,1)

	return scaleSlot
end

--缓存卡
function LangyalingCardsLayer:initCachCard()
	require "main.view.hero.heroPro.ui.HeroProScaleSlot";
	_heroSkeleton = getSkeletonByName("hero_ui");
	-- BitmapCacher:cacheImage(artData[373].source);
	-- BitmapCacher:cacheImage(artData[374].source);
	-- BitmapCacher:cacheImage(artData[1159].source);

	-- _getHeroCard(tempData)
end

--构建UI
function LangyalingCardsLayer:popClickLayer1()
	local armature = self.popUp.skeleton:buildArmature("cards_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();	
	self.disPoseArmature = armature
	self.cardsUIDisplay = armature.display
	self:addChild(armature.display)

	self.closeButton2 = Button.new(armature:findChildArmature("common_close_button"), false);
	local buttonPos = self.closeButton2:getPosition()
	self.closeButton2:setPositionXY(buttonPos.x,buttonPos.y + GameData.uiOffsetY)

    local movieClip6 = MovieClip.new();
    movieClip6:initFromFile("langyaling_ui", "gold_tips");
    movieClip6:gotoAndPlay("f1");
    movieClip6:update();
    self.goldLayer = Layer.new()
    self.goldLayer:initLayer()
    self.goldLayer:addChild(movieClip6.layer)

    local text_data_2 = movieClip6.armature:getBone("wanfanDes").textData;
    self.desGoldText = createTextFieldWithTextData(text_data_2,"");
    self.goldLayer:addChild(self.desGoldText);
    self:addChild(self.goldLayer)
	
	local gold_ui = armature.animation.armature:getBone("gold_ui"):getDisplay();    
	self.goldLayer:setPositionXY(gold_ui:getPositionX(),gold_ui:getPositionY() - 60)
	self.goldLayer:setVisible(false)

    local movieClip7 = MovieClip.new();
    movieClip7:initFromFile("langyaling_ui", "sliver_tips");
    movieClip7:gotoAndPlay("f1");
    movieClip7:update();
    self.sliverLayer = Layer.new()
    self.sliverLayer:initLayer()
    self.sliverLayer:addChild(movieClip7.layer)

    local text_data_2 = movieClip7.armature:getBone("wanfanDes").textData;
    self.desSliverText = createTextFieldWithTextData(text_data_2,"");
    self.sliverLayer:addChild(self.desSliverText);
    self:addChild(self.sliverLayer)
	
	local sliver_ui = armature.animation.armature:getBone("sliver_ui"):getDisplay();    
	self.sliverLayer:setPositionXY(sliver_ui:getPositionX(),sliver_ui:getPositionY() - 60)
	self.sliverLayer:setVisible(false)	

	self:addEventListener(DisplayEvents.kTouchBegin,self.onClickUI,self);

	-- 货币
	local huobiGroupBone = armature:findChildArmature("huobiGroup")
	local huobiGroupDO = armature.animation.armature:getBone("huobiGroup"):getDisplay()
	local huobiPos = huobiGroupDO:getPosition()
	huobiGroupDO:setPositionXY(huobiPos.x,huobiPos.y + GameData.uiOffsetY)

	local yinliangTextBone = huobiGroupBone:getBone("yinliangText")
	local yuanbaoTextBone = huobiGroupBone:getBone("yuanbaoText")
	local yingxionglingTextBone = huobiGroupBone:getBone("yingxionglingText")
	local langyalingTextBone = huobiGroupBone:getBone("langyalingText")
	local yingxionglingImageDO = huobiGroupBone:getBone("yingxionglingImage"):getDisplay()
	local langyalingImageDO = huobiGroupBone:getBone("langyalingImage"):getDisplay()

	local common_add_bg1DO = huobiGroupBone:getBone("common_add_bg1"):getDisplay()
	local common_add_bg2DO = huobiGroupBone:getBone("common_add_bg2"):getDisplay()
	local bantou_bg1DO = huobiGroupBone:getBone("bantou_bg1"):getDisplay()
	local bantou_bg2DO = huobiGroupBone:getBone("bantou_bg2"):getDisplay()		

	common_add_bg1DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBg1,self);
	common_add_bg2DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBg2,self);
	bantou_bg1DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBantouBg1,self);
	bantou_bg2DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBantouBg2,self);

	self.yinliangText = createTextFieldWithTextData(yinliangTextBone.textData,"")
	self.yuanbaoText = createTextFieldWithTextData(yuanbaoTextBone.textData,"")
	self.yinliangText.touchEnabled = false
	self.yuanbaoText.touchEnabled = false
	self.yingxionglingText = createTextFieldWithTextData(yingxionglingTextBone.textData,self.popUp.bagProxy:getItemNum(1009002).."")
	self.langyalingText = createTextFieldWithTextData(langyalingTextBone.textData,self.popUp.bagProxy:getItemNum(1009001).."")

	local yingxionglingImage = Image.new()
	yingxionglingImage:loadByArtID(StaticArtsConfig.IMAGE_YINGXIONGLING)
	yingxionglingImage:setPosition(yingxionglingImageDO:getPosition())
	yingxionglingImage:setScale(0.6)

	local langyalingImage = Image.new()
	langyalingImage:loadByArtID(StaticArtsConfig.IMAGE_LANGYANLING)
	langyalingImage:setPosition(langyalingImageDO:getPosition())
	langyalingImage:setScale(0.5)

	huobiGroupDO:addChild(self.yinliangText)
	huobiGroupDO:addChild(self.yuanbaoText)
	huobiGroupDO:addChild(self.yingxionglingText)
	huobiGroupDO:addChild(self.langyalingText)
	huobiGroupDO:addChild(yingxionglingImage)
	huobiGroupDO:addChild(langyalingImage)

	local _buttonText
	local _imageID
	local _text
	local _scaleRate = 1
	if _clickType == 1 then
		_scaleRate = 0.6
		_imageID = StaticArtsConfig.IMAGE_YINGXIONGLING
		if _buyCount == 1 then
			_buttonText = "再召一次"
			_text = "消耗          x1"
		else
			_buttonText = "再召十次"
			_text = "消耗           x10"
		end
	else
		_scaleRate = 0.55
		_imageID = StaticArtsConfig.IMAGE_LANGYANLING
		if _buyCount == 1 then
			_buttonText = "再召一次"
			_text = "消耗          x1"
		else
			_buttonText = "再召十次"
			_text = "消耗           x10"
		end		
	end

	-- 
    self.goonButton = Button.new(armature:findChildArmature("common_red_button"),false,_buttonText,true);
    self.goonButton:addEventListener(Events.kStart,self.onGoonRoll,self);
    self.goonButton.buttonId = 1

    -- self.oneClickButton = Button.new(armature:findChildArmature("one_click_button"),false,"一键翻牌",true);
    -- self.oneClickButton:addEventListener(Events.kStart,self.oneClick,self);    
  

    local textBone = armature.animation.armature:getBone("cost_text")
    local imageBone = armature.animation.armature:getBone("itemImage")
	self.decText = createTextFieldWithTextData(textBone.textData,_text)
	self.decText:setPosition(textBone:getDisplay():getPosition())

	self.itemImage = Image.new()
	self.itemImage:loadByArtID(_imageID)
	self.itemImage:setPosition(imageBone:getDisplay():getPosition())
	self.itemImage:setScale(_scaleRate)

	self:addChild(self.decText)
	self:addChild(self.itemImage)

	self.goonButton:setVisible(false)
	-- self.oneClickButton:setVisible(false)

	self.decText:setVisible(false)
	self.itemImage:setVisible(false)

	self.needCleanUI = Layer.new()
	self.needCleanUI:initLayer()
	self:addChild(self.needCleanUI)

	self.needCleanUI2 = Layer.new()
	self.needCleanUI2:initLayer()
	self:addChild(self.needCleanUI2)	

	local length = table.getn(self.itemArr)
	if length == 1 then
		local function _callBack()
			self.isPopupLayer = false
			self.closeButton2:addEventListener(Events.kStart, self.onUIClose, self);
			self.goonButton:setVisible(true)
			-- self.oneClickButton:setVisible(true)
			-- self.goonButton:setLable("一键翻牌")
			
			self.decText:setVisible(true)
			self.itemImage:setVisible(true)					
		end
		self:playCartoon1(1,self.itemArr[1],1,_callBack)
	elseif length == 10 or length == 11 then
		self:playCartoon11()
	end

	self:refreshCurrency()
end

--继续抽
function LangyalingCardsLayer:onGoonRoll()
	self.cartoon1 = nil
	if self.goonButton.buttonId == 1 then
		if _clickType == 1 then
			if _buyCount == 1 then
				self.popUp:onClickYinbiOneButton()
			else
				self.popUp:onClickYinbiTenButton()
			end
		else
			if _buyCount == 1 then
				self.popUp:onClickJinbiOneButton()
			else
				self.popUp:onClickJinbiTenButton()
			end
		end
	else
		self:oneClick()
	end
end

--得到道具
local function _getItemDO(data)

	local itemLayer = Layer.new()
	itemLayer:initLayer()
	local common_grid=CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
	itemLayer:addChild(common_grid)
	local common_mingzi_bg=CommonSkeleton:getBoneTextureDisplay("commonImages/common_mingzi_bg_2");
	-- common_mingzi_bg:setScale(1.5)
	common_mingzi_bg:setPositionXY(-35,-30)
	itemLayer:addChild(common_mingzi_bg)

	local itemImage = Image.new()
	itemImage:loadByArtID(data["art"])


	if data["functionID"] == 20 then
        local clipper = ClippingNodeMask.new(CommonSkeleton:getBoneTextureDisplay("commonImages/linghunshi_mask"));
	    clipper:setAlphaThreshold(0);
	    clipper:setPositionXY(5,8)
	    itemLayer:addChild(clipper);

    	itemImage:setPositionXY(3,0)

    	clipper:addChild(itemImage);
    	-- clipper:setContentSize(itemImage:getContentSize());

		local mask = CommonSkeleton:getBoneTextureDisplay("commonImages/linghunshi_fg");
		mask:setPositionXY(5,8)
		itemLayer:addChild(mask);
	else
		itemImage:setPositionXY(8,8)
		itemLayer:addChild(itemImage)
	end

	local frameBg=CommonSkeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_" .. data["color"]);
	itemLayer:addChild(frameBg);
	itemLayer:setContentSize(makeSize(120,120));

	if data["count"] ~= 1 then
		local textFieldCount = TextField.new(CCLabelTTF:create(data["count"],GameConfig.DEFAULT_FONT_NAME,20));
		textFieldCount:setPositionXY(95 - textFieldCount:getContentSize().width,10)
		itemLayer:addChild(textFieldCount)
	end

	local textFieldName = TextField.new(CCLabelTTF:create(data["name"],GameConfig.DEFAULT_FONT_NAME,24));

	textFieldName:setPositionXY(54 - textFieldName:getContentSize().width / 2,-28)
	itemLayer:addChild(textFieldName)

	return itemLayer

end

function LangyalingCardsLayer:boneLightBack3(cartoonType,cardTable,callBackFunc)

	local _positionX,_positionY = GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2
	local _selfUI = self.needCleanUI;
	local _selfUI2 = self.needCleanUI2;

	_selfUI2:removeChildren()
	
	local index = cardTable.index	
	local cardBackImage = cardTable.cardBackImage
	-- local cardBackImage1 = cardTable.cardBackImage1

	-- 一次抽
	if cartoonType == 1 then
		
	elseif cartoonType == 2 then -- 10连抽
		if index <= 5 then -- 第一行
			_positionX,_positionY = 250 + (index - 1) * 193,520
		else -- 第二行
			_positionX,_positionY = 250 + (index - 6) * 193,270
		end
	end

	local itemTable = self.itemArr[index]

	local function _boneLightBack2()

		local actionArr1 = CCArray.create()
		local actionArr2 = CCArray.create()

		if itemTable["isCard"] == 1 then --卡牌
			-- 太阳
			local _boneCartoon3 = BoneCartoon.new()
			_boneCartoon3:create(StaticArtsConfig.BONE_EFFECT_373,0);
			_boneCartoon3:setMyBlendFunc()
			_boneCartoon3:setPositionXY(GameConfig.STAGE_WIDTH / 2,GameConfig.STAGE_HEIGHT / 2)
			_selfUI2:addChild(_boneCartoon3);

			local _cardUI = _getHeroCard(itemTable)
			_cardUI:setScale(0.25)
			_cardUI:setPositionXY(_positionX,_positionY)
			_selfUI2:addChild(_cardUI);

			local function _callBackFunc()

				local onclickTouchLayerTimer
				local function _onclickTouchLayer()
					
					_selfUI2:removeChild(_boneCartoon3)

					Director:sharedDirector():getScheduler():unscheduleScriptEntry(onclickTouchLayerTimer);
					onclickTouchLayerTimer = nil

					if GameVar.tutorStage == TutorConfig.STAGE_1003 then
				    	openTutorUI({x=1198, y=641 + GameData.uiOffsetY, width = 80, height = 80, alpha = 125});
				    end
					local function _callBackFunc1()
						_selfUI2:removeChild(_cardUI);
						
						if itemTable["art"] then
							local _itemUI = _getItemDO(itemTable)
							_itemUI:setPositionXY(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)

							local itemData = BagItem.new();
							itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
							_itemUI:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  

							_selfUI:addChild(_itemUI)					
						else
							local heroRoundPortrait = HeroRoundPortrait.new();
							heroRoundPortrait:initialize(itemTable,false);
							heroRoundPortrait:showName4Langyaling();
							heroRoundPortrait:setPositionXY(_positionX - heroRoundPortrait:getContentSize().width / 2,_positionY - heroRoundPortrait:getContentSize().height / 2);
							_selfUI:addChild(heroRoundPortrait);

							-- local itemData = BagItem.new();
							-- itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
							local itemData = {heroItemTable = itemTable,positionX = _positionX,positionY = _positionY}
							heroRoundPortrait:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  								
						end

						local cartoon1
						local function removeCartoon1()
							_selfUI:removeChild(cartoon1);
						end
						cartoon1 = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_1159,_positionX - 145,_positionY + 140,1,removeCartoon1,nil,nil,true)
						_selfUI:addChild(cartoon1);

					end

					local actionArr3 = CCArray.create()
					local actionArr4 = CCArray.create()
					actionArr3:addObject(CCScaleTo:create(0.1,0.25,0.25))
					actionArr3:addObject(CCRotateBy:create(0.1 , 360))
					actionArr3:addObject(CCMoveTo:create(0.1, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
					actionArr4:addObject(CCSpawn:create(actionArr3))
					actionArr4:addObject(CCCallFunc:create(_callBackFunc1))
					_cardUI:runAction(CCSequence:create(actionArr4))

					if callBackFunc then
						callBackFunc()
					end

				end

				-- _touchLayer:addEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)
				onclickTouchLayerTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(_onclickTouchLayer, 1, false)
			end

			actionArr2:addObject(CCScaleTo:create(0.15,4,4))
			actionArr2:addObject(CCRotateBy:create(0.15 , 360))
			actionArr2:addObject(CCMoveTo:create(0.15, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
			actionArr1:addObject(CCSpawn:create(actionArr2))
			actionArr1:addObject(CCCallFunc:create(_callBackFunc))
			_cardUI:runAction(CCSequence:create(actionArr1))

		else -- 道具

			local _itemUI = _getItemDO(itemTable)
			local function _callBackFunc2()
				if callBackFunc and cartoonType == 1 then
					callBackFunc()
				end
			end
			_itemUI:setAnchorPoint(CCPointMake(0.5, 0.5))
			_itemUI:setScale(0.25)
			_itemUI:setPositionXY(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)
			_selfUI:addChild(_itemUI)

			local itemData = BagItem.new();
			itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
			_itemUI:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  																			

			actionArr2:addObject(CCScaleTo:create(0.1,1,1))
			actionArr2:addObject(CCMoveTo:create(0.1, ccp(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)))
			actionArr1:addObject(CCSpawn:create(actionArr2))
			actionArr1:addObject(CCCallFunc:create(_callBackFunc2))
			_itemUI:runAction(CCSequence:create(actionArr1))

			local cartoon1
			local function removeCartoon1()
				_selfUI:removeChild(cartoon1);
			end
			cartoon1 = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_1159,_positionX - 145,_positionY + 140,1,removeCartoon1,nil,nil,true)
			_selfUI:addChild(cartoon1);
		end
	end

	local function _boneLightBack4()
		cardBackImage:setVisible(false)
		-- cardBackImage1:setVisible(false)

		_boneLightBack2()
	end

	-- cardBackImage1:setVisible(true)
	ScreenShake:generalShake(cardBackImage,5,5,3,3)

	Tweenlite:CardFlipHalf(cardBackImage,0.5,_boneLightBack4)
end

function LangyalingCardsLayer:oneClick()

	self.hasClickedOneClick = true
	self.goonButton:setVisible(false)
	self.closeButton2:setVisible(false)

	local _timerAction
	local _cartoon11index = 0
	local function _callBack()

		_cartoon11index = _cartoon11index + 1

		local oneClickTurnCardTableV = self.oneClickTurnCardTable[_cartoon11index]

		if oneClickTurnCardTableV == nil then
			self.goonButton:setVisible(true)
			self.closeButton2:setVisible(true)
			local buttonText
			if _buyCount == 1 then
				buttonText = "再召一次"
			else
				buttonText = "再召十次"
			end

			if self.goonButton then
				self.goonButton:setLable(buttonText)
				self.goonButton.buttonId = 1
			end

			self.decText:setVisible(true)
			self.itemImage:setVisible(true)

			if _timerAction then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(_timerAction);
				_timerAction = nil
			end
		else
			if self.itemArr[oneClickTurnCardTableV.index].isCard == 1 then
				if _timerAction then
					Director:sharedDirector():getScheduler():unscheduleScriptEntry(_timerAction);
					_timerAction = nil
				end
			end

			local function _callBack1()
				if _timerAction == nil then
					_timerAction = Director:sharedDirector():getScheduler():scheduleScriptFunc(_callBack, 0.2, false)	
				end
			end

			-- type==1 1次一键
			-- type==2 10次一键
			local clickType = 1
			if table.getn(self.itemArr) > 1 then
				clickType = 2
			end

			self:boneLightBack3(clickType,oneClickTurnCardTableV,_callBack1)

		end

	end
	_timerAction = Director:sharedDirector():getScheduler():scheduleScriptFunc(_callBack, 0.2, false)

	_callBack()		

end

function LangyalingCardsLayer:playCartoon1(cartoonType,itemTable,index,callBackFunc)

	local _positionX,_positionY = GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2
	local _selfUI = self.needCleanUI;
	local _selfUI2 = self.needCleanUI2;

	-- 一次抽
	if cartoonType == 1 then
		
	elseif cartoonType == 2 then -- 10连抽
		if index <= 5 then -- 第一行
			_positionX,_positionY = 250 + (index - 1) * 193,520
		else -- 第二行
			_positionX,_positionY = 250 + (index - 6) * 193,270
		end
	end

	local function _boneLightBack2()

		local actionArr1 = CCArray.create()
		local actionArr2 = CCArray.create()
		
		self.goonButton:setVisible(true)

		if itemTable["isCard"] == 1 then --卡牌
			-- 太阳
			local _boneCartoon3 = BoneCartoon.new()
			_boneCartoon3:create(StaticArtsConfig.BONE_EFFECT_373,0);
			_boneCartoon3:setMyBlendFunc()
			_boneCartoon3:setPositionXY(GameConfig.STAGE_WIDTH / 2,GameConfig.STAGE_HEIGHT / 2)
			_selfUI2:addChild(_boneCartoon3);

			local _cardUI = _getHeroCard(itemTable)
			_cardUI:setScale(0.25)
			_cardUI:setPositionXY(_positionX,_positionY)
			_selfUI2:addChild(_cardUI);

			local function _callBackFunc()
				local _touchLayer = Layer.new()
				_touchLayer:initLayer()
				_touchLayer:setContentSize(Director:sharedDirector():getWinSize())
				_selfUI2:addChild(_touchLayer)
				local function _onclickTouchLayer()

					_selfUI2:removeChild(_boneCartoon3)
					_touchLayer:removeEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)
					_selfUI2:removeChild(_touchLayer)
					if GameVar.tutorStage == TutorConfig.STAGE_1003  then
				    	openTutorUI({x=1198, y=641 + GameData.uiOffsetY, width = 80, height = 80, alpha = 125});
				    end
					local function _callBackFunc1()
						_selfUI2:removeChild(_cardUI);

						if itemTable["art"] then
							local _itemUI = _getItemDO(itemTable)
							_itemUI:setPositionXY(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)

							local itemData = BagItem.new();
							itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
							_itemUI:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  

							_selfUI:addChild(_itemUI)					
						else
							local heroRoundPortrait = HeroRoundPortrait.new();
							heroRoundPortrait:initialize(itemTable,false);
							heroRoundPortrait:showName4Langyaling();
							heroRoundPortrait:setPositionXY(_positionX - heroRoundPortrait:getContentSize().width / 2,_positionY - heroRoundPortrait:getContentSize().height / 2);
							_selfUI:addChild(heroRoundPortrait);

							-- local itemData = BagItem.new();
							-- itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});

							local itemData = {heroItemTable = itemTable,positionX = _positionX,positionY = _positionY}
							heroRoundPortrait:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  								
						end

						local cartoon1
						local function removeCartoon1()
							_selfUI:removeChild(cartoon1);
						end
						cartoon1 = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_1159,_positionX - 145,_positionY + 140,1,removeCartoon1,nil,nil,true)
						_selfUI:addChild(cartoon1);

					end

					local actionArr3 = CCArray.create()
					local actionArr4 = CCArray.create()
					actionArr3:addObject(CCScaleTo:create(0.1,0.25,0.25))
					actionArr3:addObject(CCRotateBy:create(0.1 , 360))
					actionArr3:addObject(CCMoveTo:create(0.1, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
					actionArr4:addObject(CCSpawn:create(actionArr3))
					actionArr4:addObject(CCCallFunc:create(_callBackFunc1))
					_cardUI:runAction(CCSequence:create(actionArr4))

					if callBackFunc then
						callBackFunc()
					end

				end

				_touchLayer:addEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)

			end

			actionArr2:addObject(CCScaleTo:create(0.15,4,4))
			actionArr2:addObject(CCRotateBy:create(0.15 , 360))
			actionArr2:addObject(CCMoveTo:create(0.15, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
			actionArr1:addObject(CCSpawn:create(actionArr2))
			actionArr1:addObject(CCCallFunc:create(_callBackFunc))
			_cardUI:runAction(CCSequence:create(actionArr1))

		else -- 道具

			local _itemUI = _getItemDO(itemTable)
			local function _callBackFunc2()
				if callBackFunc and cartoonType == 1 then
					callBackFunc()
				end
			end
			_itemUI:setAnchorPoint(CCPointMake(0.5, 0.5))
			_itemUI:setScale(0.25)
			_itemUI:setPositionXY(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)
			_selfUI:addChild(_itemUI)

			local itemData = BagItem.new();
			itemData:initialize({ItemId = itemTable["ItemId"], Count = itemTable["count"]});
			_itemUI:addEventListener(DisplayEvents.kTouchTap, self.onItemTip, self,itemData);  																			

			actionArr2:addObject(CCScaleTo:create(0.1,1,1))
			actionArr2:addObject(CCMoveTo:create(0.1, ccp(_positionX - _itemUI:getContentSize().width / 2,_positionY - _itemUI:getContentSize().height / 2)))
			actionArr1:addObject(CCSpawn:create(actionArr2))
			actionArr1:addObject(CCCallFunc:create(_callBackFunc2))
			_itemUI:runAction(CCSequence:create(actionArr1))

			local cartoon1
			local function removeCartoon1()
				_selfUI:removeChild(cartoon1);
			end
			cartoon1 = cartoonPlayer(StaticArtsConfig.BONE_EFFECT_1159,_positionX - 145,_positionY + 140,1,removeCartoon1,nil,nil,true)
			_selfUI:addChild(cartoon1);
		end
	end

	local function removeCartoon1()
		_selfUI:removeChild(self.cartoon1);

		if cartoonType == 1 then

		else
			self.goonButton:setLable("一键翻牌")
			self.goonButton.buttonId = 2

			-- self.decText:setVisible(false)
			-- self.itemImage:setVisible(false)			
		end

		-- 以下做一次就行了 略有问题但也没什么问题
		self.closeButton2:addEventListener(Events.kStart, self.onUIClose, self);
		self.isPopupLayer = false
		self.goonButton:setVisible(true)
		self.hasClickedOneClick = false
		-- self.decText:setVisible(true)
		-- self.itemImage:setVisible(true)		
	end

	if not self.cartoon1 then
		self.cartoon1 = cartoonPlayer(1748,GameConfig.STAGE_WIDTH / 2 ,0,1,removeCartoon1,nil,nil,true)
		_selfUI:addChild(self.cartoon1);
	end

	local cardBackImageId = 1731
	local cartoon2

	if itemTable["isCard"] == 1 then --卡牌
		cardBackImageId = 1732
		cartoon2 = cartoonPlayer(1387,_positionX,_positionY,0,1.5)
		cartoon2:setVisible(false)	
	end

	-- local cardBackImage1 = Image.new()
	-- cardBackImage1:loadByArtID(cardBackImageId)
	-- cardBackImage1:setAnchorPoint(CCPointMake(0.5,0.5))
	-- cardBackImage1:setPositionXY(_positionX,_positionY)
	-- cardBackImage1:setVisible(false)
	-- _selfUI:addChild(cardBackImage1);

	local cardBackImage = Image.new()
	cardBackImage:loadByArtID(cardBackImageId)
	cardBackImage:setScale(0.25)
	cardBackImage:setAnchorPoint(CCPointMake(0.5,0.5))
	cardBackImage:setPositionXY(GameConfig.STAGE_WIDTH/2,0)
	_selfUI:addChild(cardBackImage);

	_selfUI2:addChild(cartoon2)
	
	local cardTable = {}
	cardTable.index = index
	cardTable.cardBackImage = cardBackImage
	-- cardTable.cardBackImage1 = cardBackImage1
	
	self.oneClickTurnCardTable[index] = cardTable

	local function _boneLightBack1()

		local function _boneLightBack4()
			_selfUI:removeChild(cardBackImage);
			-- _selfUI:removeChild(cardBackImage1);
			_boneLightBack2()
		end

		local function _boneLightBack3()
			if self.hasClickedOneClick then
				return
			end
			
			self.goonButton:setVisible(false)

			if cartoon2 then
				cartoon2:setVisible(false)
			end

			for k,v in pairs(self.oneClickTurnCardTable) do
				if v.index == index then
					table.remove(self.oneClickTurnCardTable,k)
				end
			end

			if table.getn(self.oneClickTurnCardTable) == 0 then
				local buttonText
				if _buyCount == 1 then
					buttonText = "再召一次"
				else
					buttonText = "再召十次"
				end
				self.goonButton:setLable(buttonText)
				self.goonButton.buttonId = 1
			end
			
			ScreenShake:generalShake(cardBackImage,5,5,3,3)

			-- cardBackImage1:setVisible(true)
			Tweenlite:CardFlipHalf(cardBackImage,0.5,_boneLightBack4)
		end

		if cartoon2 then
			cartoon2:setVisible(true)
		end
		
		-- 点击卡背
		if cartoonType == 1 then
			_boneLightBack3()
		else
			cardBackImage:addEventListener(DisplayEvents.kTouchTap,_boneLightBack3,self)
		end

		
	end

	local function actionFunction()
		local actionArr1 = CCArray.create()
		local actionArr2 = CCArray.create()
		actionArr2:addObject(CCScaleTo:create(0.1,1,1))
		actionArr2:addObject(CCMoveTo:create(0.15, ccp(_positionX, _positionY)))
		actionArr1:addObject(CCSpawn:create(actionArr2))
		actionArr1:addObject(CCCallFunc:create(_boneLightBack1))
		cardBackImage:runAction(CCSequence:create(actionArr1))
	end

	local _positionX1, _positionY1

	local scaleRandom = 1.2

	local actionArr1 = CCArray.create()
	local actionArr2 = CCArray.create()
	actionArr2:addObject(CCScaleTo:create(0.15,scaleRandom,scaleRandom))
	actionArr2:addObject(CCMoveTo:create(0.15, ccp(_positionX, _positionY + 30)))
	actionArr1:addObject(CCSpawn:create(actionArr2))
	actionArr1:addObject(CCDelayTime:create(0.1))
	actionArr1:addObject(CCCallFunc:create(actionFunction))
	cardBackImage:runAction(CCSequence:create(actionArr1))

end

function LangyalingCardsLayer:playCartoon11()
	local _cartoon11index = 0

	for k,v in pairs(self.itemArr) do
		_cartoon11index = _cartoon11index + 1
		if _cartoon11index <= 10 then
			self:playCartoon1(2,self.itemArr[_cartoon11index],_cartoon11index)
		end
	end
end

function LangyalingCardsLayer:removeAction1Timer()
    if self.action1Timer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.action1Timer);
        self.action1Timer = nil
    end
end

function LangyalingCardsLayer:removeBoneTimer()
    if self.boneTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.boneTimer);
        self.boneTimer = nil
    end
end

function LangyalingCardsLayer:onUIClose()
	local scaleY = 2
	local function action1TimerFun()
		scaleY = scaleY - 0.3
		if self and scaleY then
			self:setScaleX(scaleY)
			if scaleY <= 0 then
		        self:removeAction1Timer()
		        if self.popUp then
		        	self.popUp:removeCardsLayer()
		        end
	        end			
		end
  	end
  	self.action1Timer = Director:sharedDirector():getScheduler():scheduleScriptFunc(action1TimerFun, 0, false)
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
		if GameVar.tutorSmallStep > 8 then
 			openTutorUI({x=1202, y=641 + GameData.uiOffsetY, width = 80, height = 75, alpha = 125});
    	else
   			openTutorUI({x=258, y=56, width = 264, height = 560, alpha = 125});
    	end
    end
end

function LangyalingCardsLayer:onItemTip(event,data)
	if data.heroItemTable then
		local _cardUI = _getHeroCard(data.heroItemTable)
		_cardUI:setScale(0.25)
		_cardUI:setPositionXY(data.positionX,data.positionY)
		self:addChild(_cardUI);

		local function _onclickTouchLayer()
			self:removeChild(_cardUI);
		end

		local function _callBackFunc1()
			_cardUI:addEventListener(DisplayEvents.kTouchTap,_onclickTouchLayer,self)			
		end

		local actionArr3 = CCArray.create()
		local actionArr4 = CCArray.create()
		actionArr3:addObject(CCScaleTo:create(0.1,4,4))
		actionArr3:addObject(CCRotateBy:create(0.1 , 360))
		actionArr3:addObject(CCMoveTo:create(0.1, ccp(GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2)))
		actionArr4:addObject(CCSpawn:create(actionArr3))
		actionArr4:addObject(CCCallFunc:create(_callBackFunc1))
		_cardUI:runAction(CCSequence:create(actionArr4))	

	else
		self.popUp:dispatchEvent(Event.new("ON_ITEM_TIP", {item = data,nil,nil,count=data.userItem.Count},self))	
	end
end

function LangyalingCardsLayer:refreshCurrency()
	local silverText = self.popUp.userCurrencyProxy:getSilver()
	if silverText >= 1000000 then
		silverText = math.floor(silverText / 10000) .."万"
	end	

	if self.yinliangText then
		self.yinliangText:setString(silverText)
	end

	local goldText = self.popUp.userCurrencyProxy:getGold()
	if goldText >= 1000000 then
		goldText = math.floor(goldText / 10000) .."万"
	end

	if self.yuanbaoText then
		self.yuanbaoText:setString(goldText)
	end

	local yingxionglingCount = self.popUp.bagProxy:getItemNum(1009002)
	local langyalingCount = self.popUp.bagProxy:getItemNum(1009001)
	if self.yingxionglingText then
		self.yingxionglingText:setString(yingxionglingCount)
	end
	
	if self.langyalingText then
		self.langyalingText:setString(langyalingCount)	
	end
end

function LangyalingCardsLayer:onClickBg1()
    self.popUp:dispatchEvent(Event.new("TO_DIANJINSHOU"));	
    MusicUtils:playEffect(7,false);
end

function LangyalingCardsLayer:onClickBg2()
	self.popUp:dispatchEvent(Event.new("TO_VIP"));
	MusicUtils:playEffect(7,false);
end

function LangyalingCardsLayer:onClickBantouBg1()
	self.desSliverText:setString("银两:"..self.popUp.userCurrencyProxy:getSilver())
	self.sliverLayer:setVisible(true)    
end

function LangyalingCardsLayer:onClickBantouBg2()
	self.desGoldText:setString("元宝:"..self.popUp.userCurrencyProxy:getGold())
	self.goldLayer:setVisible(true)    
end
function LangyalingCardsLayer:onClickUI(event)
	if self.goldLayer:isVisible() then
		self.goldLayer:setVisible(false)
	end
	if self.sliverLayer:isVisible() then
		self.sliverLayer:setVisible(false)
	end
end