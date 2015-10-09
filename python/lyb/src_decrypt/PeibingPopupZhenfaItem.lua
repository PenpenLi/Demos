require "core.controls.page.CommonSlot"

PeibingPopupZhenfaItem=class(CommonSlot);

function PeibingPopupZhenfaItem:ctor()
  self.class=PeibingPopupZhenfaItem;
  self.beginX = 0;
  self.endX = 0;
end

function PeibingPopupZhenfaItem:dispose()
	self:removeChildren()
	PeibingPopupZhenfaItem.superclass.dispose(self);
	self.armature4dispose:dispose();
end

function PeibingPopupZhenfaItem:initialize(context, onCardTap, id)
	self:initLayer();
	self.context = context;
	self.onCardTap = onCardTap;
	self.id = id;
	self.skeleton = self.context.skeleton;
	--骨骼
	local armature=self.skeleton:buildArmature("right_list_item");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature4dispose=armature;
	self.armature=armature.display;
	self:addChild(self.armature);

	local grid = self.armature:getChildByName("bg");
	grid:setScale(0.92);
	grid:setPositionXY(3+grid:getPositionX(),-5+grid:getPositionY());

	local img = Image.new();
	img:loadByArtID(analysis("Zhenfa_Zhenfa",self.id,"icon"));
	img:setScale(0.55);
	img:setPositionXY(26,43);
	self.armature:addChild(img);

	self.name_descb=createTextFieldWithTextData(self.armature4dispose:getBone("bg").textData,analysis("Zhenfa_Zhenfa",self.id,"name"));
  	self.armature:addChild(self.name_descb);

  	self:addEventListener(DisplayEvents.kTouchBegin, self.onTapBegin, self);
	self:addEventListener(DisplayEvents.kTouchEnd, self.onTapEnd, self);
end

function PeibingPopupZhenfaItem:onTapBegin(event, data)
  	self.beginX = event.globalPosition.x;
end

function PeibingPopupZhenfaItem:onTapEnd(event)
	self.endX = event.globalPosition.x;
	if math.abs(self.beginX - self.endX) < 10 then
	 	if GameVar.tutorStage == TutorConfig.STAGE_1027 then
 			sendServerTutorMsg({})
 			closeTutorUI();
       	end
  		self.onCardTap(self.context,self.id,true);
	end;
end

function PeibingPopupZhenfaItem:setIsPlayImg(bool)
	if not self.select_img and bool then
		self.select_img = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid_over");
		self.select_img:setPositionXY(16,33);
		self.select_img:setScale(0.92);
		self.armature:addChild(self.select_img);
	end
	if self.select_img then
		self.select_img:setVisible(bool);
	end
end