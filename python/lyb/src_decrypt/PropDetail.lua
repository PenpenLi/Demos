require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";

PropDetail=class(Layer);

function PropDetail:ctor()
  self.class=PropDetail;
end

function PropDetail:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PropDetail.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function PropDetail:initialize(skeleton)
  self:initLayer();
  
  local armature=skeleton:buildArmature("bag_prop_detail");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  local armature_d=armature.display;
  
  self:addChild(armature_d);
  self.const_prop_id={-1,-2,2,3,1,30,29,-3,-4,6,7,20,28,37};
  self.const_prop_name={"名字","家族","攻击","防御","生命","格挡","破击","职业","势力","命中","闪避","暴击","韧性","免破"};
  self.textFields={};
  
  --bag_avatar_name
  local name_text_data=armature:getBone("bag_avatar_name").textData;
  local text_data_x,text_data_y=name_text_data.x,name_text_data.y;
  
  --bag_avatar_title
  local text_data_title=armature:getBone("bag_avatar_title").textData;
  local hori_dis=text_data_title.x-name_text_data.x;
  
  --bag_avatar_clan
  local bag_avatar_clan=armature:getBone("bag_avatar_clan").textData;
  local verti_dis=bag_avatar_clan.y-name_text_data.y;
  
  --text_descb
  local a=0;
  local num=table.getn(self.const_prop_id);
  while num>a do
    a=a+1;
    
    local text;
    local textField;
    local text_data=self:textClone(name_text_data);
    text_data.x=text_data_x+math.floor((a-1)/7)*hori_dis;
    text_data.y=text_data_y+(a-1)%7*verti_dis;
    if 1==a then
      text="";
      self.name_descb=createTextFieldWithTextData(text_data,text);
      self:addChild(self.name_descb);
    elseif 2==a then
      text="";
      local clan_text_data=copyTable(text_data);
      clan_text_data.width=1.5*clan_text_data.width;
      self.clan_descb=createTextFieldWithTextData(clan_text_data,text);
      self:addChild(self.clan_descb);
    elseif 8==a then
      text="";
      self.title_descb=createTextFieldWithTextData(text_data,text);
      self:addChild(self.title_descb);
    elseif 9==a then
      text="";
      self.influence_descb=createTextFieldWithTextData(text_data,text);
      self:addChild(self.influence_descb);
    else
      text="0";
      self.textFields[self.const_prop_id[a]]=createTextFieldWithTextData(text_data,text);
      self:addChild(self.textFields[self.const_prop_id[a]]);
    end

    text_data=self:textClone(text_data);
    text_data.x=-70+text_data.x;
    text_data.color=14799520;
    textField=createTextFieldWithTextData(text_data,self.const_prop_name[a]);
    self:addChild(textField);
  end

  self.common_copy_bluelonground_button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.common_copy_bluelonground_button.bone:initTextFieldWithString("common_copy_bluelonground_button","查看英魂");
  self.common_copy_bluelonground_button:addEventListener(Events.kStart,self.onHeroTap,self);
  self.common_copy_bluelonground_button:getDisplay():setVisible(false);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function PropDetail:onSelfTap(event)
  self.parent.popup_boolean=true;
end

--更新角色属性
function PropDetail:refreshAvatarProperty(userProxy, avatarPropertyProxy)
  self.name_descb:setString(StringUtils:substr(userProxy:getUserName()));
  self.clan_descb:setString(""==avatarPropertyProxy:getFamilyName() and "暂无" or avatarPropertyProxy:getFamilyName());
  self.title_descb:setString(analysis("Wujiang_Wujiangzhiye",userProxy:getCareer(),"occupation"))
  self.influence_descb:setString("暂无");
  
  avatarPropertyProxy=avatarPropertyProxy:getData();
  for k,v in pairs(avatarPropertyProxy) do
    print("property_detail",k,v);
    if self.textFields[k] then
      self.textFields[k]:setString(v);
    end
  end
end

function PropDetail:textClone(textData)
  local a={};
  for k,v in pairs(textData) do
    a[k]=v;
  end
  return a;
end

--更新玩家
function PropDetail:refreshAvatarProperty4Player(playerName, career, unitPropertyArray, familyId, familyName)
  self.name_descb:setString(StringUtils:substr(playerName));
  self.clan_descb:setString(0==familyId and "暂无" or familyName);
  self.title_descb:setString(analysis("Wujiang_Wujiangzhiye",career,"occupation"));
  self.influence_descb:setString("暂无");
  
  avatarPropertyProxy=unitPropertyArray;
  for k,v in pairs(avatarPropertyProxy) do
    if self.textFields[v.PropertyKey] then
      self.textFields[v.PropertyKey]:setString(v.PropertyValue);
    end
  end

  self.common_copy_bluelonground_button:getDisplay():setVisible(true);
end

function PropDetail:onHeroTap(event)
  self.parent.context:dispatchEvent(Event.new("TO_HERO_SKILL"));
  self.parent.context.parent:addChild(self.parent.context.panels[2]);
end