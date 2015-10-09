
LeftUI = class(TouchLayer);

function LeftUI:ctor(  )
	self.class = LeftUI;
	self.day_btn = {}
	self.reddotTab = {}
	self.btn_index = 1;
	
end

function LeftUI:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	LeftUI.superclass.dispose(self);
end

function LeftUI:initialize( context , currentDay)
	self.context = context;
	self:initLayer();
	self.skeleton = context.skeleton;
	self.day = currentDay;
	self.currentDay = currentDay;
	self.button_ui = context.button_ui
	self.huodongProxy = context.huodongProxy;
	self.bagProxy = context.bagProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.userProxy = context.userProxy;
	print("LeftUI self.button_ui = ", self.button_ui);

	local armature = self.skeleton:buildArmature("left_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	self.armature_d = armature.display;
	self:addChild(self.armature_d);
	self:initButton();
	self:refreshRedDot();

end

function LeftUI:initButton(  )
	for i=1,7 do
		local day_btn = self.armature_d:getChildByName("btn"..i);
		local day_btn_pos = convertBone2LB4Button(day_btn);
		self.armature_d:removeChild(day_btn);
		day_btn = CommonButton.new();
		if i == 7 then
			day_btn:initialize("longNomalBtn", "longchosebtn", CommonButtonTouchable.CUSTOM, self.skeleton);
		else
			day_btn:initialize("unchosebtn", "chosebtn", CommonButtonTouchable.CUSTOM, self.skeleton);
		end
		day_btn:setPosition(day_btn_pos);

		day_btn:addEventListener(DisplayEvents.kTouchTap, self.onClikeDayBtn, self, i);
		
		self.armature_d:addChild(day_btn);
		self.day_btn[i] = day_btn;

		local imgName = "num" .. i;
		print("imgName = ", imgName)
		local img = self.armature_d:getChildByName(imgName);
		if img ~= nil then 
			img.touchEnabled = false;
			img.parent:removeChild(img,false);
			self.armature_d:addChild(img);
		else
			print("img"..i.."is nil")
		end

		local reddot = self.armature_d:getChildByName("reddot"..i);
		reddot.touchEnabled = false;
		reddot.parent:removeChild(reddot,false);
		self.armature_d:addChild(reddot);
		self.reddotTab[i] = {reddot = reddot, IsVisible = false};
	end
		self.day_btn[self.day]:select(true, true);

end

function LeftUI:refreshRedDot(  )
	local booleanValue = false;
	for k,v in pairs(self.reddotTab) do
		v.reddot:setVisible(v.IsVisible);
		booleanValue = booleanValue or v.IsVisible;
	end
	local med=Facade.getInstance():retrieveMediator(MainSceneMediator.name);
   	if med then
	    med:refreshSevenDays(booleanValue);
    end
end

function LeftUI:onClikeDayBtn(event, data)

	if self.currentDay < data then
		sharedTextAnimateReward():animateStartByString("活动还没有开启哦，请先完成当天任务吧~!");
		return 
	end
	for i=1,7 do
		if i == data then

			if self.day == i then
				return
			end
			print("btn"..i);
			self.day_btn[i]:select(true, true);
			self.day = i;
			print("self.button_ui = ", self.button_ui);
			self.button_ui:updateText(i);
			if self.button_ui.harlfPrice ~= nil then
				self.button_ui.harlfPrice:setVisible(false);
			end
			self.context.selectDay = i;
			self.context.btn_index = self.button_ui.btn_index;
			self.btn_index = self.button_ui.btn_index;
			print("btn_index = ", self.context.btn_index)
			self.button_ui:updateButton(self.btn_index);
			sendMessage(29,2, {ID = i + 6});
		else
			self.day_btn[i]:select(false, true);
		end
	end
end

function LeftUI:updateLeftUI( currentDay,btn_index )
	log("function LeftUI:updateLeftUI()")
	-- self:updateButton(btn_index);
end

