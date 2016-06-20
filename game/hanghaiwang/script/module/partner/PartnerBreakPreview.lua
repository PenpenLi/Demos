-- FileName: PartnerBreakPreview.lua
-- Author: wangming
-- Date: 2015-04-08
-- Purpose: 橙色伙伴预览
--[[TODO List]]

-- module("PartnerBreakPreview", package.seeall)

-- UI控件引用变量 --

require "db/DB_Hero_view"
require "script/utils/LuaUtil"

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_tbHeroes = nil

PartnerBreakPreview = class("PartnerBreakPreview")

function PartnerBreakPreview:ctor()
	self.layMain = g_fnLoadUI("ui/break_preview.json")
	self.btns = {}
	self.tabIdx = 0
	-- if(not m_tbHeroes) then
		-- tbHeroes = {{}, {}, {}, {}}
		tbHeroes = {}

		local pDBs = DB_Hero_view.getDataById(5)
		local pInfoTable = lua_string_split(pDBs.Heroes,",")
        for k, htid in pairs(pInfoTable) do
            local db_hero = DB_Heroes.getDataById(htid)
            local pCountry = tonumber(db_hero.country) or 0
            local pQulity = tonumber(db_hero.star_lv) or 0
            if (pCountry > 0 and pQulity > 5) then
                local data = {}
                data.sName = db_hero.name
                data.nHtid = db_hero.id
                data.heroQuality = db_hero.heroQuality
                -- table.insert(tbHeroes[pCountry], data)
                table.insert(tbHeroes, data)
            end
        end

        -- 2015-03-05, 对头像排序，第一优先级：按照资质排序，资质高的排在前面；第二优先级：按照id排序，id大的排在前面
        for i, tbHero in ipairs(tbHeroes) do
            table.sort(tbHero, function ( hero1, hero2 )
                if (hero1.heroQuality > hero2.heroQuality) then
                    return true
                elseif (hero1.heroQuality == hero2.heroQuality) then
                    if (hero1.nHtid > hero2.nHtid) then
                        return true 
                    else
                        return false
                    end
                end
            end)
        end

        logger:debug(tbHeroes)
        m_tbHeroes = {heroes = tbHeroes}
	-- end
end

function PartnerBreakPreview:create( )
	local layRoot = self.layMain

	local function closeView( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			UIHelper.closeCallback()
		end
	end

	local btnClose = m_fnGetWidget(layRoot, "BTN_CLOSE") -- 关闭按钮
	btnClose:addTouchEventListener(closeView)
	-- local btnCancel = m_fnGetWidget(layRoot, "BTN_NO") -- 取消按钮
	-- UIHelper.titleShadow(btnCancel, m_i18n[1325])
	-- btnCancel:addTouchEventListener(closeView)

	local btnOk = m_fnGetWidget(layRoot, "BTN_YES") -- 确定按钮
	UIHelper.titleShadow(btnOk, m_i18n[1324])
	btnOk:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end)

	local tfd_desc1 = m_fnGetWidget(layRoot, "tfd_desc1")
	tfd_desc1:setText(m_i18n[1169]) --wm_todo   点击伙伴头像可查看伙伴信息
	local tfd_desc2 = m_fnGetWidget(layRoot, "tfd_desc2")
	tfd_desc2:setText(m_i18n[1170]) --wm_todo（后续将开放更多橙色伙伴）

	-- 所有伙伴信息{{sName = "", nHtid = id, bUsed = false}, {}, {}, {}}`
	self.heroes = m_tbHeroes.heroes

	-- 页签按钮 BTN_TAB1(风), BTN_TAB2(雷), BTN_TAB3(水), BTN_TAB4(火)
	-- local cfgTab = {{title = m_i18n[2415]}, {title = m_i18n[2416]}, {title = m_i18n[2417]}, {title = m_i18n[2418]},}
	-- for i = 1, 4 do
	-- 	local btnTab = m_fnGetWidget(layRoot, "BTN_TAB" .. i)
	-- 	-- UIHelper.titleShadow(btnTab, cfgTab[i].title)
	-- 	btnTab:setTag(i)
	-- 	btnTab:addTouchEventListener(function ( sender, eventType )
	-- 		if (eventType == TOUCH_EVENT_ENDED) then
	-- 			AudioHelper.playTabEffect()
	-- 			self:onTab(sender:getTag())
	-- 		end
	-- 	end)
	-- 	table.insert(self.btns, btnTab)
	-- end

	self.lsvAvatar = m_fnGetWidget(layRoot, "LSV_LIST")
	UIHelper.initListView(self.lsvAvatar)

	self:onTab(1) -- 触发第一个标签


	return layRoot
end

function PartnerBreakPreview:onTab( nIdx )
	-- if (nIdx == self.tabIdx) then -- 避免重复点击标签按钮
	-- 	return
	-- end
	-- if (self.tabIdx > 0) then
	-- 	self.btns[self.tabIdx]:setFocused(false) -- 取消上一个按钮的焦点
	-- 	self.btns[self.tabIdx]:setTouchEnabled(true)
	-- end
	-- self.tabIdx = nIdx
	-- self.btns[self.tabIdx]:setFocused(true) -- 给当前按下的按钮设置焦点
	-- self.btns[self.tabIdx]:setTouchEnabled(false)

	local lsvList = self.lsvAvatar
	-- local tbHeroes = self.heroes[self.tabIdx] -- 每个标签按钮对应的伙伴
	local tbHeroes = self.heroes-- 每个标签按钮对应的伙伴

	logger:debug("ChangeAvatarView:onTab nIdx = %d", nIdx)
	logger:debug(tbHeroes)
	
	lsvList:removeAllItems() -- 清除列表，准备重建

	if (not table.isEmpty(tbHeroes)) then
		local nIdx, cell = -1, nil
		local layFace, layAvatar = nil, nil -- 每个cell上存放头像的layout

		for i, hero in ipairs(tbHeroes) do
			if (i % 4 == 1) then -- 一行是 1 个 cell，1 个 cell 放 4 个头像
				lsvList:pushBackDefaultItem()
				nIdx = nIdx + 1
				cell = lsvList:getItem(nIdx)  -- cell 索引从 0 开始

				layFace = m_fnGetWidget(cell, "lay_face")
				if (not layAvatar) then
					layAvatar = layFace:clone() -- 先复制头像layout，避免创建头像按钮后的错误复制
					-- layAvatar:retain() -- 保持供后续头像复制
				end
				self:createAvatar(layFace, hero)
			else
				local newAvatar = layAvatar:clone()
				self:createAvatar(newAvatar, hero)
				cell:addChild(newAvatar) -- clone出来的头像需要添加到cell上
				local percentX = (i % 4 - 1)*0.25
				if (i % 4 == 0) then
					percentX = 0.75
				end
				newAvatar:setPositionPercent(ccp(percentX, 0))
			end
		end
		-- layAvatar:release() -- 一种类型的所有头像全部创建完后释放
	end
end

function PartnerBreakPreview:createAvatar( layFace, hero, fnCallback )
    logger:debug("ChangeAvatarView:createAvatar")
	--item of cell: lay_face(LAY_FACE_BG, TFD_NAME)
	local function eventShow ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playInfoEffect()
			
			self.chooseHtid = sender:getTag()
			logger:debug("click avater: htid = %d", self.chooseHtid)
	       	local tbData = DB_Heroes.getDataById(self.chooseHtid)
	         require "script/module/partner/PartnerInfoCtrl"
	        local pHeroValue = tbData--PartnerModle.getHeroDataByHid(m_tbHeroesValue[sender.idx])
	        logger:debug({pHeroValue=pHeroValue})
	        local fragTid = DB_Heroes.getDataById(pHeroValue.id).fragment
	        local heroInfo = {htid = self.chooseHtid ,hid = 0 ,strengthenLevel =  0,transLevel =  0}
	        local tArgs = {}
	        tArgs.heroInfo = heroInfo
	        local layer = PartnerInfoCtrl.create(tArgs,3)     --所选择武将信息22
	        LayerManager.addLayoutNoScale(layer)
		end
	end

	local layAvatar = m_fnGetWidget(layFace, "LAY_FACE_BG")
	local btnIcon = HeroUtil.createHeroIconBtnByHtid(hero.nHtid, nil, eventShow)
	if (btnIcon) then
		btnIcon:setTag(hero.nHtid)
		local btnSize = btnIcon:getSize()
		btnIcon:setPosition(ccp(btnSize.width/2, btnSize.height/2))
		layAvatar:addChild(btnIcon)
	end

	if (not self.chooseHtid and hero.bUsed) then
		self.chooseHtid = hero.nHtid
		self.oldHtid = hero.nHtid
	end
	if (self.imgChoosed and self.chooseHtid) then
		if (self.chooseHtid == hero.nHtid) then
			btnIcon:addChild(self.imgChoosed)
		end
	end

	local labName = m_fnGetWidget(layFace, "TFD_NAME")
	labName:setText(hero.sName)
end

