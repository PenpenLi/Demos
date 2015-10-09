--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyLogItem=class(TouchLayer);

function FamilyLogItem:ctor()
  self.class=FamilyLogItem;
end

function FamilyLogItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyLogItem.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyLogItem:initialize(skeleton, familyProxy, parent_container, data)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  self.data=data;
  
  --骨骼
  local armature=skeleton:buildArmature("log_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local s=analysis("Jiazu_Jiazurizhi",self.data.ID,"txt");
  local a=1;
  while 4>a do
    if (2==self.data.ID or 3==self.data.ID) and 3==a then
      s=string.gsub(s,"@" .. a,analysis("Jiazu_Zhiweidengjibiao",self.data["ParamStr" .. a],"name"));
    elseif 6==self.data.ID and 2==a then
      s=string.gsub(s,"@" .. a,analysis("Jiazu_Huodong",self.data["ParamStr" .. a],"name"));
    elseif 9==self.data.ID and 1==a then
      s=string.gsub(s,"@" .. a,analysis("Jiazu_Zhiweidengjibiao",self.data["ParamStr" .. a],"name"));
    elseif 11==self.data.ID and 2==a then
      s=string.gsub(s,"@" .. a,analysis("Jiazu_Huodong",self.data["ParamStr" .. a],"name"));
    elseif 14==self.data.ID and 2==a then
      s=string.gsub(s,"@" .. a,analysis("Daoju_Daojubiao",self.data["ParamStr" .. a],"name"));
    elseif 18==self.data.ID and 1==a then
      s=string.gsub(s,"@" .. a,analysis("Jiazu_Jiazurenwu",self.data["ParamStr" .. a],"name"));
    else
      s=string.gsub(s,"@" .. a,self.data["ParamStr" .. a]);
    end
    a=1+a;
  end
  local text=s;
  local text_data=armature:getBone("log_descb").textData;
  self.log_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.log_descb);

  local a=os.date("*t",self.data.Time);
  local h=a.hour;
  if 10>tonumber(h) then
    h="0" .. h;
  end
  local m=a.min;
  if 10>tonumber(m) then
    m="0" .. m;
  end
  text=h .. ":" .. m;
  text_data=armature:getBone("time_descb").textData;
  self.time_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_descb);
end