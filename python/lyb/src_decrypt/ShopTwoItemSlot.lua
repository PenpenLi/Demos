require "core.controls.page.CommonSlot";

require "main.view.tip.ui.EquipTip"


ShopTwoItemSlot=class(CommonSlot);

function ShopTwoItemSlot:ctor()
  self.class=ShopTwoItemSlot;
end

function ShopTwoItemSlot:dispose()
  self:removeAllEventListeners();
  ShopTwoItemSlot.superclass.dispose(self);
end

function ShopTwoItemSlot:initialize(context)
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


  self.armature_d:setContentSize(makeSize(260,231))
  --按钮
  local button=self.armature_d:getChildByName("bottom");
  self.button_pos=convertBone2LB4Button(button);
  self.armature_d:removeChild(button)
  --售完
  --ico
  local ico=self.armature_d:getChildByName("ico")
  self.ico_pos=convertBone2LB(ico);
  self.ico_pos.x=self.ico_pos.x+27;
  self.ico_pos.y=self.ico_pos.y+33
  self.armature_d:removeChild(ico);
  
  self.zhekou=self.armature_d:getChildByName("9zhe")
  
  self.zhekou:setVisible(false);

end

function ShopTwoItemSlot:setSlotData(shopItemPo)
  self.shopItemPo = shopItemPo;
  --物品名字
  self.itemPo = analysis("Daoju_Daojubiao", shopItemPo.itemid);
  
  self.itemSD = analysis("Shangdian_Shangdianwupin", self.shopItemPo.id);
  if self.itemSD.tag == 1 then
    self.zhekou:setVisible(true)
  end
  if not self.itemName then
    local itemName = self.itemPo.name
    if self.itemSD.count > 1 then
       itemName = self.itemPo.name.." x "..tostring(self.itemSD.count)
    end
    local itemNameTextData = self.armature:getBone("item_name").textData;
    self.itemName = createTextFieldWithTextData(itemNameTextData, itemName,nil,0);
    local zhekouIndex = self.armature_d:getChildIndex(self.zhekou);
    self.armature_d:addChildAt(self.itemName, zhekouIndex - 1)
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


    self.button=CommonButton.new();
    self.button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    self.button:setPosition(self.button_pos);
    self.armature_d:addChildAt(self.button,3);
    self.button:addEventListener(DisplayEvents.kTouchBegin, self.onButtonBegin, self);

    self.moneytype=shopItemPo.money
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
    --元宝

    if(self.moneytype==3) then
       self.ico=CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_gold_bg");
       self.ico:setPositionXY(self.ico_pos.x+3, self.ico_pos.y-8);

       self.ico:setScale(0.75)
       self.scale=0.75
       self.ico.touchEnabled=false
       self.armature_d:addChildAt(self.ico,4);
       self.money=self.context.userCurrencyProxy.gold
    elseif(self.moneytype==11) then
       self.ico = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_honor_bg");
       self.ico:setPositionXY(self.ico_pos.x,self.ico_pos.y-8);
       self.ico:setScale(0.75)
       self.scale=0.75
       self.ico.touchEnabled=false
       self.armature_d:addChildAt(self.ico,4);
       self.money=self.context.userCurrencyProxy:getScore()
    else
      --银两
      self.ico=CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
      self.ico:setPositionXY(self.ico_pos.x+3, self.ico_pos.y-8);
      self.ico:setScale(0.75)
      self.scale=0.75
      self.ico.touchEnabled=false
      self.armature_d:addChildAt(self.ico,4);
      self.money=self.context.userCurrencyProxy.silver
    end
    self.ico:setAnchorPoint(ccp(0.5,0.5))

    -- if self.money<shopItemPo.price then
    --    self.itemPrice:setColor(CommonUtils:ccc3FromUInt(16711680));
    -- end
    self.itemPrice.touchEnabled = false
    if (self.context.shopProxy.IDBooleanArray) then
      for k,v in pairs(self.context.shopProxy.IDBooleanArray) do
          if (shopItemPo.id==v.ID) and (v.BooleanValue==1) then
            self.button:setGray(true);   
            self.sellOut = self.skeleton:getBoneTextureDisplay("sellout");
            self.sellOut.touchEnabled=false
            self:addChild(self.sellOut)
            self.sellOut:setPositionXY(60,-160);
            break;
          end
      end
   end
end
function ShopTwoItemSlot:onButtonBegin(event)
  self.button:addEventListener(DisplayEvents.kTouchEnd, self.onButtonEnd, self);

  self.ico:setScale(self.scale*0.9)
  self.itemPrice:setScale(0.9)
  self.tapbuttonbegin=event.globalPosition
end

function ShopTwoItemSlot:onButtonEnd(event)
  self.ico:setScale(self.scale)
  self.itemPrice:setScale(1)
  if(math.abs(event.globalPosition.y-self.tapbuttonbegin.y)<10) and (math.abs(event.globalPosition.x-self.tapbuttonbegin.x)<10) then
    local nobility=self.context.userProxy.nobility
      if (self.shopItemPo.price > self.money) and (self.moneytype==3) then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        self:gotochongzhi();
      elseif (self.shopItemPo.price > self.money) and (self.moneytype==2) then
        sharedTextAnimateReward():animateStartByString("亲~银两不足了哦！");
        self:gotodianjin()
      elseif (self.shopItemPo.price > self.money) and (self.moneytype==11) then
        sharedTextAnimateReward():animateStartByString("亲~荣誉不足了哦！");
        -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
      else
        local isSellOut;
        if(self.context.shopProxy.IDBooleanArray) then
          for k,v in pairs(self.context.shopProxy.IDBooleanArray) do
            if (self.shopItemPo.id==v.ID) then
              if 1 ==v.BooleanValue then
                isSellOut = true;
              else
                self.context.shopProxy.IDBooleanArray[k].BooleanValue=1
              end
              break;
            end
          end
        end
        if not isSellOut then
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
          initializeSmallLoading();
        else
          sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_513));
        end
      end
  end
end
function ShopTwoItemSlot:onButtonTap()
    local nobility=self.context.userProxy.nobility

      if (self.shopItemPo.price > self.money) and (self.moneytype==3) then
        sharedTextAnimateReward():animateStartByString("亲~元宝不足了哦！");
        self:gotochongzhi();
      elseif (self.shopItemPo.price > self.money) and (self.moneytype==2) then
        sharedTextAnimateReward():animateStartByString("亲~银两不足了哦！");
        self:gotodianjin()
      elseif (self.shopItemPo.price > self.money) and (self.moneytype==11) then
        sharedTextAnimateReward():animateStartByString("亲~荣誉不足了哦！");
      else
        local isSellOut;
        if(self.context.shopProxy.IDBooleanArray) then
          for k,v in pairs(self.context.shopProxy.IDBooleanArray) do
            if (self.shopItemPo.id==v.ID) then
              if 1 ==v.BooleanValue then
                isSellOut = true;
              else
                self.context.shopProxy.IDBooleanArray[k].BooleanValue=1
              end
              break;
            end
          end
        end
        if not isSellOut then
          sendMessage(3,16,{ID=self.shopItemPo.id,Count=1});
        else
          sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_513));
        end
      end
end

function ShopTwoItemSlot:gotochongzhi()
  self.context:gotochongzhi();
end
function ShopTwoItemSlot:gotodianjin()
  self.context:gotodianjin();
end
function ShopTwoItemSlot:onItemTapBegin(event)
  self.itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTapEnd, self);
  self.tapitembegin=event.globalPosition
end
function ShopTwoItemSlot:onItemTapEnd(event)
  self.itemImage:addEventListener(DisplayEvents.kTouchEnd,self.onItemTapEnd,self);
  if(math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    local function callback()
      self:onButtonTap();
    end
     self.context:shopTwoItemClick(self.itemImage,callback)
  end
end