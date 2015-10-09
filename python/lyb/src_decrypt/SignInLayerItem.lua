--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

SignInLayerItem=class(TouchLayer);

function SignInLayerItem:ctor()
  self.class=SignInLayerItem;
end

function SignInLayerItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	SignInLayerItem.superclass.dispose(self);
end

function SignInLayerItem:initialize(skeleton, activityProxy, countControlProxy, bone, place, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.activityProxy=activityProxy;
  self.countControlProxy=countControlProxy;
  self.bone=bone;
  self.place=place;
  self.parent_container=parent_container;
  self.id=0;

  local pos=convertBone2LB(bone);
  local size=bone:getContentSize();
  self:setPositionXY(size.width/2+pos.x,size.height/2+pos.y);
  self.bone:setPositionXY(-size.width/2,size.height/2);
  self.bone.parent:removeChild(self.bone,false);
  self:addChild(self.bone);

  local a={"每","天","可","以","翻","一","张","牌","哟","!","每","一","行","全","部","翻","开","都","可","以","获","得","额","外","奖","励","噢","!"};
  local textField=TextField.new(CCLabelTTF:create(a[self.place],FontConstConfig.OUR_FONT,24));
  local sizeText=textField:getContentSize();
  textField:setColor(CommonUtils:ccc3FromUInt(3280640));
  textField:setPositionXY(math.floor(-sizeText.width/2),math.floor(-sizeText.height/2));
  self:addChild(textField);
end

function SignInLayerItem:onItemTap(event)
  if not self.bagItem then
    return;
  end
  self.parent_container:popTip(self.bagItem:getItemData().ItemId,self.bagItem:getItemData().Count,event.globalPosition);
end

function SignInLayerItem:onSelfTap(event)
  if 0>=self.countControlProxy:getRemainCountByID(CountControlConfig.SIGN_IN_ITEM) then
    sharedTextAnimateReward():animateStartByString("今日已经领取过了哦~");
    return;
  end
  if self.parent_container:onSignInLayerItemTap(self) then

  else
    self:removeEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  end
end

function SignInLayerItem:refresh(request)
  if 0==self.id then
    local a=self.activityProxy:getSignInDataByPlace(self.place);
    if nil==a then
      self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
      return;
    end
    self.id=a.ID;

    if request then
      local sequenceArray = CCArray:create();

      local spawnArray1 = CCArray:create();
      local scaleTo1 = CCScaleTo:create(0.2,0,1);
      spawnArray1:addObject(scaleTo1);
      local action1 = CCSpawn:create(spawnArray1);
      sequenceArray:addObject(action1);

      local function cf()
        self:addChild(self:getItems());
      end
      sequenceArray:addObject(CCCallFunc:create(cf));

      local spawnArray2 = CCArray:create();
      local scaleTo2 = CCScaleTo:create(0.2,1,1);
      spawnArray2:addObject(scaleTo2);
      local action2 = CCSpawn:create(spawnArray2);
      sequenceArray:addObject(action2);
    
      self:runAction(CCSequence:create(sequenceArray));
    else
      self:addChild(self:getItems());
    end
    self:addEventListener(DisplayEvents.kTouchTap,self.onItemTap,self);
  end
end

function SignInLayerItem:getItems()
  local a={};
  a.UserItemId=0;
  a.ItemId=analysis("Huodongbiao_Qiandaofanpai",self.id,"itemId");
  a.Count=analysis("Huodongbiao_Qiandaofanpai",self.id,"amount");
  a.IsBanding=0;
  a.IsUsing=0;
  a.Place=0;
  local b=BagItem.new();
  b:initialize(a);
  b:setPositionXY(ConstConfig.CONST_ACTIVITY_ITEM_SKEW_X+self.bone:getPositionX(),ConstConfig.CONST_ACTIVITY_ITEM_SKEW_Y-self.bone:getContentSize().height+self.bone:getPositionY());
  self.bagItem=b;
  return b;
end

function SignInLayerItem:getID()
  return self.id;
end

function SignInLayerItem:getPlace()
  return self.place;
end