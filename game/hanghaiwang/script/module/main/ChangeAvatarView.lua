-- FileName: ChangeAvatarView.lua
-- Author: zhangqi
-- Date: 2014-12-26
-- Purpose: 实现玩家更换头像的UI
--[[TODO List]]

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

ChangeAvatarView = class("ChangeAvatarView")

function ChangeAvatarView:ctor()
	self.layMain = g_fnLoadUI("ui/choose_face.json")
	self.COL_NUM = 4
end

function ChangeAvatarView:release( ... )
	-- if (self.imgChoosed) then
	-- 	self.imgChoosed:release() -- 释放对号图标
	-- 	logger:debug("ChangeAvatarView:imgChoosed:release")
	-- end

	-- if (self.layAvatar) then
	-- 	self.layAvatar:release() -- 释放头像layout
	-- 	logger:debug("ChangeAvatarView:layAvatar:release")
	-- end
end

function ChangeAvatarView:create( tbData )
	local layRoot = self.layMain
	UIHelper.registExitAndEnterCall(layRoot, function ( ... )
		-- self:release()
	end)

	local btnClose = m_fnGetWidget(layRoot, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(UIHelper.onClose)
	local btnCancel = m_fnGetWidget(layRoot, "BTN_NO") -- 取消按钮
	UIHelper.titleShadow(btnCancel, m_i18n[1325])
	btnCancel:addTouchEventListener(UIHelper.onClose)

	local btnOk = m_fnGetWidget(layRoot, "BTN_YES") -- 确定按钮
	UIHelper.titleShadow(btnOk, m_i18n[1324])
	btnOk:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			logger:debug("change avatar ok: htid = %d, oldHtid = %d", self.chooseHtid, self.oldHtid)
			if (self.chooseHtid == self.oldHtid) then
				LayerManager.removeLayout()
				return
			end

			RequestCenter.user_setFigure(function ( cbName, dictData, bRet )
				logger:debug("ChangeAvatarView-user_setFigure")
				logger:debug(dictData)
				local bSucc = (bRet and string.lower(dictData.ret) == "ok")
				local tips = bSucc and m_i18n[3225] or m_i18n[3226]
				ShowNotice.showShellInfo(tips)

				if (bSucc) then
					LayerManager.removeLayout()
					UserModel.setAvatarHtid(self.chooseHtid)
					
					if (tbData.callback) then
						tbData.callback()
					end
				end
			end, Network.argsHandlerOfTable({self.chooseHtid}))
		end
	end)

	-- 所有伙伴信息{{sName = "", nHtid = id, bUsed = false}, }
	self.heroes = tbData.heroes
	self.chooseHtid = tonumber(tbData.curHeroHid)
	self.oldHtid = tonumber(tbData.curHeroHid)
	
	self:createAvatarList()

	return layRoot
end

function ChangeAvatarView:createAvatarList(...)
	local lsvList = m_fnGetWidget(self.layMain, "LSV_LIST")
	UIHelper.initListViewCell(lsvList,nil,6,1.5)

	if (not table.isEmpty(self.heroes)) then
		self.avatarCnt = #self.heroes
		self.endLine = (self.avatarCnt % self.COL_NUM == 0) and 0 or 1
		self.cellNum = math.floor(self.avatarCnt/self.COL_NUM) + self.endLine
		local eventAvatar
		local function updateCellByIdex( lsv, idx )
			local cell = lsv:getItem(idx)
			local nBegin = idx * self.COL_NUM
			for i=1,4 do
				hero = self.heroes[nBegin+i]
				if (hero) then
					cell.item["lay_face_"..i].TFD_NAME:setText(hero.sName)
					cell.item["lay_face_"..i].TFD_NAME:setColor(UserModel.getPotentialColor({htid = hero.nHtid, bright = false}))
					cell.item["lay_face_"..i]:setEnabled(true)
					--更新头像
					local heroInfo = DB_Heroes.getDataById(hero.nHtid)
					local bgFile = "images/base/potential/color_" .. heroInfo.potential .. ".png"
					cell.item["lay_face_"..i].IMG_ICON_BG:loadTexture(bgFile) -- 用品质边框初始化按钮
					local imgName =  heroInfo.head_icon_id
					cell.item["lay_face_"..i].IMG_HEAD:loadTexture("images/base/hero/head_icon/" .. imgName)
					cell.item["lay_face_"..i].IMG_ICON:loadTexture("images/base/potential/officer_" .. heroInfo.potential .. ".png")
					--选中状态
					if (self.chooseHtid == hero.nHtid) then
						cell.item["lay_face_"..i].IMG_BLACK:setVisible(true)
					else
						cell.item["lay_face_"..i].IMG_BLACK:setVisible(false)
					end

					cell.item["lay_face_"..i].LAY_FACE_BG:setTag(hero.nHtid)
					cell.item["lay_face_"..i].LAY_FACE_BG:addTouchEventListener(eventAvatar)
				else
					cell.item["lay_face_"..i]:setEnabled(false)
				end
			end
		end
		eventAvatar = function( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				
				self.chooseHtid = sender:getTag()
				UIHelper.reloadListView(lsvList, self.cellNum, updateCellByIdex)
			end
		end
		UIHelper.reloadListView(lsvList, self.cellNum, updateCellByIdex)
	end
end
