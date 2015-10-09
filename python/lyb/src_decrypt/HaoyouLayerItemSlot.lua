require "core.controls.page.CommonSlot";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

HaoyouLayerItemSlot=class(CommonSlot);

function HaoyouLayerItemSlot:ctor()
  self.class=HaoyouLayerItemSlot;
end

function HaoyouLayerItemSlot:dispose()
  self:removeAllEventListeners();
  HaoyouLayerItemSlot.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function HaoyouLayerItemSlot:initialize(context)
	self.context = context;
	self.skeleton = self.context.skeleton;

	self:initLayer();
	--骨骼
  local armature=self.skeleton:buildArmature("buddy_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="";
  self.name_descb=createTextFieldWithTextData(armature:getBone("buddy_name_bg").textData,text);
  self:addChild(self.name_descb);

  self.level_descb=createTextFieldWithTextData(armature:getBone("level_descb").textData,text);
  self:addChild(self.level_descb);

  self.zhanli_descb=createTextFieldWithTextData(armature:getBone("zhanli_descb").textData,text);
  self:addChild(self.zhanli_descb);

  local button=self.armature4dispose.display:getChildByName("button");
  local button_pos=convertBone2LB4Button(button);
  self.armature4dispose.display:removeChild(button);
  local button_text_data = self.armature4dispose:findChildArmature("button"):getBone("common_small_blue_button").textData;
  button_text_data = copyTable(button_text_data);
  button_text_data.x = button_text_data.x;
  button_text_data.y = -1 + button_text_data.y;
  button_text_data.size = 5 + button_text_data.size;
  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(button_text_data,"送鲜花",true);
  -- button:initializeBMText("进阶","anniutuzi");
  -- button:setPosition(button_pos);
  layer:setScale(0.8);
  layer:setPositionXY(5 + button_pos.x, 3 + button_pos.y);
  layer:addChild(button);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,1);
  self.armature4dispose.display:addChild(layer);
  self["left_btn"] = button;

  local layer = Layer.new();
  layer:initLayer();
  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeText(button_text_data,"送体力",true);
  -- button:initializeBMText("进阶","anniutuzi");
  -- button:setScale(0.9);
  -- button:setPosition(button_pos);
  layer:setScale(0.8);
  layer:setPositionXY(120 + button_pos.x, 3 + button_pos.y);
  layer:addChild(button);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,2);
  self.armature4dispose.display:addChild(layer);
  self["right_btn"] = button;
end

function HaoyouLayerItemSlot:onFlowerTap(event)
	self.context:onSendFlowerButtonTap(self.data);
end

function HaoyouLayerItemSlot:onPopTap(event)
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

function HaoyouLayerItemSlot:onButtonTap(event, num)
  if 1 == num then
    local haoyouSonghuaLayer = HaoyouSonghuaLayer.new();
    haoyouSonghuaLayer:initialize(self.context,self.data.UserId);
    self.context:addChild(haoyouSonghuaLayer);

    self.context.haoyouSonghuaLayer=haoyouSonghuaLayer;
  elseif 2 == num then
    log("111111--->");
    local count=self.context.countControlProxy:getRemainCountByID(CountControlConfig.TI_SEND,CountControlConfig.Parameter_1);
    log("222");
    if 0 >= count then
      log("333");
      sharedTextAnimateReward():animateStartByString("送体力达到次数上限啦 ~");
      log("444");
      return;
    end
    log("555");
    self.context.haoyouLayerItemSlotSongtili = self;
    log("666");
    initializeSmallLoading();
    sendMessage(21,7,{UserId = self.data.UserId});
    log("777");
  end
end

function HaoyouLayerItemSlot:refreshSongtiliBTN()
  log("101010");
  self.data.BooleanValue3 = 1;
  self:refreshBTN();
  log("111111");
  sharedTextAnimateReward():animateStartByString("送体力成功啦 ~");
end

function HaoyouLayerItemSlot:refreshBTN()
  self.left_btn:setGray(1 == self.data.BooleanValue2);
  self.right_btn:setGray(1 == self.data.BooleanValue3);
  self["left_btn"]:setGray(true);
end

function HaoyouLayerItemSlot:setSlotData(data)
  log("->--" .. data.UserName);
  self.data = data;

  if self.img then
    self.armature:removeChild(self.img);
    self.img = nil;
  end

  self.img = Image.new();
  self.img:loadByArtID(analysis("Zhujiao_Huanhua",self.data.TransforId,"head"));
  self.img:setPositionXY(86,107);
  self.img:addEventListener(DisplayEvents.kTouchTap,self.onImgTap,self);
  self.armature:addChildAt(self.img,5);

  if nil ~= self.data.Vip and 0 ~= self.data.Vip then
    local vip = getVIPImgMainUI(self.data.Vip);
    if vip then
      vip:setScale(0.76);
      vip:setPositionXY(-12,55);
      self.img:addChild(vip);
    end
  end

  self.name_descb:setString(self.data.UserName);
  self.level_descb:setString(self.data.Level);
  self.zhanli_descb:setString("战力: " .. self.data.Zhanli);

  self:refreshBTN();
end

function HaoyouLayerItemSlot:onImgTap(event)
  initializeSmallLoading();
  sendMessage(3,11,{UserId=self.data.UserId,UserName=""});
end