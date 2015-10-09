LangyabangDetailLayerItem=class(TouchLayer);

function LangyabangDetailLayerItem:ctor()
  self.class=LangyabangDetailLayerItem;
end

function LangyabangDetailLayerItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  LangyabangDetailLayerItem.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function LangyabangDetailLayerItem:initialize(context, data, container)
  self:initLayer();
  self.context=context;
  self.data = data;
  self.container = container;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;

  local select_type = self.context.selected_type;
  if 1 == select_type then
    self:refreshForBangpai();
  else
    self:refresh();
  end
end

function LangyabangDetailLayerItem:refresh()
  --骨骼
  local armature=self.skeleton:buildArmature("rank_item_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self.armature:setPositionY(3);


  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createAutosizeMultiColoredLabelWithTextData(text_data,"");
  self.armature:addChild(self.player_bg);

  text_data=armature:getBone("rank_descb").textData;
  self.rank_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.rank_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("descb").textData;
  self.descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.descb);

  local configID = self.data.ParamStr2;
  if configID then
    local img = Image.new();
    img:loadByArtID(analysis("Zhujiao_Huanhua",configID,"head"));
    img:setScale(0.76);
    img:setPositionXY(97,13);
    self.armature:addChild(img);
  end
  if self.context.userProxy:getUserID() ~= self.data.UserId and self.context.userProxy:getUserName() ~= self.data.ParamStr1 then
    self.player_bg:setString("<content><font color = '#FFB400' ref = '1'>" .. self.data.ParamStr1 .. "</font></content>");
    self.player_bg:addEventListener(DisplayEvents.kTouchTap,self.onNameTap,self,self.data);
  else
    self.player_bg:setString("<content><font color = '#FFFFFF'>" .. self.data.ParamStr1 .. "</font></content>");
  end
  self.rank_descb:setString(self.data.Ranking);
  self.level_descb:setString("Lv." .. self.data.ParamStr4);
  self.descb:setString(self.data.ParamStr3);

  for k,v in pairs(self.data.RankGeneralArray) do
    if 4 == k then
      break;
    end
    -- if 0 == v.BooleanValue then
      local heroRoundPortrait = HeroRoundPortrait.new();
      heroRoundPortrait:initialize(v,false);
      heroRoundPortrait:showName4RankListDetail();
      heroRoundPortrait:setScale(0.65);
      heroRoundPortrait:setPositionXY(150*(-1+k)+440,8);
      self.armature:addChild(heroRoundPortrait);
    -- end
  end
end

function LangyabangDetailLayerItem:refreshForBangpai()
  --骨骼
  local armature=self.skeleton:buildArmature("rank_item_ui_bangpai");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self.armature:setPositionY(3);

  --title_1
  local text_data=armature:getBone("player_bg").textData;
  self.player_bg=createAutosizeMultiColoredLabelWithTextData(text_data,"");
  self.armature:addChild(self.player_bg);

  text_data=armature:getBone("rank_descb").textData;
  self.rank_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.rank_descb);

  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.level_descb);

  text_data=armature:getBone("bangpai_descb").textData;
  self.bangpai_descb=createAutosizeMultiColoredLabelWithTextData(text_data,"");
  self.armature:addChild(self.bangpai_descb);

  text_data=armature:getBone("bangpai_level_descb").textData;
  self.bangpai_level_descb=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.bangpai_level_descb);

  text_data=armature:getBone("descb_1").textData;
  self.descb_1=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.descb_1);

  text_data=armature:getBone("descb_2").textData;
  self.descb_2=createTextFieldWithTextData(text_data,"");
  self.armature:addChild(self.descb_2);

  local configID = self.data.ParamStr3;
  if configID then
    local img = Image.new();
    img:loadByArtID(analysis("Zhujiao_Huanhua",configID,"head"));
    img:setScale(0.76);
    img:setPositionXY(335,13);
    self.armature:addChild(img);
  end
  if self.context.userProxy:getUserID() ~= self.data.UserId and self.context.userProxy:getUserName() ~= self.data.ParamStr1 then
    self.player_bg:setString("<content><font color = '#FFB400' ref = '1'>" .. self.data.ParamStr4 .. "</font></content>");
    self.player_bg:addEventListener(DisplayEvents.kTouchTap,self.onNameTap,self,self.data);
  else
    self.player_bg:setString("<content><font color = '#FFFFFF'>" .. self.data.ParamStr4 .. "</font></content>");
  end
  self.rank_descb:setString(self.data.Ranking);
  self.level_descb:setString("Lv." .. self.data.ParamStr5);

  self.bangpai_descb:setString("<content><font color = '#FFB400' ref = '0'>" .. self.data.ParamStr1 .. "</font></content>");
  self.bangpai_level_descb:setString("Lv." .. self.data.ParamStr2);
  self.descb_1:setString(self.data.ParamStr6);
  self.descb_2:setString(self.data.ParamStr7);
end

function LangyabangDetailLayerItem:onNameTap(event, data)
  getUserButtonsSelector(1 == self.context.selected_type and self.data.ParamStr9 or self.data.ID,1 == self.context.selected_type and self.data.ParamStr4 or self.data.ParamStr1,event.globalPosition,self.container);
end