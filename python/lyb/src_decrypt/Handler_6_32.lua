

Handler_6_32 = class(Command);

function Handler_6_32:execute()
	local heroBankMediator=self:retrieveMediator(HeroBankMediator.name);
	if nil~=heroBankMediator then
		  sharedTextAnimateReward():animateStartByString("分解成功！");
		  heroBankMediator:refreshFenjieHero();
	end
end


Handler_6_32.new():execute();