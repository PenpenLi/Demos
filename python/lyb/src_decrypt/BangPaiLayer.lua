require "main.view.family.bangPai.BangPaiMemberLayer";
require "main.view.family.bangPai.BangPaiMemberItemLayer";
require "main.view.family.bangPai.BangPaiZhaorenLayer";
require "main.view.family.bangPai.BangPaiZhaorenItemLayer";
require "main.view.family.bangPai.BangPaiRizhiLayer";
require "main.view.family.bangPai.BangPaiRizhiItemLayer";
require "main.view.family.bangPai.BangPaiHuoyueduLayer";
require "main.view.family.bangPai.BangPaiHuoyueduItemLayer";
require "main.view.chat.ui.chatPopup.ButtonsSelector";

BangPaiLayer=class(TouchLayer);

function BangPaiLayer:ctor()
  self.class=BangPaiLayer;
end

function BangPaiLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BangPaiLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function BangPaiLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.effectProxy=self.context.effectProxy;
  self.generalListProxy=self.context.generalListProxy;
  self.countControlProxy=self.context.countControlProxy;
  self.refreshTime=0;
  
  --骨骼
  local armature=self.skeleton:buildArmature("bangpai_info_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="";
  local text_data=armature:getBone("title").textData;
  self.title=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.title);

  text="";
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.level_descb);

  text="";
  text_data=armature:getBone("paiming_descb").textData;
  self.paiming_descb=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.paiming_descb);

  text="";
  text_data=armature:getBone("renshu_descb").textData;
  self.renshu_descb=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.renshu_descb);

  text="";
  text_data=armature:getBone("huoyuedu_progress_bar").textData;
  self.huoyuedu_progress_bar=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.huoyuedu_progress_bar);

  text="帮主7天未上线可弹劾";
  text_data=armature:getBone("tanhe_descb").textData;
  self.tanhe_descb=createTextFieldWithTextData(text_data,text,true);
  self.armature:addChild(self.tanhe_descb);

  --exp_progress
  local progressBar = armature:findChildArmature("huoyuedu_progress_bar");
  self.progressBar = ProgressBar.new(progressBar, "common_blue_progress_bar_fg");
  self.progressBar:setProgress(0);

  local red_btn_texts = {"","全部同意","全部拒绝"};
  self.red_btns = {};
  for i=1,3 do
    local button=self.armature:getChildByName("red_btn_" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature:removeChild(button);

    button=CommonButton.new();
    button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
    --button:initializeText(trimButtonData,"整理背包");
    button:initializeBMText(red_btn_texts[i],"anniutuzi");
    button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,self.onRedButtonTap,self,i);
    self:addChild(button);

    table.insert(self.red_btns, button);
  end
  self.red_btns[1]:setVisible(false);

  local blue_btn_texts = {"审核","招人","离开"};
  self.blue_btns = {};
  for i=1,3 do
    local button=self.armature:getChildByName("blue_btn_" .. i);
    local button_pos=convertBone2LB4Button(button);
    self.armature:removeChild(button);

    button=CommonButton.new();
    button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
    --button:initializeText(trimButtonData,"整理背包");
    button:initializeBMText(blue_btn_texts[i],"anniutuzi");
    button:setPosition(button_pos);
    button:addEventListener(DisplayEvents.kTouchTap,self.onBlueButtonTap,self,i);
    self.armature4dispose.display:addChild(button);

    table.insert(self.blue_btns, button);
  end
  self.blue_btns[1]:setVisible(self.context.userProxy:getHasQuanxian(1));
  -- self.blue_btns[2]:setVisible(self.context.userProxy:getHasQuanxian(1));
  self.blue_btns[2]:setVisible(false);
  self.red_btns[2]:setVisible(false);
  self.red_btns[3]:setVisible(false);
  self.blue_btns[1]:setPosition(self.blue_btns[2]:getPosition());

  self.effect1 = self.armature4dispose.display:getChildByName("effect1");
  self.armature4dispose.display:removeChild(self.effect1,false);
  self.armature4dispose.display:addChild(self.effect1);
  self.effect1:setVisible(false);
  
  local zhaoren_img =self.armature4dispose.display:getChildByName("zhaoren_img");
  zhaoren_img.parent:removeChild(zhaoren_img,false);
  self.armature4dispose.display:addChild(zhaoren_img);
  SingleButton:create(zhaoren_img);
  zhaoren_img:addEventListener(DisplayEvents.kTouchTap, self.onZhaorenImgTap, self);
  zhaoren_img:setVisible(self.context.userProxy:getHasQuanxian(8));

  local huoyuedu_jiangli =self.armature:getChildByName("huoyuedu_jiangli");
  SingleButton:create(huoyuedu_jiangli);
  huoyuedu_jiangli:addEventListener(DisplayEvents.kTouchTap, self.onHuoyuedujiangli, self);
  self.huoyuedu_jiangli = huoyuedu_jiangli;

  local rizhi_img =self.armature:getChildByName("rizhi_img");
  SingleButton:create(rizhi_img);
  rizhi_img:addEventListener(DisplayEvents.kTouchTap, self.onRizhi, self);

  local askButton =self.armature4dispose.display:getChildByName("ask");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onAskTap, self);
  self.askBtn = askButton;

  local closeButton =self.armature4dispose.display:getChildByName("close_btn");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);

  self:onTAB(nil, 1);
  self:refreshByPositionChange();
  initializeSmallLoading();
  sendMessage(27,11,{FamilyId = self.userProxy:getFamilyID()});
end

function BangPaiLayer:onAskTap(event)
  local text=analysis("Tishi_Guizemiaoshu",7,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function BangPaiLayer:onHuoyuedujiangli(event)
  self.bangpaiHuoyueduLayer = BangpaiHuoyueduLayer.new();
  self.bangpaiHuoyueduLayer:initialize(self.context,self);
  self.context.parent:addChild(self.bangpaiHuoyueduLayer);
end

function BangPaiLayer:onRizhi(event)
  self.bangpaiRizhiLayer = BangpaiRizhiLayer.new();
  self.bangpaiRizhiLayer:initialize(self.context,self);
  self.context.parent:addChild(self.bangpaiRizhiLayer);
end

function BangPaiLayer:onBlueButtonTap(event, data)
  if 1 == data then
    if self.bangpaiZhaorenLayer and self.bangpaiZhaorenLayer:isVisible() then
      self:onTAB(nil, 1);
      self:refreshByPositionChange();
    else
      self:onTAB(nil, 2);
      self:refreshByPositionChange();
    end
  elseif 2 == data then
    self:onZhaoren();
  elseif 3 == data then
    self:onJiesan();
  end
end

function BangPaiLayer:refreshTimercf()
  if 0>=self.refreshTime then
    removeSchedule(self,self.refreshTimercf);
    return;
  end
  self.refreshTime=-1+self.refreshTime;
end

function BangPaiLayer:onZhaorenImgTap(event)
  self:onZhaoren();
end

function BangPaiLayer:onTanhe()
  for k,v in pairs(self.familyInfo.MemberArray) do
    if 1 == v.FamilyPositionId then
      print(getTimeServer(),v.Time);
      local time=getTimeServer()-v.Time;
      if 7 < time/86400 then
        self:onImpeach();
      else
        sharedTextAnimateReward():animateStartByString("帮主7天未上线才可弹劾哦~");
      end
      break;
    end
  end
end

function BangPaiLayer:onZhaoren()
  if self.context.userProxy:getHasQuanxian(8) then
    -- local text = "<content><font color='#0000FF' link='" .. ConstConfig.CHAT_BANG_PAI .. "," .. self.familyInfo.FamilyId .. "' ref='1'>" .. self.familyInfo.FamilyName .. "</font><font color='#FFFFFF'>招人啦,快快加入吧~</font></content>";
    -- local data = {UserId=self.context.userProxy:getUserID(),MainType=1,SubType=1,ChatContentArray=StringUtils:getContentData(text)};
    -- sendMessage(11,3,data);
    sendMessage(27,20);
    sharedTextAnimateReward():animateStartByString("招人信息发送成功叻~");
    self.refreshTime=90;
    addSchedule(self,self.refreshTimercf);
  else
    self:onTanhe();
  end
end

function BangPaiLayer:onImpeach()
  local hasItem=0<self.context.bagProxy:getItemNum(SpecialItemConstConfig.FAMILY_LEADER_IMPEACH);
  local money,price=self.context.shopProxy:getTypeAndPriceByItemID(SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,{1,2,3,4,5});
  local enough=false;
  if money then
    enough=price<=self.context.userCurrencyProxy:getMoneyByItemID(money);
  end
  
  local function onImpeachConfirm()
    initializeSmallLoading();
    sendMessage(27,17,{UserId = self.context.userProxy:getUserID()});
    sharedTextAnimateReward():animateStartByString("弹劾成功啦 ~");
  end
  local function onImpeachConfirmByGold()
    if enough then
      onImpeachConfirm();
    else
      sharedTextAnimateReward():animateStartByString("亲~" .. analysis("Daoju_Daojubiao",money,"name") .. "不够了哦!");
    end
  end
  if hasItem then
    local s="<content><font color='#67190E'>弹劾帮主需要</font>";
    s=s .. "<font color='" .. getColorByQuality(analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"color"),true) .. "'>";
    s=s .. analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"name") .. "x1</font>";
    s=s .. "<font color='#67190E'>，弹劾之后你将成为帮主哦~</font></content>";
    local a=CommonPopup.new();
    a:initialize(s,nil,onImpeachConfirm,nil,nil,nil,false,{"弹劾","取消"},true);
    self:addChild(a);
  else
    local s="<content><font color='#67190E'>花费</font>";
    s=s .. "<font color='#" .. (enough and "00FF00" or "FF0000") .. "'>";
    s=s .. price .. analysis("Daoju_Daojubiao",money,"name") .. "</font>";
    s=s .. "<font color='#67190E'>购买并使用</font>";
    s=s .. "<font color='" .. getColorByQuality(analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"color"),true) .. "'>";
    s=s .. analysis("Daoju_Daojubiao",SpecialItemConstConfig.FAMILY_LEADER_IMPEACH,"name") .. "x1</font>";
    s=s .. "<font color='#67190E'>就可以弹劾帮主了，弹劾之后你将成为帮主哦~</font></content>";

    local a=CommonPopup.new();
    a:initialize(s,nil,onImpeachConfirmByGold,nil,nil,nil,false,{"弹劾","取消"},true);
    self:addChild(a);
  end
end

function BangPaiLayer:onJiesan()
  local function onConfirm(event)
    if self.context.userProxy:getIsFamilyLeader() then
      if 1 < tonumber(self.familyInfo.Count) then
        return;
      else
        if self.familyProxy.BanquetInfoArray then
          for k,v in pairs(self.familyProxy.BanquetInfoArray) do
            if self.userProxy:getUserID() == v.UserId then
              sharedTextAnimateReward():animateStartByString("还在酒宴中,不能解散帮派哦 ~");
              return;
            end
          end
        end
      end
    end
    initializeSmallLoading();
    sendMessage(27,self.context.userProxy:getIsFamilyLeader() and 8 or 4);
  end
  local text;
  if self.context.userProxy:getIsFamilyLeader() then
    if 1 >= tonumber(self.familyInfo.Count) then
      text = StringUtils:getString4Popup(PopupMessageConstConfig.ID_138);
    else
      text = StringUtils:getString4Popup(PopupMessageConstConfig.ID_181);
    end
  else
    text = "离开帮派后,活跃度会清空,24小时后才可以加入帮派哦,确定吗?";
  end
  local popup=CommonPopup.new();
  popup:initialize(text,nil,onConfirm, nil,nil,nil,nil,nil,nil,true);
  self.context:addChild(popup);
end

function BangPaiLayer:onRedButtonTap(event, data)
  if 1 == data then
    
  elseif 2 == data then
    self.bangpaiZhaorenLayer:deleteItemAll(true);
  elseif 3 == data then
    self.bangpaiZhaorenLayer:deleteItemAll(false);
  end
end

function BangPaiLayer:onTAB(event, data)
  if 1 == data then
    if not self.bangpaiMemberLayer then
      self.bangpaiMemberLayer = BangpaiMemberLayer.new();
      self.bangpaiMemberLayer:initialize(self.context);
      self.armature:addChild(self.bangpaiMemberLayer);
    end
    self.bangpaiMemberLayer:setVisible(true);
    if self.bangpaiZhaorenLayer then
      self.bangpaiZhaorenLayer.parent:removeChild(self.bangpaiZhaorenLayer);
      self.bangpaiZhaorenLayer = nil;
    end
  elseif 2 == data then
    self.bangpaiZhaorenLayer = BangpaiZhaorenLayer.new();
    self.bangpaiZhaorenLayer:initialize(self.context);
    self.armature:addChild(self.bangpaiZhaorenLayer);
    if self.bangpaiMemberLayer then
      self.bangpaiMemberLayer:setVisible(false);
    end
  end
end

function BangPaiLayer:refreshFamilyInfo(familyInfo)
  self.familyInfo = familyInfo;

  self.title:setString(self.familyInfo.FamilyName);
  self.level_descb:setString("等级：" .. self.familyInfo.FamilyLevel);
  self.paiming_descb:setString("排名：" .. self.familyInfo.Ranking);
  self.renshu_descb:setString("帮众：" .. self.familyInfo.Count .. "/" .. analysis("Bangpai_Jiazushengjibiao",self.familyInfo.FamilyLevel,"renshu"));
  local familyLevelMax = 15;
  local isFamilyLevelMax = familyLevelMax <= self.familyInfo.FamilyLevel;
  local busy = analysis("Bangpai_Jiazushengjibiao", isFamilyLevelMax and familyLevelMax or (1 + self.familyInfo.FamilyLevel),"busy");
  self.huoyuedu_progress_bar:setString((isFamilyLevelMax and busy or self.familyInfo.Huoyuedu) .. "/" .. busy);
  self.progressBar:setProgress(self.familyInfo.Huoyuedu / busy);

  self.bangpaiMemberLayer:refreshFamilyInfo(familyInfo);
end

function BangPaiLayer:refreshFamilyApplierArray(applierArray)
  self.bangpaiZhaorenLayer:refreshFamilyApplierArray(applierArray);
end

function BangPaiLayer:refreshFamilyLogArray(familyLogArray)
  self.bangpaiRizhiLayer:refreshFamilyLogArray(familyLogArray);
end

function BangPaiLayer:refreshHuoyuedujiangli(huoyuedu, idArray)
  self.bangpaiHuoyueduLayer:refreshHuoyuedujiangli(huoyuedu,idArray);
end

function BangPaiLayer:refreshFamilyMemberKaichu(userID)
  self.familyInfo.Count = -1 + self.familyInfo.Count;
  self.renshu_descb:setString("帮众：" .. self.familyInfo.Count .. "/" .. analysis("Bangpai_Jiazushengjibiao",self.familyInfo.FamilyLevel,"renshu"));

  self.bangpaiMemberLayer:refreshFamilyMemberKaichu(userID);
end

function BangPaiLayer:refreshFamilyMemeberPositionID(userID, positionID)
  self.bangpaiMemberLayer:refreshFamilyMemeberPositionID(userID,positionID);
  if userID == self.context.userProxy:getUserID() then
    self:refreshByPositionChange();
  end
end

function BangPaiLayer:refreshFamilyMemeberPositionIDs(changeMemberArray)
  self.bangpaiMemberLayer:refreshFamilyMemeberPositionIDs(changeMemberArray);
  for k,v in pairs(changeMemberArray) do
    if v.UserId == self.context.userProxy:getUserID() then
      self:refreshByPositionChange();
      break;
    end
  end
end

function BangPaiLayer:refreshFamilyMemberIncrease(data)
  self.familyInfo.Count = data.Count;
  self.renshu_descb:setString("帮众：" .. self.familyInfo.Count .. "/" .. analysis("Bangpai_Jiazushengjibiao",self.familyInfo.FamilyLevel,"renshu"));

  self.bangpaiMemberLayer:refreshFamilyMemberIncrease(data);
end

function BangPaiLayer:refreshHuoyuedulingjiang(id)
  self.bangpaiHuoyueduLayer:refreshHuoyuedulingjiang(id);
end

-- 1 批准申请
-- 2 修改公告
-- 3 解散家族
-- 4 开除成员
-- 5 退出家族
-- 6 弹劾帮主
-- 7 任命副帮主
-- 8 招人
-- 9 降职

function BangPaiLayer:refreshByPositionChange()
  -- if self.bangpaiMemberLayer and self.bangpaiMemberLayer:isVisible() then
  --   self.blue_btns[1]:setVisible(self.context.userProxy:getHasQuanxian(1));
  --   self.blue_btns[1]:refreshText("审核");
  --   if self.context.userProxy:getIsFamilyLeader() then
  --     self.blue_btns[2]:setVisible(self.context.userProxy:getHasQuanxian(8));
  --     self.blue_btns[2]:refreshText("招人");
  --   else
  --     self.blue_btns[2]:setVisible(self.context.userProxy:getHasQuanxian(6));
  --     self.blue_btns[2]:refreshText("弹劾");
  --   end
  --   self.blue_btns[3]:setVisible(true);

  --   self.red_btns[2]:setVisible(false);
  --   self.red_btns[3]:setVisible(false);

  --   self.tanhe_descb:setVisible(self.context.userProxy:getHasQuanxian(6));
  -- else
  --   self.blue_btns[1]:setVisible(self.context.userProxy:getHasQuanxian(1));
  --   self.blue_btns[1]:refreshText("成员");
  --   self.blue_btns[2]:setVisible(false);
  --   self.blue_btns[3]:setVisible(false);
    
  --   self.red_btns[2]:setVisible(true);
  --   self.red_btns[3]:setVisible(true);

  --   self.tanhe_descb:setVisible(false);
  -- end
  -- self.blue_btns[3]:refreshText(self.context.userProxy:getIsFamilyLeader() and "解散" or "退帮");
  if self.bangpaiMemberLayer and self.bangpaiMemberLayer:isVisible() then
    self.blue_btns[1]:setVisible(self.context.userProxy:getHasQuanxian(1));
    self.blue_btns[1]:refreshText("审核");
    
  else
    self.blue_btns[1]:setVisible(self.context.userProxy:getHasQuanxian(1));
    self.blue_btns[1]:refreshText("成员");
  end

  -- if self.context.userProxy:getIsFamilyLeader() then
  --   self.blue_btns[2]:setVisible(self.context.userProxy:getHasQuanxian(8));
  --   self.blue_btns[2]:refreshText("招人");
  -- else
  --   self.blue_btns[2]:setVisible(self.context.userProxy:getHasQuanxian(6));
  --   self.blue_btns[2]:refreshText("弹劾");
  -- end
  self.blue_btns[3]:setVisible(true);
  self.blue_btns[3]:refreshText(self.context.userProxy:getIsFamilyLeader() and "解散" or "退帮");

  self.red_btns[2]:setVisible(false);
  self.red_btns[3]:setVisible(false);

  self.tanhe_descb:setVisible(self.context.userProxy:getHasQuanxian(6));
end

function BangPaiLayer:refreshRedDot()
  if self.context.userProxy:getHasQuanxian(1) and self.context.heroHouseProxy.Hongidan_Shenqingdu then
    self.armature4dispose.display:removeChild(self.effect1,false);
    self.armature4dispose.display:addChild(self.effect1);
    self.effect1:setVisible(true);
  else
    self.effect1:setVisible(false);
  end
  if self.effect then
    self.effect.parent:removeChild(self.effect);
    self.effect = nil;
    self.touchLayer.parent:removeChild(self.touchLayer);
    self.touchLayer = nil;
    self.huoyuedu_jiangli:setVisible(true);
  end
  if self.context.heroHouseProxy.Hongidan_Huoyuedu then
    self.effect = cartoonPlayer("1767",1000,582,0);
    self:addChild(self.effect);
    self.touchLayer = Layer.new();
    self.touchLayer:initLayer();
    self.touchLayer:setContentSize(makeSize(100,100));
    self.touchLayer:setPositionXY(955,537);
    self.touchLayer:addEventListener(DisplayEvents.kTouchTap, self.onHuoyuedujiangli, self);
    self:addChild(self.touchLayer);
    self.huoyuedu_jiangli:setVisible(false);
  end
end