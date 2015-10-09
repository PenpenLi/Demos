require "main.view.mail.ui.mailPopup.MailItem";

MailLayer=class(Layer);

function MailLayer:ctor()
  self.class=MailLayer;
end

function MailLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	MailLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function MailLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.items={};
  
  --骨骼
  local armature=self.skeleton:buildArmature("mail_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  
  armature=armature.display;
  self:addChild(armature);

  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_1_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_2_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_2_3_2"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_4"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_1_2"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_3_2_2"):setScaleY(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleX(-1);
  -- armature:getChildByName("bag_background"):getChildByName("bag_background_img_sub_4_3"):setScaleY(-1);

  -- self.closeButton = Button.new(self.armature4dispose:findChildArmature("common_close_button"), false);
  -- self.closeButton:addEventListener(Events.kStart, self.context.closeUI, self.context);

  -- self.item_number_textField=createTextFieldWithTextData(self.armature4dispose:getBone("none_img").textData,"......\n暂无邮件");
  -- self:addChild(self.item_number_textField);

  self.closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);

  self.armature4dispose.display:getChildByName("none_img"):setVisible(false);
end

function MailLayer:initializeGallery()
  self.const_item_num=3.4;
  self.const_item_size=makeSize(520,168);
  self.const_item_layer_pos=makePoint(36,75);
  --item
  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPosition(self.const_item_layer_pos);
  self.item_layer:setViewSize(makeSize(self.const_item_size.width,
                                       self.const_item_num*self.const_item_size.height));
  self.item_layer:setItemSize(self.const_item_size);
  self:addChild(self.item_layer);

  self:addChild(self.closeButton);

  self.yijian_btn =self.armature4dispose.display:getChildByName("yijian_btn");
  SingleButton:create(self.yijian_btn);
  self.yijian_btn:addEventListener(DisplayEvents.kTouchTap, self.onYijianTap, self);
  self.armature4dispose.display:removeChild(self.yijian_btn,false);
  self:addChild(self.yijian_btn);
end

function MailLayer:onYijianTap(event)
  if self.context.bagProxy:getBagIsFull() then
    sharedTextAnimateReward():animateStartByString("背包满了呢 ~");
    return;
  end
  local items = {};
  for k,v in pairs(self.items) do
    if 0 < table.getn(v.itemData.ItemIdArray) then
      table.insert(items,v);
    end
  end
  if 0 == table.getn(items) then
    sharedTextAnimateReward():animateStartByString("没有可领取的邮件呢 ~");
    return;
  end
  for k,v in pairs(items) do
    self:removeMailItem(v);
  end
  self.context:onGetBonus({MailId = 0});
  self.context:closeMailItemDetail();
end

function MailLayer:removeGallery()
  self:removeChild(self.item_layer);
  self.item_layer=nil;
end

function MailLayer:removeMailItem(mailItem)
  for k,v in pairs(self.items) do
    if mailItem.itemData.MailId == v.itemData.MailId then
      self.item_layer:removeItemAt(-1 + k, true);
      table.remove(self.items, k);
      break;
    end
  end
  local hasMail = 0 ~= table.getn(self.items);
  self.armature4dispose.display:getChildByName("none_img"):setVisible(not hasMail);
  -- self.item_number_textField:setVisible(not hasMail);
end

function MailLayer:refreshMail()
  local data = self.context.mailProxy:getData();
  local mailArray = data.MailArray;
  local idArray = data.IDArray;
  for k,v in pairs(mailArray) do
    if 0 ~= v.ConfigId then
      print(v.ConfigId);
      local tb_data = analysis("Tishi_Xiaoxibiao",v.ConfigId);
      v.Title = tb_data.title;
      v.FromUserName = tb_data.addressor;
      v.Content = tb_data.text;
      local data = StringUtils:lua_string_split(v.ParamStr1,"#");
      for k_,v_ in pairs(data) do
        if 25 == v.ConfigId then
          if 1 == k_ or 3 == k_ then
            v.Content = string.gsub(v.Content,"@" .. k_,analysis("Huodong_Lishileijiqiandao",v_,"beizhu"));
          else
            v.Content = string.gsub(v.Content,"@" .. k_,v_);
          end
        else
          v.Content = string.gsub(v.Content,"@" .. k_,v_);
        end
      end
    end
  end
  local _n=0;
  local _num=table.getn(mailArray);
  while _n<_num do
    _n = 1+_n;
    local item = MailItem.new();
    item:initialize(self, mailArray[_n]);
    table.insert(self.items,item);
    self.item_layer:addItem(item);
  end

  local hasMail = 0 ~= table.getn(mailArray);
  self.armature4dispose.display:getChildByName("none_img"):setVisible(not hasMail);
  -- self.item_number_textField:setVisible(not hasMail);
end