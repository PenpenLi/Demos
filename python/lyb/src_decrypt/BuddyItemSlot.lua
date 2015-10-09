require "core.controls.page.CommonSlot";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

BuddyItemSlot=class(CommonSlot);

local buddyItem = nil;
function BuddyItemSlot:ctor()
  self.class=BuddyItemSlot;
end

function BuddyItemSlot:dispose()
	buddyItem = nil;
  self:removeAllEventListeners();
  BuddyItemSlot.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyItemSlot:initialize(context, data)
	self.context = context;
	self.skeleton = self.context.skeleton;
	self.data = data;

	self:initLayer();
	--骨骼
  local armature=self.skeleton:buildArmature("buddy_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local image = Image.new();
  image:loadByArtID(analysis("Zhujiao_Zhujiaozhiye",self.data.Career,"touxiang"));
  image:setPositionXY(10,8);
  self:addChild(image);

  local text=self.data.UserName .. " Lv." .. self.data.Level;
  self.name_descb=createTextFieldWithTextData(armature:getBone("bag_item_name").textData,text);
  self:addChild(self.name_descb);

  text="Lv." .. self.data.Level;
  self.level_descb=createTextFieldWithTextData(armature:getBone("bag_item_level").textData,text);
  self:addChild(self.level_descb);

  text=self.data.Zhanli;
  self.zhanli_descb=createTextFieldWithTextData(armature:getBone("zhanli_img").textData,text);
  self:addChild(self.zhanli_descb);

  self.item_over=self.armature:getChildByName("buddy_item_over");
  self.item_over.touchEnabled=false;
  self.armature:removeChild(self.item_over,false);
  self.armature:addChild(self.item_over);
  self:select(false);

  self.armature:getChildByName("buddy_item_flower"):addEventListener(DisplayEvents.kTouchTap,self.onFlowerTap,self);

  local layer = Layer.new();
  layer:initLayer();
  layer:setContentSize(makeSize(345,139));
  layer:addEventListener(DisplayEvents.kTouchTap,self.onPopTap,self);
  self:addChild(layer);

  self:addEventListener(DisplayEvents.kTouchTap,self.onItemTap,self);
end

function BuddyItemSlot:onItemTap(event)
  print(event,event.globalPosition.x,event.globalPosition.y);
  if buddyItem == self then
  	return;
  end
  if buddyItem then
  	buddyItem:select(false);
  end
  buddyItem=self;
  buddyItem:select(true);
end

function BuddyItemSlot:select(bool)
	self.item_over:setVisible(bool);
end

function BuddyItemSlot:onFlowerTap(event)
	self.context:onSendFlowerButtonTap(self.data);
end

function BuddyItemSlot:onPopTap(event)
	local buttonsSelector=ButtonsSelector.new();
	local function onLookInto(data)

		buttonsSelector.parent:removeChild(buttonsSelector);
	end
	local function onDelete(data)
		self.context:dispatchEvent(Event.new("chatDeleteBuddy",{UserId=self.data.UserId},self));
		buttonsSelector.parent:removeChild(buttonsSelector);
	end
	local function onSendFlower(data)
		self.context:onSendFlowerButtonTap(self.data);
		buttonsSelector.parent:removeChild(buttonsSelector);
	end
    local functions={onSendFlower, onDelete, onLookInto};
    local texts={"送鲜花","删除","查看"};
    buttonsSelector:initialize(functions,texts,self.data);
    buttonsSelector:setPos(event.globalPosition);
    self.context:addChild(buttonsSelector);
end

function BuddyItemSlot:setSlotData(data)
  log("->--" .. data.UserName);
end