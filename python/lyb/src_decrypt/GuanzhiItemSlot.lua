require "core.controls.page.CommonSlot";

GuanzhiItemSlot=class(CommonSlot);

function GuanzhiItemSlot:ctor()
  self.class=GuanzhiItemSlot;
end

function GuanzhiItemSlot:dispose()
  self:removeAllEventListeners();
  GuanzhiItemSlot.superclass.dispose(self);
  self.armature:dispose();
end

function GuanzhiItemSlot:initialize(context)
	self.context = context;
	self.skeleton = self.context.skeleton;
  self.bagItem = nil;
  table.insert(self.context.slots, self);

	self:initLayer();
end

function GuanzhiItemSlot:getID()
  return self.id;
end

function GuanzhiItemSlot:setSlotData(id)
  self.id = id;

  if self.armature then
    self:removeChild(self.armature.display);
    self.armature:dispose();
  end

  local armature=self.skeleton:buildArmature("guanzhi_card");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  -- self.armature.display:getChildByName("meihua"):setScale(2);

  local text=analysis("Shili_Guanzhi",self.id,"title");
  self.name = text;
  local name_descb=createTextFieldWithTextData(armature:getBone("name_descb").textData,text);
  self.armature.display:addChild(name_descb);
  self.name_descb = name_descb;

  text=analysis("Shili_Guanzhi",self.id,"pinji");
  self.pinji = text;
  local pos_descb=createTextFieldWithTextData(armature:getBone("pos_descb").textData,text);
  self.armature.display:addChild(pos_descb);

  text=analysis("Shili_Guanzhi",self.id,"buff");
  local tb;
  if "" == text then
    tb = {};
  else
    tb = StringUtils:stuff_string_split(text);
  end
  text = "";
  for k,v in pairs(tb) do
    text = text .. analysis("Shuxing_Shuju",v[1],"name") .. "+" .. v[2] .. "\n";
  end
  local buff_descb=createTextFieldWithTextData(armature:getBone("buff_descb").textData,text);
  self.armature.display:addChild(buff_descb);

  local premise_descb=createTextFieldWithTextData(armature:getBone("premise_descb").textData,"需    ");
  self.armature.display:addChild(premise_descb);

  local kaiqi_descb=createTextFieldWithTextData(armature:getBone("kaiqi_descb").textData,"");
  self.armature.display:addChild(kaiqi_descb);
  self.kaiqi_descb = kaiqi_descb;

  local img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_shengwang_bg");
  img:setScale(0.8);
  img:setPositionXY(25,1);
  premise_descb:addChild(img);

  local textData = armature:getBone("shengwang_descb").textData;
  textData.width = 0;
  local prestige_need = analysis("Shili_Guanzhi",self.id,"prestige");
  local prestige = self.context.userCurrencyProxy:getPrestige();
  local shengwang_descb=createTextFieldWithTextData(textData,prestige_need,true);
  -- shengwang_descb:setPositionY(95);
  self.armature.display:addChild(shengwang_descb);

  local size = shengwang_descb:getContentSize().width;
  local value = 132 - size/2;
  -- premise_descb:setPositionX(value);
  shengwang_descb:setPositionX(value);

  local num = 0;
  for k,v in pairs(self.context.idCountArray) do
    if self.id == v.ID then
      num = v.Count;
      break;
    end
  end
  text="<content><font color='#FFB400'>当前 </font><font color='#FFFFFF'>" .. num .. "</font><font color='#FFB400'>人</font></content>";
  local count=createAutosizeMultiColoredLabelWithTextData(armature:getBone("count").textData,text);
  self.armature.display:addChild(count);
  count:setVisible(false);

  if self.id == 1 + self.context.userProxy:getNobility() then

    -- local button=Button.new(self.armature:findChildArmature("button"),false);
    -- button.bone:initTextFieldWithString("common_small_orange_button","升官");
    -- button:addEventListener(Events.kStart,self.context.onItemTap,self.context,self.id);
    local function onShengGuanConfirm()
      self.context.onItemTap(self.context,nil,self.id);
      if GameVar.tutorStage == TutorConfig.STAGE_1012 then
        openTutorUI({x=1159, y=617, width = 78, height = 75, alpha = 125});
      end
    end
    local function onShengGuan()
      if analysis("Shili_Guanzhi",self.id,"prestige") > self.context.userCurrencyProxy:getPrestige() then
        sharedTextAnimateReward():animateStartByString("声望不足呢~");

        return;
      end
      if GameVar.tutorStage == TutorConfig.STAGE_1012 then
          openTutorUI({x=650, y=214, width = 190, height = 50, alpha = 125});
      end
      local commonPopup=CommonPopup.new();
      commonPopup:initialize("是否消耗" .. prestige_need .. "声望换取官职\n" .. self.pinji .. " : " .. self.name,nil,onShengGuanConfirm, nil, nil, nil, nil, nil, nil, true);
      self.context.parent:addChild(commonPopup);
    end
    -- local button = generateButton(self.armature,"button","common_small_blue_button","升官",onShengGuan,_,_,_,_,_,true,_,_,_,true);
    -- button.textField:setPositionXY(5,7);
    -- button:setPositionY(30+button:getPositionY());

    local buttonData=self.armature:findChildArmature("button"):getBone("common_small_blue_button").textData;
    local button=self.armature.display:getChildByName("button");
    local button_pos=convertBone2LB4Button(button);
    self.armature.display:removeChild(button);

    button=CommonButton.new();
    button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    --button:initializeText(trimButtonData,"整理背包");
    button:initializeBMText("升官","anniutuzi");
    button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,onShengGuan);
    self.armature.display:addChild(button);

    if prestige_need > prestige then
      shengwang_descb:setColor(ccc3(255,0,0));
    else
      shengwang_descb:setColor(ccc3(0,255,0));
    end
    premise_descb:setVisible(true);
    shengwang_descb:setVisible(true);

    if 3 == self.id then
      self.kaiqi_descb:setString("征战功能开启");
    end
  else
    self.armature.display:getChildByName("button"):setVisible(false);
    if self.id <= self.context.userProxy:getNobility() then
      text="已获得";
      local yihuode_descb=createTextFieldWithTextData(armature:getBone("yihuode_descb").textData,text);
      self.armature.display:addChild(yihuode_descb);
      premise_descb:setVisible(false);
      shengwang_descb:setVisible(false);
    else
      -- name_descb:setOpacity(102);
      -- pos_descb:setOpacity(102);
      -- buff_descb:setOpacity(102);
      name_descb:setColor(ccc3(68,68,68));
      pos_descb:setColor(ccc3(68,68,68));
      buff_descb:setColor(ccc3(68,68,68));

      -- shengwang_descb:setColor(ccc3(68,68,68));
      -- premise_descb:setColor(ccc3(68,68,68));
      shengwang_descb:setVisible(false);
      premise_descb:setVisible(false);

      -- shengwang_descb:setColor(ccc3(172,81,0));
      -- premise_descb:setVisible(true);
      -- shengwang_descb:setVisible(true);

      self.premise_descb_1=createTextFieldWithTextData(armature:getBone("premise_descb_1").textData,1==self.id and "" or ("需 " .. analysis("Shili_Guanzhi",-1+self.id,"title")));
      self.premise_descb_1:setColor(ccc3(68,68,68));
      self.armature.display:addChild(self.premise_descb_1);

      if 3 == self.id then
        self.kaiqi_descb:setString("征战功能开启");
      end
    end
  end

  local current_pos = self.armature.display:getChildByName("current_pos");
  if self.id == self.context.userProxy:getNobility() then
    self.armature.display:removeChild(current_pos,false);
    self.armature.display:addChild(current_pos);
    current_pos:setVisible(true);
  else
    current_pos:setVisible(false);
  end
end