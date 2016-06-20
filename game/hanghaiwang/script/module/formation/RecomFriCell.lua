
--zhaoqiangjun 推荐小伙伴的Cell

require "script/GlobalVars"
require "script/module/public/class"
require "script/module/public/Cell/Cell"

RecomFriCell = class("RecomFriCell", Cell)

local m_i18n = gi18n
local m_fnGetWidget = g_fnGetWidgetByName

--生成Cell的回调方法
function RecomFriCell:ctor(...)
	local layCell = ...
	self.cell = tolua.cast(layCell, "Layout")
	self.tbMaskRect = {}
	self.tbBtnEvent = {} -- 保存需要屏蔽cell touch 事件的按钮的事件，便于在cell touch中激发按钮事件
	
end

function RecomFriCell:addMaskButton(btn, sName, fnBtnEvent)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		logger:debug("RecomFriCell:addMaskButton:%s  x = %f, y = %f, w = %f, h = %f", btn:getName(), x, y, size.width, size.height)

		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local posPercent = btn:getPositionPercent()
		local xx, yy = szParent.width*g_fScaleX*posPercent.x, szParent.height*g_fScaleX*posPercent.y
		logger:debug("RecomFriCell:addMaskButton  xx = %f, yy = %f", xx, yy)
		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = fnBtnEvent}
	end
end

-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function RecomFriCell:touchMask(point)
	logger:debug("RecomFriCell:touchMask point.x = %f, point.y = %f", point.x, point.y)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		logger:debug(name)
		logger:debug("RecomFriCell:touchMask rect:x = %f,x = %f,x = %f,x = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
		if (rect:containsPoint(point)) then
			logger:debug("RecomFriCell:touchMask hitted button:", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
			logger:debug(self.tbBtnEvent)
			return self.tbBtnEvent[name]
				-- return true
		end
	end
end

function RecomFriCell:getGroup()
	if (self.mlaycell) then
		logger:debug("mlaycell")
		return self.mlaycell
	end
	logger:debug("mlaycell: nil")
	return nil
end

function RecomFriCell:refresh(tbData)
    if (self.mlaycell) then
        local cell = self.mlaycell
        
        self:removeMaskButton("BTN_ON")
        self:removeMaskButton("BTN_UNLOAD")
        self:removeMaskButton("BTN_GAIN")

        local recomType = tbData.isForm

        local btnUnLoad = m_fnGetWidget(cell, "BTN_UNLOAD")
        local btnLoad   = m_fnGetWidget(cell, "BTN_ON")
        local btnGain   = m_fnGetWidget(cell, "BTN_GAIN")
        local imgOnForm = m_fnGetWidget(cell, "IMG_FRONTED")

        local headId
        if tonumber(recomType) == 100 then 			--英雄在小伙伴阵上
            btnUnLoad:setTag(tbData.hid)
            
			logger:debug("hid:".. tbData.hid)
        	self:addMaskButton(btnUnLoad, "BTN_UNLOAD", tbData.onUnload)
            UIHelper.titleShadow(btnUnLoad, m_i18n[1710])
        	btnUnLoad:setEnabled(true)
        	btnLoad:setEnabled(false)
        	btnGain:setEnabled(false)
            imgOnForm:setVisible(true)
            headId  = tbData.hid
        elseif tonumber(recomType) == 101 then 		--英雄在列表中
            btnLoad:setTag(tbData.hid)

			logger:debug("hid:".. tbData.hid)
        	self:addMaskButton(btnLoad, "BTN_ON", tbData.onLoad)
            UIHelper.titleShadow(btnLoad, m_i18n[1210])
        	btnUnLoad:setEnabled(false)
        	btnLoad:setEnabled(true)
        	btnGain:setEnabled(false)
            imgOnForm:setVisible(false)
            headId  = tbData.hid

        elseif tonumber(recomType) == 102 then   			--英雄要获取了
            btnGain:setTag(tbData.htid)
        	self:addMaskButton(btnGain, "BTN_GAIN", tbData.onGain)
            UIHelper.titleShadow(btnLoad, m_i18n[1249]) 
        	btnUnLoad:setEnabled(false)
        	btnLoad:setEnabled(false)
        	btnGain:setEnabled(true)
            imgOnForm:setVisible(false)
            headId  = tbData.htid
        end
        local labLevel 	= m_fnGetWidget(cell, "TFD_PARTNER_LV")
        labLevel:setText("Lv.".. tbData.level)

        local heroNameColor     = HeroPublicUtil.getLightColorByStarLv(tbData.quality)
        local labName 	= m_fnGetWidget(cell, "TFD_PARTNER_NAME")
        labName:setText(tbData.name)
        labName:setColor(heroNameColor)

        for i = 1, 6 do
            local star = m_fnGetWidget(cell, "IMG_STAR" .. i) -- 星数
            star:setVisible(i <= tbData.quality)
        end

        btnIcon = HeroUtil.createHeroIconBtnByHtid(tbData.htid)
        local headIcon = m_fnGetWidget(cell, "LAY_ICON")
        headIcon:removeAllChildren()
        btnIcon:setTag(tonumber(headId))
        logger:debug("headId:".. headId)
        local szIcon = headIcon:getSize()
        btnIcon:setPosition(ccp(szIcon.width/2, szIcon.height/2))
        headIcon:addChild(btnIcon)
        self.tbMaskRect["LAY_ICON"] = headIcon:boundingBox()
        self.tbBtnEvent["LAY_ICON"] = {sender = btnIcon, event = tbData.onheadFunc}

        local heroGroup = tbData.GroupArr
        logger:debug(heroGroup)
        local union = table.count(heroGroup)
        for i = 1,4 do
        	local labUnion = m_fnGetWidget(cell, "TFD_JIBAN".. i)
        	if i <= union then
                local gname     = heroGroup[i].gname
                local isActive  = heroGroup[i].isActive
        		labUnion:setText(tbData.GroupArr[i].gname)
                if isActive and tonumber(recomType) == 100 then         --并且不是获取的英雄
                    labUnion:setColor(ccc3(255 ,246 ,0))
                else
                    labUnion:setColor(ccc3( 46 , 15 ,2))
                end
        	else
        		labUnion:setText("")
        	end
        end

        local country = tbData.country
        local countryStr = HeroModel.getCiconByCidAndlevel(country,tbData.quality)
         -- "images/hero/"
        -- if tonumber(country) == 1 then
        -- 	countryStr = countryStr.."wind/wind".. tbData.quality ..".png"
        -- elseif tonumber(country) == 2 then
        -- 	countryStr = countryStr.."thunder/thunder".. tbData.quality ..".png"
        -- elseif tonumber(country) == 3 then
        -- 	countryStr = countryStr.."water/water".. tbData.quality ..".png"
        -- elseif tonumber(country) == 4 then
        -- 	countryStr = countryStr.."fire/fire".. tbData.quality ..".png"
        -- end
        local imgCountry = m_fnGetWidget(cell, "IMG_TYPE")
        logger:debug("countryStr:".. countryStr)
        imgCountry:loadTexture(countryStr)
    end
end

function RecomFriCell:init( tbData )
    local widget = self.cell
    if (widget) then
        self.mlaycell = widget:clone()
        self.mlaycell:setPosition(ccp(0,0))
        self.mlaycell:setScale(g_fScaleX)
    end 
end