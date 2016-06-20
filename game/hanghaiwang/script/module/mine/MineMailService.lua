-- FileName: MineMailService.lua
-- Author:sunyunpeng 
-- Date: 2015-06-01
-- Purpose: 资源矿邮件数据拉取
--[[TODO List]]

module("MineMailService", package.seeall)
require "script/module/mine/MineMailData"

-- UI控件引用变量 --

-- 模块局部变量 --
local _tempIdtb = MineMailData.MINEMAIlTEMPLATEID
local m_i18n = gi18n
local function init(...)

end

function destroy(...)
	package.loaded["MineMailService"] = nil
end

function moduleName()
    return "MineMailService"
end

-- 得到资源矿仇人列表数据
-- n_startIndex:开始索引第一次为0，其他情况下是mid
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false  第一次拉取默认true
-- callbackFunc:回调
function getRevengeMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug ("getMineralMailList---后端数据")
		logger:debug (dictData.ret)
		if(bRet == true)then
			MineMailData.mineRevengeData = dictData.ret
			callbackFunc( dictData.ret,dictData.ret.mail_number )
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	--RequestCenter.mail_getBattleMailList(requestFunc,args)
	Network.rpc(requestFunc, "mail.getMineralMailList", "mail.getMineralMailList", args, true)
end

-- 得到资源矿到期列表数据
-- n_startIndex:开始索引第一次为0，其他情况下是mid
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false  第一次拉取默认true
-- callbackFunc:回调
function getResourceExhaustMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug ("getMineralMailList---后端数据")
		logger:debug (dictData.ret)
		if(bRet == true)then
			logger:debug(dictData.ret)
			MineMailData.mineExhaustData = dictData.ret
			callbackFunc( dictData.ret.list,dictData.ret.mail_number )
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	--RequestCenter.mail_getMailBoxList(requestFunc, args)
	Network.rpc(requestFunc, "mail.getMineralMailListTableTwo", "mail.getMineralMailListTableTwo", args, true)
	
	--Network.rpc(requestFunc, "mail.getMineralMailList", "mail.getMineralMailList", args, true)
end

-- 得到资源抢夺列表数据
-- n_startIndex:开始索引第一次为0，其他情况下是mid
-- n_num:个数
-- older: 是拉取比参照值老的邮件还是新的邮件	 旧邮件是true, 新邮件是false  第一次拉取默认true
-- callbackFunc:回调
function getGrabMailList(n_startIndex, n_num, older, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			logger:debug(dictData.ret)
			MineMailData.mineGrabData = dictData.ret
			callbackFunc( dictData.ret.list ,dictData.ret.mail_number)
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(n_startIndex))
	args:addObject(CCInteger:create(n_num))
	args:addObject(CCString:create(older))
	RequestCenter.mineral_getRobLog(requestFunc,args)
	--Network.rpc(requestFunc, "mineral.getRobLog", "mineral.getRobLog", args, true)
end

-- 通过uid获取DomainId
function getDomainInfoOfUser( uid , RobDomainType,callbackFunc)
	local function requestFunc( cbFlag, dictData, bRet )
		logger:debug( {dictData = dictData})
		logger:debug({RobDomainType=RobDomainType})
		if(bRet == true)then
			logger:debug(dictData.ret)
			local revengePits = dictData.ret
			local domainid = nil
			local pitid = nil
			local revengeDb= {}

			if (revengePits and tonumber(revengePits) ~= 0 and #revengePits ~=0 ) then
				for i,v in ipairs(revengePits) do
					require "script/module/mine/MineModel"
					local domaintype = MineModel.convertDomainToArea(tonumber(v.domain_id))
					if (domaintype == 1 or domaintype == 2) then
						revengeDb.lowerResource =  { domainid = v.domain_id , pitid = v.pit_id}
					else
						revengeDb.higherResource =  { domainid = v.domain_id , pitid = v.pit_id}
					end
				end

				logger:debug({revengeDb=revengeDb})

				if (RobDomainType == 1 or RobDomainType == 2) then
					if (revengeDb.lowerResource) then
						domainid = revengeDb.lowerResource.domainid
						pitid = revengeDb.lowerResource.pitid
					elseif (revengeDb.higherResource) then
						domainid = revengeDb.higherResource.domainid
						pitid = revengeDb.higherResource.pitid
					end

				else
					if (revengeDb.higherResource) then
						domainid = revengeDb.higherResource.domainid
						pitid = revengeDb.higherResource.pitid
					elseif (revengeDb.lowerResource) then
						domainid = revengeDb.lowerResource.domainid
						pitid = revengeDb.lowerResource.pitid
					end
				end
			end
			callbackFunc( domainid,pitid)
		end
	end

	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(uid))
	--args:addObject(CCInteger:create(domainType))

	logger:debug("mineral.getDomainInfoOfUser")

	Network.rpc(requestFunc, "mineral.getDomainInfoOfUser", "mineral.getDomainInfoOfUser", args, true)
end

--查看战报
function fnLookbatter( _tag, sender)
	local menuBtnCanCall = MineMailData._menuBtnCanCall
	if (not menuBtnCanCall) then   --  超出LISTVIEW范围时 不促发事件
		--sender:unselected()
		return 
	end
	local tag = sender:getTag()
	-- 音效
	AudioHelper.playCommonEffect()
	local function createNext( fightRet )
		logger:debug("fnLookbatter")
		if(LayerManager.curModuleName() ~= MineMailCtrl.moduleName()) then
			return 
		end
		-- 调用战斗接口 参数:atk
		-- 调用结算面板
		-- require "script/model/user/UserModel"
		-- local uid = UserModel.getUserUid()
		-- 解析战斗串获得战斗评价
		local amf3_obj = Base64.decodeWithZip(fightRet)
		local lua_obj = amf3.decode(amf3_obj)
		local tbData = {}

   		if(tonumber(UserModel.getUserUid()) == tonumber(lua_obj.team1.uid)) then
   			tbData.uid = lua_obj.team2.uid
   			tbData.uname = lua_obj.team2.name
   			tbData.fightForce = lua_obj.team2.fightForce
   		else
   			tbData.uid = lua_obj.team1.uid
   			tbData.uname = lua_obj.team1.name
   			tbData.fightForce = lua_obj.team1.fightForce
   		end
   			tbData.brid = lua_obj.brid
   			
		require "script/battle/BattleModule"
		local fnCallBack = function ( ... )

		end

		tbData.type = MineMailData.ReplayType.KTypeMineMail
		tbData.Tabtype = MineMailCtrl._curPage		

		MineMailView.removeListView()
		
		--BattleModule.PlayNormalRecord(fightRet,fnCallBack,tbData,true)
		logger:debug({tbData=tbData})
		logger:debug({fightRet=fightRet})

		BattleModule.playMineBattle(fightRet,fnCallBack,tbData,true)
	
	end
	getRecord(tag,createNext)
end


-- 得到战斗串
--  int $brid: 战报id
function getRecord(brid, callbackFunc )
	local function requestFunc( cbFlag, dictData, bRet )
		if(bRet == true)then
			-- logger:debug(dictData.ret)
			local dataRet = dictData.ret
			if (dataRet=="" or dataRet==" ") then
				ShowNotice.showShellInfo(m_i18n[7814]) 
			else 
				callbackFunc( dataRet )
			end 
			
		end
	end
	-- 参数
	local args = CCArray:create()
	args:addObject(CCInteger:create(brid))
	--Network.rpc(requestFunc, "battle.getRecord", "battle.getRecord", args, true)
	RequestCenter.battle_getRecord(requestFunc,args)
end


-- 获得每个Cell上的显示信息
function getCellShowAttr( tCellValue )
	logger:debug({getCellShowAttr_tCellValue=tCellValue})
	local tbRichStr = {}
	local templateId = tonumber(tCellValue.templateId)

	tbRichStr.nowCapture = tCellValue.now_capture or ""
 	tbRichStr.preCapture = tCellValue.pre_capture or ""
 	tbRichStr.domainId = tCellValue.domain_id or ""
 	tbRichStr.mineRegionType = tCellValue.mineRegionType or ""
 	tbRichStr.mineRegionId = tCellValue.mineRegionId or ""
 	tbRichStr.mineMineType = tCellValue.mineMineType or ""
 	tbRichStr.content = tCellValue.content

 	local function getWoodAndSilver( feild )
 		logger:debug({getWoodAndSilver_feild = feild})
 		local gainGroup = {}
 		if feild and type(feild) == "table" then
    		gainGroup = feild 
 		else
 			gainGroup[1] = feild or "0"
 			gainGroup[2] = "0"
 		end

 		gainGroup[1] = tonumber(gainGroup[1])
 		gainGroup[2] = tonumber(gainGroup[2])

 		logger:debug({getWoodAndSilver = gainGroup })
 		return gainGroup
 	end 

    if (tCellValue.va_extra) then  -- 8
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[2])
    	logger:debug({gainGroup = gainGroup})
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
 		tbRichStr.domainType = tonumber(tCellValue.va_extra.data[4] or 0) 
		tbRichStr.gatherTime =  TimeUtil.getTimeStringFont(math.floor(gainGroup[1] or 0))
	   	tbRichStr.replay = tonumber(tCellValue.va_extra.replay) or 0
	    tbRichStr.captureUid = tonumber(tCellValue.va_extra.data[1].uid) or 0
	    tbRichStr.nowCapture = tCellValue.va_extra.data[1].uname or ""
    end
    
	if (templateId == _tempIdtb.ZYKBFQ )  then
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[3])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
    elseif (templateId == _tempIdtb.BRQDCG or templateId == _tempIdtb.XZBQTS)   then
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[3])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
	elseif (templateId == _tempIdtb.ZYZLWC or templateId == _tempIdtb.ZLSJJS) then
 		tbRichStr.captureTime  = TimeUtil.getTimeStringFont(tCellValue.va_extra.data[1] or 0)
	elseif (templateId == _tempIdtb.ZYKBZL) then
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[3])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
 	elseif (tonumber(tCellValue.templateId) == _tempIdtb.BDJL)  then 
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[3])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.ZYKFQ or  tonumber(tCellValue.templateId) == _tempIdtb.ZDFQXZ)  then   --34  36放弃资源矿 放弃协助资源矿 
		tbRichStr.gatherTime =  TimeUtil.getTimeStringFont(math.floor(tCellValue.va_extra.data[1] or 0))
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[2])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0) 
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.QXBDZSB) then  -- 6
    	local gainGroup = getWoodAndSilver(tCellValue.va_extra.data[3])
    	tbRichStr.gatherSilver = math.floor(gainGroup[1] or 0) 
    	tbRichStr.gatherWood = math.floor(gainGroup[2] or 0)  
		tbRichStr.gatherTime =  TimeUtil.getTimeStringFont(math.floor(tCellValue.va_extra.data[2].gather_time or 0))
	elseif (tonumber(tCellValue.templateId) == _tempIdtb.QXBDZCG) then  -- 7
 		tbRichStr.domainType = tonumber(tCellValue.va_extra.data[2].domain_type or 0) 
	end

 	return tbRichStr
end

function create(...)

end
