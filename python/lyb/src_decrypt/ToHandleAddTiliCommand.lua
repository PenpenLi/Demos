
ToHandleAddTiliCommand=class(Command);

function ToHandleAddTiliCommand:ctor()
	self.class=ToHandleAddTiliCommand;
end

function ToHandleAddTiliCommand:execute(data)
  self.userCurrencyProxy=self:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.countControlProxy=self:retrieveProxy(CountControlProxy.name);
  self:onAddTili(data);
end


function ToHandleAddTiliCommand:onAddTili(data)
	local placeTable = self.bagProxy:getPlaceDataByItemID(1005001);
	local place;
	for k,v in pairs(placeTable) do
		if 0<v.Count then
			place=v.Place;
			break;
		end
	end

	local remainCount = self.countControlProxy:getRemainCountByID(CountControlConfig.AddTili);
	local curItemCount = self.bagProxy:getItemNum(1005001)
	print("====================place", place);
	print("====================remainCount", remainCount);
    local shopPos = analysisByName("Shangdian_Shangdianwupin", "itemid", 1005001)
    local shopItemPo;
    for k,v in pairs(shopPos) do
    	if v.type == 3 then
    		shopItemPo = v
    	end
    end
    print("====================shopItemPo.id", shopItemPo.id);
    --非VIP
	if self.userProxy:getVipLevel() == 0 then  		
		if curItemCount > 0 and remainCount > 0 then--有体力药有次数
		    local function confirmBack()
		    	local data={Place=place,ItemId=1005001,Count=1,CurrencyType=0};
		    	sendMessage(9,4,data)
		    	self:onHandleTutor();
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_500),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_500),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		elseif curItemCount == 0  and remainCount > 0 then--无体力药有次数
		    local function confirmBack()
		    	if self.userCurrencyProxy.gold >= shopItemPo.price then
			    	local data={ID=shopItemPo.id};
			    	sendMessage(9,15,data)
					self:onHandleTutor()
			    else
					self:onHandleTutor()
	    	        sharedTextAnimateReward():animateStartByString("元宝不足");
					MainSceneToVipCommand.new():execute()
			    end
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_501),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_501),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		elseif curItemCount > 0  and remainCount == 0 then--有体力药无次数
		    local function confirmBack()
    	        sharedTextAnimateReward():animateStartByString("升级vip可增加次数");
				MainSceneToVipCommand.new():execute()
				self:onHandleTutor();
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_502),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_502),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		else--无体力药无次数
		    local function confirmBack()
    	        sharedTextAnimateReward():animateStartByString("升级vip可增加次数");
				MainSceneToVipCommand.new():execute()
				self:onHandleTutor()
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_506),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_506),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		end
	else
		if curItemCount > 0 and remainCount > 0 then--有体力药有次数
		    local function confirmBack()
		    	local data={Place=place,ItemId=1005001,Count=1,CurrencyType=0};
		    	sendMessage(9,4,data)
				self:onHandleTutor()
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_503,{remainCount}),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_503),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		elseif curItemCount == 0  and remainCount > 0 then--无体力药有次数
		    local function confirmBack()
		    	if self.userCurrencyProxy.gold >= shopItemPo.id then
			    	local data={ID=shopItemPo.id};
			    	sendMessage(9,15,data)
					self:onHandleTutor();
			    else
	    	        sharedTextAnimateReward():animateStartByString("元宝不足");
					MainSceneToVipCommand.new():execute()
					self:onHandleTutor();
			    end
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_504),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_504),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		elseif curItemCount > 0  and remainCount == 0 then--有体力药无次数
		    local function confirmBack()
    	        sharedTextAnimateReward():animateStartByString("升级vip可增加次数");
				MainSceneToVipCommand.new():execute()
				self:onHandleTutor();
		    end
		    local commonPopup=CommonPopup.new();
		    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_505),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_505),nil,true, true);
		    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
		else--无体力药无次数

			if data.type == 1 then
			    local function confirmBack()
			    	self:onHandleTutor();
	    	        sharedTextAnimateReward():animateStartByString("升级vip可增加次数");
					MainSceneToVipCommand.new():execute()
			    end
			    local commonPopup=CommonPopup.new();
			    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_506),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_506),nil,true, true);
			    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
			else
		        local function confirmBack()
					 self:onHandleTutor();
		             sharedTextAnimateReward():animateStartByString("升级vip可增加次数");
		       		 MainSceneToVipCommand.new():execute()
		        end
		        local commonPopup=CommonPopup.new();
		        commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_511),self,confirmBack,nil,nil,nil,true,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_511),nil,true, true);
		        sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_CURRENCY):addChild(commonPopup);
			end
		end
	end
end
function ToHandleAddTiliCommand:onHandleTutor()
	if GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
   		sendServerTutorMsg({})
   		closeTutorUI();
    end
end