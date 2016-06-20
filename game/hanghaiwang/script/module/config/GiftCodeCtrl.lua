-- FileName: GiftCodeCtrl.lua
-- Author: Xufei
-- Date: 2015-07-30
-- Purpose: 礼包码 控制
--[[TODO List]]

module("GiftCodeCtrl", package.seeall)
require "script/module/config/GiftCodeView"

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n
local _tbNotice = {_i18n[6302], _i18n[6303], _i18n[6304],
 _i18n[6305], _i18n[6306], _i18n[6307]}
--[[
 {"未知错误", "该礼包码已被使用", "系统繁忙，请重试",
 "此卡不可使用", "礼包码不正确，请重新输入", "领取失败，同一类型礼券只能使用一次"}
]]

local function init(...)

end

function destroy(...)
	package.loaded["GiftCodeCtrl"] = nil
end

function moduleName()
    return "GiftCodeCtrl"
end

function getChangeBtnEvent( inputBox )
	return function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then	
			local codeText = inputBox:getText() or ""
			logger:debug{testInputBox = codeText}

			if (codeText == "") then
				AudioHelper.playCommonEffect()
				ShowNotice.showShellInfo(_i18n[6308]) --请先输入礼包码
				return
			end

			local function receiveRewardByCode( cbFlag, dictData, bRet )
				if (bRet) then
					if (dictData.ret.ret == "ok") then
						AudioHelper.playBuyGoods()
						logger:debug({testReward = dictData.ret.reward})
						local tbReward = {}
						for k,v in pairs(dictData.ret.reward) do
							local tb = {}
							tb.type = v[1]
							tb.id = v[2]
							tb.num = v[3]
							table.insert(tbReward, tb)
						end
						require "script/module/public/RewardUtil"
						UIHelper.createGetRewardInfoDlg(dictData.ret.info, 
							RewardUtil.parseRewardsByTb(RewardUtil.getItemsDataByTb(tbReward), true))

						Platform.doPostGiftCode(codeText) -- SDK拇指玩渠道需求，在礼包码成功后调用
					elseif (dictData.ret.ret) then
						AudioHelper.playCommonEffect()
						ShowNotice.showShellInfo( _tbNotice[tonumber(dictData.ret.ret)+1] ) --_tbNotice下标从1开始
					end
				end
			end
			local args = Network.argsHandler(codeText)		
			RequestCenter.reward_getGiftByCode(receiveRewardByCode, args)
		end
	end
end

function create(...)
	local instanceView = GiftCodeView:new()
	instanceView:create()
end
