require "core.controls.page.CommonSlot";

require "main.view.tip.ui.EquipTip"


ShopItemSlot=class(CommonSlot);

function ShopItemSlot:ctor()
  self.class=ShopItemSlot;
end

function ShopItemSlot:dispose()
  self:removeAllEventListeners();
  ShopItemSlot.superclass.dispose(self);
end

function ShopItemSlot:initialize(context)
	self.context = context;
	self:initLayer();

  self.skeleton= self.context.shopProxy:getSkeleton();
  local armature= self.skeleton:buildArmature("shop_render");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(armature_d);


  --按钮
  local button=self.armature_d:getChildByName("bottom");
  self.button_pos=convertBone2LB4Button(button);
  self.armature_d:removeChild(button)

  self.zhekou=self.armature_d:getChildByName("9zhe")
  
  self.zhekou:setVisible(false);



end

function ShopItemSlot:setSlotData(shopItemPo)
  
  self.shopItemPo = shopItemPo;
  --物品名字
  self.itemPo = analysis("Daoju_Daojubiao", shopItemPo.itemid);
  if not self.itemName then
    local itemShowName;
    if shopItemPo.count == 1 then
      itemShowName = self.itemPo.name
    else
      itemShowName = self.itemPo.name .. " x " .. shopItemPo.count;
    end

    local itemNameTextData = self.armature:getBone("item_name").textData;
    self.itemName = createTextFieldWithTextData(itemNameTextData,itemShowName ,nil,0);
    self:addChild(self.itemName)
    --self.itemName:setColor(CommonUtils:ccc3FromUInt(0));
  end
  --物品item
  if not self.itemImage then
    self.itemImage = BagItem.new(); 
    self.itemImage:initialize({ItemId = self.shopItemPo.itemid, Count = 1});
    self.itemImage:setPositionXY(86,-156)
    self.armature_d:addChild(self.itemImage)
    self.itemImage.touchEnabled=true
    self.itemImage.touchChildren=true
  end
  self.itemImage:addEventListener(DisplayEvents.kTouchBegin,self.onItemTapBegin,self);
  --货币
  self.ico=self.armature_d:getChildByName("ico")
  self.ico:setVisible(false)
  self.ico.touchEnabled=false

   --爵位、帮派等级判别
  local nobility = nil;
  if self.context.type == 1 then
    nobility = self.context.userProxy.nobility
  elseif self.context.type == 2 then
    nobility = self.context.familyProxy:getFamilyLevel()
  end

  if nobility<shopItemPo.term then

    local nobilityTextDate=self.armature:getBone("nobility").textData;
    self.nobilityName = createTextFieldWithTextData(nobilityTextDate,"需官职:")

    self:addChild(self.nobilityName)
    self.nobilityName.touchEnabled = false

    if self.context.type == 1 then
      local nobilityPo=analysis("Shili_Guanzhi",shopItemPo.term);
      self.nobilityName:setString("需官职:"..nobilityPo.title);
  
    elseif self.context.type == 2 then
      self.nobilityName:setString("需帮派等级:"..tostring(shopItemPo.term).."级");
    end


  else
    --物品价格
    self.button=CommonButton.new();
    self.button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    self.button:setPosition(self.button_pos);
    self.armature_d:addChildAt(self.button,2);
    self.button:addEventListener(DisplayEvents.kTouchBegin, self.onButtonBegin, self);

    local nobility = nil;
  if self.context.type == 1 then
    nobility = self.context.userProxy.nobility
    self.ico:setPositionXY(self.ico:getPositionX() + 30,self.ico:getPositionY()-25)
    self.ico:setVisible(true)
    self.ico:setAnchorPoint(ccp(0.5, 0.5))
    self.armature_d:addChild(self.ico)
    self.ico:setScale(0.75)
    self.icoScale = 0.75
  elseif self.context.type == 2 then
    nobility = self.context.familyProxy:getFamilyLevel()
    local icoPos = convertBone2LB(self.ico);
    local art = analysis("Daoju_Daojubiao", shopItemPo.money,"art");
    self.contributeImage = Image.new();
    self.contributeImage:loadByArtID(art);
    self.contributeImage:setPosition(ccp(icoPos.x+30, icoPos.y + 25))
    self.contributeImage:setAnchorPoint(ccp(0.5, 0.5))
    self.contributeImage:setScale(0.5)
    self.contributeImage.touchEnabled = false;
    self.conScale = 0.5;
    self.armature_d:addChild(self.contributeImage)
    self.ico:setVisible(false)
  end

    local itemPrice=self.armature:getBone("item_price").textData
    self.itemPrice=createTextFieldWithTextData(itemPrice,shopItemPo.price,true)
    -- local  pricebits=0
    -- local price =shopItemPo.price
    -- while price>0 do
    --   price=math.floor(price/10)
    --   pricebits=pricebits+1
    -- end
    -- local itemshift=(6-pricebits)/2*13
    -- self.itemPrice:setPositionXY(self.itemPrice:getPositionX()+itemshift,self.itemPrice:getPositionY())
    self:addChild(self.itemPrice)
    self.prestige=self.context.userCurrencyProxy.prestige

    -- if self.prestige<shopItemPo.price then
    --    self.itemPrice:setColor(CommonUtils:ccc3FromUInt(16711680));
    -- end
    self.itemPrice.touchEnabled = false
  end
end
function ShopItemSlot:onButtonBegin(event)
  self.button:addEventListener(DisplayEvents.kTouchEnd, self.onButtonEnd, self);
  if self.icoScale then
    self.ico:setScale(self.icoScale*0.9)
  end
  
  if self.contributeImage then
     self.contributeImage:setScale(self.conScale*0.9)
  end
  self.itemPrice:setScale(0.9)
  self.tapbuttonbegin=event.globalPosition
end

function ShopItemSlot:onButtonEnd(event)
  if self.icoScale  then
    self.ico:setScale(self.icoScale)
  end
  if self.contributeImage then
     self.contributeImage:setScale(self.conScale)
  end
  self.itemPrice:setScale(1)
  if(math.abs(event.globalPosition.y-self.tapbuttonbegin.y)<10) and (math.abs(event.globalPosition.x-self.tapbuttonbegin.x)<10) then
    if self.context.type == 1 then
      local nobility = self.context.userProxy.nobility

      if nobility < self.shopItemPo.term then
        sharedTextAnimateReward():animateStartByString("亲~官职太低买不了哦！");
      else
        self.prestige=self.context.userCurrencyProxy.prestige
        if self.shopItemPo.price > self.prestige  then
          sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
        else
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
          initializeSmallLoading();
          self:dadian()
        end
      end
    elseif self.context.type == 2 then
      local familyLevel = self.context.familyProxy:getFamilyLevel()
      if familyLevel < self.shopItemPo.term then
        local  string = analysis("Tishi_Tishineirong", 108, "captions")
        sharedTextAnimateReward():animateStartByString(string);
      else
        self.familyContribute = self.context.userCurrencyProxy.familyContribute
        if self.shopItemPo.price > self.familyContribute then
          sharedTextAnimateReward():animateStartByString("亲~帮贡不足了哦！");
        else
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
          initializeSmallLoading();
          self:dadian()
        end
      end
    end
  end


  print("$$$$$$$$$$$$$$$$$$self.shopItemPo.id",self.shopItemPo.id)
end



function ShopItemSlot:onButtonTap(event)
    if self.context.type == 1 then
      local nobility = self.context.userProxy.nobility

      if nobility < self.shopItemPo.term then
        sharedTextAnimateReward():animateStartByString("亲~官职太低买不了哦！");
      else
        self.prestige=self.context.userCurrencyProxy.prestige
        if self.shopItemPo.price > self.prestige  then
          sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
        else
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
          initializeSmallLoading();
          self:dadian()
        end
      end
    elseif self.context.type == 2 then
      local familyLevel = self.context.familyProxy:getFamilyLevel()
      if familyLevel < self.shopItemPo.term then
        local  string = analysis("Tishi_Tishineirong", 108, "captions")
        sharedTextAnimateReward():animateStartByString(string);
      else
        self.familyContribute = self.context.userCurrencyProxy.familyContribute
        if self.shopItemPo.price > self.familyContribute then
          sharedTextAnimateReward():animateStartByString("亲~帮贡不足了哦！");
        else
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
          initializeSmallLoading();
          self:dadian()
        end
      end
    end
    
end

function ShopItemSlot:dadian()
  print("ShopItemSlot:dadian()")
  local tab={daojuID=self.shopItemPo.itemid,daojuname=self.itemPo.name,daojuIDhenum=self.shopItemPo.itemid .. "^1"}
  hecDC(3,20,2,tab);
end

function ShopItemSlot:onItemTapBegin(event)
  self.itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTapEnd, self);
  self.tapitembegin=event.globalPosition
end
function ShopItemSlot:onItemTapEnd(event)
  if(math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    local function callback()
      self:onButtonTap();
    end
      self.context:shopItemClick(self.itemImage,callback)
  end
end
