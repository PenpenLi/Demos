-------------------------------------------------------------------------
--  Class include: SnsProxy_Android, SnsProxy_iOS, SnsProxy
-------------------------------------------------------------------------

if __IOS_FB then
    require "hecore.sns.SnsProxyIOS"
elseif __IOS_WEIBO then
    require "hecore.sns.SnsProxyIOS_Weibo"
elseif __IOS_QQ then
	require "hecore.sns.SnsProxyIOS_Tencent"
elseif __ANDROID then
    require "hecore.sns.SnsProxyAndroid"
end

--
-- SnsProxy_Android ---------------------------------------------------------
--
-- initialize



--
-- SnsProxy_iOS ---------------------------------------------------------
--
-- initialize


--
-- SnsProxy ---------------------------------------------------------
--
--[[
function SnsProxy:isLogin()
	return false
end
-- login
function SnsProxy:login(callback) 
end

function SnsProxy:changeAccount( callback )
end

-- called
function SnsProxy:inviteFriends(callback)
end

function SnsProxy:getAllFriends(callback)
end

-- logout    
function SnsProxy:logout(callback)
end

-- called
function SnsProxy:submitScore( leaderBoardId, level )
end

function SnsProxy:showPlatformLeaderbord( )
end
-- called
function SnsProxy:purchaseItem(goodsType, itemId, itemAmount, realAmount, callback)
end
-- called
function SnsProxy:syncSnsFriend()
end
-- called
function SnsProxy:getUserProfile(successCallback,errorCallback,cancelCallback)
end
]]--