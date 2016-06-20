-- FileName: MainDailyTaskView.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

module("MainDailyTaskView", package.seeall)
require "script/module/dailyTask/MainDailyTaskData"
require "script/module/public/ShowNotice" 
require "script/module/switch/SwitchModel"
-- UI控件引用变量 --
-- 资源文件
local dailyTaskJson = "ui/day_task.json"  

-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName
local m_ListView
local nTotalScore   = 0-- the total score of user 
local tbTaskInfo    -- 存在MainDailyTaskData中的每日任务数据
local tbAllTasks  
-- local tfdCopper
-- local tfdGold
-- local tfdSliver
local rewardAnimationTag = 10
local btnFirst
local btnSecond
local btnThird
local m_i18n = gi18n
local labnScorehave
local labnScoreAll	
local layDailyTask 

local btnEff1
local btnEff2
local btnEff3

local nAniTag1 = 1235
local nAniTag2 = 1236
local nProgressTag = 123456

local function init(...)
  
end

function destroy(...)
	package.loaded["MainDailyTaskView"] = nil
end

function moduleName()
    return "MainDailyTaskView"
end
local animationPath = "images/effect/"
--宝箱动画
local function fnAnimationOpenBox( rewardBtn,anitName,anchor,playname)

	local m_arAni1 = UIHelper.createArmatureNode({
		filePath = animationPath..anitName.."/"..anitName..".ExportJson",
		animationName = playname,
	})

	m_arAni1:setTag(rewardAnimationTag)
	local size = rewardBtn:getSize()
	m_arAni1:setPosition(ccp(0,size.height/2))

	local pNode = rewardBtn:getNodeByTag(rewardAnimationTag) or nil
	if (pNode) then
		rewardBtn:removeNode(pNode)
	end
	 
	rewardBtn:addNode(m_arAni1)
end

-- 奖励领取特效
local function addGetRewardAni( node,callback )
	LayerManager.addUILoading()
	local animation
	local function fnMovementCallBack( armature,movementType,movementID )
		if(movementType == 1) then
			animation:removeFromParentAndCleanup(true)
			LayerManager.begainRemoveUILoading()
		end
	end

	animation = UIHelper.createArmatureNode({
		filePath = "images/effect/dailyTask/task_over.ExportJson",
		animationName = "task_over",
		loop = 0,
		fnMovementCall = fnMovementCallBack,
		fnFrameCall = callback,
		bRetain = true,
	})

	-- node:removeChildByTag(nAniTag2,true)
	node:addNode(animation)
	-- animation:setTag(nAniTag2)
	animation:setZOrder(1000)
	animation:setPosition(ccp(0, 0))
	AudioHelper.playSpecialEffect("texiao_kapaizhuandong.mp3")
end

-- 进度条更新
function updateProcessBar( )
	local pProgress = m_fnGetWidget(layDailyTask,"LOAD_PROGRESS")
	local newScore = tonumber(tbTaskInfo.point)

	nTotalScore = 0
 	for i=1,#tbAllTasks do
 		nTotalScore = nTotalScore + tonumber(tbAllTasks[i].score)
 	end

	local proNode = pProgress:getNodeByTag(nProgressTag)
	proNode:setVisible(true)
	proNode:setPercentage(pProgress:getPercent())
	local per = (newScore/(tonumber(nTotalScore)) or 0) * 100
	per = per < 100 and per or 100
	local array = CCArray:create()
	array:addObject(CCProgressTo:create(1 ,per))
	array:addObject(CCCallFunc:create(function( ... )
			pProgress:setPercent(per)
			proNode:setVisible(false)
				end))

	proNode:runAction(CCSequence:create(array))

	labnScorehave:setText(tbTaskInfo.point)
	labnScoreAll:setText(nTotalScore)
	addButtonEvent(1,btnFirst)
	addButtonEvent(2,btnSecond)
	addButtonEvent(3,btnThird)
end 



-- 奖励面板页面
local function showRewardLayer( taskId )
	local taskPrize  = tbTaskInfo.va_active.task_prize
	local length  = 1

	if ((taskPrize ~= nil) and (#taskPrize~=0)) then
  		length = #taskPrize + 1 
  		taskPrize[length] = taskId
  	else
  		tbTaskInfo.va_active.task_prize={}
  		tbTaskInfo.va_active.task_prize[1] = taskId
  	end 
	
  	local tbTask  = MainDailyTaskData.getAwardInfo(taskId)

	-- 通用奖励面板
	local ptbInfos = RewardUtil.parseRewards(tbTask.reward , true)
	local p_layReward = UIHelper.createRewardDlg(ptbInfos,function ( ... )
		LayerManager.removeLayout()  --删除奖励页面
	  	-- refreshListView()  --liweidong 领取任务奖励不需要刷宝箱奖励吧。。
	  	UIHelper.reloadListView(m_ListView,#tbAllTasks,updateListCell)
		require "script/module/achieve/MainAchieveView"
	  	MainAchieveView.updateUI()
	end)
	LayerManager.addLayoutNoScale(p_layReward)

  	MainDailyTaskData.setDailyTaskInfo(tbTaskInfo)
 	tbAllTasks = MainDailyTaskData.getAllTasks(tbTaskInfo)
end

-- 领取每个任务奖励
function getTaskPrize( sender ,eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playBtnEffect("anniu_lingjiangli.mp3")

		local pTaskId = sender.taskId
		local tbTask  = MainDailyTaskData.getAwardInfo(pTaskId)

		local function getPrizeTaskCallBack(cbFlag,dictData,bRet)
			logger:debug("奖励领取")
			logger:debug(dictData)
			logger:debug(bRet)

			if (not bRet) then 
				return 
			end 

			if(dictData.ret=="ok" and dictData.err=="ok") then

				tbTaskInfo.point = tonumber(tbTaskInfo.point) + tbTask.score  --刷新积分
				updateProcessBar()
				addGetRewardAni(sender,function ( ... )
					showRewardLayer(pTaskId)
				end)
			else
				-- assert(dictData.ret=="ok","错误奖励id:" .. pTaskId) 
			  	UIHelper.reloadListView(m_ListView,#tbAllTasks,updateListCell)
				require "script/module/achieve/MainAchieveView"
			  	MainAchieveView.updateUI()
			end 
		end

		
		if(not MainDailyTaskData.judgeBagIsFull(tbTask.reward)) then  --判定背包是否已满
			local args = CCArray:create()
		    args:addObject(CCInteger:create(pTaskId))
			RequestCenter.getTaskPrize(getPrizeTaskCallBack,args)
		end
	end
end


--[[
    @des:       显示宝箱的奖励内容
    @return:    prizeId: 宝箱的Id
    			isGet: 1 没有领取过
    			  	   2 可以领取了
    			  	   3 领取完了
]]					   
local function showRewardInfo( prizeId ,isGet)
	local tbItem 			= MainDailyTaskData.getRewardInfoById(prizeId)
	local layReward 		 
	local taskPrize  		= tbTaskInfo.va_active.prize

	local redwardInfo 		= MainDailyTaskData.getDB_rewardInfo(prizeId)
  	local length  			= 1
  	---领取宝箱的奖励
	local function getPrize()
		local function getPrizeCallBack(  cbFlag, dictData, bRet  )
			if(bRet) then

				local redwardInfo = MainDailyTaskData.getDB_rewardInfo(prizeId)
				if (taskPrize~=nil) then
				  	length = #taskPrize + 1 
				  	taskPrize[length] = redwardInfo.id
			  	else
				  	tbTaskInfo.va_active.prize={}
				  	tbTaskInfo.va_active.prize[1] = redwardInfo.id
			  	end 
	  			MainDailyTaskData.setDailyTaskInfo(tbTaskInfo)

				local pBtn = nil
				local pBtn2 = nil
				if(prizeId == 1) then
					pBtn = btnEff1
					pBtn2 = btnFirst
				elseif (prizeId == 2) then
					pBtn = btnEff2
					pBtn2 = btnSecond
				elseif (prizeId == 3) then
					pBtn = btnEff3
					pBtn2 = btnThird
				end
				local pNode = pBtn:getNodeByTag(rewardAnimationTag) or nil
				if (pNode) then
					pBtn:removeNode(pNode)
				end
				local pNode2 = pBtn2:getNodeByTag(rewardAnimationTag) or nil
				if (pNode2) then
					pBtn2:removeNode(pNode2)
				end
				-- showRewardInfo(prizeId)
				-- nTotalScore = 0
				-- MainDailyTaskData.addPrizeToUser(prizeId)    --?????????
				refreshListView()
				require "script/module/achieve/MainAchieveView"
		  		MainAchieveView.updateUI()
				LayerManager.removeLayout()

		  		local ptbInfos = RewardUtil.parseRewards(redwardInfo.reward , true)

		  		logger:debug(ptbInfos)


		  		local p_layReward = UIHelper.createRewardDlg(ptbInfos)
				-- local p_tbItem 	= MainDailyTaskData.getRewardInfoById(prizeId)
				-- local p_layReward = createGetRewardInfoDlg( "每日任务", p_tbItem,nil,m_i18n[1322])
				LayerManager.addLayoutNoScale(p_layReward)
			end
		end

		local redwardInfo = MainDailyTaskData.getDB_rewardInfo(prizeId)
		local rewardArray  = string.split(redwardInfo.reward, ",")	
		local isBagFull = false

		isBagFull = MainDailyTaskData.judgeBagIsFull(redwardInfo.reward) 
		if(not isBagFull) then
			local args = CCArray:create()
	    	args:addObject(CCInteger:create(redwardInfo.id))
			RequestCenter.getPrize(getPrizeCallBack,args)
		end
	end
	

  	if (tonumber(isGet) == 2) then 
    	layReward = createGetRewardInfoDlg( m_i18n[1982], tbItem,getPrize,m_i18n[1934],m_i18n[2628])
    elseif (tonumber(isGet) == 1) then
    	layReward = createGetRewardInfoDlg( m_i18n[1982], tbItem,nil,gi18nString(1933,redwardInfo.needScore))
	elseif (tonumber(isGet) == 3) then
		layReward = createGetRewardInfoDlg( m_i18n[1982], tbItem,nil,m_i18n[1322])
    end
  	
  	if(layReward) then
		LayerManager.addLayout(layReward)
	end
end


-- 奖励按钮可领取特效
local function addAnimation( node,tag )
	local animation1 = UIHelper.createArmatureNode({
		filePath = "images/effect/dailyTask/task_get.ExportJson",
		animationName = "task_get",
		loop = 1,
		bRetain = true,
	})

	node:removeChildByTag(tag,true)
	node:addNode(animation1)
	animation1:setTag(tag)
	animation1:setZOrder(1000)

	local IMG_REACHED = node.IMG_REACHED
	local posx,posy = IMG_REACHED:getPosition()
	animation1:setPosition(ccp(posx, posy))
end

--更新cell
function updateListCell(list,idx)
	local originCell = tolua.cast(list:getItem(idx),"Widget")
	local cell = originCell.item
	local i = idx+1

    cell.IMG_CAN_GET:setVisible(false)

    cell.TFD_PROGRESS:setVisible(true)
    cell.lay_progress:setVisible(true)

    local nId 				  = tbAllTasks[i].id..""   --任务id
    local tasks  			  = tbTaskInfo.va_active.task
    local taskPrize  		  = tbTaskInfo.va_active.task_prize
 
    local redwardInfo 		  = MainDailyTaskData.getAwardInfo(nId)

    cell.TFD_ITEM_NAME:setText(redwardInfo.rewardName)
    cell.TFD_ITEM_NUM:setText("X"..redwardInfo.num)

	
	cell.IMG_ICON:loadTexture("images/base/props/" .. redwardInfo.icon )
	cell.IMG_ICON_BG:loadTexture("images/base/potential/color_" .. tbAllTasks[i].quality .. ".png")

	cell.IMG_ICON:removeChildByTag(100, true)
	local iconBorder = ImageView:create()
	iconBorder:loadTexture("images/base/potential/equip_" .. tbAllTasks[i].quality .. ".png")
	iconBorder:setTag(100)
	cell.IMG_ICON:addChild(iconBorder)

	-- cell:setSize(CCSizeMake(cell:getSize().width * g_fScaleX , cell:getSize().height * g_fScaleX))

	cell.TFD_DESC:setText(redwardInfo.taskDes)
    cell.BTN_GO:setEnabled(true)
    cell.BTN_BG:setTouchEnabled(false)
    cell.IMG_REACHED:setVisible(false)
    cell.TFD_NAME:setText(tbAllTasks[i].name)
    cell.TFD_REWARD_NUM:setText("X"..tbAllTasks[i].score)
    cell.TFD_RIGHT_NUM:setText(tbAllTasks[i].needNum)
    cell.TFD_LEFT_NUM:setText(0)
    
	cell.BTN_GO:addTouchEventListener(function ( sender ,eventType )   
                                        if (eventType == TOUCH_EVENT_ENDED) then
                                			AudioHelper.playCommonEffect()
                                			setEventOfBtn(tbAllTasks[i].type,tbAllTasks[i].switch)        	
                                        end 
                                end)

	cell.BTN_BG:loadTextureNormal("ui/bag_cell_1_bg.png")
   	cell.BTN_BG:loadTexturePressed("ui/bag_cell_1_bg.png")
   	cell.img_info_bg:loadTexture("ui/bag_cell_txt_1_bg.png")

   	cell.BTN_BG.taskId = nId   --防止复用时任务id错乱

    if tasks then  -- 判断 是否任务完成
        if tasks[nId] then
           cell.TFD_LEFT_NUM:setText(tasks[nId])
           if tonumber(tasks[nId]) >= tonumber(tbAllTasks[i].needNum) then                                        
           		cell.BTN_GO:setEnabled(false)
           		cell.BTN_BG:setTouchEnabled(true)
           		cell.BTN_BG.taskId = nId
           		cell.BTN_BG:addTouchEventListener(getTaskPrize)
           		
           		cell.TFD_PROGRESS:setVisible(false)
           		cell.lay_progress:setVisible(false)
				cell.img_info_bg:loadTexture("images/common/cell/bag_cell_txt_3_bg.png")
				cell.BTN_BG:loadTextureNormal("images/common/cell/bag_cell_3_bg.png")
				cell.BTN_BG:loadTexturePressed("images/common/cell/bag_cell_3_bg.png")
				
           end 
        end
    end
    
    if taskPrize then -- 判断是否已经领取奖励
    	for j=1,#taskPrize do
    		if tonumber(tbAllTasks[i].id) == tonumber(taskPrize[j]) then
    			cell.BTN_GO:setEnabled(false)

           		cell.BTN_BG:setTouchEnabled(false)
           		cell.IMG_REACHED:setVisible(true)
           		cell.TFD_PROGRESS:setVisible(false)
           		cell.lay_progress:setVisible(false)
				-- cell.img_info_bg:loadTexture("ui/bag_cell_txt_1_bg.png")
				-- cell.BTN_BG:loadTextureNormal("ui/bag_cell_1_bg.png")
				-- cell.BTN_BG:loadTexturePressed("ui/bag_cell_1_bg.png")
    		end
    	end
    end
     
    cell.BTN_BG:removeNodeByTag(nAniTag1)
    if (cell.BTN_BG:isTouchEnabled()) then 
		addAnimation(cell.BTN_BG,nAniTag1)
    end 
end
function refreshListView(  )   --liweidong修改 之前是刷listview和宝箱 现在只刷宝箱
	-- m_ListView:requestDoLayout()
	addButtonEvent(1,btnFirst)
	addButtonEvent(2,btnSecond)
	addButtonEvent(3,btnThird)
	nTotalScore = 0
 	for i=1,#tbAllTasks do
 		nTotalScore = nTotalScore + tonumber(tbAllTasks[i].score)
 	end
	-- labnScorehave:setStringValue(tbTaskInfo.point)
	labnScorehave:setText(tbTaskInfo.point)
	labnScoreAll:setText(nTotalScore)
	local pProgress = m_fnGetWidget(layDailyTask,"LOAD_PROGRESS")
	local pNum = tonumber(tbTaskInfo.point)/tonumber(nTotalScore) or 0
	pNum = pNum > 1 and 1 or pNum
	pProgress:setPercent(pNum*100)
end

local function removeEffect( rewardBtn )
	local pNode = rewardBtn:getNodeByTag(rewardAnimationTag) or nil
	if (pNode) then
		rewardBtn:removeNode(pNode)
	end
end
--  rewardId 奖励类型 1 copper  2 sliver 3 gold   falg: 宝箱状态 0 关闭 ， 1，打开 ，3空了
local function setButtonImg( type ,falg) 

	if tonumber(type) == 1 then
		if tonumber(falg) == 0 then 
			btnFirst:loadTextures("ui/copper_box_close_n.png","ui/copper_box_close_h.png",nil)
			removeEffect(btnFirst)
		elseif tonumber(falg) == 1 then
			btnFirst:loadTextures("ui/copper_box_open_n.png","ui/copper_box_open_h.png",nil)
			fnAnimationOpenBox(btnFirst,"copy_box",1,"copy_box_copper")
		elseif tonumber(falg) == 2 then
			btnFirst:loadTextures("ui/copper_box_empty_n.png","ui/copper_box_empty_n.png",nil)
			removeEffect(btnFirst)
		end
	end
	if tonumber(type) == 2 then
		if tonumber(falg) == 0 then 
			btnSecond:loadTextures("ui/silver_box_close_n.png","ui/silver_box_close_h.png",nil)
			removeEffect(btnSecond)
		elseif tonumber(falg) == 1 then
			btnSecond:loadTextures("ui/silver_box_open_n.png","ui/silver_box_open_h.png",nil)
			fnAnimationOpenBox(btnSecond,"copy_box",2,"copy_box_silver")
		elseif tonumber(falg) == 2 then
			btnSecond:loadTextures("ui/silver_box_empty_n.png","ui/silver_box_empty_n.png",nil)
			removeEffect(btnSecond)
		end
	end
	if tonumber(type) == 3 then
		if tonumber(falg) == 0 then 
			btnThird:loadTextures("ui/gold_box_close_n.png","ui/gold_box_close_h.png",nil)
			removeEffect(btnThird)
		elseif tonumber(falg) == 1 then
			btnThird:loadTextures("ui/gold_box_open_n.png","ui/gold_box_open_h.png",nil)
			fnAnimationOpenBox(btnThird,"copy_box",3,"copy_box_goden")
		elseif tonumber(falg) == 2 then
			btnThird:loadTextures("ui/gold_box_empty_n.png","ui/gold_box_empty_n.png",nil)
			removeEffect(btnThird)
		end
	end
end



function addButtonEvent( rewardId ,btn)
    local redwardInfo = MainDailyTaskData.getDB_rewardInfo(rewardId)
    local prizeArray  = tbTaskInfo.va_active.prize
    local flag = 0
    
    if tonumber(redwardInfo.needScore)<= tonumber(tbTaskInfo.point) then
    	if prizeArray then
    		for i=1,#prizeArray do
    			if tonumber(prizeArray[i]) == tonumber(redwardInfo.id) then
    				--btn:loadTextures("ui/copper_box_empty_n.png","ui/copper_box_empty_h.png",nil)
    				setButtonImg(rewardId,2)

    				flag = 1
    				btn:addTouchEventListener(
			   	 	function ( sender , eventType )
				   	 	if (eventType == TOUCH_EVENT_ENDED) then
							AudioHelper.playCommonEffect()
				   	 		showRewardInfo(rewardId,3)
						end		
					end)
    			end
    		end
    	end
    	if tonumber(flag) == 0 then
    		-- btn:loadTextures("ui/copper_box_open_n.png","ui/copper_box_open_h.png",nil)
    		setButtonImg(rewardId,1)
    		btn:addTouchEventListener(
	   	 	function ( sender , eventType )
		   	 	if (eventType == TOUCH_EVENT_ENDED) then
					AudioHelper.playCommonEffect()
		   	 		showRewardInfo(rewardId,2)
				end			
			end)
    	end
   		
	else
		--btn:loadTextures("ui/copper_box_close_n.png","ui/copper_box_close_h.png",nil)
		setButtonImg(rewardId,0)
		btn:addTouchEventListener(
			   	 	function ( sender , eventType )
				   	 	if (eventType == TOUCH_EVENT_ENDED) then
				   	 		AudioHelper.playCommonEffect()
				   	 		showRewardInfo(rewardId,1)
						end		
					end)
   	end
end

-- label添加描边 2px，＃280000
function LabelStroke( label )

	UIHelper.labelNewStroke(label, ccc3(0x28,0,0),2)
end

function create(...)



	layDailyTask = g_fnLoadUI(dailyTaskJson)
    local layEasyInfo = m_fnGetWidget(layDailyTask,"lay_easy_info")
    labnScorehave = m_fnGetWidget(layDailyTask,"TFD_LEFT_NUM") 
    labnScoreAll = m_fnGetWidget(layDailyTask,"TFD_RIGHT_NUM")
	btnFirst = m_fnGetWidget(layDailyTask,"BTN_COPPER")
	btnSecond = m_fnGetWidget(layDailyTask,"BTN_SLIVER")
	btnThird = m_fnGetWidget(layDailyTask,"BTN_GOLD")
	btnEff1 = m_fnGetWidget(layDailyTask,"IMG_EFFECT1")
	btnEff2 = m_fnGetWidget(layDailyTask,"IMG_EFFECT2")
	btnEff3 = m_fnGetWidget(layDailyTask,"IMG_EFFECT3")
	m_ListView = m_fnGetWidget(layDailyTask,"LSV_LIST")

	tbTaskInfo = MainDailyTaskData.getDailyTaskInfo()
	tbAllTasks = MainDailyTaskData.getAllTasks(tbTaskInfo)
	LabelStroke(layDailyTask.tfd_title)
	LabelStroke(labnScorehave)
	LabelStroke(layDailyTask.tfd_slant)
	LabelStroke(labnScoreAll)
	LabelStroke(layDailyTask.tfd_num_copper)
	LabelStroke(layDailyTask.tfd_num_sliver)
	LabelStroke(layDailyTask.tfd_num_gold)

 	local baseBalue = MainDailyTaskData.getBaseValue()
	layDailyTask.tfd_num_copper:setText(string.format(m_i18n[1997],baseBalue[1]))
	layDailyTask.tfd_num_sliver:setText(string.format(m_i18n[1997],baseBalue[2]))
	layDailyTask.tfd_num_gold:setText(string.format(m_i18n[1997],baseBalue[3]))


	layEasyInfo:setScale(g_fScaleX)

    btnFirst:setVisible(true)
    btnSecond:setVisible(true)
    btnThird:setVisible(true)
	local dCell = m_ListView:getItem(0)
	UIHelper.titleShadow(dCell.BTN_GO)
    dCell.tfd_score_title:setText(m_i18n[1988])
	dCell:setSize(CCSizeMake(dCell:getSize().width*g_fScaleX,dCell:getSize().height*g_fScaleX))
	dCell.BTN_BG:setScale(g_fScaleX)

	UIHelper.initListViewCell(m_ListView)
	refreshListView()
    m_ListView:setTouchEnabled(true)
    -- nTotalScore = 0
    UIHelper.reloadListView(m_ListView,#tbAllTasks,updateListCell,nil,true)
    

    UIHelper.registExitAndEnterCall(layDailyTask,function ( ... )
    	UIHelper.removeArmatureFileCache()
    end)
 
    local pProgress = m_fnGetWidget(layDailyTask,"LOAD_PROGRESS")
    local progressTimer = UIHelper.fnGetProgress("ui/progress_daytask.png")
    pProgress:addNode(progressTimer)
    progressTimer:setTag(nProgressTag)
    progressTimer:setVisible(false)


    return layDailyTask
end


--根据任务类型，为button 设置不同的跳转事件 
function setEventOfBtn( nType, nSwitch)
	local pSwitch = tonumber(nSwitch) or -1
	if(pSwitch ~= -1) then
		if(tonumber(nType) == 16) then
			if(not SwitchModel.getSwitchOpenState(pSwitch)) then
				local switchInfo = DB_Switch.getDataById(pSwitch)
				local param = switchInfo.level or "1"
				require "script/module/public/ShowNotice"
				local desc = string.format(m_i18n[1989],param)
				ShowNotice.showShellInfo(desc)
				return
			end 
		else
			if(not SwitchModel.getSwitchOpenState(pSwitch,true)) then
				return
			end 
		end
		
	end


	if (tonumber(nType) == 1) then
		require "script/module/copy/MainCopy"
		if (MainCopy.moduleName() ~= LayerManager.curModuleName()) then
			MainCopy.destroy()
			local layCopy = MainCopy.create()
			if (layCopy) then
				LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
				PlayerPanel.addForCopy()
				MainCopy.updateBGSize()
				MainCopy.setFogLayer()

				MainScene.changeMenuCircle(3)
			end
		end
	elseif (tonumber(nType) == 2) then
		require "script/module/copy/MainCopy"
		-- if(not SwitchModel.getSwitchOpenState(ksSwitchEliteCopy,true)) then
		-- 	return
		-- end 
	    local layCopy = MainCopy.create(2,false)
		if (layCopy) then
			LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
			PlayerPanel.addForCopy()
			MainCopy.updateBGSize()
			MainCopy.setFogLayer()
			MainScene.changeMenuCircle(3)
		end
	elseif (tonumber(nType) == 3) then
		require "script/module/astrology/MainAstrologyModel"
		-- if(not SwitchModel.getSwitchOpenState( ksSwitchStar ,true)) then
		-- 	return
		-- end
		MainAstrologyModel.createViewByGetAstrologyInfo()
	elseif (tonumber(nType) == 4) then
 		require "script/module/grabTreasure/MainGrabTreasureCtrl"
 	-- 	if(not SwitchModel.getSwitchOpenState(ksSwitchRobTreasure,true)) then
		-- 	return
		-- end 
 	   	MainGrabTreasureCtrl.create()
	elseif (tonumber(nType) == 5) then	
		require "script/module/arena/MainArenaCtrl"  
		-- if(not SwitchModel.getSwitchOpenState(ksSwitchArena,true)) then
		-- 	return
		-- end   
 		MainArenaCtrl.create()	
	elseif (tonumber(nType) == 6) then
		require "script/module/friends/MainFdsCtrl"
		LayerManager.changeModule(MainFdsCtrl.create(), MainFdsCtrl.moduleName(), {1, 3}, true)
		PlayerPanel.addForActivity()
	elseif (tonumber(nType) == 7) then		
		-- if (not SwitchModel.getSwitchOpenState(ksSwitchGuild,true)) then
		-- 	return
		-- end
		require "script/module/guild/GuildDataModel"
		require "script/module/guild/MainGuildCtrl"
		require "script/module/guild/cafeHouse/CafeHouseCtrl"
		  
		if GuildDataModel.getIsHasInGuild() == false then
			ShowNotice.showShellInfo(m_i18n[1925])
		else
			--CafeHouseCtrl.create()
			MainGuildCtrl.enterCafe()
		end
	elseif (tonumber(nType) == 8) then	
		require "script/module/copy/MainCopy"
		-- if(not SwitchModel.getSwitchOpenState(ksSwitchExplore,true)) then
		-- 	return
		-- end   
	    local layCopy = MainCopy.create(3,true)
		if (layCopy) then
			LayerManager.changeModule(layCopy, MainCopy.moduleName(), {3}, true)
			PlayerPanel.addForCopy()
			MainCopy.updateBGSize()
			MainCopy.setFogLayer()

			MainScene.changeMenuCircle(3)
		end
	elseif (tonumber(nType) == 9) then--喝可乐
		require "script/module/wonderfulActivity/MainWonderfulActCtrl"
		local act = MainWonderfulActCtrl.create("supply")
		LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
		local scene = CCDirector:sharedDirector():getRunningScene()
		performWithDelay(scene, function(...)
			MainWonderfulActView.updateLSVPos(WonderfulActModel.tbShowType.kShowSupply)
		end, 0.1)
	elseif (tonumber(nType) == 10) then
		require "script/module/SkyPiea/MainSkyPieaCtrl"
		MainSkyPieaCtrl.create()
	elseif (tonumber(nType) == 11) then
		require "script/module/copyActivity/MainCopyCtrl"
		MainCopyCtrl.create()
	elseif (tonumber(nType) == 12) then
		require "script/module/WorldBoss/MainWorldBossCtrl"
		MainWorldBossCtrl.create(true)
	elseif (tonumber(nType) == 13) then--签到
		require "script/module/wonderfulActivity/MainWonderfulActCtrl"
		local act = MainWonderfulActCtrl.create("registration")
		LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
	elseif (tonumber(nType) == 14) then--联盟大厅
		require "script/module/guild/GuildDataModel"
		require "script/module/guild/MainGuildCtrl"
		if GuildDataModel.getIsHasInGuild() == false then
			ShowNotice.showShellInfo(m_i18n[1925])
		else
			MainGuildCtrl.enterHall()
		end
		
	elseif (tonumber(nType) == 15) then--酒馆
		require "script/module/shop/MainShopCtrl"
		if (MainShopCtrl.moduleName() ~= LayerManager.curModuleName()) then
			local layShop = MainShopCtrl.create()
			if (layShop) then
				LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
				PlayerPanel.addForPublic()
				MainScene.updateBgLightOfMenu() -- zhangqi, 刷新背景光晕的显示
			end
		end
	elseif (tonumber(nType) == 16) then--神秘商店
		local function treaShopReturn( sender,eventType )
			if eventType == TOUCH_EVENT_ENDED then
				local curModuleName = LayerManager.curModuleName()
				DropUtil.getReturn(curModuleName)
				tbAllTasks = MainDailyTaskData.getAllTasks(tbTaskInfo)
				refreshListView()
				UIHelper.reloadListView(m_ListView,#tbAllTasks,updateListCell)
			end
		end 
		local funcall = treaShopReturn
		require "script/module/wonderfulActivity/mysteryCastle/MysteryCastleCtrl"
		MysteryCastleCtrl.create(funcall, 1)
	elseif (tonumber(nType) == 17) then--装备列表
		require "script/module/equipment/MainEquipmentCtrl"
		local layEquipment = MainEquipmentCtrl.create()
		if layEquipment then
			LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3}, true)
			PlayerPanel.addForPartnerStrength()
		end
	elseif (tonumber(nType) == 18) then--宝物列表
		require "script/module/treasure/MainTreaBagCtrl"
		MainTreaBagCtrl.create() 
	elseif (tonumber(nType) == 19) then--购买贝利
		require "script/module/wonderfulActivity/MainWonderfulActCtrl"
		local act = MainWonderfulActCtrl.create("buyMoney")
		LayerManager.changeModule(act, MainWonderfulActCtrl.moduleName(), {1,3},true)
	elseif (tonumber(nType)==20) then   --深海监狱
		require "script/module/impelDown/MainImpelDownCtrl"
		MainImpelDownCtrl.create()
	elseif (tonumber(nType)==21) then 
		require "script/module/mine/MainMineCtrl"  --资源矿
		MainMineCtrl.create()
	elseif (tonumber(nType)==22) then   --（酒馆－道具） 购买体力
		local layShop = MainShopCtrl.create(2)
		if (layShop) then
			LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
			PlayerPanel.addForPublic()
		end
	elseif(tonumber(nType)==23) then --（酒馆－道具） 购买体力
		local layShop = MainShopCtrl.create(2)
		if (layShop) then
			LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
			PlayerPanel.addForPublic()
		end
	elseif(tonumber(nType)==24) then  --购买宝物礼盒
		local layShop = MainShopCtrl.create(2)
		if (layShop) then
			LayerManager.changeModule(layShop, MainShopCtrl.moduleName(), {1,3},true)
			PlayerPanel.addForPublic()
		end
	elseif(tonumber(nType)==25) then --挑战觉醒副本
		copyAwakeCtrl.create()
	end 
end

function createGetRewardInfoDlg( stitle,_tbItems ,fnCallBack,subTitle,strBtnText,fnClose)   ---fnClose  指定 关闭按钮的事件 add by lizy
	local layMain = g_fnLoadUI("ui/copy_get_reward.json")

	local img_bg = m_fnGetWidget(layMain,"img_bg")-- 主背景
	layMain.img_title_daytask:setVisible(true)
	layMain.img_title_preview:setVisible(false)

	if subTitle then
		local tfd_info = m_fnGetWidget(layMain,"tfd_info") -- 奖励提示框名称
		tfd_info:setText(subTitle)
	else
		local i18ntfd_info = m_fnGetWidget(layMain,"tfd_info") -- 奖励介绍 -- 需要本地化的文字 信息 "恭喜船长获得如下奖励："
		UIHelper.labelEffect(i18ntfd_info,m_i18n[1322])
	end


	local LSV_DROP = m_fnGetWidget(layMain,"LSV_DROP") -- listview

	UIHelper.initListView(LSV_DROP)

	local tbSortData = {}

	local tbSub = {}
	for i,v in ipairs(_tbItems) do
		table.insert(tbSub,v)
		if(table.maxn(tbSub)>=4) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		elseif(i==table.maxn(_tbItems)) then
			table.insert(tbSortData,tbSub)
			tbSub = {}
		end
	end

	local cell

	local tbCell = {}
	for i, itemInfo in ipairs(tbSortData) do
		LSV_DROP:pushBackDefaultItem()

		cell = LSV_DROP:getItem(i-1)  -- cell 索引从 0 开始
		table.insert(tbCell,cell)
		for index,item in ipairs(itemInfo) do
			local imgKey = "IMG_" .. index
			local img = m_fnGetWidget(cell, imgKey)
			img:addChild(item.icon)
			local nameKey = "TFD_NAME_" .. index
			local labName = m_fnGetWidget(cell, nameKey) -- 名称
			labName:setText(item.name)
			UIHelper.labelEffect(labName,item.name) 
			if (item.quality ~= nil) then

				local color =  g_QulityColor[tonumber(item.quality)]
				if(color ~= nil) then
					labName:setColor(color)
				end
			end

			if (index == table.maxn(itemInfo) and index < 4) then --移除剩余的
				for j=index+1,4 do
					imgKey = "IMG_" .. j
					nameKey = "TFD_NAME_" .. j
					local img = m_fnGetWidget(cell, imgKey)
					local labName = m_fnGetWidget(cell, nameKey) -- 名称
					img:removeFromParent()
					labName:removeFromParent()
				end
			end
		end

	end

	local img_reward_bg = m_fnGetWidget(layMain,"img_reward_bg")

	local ncount = table.maxn(tbSortData) -- 统计cell 个数
	if(ncount>2) then  -- 对多于两行对处理
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*2.5))
		img_bg:setSize(CCSizeMake(img_bg:getVirtualRenderer():getContentSize().width,img_bg:getVirtualRenderer():getContentSize().height*1.4))
	elseif(ncount==2)  then
		-- for i,cellTemp in ipairs(tbCell) do
		-- 	cellTemp:setSize(CCSizeMake(cellTemp:getSize().width,cellTemp:getSize().height*.25))
		-- end
		img_reward_bg:setSize(CCSizeMake(img_reward_bg:getSize().width,img_reward_bg:getSize().height*2))
		img_bg:setSize(CCSizeMake(img_bg:getVirtualRenderer():getContentSize().width,img_bg:getVirtualRenderer():getContentSize().height*1.25))
		-- LSV_DROP:setSize(CCSizeMake(LSV_DROP:getSize().width,LSV_DROP:getSize().height*2))

	else

	end


	--绑定按钮事件
	local BTN_GET = m_fnGetWidget(layMain,"BTN_GET") --确定按钮
	if strBtnText then 
		UIHelper.titleShadow(BTN_GET,strBtnText)
	else
		UIHelper.titleShadow(BTN_GET,m_i18n[1029])
	end
	
	local BTN_CLOSE = m_fnGetWidget(layMain,"BTN_CLOSE") --关闭按钮
	BTN_GET:addTouchEventListener( 	function (sender ,eventType )  ---为 按钮加入时间，如果回调空默认为关闭  add by lizy
			  							if (eventType == TOUCH_EVENT_ENDED) then
		  									AudioHelper.playCommonEffect()
			  								if (fnCallBack) then
			  									fnCallBack()
			  								else
			  								 	LayerManager.removeLayout()
			  								end
			  							end
									end)
	BTN_CLOSE:addTouchEventListener( function ( sender ,eventType)
			  							if (eventType == TOUCH_EVENT_ENDED) then
											AudioHelper.playCloseEffect()
			  								if (fnClose) then
			  									fnClose()
			  								else
												LayerManager.removeLayout()
			  								end
			  							end
									end)


	return layMain
end
