--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

HeroSkillPopup=class(LayerPopableDirect);

function HeroSkillPopup:ctor()
  self.class=HeroSkillPopup;
end

function HeroSkillPopup:dispose()
	HeroSkillPopup.superclass.dispose(self);
  -- self.removeArmature:dispose();
end

function HeroSkillPopup:onDataInit()
  -- local proxyRetriever=ProxyRetriever.new();
  -- self.strengthenProxy=proxyRetriever:retrieveProxy(StrengthenProxy.name);--获取数据
  self.skeleton = getSkeletonByName("hero_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(false);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeleton,"heroPro_ui");
  self:setLayerPopableData(layerPopableData);
end

function HeroSkillPopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function HeroSkillPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  print("==================================");
  
  -- local armature=self.skeleton:buildArmature("heroPro_ui");
  -- armature.animation:gotoAndPlay("f1");
  -- armature:updateBonesZ();
  -- armature:update();
  -- self.removeArmature = armature;
  -- --应该归于基类

  -- armature=armature.display;
  -- self.armature=armature;
  -- armature.touchEnabled=true;
  -- self:addChild(armature);

  self:setContentSize(makeSize(1280,720));  

  -- self.strengthenAndStarAdd_item=armature:getChildByName("strengthenAndStarAdd_item");
  -- self.forge_item=armature:getChildByName("forge_item");
  -- armature:removeChild(self.forge_item,false);
  
  -- local closeButton=armature:getChildByName("common_copy_close_button");
  -- local closeButton_pos=convertBone2LB4Button(closeButton);--closeButton:getPositionX(),closeButton:getPositionY();
  -- armature:removeChild(closeButton);
  
  -- -- --closeButton
  -- closeButton=CommonButton.new();
  -- closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  -- closeButton:setPosition(closeButton_pos);
  -- closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  -- self:addChild(closeButton);
  -- self.closeButton=closeButton;
  
  

  -- self:onTabButtonTap(self.tab_buttons[1]);
end

function HeroSkillPopup:onUIInit()
  CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
  -- kCCDirectorProjection2D


  -- for i = 40,1,-1 do
  --   local card = getImageByFlaObjName(self.skeleton,"hero_card_ui","hero_card");
  --   self:addChild(card);
  --   card:setAnchorPoint(ccp(0.5,0.5));
  --   Tweenlite:flip(card,0,normalDu);
  --   if i == 1 then
  --     card:setPositionX(centerLineX);
  --     Tweenlite:removeFlip(card,0);
  --   else
  --     card:setPositionX(rightLineX + space*(i - 2));
  --     card:setScale(0.7 - 0.015*i);
  --     -- card:setScale(0.7);
  --   end;
  --   card:setPositionY(GameConfig.STAGE_HEIGHT/2);
  --   table.insert(self.cardTb, card);
  --   table.insert(self.cardPos, card:getPositionX());
  -- end  

  -- self:addEventListener(DisplayEvents.kTouchBegin,self.onSlidTap1,self);
  -- self:addEventListener(DisplayEvents.kTouchMove,self.onSlidTap2,self);
  -- self:addEventListener(DisplayEvents.kTouchEnd,self.onSlidTap3,self);
end

function HeroSkillPopup:onRequestedData()

end

function LayerPopable:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end