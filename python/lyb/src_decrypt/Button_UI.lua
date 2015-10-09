require "main.view.SevenDays.ui.render.buttonConfig"
require "main.view.SevenDays.ui.render.ListView"
require "main.view.SevenDays.ui.render.HalfPrice"
Button_UI = class(TouchLayer);

function Button_UI:ctor()
	self.class = Button_UI;
	self.btn = {}
	self.btnText_pos = {}
	self.btn_text = {}
	self.buttonConfig = buttonConfig;
	self.btn_index = 1;
	self.btnReddotTab = {};
end

function Button_UI:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	Button_UI.superclass.dispose(self);
end

function Button_UI:initialize( context, day , btn_index)
	self.context = context;
	self.day = day;
	self:initLayer();
	self.skeleton = context.skeleton;
	self.huodongProxy = context.huodongProxy;
	self.bagProxy = context.bagProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.userProxy = context.userProxy;
	self.render1_pos = context.render1_pos;--滑动列表位置
	self.render2_pos = context.render2_pos;
	self.rightbg_pos = context.rightbg_pos;

	local armature = self.skeleton:buildArmature("button_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self.armature_d = armature.display;

	self:addChild(self.armature_d);
	self:initButton(btn_index);
	self:refreshRedDot();
	-- self:initScrollView(self.day);
end



function Button_UI:initButton( btn_index )
	for i=1,4 do
		local btn_name = "btn"..i;
		local btn = self.armature_d:getChildByName(btn_name);
		local btn_pos = convertBone2LB4Button(btn);
		self.armature_d:removeChild(btn);
		btn = CommonButton.new();
		btn:initialize("choseButton", "unchoseButton", CommonButtonTouchable.CUSTOM, self.skeleton);
		btn:setPosition(btn_pos);
		btn:addEventListener(DisplayEvents.kTouchTap, self.onClickBtn, self,i);
		self.btn[i] = btn;
		self.armature_d:addChild(btn);
		btn:select(true);
		local reddot = self.armature_d:getChildByName("reddot"..i);
		reddot.touchEnabled = false;
		reddot.parent:removeChild(reddot, false);
		self.armature_d:addChild(reddot);
		self.btnReddotTab[i] = {reddot = reddot, IsVisible = false};
	end
	self:updateText(self.day);
	log("function Button_UI:initButton( btn_index ) self:initScrollView(self.day); ")
	self:initScrollView(self.day);

	print("self.btn_index = ",  btn_index)
	self.btn[btn_index or 1 ]:select(false);
end

function Button_UI:refreshRedDot(  )
	--用来维护右边四个按钮小红点
	for k,v in pairs(self.btnReddotTab) do
		v.reddot:setVisible(v.IsVisible);
	end
end

function Button_UI:updateButton( btn_index )
	for i=1,4 do
		if i == btn_index then
			self.btn[i]:select(false);
			if i == 4 then
				self:initHalfPrice(self, self.day);
				self.listScrollView:setVisible(false);
			else
				self.listScrollView:setVisible(true);
				if self.harlfPrice ~= nil then
					self.harlfPrice:setVisible(false);
				end
			end
		else
			self.btn[i]:select(true);
		end		
	end
end


function Button_UI:onClickBtn( event, data)

	print("date" , data);
	print("onClickBtn");
	for i=1,4 do

		if i == data then
			self.btn[i]:select(false);
			-- print("onClickBtn btn"..i, "self.day = ", self.day);

			self.btn_index = i;
			self.context.btn_index = i;

			if i == 4 then
				self:initHalfPrice(self, self.day);
				self.listScrollView:setVisible(false);
			else
				self.listScrollView:updateListView(self.day, i);
				self.listScrollView:setVisible(true);
				if self.harlfPrice ~= nil then
					self.harlfPrice:setVisible(false);
				end
			end
		else
			self.btn[i]:select(true);
		end
	end
end

function Button_UI:updateText( day)


print("\n\n\n\n\n-------------------------------------------updateText")
	for i=1,4 do
		self.day = day ;
		self:removeChild(self.btn_text[i]);
		local btn_textDate = self.armature:getBone("text"..i).textData;
		log("text = ", self.buttonConfig[day][i])
		local BMText = BitmapTextField.new(self.buttonConfig[day][i], "huodong", btn_textDate.width, btn_textDate.alignment);
		local bmsize = BMText:getContentSize();
		local fixX = (btn_textDate.width - bmsize.width) / 2;
		BMText:setPositionXY(btn_textDate.x + fixX, btn_textDate.y);
		self.btn_text[i] = BMText;
		self:addChild(self.btn_text[i]);
		self.btn_text[i].touchEnabled = false;
		self.armature_d:removeChild(btn_text);
		self.btn[i]:select(true);
	end
	-- self.btn[1]:select(false);
end

function Button_UI:initScrollView( day)
	log("function Button_UI:initScrollView( day)")
	if self.listScrollView == nil then
		print("initScrollView")
		self.listScrollView = ListView.new();
		self.listScrollView:initialize(self, day, 1);

		-- print("self.rightbg_pos = ", self.rightbg_pos.x, self.rightbg_pos.y);
		self.listScrollView:setPosition(self.rightbg_pos);
		self:addChild(self.listScrollView);
	end
end

function Button_UI:initHalfPrice()
	if self.harlfPrice == nil then
		self.harlfPrice =  HalfPrice.new();
		self.harlfPrice:initialize(self, self.day);
		self.harlfPrice:setPosition(self.rightbg_pos);
		self:addChild(self.harlfPrice);
	else
		self.harlfPrice.day = self.day;
		self.harlfPrice:setVisible(true);
		self.harlfPrice:updateHarfPrice();
	end
end