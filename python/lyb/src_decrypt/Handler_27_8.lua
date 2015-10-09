Handler_27_8 = class(Command);

function Handler_27_8:execute()
	uninitializeSmallLoading();
	if BangpaiMediator then
		local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
		  if bangpaiMediator then
		  	bangpaiMediator:onClose();
		  end
	end
end

Handler_27_8.new():execute();