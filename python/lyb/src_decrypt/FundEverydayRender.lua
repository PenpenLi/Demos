
FundEverydayRender=class(Layer);

function FundEverydayRender:ctor()
  self.class=FundEverydayRender;
end

function FundEverydayRender:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FundEverydayRender.superclass.dispose(self);
end


function FundEverydayRender:initialize(skeleton,dayIndex,state)
  self:initLayer();
  self.skeleton=skeleton;
  self.dayIndex=dayIndex;
  self.state = state;

  --骨骼
  local armature=skeleton:buildArmature("fund_everyday_render");--armature是个容器?相当于movieClip
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  
  --text_day
  local text="第"..self.dayIndex.."天";
  local text_data = armature:getBone("text_day").textData;
  self.text_day = createTextFieldWithTextData(text_data,text);
  self.armature:addChildAt(self.text_day,1);
  
  --symbol_right
  self.symbol_right = self.armature:getChildByName("symbol_right");
  self.symbol_right:setVisible(state==1);


  --red_border
  self.red_border = self.armature:getChildByName("red_border");
  self.red_border:setVisible(false);


  --blackCarvas
  self.blackCarvas = self.armature:getChildByName("blackCarvas");
  self.blackCarvas:setVisible(false);

end



function FundEverydayRender:setData(boo)
  self.symbol_right:setVisible(boo);
end

function FundEverydayRender:isPassed(boo)
  self.blackCarvas:setVisible(boo);
end

function FundEverydayRender:select(boo)
  self.red_border:setVisible(boo);
end