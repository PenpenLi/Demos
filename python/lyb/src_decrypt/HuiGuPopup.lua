require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";

HuiGuPopup=class(LayerPopableDirect);
function HuiGuPopup:ctor()
  self.class=HuiGuPopup;
end

function HuiGuPopup:dispose()
	self.clipper:removeChildren();
	for k,v in pairs(self.ZJList) do
		v:dispose();
	end
	self.mainSceneScript:dispose();
	self.clipper:removeEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin);
	self:removeShceduler();
	HuiGuPopup.superclass.dispose(self);
end

function HuiGuPopup:initialize()
  	self.skeleton=nil;
  	self.countProxy = nil;
end
function HuiGuPopup:onDataInit()
	self.countProxy = self:retrieveProxy(CountControlProxy.name);
	self.storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
	self.skeleton = getSkeletonByName("huiGu_ui");
	local layerPopableData = LayerPopableData.new();
	layerPopableData:setHasUIBackground(true);
	layerPopableData:setHasUIFrame(true);
	layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_STORYLINE,nil,true);
	layerPopableData:setArmatureInitParam(self.skeleton,"huiGu_ui");
	layerPopableData:setShowCurrency(true);
	self:setLayerPopableData(layerPopableData);
	
end

function HuiGuPopup:initialize()
  -- self:initLayer();

  
  -- self:addChild(LayerColorBackGround:getBackGround());
  -- self.skeleton=nil;
end

function HuiGuPopup:onPrePop()
 	self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT)); 
	self.armature_d = self.armature.display;

	self.nameTF = BitmapTextField.new("剧情回顾","anniutuzi");
	local ttlTFC = self.armature_d:getChildByName("ttlTF");
	ttlTFC:addChild(self.nameTF);
	self.askBtn = Button.new(self.armature:findChildArmature("common_copy_ask_button"),false,"");
	self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
	self.renderTmp = self.armature_d:getChildByName("itemTmp");
	self.askBtn:setVisible(false);

 	local tempCCSprite = CCSprite:create();
    local tempSprite = Sprite.new(tempCCSprite);
	self.clipper = ClippingNode.new(tempSprite);
	self.clipper:setAlphaThreshold(0.0);
	self.clipper:setContentSize(makeSize(1010,500));
	self.renderTmp:addChild(self.clipper);
	self.clipper:addEventListener(DisplayEvents.kTouchBegin,self.onMoveBegin,self);
	self.ZJRdArr = {};
	self.GQRdArr = {};
	self.ZJList = {};
	self.ZJListDatas = {};
	for i=1,7 do
		local blRender = BlRender.new(self.skeleton,self);
		self.clipper:addChild(blRender:getDisplay());
		blRender:setVisible(false);
		table.insert(self.ZJList,blRender);
		table.insert(self.GQRdArr,blRender);
	end
	for i=1,7 do
		local render = FrRender.new(self.skeleton,self);
		local render_d = render:getDisplay();
		self.clipper:addChild(render_d);
		render_d:addEventListener(DisplayEvents.kTouchTap,self.onClickRender,self,render);
		render:setVisible(false);
		table.insert(self.ZJList,render);
		table.insert(self.ZJRdArr,render);
		self.renderW = render:renderWidth();
	end
	self.starIndex = 1;
	self.startX = 0;
	self.selectIdx = 0;
	self.starSubIndex = 1;
	local idx=self.starIndex;
	for i,v in ipairs(self.ZJRdArr) do
		local data = 
		v:setData(idx);
		idx=idx+1;
	end

	self:onMakeList();
	require "main.controller.command.scriptCartoon.MainSceneScript"
  -- self.mainSceneScript = MainSceneScript.new()
   	self.mainSceneScript = MainSceneScript.new()
   	self.mainSceneScript:initScript(self)
end
function HuiGuPopup:endScriptData()
	local scriptId = tonumber(self.scriptidArr[self.scriptIdx]);
	if scriptId and scriptId >0 then
		local function callBack()
			self.mainSceneScript:beginScript(scriptId)
			self.scriptIdx=self.scriptIdx+1;
		end 
		Tweenlite:delayCallS(0,callBack);
	end
end
function HuiGuPopup:playScript(arr)
	self.scriptIdx = 1;
	self.scriptidArr = arr;
	self:endScriptData();
end
function HuiGuPopup:onShowTip()
end
function HuiGuPopup:onMoveBegin(event)
	self.isMove = nil;
	self.moveDX = 0;
	self:removeShceduler();
	self.beginX = event.globalPosition.x;
	self.clipper:addEventListener(DisplayEvents.kTouchMove,self.onMove,self);
	self.clipper:addEventListener(DisplayEvents.kTouchEnd,self.onMoveEnd,self);
end
function HuiGuPopup:onMove(event)
	local x,y = event.globalPosition.x,event.globalPosition.y;
	if not self.isMove and math.abs(x - self.beginX) > 20 then self.isMove = true end
	if self.isMove then
		self.moveDX = x-self.beginX;
		self.beginX = x;
		self:onMoveX(self.moveDX);
	end
end

function HuiGuPopup:onMoveEnd(event)
	self.clipper:removeEventListener(DisplayEvents.kTouchMove,self.onMove);
	self.clipper:removeEventListener(DisplayEvents.kTouchEnd,self.onMoveEnd);
	if self.isMove then
		local function callBackFun()
			self.moveDX = self.moveDX*0.85;
			if math.abs(self.moveDX)>1 then
				self:onMoveX(self.moveDX);
			else
				self:removeShceduler();
			end
		end
		callBackFun();
	 	self.shcedulerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callBackFun,0,false);
	 end
end
function HuiGuPopup:removeShceduler()
	if self.shcedulerId then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.shcedulerId);
	end
end
local function sortFun(a, b)
	return a.sortTag < b.sortTag;
end
function HuiGuPopup:getZJDatas(idx)
	local function isStoryOpen( storyLineId )
		local storylines = self.storyLineProxy.openedStorylineIds;
		for k, v in ipairs(storylines) do
			if v == storyLineId then
				return true;
			end
		end
	end
	local data = self.ZJListDatas[idx];
	if not data then
		local daTm = analysisByName("Juqing_Juqinghuigu","type",idx);
		data = {};
		for k,v in pairs(daTm) do
			data[v.type2]=v;
			data[v.type2].isOpen = self.storyLineProxy:getStrongPointState(v.guankaid)==1
		end
		data.isOpen=data[1] and isStoryOpen(data[1].storyId);
		self.ZJListDatas[idx] = data;
	end
	return data;
end
function HuiGuPopup:onMakeList()
	local subIdx = self.starSubIndex;
	local selectDatas = self.ZJListDatas[self.selectIdx] or {};
	self.selectDC = #selectDatas;
	for i1,v1 in ipairs(self.GQRdArr) do 
		v1:setData(selectDatas[subIdx],self.selectIdx,subIdx);
		subIdx=subIdx+1;
	end
	table.sort( self.ZJList, sortFun );
	table.sort(self.ZJRdArr,sortFun);
	local showCount = 0;
	for i=1,14 do
		local render = self.ZJList[i];
		if render.isFrRdr then
			render:setVisible(i<=7);
		end
		render:setPositionX(self.startX+self.renderW*(i-1));
	end
end
function HuiGuPopup:onMoveX(x)
	local render = self.ZJList[1];
	self.startX = render:getPositionX()+x;
	if self.startX+self.renderW<0 then
		if not self.ZJList[5].isUsed then 
			self.startX = -self.renderW;
			return;
		end
		if render.isFrRdr then
			self.starIndex=self.starIndex+1;
			render:setData(self.starIndex+6);
		else
			if self.starSubIndex >=self.selectDC then 
				self.starSubIndex = self.selectDC+1;
			else
				self.starSubIndex=self.starSubIndex+1;
			end
		end
		self.startX = 0;
		return self:onMakeList();
	elseif self.startX>0 then
		if self.starIndex<=1 then 
			self.startX = 0 
			return;
		end
		if render.isFrRdr then
			if self.starIndex-1 == self.selectIdx then
				self.starSubIndex = self.selectDC;
			else
				self.starIndex=self.starIndex-1;
				self.ZJRdArr[7]:setData(self.starIndex);
			end
		else
			if self.starSubIndex <=1 then 
				self.starIndex=self.starIndex-1 
				self.ZJRdArr[7]:setData(self.starIndex);
			else
				self.starSubIndex=self.starSubIndex-1;
			end
		end

		self.startX = -self.renderW;
		return self:onMakeList();
	end
	for i,render in ipairs(self.ZJList) do
		 if render.isUsed then
			render:moveX(x);
		end
	end
end

function HuiGuPopup:onClickRender(event,render)
	if self.isClicked or self.isMove or render:isLock() then return end;
	self.isClicked = true;
	if self.selectIdx == render.index then
		--self.selectIdx = 0;
		self:onUICloseList()
	else
		self.selectIdx = render.index;
		self.starSubIndex = 1;
		self:onMakeList();
		self:onUIShowList()
	end
	--self:onMakeList();

end
function HuiGuPopup:onUIShowList()
	local startX = nil;
	local moveIdx = 0;
	for i,render in ipairs(self.ZJList) do
		if render.isFrRdr and render.index == self.selectIdx then 
			startX = render:getPositionX();
		elseif not render.isFrRdr and not startX then
			startX = render:getPositionX();
		elseif startX and render.isFrRdr then
			startX = startX+self.renderW;
			render:setPositionX(startX)
			Tweenlite:to(render:getDisplay(),0.05*moveIdx,self.renderW*moveIdx,0,0,nil,true);
			render:setVisible(true);
		elseif startX then
			moveIdx=moveIdx+1
			render:setPositionX(startX)
			Tweenlite:to(render:getDisplay(),0.05*moveIdx,self.renderW*moveIdx,0,0,nil,true);
		end
	end
	local function callBack()
		self:onMakeList();
		self.isClicked = nil;
	end
	Tweenlite:delayCallS(0.05*moveIdx,callBack)
end
function HuiGuPopup:onUICloseList()
	local endX = nil;
	local moveIdx = 0;
	for i,render in ipairs(self.ZJList) do
		if render.isFrRdr and render.index == self.selectIdx then 
			endX = render:getPositionX();
		elseif not render.isFrRdr and not endX then
			endX = render:getPositionX();
		elseif endX and render.isFrRdr then
			Tweenlite:to(render:getDisplay(),0.05*moveIdx,-self.renderW*moveIdx,0,0,nil,true);
			render:setVisible(true);
		elseif endX then
			moveIdx=moveIdx+1
			Tweenlite:to(render:getDisplay(),0.05*moveIdx,-self.renderW*moveIdx,0,0,nil,true);
		end
	end
	local function callBack()
		self.selectIdx = 0;
		self:onMakeList();
		self.isClicked = nil;
	end
	Tweenlite:delayCallS(0.05*moveIdx,callBack)
end
function HuiGuPopup:onUIInit()
  --CCDirector:sharedDirector():setProjection(kCCDirectorProjectionDefault);
end

function HuiGuPopup:onRequestedData()

end

function HuiGuPopup:onUIClose()
	self:dispatchEvent(Event.new("closeNotice",nil,self));
end
local function makeHStr(name)
	local str = "";
    local _count = -1;
    while (-1-string.len(name)) < _count do
		str = string.sub(name, -2 + _count, _count) .. "\n"..str;
		_count = -3 + _count;
    end
    return str;
end
local function makeHStr2(name)
	local str = "";
    local _count = -1;
    while (-1-string.len(name)) < _count do
		str = str..string.sub(name, -2 + _count, _count) ;
		_count = -3 + _count;
    end
    return str;
end
FrRender=class(EventDispatcher);
function FrRender:ctor(skeleton,parent)
	self.parent = parent;
	self.skeleton = skeleton;
	self.isFrRdr = true;
	self:buildRender();
	self:initUI();
end
function FrRender:buildRender()
  self.armature=self.skeleton:buildArmature("renderFr_ui");
  self.armature.animation:gotoAndPlay("f1");
  self.armature:updateBonesZ();
  self.armature:update();
  self.armature_d=self.armature.display;
end
function FrRender:getDisplay()
	return self.armature_d;
end
function FrRender:renderWidth()
	return self.bg:getContentSize().width;
end
function FrRender:initUI()
	self.bg = self.armature_d:getChildByName("common_copy_item_bg_5");
	self.weikai = self.armature_d:getChildByName("weikai");
	self.zjTF = generateText(self.armature_d,self.armature,"stateTF","");
	self.nameTF = generateText(self.armature_d,self.armature,"battleTF","");
	self.armature_d:setChildIndex(self.weikai,1000);	
end
function FrRender:setData(idx)
	local datas = self.parent:getZJDatas(idx);
	self.sortTag = idx*100;
	self.index = idx;
	self.isOpen = datas.isOpen;
	self.zjData =datas[1];
	if not self.zjData then
		self:setVisible(false);
		return;
	end
	self:setVisible(true);
	self.weikai:setVisible(not self.isOpen);
	self.zjTF:setString("第\n"..idx.."\n章");
	local strName = makeHStr(self.zjData.stroyname)
	self.nameTF:setString(strName);
end
function FrRender:isLock()
	return not self.isOpen;
end
function FrRender:setVisible(b)
	b = self.zjData and b;
	self.armature_d:setVisible(b);
	self.isUsed = b;
end
function FrRender:setPositionX(x)
	self.armature_d:setPositionX(x)
end
function FrRender:getPositionX()
	return self.armature_d:getPositionX()
end
function FrRender:moveX(x)
	self:setPositionX(self:getPositionX()+x);
end
function FrRender:dispose()
	self.parent = nil;
	self.armature:dispose();
end

BlRender=class(EventDispatcher);
function BlRender:ctor(skeleton,parent)
	self.parent = parent;
	self.skeleton = skeleton;
	self:buildRender();
	self:initUI();
end
function BlRender:buildRender()
  self.armature=self.skeleton:buildArmature("renderBl_ui");
  self.armature.animation:gotoAndPlay("f1");
  self.armature:updateBonesZ();
  self.armature:update();
  self.armature_d=self.armature.display;
end
function BlRender:getDisplay()
	return self.armature_d;
end
function BlRender:renderWidth()
	return self.bg:getContentSize().width;
end
function BlRender:initUI()
	self.bg = self.armature_d:getChildByName("common_background");
	self.msgT1 = self.armature_d:getChildByName("msgT1");
	self.msgT2 = self.armature_d:getChildByName("msgT2");
	self.weikai = self.armature_d:getChildByName("weikai");
	self.ttlTF = generateText(self.armature_d,self.armature,"tiTF","");
	-- self.msg1TF = generateText(self.armature_d,self.armature,"msg1","");
	-- self.msg2TF = generateText(self.armature_d,self.armature,"msg2","");
	self.huiGuBtn = Button.new(self.armature:findChildArmature("common_huigu_button"),false,"");
	self.huiGuBtn:addEventListener(Events.kStart,self.clickBtn,self);

	self.msg1TF=BitmapTextField.new("", "juqinghuigu",30);
    self.msg1TF.sprite:setAnchorPoint(transLayerAnchor(0, 1));
    self.msg1TF.sprite:setLineBreakWithoutSpace(true);
    self.msgT1:addChild(self.msg1TF);

    self.msg2TF=BitmapTextField.new("", "juqinghuigu",30);
    self.msg2TF.sprite:setAnchorPoint(transLayerAnchor(0, 1));
    self.msg2TF.sprite:setLineBreakWithoutSpace(true);
    self.msgT2:addChild(self.msg2TF);
    self.armature_d:setChildIndex(self.weikai,1000);	
end
function BlRender:clickBtn()
	self.parent:playScript(self.scriptidArr);
end
function BlRender:setData(data,idx,subIdx)
	self.sortTag = idx*100+subIdx;
	self.index = idx;
	self.subIndex = subIdx;
	self.data = data;
	if not data then
		self:setVisible(false);
		self.sortTag = 999999999;
		return 
	end
	self:setVisible(true);
	self.weikai:setVisible( not self.data.isOpen);
	local strName = makeHStr(self.data.name)
	self.ttlTF:setString(strName)
	local msg1str = makeHStr2(self.data.txt1)
	local msg2str = makeHStr2(self.data.txt2)
	self.msg1TF:setString(msg2str)
	self.msg2TF:setString(msg1str)
	self.scriptidArr = StringUtils:lua_string_split(self.data.scriptid,",");
	self.huiGuBtn:setVisible(tonumber(self.scriptidArr[1])>0)
	self.huiGuBtn:setEnabled(self.data.isOpen);
end
function BlRender:setVisible(b)
	self.armature_d:setVisible(b);
	self.isUsed = b;
end
function BlRender:setPositionX(x)
	self.armature_d:setPositionX(x)
end
function BlRender:getPositionX()
	return self.armature_d:getPositionX()
end
function BlRender:moveX(x)
	self:setPositionX(self:getPositionX()+x);
end

function BlRender:dispose()
	self.parent = nil;
	self.armature:dispose();
end