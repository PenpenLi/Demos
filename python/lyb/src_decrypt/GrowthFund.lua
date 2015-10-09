require "main.view.huoDong.ui.render.KaifuFund"
require "main.view.huoDong.ui.render.GrowthFundItem"
require "main.view.huoDong.ui.render.GeneralWelfare"
GrowthFund = class(TouchLayer);

function GrowthFund:ctor()
	self.class = GrowthFund;
	self.ItemTable = {};
	self.count = 0;
	self.IsLoading = false;
	self.IDTable = {5,6}
end

function GrowthFund:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	GrowthFund.superclass.dispose(self);
	self.armature:dispose();
end

function GrowthFund:initialize(context, id )
	-- body
	self.context = context;
	self.id = id;
	self.choseId = 5;
	self:initLayer();
	self.data = context.huodongProxy;
	self.huodongProxy = context.huodongProxy;
	self.herohouseProxy = context.herohouseProxy;
	self.userProxy =  context.userProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	print(" self.initLayer() ","id = ", id)
	self.skeleton = context.skeleton;
	local armature = self.skeleton:buildArmature("growthFoudContainer");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature; 

	local  armature_d = armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);
	self:initButton();
	self:initKaifuFund();
	self:refreshRaddot();



end

function GrowthFund:refreshData( tem)
	--获取开服基金数据
	print("\n\n\n\n\n\n.IsBuyFund = ", self.data.IsBuyFund, tem, self.choseId);

	self.data3 = self.huodongProxy:getHuodongDataByID(self.choseId);

	if self.choseId == 5 then
		-- 开服基金数据
		if #self.data3 == 1 then
			-- 表示领取奖励确认数据
			print(" takeAward check data", self.choseId)
			self.kaifuFund:replaceItem(self.data3[1], self.data1);
			local booleanValue = 0;
			for k,v in pairs(self.data1) do
				if v.Count >= v.MaxCount and v.BooleanValue == 0 then
					booleanValue = 1;
					break;
				end
			end
			self.huodongProxy:setReddotDataByID(5, booleanValue);

		else
			-- 表示刷新数据
			self.data1 = self.huodongProxy:getHuodongDataByID(self.choseId);
			print(" refreshData data", self.choseId, self.data1);
			if self.kaifuFund ~= nil then
			if self.kaifuFund.listScrollViewLayer == nil then 
				self.kaifuFund:initScrollView();
			end
			end
		end
	elseif self.choseId == 6 then
		-- 全名福利数据
		if #self.data3 == 1 then
			-- 表示领取奖励确认数据
			print(" takeAward check data", self.choseId)
			self.GeneralWelfare:replaceItem(self.data3[1], self.data1);
			local booleanValue = 0;
			for k,v in pairs(self.data2) do
				if v.Count >= v.MaxCount and v.BooleanValue == 0 then
					booleanValue = 1;
					break;
				end
			end
			self.huodongProxy:setReddotDataByID(6, booleanValue);
		else
			-- 表示刷新数据
			
			self.data2 = self.huodongProxy:getHuodongDataByID(6);
			print(" refreshData data", self.choseId, self.data2);
			if self.GeneralWelfare ~= nil then
				self.GeneralWelfare:initScrollView(self, 6);
				self.GeneralWelfare:initCount();
			end
		end

	end

	self:refreshRenderReddot();
	self.context:refreshMainHuoDongReddot();

	-- self.data1 = self.huodongProxy:getHuodongDataByID(5);
	-- self.data2 = self.huodongProxy:getHuodongDataByID(6);
end

function GrowthFund:refreshRenderReddot()
	local booleanValue = self.huodongProxy:getReddotState(nil, self.IDTable);

	if booleanValue == 1 then
		self.context:renderDotVisible(5, true);
	else
		self.context:renderDotVisible(5,false);
	end

end

-- function GrowthFund:replaceItem(oldData, newData,listview, choseId)
-- 	if oldData == nil or newData == nil or listview == nil then
-- 		return;
-- 	end
-- 	local index = -1;
-- 	for k,v in pairs(oldData) do
-- 		if oldData.ConditionID == newData.ConditionID then
-- 			index = k;
-- 			break;
-- 		end
-- 	end

-- 	if index == -1 then
-- 		return;
-- 	else
-- 		listview:removeItemAt(index -1);
-- 		if choseId == 5 then
-- 			local Item = GrowthFundItem.new();
-- 			item:initialize(self, , self.id, self.data.IsBuyFund);
-- 			self.listScrollViewLayer:addItem(item);

-- 		else
-- 		end
-- 	end
-- end

function GrowthFund:initKaifuFund(  )

	if self.kaifuFund == nil then
		self.kaifuFund = KaifuFund.new();
		self.kaifuFund:initialize(self, 5)
		self.kaifuFund:setPosition(self.rightbg_pos)
		self:addChild(self.kaifuFund);
    end

end

function GrowthFund:initGeneralWelfare(  )
	if not self.GeneralWelfare then
		self.GeneralWelfare = GeneralWelfare.new();
		self.GeneralWelfare:initialize(self, 6);
		self.GeneralWelfare:setPosition(self.rightbg_pos);
		self:addChild(self.GeneralWelfare);
		sendMessage(29,2, {ID = 6});
	end
end

function GrowthFund:initButton()


	--开服基金按钮
	local kaifu_btn=self.armature.display:getChildByName("kaifu_btn");
	local kaifu_btn_pos=convertBone2LB4Button(kaifu_btn);--kaifu_btn:getPosition();
	self.armature.display:removeChild(kaifu_btn);

	kaifu_btn=CommonButton.new();
	kaifu_btn:initialize("choseButton","unchoseButton",CommonButtonTouchable.CUSTOM,self.skeleton);
	kaifu_btn:setPosition(kaifu_btn_pos);
	kaifu_btn:addEventListener(DisplayEvents.kTouchTap,self.onClickKaifuBtn,self);
	self.armature.display:addChild(kaifu_btn);
	self.kaifu_btn = kaifu_btn;

	local img = self.armature_d:getChildByName("kaifujijin");
	img.touchEnabled = false;
	img.parent:removeChild(img,false);
	self.armature_d:addChild(img);

	--全民福利按钮
	local quanming_btn = self.armature_d:getChildByName("quanming_btn");
	local quanming_btn_pos = convertBone2LB4Button(quanming_btn);
	self.armature_d:removeChild(quanming_btn);

	quanming_btn = CommonButton.new();
	quanming_btn:initialize("choseButton", "unchoseButton", CommonButtonTouchable.CUSTOM, self.skeleton);
	quanming_btn:setPosition(quanming_btn_pos);
	quanming_btn:addEventListener(DisplayEvents.kTouchTap, self.onClickQuanmingBtn, self);
	quanming_btn:select(true);
	self.armature_d:addChild(quanming_btn);
	self.quanming_btn = quanming_btn;

	local quanming_img = self.armature_d:getChildByName("quanmingfuli");
	quanming_img.touchEnabled = false;
	quanming_img.parent:removeChild(quanming_img, false);
	self.armature_d:addChild(quanming_img);

	local reddot1 = self.armature_d:getChildByName("reddot1");
	self.reddot1 = reddot1;
	reddot1.touchEnabled = false;
	reddot1.parent:removeChild(reddot1, false);
	self:addChild(reddot1);
	local reddot2 = self.armature_d:getChildByName("reddot2");
	self.reddot2 = reddot2;
	reddot2.touchEnabled = false;
	reddot2.parent:removeChild(reddot2, false);
	self:addChild(reddot2);

	self.reddot1:setVisible(false);
	self.reddot2:setVisible(false);

end

function GrowthFund:onClickKaifuBtn(  )
	print("onClickKaifuBtn");
	self.choseId = 5;
	self.quanming_btn:select(true);
	self.kaifu_btn:select(false);
	if self.GeneralWelfare then
		self.GeneralWelfare:setVisible(false);
	end
	self.kaifuFund:setVisible(true);
end

function GrowthFund:onClickQuanmingBtn(  )
	print("onClickQuanmingBtn");
	self.choseId = 6;
	self.quanming_btn:select(false);
	self.kaifu_btn:select(true);
	self.kaifuFund:setVisible(false);
	self:initGeneralWelfare();
	self.GeneralWelfare:setVisible(true);
end


function GrowthFund:takeAward(conditionID)
  -- self.context.huodongProxy:takeAward(self.id, conditionID) 
end

function GrowthFund:refreshRaddot()
	-- local reddotTab = self.huodongProxy:getRedDotTab();

	-- for k,v in pairs(reddotTab) do
	-- 	if v.ID == 5 and v.BooleanValue == 1 then
	-- 		self.reddot1:setVisible(true);
	-- 	end
	-- 	if v.ID == 6 and v.BooleanValue == 1 then
	-- 		self.reddot2:setVisible(true);
	-- 	end
	-- end
	local reddot1 = self.huodongProxy:getReddotState(5, nil);
	local reddot2 = self.huodongProxy:getReddotState(6, nil);
	if reddot1 == 1 then 
		self.reddot1:setVisible(true);
	else
		self.reddot1:setVisible(false);
	end
	if reddot2 == 1 then
		self.reddot2:setVisible(true);
	else
		self.reddot2:setVisible(false);
	end
end
