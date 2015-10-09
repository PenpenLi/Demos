
Handler_3_45 = class(MacroCommand);

function Handler_3_45:execute()

	local userProxy = self:retrieveProxy(UserProxy.name)
	if not userProxy.zodiacIdForMsg then
		return;
	end
	local  ID = userProxy.zodiacIdForMsg;
	userProxy.zodiacId = ID;
	print("userProxy.zodiacId", userProxy.zodiacId)

	local tianxiangPo = analysis("Zhujiao_Tianxiangshouhudian",ID)
	local tianxiangPos = analysisByName("Zhujiao_Tianxiangshouhudian", "group", tianxiangPo.group);
  	table.insert(userProxy.tianXiangIds, ID);


  	local bool = false;
	local isLast = true;
	for k, v in pairs(tianxiangPos) do
	  if v.id <= ID then

	  else
	    isLast = false;
	  end
	end
	if isLast and analysisHas("Zhujiao_Tianxiangshouhudian",tianxiangPo.id2) then
		table.insert(userProxy.tianXiangZuIds, tianxiangPo.group + 1);
		bool = true
	else
		bool = false
	end


	if TianXiangMediator then
		local tianXiangMediator=self:retrieveMediator(TianXiangMediator.name);
		if tianXiangMediator then
			tianXiangMediator:refreshData(bool);
		end
	end


end

Handler_3_45.new():execute();