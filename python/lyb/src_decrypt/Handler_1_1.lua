require "core.controls.CommonPopup"
require "main.view.langyaling.LangyalingMediator";

--错误信息
Handler_1_1 = class(Command);

function Handler_1_1:execute()
    uninitializeSmallLoading()
	local errorCode = recvTable["ErrorCode"];
	print("ErrorCode:",errorCode);
	local errorMessage = analysis("Tishi_Cuowuma",errorCode,"desc1")
	if errorMessage == nil  or errorMessage == "" then
		return
	end
	
    sharedTextAnimateReward():animateStartByString(errorMessage);
    
    local langyalingMediator = self:retrieveMediator(LangyalingMediator.name)
    if langyalingMediator then
		langyalingMediator:setIsPopupLayer()
    end

    if StrengthenProxy then
        local strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
        strengthenProxy.Qianghua_Bool = nil;
        strengthenProxy.Dazao_Bool = nil;
        strengthenProxy.Xi_Lian = nil;
    end

    if HeroHouseProxy then
        local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
        heroHouseProxy.Jinengshengji_Bool = nil;
        heroHouseProxy.Shengji_Bool = nil;

        heroHouseProxy.Shengxing_Bool = nil;
        heroHouseProxy.Jinjie_Bool = nil;

        heroHouseProxy.Yuanfen_Jinjie_Bool = nil;
    end
end

Handler_1_1.new():execute();