-- FileName: ShipBulletRequest.lua
-- Author: yucong
-- Date: 2015-02-14
-- Purpose: function description of module
--[[TODO List]]

module("ShipBulletRequest", package.seeall)

-- 穿戴、卸下
-- gunBarId 炮筒id
-- bulletId 炮弹id，卸下时传0
-- func 回调，参数bulletId
function wearBullet( gunBarId, bulletId, func )
	RequestCenter.mainship_wearBullet(function ( cbFlag, dictData, bRet )
		if (bRet) then
			logger:debug("wearBulletOK")
			-- 设置数据
			CannonModel.setCannonBallBy(gunBarId, bulletId)
			if (func) then
				func(bulletId)
			end
			GlobalNotify.postNotify(ShipBulletConst.MSG_BULLET_LOAD_OK, bulletId)
		end
	end, Network.argsHandlerOfTable({gunBarId, bulletId}))
end