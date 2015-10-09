Handler_27_13 = class(Command);

function Handler_27_13:execute()
  print(".27.13.",recvTable["FamilyId"],recvTable["BooleanValue"]);
  uninitializeSmallLoading();
  if BangpaiMediator then
    local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
    if bangpaiMediator then
    	bangpaiMediator:getViewComponent():refreshFamilyApply(recvTable["FamilyId"],recvTable["BooleanValue"]);
    end
    -- if 1==recvTable["State"] then
    -- 	sharedTextAnimateReward():animateStartByString("加入家族成功~");
    -- else
    -- 	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_140));
    -- end
  end
end

Handler_27_13.new():execute();