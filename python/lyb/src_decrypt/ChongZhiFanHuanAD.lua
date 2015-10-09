require "main.view.huoDong.ui.render.ChongZhiFanHuanADText"
ChongZhiFanHuanAD = class(TouchLayer);

function ChongZhiFanHuanAD:ctor(  )
	self.class = ChongZhiFanHuanAD;
	self.ChongZhiFanHuanADText = ChongZhiFanHuanADText;
end

function ChongZhiFanHuanAD:dispose(  )
	self:removeChildren();
	ChongZhiFanHuanAD.superclass.dispose(self);
end

function ChongZhiFanHuanAD:initialize( context, id )
	self.context = context;
	self.skeleton =  context.skeleton;

	self:initLayer();

	local armature = self.skeleton:buildArmature("chongzhifanhuanAD_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	self.armature_d = armature.display;
	self:addChild(self.armature_d);
	self:initText();

	self.bg=Image.new();
    self.bg:loadByArtID(435);
    self.bg:setPositionXY(470, -45);
   	self.bg:setScale(0.84);
   	self:addChild(self.bg);
end

function ChongZhiFanHuanAD:initText(  )
	for i=1,8 do
		local textData = self.armature:getBone("text"..i).textData;
		text = createTextFieldWithTextData(textData, ChongZhiFanHuanADText[i]);
		self:addChild(text);

	end
end