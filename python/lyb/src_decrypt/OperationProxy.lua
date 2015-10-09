OperationProxy=class(Proxy);

function OperationProxy:ctor()
  self.class=OperationProxy;
  self.skeleton = nil;
  
  -- self.offMusic = false
  -- self.offSound = false
  -- self.offOtherPlayer = false
  -- self.offBattleEffect = false
  -- self.atWeibo = false
  -- self.atWeixin = false
	self.oldOperationData = {}
	self.operationData = {}
  self.data = nil;
end

function OperationProxy:getSkeleton()
    if nil == self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("main_ui");
    end
    return self.skeleton;
end

function OperationProxy:setData(data)
  self.data = data;
end

function OperationProxy:getHasID(id)
  if not self.data then return false; end
  for k,v in pairs(self.data) do
    if id == v.ID then return true; end
  end
  return false;
end

-- 阵法是否有小红点
function OperationProxy:isZhenfaRedIconVisible(zhenfaProxy,bagProxy,userCurrencyProxy,data)
  local isRedVisible = false
  if data then
    -- log("data==========="..data)
    isRedVisible = zhenfaProxy:checkCanUpdate(data,bagProxy,userCurrencyProxy)
  else
    for i=1,11 do
      isRedVisible = zhenfaProxy:checkCanUpdate(i,bagProxy,userCurrencyProxy)
      if isRedVisible then
        break;
      end
    end
  end

  return isRedVisible
end
-- 天相
function OperationProxy:isTianxiangRedIconVisible(userProxy, userCurrencyProxy)
  local isRedVisible = false
  local nextTianXiang
  if userProxy.zodiacId == 0 then
    nextTianXiang = 10001
  else
    nextTianXiang = analysis("Zhujiao_Tianxiangshouhudian",userProxy.zodiacId, "id2")
  end
  if nextTianXiang ~= 0 then
    local tianXiangPo = analysis("Zhujiao_Tianxiangshouhudian",nextTianXiang)
    if userCurrencyProxy.storyLineStar >= tianXiangPo.vigourPoint and userCurrencyProxy.silver >= tianXiangPo.money then
      isRedVisible = true
    end
  end
  return isRedVisible
end

rawset(OperationProxy,"name","OperationProxy");

