require "main.view.activity.ui.fund.FundSelect";
require "main.view.activity.ui.fund.FundEveryday";


FundPopUp=class(TouchLayer);

local uiArr={"fund_select","fund_everyday","fund_detail_silver","fund_detail_gold"};
function FundPopUp:ctor()
  self.class=FundPopUp;
end

function FundPopUp:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  FundPopUp.superclass.dispose(self);

end

function FundPopUp:initializeUI(skeleton, activityProxy, userCurrencyProxy, userDataAccumulateProxy,userProxy)
  self:initLayer();

  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.userCurrencyProxy = userCurrencyProxy;
  self.userDataAccumulateProxy = userDataAccumulateProxy;
  
  -- local mainSize = Director:sharedDirector():getWinSize();
  -- self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));

  local fundState = self.activityProxy.fundState
  local panel;
  if fundState==0 then      --无基金
    panel=FundSelect.new();
    panel:initializeUI(skeleton, activityProxy, userCurrencyProxy, userDataAccumulateProxy,userProxy)
  elseif fundState==1 then  --银基金
    panel=FundEveryday.new();
    panel:initializeUI(skeleton, fundState, activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  elseif fundState==2 then  --金基金
    panel=FundEveryday.new();
    panel:initializeUI(skeleton, fundState, activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  elseif fundState==3 then  --钻石基金
    panel=FundEveryday.new();
    panel:initializeUI(skeleton, fundState, activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  end
  
  if fundState>0 then
    self.fundEveryday = panel;
  end

  self:addChild(panel);  

  AddUIBackGround(self);
  --AddUIFrame(self); 
end

function FundPopUp:refresh()
  if self.fundEveryday then
    self.fundEveryday:refresh()
  end
end

function FundPopUp:onOpenVIPUI()
  self:dispatchEvent(Event.new("OPEN_VIP_UI",{},self));
end

