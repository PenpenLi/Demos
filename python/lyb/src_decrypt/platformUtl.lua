
local platformUtl = PlatformUtil();
function setGspUserId(userId)
	platformUtl:setGameUserId(userId);
end
function showGM()
	platformUtl:showGM();
end
function showGameCenter()
	platformUtl:showGameCenter();
end
function hideGameCenter();
	platformUtl:hideGameCenter();
end
function callGspBuy(prodId, pordName, price, amount, description,extend)
	platformUtl:CallGSPBuy(tostring(prodId), amount..pordName, tostring(price), tostring(amount), description,extend);
end


--ios lua 回调

function LoginSucc(userId,session,nickName)
	-- body
end
function LoginFail()
	-- body
end
function LogoutSucc()
	-- body
end
function PaySucc()
	-- body
end
function PayFail()
	-- body
end
function onSetBtn34(btn3name,funKey3,btn4name,funKey4)
	-- body
end