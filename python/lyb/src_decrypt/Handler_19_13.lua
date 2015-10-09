Handler_19_13 = class(Command);

function Handler_19_13:execute()
   uninitializeSmallLoading();

   if GuanzhiPopupMediator then
      local guanzhiPopupMediator=self:retrieveMediator(GuanzhiPopupMediator.name);
      if nil ~= guanzhiPopupMediator then 
         guanzhiPopupMediator:refresh(recvTable["IDCountArray"]);
      end
   end
end

Handler_19_13.new():execute();