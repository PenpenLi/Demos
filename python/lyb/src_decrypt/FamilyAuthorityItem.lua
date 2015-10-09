--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyAuthorityItem=class(TouchLayer);

function FamilyAuthorityItem:ctor()
  self.class=FamilyAuthorityItem;
end

function FamilyAuthorityItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyAuthorityItem.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyAuthorityItem:initialize(skeleton, familyProxy, container, parent_container, id)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.container=container;
  self.parent_container=parent_container;
  self.id=id;
  self.auth_bool=self:hasAuthority();
  
  --骨骼
  local armature=skeleton:buildArmature("authority_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- local color=13==self.id and (self.familyProxy:getImpeachable() and '00FF00' or 'CCCCCC') or (self.auth_bool and '00FF00' or 'CCCCCC');
  -- local text='<content><font color="#' .. color .. '" ref="1">' .. analysis("Jiazu_Zuyuanquanxian",self.id,"name") .. '</font></content>';
  -- local text_data=armature:getBone("authority_item_bg").textData;
  -- self.authority_item_bg=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- if self.auth_bool then
  --   self.authority_item_bg:addEventListener(DisplayEvents.kTouchTap,self.onTap,self);
  -- end
  -- self.armature:addChild(self.authority_item_bg);

  -- text=self.auth_bool and analysis("Jiazu_Zuyuanquanxian",self.id,"explain") or self:getPosition(self.id);
  -- text_data=armature:getBone("descb").textData;
  -- self.descb=createTextFieldWithTextData(text_data,text);
  -- self.armature:addChild(self.descb);

  local text=analysis("Bangpai_Zuyuanquanxian",self.id,"explain");
  local text_data=armature:getBone("authority_item_bg").textData;
  self.authority_item_bg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.authority_item_bg);

  self.button=Button.new(armature:findChildArmature("descb"),false);
  self.button.bone:initTextFieldWithString("common_small_orange_button",analysis("Bangpai_Zuyuanquanxian",self.id,"name"));
  self.button:addEventListener(Events.kStart,self.onTap,self);
end

function FamilyAuthorityItem:onTap(event)
  -- if 1==self.id then
  --   local a=FamilyInviteLayer.new();
  --   a:initialize(self.skeleton,self.familyProxy,self.parent_container);
  --   self.parent_container:addChild(a);
  -- elseif 2==self.id then
  --   self.parent_container:getPanel(1):onLevelupButtonTap();
  -- elseif 3==self.id then
  --   self.parent_container:onTabButton(self.parent_container.tab_buttons[4]);
  -- elseif 4==self.id then
  --   self.parent_container:getPanel(1):onChangeNoticeTap();
  -- elseif 5==self.id or 11==self.id then
  --   self.parent_container:getPanel(1):onDismissButtonTap();
  -- elseif 6==self.id or 8==self.id or 9==self.id then
  --   self.parent_container:onTabButton(self.parent_container.tab_buttons[2]);
  --   if 8==self.id then
  --     sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_143));
  --   end
  -- elseif 7==self.id then
  --   local a=self:getItemByID(2);
  --   if a then
  --     a:onActivateTap();
  --   else
  --     sharedTextAnimateReward():animateStartByString("家族等级不够哦~");
  --   end
  -- elseif 10==self.id then
  --   local a=self:getItemByID(4);
  --   if a then
  --     a:onActivateTap();
  --   else
  --     sharedTextAnimateReward():animateStartByString("家族等级不够哦~");
  --   end
  -- elseif 12==self.id then
  --   self.parent_container:dispatchEvent(Event.new("TO_AUTO_GUIDE",FunctionConfig.FUNCTION_ID_128,self));
  -- elseif 13==self.id then
  --   if self.familyProxy:getImpeachable() then
  --     self.parent_container:onImpeach();
  --   else
  --     return;
  --   end
  -- end

  if 1 == self.id then
    self.parent_container:onShenqingTap(nil);
  elseif 2 == self.id then
    self.parent_container:getPanel(1):onChangeNoticeTap();
  elseif 3 == self.id then
    self.parent_container:getPanel(1):onDismissButtonTap();
  elseif 4 == self.id then
    self.parent_container:onChengyuanTap(nil);
  elseif 5 == self.id then
    self.parent_container:getPanel(1):onDismissButtonTap();
  end
  self.container:closeTip();
end

function FamilyAuthorityItem:getItemByID(id)
  for k,v in pairs(self.parent_container:getPanel(1).items) do
    if id==v.id then
      return v;
    end
  end
end

function FamilyAuthorityItem:hasAuthority()
  local authority=analysis("Jiazu_Zhiweidengjibiao",self.container.userProxy:getFamilyPositionID(),"quanxian");
  authority=StringUtils:lua_string_split(authority,",");
  for k,v in pairs(authority) do
    if self.id==tonumber(v) then
      return true;
    end
  end
  return false;
end

function FamilyAuthorityItem:getPosition(id)
  local a=5;
  while analysisHas("Jiazu_Zhiweidengjibiao",a) do
    local authority=analysis("Jiazu_Zhiweidengjibiao",a,"quanxian");
    authority=StringUtils:lua_string_split(authority,",");
    for k,v in pairs(authority) do
      if id==tonumber(v) then
        return analysis("Jiazu_Zhiweidengjibiao",a,"name") .. "权限";
      end
    end
    a=-1+a;
  end
  return "";
end