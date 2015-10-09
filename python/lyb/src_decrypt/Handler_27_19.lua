Handler_27_19 = class(Command);

function Handler_27_19:execute()
  print(".27.19.",recvTable["ID"]);
  uninitializeSmallLoading();
  if BangpaiMediator then
    local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
    if bangpaiMediator then
      bangpaiMediator:getViewComponent():refreshHuoyuedulingjiang(recvTable["ID"]);
    end
   end
end

Handler_27_19.new():execute();