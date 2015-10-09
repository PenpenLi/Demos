--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-9-10

	yanchuan.xie@happyelements.com
]]

BossInjureRankLayer=class(LayerColor);

function BossInjureRankLayer:ctor()
  self.class=BossInjureRankLayer;
end

function BossInjureRankLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BossInjureRankLayer.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function BossInjureRankLayer:initialize(userName)
  self:initLayer();
  self.rank_texts={};
  self.touchEnabled=false;
  self.touchChildren=false;
  self:setPositionXY(3,170);
  self:changeWidthAndHeight(275,245);
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
  self.userName=userName;

  local f_y=6;
  local f_xs={1,50,170};
  local skew_y=40;
  local a=0;
  while 6>a do
    a=1+a;
    local color=16777215;
    if 1==a then
      color=16711680;
    elseif 2==a then
      color=16752640;
    elseif 3==a then
      color=13107455;
    end
    local ret1=createTextFieldWithTextData({x=f_xs[1],y=f_y+skew_y*(6-a),width=50.6,height=26.5,lineType="single line",size=22,color=16777215,alignment=kCCTextAlignmentLeft,space=0,textType="static"},"",true);
    ret1:setColor(CommonUtils:ccc3FromUInt(color));
    self:addChild(ret1);
    table.insert(self.rank_texts,ret1);
    local ret2=createTextFieldWithTextData({x=f_xs[2],y=f_y+skew_y*(6-a),width=120,height=26.5,lineType="single line",size=22,color=16777215,alignment=kCCTextAlignmentLeft,space=0,textType="static"},"",true);
    ret2:setColor(CommonUtils:ccc3FromUInt(color));
    self:addChild(ret2);
    table.insert(self.rank_texts,ret2);
    local ret3=createTextFieldWithTextData({x=f_xs[3],y=f_y+skew_y*(6-a),width=130,height=26.5,lineType="single line",size=22,color=16777215,alignment=kCCTextAlignmentLeft,space=0,textType="static"},"",true);
    ret3:setColor(CommonUtils:ccc3FromUInt(color));
    self:addChild(ret3);
    table.insert(self.rank_texts,ret3);
  end
end

--{{Ranking,UserName,Count}}
function BossInjureRankLayer:refresh(data)
  if not data then return; end
  local array1 = {};
  local itemNum = 6
  for k,v in pairs(data) do--去重
    if array1[tostring(v.Ranking)] then
      itemNum = 5
    end
    if self.userName == v.UserName and v.Ranking < 6 then 
      itemNum = 5
    end
    if v.Ranking ~= 0 then
      array1[tostring(v.Ranking)]=v;
    end
  end
  local array2 = {}
  for k,v in pairs(array1) do--去重
      table.insert(array2,v)
  end
  local function sf(a, b)
    return a.Ranking<b.Ranking;
  end
  table.sort(array2,sf);
  for k,v in pairs(array2) do
    if itemNum<k then
      break;
    end
    local a=0;
    while 3>a do
      a=1+a;
      local s={v.Ranking,v.UserName,v.Count};
      self.rank_texts[-3+a+3*k]:setString(s[a]);
    end
  end
  if #array2<6 then
    local a=0;
    while 3>a do
      a=1+a;
      self.rank_texts[-3+a+3*6]:setString("");
    end
  end
end