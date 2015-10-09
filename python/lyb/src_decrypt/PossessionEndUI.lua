--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-5-2

  yanchuan.xie@happyelements.com
]]

PossessionEndUI=class(TouchLayer);

function PossessionEndUI:ctor()
  self.class=PossessionEndUI;
end

function PossessionEndUI:dispose()
  self.parent_container.endUI=nil;
  self:removeAllEventListeners();
  self:removeChildren();
  PossessionEndUI.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionEndUI:initializeUI(skeleton, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.familyProxy=self.parent_container.familyProxy;
  self.userProxy=self.parent_container.userProxy;
  self.const_max_sign_in=8;
  self.imgs={};
  self.img_fgs={};
  self.win_imgs={};
  self.selected=nil;
  self.data=nil;

  --骨骼
  local armature=skeleton:buildArmature("end_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);
  
  local a=0;
  while 5>a do
    a=1+a;
    local img=self.armature:getChildByName("img_" .. a);
    img:addEventListener(DisplayEvents.kTouchBegin,self.onImageBegin,self);
    table.insert(self.imgs,img);
    local img_fg=self.armature:getChildByName("img_fg_" .. a);
    img_fg.touchEnabled=false;
    img_fg:setVisible(false);
    table.insert(self.img_fgs,img_fg);

    local title=Image.new();
    title.touchEnabled=false;
    title:loadByArtID(analysis("Jiazu_Lingdizhanbaoming",a,"artid"));
    title:setPosition(self.armature:getChildByName("pos_" .. a):getPosition());
    self.armature:addChild(title);
  end

  local data=self.skeleton.textureAtlasData:getSubTextureData("img_5");
  local i=1+self.armature:getChildIndex(self.imgs[5]);
  local pos=self.imgs[5]:getPosition();
  local disp=Sprite.new(getGraySprite(self.imgs[5].sprite,data.x,data.y,true));
  disp.sprite:setAnchorPoint(CCPointMake(0,1));
  disp.touchEnabled=false;
  disp:setPosition(pos);
  self.imgs[5]=disp;
  self.armature:addChildAt(disp,i);

  local text="";
  local text_data=armature:getBone("sign_in_tip_fg").textData;
  self.sign_in_tip_fg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.sign_in_tip_fg);

  text="";
  text_data=armature:getBone("winner_descb").textData;
  self.winner_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.winner_descb);

  text="";
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  text="";
  text_data=armature:getBone("cost_descb").textData;
  self.cost_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.cost_descb);

  text="";
  text_data=armature:getBone("number_descb").textData;
  self.number_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.number_descb);

  text="<content><font color='#E1D2A0'>领主奖励</font></content>";
  text_data=armature:getBone("bonus").textData;
  self.bonus=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.bonus);
  
  text="";
  text_data=armature:getBone("bonus_descb").textData;
  self.bonus_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.bonus_descb);

  text="每周五10点开始报名";
  text_data=armature:getBone("time_bg").textData;
  self.time_bg=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_bg);

  text="<content><font color='#00FF00' ling='1' ref='1'>查看上一次领地战</font></content>";
  text_data=armature:getBone("number_descb0").textData;
  self.number_descb0=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.number_descb0:addEventListener(DisplayEvents.kTouchTap,self.onRuleButtonTap,self);
  self.armature:addChild(self.number_descb0);
end

function PossessionEndUI:resume4Battle()
  self:onRuleButtonTap();
end

--移除
function PossessionEndUI:onCloseButtonTap(event)
  self.parent_container:onCloseButtonTap(event);
end

function PossessionEndUI:onImageBegin(event)
  local s;
  for k,v in pairs(self.imgs) do
    if checkTouched(v,event.globalPosition) then
      s=k;
      break;
    end
  end
  if s then
    self:onImageSelected(s);
  end
end

function PossessionEndUI:onImageSelected(s)
  if self.selected==s or 5==s then
    return;
  end
  if self.selected then
    self.img_fgs[self.selected]:setVisible(false);
  end
  self.selected=s;
  self.img_fgs[self.selected]:setVisible(true);

  local mapInfo=self:getMapInfo(self.selected);
  local normal_data=self.familyProxy:getNormalData();
  self.sign_in_tip_fg:setString(analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"name"));
  self.winner_descb:setString("<content><font color='#FF7E00'>本周领主   </font><font color='#FFFFFF'>" .. (""==mapInfo.FamilyName and "无" or mapInfo.FamilyName) .. "</font></content>");
  
  self.level_descb:setString("<content><font color='#E1D2A0'>占领时间</font></content>");
  local opentime=os.date("%Y-%m-%d %H:%M:%S",-604800+self.data.Time);
  local closetime=os.date("%Y-%m-%d ",self.data.Time);
  closetime=closetime .. analysis("Jiazu_Lingdizhanliuchengzhuangtai",2,"bedin") .. ":00";
  self.cost_descb:setString("<content><font color='#00FF00'>" .. opentime .. "</font><font color='#E1D2A0'>   到</font></content>");
  self.number_descb:setString("<content><font color='#00FF00'>" .. closetime .. "</font></content>");
  self.bonus_descb:setString(analysis("Jiazu_Lingdizhanbaoming",mapInfo.MapId,"describe"));
end

function PossessionEndUI:onRuleButtonTap(event)
  self.parent_container:addLastBattleUI(self:getMapInfo(self.selected).MapId);
end

function PossessionEndUI:refreshStage(data)
  self.data=data;
  self:onImageSelected(self.selected and self.selected or 1);
  self:refreshWinImg();
end

function PossessionEndUI:refreshWinImg()
  for k,v in pairs(self.data.MapInfoArray) do
    if 0~=self.userProxy:getFamilyID() and self.userProxy:getFamilyID()==v.FamilyId then
      if not self.win_imgs[v.MapId] then
        self.win_imgs[v.MapId]=self.skeleton:getBoneTextureDisplay("win_img");
        self.win_imgs[v.MapId].touchEnabled=false;
        self.win_imgs[v.MapId]:setPosition(self.armature:getChildByName("win_pos_" .. v.MapId):getPosition());
      end
      self.armature:addChild(self.win_imgs[v.MapId]);
    else
      if self.win_imgs[v.MapId] then
        self.armature:removeChild(self.win_imgs[v.MapId]);
        self.win_imgs[v.MapId]=nil;
      end
    end
  end
end

function PossessionEndUI:getMapInfo(id)
  if self.data then
    for k,v in pairs(self.data.MapInfoArray) do
      if id==v.MapId then
        return v;
      end
    end
  end
end