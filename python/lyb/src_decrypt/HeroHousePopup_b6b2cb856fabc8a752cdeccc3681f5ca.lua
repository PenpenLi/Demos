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

HeroHousePopup=class(LayerPopableDirect);

function HeroHousePopup:ctor()
  self.class=HeroHousePopup;
  self.cardTb = {};
  self.cardPos = {};
  self.beginX = 0;
  self.endX = 0;
end

function HeroHousePopup:dispose()
	HeroHousePopup.superclass.dispose(self);
  self.removeArmature:dispose();
end

function HeroHousePopup:onDataInit()
  -- local proxyRetriever=ProxyRetriever.new();
  -- self.strengthenProxy=proxyRetriever:retrieveProxy(StrengthenProxy.name);--获取数据
end

function HeroHousePopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function HeroHousePopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);

  print("==================================");
  self.skeleton = getSkeletonByName("heroHouse_ui");
  local armature=self.skeleton:buildArmature("heroHouse_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  --应该归于基类

  armature=armature.display;
  self.armature=armature;
  armature.touchEnabled=true;
  self:addChild(armature);

  self:setContentSize(makeSize(1280,720));  

  -- self.strengthenAndStarAdd_item=armature:getChildByName("strengthenAndStarAdd_item");
  -- self.forge_item=armature:getChildByName("forge_item");
  -- armature:removeChild(self.forge_item,false);
  
  --closeButton
  -- local closeButton=armature:getChildByName("common_copy_close_button");
  -- local closeButton_pos=convertBone2LB4Button(closeButton);--closeButton:getPositionX(),closeButton:getPositionY();
  -- armature:removeChild(closeButton);
  
  -- --closeButton
  -- closeButton=CommonButton.new();
  -- closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
  -- closeButton:setPosition(closeButton_pos);
  -- closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  -- self:addChild(closeButton);
  -- self.closeButton=closeButton;
  
  -- self:onTabButtonTap(self.tab_buttons[1]);
end

local normalWidth = 315;
local smallWidth = normalWidth*0.7;
local leftLineX = -normalWidth/2;
local centerLineX = 100 + normalWidth/2;
local rightLineX = centerLineX + normalWidth + 20;
local space = 80;
local normalDu = 20;
function HeroHousePopup:onUIInit()
  CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
  -- kCCDirectorProjection2D


  for i = 40,1,-1 do
    local card = getImageByFlaObjName(self.skeleton,"hero_card_ui","hero_card");
    self:addChild(card);
    card:setAnchorPoint(ccp(0.5,0.5));
    Tweenlite:flip(card,0,normalDu);
    if i == 1 then
      card:setPositionX(centerLineX);
      Tweenlite:removeFlip(card,0);
    else
      card:setPositionX(rightLineX + space*(i - 2));
      card:setScale(0.7 - 0.015*i);
      -- card:setScale(0.7);
    end;
    card:setPositionY(GameConfig.STAGE_HEIGHT/2);
    table.insert(self.cardTb, card);
    table.insert(self.cardPos, card:getPositionX());
  end  

  self:addEventListener(DisplayEvents.kTouchBegin,self.onSlidTap1,self);
  self:addEventListener(DisplayEvents.kTouchMove,self.onSlidTap2,self);
  self:addEventListener(DisplayEvents.kTouchEnd,self.onSlidTap3,self);
end

--滑动
function HeroHousePopup:onSlidTap1(event)
  self.benginX = event.globalPosition.x;
end
--滑动
local tempW = 300;
-- local curNum = 1;
local direction = "";
function HeroHousePopup:onSlidTap2(event)
  local a = self.benginX - event.globalPosition.x;
  local len = #self.cardTb;
  local w = 0;
  local s = 0;
  for i = 1,len do
    local card = self.cardTb[i];
    if a < 0 then--right
      direction = "right";
      return;
    else--left
      -- if math.abs(a) >= tempW then self:setCardPosLeft(); end;
      direction = "left";
      a = math.mod(math.abs(a),tempW);
      if card:getPositionX() < centerLineX and card:getPositionX() > leftLineX then--left
        w = centerLineX - leftLineX;
        card:setPositionX(self.cardPos[i] - w*(math.abs(a)/tempW));  

        s = 1 - 0.3 * (math.abs(a)/tempW);
        card:setScale(s);      
      elseif card:getPositionX() < rightLineX and card:getPositionX() > centerLineX then--center
        w = rightLineX - centerLineX;
        card:setPositionX(self.cardPos[i] - w*(math.abs(a)/tempW));  

        s = 0.7 + 0.3 * (math.abs(a)/tempW);
        card:setScale(s); 

        Tweenlite:flip(card,0,normalDu*(1 - math.abs(a)/tempW));
      else--right
        card:setPositionX(self.cardPos[i] - space*(math.abs(a)/tempW));  
        
        -- local tempS = 0.7 - 0.015*i;
        -- s = tempS + (1 - tempS) * (math.abs(a)/tempW);
        -- print("tempS:"..tempS.."=====tempS:"..s);
        -- card:setScale(s);
      end;
    end;    
  end;

end

--滑动
function HeroHousePopup:onSlidTap3(event)
  -- local a = event.globalPosition.x - self.benginX;
  -- if direction == "left" then
  --   local a = self.benginX - event.globalPosition.x;
  --   a = math.abs(a);
  --   if math.abs(a)/tempW > 0 then

  --   else

  --   end;
  -- else--right

  -- end;
end

--左移数据更新
function HeroHousePopup:setCardPosLeft()
  self.benginX = 0;
  local len = #self.cardTb;
  local firsX = self.cardTb[1];
  if self.cardTb[1] == centerLineX then
    self.cardTb[1] = leftLineX;
  else
    --continue
  end;
  self.cardTb[1] = firsX;
  for i=len,2,-1 do
    self.cardTb[i] = self.cardTb[i - 1];
    if self.cardTb[i] == centerLineX then
      self.cardPos[i]:setScale(1);
    end;
  end
  

end

function HeroHousePopup:onRequestedData()

end

--移除
function HeroHousePopup:onCloseButtonTap(event)
  --HEROHOUSE_CLOSE
  self:dispatchEvent(Event.new("HEROHOUSE_CLOSE",nil,self));
end
