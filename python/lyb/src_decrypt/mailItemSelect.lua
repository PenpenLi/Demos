require "main.view.mail.ui.mailPopup.MailDetail";
require "main.view.mail.ui.mailPopup.MailDetailWithBonus";

local mailItemSelect = nil;

MailItem=class(Layer);

function MailItem:ctor()
  self.class=MailItem;
end

function MailItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	MailItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function MailItem:initialize(context, itemData)
  self:initLayer();
  self.context = context;
  self.itemData = itemData;
  self.skeleton = self.context.skeleton;
  self.items = {};
  -- <!-- ConfigId不为0时邮件内容读表 ByteType: 1:一次性邮件  2:持续型邮件  ByteState: 0,未读 1,已读 -->
  -- <sequence>MailId,ConfigId,ParamStr1,Title,FromUserName,DateTime,Content,ByteState,ItemIdArray,ByteType</sequence>

  --骨骼
  local armature = self.skeleton:buildArmature("item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  armature = armature.display;
  self:addChild(armature);

  self:refreshReadImage();

  local text_data = self.armature4dispose:getBone("title_descb").textData;
  local title_descb = createTextFieldWithTextData(text_data,self.itemData.Title);
  self.armature4dispose.display:addChild(title_descb);

  text_data = self.armature4dispose:getBone("auther_descb").textData;
  local auther_descb = createRichMultiColoredLabelWithTextData(text_data,"<content><font color='#4F2900'>发件人 : </font><font color='#B33B01'>" .. self.itemData.FromUserName .. "</font></content>");
  self.armature4dispose.display:addChild(auther_descb);

  text_data = self.armature4dispose:getBone("date_descb").textData;
  local date_descb = createTextFieldWithTextData(text_data,os.date("%Y-%m-%d %H:%M:%S",self.itemData.DateTime));
  self.armature4dispose.display:addChild(date_descb);

  self:addEventListener(DisplayEvents.kTouchBegin,self.onSelfBegin,self);
  self:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);

  self.select_img = armature:getChildByName("item_fg");
  self.select_img.touchEnabled = false;
  self.select_img:setVisible(false);
end

function MailItem:onSelfBegin(event)
  -- self:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  -- self:addEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  self.beginX = event.globalPosition.x;
  self.armature4dispose.display:setPositionXY(13,4);
  self.armature4dispose.display:setScale(0.95);
end

function MailItem:onSelfEnd(event)
  self.endX = event.globalPosition.x;
  if self.beginX and math.abs(self.beginX - self.endX) < 10 then
    if 0 == self.itemData.ByteState then
      self.itemData.ByteState = 1;
      self:refreshReadImage();
      self.context.context:onRead({MailId = self.itemData.MailId});
    end
    self.context.context:onMailItemTap(self);
    if mailItemSelect then
      mailItemSelect:select(false);
      mailItemSelect = nil;
    end
    mailItemSelect = self;
    mailItemSelect:select(true);
  end
  self.armature4dispose.display:setPositionXY(0,0);
  self.armature4dispose.display:setScale(1);
end

function MailItem:onSelfMove(event)
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  self:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
end

function MailItem:refreshReadImage()
  if self.readImage then
    self.armature4dispose.display:removeChild(self.readImage);
  end
  if 0 == self.itemData.ByteState then
    self.readImage = self.skeleton:getBoneTextureDisplay(0 == table.getn(self.itemData.ItemIdArray) and "mail_uis/weidu_img" or "mail_uis/weidu_img_bonus");
    self.readImage : setPositionXY(25,42);
  else
    self.readImage = self.skeleton:getBoneTextureDisplay(0 == table.getn(self.itemData.ItemIdArray) and "mail_uis/yidu_img" or "mail_uis/yidu_img_bonus");
    self.readImage:setPositionXY(25,42);
  end
  self.armature4dispose.display:addChild(self.readImage);
end

function MailItem:select(bool)
  if not self.select_img.isDisposed then
    self.select_img:setVisible(bool);
  end
end