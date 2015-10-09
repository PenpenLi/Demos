MailDetail=class(Layer);

function MailDetail:ctor()
  self.class=MailDetail;
end

function MailDetail:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	MailDetail.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function MailDetail:initialize(context, mailItem)
  self:initLayer();
  self.context = context;
  self.mailItem = mailItem;
  self.skeleton = self.context.skeleton;
  self.itemData = self.mailItem.itemData;
  
  --骨骼
  local armature = self.skeleton:buildArmature("mail_detail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  armature = armature.display;
  self:addChild(armature);

  local text_data = self.armature4dispose:getBone("mail_title_descb").textData;
  local mail_title_descb = createTextFieldWithTextData(text_data,self.itemData.Title);
  self:addChild(mail_title_descb);

  text_data = self.armature4dispose:getBone("mail_content_descb").textData;
  local mail_content_descb = createTextFieldWithTextData(text_data,self.itemData.Content);
  self:addChild(mail_content_descb);

  text_data = self.armature4dispose:getBone("mail_auther_descb").textData;
  local mail_auther_descb = createRichMultiColoredLabelWithTextData(text_data,"<content><font color='#FFFFFF'>发件人 : </font><font color='#FFA200'>" .. self.itemData.FromUserName .. "</font></content>");
  self:addChild(mail_auther_descb);

  -- self.closeButton = Button.new(self.armature4dispose:findChildArmature("common_blue_button"), false);
  -- self.closeButton.bone:initTextFieldWithString("common_blue_button","关闭");
  -- self.closeButton:addEventListener(Events.kStart, self.context.closeMailItemDetail, self.context);

  local button=armature:getChildByName("common_blue_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature4dispose.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("关闭","anniutuzi");
  button:setPosition(button_pos);
  -- button:addEventListener(DisplayEvents.kTouchTap,self.context.closeMailItemDetail,self.context);
  button:addEventListener(DisplayEvents.kTouchTap,self.onCloseTap,self);
  self.armature4dispose.display:addChild(button);
end

function MailDetail:onCloseTap(event)
  self.context:closeMailItemDetail();
  self.context:removeMailItem(self.mailItem);
end