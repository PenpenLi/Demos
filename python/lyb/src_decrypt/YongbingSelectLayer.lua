require "main.view.hero.heroTeam.ui.HeroTeamPageView"

YongbingSelectLayer=class(Layer);

function YongbingSelectLayer:ctor()
  self.class=YongbingSelectLayer;
end

function YongbingSelectLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  YongbingSelectLayer.superclass.dispose(self);
  self.armature:dispose();
end

--intialize UI
function YongbingSelectLayer:initialize(context)
  self:initLayer();
  self.context = context;
  self.skeleton = self.context.skeleton;
  self.heroHouseProxy = self.context.heroHouseProxy;
  self.familyProxy = self.context.familyProxy;
  --self.datas = self.heroHouseProxy:getGeneralArrayWithPlayer();
  self.datas = self.familyProxy:getYongbingData4Paiqian();
  self.generalIDs = {};

  local bg=LayerColorBackGround:getOpacityBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self:addChild(bg);

  local armature=self.skeleton:buildArmature("select_layer");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self.armature.display:setPositionXY(400,50);
  self:addChild(self.armature.display);

  self.armature.display:getChildByName("common_copy_line_horizon"):setScale(0.75);
  local text_data=self.armature:getBone("common_copy_line_horizon").textData;

  self.descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.descb);

  self.pageView = HeroTeamPageView:create(self,self.onCardTap,3);
  self.pageView:setPositionXY(20, -400);
  self.armature.display:addChild(self.pageView);

  local button=self.armature.display:getChildByName("btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("确定","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onConfirm,self);
  self.armature.display:addChild(button);
end

function YongbingSelectLayer:onSelfTap(event)
  self.parent:removeChild(self);
end

function YongbingSelectLayer:onConfirm(event)
  if self.generalIDs[1] then
    initializeSmallLoading();
    sendMessage(27,40,{GeneralId = self.generalIDs[1]});
    hecDC(3,24,1,{heroID = self.generalIDs[1]});
  end
  self:onSelfTap(event);
end

function YongbingSelectLayer:onCardTap(items)
  self.generalIDs = {items.GeneralId};
  self.pageView:setIsPlayImg();
end

function YongbingSelectLayer:getIsPlayByGeneralID(generalID)
  for k,v in pairs(self.generalIDs) do
    if generalID == v then
      return true;
    end
  end
  return false;
end