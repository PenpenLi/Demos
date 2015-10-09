require "main.config.ConstConfig";

OtherPlayerMenuPopup=class(TouchLayer);

function OtherPlayerMenuPopup:ctor()
  self.class=OtherPlayerMenuPopup;
  self.buttonsTable = {};
end

function OtherPlayerMenuPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	OtherPlayerMenuPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function OtherPlayerMenuPopup:initializeUI(generalListProxy, buddyListProxy, userProxy, data)
  self:initLayer();
  self.data=data;
  
  self.labelTable = {[1]="查看", [2]="切磋"};
  if buddyListProxy:getBuddyData(data.playerName) then
    table.insert(self.labelTable, "聊天");
  else
    table.insert(self.labelTable, "私聊");
    table.insert(self.labelTable, "加好友");
  end

  if userProxy.familyId ~= 0 then
    table.insert(self.labelTable, "邀家族");
  end
  local armatureName
  local prefix = "common_buddy_" 
  local suffix = "item_popup_pannel" 

  if #self.labelTable == 4 then
     armatureName = prefix .. suffix;
  else
     armatureName = prefix .. #self.labelTable .. "_" .. suffix;
  end

  local armature=CommonSkeleton:buildArmature(armatureName);
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;
  self.armature_d = armature_d;

  local mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
  self:addEventListener(DisplayEvents.kTouchTap, self.onLayerTap, self);
  
  self:addChild(armature_d);
  if self.data.position then
    armature_d:setPosition(getTipPosition(armature_d,self.data.position));
  else
    armature_d:setPositionXY(114, 170);
  end
    
    --text
  local textArm = armature:findChildArmature("common_copy_blueround_button_1");
  
  local trimButtonData=textArm:getBone("common_blueround_button").textData;
  
  for i_k, i_v in pairs(self.labelTable) do 
    local tab1Button=armature_d:getChildByName("common_copy_blueround_button_" .. i_k);
    local tab1_pos=convertBone2LB4Button(tab1Button);
    armature_d:removeChild(tab1Button);
    --tab1Button
    tab1Button=CommonButton.new();
    tab1Button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    tab1Button:initializeText(trimButtonData, self.labelTable[i_k]);
    if i_k == 1 and data.playerID > ConstConfig.CONST_ROBOT_ID then
      tab1Button:setGray(true);
    end
    tab1Button:setPosition(tab1_pos);
    tab1Button:addEventListener(DisplayEvents.kTouchTap, self.onTap, self);
    armature_d:addChild(tab1Button);
    table.insert(self.buttonsTable, tab1Button);
  end
  if data.playerName == "侠士" then
    for k,v in pairs(self.buttonsTable) do
      v:setGray(true)
    end
  end
end
function OtherPlayerMenuPopup:onTap(event)
  local index;
  for i_k, i_v in pairs(self.buttonsTable) do
    if i_v == event.target then
      index = i_k; 
    end
  end
    --[[if index == 1 then
     
   elseif index == 2 then
     
   elseif index == 3 then
     
   elseif index == 4 then
    end]]

  local openMenuEvent = Event.new("OPEN_MENU_COMMAND", {index = index}, self);
  self:dispatchEvent(openMenuEvent);
  self:onLayerTap(nil);
end
function OtherPlayerMenuPopup:onLayerTap(event)
  if self.data.func then
    self.data.func(self.data.context);
  end
  local removeMenuEvent = Event.new("REMOVE_MENU_CLICK", nil, self);
  self:dispatchEvent(removeMenuEvent);
end

