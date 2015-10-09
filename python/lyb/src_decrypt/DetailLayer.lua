require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";
require "main.common.batchUse.BatchUseUI";
require "core.display.LayerPopable";

DetailLayer=class(LayerKeyBackable);

function DetailLayer:dispose()
  if self.grid_over and self.grid_over.parent then
    self.grid_over.parent:removeChild(self.grid_over);
  end
  self:removeAllEventListeners();
  self:removeChildren();
	DetailLayer.superclass.dispose(self);
  self.armature:dispose();
end

function DetailLayer:getItemData()
  return self.itemData;
end

DetailLayerType = {
  KUAI_SU_SUO_YIN = "KUAI_SU_SUO_YIN"
};

--intialize UI
function DetailLayer:initialize(skeleton, tapItem, showButton, detailLayerType, callBack)
  self:initLayer();
  self.effectProxy=self:retrieveProxy(EffectProxy.name);
  -- self.petBankProxy=self:retrieveProxy(PetBankProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  self.openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name);
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.userDataAccumulateProxy=self:retrieveProxy(UserDataAccumulateProxy.name);
  self.callBack = callBack;
  
  local armature=skeleton:buildArmature("detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature4dispose=armature;
  local armature_d=armature.display;
  
  --出售
  local sellButton=armature_d:getChildByName("common_blue_button");
  local sell_pos=convertBone2LB4Button(sellButton);--equipButton:getPosition();
  armature_d:removeChild(sellButton);

  --使用
  local equipButton=armature_d:getChildByName("common_blue_button_1");
  local equip_pos=convertBone2LB4Button(equipButton);--equipButton:getPosition();
  armature_d:removeChild(equipButton);
  
  
  self:addChild(armature_d);
  self.bag_item=tapItem;
  self.item=self.bag_item:clone();
  self.itemData=self.item:getItemData();
  self.isPetEgg=BagConstConfig.USE_ID_11==self.item:getUseID();
  self.isSynthetic=self.item:getSyntheticable();

  if self.isSynthetic then
    self.syntheticItemID=analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
    self.min=analysis("Daoju_Hecheng",self.syntheticItemID,"need");
    self.min=StringUtils:stuff_string_split(self.min);
    self.min=self.min[1];
    self.suipian_count = self.bagProxy:getItemNum(tonumber(self.min[1]));
    self.suipian_enough = tonumber(self.min[2]) <= self.suipian_count;

    local suipian = {nil,nil,1011901,1011902,1011903,1011904};
    local suipianID = suipian[analysis("Daoju_Daojubiao",self.syntheticItemID,"color")];
    self.common_suipian_name = "";
    self.common_suipian_count = 0;
    if suipianID then
      self.common_suipian_name = analysis("Daoju_Daojubiao",suipianID,"name");
      self.common_suipian_count = self.bagProxy:getItemNum(suipianID);
    end
    self.common_suipian_enough = tonumber(self.min[2]) <= (self.suipian_count + self.common_suipian_count);
  end

  local bs="";
  if self.isSynthetic then
    if self.common_suipian_enough then
      bs="合成";
    else
      bs="获取";
    end
  elseif self.item:isUsable() then
    if self.isPetEgg then
      bs="孵化";
    else
      bs="使用";
    end
  end
  
  --item
  local grid=armature_d:getChildByName("common_copy_grid");
  local pos=convertBone2LB(grid);--;grid:getPosition();
  pos.x=pos.x+ConstConfig.CONST_GRID_ITEM_SKEW_X;
  pos.y=pos.y+ConstConfig.CONST_GRID_ITEM_SKEW_Y;
  self.item:setPosition(pos);
  self:addChild(self.item);
  
  
 
  --bag_item_name
  local text_data=armature:getBone("bag_item_name").textData;
  local daoju_data = analysis("Daoju_Daojubiao",self.itemData.ItemId);
  local text=daoju_data.name
  
  if daoju_data.functionID==4 then
    color=getSimpleGrade(daoju_data.color)
  else
    color=daoju_data.color
  end
  local bag_item_name=createTextFieldWithQualityID(color,text_data,text);
  self:addChild(bag_item_name);
  
  --bag_item_category_name
  text_data=armature:getBone("bag_item_category_name").textData;
  local bag_item_category_name=createTextFieldWithTextData(text_data,"类型");
  self:addChild(bag_item_category_name);
  
  --bag_item_category_descb
  text_data=armature:getBone("bag_item_category_descb").textData;
  text=analysisHas("Daoju_Daojufenlei",self.item:getCategoryID()) and analysis("Daoju_Daojufenlei",self.item:getCategoryID(),"function") or "";
  local bag_item_category_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_category_descb);
  
  --bag_item_overlay
  text_data=armature:getBone("bag_item_overlay").textData;
  local bag_item_overlay=createTextFieldWithTextData(text_data,"叠加");
  self:addChild(bag_item_overlay);
  
  --bag_item_overlay_descrb
  text_data=armature:getBone("bag_item_overlay_descrb").textData;
  text=self.bag_item:getItemData().Count .. "/" .. analysis("Daoju_Daojubiao",self.itemData.ItemId,"overlap");
  if 0==text then
    text="不可叠加";
  end
  local bag_item_overlay_descrb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_overlay_descrb);
  
  --bag_item_output
  text_data=armature:getBone("bag_item_output").textData;
  local bag_item_output=createTextFieldWithTextData(text_data,"产出");
  self:addChild(bag_item_output);
  
  --bag_item_output_descb
  text_data=armature:getBone("bag_item_output_descb").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"origin");
  local bag_item_output_descb=createTextFieldWithTextData(text_data,text);
  self:addChild(bag_item_output_descb);
  
  --bag_item_specification
  text_data=armature:getBone("bag_item_specification").textData;
  text=analysis("Daoju_Daojubiao",self.itemData.ItemId,"function");
  local bag_item_specification=createTextFieldWithTextData(text_data,"说明：" .. text);
  self:addChild(bag_item_specification);

  --使用
  if showButton then
    if DetailLayerType.KUAI_SU_SUO_YIN == detailLayerType then

      local button=CommonButton.new();
      button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
      --button:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"出售");
      button:initializeBMText("获取","anniutuzi");
      button:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),sell_pos.y);
      button:addEventListener(DisplayEvents.kTouchTap,self.onTrack,self);
      self:addChild(button);

    elseif self.item:isUsable() or self.isSynthetic then
      if 0<self.item:getSellNum() then
        sellButton=CommonButton.new();
        sellButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --sellButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"出售");
        sellButton:initializeBMText("出售","anniutuzi");
        sellButton:setPosition(sell_pos);
        sellButton:addEventListener(DisplayEvents.kTouchTap,self.onSellButtonTap,self);
        self:addChild(sellButton);

        equipButton=CommonButton.new();
        equipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --equipButton:initializeText(armature:findChildArmature("common_blue_button_1"):getBone("common_small_blue_button").textData,bs);
        equipButton:initializeBMText(bs,"anniutuzi");
        equipButton:setPosition(equip_pos);
        equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
        self:addChild(equipButton);
      else
        equipButton=CommonButton.new();
        equipButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
        --equipButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,bs);
        equipButton:initializeBMText(bs,"anniutuzi");
        equipButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),equip_pos.y);
        equipButton:addEventListener(DisplayEvents.kTouchTap,self.onEquipButtonTap,self);
        self:addChild(equipButton);
      end
    elseif 0<self.item:getSellNum() then
      sellButton=CommonButton.new();
      sellButton:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
      --sellButton:initializeText(armature:findChildArmature("common_blue_button"):getBone("common_small_blue_button").textData,"出售");
      sellButton:initializeBMText("出售","anniutuzi");
      sellButton:setPositionXY(math.floor((sell_pos.x+equip_pos.x)/2),sell_pos.y);
      sellButton:addEventListener(DisplayEvents.kTouchTap,self.onSellButtonTap,self);
      self:addChild(sellButton);
    end
  end
  
  self.grid_over=skeleton:getCommonBoneTextureDisplay("commonGrids/common_grid_over");
  local size=self.bag_item:getChildAt(0):getContentSize();
  local over_size=self.grid_over:getContentSize();
  self.grid_over:setPositionXY(self.bag_item:getChildAt(0):getPositionX()+(size.width-over_size.width)/2,self.bag_item:getChildAt(0):getPositionY()+(size.height-over_size.height)/2);
  self.bag_item:addChild(self.grid_over);
  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

--移除
function DetailLayer:onCloseButtonTap(event)
  if self.parent and self.parent.removeItemTap then
    self.parent:removeItemTap();
  end
  if self.callBack then
    self.callBack();
  end
end

--使用
function DetailLayer:onEquipButtonTap(event)
  print("onBagPropUse");

  local useID=self.item:getUseID();
  local num=0;
  --elseif BagConstConfig.USE_ID_8==useID then
  if self.item:getSyntheticable() then
    -- if self.item:getBatchSynthesisble() then
    --   local tarItemId = analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3");
    --   ----------------------货币消耗判断--------------------------------
    --   local costStr = analysis("Daoju_Hecheng",tarItemId,"yinliang");
    --   local tbl = StringUtils:lua_string_split(costStr,",");
    --   local cost = tonumber(tbl[2]);
    --   local userCurrency = 0;
    --   if 2 == tonumber(tbl[1]) then 
    --     userCurrency = self.userCurrencyProxy:getSilver();
    --     if userCurrency < cost then
    --       sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_20));
    --       return;
    --     end
    --   elseif 3 == tonumber(tbl[1]) then
    --     userCurrency = self.userCurrencyProxy:getGold();
    --     if userCurrency < cost then
    --       sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
    --       return;
    --     end
    --   elseif 7 == tonumber(tbl[1]) then
    --     userCurrency = self.userCurrencyProxy:getPrestige();
    --     if userCurrency < cost then
    --       -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_18));
    --       sharedTextAnimateReward():animateStartByString("亲~声望不足了哦！");
    --       return;
    --     end
    --   end
    --   local maxcountByCount = math.floor(self.bag_item.bagProxy:getItemNum(self.itemData.ItemId)/tonumber(self.min[2]));
    --   local maxcountByCurrency = maxcountByCount;
    --   if ""==costStr then

    --   else
    --     maxcountByCurrency = math.floor(userCurrency/cost);
    --   end
    --   local maxcount = math.min(maxcountByCurrency,maxcountByCount);
    --   if maxcount < 2 then
    --     local a=CommonPopup.new();
    --     a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_112,{tonumber(self.min[2]),tonumber(self.min[1]),1,self.syntheticItemID}),self,self.onSynthetic,{Count = 1},nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_112),true);
    --     self.parent.parent:addChild(a);
    --   else
    --     self:onBatchUI(maxcount,true,self.bag_item.bagProxy:getItemNum(self.itemData.ItemId));
    --   end
    -- else
    if self.suipian_enough then
      self:onSynthetic({Count = 1});
    elseif self.common_suipian_enough then
      local a=CommonPopup.new();
      -- a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_112,{tonumber(self.min[2]),tonumber(self.min[1]),1,self.syntheticItemID}),self,self.onSynthetic,{Count = 1},nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_112),true);
      a:initialize("合成会消耗" .. (tonumber(self.min[2]) - self.suipian_count) .. "个" .. self.common_suipian_name .. ",确定吗?",self,self.onSynthetic,{Count = 1});
      self.parent.parent:addChild(a);
    else

    end
    -- end
    return;
  elseif BagConstConfig.USE_ID_1==useID then
    --[[local data={Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=1,CurrencyType=0};
    self.parent:dispatchEvent(Event.new("onBagPropUse",data,self.parent));]]
    local count=0;
    if self.bag_item:getBatchUsable() then
      if 1003001==self.bag_item:getItemData().ItemId and 1003002==self.bag_item:getItemData().ItemId then
        count=math.min(self.bag_item:getItemData().Count,self.countControlProxy:getRemainCountByID(CountControlConfig.AddTili));
      else
        count=self.bag_item:getItemData().Count;
      end
    else
      count=1;
    end
    if 0==count then
      sharedTextAnimateReward():animateStartByString("没有使用次数了哦~");
      self:onCloseButtonTap(event);
    elseif 1==count then
      self:onUserConfirm({Count=1});
      self:onCloseButtonTap(event);
    else
      self:onBatchUI(count);
    end
  elseif BagConstConfig.USE_ID_10==useID then
    --[[if self.parent.bagProxy:getBagLeftPlaceCount(self.parent.itemUseQueueProxy)<analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter1") then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
    else
      local data={Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=1,CurrencyType=0};
      self.parent:dispatchEvent(Event.new("onBagPropUse",data,self.parent));
    end]]
    --[[local a=analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter1");
    local b=self.bag_item:getBatchUsable() and self.bag_item:getItemData().Count or 1;
    local c=self.parent.bagProxy:getBagLeftPlaceCount(self.parent.itemUseQueueProxy);
    local count=(0==a or a*b<=c) and b or math.floor(c/a/b);]]

    ----后端逻辑修改,改为批量使用会单独计算每一次使用后背包的空余状况,一旦在中间出现不足的情况,服务器会主动停止使用----
    ----------------因此批量使用只要判断第一次是否能成功就OK------------------------------
    print(self.userDataAccumulateProxy:getCount(27, analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3")))
    if 31 == analysis("Daoju_Daojubiao",self.itemData.ItemId,"functionID") and analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter2") == self.userDataAccumulateProxy:getCount(27, analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter3")) then
      sharedTextAnimateReward():animateStartByString("今天的使用次数不够啦!");
      self:onCloseButtonTap(event);
      return;
    end

    local countByType = analysis("Daoju_Daojubiao",self.itemData.ItemId,"parameter1")
    local countByLeftPlace=self.parent.bagProxy:getBagLeftPlaceCount(self.parent.itemUseQueueProxy);
    local count = self.bag_item:getBatchUsable() and self.bag_item:getItemData().Count or 1;
    if countByLeftPlace < countByType then
      count = 0;
    end
    
    if 0==count then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_15));
      self:onCloseButtonTap(event);
    elseif 1==count or not self.bag_item:getBatchUsable() then
      self:onUserConfirm({Count=1}); 
      self:onCloseButtonTap(event);
    else
      self:onBatchUI(count);
    end
  elseif BagConstConfig.USE_ID_11==useID then
    --[[local data={Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=1,CurrencyType=0};
    self.parent:dispatchEvent(Event.new("onBagPropUse",data,self.parent));]]
    local count=math.min(self.petBankProxy:getLeftGrid(),self.bag_item:getItemData().Count);
    if not self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_5) then
      sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_185));
      self:onCloseButtonTap(event);
    elseif 0==count then
      sharedTextAnimateReward():animateStartByString("宠物包包已经满了喔 !");
      self:onCloseButtonTap(event);
    elseif 1==count then
      self:onUserConfirm({Count=1});
      self:onCloseButtonTap(event);
    else
      self:onBatchUI(count);
    end
  elseif BagConstConfig.USE_ID_18==useID then
    self.parent:dispatchEvent(Event.new(MainSceneNotifications.MAIN_SCENE_TO_CHANGE_NAME,nil,self.parent));
    self:onCloseButtonTap(event);
  elseif BagConstConfig.USE_ID_2==useID then
    sendMessage(9,4,{Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=1,CurrencyType=0});
    self:onCloseButtonTap(event);
  elseif BagConstConfig.USE_ID_5 == useID then -- 改名卡
    local itemCount = self.bagProxy:getItemNum(1015001)
    local desText = '<content><font color="#67190E">使用</font><font color="#fc00ff">改名卡x1</font><font color="#67190E">就可以修改名字了</font>'
    if itemCount == 0 then
      desText = '<content><font color="#67190E">花费100元宝购买并使用</font><font color="#fc00ff">改名卡x1</font><font color="#67190E">就可以修改名字了</font>'
    end
    require "core.controls.CommonInput";
    self.inputTips = CommonInput.new();
    local function sendToServer()
      local inputName = self.inputTips.inputText:getString()
        local nameLength = CommonUtils:calcCharCount(inputName);
        if nameLength == 0 then
            sharedTextAnimateReward():animateStartByString("请取个名字~");
            return
        elseif nameLength > 6 then
            sharedTextAnimateReward():animateStartByString("名字不能超过6个字~");
            return
        end

      if itemCount == 0 then
        if self.userCurrencyProxy:getGold() < 100 then
          sharedTextAnimateReward():animateStartByString("元宝不足!");
          self:dispatchEvent(Event.new("TO_VIP"));  
          return;
        end
      end

      log("inputName===="..inputName)
      sendMessage(3,41,{UserName = inputName})
      self.inputTips:removePopup()
      self:onCloseButtonTap();
    end
    self.inputTips:initialize("输入你的新名字吧",desText,self,sendToServer,nil,nil,nil,true,nil,true,true,nil);
    
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.inputTips)  
  else
    self.parent:dispatchEvent(Event.new("TO_AUTO_GUIDE",{ID=analysis("Daoju_Daojucaozuo",useID,"uiId"),ItemId=self.itemData.ItemId},self.parent));
    self:onCloseButtonTap(event);
  end
end

function DetailLayer:onBatchUI(maxCount,isMerge,totalCount)
  if not isMerge then
    local batchUseUI=BatchUseUI.new();
    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=maxCount},{"使用","取消"},self.onUserConfirm,nil,1);
    self.parent.parent:addChild(batchUseUI);
  else
    local costStr = analysis("Daoju_Hecheng",self.syntheticItemID,"yinliang");
    local tbl = StringUtils:lua_string_split(costStr,",");
    local cost = tonumber(tbl[2]);
    local costType = tonumber(tbl[1]);
    local batchUseUI=BatchUseUI.new();
    batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=maxCount, CostValue = cost, CostType = costType, totalCount = totalCount},{"合成","取消"},self.onSynthetic,nil,6);
    self.parent.parent:addChild(batchUseUI);
  end
end

function DetailLayer:onUserConfirm(data)
  local data={Place=self.itemData.Place,ItemId=self.itemData.ItemId,Count=data.Count,CurrencyType=0};
  self.parent:dispatchEvent(Event.new("onBagPropUse",data,self.parent));
  self:onCloseButtonTap(event);
end

--出售
function DetailLayer:onSellButtonTap(event)
  if 4 > analysis("Daoju_Daojubiao",self.itemData.ItemId,"color") then
    if self.item:getIsConfirm4Sell() then
      local a=CommonPopup.new();
      a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_196),self,self.sell,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_196));
      self.parent.parent:addChild(a);
      return;
    end
    self:sell();
    return;
  end
  local a=CommonPopup.new();
  a:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_16),self,self.sell,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_16));
  self.parent.parent:addChild(a);
end

function DetailLayer:onSynthetic(data)
  --local data={Place=self.itemData.Place,ItemId=self.syntheticItemID};
  -- if not self.bagProxy:hasEnoughPlace4Item(self.itemUseQueueProxy,self.syntheticItemID,1) then
  --   sharedTextAnimateReward():animateStartByString("包包空间不足哦~先去清理一下吧!");
  --   return;
  -- end

  local data={UserItemId=self.itemData.UserItemId, Count = data.Count};
  self.parent:dispatchEvent(Event.new("bagPropSynthetic",data,self.parent));
  self:onCloseButtonTap();
end

function DetailLayer:onTrack(event)
  Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,{itemId=self.itemData.ItemId,count = self.bag_item.bagHasCount,totalCount = self.bag_item.totalNeedCount , display = self},self));
  -- self:onCloseButtonTap(event);
end

function DetailLayer:sell()
  -- if 1==self.bag_item:getItemData().Count then
    self:sellConfirm({Count=self.bag_item:getItemData().Count});
    self:onCloseButtonTap();
  -- else
  --   local batchUseUI=BatchUseUI.new();
  --   batchUseUI:initialize(self.effectProxy:getBatchUseSkeleton(),self,{ItemId=self.itemData.ItemId,MaxCount=self.bag_item:getItemData().Count},{"出售","取消"},self.sellConfirm,nil,2);
  --   self.parent.parent:addChild(batchUseUI);
  -- end
end

function DetailLayer:sellConfirm(data)
  print("------>>>>>sellConfirm",self.itemData.UserItemId,self.itemData.ItemId,self.itemData.Count,self.itemData.Place);
  self.parent:dispatchEvent(Event.new("bagItemSell",{UserItemId=self.itemData.UserItemId,Count=data.Count},self.parent));
  self:onCloseButtonTap(event);
end

function DetailLayer:onSelfTap(event)
  self.parent.popup_boolean=true;
end

function DetailLayer:closeUI(event)
  self:onCloseButtonTap(event);
end