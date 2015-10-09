ToRefreshReddotCommand=class(Command);

function ToRefreshReddotCommand:ctor()
	self.class=ToRefreshReddotCommand;
end

function ToRefreshReddotCommand:execute(notification)
	if notification == nil then
		return
	end
	
	-- 刷新指定的系统 常量不可变
	local functionID = notification.data.type
	local value = notification.data.value
	if functionID == FunctionConfig.FUNCTION_ID_5 then -- 邮箱
	    local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
	    if leftButtonGroupMediator then
	      leftButtonGroupMediator:refreshMail(value)
	  	else -- 战场中
			GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_5] = true
			GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_5] = false
	    end
	elseif functionID == FunctionConfig.FUNCTION_ID_10 then
		GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_10] = 1 == value and true or false;
	    local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
	    if leftButtonGroupMediator then
	      leftButtonGroupMediator:getViewComponent():refreshHaoyou()
	    end
	    if BuddyPopupMediator then
		    local buddyPopupMediator = self:retrieveMediator(BuddyPopupMediator.name)
		    if buddyPopupMediator then
		      buddyPopupMediator:getViewComponent():refreshReddot();
		    end
		end
	elseif functionID == FunctionConfig.FUNCTION_ID_12 then -- 琅琊令
	    local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
	    if leftButtonGroupMediator then
	      leftButtonGroupMediator:refreshLangyaling()
	    end
	elseif functionID == FunctionConfig.FUNCTION_ID_26 then --  论剑
	    local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
	    if hButtonGroupMediator then
	      hButtonGroupMediator:refreshLunjian()
	    end
	elseif functionID == FunctionConfig.FUNCTION_ID_33 then
	    local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
	    if hButtonGroupMediator then
	      hButtonGroupMediator:refreshShili()
	    end
	    if FactionMediator then
	    	local factionMediator = self:retrieveMediator(FactionMediator.name)
	    	if factionMediator then
		      factionMediator:getViewComponent():refreshXiaohongdian()
		    end
	    end
	elseif functionID == FunctionConfig.FUNCTION_ID_34 then
	    local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
	    if hButtonGroupMediator then
	      hButtonGroupMediator:refreshShili()
	    end		
	elseif functionID == FunctionConfig.FUNCTION_ID_35 then
	    local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
	    if hButtonGroupMediator then
	      hButtonGroupMediator:refreshShili()
	    end		
	elseif functionID == FunctionConfig.FUNCTION_ID_36 then
	    local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
	    if hButtonGroupMediator then
	      hButtonGroupMediator:refreshShilian()
	    end
	elseif functionID == 4 then

	end

end
