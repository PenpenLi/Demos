ClipBoardUtil = {}

function ClipBoardUtil.copyText(str)
	if __ANDROID then
		luajava.bindClass("com.happyelements.android.utils.ClipBoardUtil"):copyString(str)
	elseif __IOS then
		local pasteboard = UIPasteboard:generalPasteboard()
		pasteboard:setPersistent(true)
		pasteboard:setString(str)
	end
end

