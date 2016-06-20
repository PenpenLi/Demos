-- FileName: AccLoginRequest.lua
-- Author: yucong
-- Date: 2015-11-11
-- Purpose: 累计登录活动网络模块
--[[TODO List]]
module("AccLoginRequest", package.seeall)

function getAccLoginInfo( func )
	RequestCenter.accGift_getAccLoginInfo(function ( cbFlag, dictData, bRet )
		if (bRet) then
			if (func) then
				func(dictData.ret)
			end
		end
	end)
end

function getAccLoginGift( id, goodIndex, func )
	RequestCenter.accGift_getAccLoginGift(function ( cbFlag, dictData, bRet )
		if (bRet) then
			if (func) then
				func(dictData.ret)
			end
		end
	end, Network.argsHandlerOfTable({id, goodIndex}))
end
