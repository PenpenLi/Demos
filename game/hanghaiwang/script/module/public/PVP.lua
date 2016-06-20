-- FileName: PVP.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: function description of module
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("PVP", package.seeall)

function doPVP( uid )

	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	RequestCenter.friend_pk(function (cbFlag, dictData, bRet) 
		logger:debug(dictData)
								local dictData = dictData.ret
								local tbData = {}
								tbData.brid = dictData.brid
								tbData.playerName = dictData.army_uname 
								tbData.fightForce = dictData.army_fight_force
								tbData.uid = UserModel.getUserUid()
								tbData.uid2 = uid
								require "script/battle/BattleModule"
								BattleModule.playPVP(dictData.fight_ret, function (  )

																			end, tbData)
	 						end, args)
end