require "main.view.family.ui.familyBanquet.FamilyHoldBanquetItem"
require "main.model.UserProxy"


FamilyHoldBanquetPopup=class(LayerPopableDirect);

function FamilyHoldBanquetPopup:ctor()
  self.class=FamilyHoldBanquetPopup;
end
function FamilyHoldBanquetPopup:dispose()
  FamilyHoldBanquetPopup.superclass.dispose(self);
end


function FamilyHoldBanquetPopup:onDataInit()

  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);

  self.skeleton = self.familyProxy:getBanquetSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setShowCurrency(true);
  layerPopableData:setArmatureInitParam(self.skeleton,"hold_banquet_panel_ui")
  self:setLayerPopableData(layerPopableData)
  MusicUtils:playEffect(7,false)
end


function FamilyHoldBanquetPopup:initialize()

  self:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(1280, 720));

end

--后执行
function FamilyHoldBanquetPopup:onPrePop()

  local armature_d=self.armature.display;

  local text_data = self.armature:getBone("tieshi_word_txt").textData;
  self.tieshiText = createTextFieldWithTextData(text_data,"琅琊小贴士 :举办宴会可获得稀有的魂石，参加宴会将获得体力", true);
  self:addChild(self.tieshiText);
  
  for i,v in ipairs(self.countControlProxy.data) do
    if v.ID == 11 then 
      self.jubanCount = v.TotalCount - v.CurrentCount;
    end
  end
  local text_data = self.armature:getBone("shengyu_value_txt").textData;
  self.cjnText = createTextFieldWithTextData(text_data,"剩余："..self.jubanCount.."次",true);
  self:addChild(self.cjnText);

  self.askButton =armature_d:getChildByName("ask_button");
  SingleButton:create(self.askButton);
  self.askButton:addEventListener(DisplayEvents.kTouchTap, self.askTap, self);

  BANQUETTYPE = {"SIREN_YANHUI", "LIUREN_YANHUI", "QUANBANG_YANHUI"}
  
  for i = 1, table.getn(BANQUETTYPE) do
    local familyHoldBanquetItem = FamilyHoldBanquetItem.new();
    familyHoldBanquetItem:initialize(self, {banquetType = BANQUETTYPE[i], index = i});
    local x = 140+(i-1)%3*342;
    local y = 100
    familyHoldBanquetItem:setPosition(ccp(x, y))
    self:addChild(familyHoldBanquetItem);
  end


end


-- function FamilyHoldBanquetPopup:refreshjuBanCount()
--     for i,v in ipairs(self.countControlProxy.data) do
--     if v.ID == 11 then 
--       self.jubanCount = v.TotalCount - v.CurrentCount;
--       self.cjnText:setString("剩余："..self.jubanCount.."次";
--     end
--   end
-- end

function FamilyHoldBanquetPopup:askTap(event)
    local functionStr = analysis("Tishi_Guizemiaoshu",14,"txt");
  
    TipsUtil:showTips(event.target,functionStr,nil,0);
end

function FamilyHoldBanquetPopup:entetrBanquetByNotification(index)
  
  if #self.familyProxy.BanquetInfoArray >= 3 then
      sharedTextAnimateReward():animateStartByString("帮派同时最多只能办3场酒宴哦！");
      return;
  end

  if self.jubanCount >= 1 then
    if self.bagProxy:getBagIsFull() == false then
      initializeSmallLoading();
      self:dispatchEvent(Event.new("FamilyHoldBanquetEnterBanquet",index,self));
      sendMessage(27, 34, {Type = index.Type})
      if index.Type == 3 then
        self:closeUI();
      end
    else
      sharedTextAnimateReward():animateStartByString("背包已满，无法举办哦！");
    end
    

  else
    sharedTextAnimateReward():animateStartByString("您的举办次数不够！");
  end
  
end

function FamilyHoldBanquetPopup:onUIClose()
  self:dispatchEvent(Event.new("FamilyHoldBanquetClose",nil,self));
end


-- function FamilyHoldBanquetPopup:refreshHoldCount(count)
--     self.cjnText:setString("剩余："..tostring(count).."次")
-- end

function FamilyHoldBanquetPopup:gotoChongZhi()
  self:dispatchEvent(Event.new("FamilyHoldBanquetToChongZhi",nil,self));
end