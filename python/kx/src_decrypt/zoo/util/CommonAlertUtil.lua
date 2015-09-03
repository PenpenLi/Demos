
CommonAlertUtil = {}

NotRemindFlag = table.const {
  PHOTO_ALLOW = "photo_allow",
  GPS_ALLOW = "gps_allow",
  SMS_ALLOW = "sms_allow",
  CAMERA_ALLOW = "camera_allow",
}

--@notRemind 写在本地的某个提示不再提示的标识 将字符串作为Key传入 不要轻易改动 来自NotRemindFlag其中之一 自行添加
function CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,notRemind,message,title,tip,onButton2Click,onTextInput,onCancel)
	if _G.isPrePackage then 
		local MainActivityHolder = luajava.bindClass('com.happyelements.android.MainActivityHolder')
		local preferences = MainActivityHolder.ACTIVITY:getSharedPreferences("pre_package_info", 0)
		local isAlwaysAllow = preferences:getBoolean(notRemind, false)
		if not isAlwaysAllow then
			local _onButton1Click = onButton1Click or function() end
			local _onButton2Click = onButton2Click or function() end
			local _onCancel = onCancel or function() end
			local _onTextInput = onTextInput or function() end

			local buttonCallfunc = luajava.createProxy("com.happyelements.hellolua.share.IDialogCallback", 
				{onButton1Click=_onButton1Click,onButton2Click=_onButton2Click,onTextInput=_onTextInput,onCancel=_onCancel})

			local _message = message or ""
			local _title = title or "系统提示"
			local _tip = tip or "不再提示"
			local _notRemind = notRemind or ""
			local builder = luajava.bindClass("com.happyelements.hellolua.share.CommonAlertDialog")
			builder:buildNetStatusDialog(_title, _message, _tip, _notRemind, "确定", "取消", buttonCallfunc)
		else
			if onButton1Click then 
				onButton1Click()
			end
		end
	else
		if onButton1Click then 
			onButton1Click()
		end
	end
end

function CommonAlertUtil:showPrePackageNetWorkAlertPanel(onButton1Click, onButton2Click, isIngame)
	if _G.isPrePackage then 
		local _onButton1Click = onButton1Click or function() end
		local _onButton2Click = onButton2Click or function() end
		local _onCancel = function() end
		local _onTextInput = function() end

		local buttonCallfunc = luajava.createProxy("com.happyelements.hellolua.share.ITrafficAlertDialogCallback", 
			{onButton1Click=_onButton1Click,onButton2Click=_onButton2Click,onTextInput=_onTextInput,onCancel=_onCancel})

		local title = "联网提示"
		local message = isIngame and "允许开心消消乐联网及获取位置信息，能体验更多精彩功能哦！联网络会产生流量费（详询当地运营商），同时需重启游戏，是否现在允许？" 
		or "欢迎来玩开心消消乐。允许游戏联网及获取位置信息，能体验更多精彩功能哦！联接网络会产生流量费（详询当地运营商）。是否现在允许？"
		local tip = "不再提示"

		local builder = luajava.bindClass("com.happyelements.hellolua.share.TrafficAlertDialog")
		local buttonLabel1 = "允许"
		local buttonLabel2 = "离线继续" 

		builder:buildNetStatusDialog(title, message, tip, buttonLabel1, buttonLabel2, buttonCallfunc)
	end
end