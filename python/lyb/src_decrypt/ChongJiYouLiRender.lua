
ChongJiYouLiRender=class(TouchLayer);

function ChongJiYouLiRender:ctor()
  self.class=ChongJiYouLiRender;
end

function ChongJiYouLiRender:dispose()
  self:removeAllEventListeners();
  ChongJiYouLiRender.superclass.dispose(self);
end

function ChongJiYouLiRender:initialize(context,data)
  self.data=data
  self.context=context
  self.bagProxy = context.bagProxy;
  self:initLayer();
  self.skeleton = context.skeleton
  local armature= self.skeleton:buildArmature("render");

  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);
  
  local textContent = analysis("Huodong_Yunyinghuodongtiaojian", data.Type, "miaoshu");
  textContent = StringUtils:stuff_string_replace(textContent, "@1", data.Param1, 2);

  self.target=createMultiColoredLabelWithTextData(armature:getBone("target").textData, textContent);
  armature_d:addChild(self.target)
 
  self:initItem();
  self:initButton();
end
function ChongJiYouLiRender:initButton(  )
  self.award1 = self.armature_d:getChildByName("award1");
  local btnData=self.armature:findChildArmature("btn"):getBone("common_small_blue_button").textData;
  print("btnData = ", btnData);
  local btn = self.armature_d:getChildByName("btn");
  local btn_pos = convertBone2LB4Button(btn);
  self.armature_d:removeChild(btn);
  self.btn = CommonButton.new();
  self.btn:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
  self.btn:initializeText(btnData, "领取", true);
  self.btn:setPosition(btn_pos);
  self.btn:addEventListener(DisplayEvents.kTouchTap, self.onClickBtn, self);

  print(" data = ", self.data.BooleanValue, self.data.Count, self.data.MaxCount, self.data.ConditionID);
  if self.data.BooleanValue == 1 then
    self.award1:setVisible(false);
    self.btn:setGray(true);
    self.btn:refreshText("已领取")
  elseif self.data.Count >= self.data.MaxCount then
    self.btn:setGray(false);
    self.btn:refreshText("领取")
    self.award1:setVisible(false);
   elseif self.data.Count < self.data.MaxCount then
    self.award1:setVisible(true);
    self.btn:setVisible(false);
  end
  self.armature_d:addChild(self.btn); 
end



function ChongJiYouLiRender:initItem()
  self.item = {};
  for i=1,3 do
    local item = self.armature_d:getChildByName("item"..i);
    local item_pos = convertBone2LB(item);
    self.armature_d:removeChild(item);
    item =  CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
    item:setScale(0.9);
    item:setPosition(item_pos);
    self.armature_d:addChild(item);
    item:setVisible(false);
    self.item[i] = {item =  item, item_pos = item_pos};
  end

  self.itemImage = {};
  for k,v in pairs(self.data.ItemIdArray) do
    self.item[k].item:setVisible(true);
    local itemImage = BagItem.new();
    itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
    itemImage:setScale(0.9);
    itemImage:setPositionXY(self.item[k].item_pos.x + 6, self.item[k].item_pos.y + 6);
    self.armature_d:addChild(itemImage);
    itemImage.touchEnabled = true;
    itemImage.touchChildren = true;
    itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);
    itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTipEnd, self);
  end
end


function ChongJiYouLiRender:onClickBtn(event)

  -- self.bagProxy:self.bagProxy = context.bagProxy;
  local bagstate = self.context.context:getBagState(#self.data.ItemIdArray);
  if bagstate == false then
    return;
  end
  self.context:takeAward(self.data.ConditionID);
  sendMessage(29,3,{ConditionID=self.data.ConditionID})
 
end

function ChongJiYouLiRender:onItemTip(event)
  self.tapitembegin=event.globalPosition
end

function ChongJiYouLiRender:onItemTipEnd(event)
  if self.tapitembegin and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    self.context.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
  end
end