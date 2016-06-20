-- FileName: MainFdsView.lua
-- Author: xianghuiZhang
-- Date: 2014-04-00
-- Purpose: 好友列表ui显示
--[[TODO List]]

module("MainFdsView", package.seeall)

require "script/module/friends/recomdFdsCtrl"
--require "script/module/friends/staminaFdsCtrl"
require "script/module/friends/MainFdsData"
require "script/module/public/Cell/FriendsCell"
require "script/module/public/HZListView"
require "script/module/friends/FriendsApplyCtrl"

-- UI控件引用变量 --
local jsonFdsbg = "ui/friends_bg.json"
local jsonFdsyeqian = "ui/friends_yeqian.json"
local jsonFdsMine = "ui/friends_mine.json"
local jsonFdsComtion = "ui/friends_communication.json"
local jsonFdsMsg = "ui/friends_message.json"

local selectColor = ccc3(255,255,255)
local normalColor = ccc3(191,147,103)

-- 模块局部变量 --
local fdsbgLayer --背景layer
local fdsyeqianLayer --页签
local fdsMineLayer = nil --我的好友
local fdsRecommend = nil --推荐好友
local fdsStamina = nil --耐力界面
local fdsApplyLayer = nil

local listView = nil
local m_layCell = nil
local tfdNum1 --好友数量label

local btnMine  --w我的好友
local btnRecommend  --推荐好友
local btnRecieve    --领取耐力
local btnApply		--好友申请

local nCurIndex=0

msg_input = nil --留言控件

local fnOnCallBack --点击事件集合
local m_fnGetWidget = g_fnGetWidgetByName
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)
	fdsMineLayer = nil
	fdsRecommend = nil
	fdsStamina = nil
	fdsApplyLayer = nil
	fdsyeqianLayer = nil
	listView = nil
	nCurIndex = 0
end

function destroy(...)
	package.loaded["MainFdsView"] = nil
end

function moduleName()
    return "MainFdsView"
end

--------------我的好友列表--------------
--[[
tbView = {szView = CCSize, szCell = CCSize, tbDataSource = table_array,
                CellAtIndexCallback = func, CellTouchedCallback = func, didScrollCallback = func, didZoomCallback = func}
--]]
local function cellAtIndex( tbData, idx)
	local cell = FriendsCell:new({cell = m_layCell,cellType = 1})
	cell:init(tbData)
	cell:refresh(tbData,idx,1)
	return cell
end

function initListView(  )
	local LAY_FORTBV = m_fnGetWidget(fdsMineLayer,"LAY_FORTBV")
	LAYCELL = m_fnGetWidget(LAY_FORTBV,"LAY_CELL")
	m_layCell = LAYCELL:clone()
	m_layCell:setScale(g_fScaleX)
	m_layCell:retain()
	local tbView = {}
	tbView.szView = CCSizeMake(LAY_FORTBV:getSize().width,LAY_FORTBV:getSize().height)
	tbView.szCell = CCSizeMake(m_layCell:getSize().width ,m_layCell:getSize().height + 10)
	tbView.CellAtIndexCallback = cellAtIndex
	tbView.tbDataSource = MainFdsData.getPageFdsData(fnOnCallBack)

	listView = HZListView:new()
	if (listView:init(tbView)) then
        local hzLayout = TableViewLayout:create(listView:getView())
        LAY_FORTBV:addChild(hzLayout)
        listView:refresh()
    end

    LAYCELL:removeFromParentAndCleanup(true)
end

function updateListView( ... )
	if (listView) then
		listView:changeDataSource(MainFdsData.getPageFdsData(fnOnCallBack))
	end 
end

function updateListCell( idx )
	if (idx and listView) then
		listView:changeData(MainFdsData.getPageFdsData(fnOnCallBack))
		listView:updateCellAtIndex(idx)
	end
end

function updateAllListCell()
	if (listView) then
		listView:changeData(MainFdsData.getPageFdsData(fnOnCallBack))
		listView:reloadDataByOffset() --liweidong 重画列表
	end
end

function insertMoreListCell(preData)
	if (listView) then
		local curData = MainFdsData.getPageFdsData(fnOnCallBack)
		logger:debug("insertMoreListCell")
		logger:debug(curData)
		listView:changeData(curData)
		local moreNum = #curData - #preData
		logger:debug(moreNum)
		listView:reloadDataByInsertData(moreNum)
	end
end

--------------好友交流--------------
function fnRecomdLayer( figure )
	local fdsComtion = g_fnLoadUI(jsonFdsComtion)
	LayerManager.addLayout(fdsComtion)

	local btnColse = m_fnGetWidget(fdsComtion,"BTN_CLOSE")
	btnColse:addTouchEventListener(fnOnCallBack.onBtnCommt)

	local btnBack = m_fnGetWidget(fdsComtion,"BTN_BACK")
	UIHelper.titleShadow(btnBack,gi18n[6701])
	btnBack:addTouchEventListener(fnOnCallBack.onBtnPVP)
	
	local btnMessage = m_fnGetWidget(fdsComtion,"BTN_MESSAGE")
	UIHelper.titleShadow(btnMessage,m_i18n[2917])
	btnMessage:addTouchEventListener(fnOnCallBack.onBtnMsg)
	
	local btnFormation = m_fnGetWidget(fdsComtion,"BTN_FORMATION")
	UIHelper.titleShadow(btnFormation,m_i18n[2918])
	btnFormation:addTouchEventListener(fnOnCallBack.onBtnFor)
	
	local btnRemove = m_fnGetWidget(fdsComtion,"BTN_REMOVE")
	UIHelper.titleShadow(btnRemove,m_i18n[2919])
	btnRemove:addTouchEventListener(fnOnCallBack.onBtnRemove)
	
	local fdsInfo = m_fnGetWidget(fdsComtion,"TFD_INFO2")
	fdsInfo:setText(MainFdsData.getMsgName())
	UIHelper.labelStroke(fdsInfo)

	local nameColor = UserModel.getPotentialColor({htid=figure,bright=true})
	fdsInfo:setColor(nameColor)
end


--------------好友留言--------------
function fnMsgLayer( ... )
	local fdsMsg = g_fnLoadUI(jsonFdsMsg)
	LayerManager.addLayout(fdsMsg)

	local btnColse = m_fnGetWidget(fdsMsg,"BTN_CLOSE")
	btnColse:addTouchEventListener(fnOnCallBack.onBtnCommt)

	local btnBack = m_fnGetWidget(fdsMsg,"BTN_BACK")
	UIHelper.titleShadow(btnBack,m_i18n[1019])
	btnBack:addTouchEventListener(fnOnCallBack.onBtnCommt)
	
	local btnSend = m_fnGetWidget(fdsMsg,"BTN_SEND")
	UIHelper.titleShadow(btnSend,m_i18n[2159])
	btnSend:addTouchEventListener(fnOnCallBack.onBtnSend)
	
	local ImgMsg = m_fnGetWidget(fdsMsg,"img_message_bg")
	msg_input = UIHelper.createEditBox(CCSizeMake(ImgMsg:getSize().width-20, ImgMsg:getSize().height-5), nil, true)
    msg_input:setAnchorPoint(ccp(0, 0))
    msg_input:setPlaceHolder(m_i18n[2903]);
    msg_input:setFontColor(ccc3(0x82, 0x56, 0))
    msg_input:setFontSize(26)
    msg_input:setMaxLength(100);
    msg_input:setReturnType(kKeyboardReturnTypeDone)
    -- msg_input:setInputMode(kEditBoxInputModeAny)
    msg_input:setPosition(ccp(-ImgMsg:getSize().width/2,-ImgMsg:getSize().height / 2))
	ImgMsg:addNode(msg_input,999,999)

end

function updateFdsNum( ... )
	local friendsData = MainFdsData.getFriendsList()
	tfdNum1:setText(table.count(friendsData))
end

--我的好友界面
local function fnMineFdsLayer( ... )
	listView = nil
	
	fdsMineLayer = g_fnLoadUI(jsonFdsMine)

	-- zhangqi, 2014-07-17, 注册UI被remove的回调，将TableView的引用置为nil，避免后端推送刷新时刷新不存在的UI
	UIHelper.registExitAndEnterCall(fdsMineLayer, function ( ... )
		if (LayerManager.getChangModuleType()~=1) then 
			if(m_layCell)then 
				m_layCell:release()
				m_layCell = nil
			end 
			if(listView)then 
				listView:removeView()
				listView = nil
			end 
		end 
	end)
	fdsbgLayer:addChild(fdsMineLayer)

	tfdNum1 = m_fnGetWidget(fdsMineLayer,"TFD_FRIENDS_NUM1")
	local tfdNum3 = m_fnGetWidget(fdsMineLayer,"TFD_FRIENDS_NUM3")
	-- UIHelper.labelStroke(tfdNum1)
	UIHelper.labelShadow(tfdNum1,CCSizeMake(3, -3))
	-- UIHelper.labelStroke(tfdNum3)
	UIHelper.labelShadow(tfdNum3,CCSizeMake(3, -3))

	local tfdFdOwn = m_fnGetWidget(fdsMineLayer,"tfd_friends_own")
	UIHelper.labelAddStroke(tfdFdOwn,m_i18n[2924])
	UIHelper.labelShadow(tfdFdOwn,CCSizeMake(3, -3))

	local friendsData = MainFdsData.getFriendsList()
	tfdNum1:setText(table.count(friendsData))
	tfdNum3:setText("500")

	local layNofriends = m_fnGetWidget(fdsMineLayer,"LAY_NOFRIENDS")
			-- 当前无好友
	local tfd_tip = m_fnGetWidget(fdsMineLayer,"TFD_TIP") 
	UIHelper.labelNewStroke(tfd_tip, ccc3(0x28,0,0),2)

	local layFortbv = m_fnGetWidget(fdsMineLayer,"LAY_FORTBV")

	-- 好友数量
	UIHelper.labelNewStroke(fdsMineLayer.tfd_friends_own, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsMineLayer.TFD_FRIENDS_NUM1, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsMineLayer.TFD_FRIENDS_NUM2, ccc3(0x28,0,0),2)
	UIHelper.labelNewStroke(fdsMineLayer.TFD_FRIENDS_NUM3, ccc3(0x28,0,0),2)

	if (table.count(friendsData) > 0) then
		layNofriends:setVisible(false)
		layFortbv:setVisible(true)
		initListView()
		fnOnCallBack.updateFdsData()
	else
		local btnAdd = m_fnGetWidget(fdsMineLayer,"BTN_ADD_FRIENDS")
		UIHelper.titleShadow(btnAdd,m_i18n[2921])
		btnAdd:addTouchEventListener(fnOnCallBack.onBtnAddFds)

		layNofriends:setVisible(true)
		layFortbv:setVisible(false)
	end
end

--推荐好友界面
local function fnRecommendLayer( ... )
	fdsRecommend = recomdFdsCtrl.create()
	fdsbgLayer:addChild(fdsRecommend)
end

--领取耐力界面
local function fnStaminaLayer( ... )
	fdsStamina = staminaFdsCtrl.create()
	fdsbgLayer:addChild(fdsStamina)
end

-- 好友申请
local function fnFriendsApplyLayer( ... )
	fdsApplyLayer = FriendsApplyCtrl.create()
	fdsbgLayer:addChild(fdsApplyLayer)
end

-- 判定当前页
function getCurrentIndex( ... )
	return nCurIndex
end


function onSelectFocus( tag)

	LayerManager.addUILoading()

	if(fdsMineLayer) then
		fdsMineLayer:removeFromParentAndCleanup(true)
		fdsMineLayer = nil
	end 

	if(fdsStamina) then
		fdsStamina:removeFromParentAndCleanup(true)
		fdsStamina = nil
	end

	if(fdsRecommend) then
		fdsRecommend:removeFromParentAndCleanup(true)
		fdsRecommend = nil
	end

	if(fdsApplyLayer)then 
		fdsApplyLayer:removeFromParentAndCleanup(true)
		fdsApplyLayer = nil
	end 

	nCurIndex = tag

	local tbButton = {btnMine,btnRecommend,btnRecieve,btnApply}
	for i=1,#tbButton do 
		tbButton[i]:setFocused(i==tag)
		tbButton[i]:setTouchEnabled(i~=tag)
		tbButton[i]:setTitleColor(tag==i and selectColor or normalColor)
	end 

	local tbFnLayer = {fnMineFdsLayer,fnRecommendLayer,fnStaminaLayer,fnFriendsApplyLayer}
	tbFnLayer[tag]()

	LayerManager.begainRemoveUILoading()

end

function updateStaminaTip( ... )
	if (fdsyeqianLayer) then
		local imgTip = m_fnGetWidget(fdsyeqianLayer,"IMG_TIP")
		staminaFdsCtrl.setTipWidget(imgTip)
	end
end

function updateApplyTip( ... )
	if (fdsyeqianLayer) then
		local imgTip = m_fnGetWidget(fdsyeqianLayer,"IMG_TIP_APPLY")
		require "script/module/friends/FriendsApplyModel"
		FriendsApplyCtrl.setTipWidget(imgTip)
	end
end

function create(callBack)
	init()

	fnOnCallBack = callBack

	fdsbgLayer = g_fnLoadUI(jsonFdsbg)

	local imgBg = m_fnGetWidget(fdsbgLayer, "IMG_BG")
	imgBg:setScale(g_fScaleX) -- zhangqi, 2014-08-28, redmine 功能 #13011
	
	fdsyeqianLayer = g_fnLoadUI(jsonFdsyeqian)
	fdsbgLayer:addChild(fdsyeqianLayer)

	 -- zhangqi, 2014-08-28, redmine 功能 #13011
	local imgChain = m_fnGetWidget(fdsyeqianLayer, "img_chain")
	imgChain:setScale(g_fScaleX)
	local imgYeqianBG = m_fnGetWidget(fdsyeqianLayer, "IMG_BG")
	imgYeqianBG:setScale(g_fScaleX)
	local layInfo = m_fnGetWidget(fdsyeqianLayer, "LAY_INFO")
	local szOrigInfo = layInfo:getSize()
	layInfo:setSize(CCSizeMake(szOrigInfo.width*g_fScaleX, szOrigInfo.height*g_fScaleX))

	btnMine = m_fnGetWidget(fdsyeqianLayer,"BTN_MY_FRIENDS")
	btnMine:setTag(1)
	btnMine:addTouchEventListener(fnOnCallBack.onBtnFocus)
	UIHelper.titleShadow(btnMine,m_i18n[2904])

	btnRecommend = m_fnGetWidget(fdsyeqianLayer,"BTN_RECOMMEND")
	btnRecommend:setTag(2)
	btnRecommend:addTouchEventListener(fnOnCallBack.onBtnFocus)
	UIHelper.titleShadow(btnRecommend,m_i18n[2905])

	btnRecieve = m_fnGetWidget(fdsyeqianLayer,"BTN_RECIEVE")
	btnRecieve:setTag(3)
	btnRecieve:addTouchEventListener(fnOnCallBack.onBtnFocus)
	UIHelper.titleShadow(btnRecieve,m_i18n[2906])

	btnApply = m_fnGetWidget(fdsyeqianLayer,"BTN_APPLY")
	btnApply:setTag(4)
	btnApply:addTouchEventListener(fnOnCallBack.onBtnFocus)
	UIHelper.titleShadow(btnApply,m_i18n[2849])   --"好友申请"

	local returnBack = m_fnGetWidget(fdsyeqianLayer,"BTN_BACK")
	returnBack:addTouchEventListener(fnOnCallBack.onBtnClose)
	UIHelper.titleShadow(returnBack,m_i18n[1019])

	UIHelper.addCallbackOnExit(fdsbgLayer, destroy) -- zhangqi, 20140627, 绑定destroy方法到UI的onExit

	return fdsbgLayer
end
