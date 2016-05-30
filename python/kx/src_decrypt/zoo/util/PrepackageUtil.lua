PrepackageUtil = {}
PrepackageNetWorkDialogState =  table.const{
	NEXT_SHOW = 0,
	ONLY_NEXT_NO_SHOW = 1,
	NEVER_SHOW = 2
}
-------设置预装包所需的值
function PrepackageUtil:setPrePackageValue()
	---------pre package-------------------------------------------------------
	_G.noMoreTipsForPrePackageNetWork = false
	_G.isPrePackageNoNetworkMode = false
	_G.isPrePackageCannotShowUpdatePanel = false
	---------end----------------------------------------------------------------
	local function safeReadConfig()
	    _G.isPrePackage = StartupConfig:getInstance():getIsPrePackage()
	end
	pcall(safeReadConfig)
	 ----------------------------------------------------------------------------------pre package setting
	if _G.isPrePackage then
	    PrepackageUtil:readFromLocal()
	end
end

-----检查是否需要弹出预装包联网提示
function PrepackageUtil:prePackageCheck(callback)
	--防破解
	if __ANDROID and HeGame then
    	HeGame:setValid(true)
    end

	PrepackageUtil:setPrePackageValue()
	
	if _G.isPrePackage and not _G.noMoreTipsForPrePackageNetWork then
       PrepackageUtil:showBeforeLoadingDialog(callback)
    else
        callback()
    end

end

function PrepackageUtil:readFromLocal()
	local dialogState = CCUserDefault:sharedUserDefault():getIntegerForKey("PrepackageNetWorkDialogState")
	if dialogState == PrepackageNetWorkDialogState.ONLY_NEXT_NO_SHOW then
		 CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", PrepackageNetWorkDialogState.NEXT_SHOW)
	end
	_G.noMoreTipsForPrePackageNetWork = dialogState > 0
	_G.isPrePackageNoNetworkMode = not CCUserDefault:sharedUserDefault():getBoolForKey("isPrePackageNetworkOpen")
	if __ANDROID then 
		local prepackageUtil = luajava.bindClass("com.happyelements.android.utils.PrepackageUtils")
		if prepackageUtil then
			prepackageUtil:getInstance():setPrePackageNoNetworkMode(_G.isPrePackageNoNetworkMode)
		end
	end
	print("G.noMoreTipsForPrePackageNetWork = ", _G.noMoreTipsForPrePackageNetWork)
	print("G.isPrePackageNoNetworkMode = ", _G.isPrePackageNoNetworkMode)
	print("----------------------------------------------------------------------------")
	--进入游戏次数
	local enterGameTime = CCUserDefault:sharedUserDefault():getIntegerForKey("game.userdef.enterGameTime")
	if enterGameTime < 3 then
		enterGameTime = enterGameTime + 1
		CCUserDefault:sharedUserDefault():setIntegerForKey("game.userdef.enterGameTime", enterGameTime)
		_G.isPrePackageCannotShowUpdatePanel = true
	end
end

function PrepackageUtil:showBeforeLoadingDialog(callback)
	local prepackageUtil
	local onButton1Click = function(isSaveOption)
		if isSaveOption then
			CCUserDefault:sharedUserDefault():setBoolForKey("isPrePackageNetworkOpen", true)
			local value = PrepackageNetWorkDialogState.NEVER_SHOW
			CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", value)
			if prepackageUtil then
				prepackageUtil:getInstance():setPrePackageNoNetworkMode(false)
			end
		end
		_G.isPrePackageNoNetworkMode = false
		callback()
	end

	local onButton2Click = function(isSaveOption) 
		CCUserDefault:sharedUserDefault():setBoolForKey("isPrePackageNetworkOpen", false)
		local value = isSaveOption and PrepackageNetWorkDialogState.NEVER_SHOW or PrepackageNetWorkDialogState.NEXT_SHOW
		CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", value)
		_G.isPrePackageNoNetworkMode = true
		if prepackageUtil then
			prepackageUtil:getInstance():setPrePackageNoNetworkMode(true)
		end
		callback()
	end


	if __ANDROID then 
		prepackageUtil = luajava.bindClass("com.happyelements.android.utils.PrepackageUtils")
		CommonAlertUtil:showPrePackageNetWorkAlertPanel(onButton1Click,  onButton2Click);
	else
		callback()
	end
end

function PrepackageUtil:showSettingNetWorkDialog()
	local onButton1Click = function(isSaveOption)
		local prepackageUtil = luajava.bindClass("com.happyelements.android.utils.PrepackageUtils")
		if isSaveOption then
			CCUserDefault:sharedUserDefault():setBoolForKey("isPrePackageNetworkOpen", true)
			local value =  PrepackageNetWorkDialogState.NEVER_SHOW
			CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", value)
			if prepackageUtil then
				prepackageUtil:getInstance():setPrePackageNoNetworkMode(false)
			end
			PrepackageUtil:restart()
		else
			CCUserDefault:sharedUserDefault():setBoolForKey("isPrePackageNetworkOpen", false)
			CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", PrepackageNetWorkDialogState.NEXT_SHOW)
			if prepackageUtil then
				prepackageUtil:getInstance():setPrePackageNoNetworkMode(true)
			end
			_G.isPrePackageNoNetworkMode = false
		end

	end

	local onButton2Click = function(isSaveOption) 
		CCUserDefault:sharedUserDefault():setBoolForKey("isPrePackageNetworkOpen", false)
		local value = isSaveOption and PrepackageNetWorkDialogState.NEVER_SHOW or PrepackageNetWorkDialogState.NEXT_SHOW
		CCUserDefault:sharedUserDefault():setIntegerForKey("PrepackageNetWorkDialogState", value)
	end
	CommonAlertUtil:showPrePackageNetWorkAlertPanel(onButton1Click,  onButton2Click, true);
end

function PrepackageUtil:showInGameDialog(yescallback) ---实际是commontip
	local text = {
			tip = Localization:getInstance():getText("pre.tips.network.3"),
			yes = Localization:getInstance():getText("give.back.panel.button.notification"),
			no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
		}
	local _yescallback = yescallback or nil 
	CommonTipWithBtn:showTip(text, "positive", _yescallback, nil, nil, true);

end

function PrepackageUtil:restart()
	local applicationHelper =  luajava.bindClass("com.happyelements.android.ApplicationHelper")
	applicationHelper:restart();
end

function PrepackageUtil:isPreNoNetWork()
	return _G.isPrePackage and _G.isPrePackageNoNetworkMode
	-- return true
end

local isShowDialogByLevelUp = false
function PrepackageUtil:ChangeIsShowNetworkDialog(newLevel)
	if not newLevel then return end
	if newLevel / 10 > 3 and newLevel % 10 == 1 then
		isShowDialogByLevelUp = true
	end
end

function PrepackageUtil:LevelUpShowTipToNetWork()
	if PrepackageUtil:isPreNoNetWork() and isShowDialogByLevelUp then
		-- PrepackageUtil:showInGameDialog()
		PrepackageUtil:showSettingNetWorkDialog()
		isShowDialogByLevelUp = false
	end
end

--检测是否是短代支付（预装包需求）
function PrepackageUtil:checkIsSMSPayment(paymentType)
    if paymentType and paymentType~=kUnsupport then
        for k,v in pairs(PlatformPaymentChinaMobileEnum) do
            if v==paymentType then 
                return true
            end
        end
        for k,v in pairs(PlatformPaymentChinaUnicomEnum) do
            if v==paymentType then 
                return true
            end
        end
        for k,v in pairs(PlatformPaymentChinaTelecomEnum) do
            if v==paymentType then 
                return true
            end
        end
        return false
    else
        return false
    end 
end