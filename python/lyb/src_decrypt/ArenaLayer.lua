
ArenaLayer=class(Layer);

function ArenaLayer:ctor()
  self.class=ArenaLayer;
  self.itemArray = {}
  self.itemUserFrontArray = {}
  self.itemUserBackArray = {}
  require "main.view.arena.ui.ArenaFrontItem";
  require "main.view.arena.ui.ArenaBackItem";
  self.zhanli = 0
end

function ArenaLayer:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	ArenaLayer.superclass.dispose(self);
    if self.cdTimeListener then
        self.cdTimeListener:dispose();
        self.cdTimeListener = nil
    end
    self.popUp = nil
    self:removeTimeOutTimer()
    self:removeLoopTimer()
end

--intialize UI
function ArenaLayer:initialize(popUp)
    if self.popUp then return end;
    self.popUp = popUp;
    self:initLayer();
    -- local backHalfAlphaLayer =  LayerColorBackGround:getCustomBackGround(GameConfig.STAGE_WIDTH, GameConfig.STAGE_HEIGHT, 185)
    -- self:addChildAt(backHalfAlphaLayer,0)
    local armature=self.popUp.skeleton:buildArmature("arenaLayer_ui");
    self.armature = armature;
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();

    local armature_d=armature.display;
    self:addChild(armature_d);
    self.armature_d = armature_d;

    local text_data = self.armature:getBone("pm_text").textData;
    self.pmText = createTextFieldWithTextData(text_data,"排名 :");
    self:addChild(self.pmText);

    local text_data = self.armature:getBone("pm_num_text").textData;
    self.pmNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.pmNumText);

    local text_data = self.armature:getBone("zl_text").textData;
    self.zlText = createTextFieldWithTextData(text_data,"战力 :");
    self:addChild(self.zlText);

    local text_data = self.armature:getBone("zl_num_text").textData;
    self.zlNumText = createTextFieldWithTextData(text_data,"");
    self:addChild(self.zlNumText);

    local text_data = self.armature:getBone("times_text").textData;
    self.timesText = createTextFieldWithTextData(text_data,"次数 :");
    self:addChild(self.timesText);

    local text_data = self.armature:getBone("times_num_text").textData;
    self.timesNumText = createTextFieldWithTextData(text_data,"6/6");
    self:addChild(self.timesNumText);

    local headicon = self.armature_d:getChildByName("headicon")
    self.headiconP = headicon:getPosition()

    self.fangshouButton =armature_d:getChildByName("fangshou_button");
    SingleButton:create(self.fangshouButton, nil, 0);
    self.fangshouButton:addEventListener(DisplayEvents.kTouchTap, self.onCzTap, self);

    self.shangchengButton =armature_d:getChildByName("shangcheng_button");
    SingleButton:create(self.shangchengButton, nil, 0);
    self.shangchengButton:addEventListener(DisplayEvents.kTouchTap, self.shangchengTap, self);

    self.shangchengButton =armature_d:getChildByName("phb_button");
    SingleButton:create(self.shangchengButton, nil, 0);
    self.shangchengButton:addEventListener(DisplayEvents.kTouchTap, self.onPhbTap, self);

    self.zhanbaoButton =armature_d:getChildByName("zhanbao_button");
    SingleButton:create(self.zhanbaoButton, nil, 0);
    self.zhanbaoButton:addEventListener(DisplayEvents.kTouchTap, self.zhanbaoTap, self);

    self.xiangqingButton =armature_d:getChildByName("xiangqing_button");
    SingleButton:create(self.xiangqingButton, nil, 0);
    self.xiangqingButton:addEventListener(DisplayEvents.kTouchTap, self.onWanFaTap, self);

    armature_d:getChildByName("shuaxing_button"):setVisible(false)
    armature_d:getChildByName("chongzhi_button"):setVisible(false)
    armature_d:getChildByName("guomai_button"):setVisible(false)
end

function ArenaLayer:onCzTap(event)
    self.popUp:dispatchEvent(Event.new("to_Defense_Team",{context = self, onEnter = nil,funcType = "ArenaDefense"},self));
end

function ArenaLayer:zhanbaoTap(event)
    sharedTextAnimateReward():animateStartByString("亲~稍后开放哦~");
    hecDC(3,16,4)
end

function ArenaLayer:isNeedVipPopUp()
    local vipLV=self.popUp.userProxy:getVipLevel();
    if vipLV >= 15 then
        return false
    else
        return true
    end
end

function ArenaLayer:functionPanel()
    self.popUp:dispatchEvent(Event.new("TO_MAINSCENE_VIP",nil,self));
end

function ArenaLayer:onGuomaiTap(event)
    local leftTimes = self.popUp.countProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    local buyTimes = self.popUp.countProxy:getRemainLimitedCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    if leftTimes <= 0 then
      if buyTimes <= 0 then
        if self:isNeedVipPopUp() then
            local tips=CommonPopup.new();
            tips:initialize("VIP等级不足，不能购买次数",self,self.functionPanel,nil,nil,nil,nil,nil);
            commonAddToScene(tips,true);
            return
        end
        sharedTextAnimateReward():animateStartByString("亲~没有次数了哦！");
        return
      end
    end
    local gold = self.popUp.countProxy:getAddCountNeedGold(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    if not gold then
        sharedTextAnimateReward():animateStartByString("亲~购买次数用完了哦！");
        return
    end
    if gold > self.popUp.userCurrencyProxy:getGold() then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        return
    end
    sendMessage(3,6,{TimerType = GameConfig.USER_CDTIME_TYPE_1.."_0"})
    sendMessage(3,9,{CountControlType=CountControlConfig.ARENA_COUNT,CountControlParam=CountControlConfig.Parameter_1})
end

function ArenaLayer:onChongzhiTap(event)
    if not self.cdTimeListener then 
        sharedTextAnimateReward():animateStartByString("可以直接挑战哦！");
        return 
    end
    local gold = analysis("Xishuhuizong_Xishubiao",1047,"constant");
    if gold > self.popUp.userCurrencyProxy:getGold() then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        return
    end
    sendMessage(3,7,{TimerType = GameConfig.USER_CDTIME_TYPE_1.."_0"})
end

function ArenaLayer:onRefreshTap(event)
    if self.popUp.arenaProxy.ranking <= 50 then
        sharedTextAnimateReward():animateStartByString("不要再刷新了，请一点一点进步吧~");
        return
    end
    local leftTimes = self.popUp.countProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_2)
    local buyTimes = self.popUp.countProxy:getRemainLimitedCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_2)
    if leftTimes <= 0 then
      if buyTimes <= 0 then
          sharedTextAnimateReward():animateStartByString("亲~没有次数了哦！");
          return
      end
    end
    local gold = self.popUp.countProxy:getAddCountNeedGold(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_2)
    if not gold then
        sharedTextAnimateReward():animateStartByString("亲~刷新次数用完了哦！");
        return
    end
    if gold > self.popUp.userCurrencyProxy:getGold() then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        return
    end
    initializeSmallLoading();
    sendMessage(16,4)
    hecDC(3,16,3,{daojuIDhenum = "3^"..gold})
end

function ArenaLayer:removeTimeOutTimer()
    if self.timeOut then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOut);
        self.timeOut = nil
    end
end

function ArenaLayer:onPhbTap(event)
    self.popUp:onPhbTap()
end

function ArenaLayer:refreshEmployArrayData(battleEmployArray)
    self.friendFightLayer:refreshEmployArrayData(battleEmployArray);
end

function ArenaLayer:onWanFaTap(event)
    local string =analysis("Tishi_Guizemiaoshu",4,"txt");
    if string == "" then
        string = "<空>"
    end
    TipsUtil:showTips(event.target,string,nil,0);
    hecDC(3,16,5)
end

function ArenaLayer:removeWanfaLayer()
    if self.arenaWanFaLayer then
        self.popUp:removeChild(self.arenaWanFaLayer)
        self.arenaWanFaLayer = nil
    end
end

function ArenaLayer:refreshArenaLayerData()
    local arenaProxy = self.popUp.arenaProxy
    self.pmNumText:setString(arenaProxy.ranking)
    self.myRanking = arenaProxy.ranking

    self:refreshMyTeam()
    --if arenaProxy.ranking ~= 1 then
        self:refreshUserData()
    --else
    --    local first = self.popUp.skeleton:getBoneTextureDisplay("first")
    --    first:setPositionXY(500,200)
    --    self:addChild(first)
    --    self:setStateVisible()
    -- end
    self:refreshButtonState()
    self:refreshTimesData()
    self:refreshTimeData()

end

function ArenaLayer:refreshButtonState()
    local remainCount = self.popUp.countProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    if remainCount > 0 then
        if not self.popUp.arenaProxy:getTimeValue() or self.popUp.arenaProxy:getTimeValue() <= 0 then
            --刷新
            self:addRefreshButtonState()
            self.buttonState = 1
        else
            --重置
            self.buttonState = 2
            self:addChongzhiButtonState()
        end
    else
        --购买
        self:addGuomaiButtonState()
        self.buttonState = 3
    end
end

function ArenaLayer:setStateVisible()
    if self.des1Text then
        self.des1Text:setVisible(false)
    end
    if self.des2Text then
        self.des2Text:setVisible(false)
    end
    if self.des3Text then
        self.des3Text:setVisible(false)
    end
    if self.guomaiButton then
        self.guomaiButton:setVisible(false)
    end
    if self.chongzhiButton then
        self.chongzhiButton:setVisible(false)
    end
    if self.shuaxingButton then
        self.shuaxingButton:setVisible(false)
    end
end

function ArenaLayer:addGuomaiButtonState()
    self:setStateVisible()
    if not self.des1Text then
        local text_data = self.armature:getBone("des1_text").textData;
        self.des1Text = createTextFieldWithTextData(text_data,"");
        self:addChild(self.des1Text);
    end
    local gold = self.popUp.countProxy:getAddCountNeedGold(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    if gold then
        self.des1Text:setString(gold.."元宝")
        self.des1Text:setVisible(true)
        if not self.des2Text then
            local text_data = self.armature:getBone("des2_text").textData;
            self.des2Text = createTextFieldWithTextData(text_data,"");
            self:addChild(self.des2Text);
        end
        self.des2Text:setString("购买1次")
        self.des2Text:setVisible(true)
    else
        if self.des1Text then
            self.des1Text:setVisible(false)
        end
        if self.des2Text then
            self.des2Text:setVisible(false)
        end
    end
    if not self.guomaiButton then
        self.guomaiButton = self.armature_d:getChildByName("guomai_button");
        SingleButton:create(self.guomaiButton);
        self.guomaiButton:addEventListener(DisplayEvents.kTouchTap, self.onGuomaiTap, self);
    end
    self.guomaiButton:setVisible(true)
end

function ArenaLayer:addChongzhiButtonState()
    self:setStateVisible()
    if not self.des1Text then
        local text_data = self.armature:getBone("des1_text").textData;
        self.des1Text = createTextFieldWithTextData(text_data,"");
        self:addChild(self.des1Text);
    end
    self.des1Text:setString("挑战冷却")
    self.des1Text:setVisible(true)
    if not self.des2Text then
        local text_data = self.armature:getBone("des2_text").textData;
        
        self.des2Text = createTextFieldWithTextData(text_data,"");
        self:addChild(self.des2Text);
    end
    local gold = analysis("Xishuhuizong_Xishubiao",1047,"constant");
    self.des2Text:setString(gold.."元宝")
    self.des2Text:setVisible(true)
    if not self.des3Text then
        local text_data = self.armature:getBone("des3_text").textData;
        self.des3Text = createTextFieldWithTextData(text_data,"");
        self:addChild(self.des3Text);
    end
    self.des3Text:setVisible(true)
    if not self.cdTimeListener then
        self:refreshTimeData()
    end
    if not self.chongzhiButton then
        self.chongzhiButton = self.armature_d:getChildByName("chongzhi_button");
        SingleButton:create(self.chongzhiButton);
        self.chongzhiButton:addEventListener(DisplayEvents.kTouchTap, self.onChongzhiTap, self);
    end
    self.chongzhiButton:setVisible(true)
    
end

function ArenaLayer:addRefreshButtonState()
    --if self.popUp.arenaProxy.ranking == 1 then return end
    self:setStateVisible()
    if not self.des2Text then
        local text_data = self.armature:getBone("des2_text").textData;
        self.des2Text = createTextFieldWithTextData(text_data,"");
        self:addChild(self.des2Text);
    end
    local gold = self.popUp.countProxy:getAddCountNeedGold(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_2)
    if gold then
        local  goldStr = gold == 0 and "免费刷新" or gold.."元宝刷新"
        self.des2Text:setString(goldStr)
        self.des2Text:setVisible(true)
    else
        self.des2Text:setVisible(false)
    end
    
    if not self.shuaxingButton then
        self.shuaxingButton = self.armature_d:getChildByName("shuaxing_button");
        SingleButton:create(self.shuaxingButton);
        self.shuaxingButton:addEventListener(DisplayEvents.kTouchTap, self.onRefreshTap, self);
    end
    self.shuaxingButton:setVisible(true)
end

function ArenaLayer:refreshUserData()
    self:removeLayerUserData()
    local arenaProxy = self.popUp.arenaProxy
    local i = 0
    local function loopTime()
        local userVO = arenaProxy.userArenaArray[i+1]
        if userVO then
            local arenaFrontItem=ArenaFrontItem.new();
            arenaFrontItem:initializeItem(self,self.popUp.skeleton,i+1);
            self:addChild(arenaFrontItem)
            arenaFrontItem:setPositionXY(120+i*300,42)
            self.itemUserFrontArray[userVO.UserId] = arenaFrontItem
            arenaFrontItem:refreshItemData(userVO)
        end
        if i>=2 then
            self:removeLoopTimer()
            uninitializeSmallLoading();
        end
        i = i + 1
    end
    self.loopTimeFun = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopTime, 0.1, false)
end

function ArenaLayer:refreshHeroDetailData(userId)
    if self.itemUserBackArray[userId] then
        self:removeChild(self.itemUserBackArray[userId])
        self.itemUserBackArray[userId] = nil
    end
    local arenaBackItem=ArenaBackItem.new();
    arenaBackItem:initializeItem(self,self.popUp.skeleton,userId);
    self:addChild(arenaBackItem)
    local arenaFrontItem = self.itemUserFrontArray[userId]
    arenaBackItem:setPosition(arenaFrontItem:getPosition())
    self.itemUserBackArray[userId] = arenaBackItem
    local tempArray = self.popUp.arenaProxy.allRankGeneralArray[userId]
    -- table.sort(tempArray,sortOnGrade)
    arenaBackItem:refreshItemData(tempArray,self:getUserArenaVO(userId))
    arenaBackItem:setVisible(false)
   self:CardFlipFront(userId)
end

function ArenaLayer:getUserArenaVO(userId)
    for key,userVO in pairs(self.popUp.arenaProxy.userArenaArray) do
        if userVO.UserId == userId then
            return userVO
        end
    end
end

function ArenaLayer:onClickFrontTap(place,userId)
    if self.itemUserBackArray[userId] then
        self:CardFlipFront(userId)
        return 
    end
    sendMessage(16,6,{UserId = userId})
end

function ArenaLayer:CardFlipFront(userId)
    Tweenlite:CardFlip(self.itemUserFrontArray[userId],self.itemUserBackArray[userId],0.5)
end

function ArenaLayer:onClickBackTap(userId)
    Tweenlite:CardFlip(self.itemUserBackArray[userId],self.itemUserFrontArray[userId],0.5)
end

function ArenaLayer:shangchengTap(event)
    self.popUp:dispatchEvent(Event.new("TO_SHOP_TWO",nil,self));
end

function ArenaLayer:removeLoopTimer()
    if self.loopTimeFun then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.loopTimeFun);
        self.loopTimeFun = nil
    end
end

function ArenaLayer:refreshDefData()
    local arenaProxy = self.popUp.arenaProxy
    local heroHouseProxy = self.popUp.heroHouseProxy
    local mainGeneral =  heroHouseProxy:getMainGeneral()
    self.zhanli = 0
    self.zhanli = self.zhanli + heroHouseProxy:getZongZhanli(mainGeneral.GeneralId)

    for key,value  in pairs(arenaProxy.generalIdArray) do
        self.zhanli = self.zhanli + heroHouseProxy:getZongZhanli(value.GeneralId)
    end
    self.zhanli = math.floor(self.zhanli)
    self.zlNumText:setString(self.zhanli)
end

function ArenaLayer:refreshMyTeam()
    local arenaProxy = self.popUp.arenaProxy
    local heroHouseProxy = self.popUp.heroHouseProxy
    local mainGeneral =  heroHouseProxy:getMainGeneral()
    self.zhanli = self.zhanli + heroHouseProxy:getZongZhanli(mainGeneral.GeneralId)
    local artId = analysis("Zhujiao_Zhujiaozhiye",self.popUp.userProxy:getCareer(),"art3")
    mainGeneral.IsMainGeneral = 1
    local heroRoundPortrait = HeroRoundPortrait.new();
    heroRoundPortrait:initialize(mainGeneral);
    heroRoundPortrait:setScale(0.95);
    heroRoundPortrait:setPositionXY(self.headiconP.x,self.headiconP.y)
    self:addChild(heroRoundPortrait)

    for key,value  in pairs(arenaProxy.generalIdArray) do
        self.zhanli = self.zhanli + heroHouseProxy:getZongZhanli(value.GeneralId)
    end
    self.zhanli = math.floor(self.zhanli)
    self.zlNumText:setString(self.zhanli)
    hecDC(3,16,1,{noun = arenaProxy.ranking, heroID = self.popUp.userProxy:getUserID(), heroforce = self.zhanli})
end

function ArenaLayer:refreshTimesData()
    local string = self.popUp.countProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    local string1 = self.popUp.countProxy:getJibencishu(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
    self.timesNumText:setString(string.."/"..string1);
    local twoColorNum = string == 0 and 6 or 2;
    local color = CommonUtils:ccc3FromUInt(getColorByQuality(twoColorNum));
    self.timesNumText:setColor(color);
    self:refreshButtonState()
end

function ArenaLayer:refreshTimeData(flag)
    if not self.popUp.arenaProxy.timeValue then return end
    if not self.des3Text then return end
    if self.buttonState == 3 or self.buttonState == 1 then return end
    if not flag and self.popUp.arenaProxy.timeValue == 0 then return end
    if flag and self.popUp.arenaProxy.timeValue == 0 then
        if self.cdTimeListener then
            self.cdTimeListener:setTotalTime(self.popUp.arenaProxy.timeValue,3)
            self.cdTimeListener:dispose();
            self.des3Text:setString(self.cdTimeListener:getTimeStr());
            self.cdTimeListener = nil
        end
        self:addRefreshButtonState()
        return
    end
    local function cdTimeFun()
          if self.cdTimeListener.totalTime <= 0 then
              self.cdTimeListener:dispose();
              self.des3Text:setString(self.cdTimeListener:getTimeStr());
              self.cdTimeListener = nil
              self:addRefreshButtonState()
          else
              self.des3Text:setString(self.cdTimeListener:getTimeStr());
          end
    end

    if self.cdTimeListener == nil then
        self.cdTimeListener = RefreshTime.new();
        self.cdTimeListener:initTime(self.popUp.arenaProxy.timeValue, cdTimeFun,nil,3);
    else
        self.cdTimeListener:setTotalTime(self.popUp.arenaProxy.timeValue,3)
    end
end

function ArenaLayer:removeLayerData()
    for key,value in pairs(self.itemArray) do
        value.parent:removeChild(value)
    end
    self.itemArray = {}
    self.zhanli = 0
end

function ArenaLayer:removeLayerUserData()
    for key,value in pairs(self.itemUserFrontArray) do
        value.parent:removeChild(value)
    end
    self.itemUserFrontArray = {}
    for key,value in pairs(self.itemUserBackArray) do
        value.parent:removeChild(value)
    end
    self.itemUserBackArray = {}
end