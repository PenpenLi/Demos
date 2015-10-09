require "main.model.BagProxy";
require "main.controller.command.bagPopup.AvatarEquipOnOffCommand";
require "main.controller.command.bagPopup.BagFullEffectCommand";
require "main.view.bag.BagPopupMediator";
require "main.view.strengthen.StrengthenPopupMediator";
require "main.managers.BetterEquipManager";
require "main.view.mainScene.MainSceneMediator";

Handler_9_1 = class(MacroCommand);

local _yingxionglingOldCount = 0
local _langyalingOldCount = 0

function Handler_9_1:execute()

  self.targetTable = {{id = 1016008},{id = 1016002},{id = 1016003}
                    ,{id = 1016004},{id = 1016005},{id = 1016006}
                    ,{id = 1016007},{id = 1016001},{id = 1016009}
                    ,{id = 1016010},{id = 1016011}}

  uninitializeSmallLoading();

  local booleanValue2 = recvTable["BooleanValue2"];
  
  self.bagProxy=self:retrieveProxy(BagProxy.name);

  self.pop_items={};
  for k,v in pairs(recvTable["UserItemArray"]) do
    -- 存琅琊令和英雄令的个数
    if v.ItemId == 1009001 then
      _langyalingOldCount = self.bagProxy:getItemNum(1009001)
    elseif v.ItemId == 1009002 then
      _yingxionglingOldCount = self.bagProxy:getItemNum(1009002)
    end
    self.pop_items[v.ItemId]=v.ItemId;

    for k1,v1 in pairs(self.targetTable) do
      if v.ItemId == v1.id then
        v1.oldCount = self.bagProxy:getItemNum(v.ItemId)
      end
    end
  end
  for k,v in pairs(self.pop_items) do
    self.pop_items[k]=self.bagProxy:getItemNum(v);
  end

  self.bagProxy:refresh(recvTable["UserItemArray"],recvTable["Type"]);
  if booleanValue2 == 1 then
    self:popUpTextAnimate();
  end

  self.equipmentInfoProxy=self:retrieveProxy(EquipmentInfoProxy.name);
  self.equipmentInfoProxy:delete(recvTable["UserItemArray"]);

  --BagPopupMediator
  if BagPopupMediator then
    local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
    if nil~=bagPopupMediator then
      bagPopupMediator:refreshBagData(self:getUserItemArray(),recvTable["Type"]);
      bagPopupMediator:refreshBagDelete(self:getDeleteArray());
    end
  end

  if ChatPopupMediator then
    local chatPopupMediator=self:retrieveMediator(ChatPopupMediator.name);
    if nil~=chatPopupMediator then
      chatPopupMediator:refreshTrumpet();
    end
  end

  self:addSubCommand(BagFullEffectCommand);
  self:complete();  

  self:refreshAnimateReward()

  self:refreshRedDot()

  self:refreshMediator();
end

function Handler_9_1:getUserItemArray()
  local userItemArray={};
  for k,v in pairs(recvTable["UserItemArray"]) do
    local a=self.bagProxy:getItemData(v.UserItemId);
    table.insert(userItemArray,a);
  end
  return userItemArray;
end

function Handler_9_1:getDeleteArray()
  local itemArray={};
  for k,v in pairs(recvTable["UserItemArray"]) do
    if 0==v.Count then
      table.insert(itemArray,v);
    end
  end
  return itemArray;
end

function Handler_9_1:refreshAnimateReward()
	self.gainItemArray = {};
  if 2==recvTable["Type"] then
    for k,v in pairs(recvTable["UserItemArray"]) do
      local a=v.Count;
      local b=0;
      local item=self.bagProxy:getItemData(v.UserItemId);
      if item then
        b=item.Count;
      end
      local c=a-b;
      local d=analysis("Daoju_Daojubiao",v.ItemId,"name") .. "x" .. c;
      local quality=analysis("Daoju_Daojubiao",v.ItemId,"color");
      local color=getColorByQuality(quality,true);

      if 0<c then
				table.insert(self.gainItemArray,{ItemId = v.ItemId,Count = c});
    
				local const_equipIDs={1100,1101,1102,1103,1104,1105,1106};
        local categoryID=math.floor(v.ItemId/1000);
        for k_,v_ in pairs(const_equipIDs) do
          if categoryID==v_ then
            table.insert(BetterEquipManager.betterEquips,v.UserItemId);
            --break;注释的代码不要解开
          end
        end
      end
    end
  end
end

function Handler_9_1:popUpTextAnimate()

  for k,v in pairs(self.pop_items) do
    local num=self.bagProxy:getItemNum(k);
    if num>v then
      local d=analysis("Daoju_Daojubiao",k,"name") .. "x" .. (num-v);
      local quality=analysis("Daoju_Daojubiao",k,"color");
      local color=getColorByQuality(quality,true);
      sharedTextAnimateReward():animateStartByString('<content><font color="#FFFFFF">获得 </font><font color="' .. color ..'">' .. d .. '</font><font color="#FFFFFF">个</font></content>');
    end
  end
end

function Handler_9_1:refreshRedDot()

  -- 检查是否有需要刷新红点的
  -- type == 1 道具触发的 2货币触发

  -- 不要分开判断 不停的遍历获得道具的列表，统一在一个循环里做
  for k,v in pairs(recvTable["UserItemArray"]) do
    -- 刷新琅琊令
    if (v.ItemId == 1009001 and _langyalingOldCount < v.Count)
      or (v.ItemId == 1009002 and _yingxionglingOldCount < v.Count)
      then -- 道具增加
      _yingxionglingOldCount = 0
      _langyalingOldCount = 0
      GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_12] = false
      self:addSubCommand(ToRefreshReddotCommand);
      self:complete({data={type=FunctionConfig.FUNCTION_ID_12}}); 
    else --道具减少
      if (v.ItemId == 1009001 and v.Count == 0)
      or (v.ItemId == 1009002 and v.Count == 0) then -- 减少到0 不显示了
        GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_12] = true
        self:addSubCommand(ToRefreshReddotCommand);
        self:complete({data={type=FunctionConfig.FUNCTION_ID_12}}); 
      end
    end

    -- other
    for k1,v1 in pairs(self.targetTable) do
      if (v.ItemId == tonumber(v1.id) and v1.oldCount and v.Count > v1.oldCount)
      or recvTable["Type"] == 1 then
        -- log("v1.id========="..v1.id)
        -- if v1.oldCount then
        --   log("v1.oldCount========="..v1.oldCount)
        -- end
        -- 检查是否有需要刷新红点的
        self:addSubCommand(JudgeReddotCommand);
        if recvTable["Type"] == 1 then
          self:complete({data={functionId=FunctionConfig.FUNCTION_ID_61}});
        else
          self:complete({data={functionId=FunctionConfig.FUNCTION_ID_61,value=k1}});
        end

        self.targetTable = {}
        break;
      end
    end
  end

  local heroHouseProxy;
  local generalArray;
  if HeroHouseProxy then
    heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    generalArray = heroHouseProxy.generalArray;
  end

  local needRefresh = false;
  if heroHouseProxy and generalArray then
    for k,v in pairs(generalArray) do
      heroHouseProxy:setHongdianData(v.GeneralId,2);
      heroHouseProxy:setHongdianData(v.GeneralId,3);
      heroHouseProxy:setHongdianData(v.GeneralId,4);
      heroHouseProxy:setHongdianData(v.GeneralId,6);
      heroHouseProxy:setHongdianData(v.GeneralId,7);
    end
    needRefresh = true;
  end
  if needRefresh then
    HeroRedDotRefreshCommand.new():execute();
  end
end

function Handler_9_1:refreshMediator()
  if HeroHousePopupMediator then
    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if mediator then
      local bool;
      for k,v in pairs(recvTable["UserItemArray"]) do
        if 8 == math.floor(v.ItemId/1000000) then
          bool = true;
          break;
        end
      end
      if bool then
        mediator:getViewComponent():refreshOnProClose();
      end
    end
  end

  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
      if not heroHouseProxy.isIn6_11 then
        mediator:getViewComponent():refreshCurrentData();
      end
      heroHouseProxy.isIn6_11 = nil;
    end
  end

  if StrengthenPopupMediator then
    local mediator = self:retrieveMediator(StrengthenPopupMediator.name);
    if mediator then
      mediator:getViewComponent():refreshPanelByTrack();
    end
  end
end

Handler_9_1.new():execute();