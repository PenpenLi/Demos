-- FileName: AnnounceCtrl.lua
-- Author: menghao
-- Date: 2014-06-19
-- Purpose: 公告ctrl


module("AnnounceCtrl", package.seeall)


require "script/module/config/AnnounceView"


-- UI控件引用变量 --


-- 模块局部变量 --
local m_strNotice


local addNoticeToLay = function ( strAll )
	strAll = string.gsub(strAll, "\r\n", " \n")
	local tbAllOld = string.split(strAll, "======")

	for k,v in pairs(tbAllOld) do
		local tbOneOld = string.split(v, "|")

		local tbInfo = {}
		tbInfo.colorT = string.split(tbOneOld[1], ",")
		tbInfo.colorW = string.split(tbOneOld[3], ",")
		tbInfo.title = tbOneOld[2]
		tbInfo.word = tbOneOld[4]

		if (#tbAllOld == 1) then
			AnnounceView.addAnnounce(tbInfo, 1)
			return
		end
		AnnounceView.addAnnounce(tbInfo)
	end
end


local function getAnnounceCallBack( sender, res )
	logger:debug("getAnnounceCallBack_res:getResponseCode = " .. res:getResponseCode())

	LayerManager.removeLoading()

	if (res:getResponseCode() == 200)then
		m_strNotice = res:getResponseData()

		if (m_strNotice and m_strNotice ~= "") then
			local layAnnounce = AnnounceView.create()
			LayerManager.addLayout(layAnnounce)
			addNoticeToLay(m_strNotice)
			MainScene.addNoticeTime()
		end
	else
		if (g_debug_mode) then -- zhangqi, 2015-06-11, 如果拉取公告错误线下才弹提示
			LayerManager.addLayout(UIHelper.createCommonDlg(gi18n[2829], nil, nil, 1))
		end
	end
end


-- 通过服务器标识serverKey拉取第二类通知
function fetchNotice02FromServer(serverKey)
	require "platform/Platform"
	local url = Platform.getNoticeBeforeGameUrl()
	local request = LuaHttpRequest:newRequest()
	request:setRequestType(CCHttpRequest.kHttpGet)
	request:setUrl(url)
	logger:debug("fetchNotice02FromServer url = " .. url)
	request:setResponseScriptFunc(getAnnounceCallBack)

	LayerManager.addLoading()
	
	CCHttpClient:getInstance():send(request)
	request:release()
end


local function init(...)

end


function destroy(...)
	package.loaded["AnnounceCtrl"] = nil
end


function moduleName()
	return "AnnounceCtrl"
end


function create(...)
	if (UserModel.getAvatarLevel() < 6) then
		return
	end
	-- AppStore审核
	if (Platform.isAppleReview()) then
		return
	end

	fetchNotice02FromServer()
end

