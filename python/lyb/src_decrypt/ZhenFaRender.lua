
ZhenFaRender=class(TouchLayer);

function ZhenFaRender:ctor()
  self.class=ZhenFaRender;
end

function ZhenFaRender:dispose()
  self:removeAllEventListeners();
  ZhenFaRender.superclass.dispose(self);
end

function ZhenFaRender:initialize(context, id)

  self.context=context
  self:initLayer();
  self.skeleton = context.skeleton
  self.id = id;
  self.zhenFaTab = analysis("Zhenfa_Zhenfa", id);
  

  local armature=self.skeleton:buildArmature("render");
  self.armature = armature;
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  local armature_d=armature.display;
  self.armature_d = armature_d;
  self:addChild(self.armature_d)

  local zhenfa_txtBone = self.armature:getBone("zhenfa_txt");
  self.zhenfa_txt = createTextFieldWithTextData(zhenfa_txtBone.textData, self.zhenFaTab.name);
  self.zhenfa_txt:setPositionXY(120,32)

  local pic_bg =armature_d:getChildByName("pic_bg");
  pic_bg:setScale(0.9)
  pic_bg:setPositionXY(20, -8)
  pic_bg:addChild(self.zhenfa_txt)

  local xiaohao_imgID = analysis("Zhenfa_Zhenfa", id, "icon");
  self.xiaohao_img = Image.new();
  self.xiaohao_img:loadByArtID(xiaohao_imgID);
  self.xiaohao_img:setScale(0.5)
  self.xiaohao_img:setPositionXY(31, -94);
  self.armature_d:addChild(self.xiaohao_img);

  self.panel = armature_d:getChildByName("panel");

  self.frame =armature_d:getChildByName("frame");
  self.frame:setScale(1.03)
  self.frame:setPositionXY(-5,1)  
  self.frame:setVisible(false)

  self.unactivate =armature_d:getChildByName("unactivate");
  self.unactivate:setScale(0.96)
  self.unactivate:setPositionXY(5,-5)
  self.armature_d:swapChildren(self.unactivate, self.xiaohao_img)
  self.armature_d:swapChildren(self.unactivate, self.frame)

  self.unactivate:setVisible(true)
  self:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);

  self:initRedDot()  
end

function ZhenFaRender:initRedDot()
  self.redIcon = CommonSkeleton:getCommonBoneTextureDisplay("commonImages/common_redIcon");
  self.redIcon:setPositionXY(190,85)
  
  local isVisible = self.context.zhenFaProxy:checkCanUpdate(self.id,self.context.bagProxy,self.context.userCurrencyProxy)
  self.redIcon:setVisible(isVisible)
end

function ZhenFaRender:onTapBegin(event)
  self.tapitembegin=event.globalPosition
  self:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
end


function ZhenFaRender:onTapEnd(event)
  if self.tapitembegin and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    self.context:selectItem(self.id)
    self:removeEventListener(DisplayEvents.kTouchTap, self.onTap, self)
    if GameVar.tutorStage == TutorConfig.STAGE_1026 then
      openTutorUI({x=948, y=116, width = 132, height = 50});
    end 

  end
  
end




