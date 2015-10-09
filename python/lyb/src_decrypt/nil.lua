--=====================================================
-- 名称：     
-- @authors： 赵新
-- @mail：    xianxin.zhao@happyelements.com
-- @website： http://www.cnblogs.com/tinytiny/
-- @date：    2014-07-22 17:59:45
-- @descrip： 
-- All Rights Reserved. 
--=====================================================

--displayObj	ui
--btnStr		按钮名称
--skinStr 		按钮皮肤
function generateButton(armature,btnStr,skinStr,text,callBack,paramObj,offsetY,append_s,isBMText,offset_down,stroke,btn_type,singlet)
	if nil == append_s then
		append_s = "";
	end
	if not btn_type then
		btn_type = CommonButtonTouchable.BUTTON;
	end
	local displayObj = armature.display;
	local tempBtn = displayObj:getChildByName(btnStr);
	-- local temp_button_pos = convertBone2LB4Button(tempBtn);--不能用，临时处理-70
	local temp_button_pos = convertBone2LB4Button(tempBtn);

	local index = displayObj:getChildIndex(tempBtn);
	displayObj:removeChild(tempBtn);--从原ui中移除

	tempBtn = CommonButton.new();
	tempBtn:initialize(append_s .. skinStr.."_normal",not singlet and append_s .. skinStr.."_down" or nil,CommonButtonTouchable.CUSTOM);

	-- if offsetY == nil then
	-- 	offsetY = 70;
	-- end;
	-- temp_button_pos.y = temp_button_pos.y - offsetY;

	local text_data = armature:findChildArmature(btnStr):getBone(skinStr).textData;
	if isBMText then
		tempBtn:initializeBMText(text,"anniutuzi",_,_,offset_down);
	else
		tempBtn:initializeText(text_data,text,stroke,nil,offset_down,stroke);
	end
	tempBtn.name = btnStr;

	tempBtn:setPosition(temp_button_pos);
	tempBtn:addEventListener(DisplayEvents.kTouchTap,callBack,paramObj);
	displayObj:addChildAt(tempBtn,index);
	
	return tempBtn;
end;

--如果按钮素材在自己的fla中
function generateButtonByPrivateFla(skeleton,armature,btnStr,skinStr,skinStr2,text,callBack,paramObj,offsetY)
  local displayObj = armature.display;
  local tempBtn = displayObj:getChildByName(btnStr);
  -- local temp_button_pos = convertBone2LB4Button(tempBtn);--不能用，临时处理-70
  local temp_button_pos = tempBtn:getPosition();

  local index = displayObj:getChildIndex(tempBtn);
  displayObj:removeChild(tempBtn);--从原ui中移除

  tempBtn = CommonButton.new();
  tempBtn:initialize(skinStr.."_normal",skinStr.."_down",CommonButtonTouchable.BUTTON,skeleton);

  if offsetY == nil then
    offsetY = 70;
  end;
  temp_button_pos.y = temp_button_pos.y - offsetY;

  local text_data = armature:findChildArmature(btnStr):getBone(skinStr2).textData;
  tempBtn:initializeText(text_data,text);
  tempBtn.name = btnStr;

  tempBtn:setPosition(temp_button_pos);
  tempBtn:addEventListener(DisplayEvents.kTouchTap,callBack,paramObj);
  displayObj:addChildAt(tempBtn,index);
  
  return tempBtn;
end;


--displayObj	ui
--armatureObj	对象
--nameStr		文字对象名称
--textStr 		描述文字
function generateText(displayObj,armatureObj,nameStr,textStr,stroke_bool, strokeColor, stroke_size)
	local contentTextData = armatureObj:getBone(nameStr).textData;
	local tempContent =  createTextFieldWithTextData(contentTextData, textStr,stroke_bool, strokeColor, stroke_size);
	displayObj:addChild(tempContent)--,armatureObj:getBone(nameStr).globalZ);  

	return tempContent;
end;

--listX		ui
--listY		对象
--renderWidth		文字对象名称
--renderHeight 		描述文字
--itemCount
--direction
--moveEnabled
function generateTableView(listX,listY,renderWidth,renderHeight,itemCount,direction,moveEnabled)
	if direction then direction = kCCScrollViewDirectionHorizontal; end;
	if moveEnabled then moveEnabled = true; end; 
	local list = GalleryViewLayer.new();
	list:initLayer();
	list:setMoveEnabled(moveEnabled);

	list:setContentSize(makeSize(renderWidth , renderHeight));--* self.ITEM_COUNT
	list:setMaxPage(itemCount);
	list:setViewSize(makeSize(renderWidth, renderHeight));

	list:setDirection(direction);
	list:setPositionXY(listX, listY);
	return list;
end;

--displayObj	ui
--artid			素材id
--artX 	
--artY		
function generateImgByArtId(displayObj,artid,artX,artY)
	local image = Image.new()
	image:loadByArtID(artid)
	image:setPositionXY(artX , artY);
	displayObj:addChild(image)
	return image;
end;

--修改图片素材	
function updateImg(armature,souImg,tarImg,h)
	local pos = souImg:getPosition();
	local index = armature.display:getChildIndex(souImg);
	if armature.display:contains(souImg) then
		armature.display:removeChild(souImg);
	end;
	armature.display:addChildAt(tarImg,index);
	pos.y = pos.y - h;
	tarImg:setPosition(pos);
	-- return tarImg;
end;

--修改星星等级图片素材	
function updateStar(armature,num)
	for i=1,5 do
		local img = armature.display:getChildByName("star"..i)
		if i <= num then
			img:setVisible(true);
		else
			img:setVisible(false);
		end;
	end
	
end;

--图片数字
CartoonNum = class(TouchLayer);

function CartoonNum:ctor()
	self.class = CartoonNum;
	self.name = "root";
end

function CartoonNum:setData(num,skinStr,space)
	self.num = num;
	log("num->" .. num);
	self:removeChildren();
	local numTb = splitNum(num);
	local maxNum = #("" .. num);
	for i = maxNum,1,-1 do
		local numImg = CommonSkeleton:getBoneTextureDisplay("commonNumbers/"..skinStr..numTb[i]);
		log("numTb[i]" .. tostring(numTb[i]));
		if numImg then
			self:addChild(numImg);
			numImg:setPositionX(space*(maxNum - i));	
		end
	end
end

--单个图标button
SingleButton = class(TouchLayer);

function SingleButton:ctor()
	self.class = SingleButton;
	self.name = "root";
	self.muiscEnabled = true;
end
function SingleButton:dispose()
	self.displayObj:removeEventListener(DisplayEvents.kTouchBegin, self.onClick);
	self.displayObj:stopAllActions();
	SingleButton.superclass.dispose(self);
end
function SingleButton:initialize(displayObj,callBack,musicID)
	self.callBack = callBack;
	self.displayObj = displayObj;
	if musicID then
		self.musicID = musicID;
	elseif self.displayObj.name=="common_copy_close_button" or self.displayObj.name=="common_close_button" or self.displayObj.name=="close_button" or self.displayObj.name=="close_btn" then
        self.musicID = 8;
    else
    	self.musicID = 7;
    end
	self.displayObj:setAnchorPoint(ccp(0.5,0.5));
	self.displayObj:setPositionX(self.displayObj:getPositionX() + self.displayObj:getContentSize().width/2);
	self.displayObj:setPositionY(self.displayObj:getPositionY() - self.displayObj:getContentSize().height/2);
	-- self:addChild(displayObj);
	displayObj:addEventListener(DisplayEvents.kTouchBegin, self.onClick, self);
	
	local function playMusic()
		if GameData.isMusicOn and self.muiscEnabled then
			MusicUtils:playEffect(self.musicID,false);
		end
	end
	displayObj:addEventListener(DisplayEvents.kTouchBegin, playMusic);
end
function SingleButton:setMusicEnabled(bool)
	self.muiscEnabled = bool;
end
function SingleButton:onClick(event)
	
	self.displayObj:addEventListener(DisplayEvents.kTouchEnd, self.onEnd, self);
	-- self.displayObj:removeEventListener(DisplayEvents.kTouchBegin, self.onClick, self);
	
	-- self.displayObj:setScaleX(0.5);
	-- self.displayObj:setScaleY(0.5);
	-- self.displayObj:stopAllActions();
	-- print("scale:"..self.displayObj:getScale());

	-- function callBack2()
	-- 	function callBack3()
	-- 		self.displayObj:addEventListener(DisplayEvents.kTouchBegin, self.onClick, self);
	-- 	end;
	-- 	Tweenlite:scale(self.displayObj,0.5,self.displayObj:getScale() + 0.2,self.displayObj:getScale() + 0.2,
	-- 		255,callBack3,nil,EaseType.CCEaseElasticOut)
	-- 	if self.callBack then
	-- 		self.callBack(event);
	-- 	end;
	-- end;
	-- Tweenlite:scale(self.displayObj,0.05,self.displayObj:getScale() - 0.2,self.displayObj:getScale() - 0.2,
	-- 	255,callBack2,nil)
	self.displayObj:setScale(self.displayObj:getScale() - 0.1);
end
function SingleButton:onEnd(event)
	if self.displayObj.isDisposed then
		return;
	end
	self.displayObj:setScale(self.displayObj:getScale() + 0.1);
	if self.callBack then
		self.callBack(event);
	end
	self.displayObj:removeEventListener(DisplayEvents.kTouchEnd, self.onEnd, self);
end
function SingleButton:getHeight()
	return self.displayObj:getContentSize().height*self.displayObj:getScale();
end
function SingleButton:create(displayObj,callBack,musicID)
	local container = SingleButton.new();
	container:initLayer();
	container:initialize(displayObj,callBack,musicID);
	return container;
end


--设置英雄tabbar
--num  index
function setHeroTabBar(armature,num)
	local btnTb = {};
	local btn1 = SingleButton:create(armature.display:getChildByName("common_copy_shuXing_button"));
	local btn2 = SingleButton:create(armature.display:getChildByName("common_copy_jiNeng_button"));
	local btn3 = SingleButton:create(armature.display:getChildByName("common_copy_jinJie_button"));
	local btn4 = SingleButton:create(armature.display:getChildByName("common_copy_shengJi_button"));
	table.insert(btnTb,btn1);
	table.insert(btnTb,btn2);
	table.insert(btnTb,btn3);
	table.insert(btnTb,btn4);
	for i=1,4 do
		if num == i then
			btnTb[i].displayObj:setScale(1);
			btnTb[i]:setPositionX(190/2 - btnTb[i]:getContentSize().width/2)
		else
			btnTb[i].displayObj:setScale(0.8);
			btnTb[i]:setPositionX(190/2 - 0.8*btnTb[i]:getContentSize().width/2)
		end;
		if i ~= 1 then
			btnTb[i].displayObj:setPositionY(btnTb[i - 1].displayObj:getPositionY() - btnTb[i - 1]:getHeight());
		end;
	end
end;



-- 使用方法------
--	......
--	target = create();//textfield sprite layer 等等
--  target:addEventListener(DisplayEvents.kTouchTap,self.onShowTip,self);
--	......
--	function yourClass:onShowTip()
--		local text=analysis("Tishi_Guizemiaoshu",2,"txt"); 或者 自定义文本
--		TipsUtil:showTips(target,text,width=nil);
--	end
-- ------------
TipsUtil = {};

CommonTips = class(Layer);
function CommonTips:ctor(prLyer)
	if prLyer then
		self.mianLayer = prLyer;
	else
		self.mianLayer = sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP);
	end
	local tagPar = self.mianLayer:getParent();
	self.dPos = tagPar:convertToWorldSpace(self.mianLayer:getPosition());
end
function CommonTips:dispose()

end
function CommonTips:showTips()
	self.mianLayer:addChild(self);
end
function CommonTips:initTips(text,width,pos,dy)
	dy = dy and dy or 0;
	width = width and width or 0;
	local winSize = Director:sharedDirector():getWinSize()
	if	width > winSize.width-20 then width = winSize.width-20 end
	local text_data={x=0,y=0,width=width,height=0,size=26,alignment=0,color=0xe1d2a0};
	local tipTF = createTextFieldWithTextData(text_data,text);
	local tipTFSize = tipTF:getContentSize();
	if tipTFSize.width>winSize.width-60 then
		tipTFSize = makeSize(winSize.width-60,0);
		tipTF:setDimensions(tipTFSize);
		tipTFSize = tipTF:getContentSize();
	end
	self.tipsSize = makeSize(tipTFSize.width+40,tipTFSize.height+40);
	local bg = CommonSkeleton:getBoneTexture9DisplayBySize("commonBackgroundScalables/common_background_1",nil,self.tipsSize);
	pos = ccp(pos.x,pos.y-self.tipsSize.height-dy);
	if pos.x+self.tipsSize.width>winSize.width-10 then pos.x = winSize.width-10-self.tipsSize.width end;
	self:addChild(bg);
	bg:setPositionXY(pos.x+self.dPos.x,pos.y+self.dPos.y);
	self:addChild(tipTF);
	tipTF:setPositionXY(pos.x+20+self.dPos.x,pos.y+25+self.dPos.y);
end
function CommonTips:initBackGround(opacity)
  opacity = opacity or 10
  local backHalfAlphaLayer = LayerColorBackGround:getBackGround()
  backHalfAlphaLayer:setOpacity(opacity)
  backHalfAlphaLayer:setPositionXY(-GameData.uiOffsetX,-GameData.uiOffsetY);
  self:addChild(backHalfAlphaLayer)
  backHalfAlphaLayer:addEventListener(DisplayEvents.kTouchTap,self.onRemoveTips,self);
end

local tips;

function CommonTips:removeTip()
	if tips then
		tips:onRemoveTips();
		tips=nil;
	end
end

function CommonTips:onRemoveTips()
	self.mianLayer:removeChild(self);
end

function TipsUtil:showTips(tag,text,width,opacity,dy,prLyer)
	local tagPar = tag:getParent();
	if not tagPar then return end;
	local pos = tagPar:convertToWorldSpace(tag:getPosition());
	local ommonTips = CommonTips.new(prLyer);
	ommonTips:initLayer();
	ommonTips:setContentSize(makeSize(1,1));
	ommonTips:initBackGround(opacity);
	width = width and width or 0;
	ommonTips:initTips(text,width,pos,dy)
	ommonTips:showTips();

	CommonTips:removeTip();
	tips = ommonTips;
end

