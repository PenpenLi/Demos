-- FileName: FriendsCell.lua
-- Author: xianghuiZhang
-- Date: 2014-06-05
-- Purpose: 定义好友列表用的Cell类
--[[TODO List]]

require "script/module/public/class"
require "script/module/public/Cell/Cell"

local m_fnGetWidget = g_fnGetWidgetByName

----------------------------- 定义好友 FriendsCell  -----------------------------
FriendsCell = class("FriendsCell", Cell)

function FriendsCell:ctor(...)
    local tbCell = ...
    self.cellType = tbCell.cellType
    self.cell = tolua.cast(tbCell.cell, "Layout")
    self.tbMaskRect = {}
    self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
end

function FriendsCell:addMaskButton(btn, sName, fnBtnEvent)
    if ( not self.tbMaskRect[sName]) then
        local x, y = btn:getPosition()
        local size = btn:getSize()
        logger:debug("MailCell:addMaskButton  x = %f, y = %f, w = %f, h = %f", x, y, size.width, size.height)

        -- 坐标和size都乘以满足屏宽的缩放比率
        local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
        local posPercent = btn:getPositionPercent()
        local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
        logger:debug("LevelRewardCell:addMaskButton  xx = %f, yy = %f", xx, yy)
        self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
        self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
    end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function FriendsCell:touchMask(point)
    if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
        return nil
    end

    for name, rect in pairs(self.tbMaskRect) do
        logger:debug("rect:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        if (rect:containsPoint(point)) then
            logger:debug("hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
            return self.tbBtnEvent[name]
            -- return true
        end
    end
end

function FriendsCell:getGroup()
    if (self.mlaycell) then
        -- local tg = HZTouchGroup:create() -- 可接受触摸事件，传递给UIButton等UI控件
        -- tg:addWidget(self.mlaycell)
        -- return tg
        return self.mlaycell
    end
    return nil
end


--cellType:1为我的好友cell，2为推荐好友cell，3为领取耐力cell ,4好友申请
-- idx:当前cell在tableview中的index
function FriendsCell:refresh(tbData)
    if (self.mlaycell) then
        local cell = self.mlaycell
        if(self.cellType==1 ) then
            local LAY_MORE = m_fnGetWidget(cell,"LAY_MORE")
            if (not tbData.more) then 
                LAY_MORE:setVisible(false)
                LAY_MORE:setEnabled(false)
            else
                LAY_MORE:setVisible(true)
                LAY_MORE:setEnabled(true)
            end
        end
        self:removeMaskButton("BTN_MORE")
        self:removeMaskButton("BTN_COMMU")
        self:removeMaskButton("BTN_GIVE_STAMINA")
        self:removeMaskButton("BTN_INVITE")
        if (not tbData.more) then
            
            require "script/module/friends/MainFdsCtrl"
            require "script/module/friends/FriendsApplyModel"
            local tfdName = m_fnGetWidget(cell, "TFD_NAME")
            tfdName:setText(tbData.uname)
            local nameColor = UserModel.getPotentialColor({htid=tbData.figure,bright=false})
            tfdName:setColor(nameColor)

            local tfdLv = m_fnGetWidget(cell, "TFD_LV")
            tfdLv:setText(tbData.level)

            local labnZDL = m_fnGetWidget(cell, "TFD_ZHANDOULI")
            labnZDL:setText(tbData.fight_force)

            require "script/model/utils/HeroUtil"
            local lay_photo = m_fnGetWidget(cell, "LAY_PHOTO")
            if(tbData.figure)then 
                lay_photo:removeNodeByTag(101)
                local headSp = HeroUtil.getHeroIconByHTID(tbData.figure)
                headSp:setTag(101)
                local size = lay_photo:getSize()
                headSp:setPosition(ccp(size.width/2,size.height/2))
                lay_photo:addNode(headSp)
            else 
                logger:debug("头像字段null")
                logger:debug(tbData)
            end 


            if(self.cellType == 1) then
                local btnCommu = m_fnGetWidget(cell, "BTN_COMMU")
                UIHelper.titleShadow(btnCommu,gi18n[2907])
                btnCommu:setTag(tbData.uid)
                btnCommu.figure = tbData.figure
                -- btnCommu:addTouchEventListener(tbData.eventBack.onBtnCommu)
                self:addMaskButton(btnCommu, "BTN_COMMU", tbData.eventBack.onBtnCommu)

                local tfdStatus = m_fnGetWidget(cell, "TFD_STATUS")
                tfdStatus:setText(tbData.stateText)
                if( tonumber(tbData.status) == 1)then --在线 
                    tfdStatus:setColor(ccc3(0xdf,0x01,0x0c))
                else    --离线 封号。。
                     tfdStatus:setColor(ccc3(127,95,32))
                end 

                local btnGiveStma = m_fnGetWidget(cell, "BTN_GIVE_STAMINA")
                btnGiveStma:setTag(tbData.uid)

                -- local imgForStatus = m_fnGetWidget(cell, "IMG_FORBIDDEN_STATUS")

                if (tbData.isGive) then
                    -- imgForStatus:setVisible(true)
                    btnGiveStma:setBright(false)
                    btnGiveStma:setTouchEnabled(false)
                    self:removeMaskButton("BTN_GIVE_STAMINA")
                else
                    -- imgForStatus:setVisible(false)
                    btnGiveStma:setBright(true)
                    btnGiveStma:setTouchEnabled(true)
                    self:addMaskButton(btnGiveStma, "BTN_GIVE_STAMINA", tbData.eventBack.onBtnGive)
                end

            elseif(self.cellType == 2) then
                local btnInvite = m_fnGetWidget(cell, "BTN_INVITE")
                btnInvite:setTag(tbData.uid)
                UIHelper.titleShadow(btnInvite,gi18n[2915])
                -- btnInvite:addTouchEventListener(tbData.eventBack.onBtnInvite)
                self:addMaskButton(btnInvite, "BTN_INVITE", tbData.eventBack.onBtnInvite)
                btnInvite.idx = tbData.idx

            elseif(self.cellType == 3) then 
                logger:debug("tbData.dayTime" .. tbData.dayTime)
                local tfdStatus = m_fnGetWidget(cell, "TFD_STATUS")
                tfdStatus:setTag(tonumber(tbData.time))
                tfdStatus:setText(tbData.dayTime)
                UIHelper.labelStroke(tfdStatus)
                local btnGiveStana = m_fnGetWidget(cell, "BTN_GIVE_STAMINA")
                btnGiveStana:setTag(tbData.uid)
                -- btnGiveStana:addTouchEventListener(tbData.eventBack.onBtnGetLove)
                self:addMaskButton(btnGiveStana, "BTN_GIVE_STAMINA", tbData.eventBack.onBtnGetLove)

            elseif(self.cellType == 4)then 
                local btnAgree = m_fnGetWidget(cell, "BTN_AGREE")
                self:addMaskButton(btnAgree, "BTN_AGREE", tbData.onInvite)
                btnAgree:setTag(tbData.uid)

                local btnRefuse = m_fnGetWidget(cell,"BTN_REFUSE")
                self:addMaskButton(btnRefuse,"BTN_REFUSE",tbData.onRefuse)
                btnRefuse:setTag(tbData.uid)
                require "script/module/mail/MailData"
                local tfdStatus = m_fnGetWidget(cell, "TFD_STATUS")  --几天前
                local timeStr = MailData.getValidTime( tbData.recv_time )
                tfdStatus:setText(timeStr)
            end 
        else  
            local btnMore = m_fnGetWidget(cell, "BTN_MORE")
            self:addMaskButton(btnMore, "BTN_MORE", tbData.eventBack.onBtnMore)
        end
    end
end

function FriendsCell:init( tbData )
    local widget = self.cell
    if (widget) then
        self.mlaycell = widget:clone()
        self.mlaycell:setPosition(ccp(0,0))
    end 
end
