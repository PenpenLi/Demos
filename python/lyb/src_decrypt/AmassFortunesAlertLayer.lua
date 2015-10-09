
AmassFortunesAlertLayer=class(TouchLayer);

function AmassFortunesAlertLayer:ctor()
  self.class=AmassFortunesAlertLayer;
end

function AmassFortunesAlertLayer:dispose()
  self:removeAllEventListeners();
	self:removeChildren();
  AmassFortunesAlertLayer.superclass.dispose(self);
  self.removeArmature:dispose()
end

function AmassFortunesAlertLayer:initialize(skeleton, id)
  self:initLayer();
  self.skeleton=skeleton;
      --骨骼
  local armature=skeleton:buildArmature("alert_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);

   self.common_copy_gold_bg = self.armature:getChildByName("common_copy_gold_bg");
   self.obtain_gold_bg1 = self.armature:getChildByName("obtain_gold_bg1");

  local timeHasUsed_data=armature:getBone("timeHasUsed").textData;
  self.timeHasUsed=createTextFieldWithTextData(timeHasUsed_data,"次数已经用完了");
  self.armature:addChild(self.timeHasUsed);


  if analysisHas("Huodongbiao_Laohuji", id + 1) then
    local activityPo = analysis("Huodongbiao_Laohuji", id + 1);

    --need
    local text_data=armature:getBone("need").textData;
    self.need=createTextFieldWithTextData(text_data, "仅需");
    self.armature:addChild(self.need);
    
    --need_value
    local text_data=armature:getBone("need_value").textData;
    self.need_value=createTextFieldWithTextData(text_data, activityPo.cost);
    self.armature:addChild(self.need_value);


    local obtain_data=armature:getBone("obtain").textData;
    self.obtain=createTextFieldWithTextData(obtain_data,"至少可得");
    self.armature:addChild(self.obtain);

    local obtain_value_data=armature:getBone("obtain_value").textData;
    self.obtain_value=createTextFieldWithTextData(obtain_value_data,  activityPo.min);
    self.armature:addChild(self.obtain_value);

    self.timeHasUsed:setVisible(false)
  else
    self.timeHasUsed:setVisible(true)
    self.common_copy_gold_bg:setVisible(false);
    self.obtain_gold_bg1:setVisible(false);
  end

end

function AmassFortunesAlertLayer:setData(id)
  if analysisHas("Huodongbiao_Laohuji", id + 1) then
    local activityPo = analysis("Huodongbiao_Laohuji", id + 1);
    self.need_value:setString(activityPo.cost);
    self.obtain_value:setString(activityPo.min);

    self.need:setVisible(true);
    self.need_value:setVisible(true);
    self.obtain:setVisible(true);
    self.obtain_value:setVisible(true);
    self.common_copy_gold_bg:setVisible(true);
    self.obtain_gold_bg1:setVisible(true);

     self.timeHasUsed:setVisible(false);
  else
    
    self.need:setVisible(false);
    self.need_value:setVisible(false);
    self.obtain:setVisible(false);
    self.obtain_value:setVisible(false);
    self.common_copy_gold_bg:setVisible(false);
    self.obtain_gold_bg1:setVisible(false);

     self.timeHasUsed:setVisible(true);
  end
end