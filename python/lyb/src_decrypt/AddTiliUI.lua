
AddTiliUI = class(TouchLayer)

function AddTiliUI:ctor()
	self.class = AddTiliUI;
  self.state = nil;
end

function AddTiliUI:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  AddTiliUI.superclass.dispose(self);
  if self.cdTime1Listener then
    self.cdTime1Listener:dispose();
    self.cdTime1Listener = nil;
  end
  self.armature:dispose()
end

function AddTiliUI:initializeUI(userCurrencyProxy, countControlProxy)

  self.userCurrencyProxy = userCurrencyProxy;
  self.countControlProxy = countControlProxy;
  self:initLayer();

  self.childLayer = TouchLayer.new();
  self.childLayer:initLayer();
  self:addChild(self.childLayer)

  local mainSize = Director:sharedDirector():getWinSize();
  self.childLayer.sprite:setContentSize(CCSizeMake(mainSize.width, mainSize.height));
  self.childLayer:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
  
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("main_ui");
  end

  local armature=self.skeleton:buildArmature("tiliTip");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  local armature_d=armature.display;
  self:addChild(armature_d);

  local tiliTextTextData = armature:getBone("tiliText").textData;

  local tili = '体力：' .. self.userCurrencyProxy.tili.."/" .. analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1014,"constant");
  self.tiliText = createTextFieldWithTextData(tiliTextTextData, tili);
  armature_d:addChild(self.tiliText);

  local danyaoTextDescData = armature:getBone("huifuText").textData;
  self.danyaoTextDesc = createTextFieldWithTextData(danyaoTextDescData, "恢复：6分钟恢复1点");
  armature_d:addChild(self.danyaoTextDesc);


  local remainCount, totalCount = self.countControlProxy:getRemainCountByID(CountControlConfig.AddTili);
  -- local countStr = (totalCount - remainCount) .. "/" .. totalCount
  local danyaoTextData = armature:getBone("danyaoText").textData;
  self.danyaoText = createTextFieldWithTextData(danyaoTextData, "饺子：今日可吃" .. remainCount .."笼");
  armature_d:addChild(self.danyaoText);


  local huifuDescTextData = armature:getBone("huifuDescText").textData;
  self.huifuDescText = createTextFieldWithTextData(huifuDescTextData, "体力满后不恢复");
  armature_d:addChild(self.huifuDescText);

  local common_copy_background_4 = armature_d:getChildByName("common_copy_background_4");

  armature_d:setContentSize(common_copy_background_4:getContentSize());
  armature_d:setPositionXY(845, 495+GameData.uiOffsetY*2);

end
--state, danyaoText = userProxy.danyaoText

function AddTiliUI:onTipsEnd()
  print("ddddddddddddddddd")
  self.parent:removeChild(self)
end
