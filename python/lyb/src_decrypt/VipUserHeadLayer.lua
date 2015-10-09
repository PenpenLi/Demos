
VipUserHeadLayer=class(Layer);

function VipUserHeadLayer:ctor()
  self.class=VipUserHeadLayer;
  self.vipLevel = 0;
end

function VipUserHeadLayer:dispose()
  self:removeAllEventListeners();
	VipUserHeadLayer.superclass.dispose(self);
end

function VipUserHeadLayer:initialize(vip, scale)
  self:initLayer();
  self:setTouchEnabled(false);
  self:refresh(vip, scale);
end

function VipUserHeadLayer:refresh(vip, scale)
  self.vip=vip;
  self:removeChildren();
  local vipTable=analysisTotalTable("Huiyuan_Huiyuandengji");
  local vipPointMax = 0;
  local vipLevelMax = 0;
  for k,v in pairs(vipTable) do
    if v.max > vipPointMax then
      vipPointMax = v.max;
      vipLevelMax=tonumber(string.sub(k,4));
    end
    if self.vip>=v.min and self.vip<=v.max then
      self.vipLevel=tonumber(string.sub(k,4));
      break;
    end
  end
  if vipPointMax < vip then
    self.vipLevel = vipLevelMax
  end
  local vip_word = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip");
  self:addChild(vip_word);
  local totalWidth = vip_word:getContentSize().width;
  local totalHeight = vip_word:getContentSize().height;
  if self.vipLevel >= 10 then
    local beginVip = 1;
    local endVip = self.vipLevel % 10;
    local vip0 = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip" .. endVip);
    local vip1 = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip1");
   
    self:addChild(vip1)
    vip1:setPositionXY(totalWidth-7, 15);
    totalWidth = totalWidth + vip1:getContentSize().width;

    self:addChild(vip0)
    vip0:setPositionXY(totalWidth-14, 15);
    totalWidth = totalWidth + vip0:getContentSize().width-7;
  else
    local vipImage = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_mainui_vip" .. self.vipLevel);
    self:addChild(vipImage)
    vipImage:setPositionXY(totalWidth-7, 15);
    totalWidth = totalWidth + vipImage:getContentSize().width;
  end
  
  self.sprite:setContentSize(CCSizeMake(totalWidth, totalHeight));
  self:setScale(scale);

end