--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

require "main.common.CommonExcel";

ItemUseQueueProxy=class(Proxy);

local place_opened_effectID=5;
local max_place=analysis("Xishuhuizong_Xishubiao",1011,"constant");

function ItemUseQueueProxy:ctor()
  self.class=ItemUseQueueProxy;
  self.data=nil;
  self.placeOpenedByVIP=0;
  self.placeOpenedCount=0;
end

rawset(ItemUseQueueProxy,"name","ItemUseQueueProxy");

--更新道具队列
function ItemUseQueueProxy:refresh(itemUseQueue)
  self.data=itemUseQueue;
  for k,v in pairs(itemUseQueue) do
    if place_opened_effectID==v.ItemEffectId then
      self.placeOpenedCount=v.ItemEffectValue;
      break;
    end
  end
end

--道具队列
function ItemUseQueueProxy:getData()
  return self.data;
end

function ItemUseQueueProxy:setPlaceOpenedByVIP(userProxy)
  local vipLV=userProxy:getVipLevel();
  if 0<vipLV then
    self.placeOpenedByVIP=analysis("Huiyuan_Huiyuantequan",1,"vip" .. vipLV);
  end
end

--格子数量
function ItemUseQueueProxy:getPlaceOpenedCount()
  local a=self.placeOpenedCount+analysis("Xishuhuizong_Xishubiao",1010,"constant")+self.placeOpenedByVIP;
  if max_place<a then
    return max_place;
  end
  return a;
end

function ItemUseQueueProxy:getMaxCount()
  return max_place;
end