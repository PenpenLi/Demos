require "core.utils.CommonUtil";
require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.controls.CommonPopup";
require "core.controls.TextLineInput";
require "main.view.chat.ui.chatPopup.ChatContentItem";
require "main.view.chat.ui.popLayer.FacesPopLayer";
require "main.view.chat.ui.popLayer.ItemsPopLayer";
require "main.view.chat.ui.popLayer.HeroPartakePopLayer";
require "core.controls.CommonScrollList";

ChatLayerPop=class(Layer);

function ChatLayerPop:ctor()
  self.class=ChatLayerPop;
end

function ChatLayerPop:dispose()
  if self.sprite then self:stopAllActions(); end
  self:removeAllEventListeners();
  self:removeChildren();
  ChatLayerPop.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function ChatLayerPop:initialize(context, container)
  self:initLayer();
  self.context=context;
  self.container=container;
  self.skeleton=self.context.skeleton;
  self.bagProxy=self.context.bagProxy;
  self.equipmentInfoProxy=self.context.equipmentInfoProxy;
  self.heroHouseProxy = self.context.heroHouseProxy;

  self.const_pop_pos_1=makePoint(104,-272);
  self.const_pop_pos_2=makePoint(104,57);
  self.facePopLayer=nil;
  self.bagEquipsPopLayer=nil;
  self.heroPartakePopLayer = nil;
  self.select_button=0;
  self.buttons={};
  self.is_poped=false;

  --骨骼
  local armature=self.skeleton:buildArmature("chat_pop");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- self.chat_pop_button=Button.new(armature:findChildArmature("chat_pop_button"),false);
  -- --self.chat_pop_button.bone:initTextFieldWithString("pop_button","+");
  -- self.chat_pop_button:addEventListener(Events.kStart,self.onChatPopButtonTap,self);

  local chat_pop_button=self.armature:getChildByName("chat_pop_button");
  local chat_pop_button_pos=convertBone2LB4Button(chat_pop_button);
  self.armature:removeChild(chat_pop_button);
  self.chat_pop_button=CommonButton.new();
  self.chat_pop_button:initialize("chatButtons/pop_button_normal",nil,CommonButtonTouchable.BUTTON,self.skeleton);
  --common_copy_blueround_button:initializeText(common_copy_blueround_button_text_data,"发送");
  -- self.chat_pop_button:initializeBMText("发送","anniutuzi");
  self.chat_pop_button:setPosition(chat_pop_button_pos);
  self.chat_pop_button:addEventListener(DisplayEvents.kTouchTap,self.onChatPopButtonTap,self);
  self.armature:addChildAt(self.chat_pop_button,7);

  self.chat_jiahao = self.armature:getChildByName("chat_jiahao");
  self.chat_jiahao.touchEnabled = false;
  self.chat_jiahao:setVisible(true);
  self.chat_jianhao = self.armature:getChildByName("chat_jianhao");
  self.chat_jianhao.touchEnabled = false;
  self.chat_jianhao:setVisible(false);

  self.pLabelFont=BitmapTextField.new("","anniutuzi");
  self.pLabelFont:setPositionXY(65,372);
  self.armature:addChild(self.pLabelFont);

  -- local back_button=Button.new(armature:findChildArmature("back_button"),false);
  -- back_button:addEventListener(Events.kStart,self.onBackSpaceButtonTap,self);

  local back_button=self.armature:getChildByName("back_button");
  local back_button_pos=convertBone2LB4Button(back_button);
  self.armature:removeChild(back_button);
  self.back_button=CommonButton.new();
  self.back_button:initialize("chatButtons/back_button_normal",nil,CommonButtonTouchable.BUTTON,self.skeleton);
  --common_copy_blueround_button:initializeText(common_copy_blueround_button_text_data,"发送");
  -- self.chat_pop_button:initializeBMText("发送","anniutuzi");
  self.back_button:setPosition(back_button_pos);
  self.back_button:addEventListener(DisplayEvents.kTouchTap,self.onBackSpaceButtonTap,self);
  self.armature:addChildAt(self.back_button,7);

  local _count=1;
  local _texts={"表 情","英 雄","装 备","语 音","图 片"};
  while 3>_count do
    local insert_button=self.armature:getChildByName("insert_button_" .. _count);
    local insert_button_pos=convertBone2LB4Button(insert_button);
    self.armature:removeChild(insert_button);
    insert_button=CommonButton.new();
    insert_button:initialize("shuru_tab_btn_normal","shuru_tab_btn_down",CommonButtonTouchable.CUSTOM,self.skeleton);
    --insert_button:initializeText(armature:findChildArmature("insert_button_" .. _count):getBone("common_small_blue_button").textData,_texts[_count]);
    insert_button:initializeBMText(_texts[_count],"anniutuzi");
    insert_button:setPosition(insert_button_pos);
    insert_button:addEventListener(DisplayEvents.kTouchTap,self.onInsertButtonTap,self,_count);
    self.armature:addChild(insert_button);
    table.insert(self.buttons,insert_button);
    -- local fg=self.armature:getChildByName("button_img_" .. _count);
    -- fg.touchEnabled=false;
    -- self.armature:removeChild(fg,false);
    -- self.armature:addChild(fg);
    if 4==_count or 5==_count then
      insert_button:setGray(true);
    end
    _count=1+_count;
  end

  local common_copy_blueround_button=self.armature:getChildByName("common_small_blue_button");
  local common_copy_blueround_button_pos=convertBone2LB4Button(common_copy_blueround_button);
  local common_copy_blueround_button_text_data=armature:findChildArmature("common_small_blue_button"):getBone("common_small_blue_button").textData;
  self.armature:removeChild(common_copy_blueround_button);
  common_copy_blueround_button=CommonButton.new();
  common_copy_blueround_button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --common_copy_blueround_button:initializeText(common_copy_blueround_button_text_data,"发送");
  common_copy_blueround_button:initializeBMText("发送","anniutuzi");
  common_copy_blueround_button:setPosition(common_copy_blueround_button_pos);
  common_copy_blueround_button:addEventListener(DisplayEvents.kTouchTap,self.container.onSendButtonTap,self.container);
  self.armature:addChild(common_copy_blueround_button);

  --发送input
  self.send_text_data=armature:getBone("chat_bg_scalable").textData;

  local text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,30+self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(30);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);

  self.armature:setPosition(self.const_pop_pos_1);
  --self:onInsertButtonTap({target=self.buttons[1]},1);
  self.armature:getChildByName("chat_bg_scalable_2"):setVisible(false);
  self.armature:getChildByName("chat_pop_bg"):setVisible(false);

  local text_data = self.armature4dispose:getBone("trumpet_descb").textData;
  self.trumpet_descb = createTextFieldWithTextData(text_data,self.context.bagProxy:getItemNum(ConstItemIDConfig.ID_1007001));
  self.armature:addChild(self.trumpet_descb);
  self.trumpet_descb:setVisible(false);
  self.armature4dispose.display:getChildByName("trumpet_descb"):setVisible(false);
  self.armature4dispose.display:getChildByName("chat_bg_scalable_1"):setVisible(false);

  self.none_textfield=createTextFieldWithTextData(self.armature4dispose:getBone("text").textData,"");
  self.armature:addChild(self.none_textfield);
end

function ChatLayerPop:refreshTrumpet()
  self.trumpet_descb:setString(self.context.bagProxy:getItemNum(ConstItemIDConfig.ID_1007001));
end

function ChatLayerPop:onBackSpaceButtonTap(event)
  self:getInput():deleteBackward();
end

function ChatLayerPop:onChatPopButtonTap(event)
  if nil==self.facePopLayer then
    self:onInsertButtonTap({target=self.buttons[1]},1);
  end
  self.is_poped = not self.is_poped;
  self:pop(self.is_poped);

  --self.chat_pop_button.bone:initTextFieldWithString("pop_button",self.is_poped and "-" or "+");
  -- self.pLabelFont:setString(self.is_poped and "-" or "+");
  self.chat_jiahao:setVisible(not self.is_poped);
  self.chat_jianhao:setVisible(self.is_poped);
end

function ChatLayerPop:onPrivateInputConfirm(data)
  self.temp_private_name=data;
  if connectBoo then
    initializeSmallLoading();
    sendMessage(11,9,{UserName=self.temp_private_name});
  end
end

function ChatLayerPop:onPrivateInputTap(event)
  local a=BuddyAddPanel.new();
  a:initialize(self.skeleton,self,self.onPrivateInputConfirm);
  self.container:addChild(a);
end

function ChatLayerPop:pop(bool)
  self:stopAllActions();
  self.armature:getChildByName("chat_bg_scalable_2"):setVisible(bool);
  self.armature:getChildByName("chat_pop_bg"):setVisible(bool);
  self.armature:getChildByName("chat_pop_bg_small"):setVisible(not bool);
  if self.facePopLayer then
    self.facePopLayer:setVisible(bool and 1==self.select_button);
  end
  if self.heroPartakePopLayer then
    self.heroPartakePopLayer:setVisible(bool and 2==self.select_button);
  end
  if self.itemsPopLayer then
    self.itemsPopLayer:setVisible(bool and 3==self.select_button);
  end
  local array=CCArray:create();
  if bool then
    function cf()
    end
    local moveTo1=CCMoveTo:create(0.2,self.const_pop_pos_2);
    local callBack=CCCallFunc:create(cf);
    array:addObject(CCEaseIn:create(moveTo1,0.2));
    array:addObject(callBack);
  else
    function cf()
    end
    local moveTo1=CCMoveTo:create(0.2,self.const_pop_pos_1);
    local callBack=CCCallFunc:create(cf);
    array:addObject(CCEaseIn:create(moveTo1,0.2));
    array:addObject(callBack);
  end
  self.armature:runAction(CCSequence:create(array));
  self.container:onChatLayerPopButtonTap(bool);
end

function ChatLayerPop:onInsertButtonTap(event, data)
  if event.globalPosition then
    MusicUtils:playEffect(7,false);
  end
  if data==self.select_button then
    return;
  end
  self.select_button=data;
  for k,v in pairs(self.buttons) do
    v:select(event.target==v);
  end
  if 1==self.select_button then
    self:onInsertButton1Tap();
  elseif 2==self.select_button then
    self:onInsertButton2Tap();
  elseif 3==self.select_button then
    self:onInsertButton3Tap();
  end
end

function ChatLayerPop:onInsertButton1Tap()
  if nil==self.facePopLayer then
    self.facePopLayer=FacesPopLayer.new();
    self.facePopLayer:initialize(self.skeleton,self,self.onFaceTap);
    self.armature:addChild(self.facePopLayer);
  end
  self.facePopLayer:setVisible(true);
  if self.itemsPopLayer then
    self.itemsPopLayer:setVisible(false);
  end
  if self.heroPartakePopLayer then
    self.heroPartakePopLayer:setVisible(false);
  end
  self.facePopLayer:refreshNoneTextField();
end

function ChatLayerPop:onInsertButton2Tap()
  if nil==self.heroPartakePopLayer then
    self.heroPartakePopLayer=HeroPartakePopLayer.new();
    self.heroPartakePopLayer:initialize(self.skeleton,self,self.onHeroTap,self.heroHouseProxy);
    self.armature:addChild(self.heroPartakePopLayer);

    self.heroPartakePopLayer:refreshItems();
  end
  self.facePopLayer:setVisible(false);
  if self.itemsPopLayer then
    self.itemsPopLayer:setVisible(false);
  end
  self.heroPartakePopLayer:setVisible(true);
  --self.itemsPopLayer:refreshItems();
  self.heroPartakePopLayer:refreshNoneTextField();
end

function ChatLayerPop:onInsertButton3Tap()
  if nil==self.itemsPopLayer then
    self.itemsPopLayer=ItemsPopLayer.new();
    self.itemsPopLayer:initialize(self.skeleton,self,self.onItemTap,self.bagProxy,self.equipmentInfoProxy);
    self.armature:addChild(self.itemsPopLayer);

    self.itemsPopLayer:refreshItems();
  end
  self.facePopLayer:setVisible(false);
  self.itemsPopLayer:setVisible(true);
  if self.heroPartakePopLayer then
    self.heroPartakePopLayer:setVisible(false);
  end
  --self.itemsPopLayer:refreshItems();
  self.itemsPopLayer:refreshNoneTextField();
end

function ChatLayerPop:onFaceTap(event, id)
  local s=string.sub(self:getInput():getInputText(),10,-11);
  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end
  local count = self:getInput():getCharCount();
  
  if defaultContent==s then
    s="";
  else
    s=StringUtils:getContentData(s);
  end
  if ""~=s and 5<StringUtils:getCountByContent(s) then
    sharedTextAnimateReward():animateStartByString("表情不能超过6个哦~");
    return;
  end
  self:getInput():appendInputText('<image>resource/faces/' .. id .. '.png</image>');
  
  if self:getInput():getCharCount() == count then
    sharedTextAnimateReward():animateStartByString("输入超出长度了哦~");
  end
end

function ChatLayerPop:onItemTap(event, item)
  local color=getColorByQuality(analysis("Daoju_Daojubiao",item:getItemData().ItemId,"color"),true);
  local name=analysis("Daoju_Daojubiao",item:getItemData().ItemId,"name");
  local equip=item:isEquip() and ConstConfig.CHAT_EQUIP or ConstConfig.CHAT_PROP;
  local id=item:isEquip() and (item:getItemData().GeneralId .. "," .. item:getItemData().ItemId) or item:getItemData().ItemId;
  local count = self:getInput():getCharCount();
  local isInit = '<content><font color="#808080">请输入...</font></content>' == self:getInput():getInputText();print(self:getInput():getInputText());
  --self:getInput():setInputText('');
  --self:getInput():appendInputText('<font color="#FFFFFF">看这里~ </font>');
  self:getInput():appendInputText('<font color="#FFFFFF"> </font>');
  self:getInput():appendInputText('<font color="' .. color .. '" link="' .. equip ..',' .. id .. '" ref="1">[' .. name .. ']</font>');
  self:getInput():appendInputText('<font color="#FFFFFF"> </font>');
  --self.parent.onSendButtonTap(self.parent);
  if self:getInput():getCharCount() == count and not isInit then
    sharedTextAnimateReward():animateStartByString("输入超出长度了哦~");
  end
end

function ChatLayerPop:onHeroTap(event, data)
  local color=getColorByQuality(getSimpleGrade(data.Grade),true);
  local name=analysis("Kapai_Kapaiku",data.ConfigId,"name");
  local equip=ConstConfig.CHAT_HERO;
  local id=data.GeneralId;
  local count = self:getInput():getCharCount();
  local isInit = '<content><font color="#808080">请输入...</font></content>' == self:getInput():getInputText();
  --self:getInput():setInputText('');
  --self:getInput():appendInputText('<font color="#FFFFFF">看这里~ </font>');
  self:getInput():appendInputText('<font color="#FFFFFF"> </font>');
  self:getInput():appendInputText('<font color="' .. color .. '" link="' .. equip ..',' .. id .. '" ref="1">[' .. name .. ']</font>');
  self:getInput():appendInputText('<font color="#FFFFFF"> </font>');
  if self:getInput():getCharCount() == count and not isInit then
    sharedTextAnimateReward():animateStartByString("输入超出长度了哦~");
  end
end

function ChatLayerPop:refreshPopArmature()
  if self.itemsPopLayer then
    self.itemsPopLayer:refreshItems();
  end
end

function ChatLayerPop:getInput()
  local input;
  if self.textInput.parent then
    input=self.textInput;
  elseif self.private_textInput.parent then
    input=self.private_textInput;
  end
  return input;
end

function ChatLayerPop:refreshPrivateChatValid(state)
  uninitializeSmallLoading();
  if 2==state then
    self.private_name:setString(self.temp_private_name);
  elseif 1==state then
    sharedTextAnimateReward():animateStartByString("玩家不在线哦~");
  else
    sharedTextAnimateReward():animateStartByString("没有这个玩家哦~");
  end
  self.temp_private_name=nil;
end