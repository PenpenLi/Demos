--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-24

	yanchuan.xie@happyelements.com
]]

require "main.view.bag.ui.bagPopup.EquipStar";
require "core.events.DisplayEvent";
require "core.controls.ListScrollViewLayer";
require "core.utils.CommonUtil";

AdaptableTip=class(Layer);

function AdaptableTip:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	AdaptableTip.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function AdaptableTip:getItemData()
  return self.itemData;
end

--intialize UI
function AdaptableTip:initialize(item_str, position)
  self:initLayer();
  self.tipBg=LayerColorBackGround:getTransBackGround();
  self.tipBg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(self.tipBg);
  local a=StringUtils:stuff_string_split(item_str);
  local s='<content>';
  local n;
  if 1<table.getn(a) then
    for k,v in pairs(a) do
      s=s .. '<font color="' .. getColorByQuality(analysis("Daoju_Daojubiao",v[1],"color"),true) .. '">' .. analysis("Daoju_Daojubiao",v[1],"name") .. '</font><font color="#FFFFFF">' .. 'X' .. v[2] .. '</font>';
    end
    n=makeSize(222,131);
  elseif 1000000<tonumber(a[1][1]) then
    s=s .. '<font color="' .. getColorByQuality(analysis("Daoju_Daojubiao",a[1][1],"color"),true) .. '">' .. analysis("Daoju_Daojubiao",a[1][1],"name") .. '</font>';
    if 1003001==tonumber(a[1][1]) or 1003002==tonumber(a[1][1]) then
      n=makeSize(181,61);
    elseif 1001==math.floor(tonumber(a[1][1])/1000) or 1002==math.floor(tonumber(a[1][1])/1000) or 1210==math.floor(tonumber(a[1][1])/1000) then
      n=makeSize(222,231);
    else
      n=makeSize(141,90);
    end
  else
    s=s .. '<font color="#FFFFFF">' .. analysis("Daoju_Daojubiao",a[1][1],"name") .. " " .. a[1][2] .. '</font>';
    n=makeSize(181,61);
  end
  s=s .. '</content>';
  local tip=CommonSkeleton:getBoneTexture9DisplayBySize("common_currency_bg",false,n);
  tip.touchEnabled=false;
  tip.touchChildren=false;
  local tipSize=tip:getContentSize();

  local ret=createMultiColoredLabelWithTextData({x=0,y=0,width=-5+tipSize.width,height=-5+tipSize.height,lineType="single line",size=22,color="ffffff",alignment=kCCTextAlignmentCenter,space=0,textType="static"},s);
  local retSize=ret:getContentSize();
  ret:setPositionY((tipSize.height-retSize.height)/2);

  if 1<table.getn(a) then

  elseif 1000000<tonumber(a[1][1]) then
    if 1003001==tonumber(a[1][1]) or 1003002==tonumber(a[1][1]) then
      ret:setPositionY(-3+ret:getPositionY());
    elseif 1001==math.floor(tonumber(a[1][1])/1000) or 1002==math.floor(tonumber(a[1][1])/1000) or 1210==math.floor(tonumber(a[1][1])/1000) then
      print(tipSize.height);
      local ret1=createTextFieldWithTextData({x=10,y=0,width=-20+tipSize.width,height=-5+tipSize.height,lineType="single line",size=22,color=16777215,alignment=kCCTextAlignmentLeft,space=0,textType="static"},analysis("Daoju_Daojubiao",tonumber(a[1][1]),"function"));
      local ret1Size=ret1:getContentSize();
      ret:setPositionY(190);
      ret1:setPositionY(-39);
      tip:addChild(ret1);
    else
      local ret1=createMultiColoredLabelWithTextData({x=0,y=0,width=-5+tipSize.width,height=-5+tipSize.height,lineType="single line",size=22,color="ffffff",alignment=kCCTextAlignmentCenter,space=0,textType="static"},'<content><font color="#FFFFFF">' .. analysis("Daoju_Daojufenlei",math.floor(tonumber(a[1][1])/1000),"function") .. '</font></content>');
      local ret1Size=ret1:getContentSize();
      ret:setPositionY(50);
      ret1:setPositionY(20);
      tip:addChild(ret1);
    end
  else
    ret:setPositionY(-3+ret:getPositionY());
  end

  tip:addChild(ret);
  tip:setPosition(getTipPosition(tip,position));
  self:addChild(tip);
end

function AdaptableTip:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end