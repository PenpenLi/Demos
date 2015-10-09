Handler_24_4 = class(Command);
require "main.model.QianDaoProxy"
function Handler_24_4:execute()
   local qiandaoProxy=self:retrieveProxy(QianDaoProxy.name)
   print("--------------------------------------")
   print("+++++++++++++++++++++++++++++++++++++++++++", recvTable["BooleanValue"])
   qiandaoProxy:setData(recvTable["Month"],recvTable["Count"],recvTable["TotalCount"],recvTable["BooleanValue"])
   	if QianDaoMediator then
		local QianDaoMediator = self:retrieveMediator(QianDaoMediator.name);
		if QianDaoMediator then
			QianDaoMediator:refreshData();
		end
	end	
	if LeftButtonGroupMediator then
        local med=self:retrieveMediator(LeftButtonGroupMediator.name);
        if med then
            -- print("i love you")
            med:refreshQianDao();
        end
    end

end

Handler_24_4.new():execute();