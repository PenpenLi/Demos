require "main.view.bag.ui.bagPopup.BagItem"
require "main.view.quickBattle.ui.MopUpResultUI";
QuickBattlePopup=class(LayerPopableDirect);

function QuickBattlePopup:ctor()
  self.class=QuickBattlePopup;
  self.FinishCountArray = nil;
end

function QuickBattlePopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  QuickBattlePopup.superclass.dispose(self);
  self.armature:dispose()

  BitmapCacher:removeUnused();
end
function QuickBattlePopup:onDataInit()

  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name)

  self.skeleton = self.storyLineProxy:getSkeleton();

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setVisibleDelegate(false)
  layerPopableData:setShowCurrency(true);
  layerPopableData:setArmatureInitParam(self.skeleton,"mopUp_ui");
  self:setLayerPopableData(layerPopableData);

end

function QuickBattlePopup:onUIInit()

end

function QuickBattlePopup:onPrePop()

  local armature_dSize =  self.armature.display:getGroupBounds().size
  print("armature_dSize.width", armature_dSize.width)
  self.armature_d_x = (self.mainSize.width - armature_dSize.width)/2
  self.armature_d_y = (self.mainSize.height - armature_dSize.height)/2
  self.armature.display:setPositionXY(self.armature_d_x, self.armature_d_y)

  local strongPointNameTextData = self.armature:getBone("strongPointName_txt").textData;
  self.strongPointName = createTextFieldWithTextData(strongPointNameTextData, self.strongPointPo.scenarioName);
  self.armature.display:addChild(self.strongPointName);  

  local cost_descTextData = self.armature:getBone("cost_desc_txt").textData;
  self.cost_desc = createTextFieldWithTextData(cost_descTextData, "每次消耗:");
  self.armature.display:addChild(self.cost_desc);   

  local cost_valueTextData = self.armature:getBone("cost_value_txt").textData;
  self.cost_value = createTextFieldWithTextData(cost_valueTextData, self.strongPointPo.depletion);
  self.armature.display:addChild(self.cost_value); 

  local common_copy_tili_bg = self.armature.display:getChildByName("common_copy_tili_bg")

  local passCount_descTextData = self.armature:getBone("passCount_desc_txt").textData;
  self.passCount_desc =  createTextFieldWithTextData(passCount_descTextData, '关卡次数: ' .. (self.strongPointPo.cishu - self.count) ..  '/' .. self.strongPointPo.cishu);
  self.armature.display:addChild(self.passCount_desc);  
 

  self.curItemCount = self.bagProxy:getItemNum(1015003);
  local saoDangQuan_txtData = self.armature:getBone("saoDangQuan_txt").textData;
  self.saoDangQuan_txt =  createTextFieldWithTextData(saoDangQuan_txtData, '剩余扫荡券: ' .. self.curItemCount);
  self.armature.display:addChild(self.saoDangQuan_txt);  

   if self.strongPointPo.Gtype == 1 then
      self.passCount_desc:setVisible(false) 
      self.cost_desc:setPositionXY(self.cost_desc:getPositionX(), self.cost_desc:getPositionY() + 24);
      self.cost_value:setPositionXY(self.cost_value:getPositionX(), self.cost_value:getPositionY() + 24);
      common_copy_tili_bg:setPositionXY(common_copy_tili_bg:getPositionX(), common_copy_tili_bg:getPositionY() + 24);

      self.saoDangQuan_txt:setPositionXY(self.saoDangQuan_txt:getPositionX(), self.saoDangQuan_txt:getPositionY() + 24)
   else
      self.passCount_desc:setVisible(true) 
   end


  local textArm = self.armature:findChildArmature("mopUp1_button");
  local trimButtonData=textArm:getBone("common_small_blue_button").textData;

  --mopUp1_button
  local mopUp1_button = self.armature.display:getChildByName("mopUp1_button")
  local mopUp_buttonPos = convertBone2LB4Button(mopUp1_button);
  self.armature.display:removeChild(mopUp1_button);
  
  mopUp1_button = CommonButton.new();
  mopUp1_button:initialize("common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  mopUp1_button:setPosition(mopUp_buttonPos);
  mopUp1_button:addEventListener(DisplayEvents.kTouchTap,self.onMopUpTap,self);
  self.mopUp1_button = mopUp1_button;
  self.armature.display:addChild(mopUp1_button);
  mopUp1_button:initializeText(trimButtonData, "扫荡1次", true);

  --mopUp10_button
  local mopUp10_button = self.armature.display:getChildByName("mopUp10_button");
  local mopUp10_buttonPos = convertBone2LB4Button(mopUp10_button);
  self.armature.display:removeChild(mopUp10_button);
  
  mopUp10_button = CommonButton.new();
  mopUp10_button:initialize("common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  mopUp10_button:setPosition(mopUp10_buttonPos);
  mopUp10_button:addEventListener(DisplayEvents.kTouchTap,self.onMopUp10Tap,self);
  self.armature.display:addChild(mopUp10_button);
  self.mopUp10_button = mopUp10_button;

  -- local leftCount = self:getLeftCountByStrongPoint();
  -- leftCount = leftCount <= 10 and leftCount or 10;
  -- leftCount = math.min(self.curItemCount, leftCount);
  -- leftCount = math.max(leftCount, 1)
  -- mopUp10_button:initializeText(trimButtonData, "扫荡" .. leftCount .. "次", true);


  local mopContent
  if self.strongPointPo.Gtype == 2 then
    mopContent = "扫荡3次"
  else
    mopContent = "扫荡10次"
  end 
  mopUp10_button:initializeText(trimButtonData, mopContent, true);

  print("onDataInit()+++++++++++++++++++++++++++++++++++++++++++++++++++")

end
function QuickBattlePopup:initialize()
  self:initLayer();
  
  self.mainSize = Director:sharedDirector():getWinSize();

  local layerColor = LayerColor.new();
  layerColor:initLayer();
  layerColor:changeWidthAndHeight(self.mainSize.width, self.mainSize.height);
  layerColor:setColor(ccc3(0,0,0));
  layerColor:setOpacity(150);
  self:addChild(layerColor)

  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));


end
function QuickBattlePopup:refreshCount(count, saoDangQuanCount)
   self.count = count;


  print("saoDangQuanCount", saoDangQuanCount)
  if saoDangQuanCount ~= 0 then
    self.curItemCount = self.curItemCount + saoDangQuanCount;
    if self.curItemCount < 0 then
      self.curItemCount = 0;
    end
    self.saoDangQuan_txt:setString("剩余扫荡券：" .. self.curItemCount)
  else
    if self.curItemCount == 0 then
      self.saoDangQuan_txt:setString("剩余扫荡券：" .. saoDangQuanCount + 1)  
    else
      self.saoDangQuan_txt:setString("剩余扫荡券：" .. self.curItemCount)  
    end
  end


   local leftCount = self:getLeftCountByStrongPoint()

   print("+++++++++++++++++++++++++++leftCount", leftCount)
   if leftCount > 0 then
     self.passCount_desc:setString('关卡次数: ' .. leftCount .. "/" .. self.strongPointPo.cishu);
     -- if leftCount < 1 then
     --   leftCount = 1;
     -- elseif leftCount > 10 then
     --   leftCount = 10
     -- end
     -- leftCount = math.min(self.curItemCount, leftCount);
     -- leftCount = math.max(leftCount, 1)
     -- self.mopUp10_button:setString("扫荡" .. leftCount .. "次");
   else
     self.passCount_desc:setString('关卡次数: 0/' .. self.strongPointPo.cishu);
     self.passCount_desc:setColor(CommonUtils:ccc3FromUInt(16711680));
     -- self:closeUI();
   end
end

function QuickBattlePopup:refreshTili()
   self.cost_value:setString(self.strongPointPo.depletion)
   if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
     self.cost_value:setColor(CommonUtils:ccc3FromUInt(16711680));
   else
    self.cost_value:setColor(CommonUtils:ccc3FromUInt(6756622));   
   end
end
function QuickBattlePopup:initData(data)

  self.strongPointId = data.StrongPointId;
  self.count = data.Count;
  self.strongPointPo = analysis("Juqing_Guanka", self.strongPointId)

  print("==================strongPointId", strongPointId)
end
--  <param main="7" sub="58" desc="请求  扫荡">Count</param>
--扫荡10次
function QuickBattlePopup:onMopUp10Tap(event)
    if self.bagProxy:getBagIsFull() then
      sharedTextAnimateReward():animateStartByString("背包已满清理一下吧");
    else
      local vipLevel=0;
      while 15 > vipLevel do
        vipLevel = 1 + vipLevel;
        if 0 < analysis("Huiyuan_Huiyuantequan",6,"vip" .. vipLevel) then
          break;
        end
      end

      if self.userProxy.vipLevel < vipLevel then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_512, {vipLevel}));
      else
        local result = self:checkLeftCountType();

        if result == 1 then
          local maxCount = math.floor(self.userCurrencyProxy.tili/self.strongPointPo.depletion);
          local count = self:getLeftCountByStrongPoint()
          if self.strongPointPo.Gtype == 2 then
            maxCount = math.min(maxCount, count, 3)
          else
            maxCount = math.min(maxCount, count, 10)
          end

          local itemPrice = self:getItemPrice();
          local function onConfirm()
            if self.curItemCount < 1 and self.userCurrencyProxy.gold < itemPrice then
              sharedTextAnimateReward():animateStartByString("元宝不足~");
              self:dispatchEvent(Event.new("gotochongzhi",nil,self));
            else

              if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
                self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
              else
                if self.curItemCount > 0 then
                  maxCount = math.min(maxCount, self.curItemCount)
                end
                self:popUpAndSendMessage(maxCount)
              end
            end
          end

          local tipsStr = ""
          if self.curItemCount < 1 then
            tipsStr = "扫荡券不足，是否花费" .. (itemPrice * maxCount) .. "元宝直接购买?"
            local tips=CommonPopup.new();
            tips:initialize(tipsStr,self,onConfirm,nil,noToBuy,nil,nil,nil,nil,true);
            tips:setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
            self:addChild(tips)
          else
            onConfirm()
          end
        elseif result == 2 then
          sharedTextAnimateReward():animateStartByString("次数不足哦~");
        elseif result == 3 then  		
          onHandleAddTili({type = 1});
        end
      end
    end
end

function QuickBattlePopup:checkLeftCountType()
    local leftCount = self:getLeftCountByStrongPoint()
  	if  leftCount > 0 and self.userCurrencyProxy.tili >= self.strongPointPo.depletion then
  		return 1
  	elseif  leftCount <= 0 then
  		return 2;
    elseif  self.userCurrencyProxy.tili < self.strongPointPo.depletion then
      return 3;
  	end
end
--  <param main="7" sub="58" desc="请求  扫荡">Count</param>
--扫荡
function QuickBattlePopup:onMopUpTap(event)

    if self.bagProxy:getBagIsFull() then
      sharedTextAnimateReward():animateStartByString("背包已满清理一下吧");
    else
      -- local vipLevel=0;
      -- while 15>vipLevel do
      --   vipLevel=1+vipLevel;
      --   if 0<analysis("Huiyuan_Huiyuantequan",13,"vip" .. vipLevel) then
      --     break;
      --   end
      -- end

      -- if self.userProxy.vipLevel < vipLevel then
      --   sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_512, {vipLevel}));
      -- else
        -- local state = self.storyLineProxy:getStrongPointState(self.strongPointId)
        
        -- if state == GameConfig.STRONG_POINT_STATE_2 then--3表示未开启
        --    sharedTextAnimateReward():animateStartByString("关卡尚未开启！");
        --    return;
        -- elseif state == GameConfig.STRONG_POINT_STATE_3 then --3表示未完成，并且能进入
        --    sharedTextAnimateReward():animateStartByString("关卡尚未通关！");
        --    return;
        -- end


        local result = self:checkLeftCountType();
        if result == 1 then

          local itemPrice = self:getItemPrice();
          local function onConfirm()
            if self.curItemCount < 1 and self.userCurrencyProxy.gold < itemPrice then
              sharedTextAnimateReward():animateStartByString("元宝不足~");
              self:dispatchEvent(Event.new("gotochongzhi",nil,self));
            else
              if self.userCurrencyProxy.tili < self.strongPointPo.depletion then
                self:dispatchEvent(Event.new("ON_ADD_TILI",nil,self));
              else
                self:popUpAndSendMessage(1)
              end
            end
          end

          local tipsStr = ""
          if self.curItemCount < 1 then
            tipsStr = "扫荡券不足，是否花费" .. itemPrice .. "元宝直接购买?"
            local tips=CommonPopup.new();
            tips:initialize(tipsStr,self,onConfirm,nil,noToBuy,nil,nil,nil,nil,true);
            tips:setPositionXY(GameData.uiOffsetX * -1,GameData.uiOffsetY * -1)
            self:addChild(tips)
          else
            onConfirm()
          end
        elseif result == 2 then
          sharedTextAnimateReward():animateStartByString("次数不足哦~");
        elseif result == 3 then
          onHandleAddTili({type = 1});
        end
      -- end
    end
end
function QuickBattlePopup:getItemPrice()
  local shopItems = analysisByName("Shangdian_Shangdianwupin", "itemid", 1015003);
  for k, v in pairs(shopItems)do
    if v.type == 3 then
      return v.price;
    end
  end
end
function QuickBattlePopup:popUpAndSendMessage(count)

    if self.strongPointPo.type == 2 then
      local extensionTable = {}
      extensionTable["yingxiongzhiID"] = self.strongPointId
      hecDC(3,30,2,extensionTable)
    end
    print("count", count)
    sendMessage(7, 58, {StrongPointId = self.strongPointId, Count = count})

    self.mopUpResultUI = MopUpResultUI.new();
    self.mopUpResultUI:initializeUI(self.storyLineProxy:getSkeleton(), self)
    self:addChild(self.mopUpResultUI);
end

function QuickBattlePopup:refreshData(RoundItemIdArray, StrongPointId)
  self.mopUpResultUI:refreshData(RoundItemIdArray, StrongPointId)
end

function QuickBattlePopup:getLeftCountByStrongPoint()
  local result;
  if self.strongPointPo.Gtype == 1 then
    result = 10;
  else
    result = self.strongPointPo.cishu - self.count
  end
  -- result = math.min(result, self.curItemCount);
  return result;
end

function QuickBattlePopup:onUIClose()

  local closeEvent = Event.new("STRONGPOINT_CLOSE", nil, self);
  self:dispatchEvent(closeEvent);
end
function QuickBattlePopup:mopUpOver()
    if self.mopUpResultUI then
       self.mopUpResultUI:setMopUpOver()
    end
    sharedTextAnimateReward():animateStartByString("扫荡结束了~");
end