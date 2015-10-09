Handler_27_14 = class(Command);

function Handler_27_14:execute()
  print(".27.14.",recvTable["FamilyLogArray"]);
  uninitializeSmallLoading();
  
  if BangpaiMediator then
    local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
    if bangpaiMediator then
    	bangpaiMediator:getViewComponent():refreshFamilyLogArray(recvTable["FamilyLogArray"]);
    end
    -- if 1==recvTable["State"] then
    -- 	sharedTextAnimateReward():animateStartByString("加入家族成功~");
    -- else
    -- 	sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_140));
    -- end
  end
end

Handler_27_14.new():execute();