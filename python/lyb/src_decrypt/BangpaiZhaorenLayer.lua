BangpaiZhaorenLayer=class(TouchLayer);

function BangpaiZhaorenLayer:ctor()
  self.class=BangpaiZhaorenLayer;
end

function BangpaiZhaorenLayer:dispose()
  self:refreshHuoyueduHongdian();
  self:removeAllEventListeners();
  self:removeChildren();
	BangpaiZhaorenLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

function BangpaiZhaorenLayer:refreshHuoyueduHongdian()
  print("BangpaiZhaorenLayer:refreshHuoyueduHongdian================",self.items and 0 < table.getn(self.items));
  if self.items and 0 < table.getn(self.items) then
    self.heroHouseProxy.Hongidan_Shenqingdu = 1;
  else
    self.heroHouseProxy.Hongidan_Shenqingdu = nil;
  end
  require "main.controller.command.family.BangpaiRedDotRefreshCommand";
  BangpaiRedDotRefreshCommand.new():execute();
end

--
function BangpaiZhaorenLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
  
  --骨骼
  local armature=self.skeleton:buildArmature("zhaoren_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  --title_1
  local text_data=armature:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"帮众名字");
  self.armature:addChild(self.title_1);

  text_data=armature:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"个人战力");
  self.armature:addChild(self.title_2);

  text_data=armature:getBone("title_3").textData;
  self.title_3=createTextFieldWithTextData(text_data,"操作");
  self.armature:addChild(self.title_3);

  initializeSmallLoading();
  sendMessage(27,5);
end

function BangpaiZhaorenLayer:refreshFamilyApplierArray(applierArray)
  if 0 == table.getn(applierArray) then
    local textField = TextField.new(CCLabelTTF:create("现在没有人申请哦",FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(218,200,161));
    textField:setPositionXY(150+640-textField:getContentSize().width/2, -75+360-textField:getContentSize().height/2);
    self:addChild(textField);
    return;
  end

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(makePoint(403,60));
  self.item_layer:setViewSize(makeSize(770,400));
  self.item_layer:setItemSize(makeSize(770,97));
  self.armature:addChild(self.item_layer);

  self.items={};
  local function sf(a, b)
    if a.Level > b.Level then
      return true;
    elseif a.Level < b.Level then
      return false;
    end
    return a.Ranking < b.Ranking;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
  end
  table.sort(applierArray, sf);
  for k,v in pairs(applierArray) do
    local item=BangpaiZhaorenItemLayer.new();
    item:initialize(self.context,self,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
end

function BangpaiZhaorenLayer:deleteItem(userId)
  for k,v in pairs(self.items) do
    if userId == v.data.UserId then
      self.item_layer:removeItemAt(-1+k,true);
      table.remove(self.items,k);
      break;
    end
  end
  self:refreshHuoyueduHongdian();
end

function BangpaiZhaorenLayer:deleteItemAll(tongyi)
  if 0 < table.getn(self.items) then
    sendMessage(27,6,{UserId = 0, BooleanValue = tongyi and 1 or 0});
    self.item_layer:removeAllItems(true);
    self.items = {};
  end
  self:refreshHuoyueduHongdian();
end