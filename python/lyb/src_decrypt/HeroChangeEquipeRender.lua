require "main.view.hero.heroPro.ui.EquipItemPageView";
require "main.view.bag.ui.bagPopup.EquipDetailLayer";

HeroChangeEquipeRender = class(Layer);

-- 构造函数
function HeroChangeEquipeRender:ctor()
	self.class = HeroChangeEquipeRender;
	
end

-- 初始化
function HeroChangeEquipeRender:initialize(context,armature,id,itemRender)
	self.detailBG = LayerColorBackGround:getCustomBackGround(860,720,0);
  	self.detailBG:addEventListener(DisplayEvents.kTouchBegin,self.onBGTap,self);
  	self.detailBG:addEventListener(DisplayEvents.kTouchMove,self.onBGTap,self);
  	self:addChild(self.detailBG);

	self.bagSkeleton = getSkeletonByName("bag_ui");

	self.context = context;
	self.armature = armature;
	self:addChildAt(armature.display,0);
	self.context.context.pageView:setMoveEnabled(false);
 --  	local closeButton = Button.new(armature:findChildArmature("common_copy_close_button"), false);
	-- closeButton:addEventListener(Events.kStart, self.closeUI, self);
	local closeButton =self.armature.display:getChildByName("common_copy_close_button");
	  SingleButton:create(closeButton);
	  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

	self.itemCon = self.armature.display:getChildByName("itemCon");
	self.pageTF = generateText(self.armature.display,self.armature,"pageTF","1/1");

	self.tips1 = self.armature.display:getChildByName("tips1");
	self.tips2 = self.armature.display:getChildByName("tips2");

	local bagProxy = context.bagProxy;


	self:setData(id,itemRender);
end

function HeroChangeEquipeRender:onBGTap(event)
	if self.detailLayer2 and self:contains(self.detailLayer2) then
		self:removeChild(self.detailLayer2);
	end
end

function HeroChangeEquipeRender:setData(id,itemRender)
	self.itemRender = itemRender;

	local bagProxy = self.context.bagProxy;
	local item = bagProxy:getEquipDataNotUsedByPlace(id)
	local function sortfunc(data_a, data_b)
		local zhanli_a = self.context.equipmentInfoProxy:getZhanli(data_a.UserItemId);
		local zhanli_b = self.context.equipmentInfoProxy:getZhanli(data_b.UserItemId);
		if zhanli_a > zhanli_b then
			return true;
		elseif zhanli_a < zhanli_b then
			return false;
		end
		return data_a.ItemId > data_b.ItemId;
	end
	table.sort(item, sortfunc);
	if self.init then
		self.pageView:update(item);
	else
	self.pageView = EquipItemPageView:create(self,item,self.pageTF,self.onCardTap);
	self.pageView:setPositionXY(0, -155);
	self.itemCon:addChild(self.pageView);
	end;
	self.init = true;

	if self.detailLayer1 and self:contains(self.detailLayer1) then
		self:removeChild(self.detailLayer1);
	end;  

	if self.detailLayer2 and self:contains(self.detailLayer2) then
		self:removeChild(self.detailLayer2);
	end;  

	--对比
	if itemRender then
		self.detailLayer1 = EquipDetailLayer.new();
	    self.detailLayer1:initialize(self.bagSkeleton,itemRender,false,nil,nil);
	    self.detailLayer1:setPositionXY(73,self.detailLayer1.isSmall and 230 or 30);
	    self:addChild(self.detailLayer1);	
   	end;
end;

--道具点击tips
function HeroChangeEquipeRender:onCardTap(items,itemRender)
	self.curItems = items;
	if self:contains(self.detailLayer2) then
		self:removeChild(self.detailLayer2);
	end;
	self.detailLayer2 = EquipDetailLayer.new();
    self.detailLayer2:initialize(self.bagSkeleton,itemRender,true,nil,BagItemType.equipeItem);
    self.detailLayer2:setPositionXY(463,self.detailLayer2.isSmall and 230 or 30);
    self:addChild(self.detailLayer2);

    if self.detailLayer1 then
    	self.detailLayer2:compareStrengthenValue(self.detailLayer1.strengthenValue);
    end

    self.detailLayer2:addEventListener("onEquip", self.onEquip,self);
end;

function HeroChangeEquipeRender:onEquip(event)
	self:closeUI();
	self:dispatchEvent(Event.new("onEquip",self.curItems.UserItemId,self));
end;

function HeroChangeEquipeRender:closeUI()
	self.context:removeChangeEquipeRender();
end

-- 销毁组件
function HeroChangeEquipeRender:dispose()
	if not self.context.context.pageView.isDisposed then
		self.context.context.pageView:setMoveEnabled(true);
	end
	self.armature:dispose();
	HeroChangeEquipeRender.super.dispose(self);
end

-- 创建实例
function HeroChangeEquipeRender:create(context,id,itemRender)
	local tempSkeleton = getSkeletonByName("hero_ui");
	local armature = tempSkeleton:buildArmature("heroEquipe_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	-- local bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_equipe_bg");
	local container = HeroChangeEquipeRender.new();
	container:initLayer();
	container:initialize(context,armature,id,itemRender);
	return container;
end

