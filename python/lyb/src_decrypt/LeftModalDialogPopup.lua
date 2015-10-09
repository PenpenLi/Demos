

--人物在右，对话内容在左
LeftModalDialogPopup=class(TouchLayer);

function LeftModalDialogPopup:ctor()
  self.class=LeftModalDialogPopup;
  self.LEFT = 1;
  self.RIGHT = 2;
end

function LeftModalDialogPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	LeftModalDialogPopup.superclass.dispose(self);
  self.armature:dispose()
end

function LeftModalDialogPopup:initializeUI(skeleton)
 
  self.skeleton=skeleton;
  self:initLayer();
  local armature = self.skeleton:buildArmature("modalDialog_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self:addChild(armature.display)
  self.armature=armature

  self.mainSize = Director:sharedDirector():getWinSize();
  self.sprite:setContentSize(CCSizeMake(self.mainSize.width, self.mainSize.height));


  local armature_d=armature.display;
  self.armature_d = armature_d;
  armature_d.touchEnabled=true;

  self.name = armature_d:getChildByName("name");
  self.name2 = armature_d:getChildByName("name2");
  --taskContent
  local dialog_content = "去找刘小霞吃金钱豹";
  local dialogContentTextData = armature:getBone("dialog_content").textData;
  self.dialogContentText =  createTextFieldWithTextData(dialogContentTextData, dialog_content);
  self:addChild(self.dialogContentText);   
  
  self.head_image = armature_d:getChildByName("head_image");
  self.ifLeft=true
end

function LeftModalDialogPopup:refreshModalDialog(npcId, userName, content,bg,zhujue,face)
  if bg then
    self.bg=Image.new()
    self.bg:loadByArtID(bg)
    self:addChildAt(self.bg,0)
  end


  --{npcId = event.data.npcId, npcName = event.data.npcName, taskData = taskData, taskPo = taskPo}
  if self.dialogContentText and self.dialogContentText.sprite then
      self.dialogContentText:setString(content);
  end
    
  if(self.npcId~=npcId) then

  else
    return
  end

  if(userName==nil or userName=="") then
    userName="呵呵"
  end
  self.userName = userName;
  if not self.npcNameTxt then
      local npcNameTxtTextData = self.armature:getBone("nametext").textData;
      self.npcNameTxt =  createTextFieldWithTextData(npcNameTxtTextData, userName);
      self.armature_d:addChild(self.npcNameTxt);
      local npcNameTxtTextData2 = self.armature:getBone("nametext2").textData;
      self.npcNameTxt2 =  createTextFieldWithTextData(npcNameTxtTextData2, userName);
      self.armature_d:addChild(self.npcNameTxt2);
  else
      self.npcNameTxt:setString(userName);
      self.npcNameTxt2:setString(userName);
  end


  self.img=self.armature_d:getChildByName("img")
  self.background2=self.armature_d:getChildByName("background2")
  self.background2:setPositionXY(0,self.mainSize.height)
  local artId 
  if(zhujue==1) then
    self.npcPo =  analysis("Zhujiao_Zhujiaozhiye", npcId)
    self.zhujueId = npcId;
    artId =  self.npcPo.art1;
    self.ifLeft = true;
  else
    self.npcPo =  analysis("Juqing_JuqingNPC", npcId)
    artId =  self.npcPo.bustName;
    self.ifLeft = false;
  end
  if artId == 0 or artId == "" then
     artId = 5
  end



  self.img=Image.new()
  self.img:loadByArtID(artId)
  self.img:setScale(1)
  self.shift=0;
  if self.npcPo.fangxiang ~= 0 then
      self.img:setScaleX(-1);
      self.shift=self.img:getContentSize().width-60;
  end
  if face then
    if(zhujue==1) then
      self.ifLeft = true;
    else
      if face == "2" then
        self.ifLeft = false;
      else
        self.ifLeft = true;
      end
    end
    self:imageRunAction()
  else
    self:imageRunAction();
  end
  if(self.img2) then
    self.armature_d:swapChildren(self.img,self.img2)
  end
  
  if(self.layer) then
    self.armature_d:removeChild(self.layer)
  end
  self.layer=LayerColor.new();
  self.layer:initLayer();
  self.layer:setContentSize(self.mainSize);
  self.layer:setColor(ccc3(0,0,0))
  self.layer.touchEnabled=false;
  if(self.img2) then
    self.armature_d:addChildAt(self.layer,1);
  else
    self.armature_d:addChildAt(self.layer,0);
  end
  self.layer:setAlpha(100)

  self.npcId = npcId;
  self.img3=self.img2
  self.img2=self.img
end

function LeftModalDialogPopup:imageRunAction()
    if (self.ifLeft) then
      if(self.img3) then
           self.armature_d:removeChild(self.img3)
      end
      self.name:setVisible(true)
      self.name2:setVisible(false)
      self.npcNameTxt:setVisible(true)
      self.npcNameTxt2:setVisible(false)
      self.img:setPositionXY(self.shift-150,0)
      self.armature_d:addChildAt(self.img,0)
      self.img.direction = self.LEFT;
      self.img:runAction(CCMoveTo:create(0.15,makePoint(self.img:getPosition().x+150,0)))
      if(self.img2) then
        
        --self.img2:setPositionXY(self.img2:getPosition().x+150,0)
        self.img2:runAction(CCMoveTo:create(0,makePoint(self.img2:getPosition().x+150,0)))
      end
    else
      if(self.img3) then
        if (self.img3.direction == self.LEFT)then
          self.armature_d:removeChild(self.img2)
          self.img2 = self.img3
        else
          self.armature_d:removeChild(self.img3)
        end
      end
      if not self.zhujueId then
        if self.img2 and (self.img2.direction == self.RIGHT) then
          self.armature_d:removeChild(self.img2)
          self.img2 = nil;
        end
      end
      self.name:setVisible(false)
      self.name2:setVisible(true)
      self.npcNameTxt:setVisible(false)
      self.npcNameTxt2:setVisible(true)
      if self.npcPo.fangxiang ~= 0 then
        self.img:setScaleX(1);
      else
        self.img:setScaleX(-1);
      end
      self.img:setPositionXY(1280-self.shift+150,0)
      self.armature_d:addChildAt(self.img,0)
      self.img.direction = self.RIGHT;
      self.img:runAction(CCMoveTo:create(0.15,makePoint(self.img:getPosition().x-150,0)))
      if(self.img2) then
        self.img2:runAction(CCMoveTo:create(0,makePoint(self.img2:getPosition().x-150,0)))
      end
    end
end
-- function LeftModalDialogPopup:getClippingImage(artId,mask,scale)
--     local clipper = ClippingNodeMask.new(mask);
--     clipper:setAlphaThreshold(0.0);
--     local image = getImageByArtId(artId)
--     image:setScale(0.5)
--     image:setPositionXY(0,-20)
--     clipper:addChild(image);
--     clipper:setScale(scale)
--     return clipper
-- end
-- function LeftModalDialogPopup:addnpcNameTxt()
--   local str = "";
--   local _count = -1;
--   while (-1-string.len(self.userName)) < _count do
--     str = str .. string.sub(self.userName, -2 + _count, _count) .. "\n";
--     -- log("->" .. _count .. " " .. (-2 + _count) .. " " .. string.sub(self.userName, -2 + _count, _count));
--     _count = -3 + _count;
--   end
--   -- print("name", str)

--   if not self.npcNameTxt then
--     -- self.userName = "真长长长"
   

--     self.npcNameTxt=BitmapTextField.new(str, "yingxiongmingzi");
--      self.npcNameTxt:setScale(1.5)
--     self:addChild(self.npcNameTxt)

--     if _count == -10 then
--       self.npcNameTxt:setPositionXY(752,390)
--     elseif _count == -7 then
--       self.npcNameTxt:setPositionXY(752,360)
--     elseif _count == -13 then
--       self.npcNameTxt:setPositionXY(752,360)
--     elseif _count == -16 then
--       self.npcNameTxt:setPositionXY(752,360)  
--     end
--   else
--     self.npcNameTxt:setString(str);
--   end
-- end