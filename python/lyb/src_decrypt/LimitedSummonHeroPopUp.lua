LimitedSummonHeroPopUp=class(TouchLayer);

function LimitedSummonHeroPopUp:ctor()
  self.class=LimitedSummonHeroPopUp;
  self.const_rankRender_max = 8.5;
  self.cosnt_tableId = 49;--活动表-营运活动.xls,限时招募英魂活动id49

  self.cards={};--限时招募英魂活动奖励卡牌
  self.cardsIds={};
  self.page_panels={};
  self.const_column=1;
  self.const_row=1;
  self.const_num=self.const_column*self.const_row;
  self.page_num=1;
  self.currentPage = 1;
end

function LimitedSummonHeroPopUp:dispose()
  	self:removeAllEventListeners();
	self:removeChildren();
  	LimitedSummonHeroPopUp.superclass.dispose(self);

  	self:disposeTime();
end

function LimitedSummonHeroPopUp:initializeUI(skeleton, activityProxy, userCurrencyProxy,bagProxy,summonHeroProxy,heroBankProxy,userProxy)
  	self:initLayer();

	self.skeleton=skeleton;
	self.activityProxy=activityProxy;
	self.userCurrencyProxy = userCurrencyProxy;
	self.bagProxy = bagProxy;
	self.summonHeroProxy = summonHeroProxy;
	self.heroBankProxy = heroBankProxy;
	self.userProxy = userProxy;

	local armature=skeleton:buildArmature("limitedSummonHero_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature=armature.display;
	self.armatureDefault=armature;
	self:addChild(self.armature);

	AddUIBackGround(self,StaticArtsConfig.SUMMON_HERO);
  	
  	local text=analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_276,"constant").."元宝";
	local text_data=armature:getBone("text_type2cost").textData;
	self.text_type2cost=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_type2cost);

	local text="00:00:00后 免费"
	local text_data=armature:getBone("text_type1cdTime").textData;
	self.text_type1cdTime=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_type1cdTime);

	local text="我的英雄币："
	local text_data=armature:getBone("text_myHeroMoney").textData;
	self.text_myHeroMoney=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_myHeroMoney);

	local text="我的排名："
	local text_data=armature:getBone("text_myGold").textData;
	self.text_myGold=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_myGold);

	local text="我的排名："
	local text_data=armature:getBone("text_myRank").textData;
	self.text_myRank=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_myRank);

	local text="";
	local text_data=armature:getBone("text_lastTime").textData;
	self.text_lastTime=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_lastTime);


	local text="活动倒计时"
	local text_data=armature:getBone("text_label_lastTime").textData;
	self.text_label_lastTime=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_label_lastTime);

	--读表时间
	local vo = analysis("Huodongbiao_Yunyinghuodong",self.cosnt_tableId);
	local text="活动时间:"..vo.opentime.."-"..vo.closetime;
	local text_data=armature:getBone("text_time ").textData;
	self.text_time =createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_time );
	--print(os.date("%x",1404094567))
	--后台返回时间
	local str = os.date("%x",self.activityProxy.limitedSummonHeroBeginTime).." 至 "..os.date("%x",self.activityProxy.limitedSummonHeroEndTime);
	self.text_time:setString(str);

	local text="活动时间";
	local text_data=armature:getBone("text_label_time").textData;
	self.text_label_time=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_label_time);

	local text="活动说明";
	local text_data=armature:getBone("text_instruction_title").textData;
	self.text_instruction_title=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_instruction_title);
	self.text_instruction_title:setVisible(false);

	local text="1.每次招募都可以获得英雄币，英雄币数量相同时获得时间越早排名越靠前，活动结束后会根据英雄币排名进行发奖。\n2.本活动中每次招募同样可以获得招募积分，该积分可以在“积分商城”中兑换道具。\n3.活动时间内获得积分达到100，可在活动结束发奖时获得488888银两奖励。";
	local text_data=armature:getBone("text_instruction").textData;
	self.text_instruction=createTextFieldWithTextData(text_data,text);
	self.armature:addChild(self.text_instruction);
	self.text_instruction:setVisible(false);

	self.instruction_bg = self.armature:getChildByName("instruction_bg");
	self.instruction_bg:setVisible(false);

  	--活动表-营运奖励
	local text = self.activityProxy:getLimitedSummonHeroPrizeContent();
	--print("===JJJJ===:",text);

	local text_data=armature:getBone("text_prizeInfo").textData;
	self.text_prizeInfo=createRichMultiColoredLabelWithTextData(text_data,text);
	self.text_prizeInfo:setPositionXY(981,260);--这个宽度不统一，由表定长度写死
	self.armature:addChild(self.text_prizeInfo);


	self.img_text_title = self.armature:getChildByName("img_text_title");

	--common_copy_bluelonground_button_1
	self.common_copy_bluelonground_button_1=self.armature:getChildByName("common_copy_bluelonground_button_1");
	self.common_copy_bluelonground_button_1_pos=convertBone2LB4Button(self.common_copy_bluelonground_button_1);
	textData=armature:findChildArmature("common_copy_bluelonground_button_1"):getBone("common_copy_bluelonground_button").textData;
	self.armature:removeChild(self.common_copy_bluelonground_button_1);

	self.common_copy_bluelonground_button_1=CommonButton.new();
	self.common_copy_bluelonground_button_1:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	self.common_copy_bluelonground_button_1:initializeText(textData,"免费");
	self.common_copy_bluelonground_button_1:setPosition(self.common_copy_bluelonground_button_1_pos);
	self.common_copy_bluelonground_button_1:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
	self.armature:addChild(self.common_copy_bluelonground_button_1);

  	--common_copy_bluelonground_button_2
	self.common_copy_bluelonground_button_2=self.armature:getChildByName("common_copy_bluelonground_button_2");
	self.common_copy_bluelonground_button_2_pos=convertBone2LB4Button(self.common_copy_bluelonground_button_2);
	textData=armature:findChildArmature("common_copy_bluelonground_button_2"):getBone("common_copy_bluelonground_button").textData;
	self.armature:removeChild(self.common_copy_bluelonground_button_2);

	self.common_copy_bluelonground_button_2=CommonButton.new();
	self.common_copy_bluelonground_button_2:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
	self.common_copy_bluelonground_button_2:initializeText(textData,"元宝招募");
	self.common_copy_bluelonground_button_2:setPosition(self.common_copy_bluelonground_button_2_pos);
	self.common_copy_bluelonground_button_2:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self);
	self.armature:addChild(self.common_copy_bluelonground_button_2);
 	
 	--common_copy_real_greenlongroundbutton
 	self.common_copy_real_greenlongroundbutton=self.armature:getChildByName("common_copy_real_greenlongroundbutton");
	self.common_copy_real_greenlongroundbutton_pos=convertBone2LB4Button(self.common_copy_real_greenlongroundbutton);
	textData=armature:findChildArmature("common_copy_real_greenlongroundbutton"):getBone("common_copy_real_greenlongroundbutton").textData;
	self.armature:removeChild(self.common_copy_real_greenlongroundbutton);

	self.common_copy_real_greenlongroundbutton=CommonButton.new();
	self.common_copy_real_greenlongroundbutton:initialize("common_real_greenlongroundbutton_normal","common_real_greenlongroundbutton_down",CommonButtonTouchable.BUTTON);
	self.common_copy_real_greenlongroundbutton:initializeText(textData,"我要充值");
	self.common_copy_real_greenlongroundbutton:setPosition(self.common_copy_real_greenlongroundbutton_pos);
	self.common_copy_real_greenlongroundbutton:addEventListener(DisplayEvents.kTouchTap,self.onRecharge,self);
	self.armature:addChild(self.common_copy_real_greenlongroundbutton);

	--open_button
	self.open_button=Button.new(armature:findChildArmature("open_button"),false);
	self.open_button:addEventListener(Events.kStart,self.onShowHelp,self);
	
	local button=Button.new(armature:findChildArmature("common_copy_left_button"),false);
  	button:addEventListener(Events.kStart,self.onLeftButtonTap,self);
  	self.leftButton=button;

  	button=Button.new(armature:findChildArmature("common_copy_right_button"),false);
  	button:addEventListener(Events.kStart,self.onRightButtonTap,self);
  	self.rightButton=button;

	--closeButton
	local closeButton=self.armature:getChildByName("common_copy_close_button");
	local closeButton_pos = convertBone2LB4Button(closeButton);
	self.armature:removeChild(closeButton);
	closeButton=CommonButton.new();
	closeButton:initialize("common_close_button_normal","common_close_button_down",CommonButtonTouchable.BUTTON);
	closeButton:setPosition(closeButton_pos);
	closeButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
	self.armature:addChild(closeButton);
	self.closeButton=closeButton;


	--(218,35)   (280-242)
	local render1=self.armature:getChildByName("render1");
	self.render1Size=render1:getContentSize();
	self.render1_pos=convertBone2LB(render1);
	self.armature:removeChild(render1);


  	self.cardsIds = StringUtils:lua_string_split(vo.neirong,",");
  
  	self.page_num=math.ceil(#self.cardsIds/self.const_num);

  	local function onFlipPageComplete()
    	self.currentPage = self.scrollView:getCurrentPage()
    	--self:flipPage(self.scrollView:getCurrentPage());
  	end

	local common_copy_grid_pos=self.armature:getChildByName("pos_cardPrize"):getPosition();
	self.grid_skew_x= 182+20;
	self.grid_skew_y= 248+20;
	self.pos_cardPrize = common_copy_grid_pos;

	--翻页
	self.scrollView=GalleryViewLayer.new();
	self.scrollView:initLayer();
	self.scrollView:setContainerSize(makeSize(self.grid_skew_x*self.const_column*self.page_num,self.grid_skew_y*self.const_row));
	self.scrollView:setViewSize(makeSize(self.grid_skew_x*self.const_column,self.grid_skew_y*self.const_row));
	self.scrollView:setMaxPage(self.page_num);
	self.scrollView:setDirection(kCCScrollViewDirectionHorizontal);
	self.scrollView:setPositionXY(common_copy_grid_pos.x,common_copy_grid_pos.y-self.grid_skew_y*(-1+self.const_row));--common_copy_grid_pos.y-self.grid_skew_y*(-1+self.const_row));


	self.scrollView:addFlipPageCompleteHandler(onFlipPageComplete);
	self:addChild(self.scrollView);


	local a=0;
	while self.page_num>a do
		a=1+a;
		local grid_layer=Layer.new();
		grid_layer:initLayer();
		grid_layer:setContentSize(makeSize(self.grid_skew_x*self.const_column,self.grid_skew_y*self.const_row));
		grid_layer:setPositionXY(self.grid_skew_x*self.const_column*(-1+a),0);
		self.scrollView:addContent(grid_layer);
		table.insert(self.page_panels,grid_layer);
	end

	self:refreshCardPrize();

	self.tipLayer=Layer.new();
	self.tipLayer:initLayer();
	self:addChild(self.tipLayer);
	self.tipLayer:addChild(self.instruction_bg);
	self.tipLayer:addChild(self.text_instruction);
	self.tipLayer:addChild(self.text_instruction_title);
	self.tipLayer:addEventListener(DisplayEvents.kTouchTap,self.onHideHelp,self);
	
end


function LimitedSummonHeroPopUp:getPanelByPlace(place)
  return self.page_panels[1+math.floor((place-1)/self.const_num)];
end

function LimitedSummonHeroPopUp:flipPageCallback()
  print("flipPageCallback...............")
  for i=1,self.const_page_count do
    self.pageButton[i]:select(false);
  end
  self.pageButton[self:getPageSelect()]:select(true);
end

--页
function LimitedSummonHeroPopUp:getPageSelect()
    if self.scrollView then
      return self.scrollView:getCurrentPage();
    end
    return 1;
end


function LimitedSummonHeroPopUp:onLeftButtonTap(event)
	print("left");
	self.scrollView:setPage(-1+self.scrollView:getCurrentPage(),true);
end

function LimitedSummonHeroPopUp:onRightButtonTap(event)
	print("right");
	self.scrollView:setPage(1+self.scrollView:getCurrentPage(),true);
end

function LimitedSummonHeroPopUp:refreshCardPrize()
  print("============================bank===============================04")
  require "main.view.summonHero.ui.DrawCard";

  for i,v in ipairs(self.cards) do
    if v.parent then
      v.parent:removeChild(v)
    end
  end

  for i=1,#self.cardsIds do
    --print("chhy1>>>:",#self.cardsIds);
    local render=DrawCard.new();
    render:initializeUI(self.summonHeroProxy:getSkeleton(),self.cardsIds[i]);
    local pos_x,pos_y=0,0;--self.pos_cardPrize.x,self.pos_cardPrize.y;
    render:setPositionXY(pos_x+ConstConfig.CONST_GRID_ITEM_SKEW_X,pos_y+ConstConfig.CONST_GRID_ITEM_SKEW_Y);
    self.page_panels[i]:addChild(render);
    table.insert(self.cards,render);
  end


end



function LimitedSummonHeroPopUp:setData()
  
end

function LimitedSummonHeroPopUp:refresh()
	self.limitedSummonHeroData={Count=0,Ranking=0,ActivityEmployScore=0,ActivityEmployRankingArray={},GeneralEmployInfoArray={}};
	self.lastLimitedSummonHeroType = 1;
	
	local Ranking = (self.activityProxy.limitedSummonHeroData.Ranking==0 and "100名以外") or self.activityProxy.limitedSummonHeroData.Ranking;
	self.text_myRank:setString("我的排名："..Ranking);

	self.text_myHeroMoney:setString("我的英雄币："..self.activityProxy.limitedSummonHeroData.ActivityEmployScore);

	self.text_myGold:setString("我的元宝："..self.userCurrencyProxy.gold);
	
	self:refreshRank();
end

function LimitedSummonHeroPopUp:refreshRank()
  	--scroll
  	self.listScrollViewLayer=ListScrollViewLayer.new();
  	self.listScrollViewLayer:initLayer();
  	self.listScrollViewLayer:setPosition(self.render1_pos);
  	self.listScrollViewLayer:setViewSize(makeSize(self.render1Size.width,
                                  self.render1Size.height*self.const_rankRender_max));
  	self.listScrollViewLayer:setItemSize(self.render1Size);
  	self.listScrollViewLayer:setDirection(1);
  	self.armature:addChild(self.listScrollViewLayer);
  
  	local a=self.activityProxy.limitedSummonHeroData.ActivityEmployRankingArray;
  	require "main.view.activity.ui.limitedSummonHero.RankRender"
  	
  	for k,v in pairs(a) do
 
    	local item=RankRender.new();
    	item:initializeUI(self.skeleton,a,k);
    	self.listScrollViewLayer:addItem(item);
  	end

  	local function funRefreshTime()
  		local remainSecond1 = self.activityProxy.remainSeconds-(os.time()-self.activityProxy.osTime);
  		--print("HHHHHHHHH:",self.activityProxy.remainSeconds,self.activityProxy.osTime,os.time())
    	local remainSecond2 = self.activityProxy.limitedSummonHeroData.cdTime-(os.time()-self.activityProxy.limitedSummonHeroData.osTime);

  		if remainSecond1 > 0 then
    		local timeStr = getTimeFormat1String(remainSecond1);
      		self.text_lastTime:setString(timeStr);
    	else
    		self.text_lastTime:setString("活动结束");
 		end

 		if remainSecond2 > 0 then
    		local timeStr = getTimeFormat1String(remainSecond2)
      		self.text_type1cdTime:setString(timeStr.." 后免费");
    	else
    		self.text_type1cdTime:setString("免费");
 		end
  	end

  	if self.activityProxy.isOpenLimitedSummonHero then
    	self:disposeTime();
    	self.refreshTimeId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(funRefreshTime, 1, false);
  	end


end

function LimitedSummonHeroPopUp:disposeTime()
  if self.refreshTimeId~=nil then
    CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.refreshTimeId);
    self.refreshTimeId = nil;
  end
end


function LimitedSummonHeroPopUp:onButtonTap(event)
	if event.target==self.common_copy_bluelonground_button_1 then
		if self.summonHeroProxy:isHeroFull(self.heroBankProxy,self.userProxy,1,self) then
    		return;
  		end

		local remainSecond2 = self.activityProxy.limitedSummonHeroData.cdTime-(os.time()-self.activityProxy.limitedSummonHeroData.osTime);
		if remainSecond2<=0 then
			self.summonHeroProxy.previousSendMessageType = 5;
			local msg = {Place=1,Count=1};
        	sendMessage(6,34,msg);
        	self:playEffect();
		else
			sharedTextAnimateReward():animateStartByString("时间未到!");
		end
	elseif event.target==self.common_copy_bluelonground_button_2 then

  		require "main.view.summonHero.ui.OneOrTenDraw"
	  	self.oneOrTenDraw = OneOrTenDraw.new();
	  	self.oneOrTenDraw:initializeUI(self.summonHeroProxy:getSkeleton(),self.summonHeroProxy,self.userCurrencyProxy,true,self.activityProxy,self.heroBankProxy,self.userProxy);
	  	self:addChild(self.oneOrTenDraw);

	end
end


function LimitedSummonHeroPopUp:drawResult()
	local resultArr =self.activityProxy.limitedSummonHeroData.GeneralEmployInfoArray;
	if #resultArr==1 then
		self:PopUpDrawOneResult();
	else
		self:PopUpDrawTenResult();
	end

	if self.oneOrTenDraw~=nil then
    	self.oneOrTenDraw:refresh();
  	end
end


function LimitedSummonHeroPopUp:PopUpDrawOneResult()
	require "main.view.summonHero.ui.DrawOneResult";
	if self.drawOneResult==nil then
		self.drawOneResult = DrawOneResult.new();
		self.drawOneResult:initializeUI(self.summonHeroProxy:getSkeleton(),self.summonHeroProxy,self.userCurrencyProxy,self.bagProxy,true,self.activityProxy,self.heroBankProxy,self.userProxy);
	end
	self:addChild(self.drawOneResult);
end

function LimitedSummonHeroPopUp:removeDrawOneResult()
  self:removeChild(self.drawOneResult);
  self.drawOneResult = nil;
end

function LimitedSummonHeroPopUp:PopUpDrawTenResult()
	require "main.view.summonHero.ui.DrawTenResult";
	if self.drawTenResult==nil then
		self.drawTenResult = DrawTenResult.new();
		self.drawTenResult:initializeUI(self.summonHeroProxy:getSkeleton(),self.summonHeroProxy,self.userCurrencyProxy,self.bagProxy,true,self.activityProxy,self.heroBankProxy,self.userProxy);
	end
	self:addChild(self.drawTenResult);
  
end

function LimitedSummonHeroPopUp:removeDrawTenResult()
	self:removeChild(self.drawTenResult);
	self.drawTenResult=nil;
end

function LimitedSummonHeroPopUp:removeOneOrTenDraw()
	self:removeChild(self.oneOrTenDraw,false);
end

function LimitedSummonHeroPopUp:onRecharge()
	print("oooK2");
	self:dispatchEvent(Event.new("OPEN_RECHARGE_UI",nil,self));
 	
end

function LimitedSummonHeroPopUp:queryHero()
  self:dispatchEvent(Event.new("QUERY_HERO",nil,self));
end

function LimitedSummonHeroPopUp:onShowHelp()
	self.text_instruction_title:setVisible(true);
	self.text_instruction:setVisible(true);
	self.instruction_bg:setVisible(true);
end

function LimitedSummonHeroPopUp:onHideHelp()
	self.text_instruction_title:setVisible(false);
	self.text_instruction:setVisible(false);
	self.instruction_bg:setVisible(false);
end

function LimitedSummonHeroPopUp:playEffect()
  local effectIcon1
  local effectIcon2
  local layer=sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS);
  if layer then
    function cf()
      effectIcon1.parent:removeChild(effectIcon1);
      effectIcon2.parent:removeChild(effectIcon2);
      effectIcon1 = nil;
      effectIcon2 = nil;
    end
    effectIcon1=cartoonPlayer("183",GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2,1,cf,2);
    effectIcon2=cartoonPlayer("184",GameConfig.STAGE_WIDTH/2, GameConfig.STAGE_HEIGHT/2,1,cf,4);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(effectIcon1);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(effectIcon2);
  end
end


function LimitedSummonHeroPopUp:remove()
  
end

function LimitedSummonHeroPopUp:onCloseButtonTap()
	self:dispatchEvent(Event.new("LimitedSummonHero_CLOSE",nil,self));
end

function LimitedSummonHeroPopUp:jumpToDecomposeHero()
	self:dispatchEvent(Event.new("JUMP_TO_HERO_BANK",nil,self));
end
