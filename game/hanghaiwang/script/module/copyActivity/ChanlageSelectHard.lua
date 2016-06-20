-- FileName: ChanlageSelectHard.lua
-- Author: liwedong
-- Date: 2015-01-14
-- Purpose: 非贝利副本战斗选择难度
--[[TODO List]]

module("ChanlageSelectHard", package.seeall)

-- UI控件引用变量 --
local layoutMain
local fancaAni=nil
-- 模块局部变量 --
local clickAnimType={
	"acopy_choose_lvse",
	"acopy_choose_tianlanse",
	"acopy_choose_lanse",
	"acopy_choose_zise",
	"acopy_choose_chengse",
	"acopy_choose_hongse"
}
local curOpenMaxLevel = 1

local function init(...)

end

function destroy(...)
	package.loaded["ChanlageSelectHard"] = nil
end

function moduleName()
    return "ChanlageSelectHard"
end
--发送战斗请求 注：写到难度选择界面是由于本界面需要播放一个动画之后才能开始战斗
function sendActivityBattle(copyId, baseId,difficult)
	AudioHelper.playSpecialEffect("texiao_kapaizhuandong.mp3")
	--动画播完才进入战斗，期间增加屏蔽，不可点击
	local layout = Layout:create()
	LayerManager.addLayoutNoScale(layout)

	armature1 = UIHelper.createArmatureNode({
				filePath = "images/effect/acopy_choose/acopy_choose.ExportJson",
				animationName = "acopy_choose",
				loop = 0,
				fnMovementCall=function()
						LayerManager.removeLayout() --移除两次，有一次屏蔽层
						LayerManager.removeLayout()
						BattleModule.playActiveCopyBattle(copyId, baseId, 1,difficult, function() end, COPY_TYPE_EVENT)
					end
				}
			)
	local ccSkin1 = CCSkin:create("ui/acopy_hard".. difficult..".png")
	logger:debug("effect path:")
	logger:debug("ui/acopy_hard".. difficult..".png")
	armature1:getBone("acopy_choose_1"):addDisplay(ccSkin1, 0)

	local mainLayBg = g_fnGetWidgetByName(layoutMain, "LAY_CHOOSE_MAIN")
	local mainImgBg = g_fnGetWidgetByName(layoutMain, "IMG_BG")
	armature1:setPosition(mainImgBg:getPosition())
	mainLayBg:addNode(armature1,10)
	layoutMain.LSV_MAIN:setVisible(false)
	--fancaAni
end
function setListPostion( ... )
	logger:debug("setListPostion")
	performWithDelayFrame(layoutMain,function( ... )
			local cell = layoutMain.LSV_MAIN:getItem(curOpenMaxLevel-1)
			UIHelper.autoSetListOffset(layoutMain.LSV_MAIN,cell)
		end,1)
end
function create(id)
	layoutMain = Layout:create()
	layoutMain:setName("Activity_Select_Hard_Layout")
	if (layoutMain) then
		UIHelper.registExitAndEnterCall(layoutMain,
				function()
					layoutMain=nil
				end,
				function()
				end
			) 
		--test
		require "script/module/copyActivity/ChanglageSelectHardView"
		local mainLayout=ChanglageSelectHardView.create()

		--local mainLayout = g_fnLoadUI("ui/acopy_choose.json")
		mainLayout:setSize(g_winSize)
		layoutMain:addChild(mainLayout)

		local backBtn = g_fnGetWidgetByName(layoutMain, "BTN_CLOSE")
		backBtn:addTouchEventListener(UIHelper.onClose)

		

		--初始化贝利奖励
		local db=DB_Activitycopy.getDataById(id)
		local openLv=lua_string_split(db.limit_lv, "|")
		local tbUserInfo = UserModel.getUserInfo()
		local level = tonumber(tbUserInfo.level)
		local openStatus={}
		local function onSelectHard(sender, eventType)
			local difficult=sender:getTag()
			local bFocus = sender:isFocused()
			if (bFocus) then
				sender:setScale(0.75)
				local hardBg = g_fnGetWidgetByName(layoutMain, "LAY_CELL"..difficult)
				hardBg:removeNodeByTag(100)
				fancaAni = UIHelper.createArmatureNode({
						filePath = "images/effect/acopy_choose/acopy_choose.ExportJson",
						animationName = clickAnimType[difficult],
						loop = 0
					})
				 fancaAni:setPosition(sender:getPosition())
				 hardBg:addNode(fancaAni,1,100)
			else
				sender:setScale(0.9)
				local hardBg = g_fnGetWidgetByName(layoutMain, "LAY_CELL"..difficult)
				hardBg:removeNodeByTag(100)
			end
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect() 
				
				if (openStatus[difficult].open==false) then
					if (openStatus[difficult].level==999) then
						ShowNotice.showShellInfo(gi18n[4315]) --TODO"该难度暂未开启"
					else
						ShowNotice.showShellInfo(openStatus[difficult].level..gi18n[5531])--"级开启"
					end
					return
				end
				--LayerManager.removeLayout()
				require "script/module/copyActivity/ChanglageMonster"
				local monster = ChanglageMonster.create(id,difficult)
				LayerManager.addLayout(monster)
			end
		end
		local removeItemNum=0
		for i,v in ipairs(openLv) do
			if (i>=7) then
				break
			end
			local hardBtn = g_fnGetWidgetByName(layoutMain, "BTN_HARD"..i)
			hardBtn:setTag(i)
			--local lock = g_fnGetWidgetByName(hardBtn, "IMG_LOCK")
			local openLv = g_fnGetWidgetByName(hardBtn, "TFD_LEVEL")
			local openJi = g_fnGetWidgetByName(hardBtn, "TFD_JI")
			local openLb = g_fnGetWidgetByName(hardBtn, "TFD_OPEN")
			UIHelper.labelNewStroke(openLv, ccc3(0x28,0x00,0x00), 2)
			UIHelper.labelNewStroke(openJi, ccc3(0x28,0x00,0x00), 2)
			UIHelper.labelNewStroke(openLb, ccc3(0x28,0x00,0x00), 2)
			local openLock = g_fnGetWidgetByName(hardBtn, "IMG_LOCK")
			openLock:setVisible(false)
			local openLay = g_fnGetWidgetByName(hardBtn, "IMG_ZHEZHAO")
			openLay:setVisible(false)
			if (tonumber(v)==999) then
				openLv:setText(gi18n[4316])--"暂未开启"
				removeItemNum=removeItemNum+1
			else
				openLv:setText(v)--"级开启".gi18n[5531]
			end
			openStatus[i]={}
			openStatus[i].level=tonumber(v)
			if (level<tonumber(v)) then
				openStatus[i].open=false
				--lock:setVisible(true)
				openLv:setVisible(true)
				openJi:setVisible(true)
				openLb:setVisible(true)
				openLock:setVisible(true)
				openLay:setVisible(true)
				hardBtn:setTouchEnabled(true)
				-- hardBtn:setBright(false)
			else
				openStatus[i].open=true
				--lock:setVisible(false)
				hardBtn:setBright(true)
				openLv:setVisible(false)
				openJi:setVisible(false)
				openLb:setVisible(false)
				hardBtn:setTouchEnabled(true)
				curOpenMaxLevel = i
			end
			hardBtn:addTouchEventListener(onSelectHard)
		end
		local list = g_fnGetWidgetByName(layoutMain, "LSV_MAIN")
		for i=1,removeItemNum do
			list:removeLastItem()
		end

	end
	setListPostion()
	LayerManager.addLayoutNoScale(layoutMain)
end
