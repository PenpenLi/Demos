-- FileName: SkyPieaRankCell.lua
-- Author: huxiaozhou
-- Date: 2015-01-08
-- Purpose: 空岛排行榜 cell
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

require "script/module/public/class"
require "script/module/public/Cell/Cell"
SkyPieaRankCell = class("SkyPieaRankCell",Cell)

local m_fnGetWidget = g_fnGetWidgetByName

function SkyPieaRankCell:ctor(layCell)
	self.cell = layCell
end


function SkyPieaRankCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mCell = widget:clone()
		self.mCell:setPosition(ccp(0,0))
		self.mCell:setEnabled(true)
	end
end

--[[
level = "60"
rank = 14
uid = "25041"
utid = "2"
uname = "诺德寇里"
figure = "10061"
point = "444"
cur_base = "2"
--]]
-- 刷新显示每个cell 
function SkyPieaRankCell:refresh( tbData )
	logger:debug(tbData)
	local imgBg1 = m_fnGetWidget(self.mCell, "IMG_CELL_1")
	local imgBg2 = m_fnGetWidget(self.mCell, "IMG_CELL_2")
	local imgBg3 = m_fnGetWidget(self.mCell, "IMG_CELL_3")
	local imgBg4 = m_fnGetWidget(self.mCell, "IMG_CELL_4")
	local lay_module = m_fnGetWidget(self.mCell, "LAY_CELL_MODULE")
	local labRank = m_fnGetWidget(lay_module, "LABN_RANK") 
	local imgRank = m_fnGetWidget(lay_module, "IMG_RANK")
	local imgRankTxt = m_fnGetWidget(lay_module, "img_rank_txt")
	local labLvl  = m_fnGetWidget(lay_module, "TFD_LV")
	local i18nLabLvl = m_fnGetWidget(lay_module, "tfd_lv_txt")
	local labName = m_fnGetWidget(lay_module, "TFD_NAME")
	local labScore = m_fnGetWidget(lay_module, "LABN_SCORE_NUM")
	local labFloor = m_fnGetWidget(lay_module, "TFD_FLOOR_NUM")
	local imgFace = m_fnGetWidget(lay_module, "IMG_FACE")
	local i18ntfd_floor = m_fnGetWidget(lay_module, "tfd_floor") -- 层
	i18ntfd_floor:setText(gi18n[5471])
	local i18ntfd_score = m_fnGetWidget(lay_module, "tfd_score") --分
	i18ntfd_score:setText(gi18n[5411])
	i18nLabLvl:setText(gi18n[1067])
	-- UIHelper.labelNewStroke(i18ntfd_floor)
	UIHelper.labelNewStroke(i18ntfd_score)
	labRank:setEnabled(false)
	imgRankTxt:setEnabled(false)
	imgRank:setEnabled(false)

	imgBg1:setEnabled(false)
	imgBg2:setEnabled(false)
	imgBg3:setEnabled(false)
	imgBg4:setEnabled(false)
	if tbData.rank == 1 then
		imgRank:setEnabled(true)
		imgRank:loadTexture("ui/guild_rank_one.png")
		imgBg1:setEnabled(true)
		i18nLabLvl:setColor(ccc3(0xc8,0x50,0x00))
		i18ntfd_floor:setColor(ccc3(0xc8,0x50,0x00))
	elseif tbData.rank == 2 then
		imgRank:setEnabled(true)
		imgRank:loadTexture("ui/guild_rank_two.png")
		imgBg2:setEnabled(true)
		i18nLabLvl:setColor(ccc3(0x6c,0x6a,0x68))
		i18ntfd_floor:setColor(ccc3(0x6c,0x6a,0x68))
	elseif tbData.rank == 3 then
		imgRank:setEnabled(true)
		imgRank:loadTexture("ui/guild_rank_three.png")
		imgBg3:setEnabled(true)
		i18nLabLvl:setColor(ccc3(0x9f,0x4f,0x36))
		i18ntfd_floor:setColor(ccc3(0x9f,0x4f,0x36))
	else
		labRank:setEnabled(true)
		labRank:setStringValue(tbData.rank)
		imgRankTxt:setEnabled(true)
		imgBg4:setEnabled(true)
		i18nLabLvl:setColor(ccc3(0x82,0x56,0x00))
		i18ntfd_floor:setColor(ccc3(0x82,0x56,0x00))
	end
	imgFace:removeAllChildren()
	local icon = HeroUtil.createHeroIconBtnByHtid(tbData.figure)
	imgFace:addChild(icon)
	labLvl:setText(tbData.level)
	labName:setText(tbData.uname)
	labScore:setStringValue(tbData.point)
	labFloor:setText(tbData.cur_base)

end
