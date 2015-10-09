
UserInfoUtil={};

UserInfoUtil.DOWN_LOAD_GIFT_SIGN="DOWN_LOAD_GIFT_SIGN";

function UserInfoUtil:private_getUserInfo(str)
	if userInfoSaver then
		return userInfoSaver:getString(tostring(str));
	end
end

function UserInfoUtil:private_setUserInfo(str, v)
	if userInfoSaver then
		userInfoSaver:setString(tostring(str),tostring(v));
	end
end

function UserInfoUtil:public_getDownLoadGiftSign(id)
	return UserInfoUtil:private_getUserInfo(UserInfoUtil.DOWN_LOAD_GIFT_SIGN .. id);
end

function UserInfoUtil:public_setDownLoadGiftSign(id)
	UserInfoUtil:private_setUserInfo(UserInfoUtil.DOWN_LOAD_GIFT_SIGN .. id,id);
end