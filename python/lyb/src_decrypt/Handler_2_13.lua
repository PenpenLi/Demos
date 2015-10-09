
Handler_2_13 = class(MacroCommand);

function Handler_2_13:execute()
	setCurrencyGroupVisible(true);
	removeMaskLayer()
	if QianDaoProxy ~= nil then
		local qiandaoProxy = self:retrieveProxy(QianDaoProxy.name);
		if qiandaoProxy ~= nil and qiandaoProxy.yijinglingqu == 0 and GameVar.tutorStage == TutorConfig.STAGE_99999 then
			self:addSubCommand(OpenQianDaoUICommand)
		end
	end
	self:complete();
	
end

Handler_2_13.new():execute();