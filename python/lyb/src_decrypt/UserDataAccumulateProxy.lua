--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
  数据累积
]]

UserDataAccumulateProxy=class(Proxy);

function UserDataAccumulateProxy:ctor()
  self.class = UserDataAccumulateProxy;
  self.accumulateTable = {};
	self.notice = false;	--用于提示是否需要在主界面播特效
	self.totalActiveNum = 0;	--目前总活跃值
	self.giftNum = 0	--已激活的活跃度礼包个数
end

rawset(UserDataAccumulateProxy,"name","UserDataAccumulateProxy");

function UserDataAccumulateProxy:getCount(bigType, param)
	if not param then
      param = 0;
	end
  local count = self.accumulateTable[bigType .. "_" .. param];
  if nil == count then
    return 0;
  end
  return count;
end
function UserDataAccumulateProxy:addItem(bigType, param, value)
  self.accumulateTable[bigType .. "_" .. param] = value;
end

