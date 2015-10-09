
LotteryUI = class (Layer);

function LotteryUI:ctor()
	self.class = LotteryUI;
	self.skeleton = nil;
	self.mianfeibaoxiangGroup1DO = nil
	self.mianfeibaoxiangGroup2DO = nil
	self.mianfeibaoxiangGroup3DO = nil
	self.mianfeibaoxiangGroup = {};
	self.clickedFreeBox = nil
	self.clickedFreeBoxCount = nil
	self.currentClickedBox = nil;
    self.urlString1 = "resource/image/arts/P129.lua"
    self.hasLeave = false
end

function LotteryUI:dispose()
  	self:removeChildren(false);
	LotteryUI.superclass.dispose(self);
	if self.armature then
		self.armature:dispose()--移除UI纹理
		self.armature= nil;	
	end
	self:removeOverTimeOut()
	BitmapCacher:deleteTextureLua(self.urlString1);
	BitmapCacher:removeUnused()
	self:removeTimer();
end

function LotteryUI:initializeUI(lotteryProxy,battleProxy,currencyProxy,countProxy)
    self:initLayer()
    self.clickedFreeBox = {}
    self.clickedFreeBoxCount = 0

	self.battleProxy = battleProxy;	
	self.lotteryProxy = lotteryProxy;
	self.currencyProxy = currencyProxy;
	self.countProxy = countProxy;

	self.needTili = self:getNeedTiLi()

    local armature = lotteryProxy:getSkeleton():buildArmature("freeLottery");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
	self:addChild(armature.display);
    armature:update()
	self.armature = armature
	--选择title
	self.xuanzetitleDO = armature:getBone("xuanzetitle"):getDisplay()
	self.xuanzetitleDOY = self.xuanzetitleDO:getPositionY()
	local backImage = Image.new()
	backImage:loadByArtID(671)
	backImage:setPositionXY(-200,-360)
	self.xuanzetitleDO:addChild(backImage)

	self.leftTextBone1 =  armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("leftText")
	self.leftTextBone2 =  armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("leftText")
	self.leftTextBone3 =  armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("leftText")

	local textData = armature:getBone("leftText").textData 
	self.battleOverTimeText = createTextFieldWithTextData(textData,"")
	self:addChild(self.battleOverTimeText)
	
	self.leaveButtonDO = armature:getBone("common_copy_greenlongroundbutton"):getDisplay();
	self.continueButtonDO = armature:getBone("common_copy_bluelonground_button"):getDisplay();
	self.leaveButtonDO:setVisible(false);
	self.continueButtonDO:setVisible(false);

	local buttonPos = convertBone2LB4Button(self.leaveButtonDO);
	local buttonData = armature:findChildArmature("common_copy_greenlongroundbutton"):getBone("common_greenlongroundbutton").textData;
	self.leaveButton = CommonButton.new();
	self.leaveButton:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	self.leaveButton:initializeText(buttonData,"离开战场");
	self.leaveButton:setPositionXY(buttonPos.x,buttonPos.y);
	self.leaveButton:addEventListener(DisplayEvents.kTouchTap,self.onClickCloseButton,self);
	self:addChild(self.leaveButton);

	buttonPos = convertBone2LB4Button(self.continueButtonDO);
	self.continueButton = CommonButton.new();
	self.continueButton:initialize("common_greenlongroundbutton_normal","common_greenlongroundbutton_down",CommonButtonTouchable.BUTTON);
	self.continueButton:addEventListener(DisplayEvents.kTouchTap,self.onClickContinueButton,self);
	self.continueButton:initializeText(buttonData,"再战一次");
	self.continueButton:setGray(self:isNeedGray())
	self.continueButton:setPositionXY(buttonPos.x,buttonPos.y + self.skewY);
	self:addChild(self.continueButton);	
	--three boxes
    self.mianfeibaoxiangGroup1DO = armature:getBone("mianfeibaoxiangGroup1").displayBridge.display
	self.mianfeibaoxiangGroup2DO = armature:getBone("mianfeibaoxiangGroup2").displayBridge.display
	self.mianfeibaoxiangGroup3DO = armature:getBone("mianfeibaoxiangGroup3").displayBridge.display
	
	self.mianfeibaoxiangGroup1DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBox,self,1);
	table.insert(self.mianfeibaoxiangGroup,self.mianfeibaoxiangGroup1DO);
	self.mianfeibaoxiangGroup2DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBox,self,2);
	table.insert(self.mianfeibaoxiangGroup,self.mianfeibaoxiangGroup2DO);
	self.mianfeibaoxiangGroup3DO:addEventListener(DisplayEvents.kTouchTap,self.onClickBox,self,3);
	table.insert(self.mianfeibaoxiangGroup,self.mianfeibaoxiangGroup3DO);

	self.mianfeibaoxiangGroup1DO.posY = self.mianfeibaoxiangGroup1DO:getPositionY()
	self.mianfeibaoxiangGroup1DO:setPositionY(GameConfig.STAGE_HEIGHT*1.6)
	
	self.mianfeibaoxiangGroup2DO.posY = self.mianfeibaoxiangGroup2DO:getPositionY()
	self.mianfeibaoxiangGroup2DO:setPositionY(GameConfig.STAGE_HEIGHT*1.6)

	self.mianfeibaoxiangGroup3DO.posY = self.mianfeibaoxiangGroup3DO:getPositionY()
	self.mianfeibaoxiangGroup3DO:setPositionY(GameConfig.STAGE_HEIGHT*1.6)
	
	-- 第一个宝箱
    self.baoxiangkaiDO1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("baoxiangkai").displayBridge.display
	self.baoxiangDO1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("baoxiang").displayBridge.display
	self.baoxiangTextDO1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("nilSpriteText").displayBridge.display
	self.leftTextDO1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("leftText").displayBridge.display
	self.goldImage1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("common_gold_bg").displayBridge.display
	self.silverImage1 = armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("common_silver_bg").displayBridge.display
    
	-- 第2个宝箱
    self.baoxiangkaiDO2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("baoxiangkai").displayBridge.display
	self.baoxiangDO2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("baoxiang").displayBridge.display
	self.baoxiangTextDO2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("nilSpriteText").displayBridge.display
	self.leftTextDO2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("leftText").displayBridge.display	
	self.goldImage2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("common_gold_bg").displayBridge.display
	self.silverImage2 = armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("common_silver_bg").displayBridge.display
	-- 第3个宝箱
    self.baoxiangkaiDO3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("baoxiangkai").displayBridge.display
	self.baoxiangDO3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("baoxiang").displayBridge.display
	self.baoxiangTextDO3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("nilSpriteText").displayBridge.display
	self.leftTextDO3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("leftText").displayBridge.display	
	self.goldImage3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("common_gold_bg").displayBridge.display
	self.silverImage3 = armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("common_silver_bg").displayBridge.display

    self.silverImage1:setVisible(false)
    self.silverImage2:setVisible(false)
    self.silverImage3:setVisible(false)
	
	self.baoxiangTextBone1 =  armature:findChildArmature("mianfeibaoxiangGroup1"):getBone("nilSpriteText")
	self.baoxiangTextBone2 =  armature:findChildArmature("mianfeibaoxiangGroup2"):getBone("nilSpriteText")
	self.baoxiangTextBone3 =  armature:findChildArmature("mianfeibaoxiangGroup3"):getBone("nilSpriteText")

	-- 添加半透
	local winSize = Director:sharedDirector():getWinSize()
	local uiSize = self:getGroupBounds(false).size
	local offsetX,offsetY = (winSize.width - uiSize.width) / 2,(winSize.height - uiSize.height) / 2

	local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
	backHalfAlphaLayer:setOpacity(185)
	backHalfAlphaLayer:setScale(1.6)
	backHalfAlphaLayer:setPositionXY(-1 * offsetX - 60, -1 * offsetY - 10)
	self:addChildAt(backHalfAlphaLayer,0)

	local nilTable = {}
	nilTable[1] = 1
	nilTable[3] = 2
	nilTable[2] = 3
	self:animateBox(nilTable)
	self:titleAnimate()

	-- 箱子状态 1，没开启，2，已开启
	self.boxState = {}
	self.boxState[1] = 1
	self.boxState[2] = 1
	self.boxState[3] = 1
	self:refreshFreeUI()
	self:refreshOverTime(1)
end

function LotteryUI:isNeedGray()
	--if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_3 then return false end
	if not self.needTili then return true end
end

--倒计时
function LotteryUI:refreshOverTime(flag)
	local giftesc = analysis("Zhandoupeizhi_Zhanchangleixing",self.battleProxy.battleType,"giftesc");
	if giftesc == 0 then return end
	self:removeOverTimeOut()
	local totalTime;
	if flag == 1 then
		totalTime = 5--analysis("Xishuhuizong_Xishubiao",239,"constant")
	elseif flag == 2 then
		totalTime = 5--analysis("Xishuhuizong_Xishubiao",240,"constant")
	end
	if not self.battleOverTimeText or not self.battleOverTimeText.sprite then
		return
	end
	self.battleOverTimeText:setString("退出倒计时 : "..totalTime.."秒")
	local function overTimeOut()
		if not self.battleOverTimeText or not self.battleOverTimeText.sprite then
			self:removeOverTimeOut();
			return
		end
        self.battleOverTimeText:setString("退出倒计时 : "..totalTime.."秒")
        if totalTime <= 0 then
        	self:removeOverTimeOut();
        	if flag == 1 then
        		self:onClickBox(nil,2)
        	elseif flag == 2 then
        		self:onClickCloseButton()
        	end
        end
        totalTime = totalTime - 1
    end
    self.overTimeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(overTimeOut, 1, false);
end

function LotteryUI:setButton()
	if self.clickedFreeBoxCount > 0 then
		if self.continueButton then
			self.continueButton:setVisible(true);
		end
		self.leaveButton:setVisible(true);
	else
		self.leaveButton:setVisible(false);
		if self.continueButton then
			self.continueButton:setVisible(false);		
		end
	end
end

function LotteryUI:refreshFreeUI()
	if self.mianfeibaoxiangGroup1DO:contains(self.PriceText1) then
		self.mianfeibaoxiangGroup1DO:removeChild(self.PriceText1)
	end	
	if self.mianfeibaoxiangGroup2DO:contains(self.PriceText2) then
		self.mianfeibaoxiangGroup2DO:removeChild(self.PriceText2)
	end	
	if self.mianfeibaoxiangGroup3DO:contains(self.PriceText3) then
		self.mianfeibaoxiangGroup3DO:removeChild(self.PriceText3)
	end	
	if self.mianfeibaoxiangGroup1DO:contains(self.PriceText_left1) then
		self.mianfeibaoxiangGroup1DO:removeChild(self.PriceText_left1)
	end	
	if self.mianfeibaoxiangGroup2DO:contains(self.PriceText_left2) then
		self.mianfeibaoxiangGroup2DO:removeChild(self.PriceText_left2)
	end	
	if self.mianfeibaoxiangGroup3DO:contains(self.PriceText_left3) then
		self.mianfeibaoxiangGroup3DO:removeChild(self.PriceText_left3)
	end	
	if self:contains(self.grayImage1) then
		self:removeChild(self.grayImage1)
	end		
	if self:contains(self.grayImage2) then
		self:removeChild(self.grayImage2)
	end
	if self:contains(self.grayImage3) then
		self:removeChild(self.grayImage3)
	end	
	self:setButton()
	self:setBoxes()
end

function LotteryUI:setBoxes()
	local notOpenBoxTable = {}
	local disBoo = false
	if self.clickedFreeBoxCount > 0 then
		disBoo = true	
	end
	for k,v in pairs(self.boxState) do
		if k == 1 then
			if v == 1 then
				self:setBoxPrice(1,disBoo)
				self.baoxiangkaiDO1:setVisible(false)
				self.baoxiangDO1:setVisible(true)
			elseif v == 2 then
				self.baoxiangkaiDO1:setVisible(true)
				self.baoxiangDO1:setVisible(false)
				self.baoxiangTextDO1:setVisible(false)
				self.goldImage1:setVisible(false)
				self.silverImage1:setVisible(false)			
			end
		elseif k == 2 then
			if v == 1 then
				self:setBoxPrice(2,disBoo)
				self.baoxiangkaiDO2:setVisible(false)
				self.baoxiangDO2:setVisible(true)
			elseif v == 2 then
				self.baoxiangkaiDO2:setVisible(true)
				self.baoxiangDO2:setVisible(false)
				self.baoxiangTextDO2:setVisible(false)
				self.goldImage2:setVisible(false)
				self.silverImage2:setVisible(false)			
			end	
		elseif k == 3 then
			if v == 1 then
				self:setBoxPrice(3,disBoo)
				self.baoxiangkaiDO3:setVisible(false)
				self.baoxiangDO3:setVisible(true)
			elseif v == 2 then
				self.baoxiangkaiDO3:setVisible(true)
				self.baoxiangDO3:setVisible(false)
				self.baoxiangTextDO3:setVisible(false)
				self.goldImage3:setVisible(false)
				self.silverImage3:setVisible(false)			
			end		
		end
	end
end

-- 设置宝箱价格相关
function LotteryUI:setBoxPrice(index,isDisplay)
	if index == 1 then
		self.baoxiangTextDO1:setVisible(isDisplay)
		self.goldImage1:setVisible(isDisplay)
	elseif index == 2 then
		self.baoxiangTextDO2:setVisible(isDisplay)
		self.goldImage2:setVisible(isDisplay)
	elseif index == 3 then
		self.baoxiangTextDO3:setVisible(isDisplay)
		self.goldImage3:setVisible(isDisplay)
	end
	if isDisplay then
		self:setPriceText(index)
	end	
end

function LotteryUI:setPriceText(index)
	local realX
	local realY
	local text_name;
	local text_data
	local selfText
	local costParam
	
	local selfText_left
	local realX_left
	local realY_left	
	local text_data_left
	local text_name_left = "开启花费:"
	
	if self.clickedFreeBoxCount == 1 then
		costParam = 36
	elseif self.clickedFreeBoxCount == 2 then
		costParam = 37
	end
	
	text_name = 5--analysis("Xishuhuizong_Xishubiao",costParam,"constant")
	
	if index == 1 then
		text_data = self.baoxiangTextBone1.textData
		text_data_left = self.leftTextBone1.textData
	elseif index == 2 then	
		text_data = self.baoxiangTextBone2.textData
		text_data_left = self.leftTextBone2.textData		
	elseif index == 3 then		
		text_data = self.baoxiangTextBone3.textData
		text_data_left = self.leftTextBone3.textData					
	end
	if nil~=text_name then
		text_data=copyTable(text_data);
		selfText=createTextFieldWithTextData(text_data,text_name);
		self:refreshCost(3,tonumber(text_name),selfText)
		
		text_data_left=copyTable(text_data_left);
		selfText_left=createTextFieldWithTextData(text_data_left,text_name_left);
		selfText_left:setColor(ccc3(255,221,0));
		
		if index == 1 then
			self.PriceText1 = selfText
			self.mianfeibaoxiangGroup1DO:addChild(self.PriceText1);
			self.PriceText_left1 = selfText_left
			self.mianfeibaoxiangGroup1DO:addChild(self.PriceText_left1);			
		elseif index == 2 then
			self.PriceText2 = selfText
			self.mianfeibaoxiangGroup2DO:addChild(self.PriceText2);		
			self.PriceText_left2 = selfText_left
			self.mianfeibaoxiangGroup2DO:addChild(self.PriceText_left2);			
		elseif index == 3 then
			self.PriceText3 = selfText
			self.mianfeibaoxiangGroup3DO:addChild(self.PriceText3);	
			self.PriceText_left3 = selfText_left
			self.mianfeibaoxiangGroup3DO:addChild(self.PriceText_left3);			
		end		
	end
end
	
function LotteryUI:onClickBox(event,index)
	self:setTimeOut();
	local isSendCommand = true
	if self.clickedFreeBox then
		for k,v in pairs(self.clickedFreeBox) do
			if v == index then	
				sharedTextAnimateReward():animateStartByString("已领取..");
				isSendCommand = false
				return
			end
		end
		local costParam = 0
		if self.clickedFreeBoxCount == 1 then
			costParam = 36
		elseif self.clickedFreeBoxCount == 2 then
			costParam = 37
		elseif self.clickedFreeBoxCount == 3 then
			isSendCommand = false
		end
		
		if costParam ~= 0 and self.currencyProxy:getGold() < 5 then
			sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_9));	
			isSendCommand = false	
			return
		end
	end
	
	if isSendCommand then
		local sendMessageTable = {}
		sendMessageTable["Position"] = index
		sendMessageTable["BooleanValue"] = 0
		self.currentClickedBox=index;
		self:dispatchEvent(Event.new("SEND_MESSAGE_FOR_CHARGE_BOX",sendMessageTable, self));
	end
end

function LotteryUI:animateBox(boxTable)
	local index = 0
	local indexDelayTime = 0
	local boxDO
	for k,v in pairs(boxTable) do
		if(v == 1) then 
			boxDO = self.mianfeibaoxiangGroup1DO
			boxDO.place = 1
		elseif(v == 2) then
			boxDO = self.mianfeibaoxiangGroup2DO
			boxDO.place = 2
		else
			boxDO = self.mianfeibaoxiangGroup3DO
			boxDO.place = 3
		end

		if index == 0 then
			indexDelayTime = 0
		elseif index == 1 then
			indexDelayTime = 200
		elseif index == 2 then
			indexDelayTime = 500
		end

		self:singalAnimateBox(boxDO,indexDelayTime)
		index = index + 1
	end

end

function LotteryUI:titleAnimate()
	local moveTo1 = CCMoveTo:create(0.2, ccp(self.xuanzetitleDO:getPositionX(), self.xuanzetitleDOY-30))
	local easeOut1 = CCEaseOut:create(moveTo1,0.2)
	local moveTo2 = CCMoveTo:create(0.15, ccp(self.xuanzetitleDO:getPositionX(), self.xuanzetitleDOY + 20))
	local easeOut2 = CCEaseOut:create(moveTo2,0.15)
	local moveTo3 = CCMoveTo:create(0.15, ccp(self.xuanzetitleDO:getPositionX(), self.xuanzetitleDOY))
	local easeOut3 = CCEaseOut:create(moveTo3,0.15)			
	local moveTo4 = CCMoveTo:create(0.3, ccp(self.xuanzetitleDO:getPositionX(), self.xuanzetitleDOY))
	local easeOut4 = CCEaseOut:create(moveTo4,0.3)
	
	local sequenceArray = CCArray:create();
    sequenceArray:addObject(easeOut1)
	sequenceArray:addObject(easeOut2)
	sequenceArray:addObject(easeOut3)
	sequenceArray:addObject(easeOut4)
    self.xuanzetitleDO:runAction(CCSequence:create(sequenceArray));
end

function LotteryUI:singalAnimateBox(boxDO,delayTime)
	boxDO.touchChildren = false;
	local delayFunction 
	local function delayAnimate()
		if(nil~=delayFunction) then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayFunction)  
        end
        local function playEffect()
			local cartoon;
			local function removeEffect()
				self.armature.display:removeChild(cartoon)
			end
			cartoon = cartoonPlayer("129",boxDO:getPositionX()+115, boxDO.posY-170,1,removeEffect,2,nil,nil)
			self.armature.display:addChild(cartoon)
			cartoon.touchEnabled=false
    		cartoon.touchChildren=false;
        end
        local function endFunc()
			boxDO.touchChildren = true;
			ScreenShake:generalShake(self,5,5,3,3)
		end
		local sequenceArray = CCArray:create()
		local moveTo = CCMoveTo:create(0.4, ccp(boxDO:getPositionX(), boxDO.posY))
		local easeOut = CCEaseOut:create(moveTo,0.4)
		local array = CCArray:create()
		local sarray = CCArray:create()
		array:addObject(easeOut)
		sarray:addObject(CCDelayTime:create(0.43))
		sarray:addObject(CCCallFuncN:create(playEffect))
		array:addObject(CCSequence:create(sarray))
		sequenceArray:addObject(CCSpawn:create(array))
		sequenceArray:addObject(CCCallFuncN:create(endFunc))
    	boxDO:runAction(CCSequence:create(sequenceArray));
	end
	
    delayFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(delayAnimate, delayTime / 1000, false)
end

function LotteryUI:setTimeOut()
    local function timeOut()
        self:removeTimer();
        self.touchEnabled=true;
        self.touchChildren=true;
    end
    self.touchEnabled=false;
    self.touchChildren=false;
    self.timeOut = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOut, 0.7, false);
end

function LotteryUI:removeTimer()
	if self.timeOut then
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
		self.timeOut = nil;
	end
end

--恢复宝箱可点击
function LotteryUI:addHaveBuyItem(boo,index)
	for k,v in pairs(self.mianfeibaoxiangGroup)do
		v.touchEnabled = true;
		v.touchChildren = true;
	end
	
	if not boo then
		self.clickedFreeBox[index] = index
		self.clickedFreeBoxCount = self.clickedFreeBoxCount + 1
		
		for k1,v1 in pairs(self.boxState) do
			if k1 == index then
				self.boxState[k1] = 2
			end
		end			
	end
end
	
function LotteryUI:onClickCloseButton()
	if self.hasLeave then return end
	self.hasLeave = true
	self:flozenChild()
	self:onClickQuit()
end

function LotteryUI:onClickQuit()
	self:removeTimer();
	self:dispatchEvent(Event.new("CLOSE_LOTTERY_MEDIATOR",{}, self));
	self:dispatchEvent(Event.new("QUIT_BATTLE_FIELD",{}, self)); 
end

--再次当前副本的战斗
function LotteryUI:onClickContinueButton()
	if self.currencyProxy:getTili() < self.needTili then
		sharedTextAnimateReward():animateStartByString("体力不够哦!");
		return
	end
	--if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 then
	self:goBattle()
	--end
	self:flozenChild()
end

function LotteryUI:goBattle()
	if self.hasLeave then return end
	self.hasLeave = true
	local msg = {StrongPointId = self.battleProxy.battleFieldId, battleType = self.battleProxy.battleType,continueBattle = true};
	self:dispatchEvent(Event.new("CLOSE_LOTTERY_MEDIATOR",{},self));  
	self:dispatchEvent(Event.new("ENTER_BATTLE_FIELD",msg,self));	
end

function LotteryUI:showGainItem(itemId,count)
	if nil == self.currentClickedBox then return end;
	local userItem = {};
	userItem.ItemId = itemId;
	userItem.Count = count;
	local item = BagItem.new();
	item:initialize(userItem);
	self.mianfeibaoxiangGroup[self.currentClickedBox]:addChild(item);
	item:setPositionXY(92,-150);
	local itemName = analysis("Daoju_Daojubiao",userItem.ItemId,"name");
	local quality = analysis("Daoju_Daojubiao",userItem.ItemId,"color");
	local textField = TextField.new(CCLabelTTF:create(itemName, FontConstConfig.OUR_FONT, 20));
	textField:setPositionXY((item:getGroupBounds().size.width-textField:getContentSize().width)/2-5,item:getGroupBounds().size.height);
	textField:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(quality)));
	item:addChild(textField);
	item.touchEnabled = false;
	item.touchChildren = false;

	local cartoon;
	local function removeEffect()
		item:removeChild(cartoon)
	end
	cartoon = cartoonPlayer("711",40,10,1,removeEffect,3,nil,true)
	cartoon.sprite:setFlipX(true);
	item:addChild(cartoon)
	cartoon.touchEnabled=false
	cartoon.touchChildren=false;
	self:refreshOverTime(2)
end

function LotteryUI:getNeedTiLi()
	local guanKaPO = self:getGuanKaPO()
	if guanKaPO then
		return guanKaPO.depletion
	else
		return nil
	end
end

function LotteryUI:getGuanKaPO()
	if self.guanKaPO then return self.guanKaPO end
	local hasBool = analysisHas("Juqing_Guanka",self.battleProxy.battleFieldId);
	if hasBool then
		self.guanKaPO = analysis("Juqing_Guanka",self.battleProxy.battleFieldId)
		return self.guanKaPO
	else
		return nil
	end
end

function LotteryUI:refreshCost(costType,costValue,costCountText)
	local myMoney
	if costType == 2 then
		myMoney = self.currencyProxy:getSilver()
	elseif costType == 3 then
		myMoney = self.currencyProxy:getGold()
	end
	if myMoney >= costValue then
		costCountText.sprite:setColor(ccc3(255,221,0));
	else
		costCountText.sprite:setColor(ccc3(255,0,0));
	end
end

function LotteryUI:getDepletionTili()
	local hasBool = analysisHas("Juqing_Guanka",self.battleProxy.battleFieldId);
	if hasBool then
		return analysis("Juqing_Guanka",self.battleProxy.battleFieldId).depletion;
	else
		return 0
	end
end

function LotteryUI:removeOverTimeOut()
    if self.overTimeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.overTimeOut);
        self.overTimeOut = nil;
    end
end

function LotteryUI:flozenChild()
	self:removeOverTimeOut();
	if self.continueButton then
		self.continueButton:removeEventListener(DisplayEvents.kTouchTap, self.onClickContinueButton);
	end
	if self.quitButton then
		self.quitButton:removeEventListener(DisplayEvents.kTouchTap, self.onClickCloseButton);
	end
end
