if __IOS then 
	waxClass{"UIAlertViewDelegateImpl", NSObject, protocols = {"UIAlertViewDelegate"}}

	local UIAlertViewStatic = {}

	function alertView_clickedButtonAtIndex (self, alertView, buttonIndex) 
		if UIAlertViewStatic.callback ~= nil then UIAlertViewStatic.callback(alertView, buttonIndex) end
		UIAlertViewStatic.callback = nil
	end

	function UIAlertViewStatic:buildUI( title, message, cancelButtonTitle, callback )
		local alert = UIAlertView:initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles(title, message,UIAlertViewDelegateImpl:init(),cancelButtonTitle,nil)
		UIAlertViewStatic.callback = callback
		return alert
	end
	
	return UIAlertViewStatic
end
return nil
