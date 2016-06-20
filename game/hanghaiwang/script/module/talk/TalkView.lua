-- FileName: TalkView.lua
-- Author: huxiaozhou
-- Date: 2014-06-10
-- Purpose: function description of module
--[[TODO List]]
-- 对话显示view
module("TalkView", package.seeall)
require "script/module/talk/TalkModel"
require "db/DB_Npcface"
require "db/DB_Npcheader"
require "script/model/user/UserModel"
require "db/DB_Heroes"
require "script/module/config/AudioHelper"


-- UI控件引用变量 --
local m_labLeft   		-- 左边人物名字
local m_labRight		-- 右边人物名字
local m_imgLeft			-- 左边的人物图片
local m_imgRight		-- 右边的人物图片
local m_LAY_HERO 		-- 对话人物背景

local m_imgNameLeft 	-- 左边名字背景
local m_imgNameRight 	-- 右边名字背景

local m_imgTalkLeft     -- 对话文字背景图片 左
local m_imgTalkRight 	-- 对话文字背景图片 右
local m_imgTalkLeftBig  -- 对话文字背景图片 左  大
local m_imgTalkRightBig -- 对话文字背景图片 右  大
local m_imgTalkCenter   -- 对话文字中间的背景 旁白
local m_imgTalkCenterTrun --  对话文字中间的背景 旁白 翻转后

local m_textLabLeft 	-- 左边对话内容lab
local m_textLabRight 	-- 右边对话内容lab
local m_textLabLeftBig  -- 左边对话内容lab  大
local m_textLabRightBig -- 右边对话内容lab  大
local m_textLabCenter 	-- 中间对话的内容lab 旁白
local m_textLabCenterTrun --中间对话的内容lab 旁白 翻转后

local m_imgFace         -- npc 表情 img
local m_imgMood			-- npc 心情 img

local m_textCurLab

local m_schedule

local m_originalPosX
local m_originalPosY

local m_npcOriginalPosX
local m_npcOriginalPosY

-- 模块局部变量 --
local kTalkShakeTag = 100 -- talk震屏action tag


local m_fnGetWidget = g_fnGetWidgetByName
local m_mainWidget = nil

local m_callbackFunc
-- 
local m_talkSimple --对话的表
local m_content

local  IMG_MENGBAN1 
local  IMG_MENGBAN2

local m_talkId = nil

-- 对话内容背景框 左侧 
local m_tbLeftImgTalkBg = {
	"images/talk/left_normal.png",
	"images/talk/left_round.png",
	"images/talk/left_angry.png",
	"images/talk/left_small.png",
	"ui/mid_normal.png",
--[[默认0为普通对话框 
0为普通对话框 （left_normal）
1为普通小对话框（left_round）
2为爆炸对话框（left_angry） 
3为爆炸小对话框（left_small）
4中间旁白
--]]
}

-- 对话内容背景框 右侧
local m_tbRightImgTalkBg = {
	-- "images/talk/right_normal.png",
	-- "images/talk/right_angry.png",
	-- "images/talk/right_round.png"
}
--[[
0无心情动态
1灯泡图标（deng_x.png）
2云朵图标（yun_y.png）
3问号图标（wenhao.png）
4叹号图标（tanhao.png）
5叹气图标（right_qi.png）
--]]
--  左侧表情
local m_tbLeftMoodImgs = {
	"images/talk/mood/deng_x.png",
	"images/talk/mood/yun_x.png",
	"images/talk/mood/wenhao.png",
	"images/talk/mood/tanhao.png",
	"images/talk/mood/left_qi.png",
}

-- 右侧表情
local m_tbRightMoodImgs = {
	"images/talk/mood/deng_y.png",
	"images/talk/mood/yun_y.png",
	"images/talk/mood/wenhao.png",
	"images/talk/mood/tanhao.png",
	"images/talk/mood/right_qi.png",
}


local function init(...)
	m_talkId = nil
	m_callbackFunc = nil
end

function destroy(...)
	package.loaded["TalkView"] = nil
end

function moduleName()
    return "TalkView"
end

-- 设置对完完成后的操作
function setCallbackFunction(callbackFunc)
	if (callbackFunc) then
		logger:debug("m_callbackFunc  对话回调不是nil ")
	end
    m_callbackFunc = callbackFunc
end

-- 显示每一组对话
function showNext( ... )
	endShake()
	local tbCurDlg = TalkModel.getNextDialog(m_talkSimple)
	if(nil == tbCurDlg) then
		if(m_schedule) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_schedule)
			m_schedule = nil
		end
		
		
		-- if (m_imgFace:getParent()) then
		-- 	m_imgFace:release()
		-- end
		LayerManager.removeTalkLayer()
		
		if (nil ~= m_callbackFunc) then
			-- pcall(m_callbackFunc)
			local tempCallback = m_callbackFunc
			m_callbackFunc = nil
			tempCallback()
		else
			logger:debug("m_callbackFunc ====== nil")
		end
		return
	else
		-- 打点记录  用户操作 2016-01-05
		UserModel.recordUsrOperationByCondition("talkViewtalkId " .. m_talkId , tbCurDlg.id)

		logger:debug(m_mainWidget)
		logger:debug(tbCurDlg.shake)
		if (tonumber(tbCurDlg.shake) == 1) then
			local runningScene = CCDirector:sharedDirector():getRunningScene()
			startShake(runningScene,0.05,4)
		end

		updateLeft(tbCurDlg)
		updateRight(tbCurDlg)
		updateFace(tbCurDlg)
		updateDlgContent(tbCurDlg)
		updateName(tbCurDlg)
		updateImgColor(tbCurDlg)
		updateMood(tbCurDlg)
		updateTalkContentBg(tbCurDlg)
		if(tonumber(tbCurDlg.npcshake) == 1 and tbCurDlg.dir=="0") then
			startShakeNpc(m_imgLeft,0.05,2)
		elseif (tonumber(tbCurDlg.npcshake) == 1 and tbCurDlg.dir=="1") then
			startShakeNpc(m_imgRight,0.05,2)
		end

	end

end

function updateLeft( tbCurDlg )
			-- 更新左侧人物
	if (tbCurDlg.leftHeaderId ~= nil and tonumber(tbCurDlg.leftHeaderId) ~= 0) then
		m_imgLeft:setVisible(true) 
		local imageFile
		local positionX
		if(tonumber(tbCurDlg.leftHeaderId)==999) then
	        if(UserModel.getUserInfo()==nil)then
	            imageFile = "quan_jiang_guojia.png"
	        else
	            imageFile = DB_Heroes.getDataById(tonumber(UserModel.getAvatarHtid())).body_img_id
	        end

            local npcList = DB_Npcheader.getArrDataByField("body_image",imageFile)
            if(npcList==nil or #npcList==0)then
                positionX = 640*0.25
            else
                positionX = npcList[1].position_x
            end

	    else
	        local npc = DB_Npcheader.getDataById(tonumber(tbCurDlg.leftHeaderId))
	        if(npc~=nil)then
	            imageFile = npc.body_image
	            positionX = npc.position_x
	        end
	    end
	    if(imageFile~=nil)then
	        imageFile = "images/base/hero/body_img/" .. imageFile
	        m_imgLeft:loadTexture(imageFile)
	        m_imgLeft:setPositionX(positionX/640*g_winSize.width)
	    end
	elseif(tbCurDlg.leftHeaderId ~= nil and tonumber(tbCurDlg.leftHeaderId) == 0) then
		m_imgLeft:setVisible(false)
	end
end

function updateRight( tbCurDlg )
	-- 更新右侧人物
	if (tbCurDlg.rightHeaderId ~= nil and tonumber(tbCurDlg.rightHeaderId) ~= 0) then
		m_imgRight:setVisible(true)
		local imageFile
		if(tonumber(tbCurDlg.rightHeaderId)==999) then
	        if(UserModel.getUserInfo()==nil)then
	            imageFile = "quan_jiang_guojia.png"
	        else
	            imageFile = DB_Heroes.getDataById(tonumber(UserModel.getAvatarHtid())).body_img_id
	        end
	        
            local npcList = DB_Npcheader.getArrDataByField("body_image",imageFile)
            if(npcList==nil or #npcList==0)then
                positionX = 640*0.25
            else
                positionX = npcList[1].position_x
            end
	    else
	       
	        local npc = DB_Npcheader.getDataById(tonumber(tbCurDlg.rightHeaderId))
	        if(npc~=nil)then
	            imageFile = npc.body_image
	            positionX = npc.position_x
	        end

	    end
	    if(imageFile~=nil)then
	        imageFile = "images/base/hero/body_img/" .. imageFile
	        m_imgRight:loadTexture(imageFile)
	        positionX = 640 - positionX
	        m_imgRight:setPositionX(positionX/640*g_winSize.width)
	    end
	elseif (tbCurDlg.rightHeaderId ~= nil and tonumber(tbCurDlg.rightHeaderId) == 0) then
 		
		m_imgRight:setVisible(false)
	end
end

-- 更新表情
function updateFace( tbCurDlg )
	 m_imgFace:removeFromParentAndCleanup(false)
	 if (tonumber(tbCurDlg.rightFaceId) ~= 0) then
    	local imgFacePath = "images/base/hero/face_img/" .. DB_Npcface.getDataById(tbCurDlg.rightFaceId).face_image
    	logger:debug(imgFacePath)
    	m_imgFace:loadTexture(imgFacePath)
    	m_imgRight:addChild(m_imgFace)

    	if (tbCurDlg.dir == "1") then
    		m_imgFace:setColor(ccc3(255,255,255))
    	else 	
    		m_imgFace:setColor(ccc3(111,111,111))
    	end
    elseif(tonumber(tbCurDlg.leftFaceId) ~= 0) then
    	local imgFacePath = "images/base/hero/face_img/" .. DB_Npcface.getDataById(tbCurDlg.leftFaceId).face_image
    	m_imgFace:loadTexture(imgFacePath)
    	m_imgLeft:addChild(m_imgFace)
    	if (tbCurDlg.dir == "0") then
    		m_imgFace:setColor(ccc3(255,255,255))
    	else 	
    		m_imgFace:setColor(ccc3(111,111,111))
    	end
    end
end

-- 更新心情
function updateMood( tbCurDlg )
	logger:debug(tbCurDlg)
	m_imgMood:removeFromParentAndCleanup(false)
	if (tonumber(tbCurDlg.dir) == 0 and tonumber(tbCurDlg.mood) ~= 0) then
		local nMood = tonumber(tbCurDlg.mood)
		local posx 
		local posy
		local moodImgPath
		if (tonumber(tbCurDlg.leftHeaderId) == 999) then

			local imageFile
	        if(UserModel.getUserInfo()==nil)then
	            imageFile = "quan_jiang_guojia.png"
	        else
	            imageFile = DB_Heroes.getDataById(tonumber(UserModel.getAvatarHtid())).body_img_id
	        end


            local npcList = DB_Npcheader.getArrDataByField("body_image",imageFile)
            logger:debug(imageFile)
            logger:debug(npcList)
            if(npcList==nil or #npcList==0)then
                posx = nil
                posy = nil
            else
                local npc = npcList[1]
                logger:debug("npc positionX = npcList[1].position_x")
                if(npc~=nil)then
		        	if (nMood==1) then
		        		posx = npc.deng_x
		        		posy = npc.deng_y
		        	elseif(nMood==2)then
		        		posx = npc.yun_x
		        		posy = npc.yun_y
		        	elseif(nMood==3)then
		        		posx = npc.wen_x
		        		posy = npc.wen_y
		        	elseif(nMood==4) then
		        		posx = npc.tan_x
		        		posy = npc.tan_y
		        	elseif(nMood==5) then
		        		posx = npc.qi_x
		        		posy = npc.qi_y
		        	end
		        	moodImgPath = m_tbLeftMoodImgs[nMood]
	        	end
		        if (posx and posy) then
			    	m_imgMood:loadTexture(moodImgPath)
			    	m_imgLeft:addChild(m_imgMood)
			    	m_imgMood:setPosition(ccp(posx,posy))
				end
            end
		else
			local npc = DB_Npcheader.getDataById(tonumber(tbCurDlg.leftHeaderId))
	        if(npc~=nil)then
	        	if (nMood==1) then
	        		posx = npc.deng_x
	        		posy = npc.deng_y
	        	elseif(nMood==2)then
	        		posx = npc.yun_x
	        		posy = npc.yun_y
	        	elseif(nMood==3)then
	        		posx = npc.wen_x
	        		posy = npc.wen_y
	        	elseif(nMood==4) then
	        		posx = npc.tan_x
	        		posy = npc.tan_y
	        	elseif(nMood==5) then
	        		posx = npc.qi_x
	        		posy = npc.qi_y
	        	end
	        	moodImgPath = m_tbRightMoodImgs[nMood]
	        end
	        if (posx and posy) then
		    	m_imgMood:loadTexture(moodImgPath)
		    	m_imgLeft:addChild(m_imgMood)
		    	m_imgMood:setPosition(ccp(posx,posy))
			end
	    end
	
	elseif(tonumber(tbCurDlg.mood) ~= 0) then
		local nMood = tonumber(tbCurDlg.mood)
		local posx 
		local posy
		local moodImgPath
		if (tonumber(tbCurDlg.rightHeaderId) == 999) then

		else
			local npc = DB_Npcheader.getDataById(tonumber(tbCurDlg.rightHeaderId))
			logger:debug(npc)
	        if(npc~=nil)then
	        	if (nMood==1) then
	        		posx = npc.deng_x
	        		posy = npc.deng_y
	        	elseif(nMood==2)then
	        		posx = npc.yun_x
	        		posy = npc.yun_y
	        	elseif(nMood==3)then
	        		posx = npc.wen_x
	        		posy = npc.wen_y
	        	elseif(nMood==4) then
	        		posx = npc.tan_x
	        		posy = npc.tan_y
	        	elseif(nMood==5) then
	        		posx = npc.qi_x
	        		posy = npc.qi_y
	        	end
	        	moodImgPath = m_tbLeftMoodImgs[nMood]
	        end
	        if (posx and posy) then
			    m_imgMood:loadTexture(moodImgPath)
			    m_imgRight:addChild(m_imgMood)
			    m_imgMood:setPosition(ccp(posx,posy))
			end
	    end
	end
end


function updateName( tbCurDlg )
	 --更新对话名字
    if(tbCurDlg.talkName~=nil and tbCurDlg.talkName~="") then
       logger:debug(tbCurDlg.talkName)
       	m_imgNameLeft:setVisible(true)
		m_imgNameRight:setVisible(true)
    	if (tbCurDlg.dir=="0") then

	        if (tbCurDlg.talkName=="[HERO]") then
	        	local userName
	            if(UserModel.getUserInfo() ~= nil and UserModel.getUserInfo().uname ~=nil) then
	                userName = UserModel.getUserInfo().uname
	            end
	            m_labLeft:setText(userName)
			else
				m_labLeft:setText(tbCurDlg.talkName)
			end
			m_imgNameLeft:setVisible(true)

			if(tbCurDlg.leftHeaderId ~= nil and tonumber(tbCurDlg.leftHeaderId) == 0) then
				m_imgNameRight:setVisible(false)
			else
				m_imgNameRight:setVisible(true)
			end
			if (m_labRight:getStringValue() == "") then
				m_imgNameRight:setVisible(false)
			end
		else 
			logger:debug(tbCurDlg.talkName)

			if (tbCurDlg.talkName=="[HERO]") then
	        	local userName
	            if(UserModel.getUserInfo() ~= nil and UserModel.getUserInfo().uname ~=nil) then
	                userName = UserModel.getUserInfo().uname
	            end
	            m_labRight:setText(userName)
			else
				m_labRight:setText(tbCurDlg.talkName)
			end
			if(tbCurDlg.rightHeaderId ~= nil and tonumber(tbCurDlg.rightHeaderId) == 0) then
				m_imgNameLeft:setVisible(false)
			else
				m_imgNameLeft:setVisible(true)
			end

			if m_labLeft:getStringValue() == "" then
				m_imgNameLeft:setVisible(false)
			end

			m_imgNameRight:setVisible(true)
		end
	else
		m_imgNameLeft:setVisible(false)
		m_imgNameRight:setVisible(false)
	end
end

function updateDlgContent( tbCurDlg )
	  --更新对话名字
    if(tbCurDlg.msg~=nil and tbCurDlg.msg~="") then
        local userName
        if(UserModel.getUserInfo() ~= nil and UserModel.getUserInfo().uname ~=nil) then
            userName = UserModel.getUserInfo().uname
        end
        local str = string.gsub(tbCurDlg.msg,"%b[HERO]",userName)
        logger:debug(str)
    	m_textLabLeft:setText("")
    	m_textLabRight:setText("")
    	

    	-- local tbStr = splitStr(str)
    	-- logger:debug(tbStr)
    	m_content = str
    	local array= BTUtil:splitString(str)
    	local tbArr = {}
    	-- logger:debug(tb)
    	for str in array_iter(array) do
    		-- print(str)
    		local ccstr = tolua.cast(str, "CCString")
    		table.insert(tbArr,ccstr:getCString())
    		-- logger:debug(ccstr:getCString())
    	end
    	-- logger:debug(tbArr)
    	-- if(tonumber(tbCurDlg.show) == 0) then
    		if (tbCurDlg.dir=="0") then
		    	if(tonumber(tbCurDlg.form) == 1 or tonumber(tbCurDlg.form) == 3) then
		        	m_textLabLeft:setText(str)
		        elseif(tonumber(tbCurDlg.form) == 4) then
		        	m_textLabCenter:setText(str)
		        else
		        	m_textLabLeftBig:setText(str)
		        end
	    	else
	    		if(tonumber(tbCurDlg.form) == 1 or tonumber(tbCurDlg.form) == 3) then
		        	m_textLabRight:setText(str)
		        elseif(tonumber(tbCurDlg.form) == 4) then
		        	m_textLabCenterTrun:setText(str)
		        else
		        	m_textLabRightBig:setText(str)
		        end
	    	end
    	-- else 
	    -- 	scheduleFunc(tbArr,tbCurDlg)
	    -- end
    end
end

function scheduleFunc( tbArr ,tbCurDlg)
	if(m_schedule) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_schedule)
		m_schedule = nil
	end
	local count = 1
	local function updateText( delta )
		-- logger:debug("delta = " .. tbArr[count])
		-- local text = m_richTextLab:getStringValue()
		local text 
		if (tbCurDlg.dir=="0") then
	    	if(tonumber(tbCurDlg.form) == 1 or tonumber(tbCurDlg.form) == 3) then
	    		m_textCurLab = m_textLabLeft
	        	text = m_textLabLeft:getStringValue()
	        else
	        	m_textCurLab = m_textLabLeftBig
	        	text = m_textLabLeftBig:getStringValue()
	        end
    	else
    		if(tonumber(tbCurDlg.form) == 1 or tonumber(tbCurDlg.form) == 3) then
    			m_textCurLab = m_textLabRight
	        	text = m_textLabRight:getStringValue()
	        else
	        	m_textCurLab = m_textLabRightBig
	        	text = m_textLabRightBig:getStringValue()
	        end
    	end


		m_textCurLab:setText("" .. text .. tbArr[count])
		if (count >= #tbArr) then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_schedule)
			m_schedule = nil
		end
		count = count + 1
	end

	m_schedule = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(updateText, 0.1, false)
	
end

function stopShowElement(  )
	if(m_schedule) then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(m_schedule)
		m_schedule = nil
		m_textCurLab:setText(m_content)
		return true
	end
	return false
end

function updateImgColor( tbCurDlg )
    if(tbCurDlg.dir=="0")then
        m_imgLeft:setColor(ccc3(255,255,255))
        m_imgRight:setColor(ccc3(111,111,111))
        m_LAY_HERO:reorderChild(m_imgRight,-1)
        m_LAY_HERO:reorderChild(m_imgLeft,1)
        m_LAY_HERO:reorderChild(m_imgNameLeft,1)
        m_LAY_HERO:reorderChild(m_imgNameRight,-1)
        m_imgNameLeft:setColor(ccc3(255,255,255))
		m_imgNameRight:setColor(ccc3(111,111,111))
		-- m_labRight:setColor(ccc3(111,111,111))
		-- m_labLeft:setColor(ccc3(255,255,255))
    else
        m_imgRight:setColor(ccc3(255,255,255))
        m_imgLeft:setColor(ccc3(111,111,111))
        m_LAY_HERO:reorderChild(m_imgRight,1)
        m_LAY_HERO:reorderChild(m_imgLeft,-1)
        m_LAY_HERO:reorderChild(m_imgNameLeft,-1)
        m_LAY_HERO:reorderChild(m_imgNameRight,1)
        m_imgNameRight:setColor(ccc3(255,255,255))
		m_imgNameLeft:setColor(ccc3(111,111,111))
		-- m_labLeft:setColor(ccc3(111,111,111))
		-- m_labRight:setColor(ccc3(255,255,255))
    end
end


function updateTalkContentBg( tbCurDlg )
	m_imgTalkRight:setVisible(false)
	m_imgTalkLeft:setVisible(false)
	m_imgTalkRightBig:setVisible(false)
	m_imgTalkLeftBig:setVisible(false)
	m_imgTalkCenter:setVisible(false)
	m_imgTalkCenterTrun:setVisible(false)
	 if(tbCurDlg.dir=="0")then
        if(tonumber(tbCurDlg.form) == 1 or tonumber(tbCurDlg.form) == 3) then
        	m_imgTalkLeft:setVisible(true)
        	logger:debug(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        	m_imgTalkLeft:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        elseif(tonumber(tbCurDlg.form) == 4) then
        	m_imgTalkCenter:setVisible(true)
        	m_imgTalkCenter:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        else
        	m_imgTalkLeftBig:setVisible(true)
        	m_imgTalkLeftBig:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        end
    else
        if(tonumber(tbCurDlg.form) ==1 or tonumber(tbCurDlg.form) ==3) then
        	m_imgTalkRight:setVisible(true)
        	m_imgTalkRight:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        	m_imgTalkRight:setFlipX(true)
        elseif(tonumber(tbCurDlg.form) == 4) then
        	m_imgTalkCenterTrun:setVisible(true)
        	m_imgTalkCenterTrun:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        	m_imgTalkCenterTrun:setFlipX(true)
        else
        	m_imgTalkRightBig:setVisible(true)
        	m_imgTalkRightBig:loadTexture(m_tbLeftImgTalkBg[tonumber(tbCurDlg.form)+1])
        end
    end
end

--  注册界面touch 事件回调
-- function layerTouch(eventType, x, y)
--     if eventType == "began" then
--         return true
--     elseif eventType == "moved" then
--         return true
--     else
--     	logger:debug("layerTouch ========== " .. eventType)
--     	if(stopShowElement()) then
--     		return true
--     	end
    	 
--         showNext()
--         return true
--     end
-- end

function fnTouchLayer( sender ,eventType )
	logger:debug(sender)
	logger:debug("eventType == " .. eventType)
	if (eventType == TOUCH_EVENT_ENDED) then
        showNext()
    end
end

-- 获取UI控件 
function loadedUI( ... )
	m_labLeft = m_fnGetWidget(m_mainWidget, "TFD_NAME_LEFT")
	m_labRight = m_fnGetWidget(m_mainWidget, "TFD_NAME_RIGHT")
	m_imgLeft = m_fnGetWidget(m_mainWidget, "IMG_LEFT")
	m_imgRight = m_fnGetWidget(m_mainWidget, "IMG_RIGHT")
	m_LAY_HERO = m_fnGetWidget(m_mainWidget, "LAY_HERO")
	m_imgNameLeft = m_fnGetWidget(m_mainWidget, "IMG_NAME_LEFT")
	m_imgNameRight = m_fnGetWidget(m_mainWidget, "IMG_NAME_RIGHT")

	m_imgTalkLeft = m_fnGetWidget(m_mainWidget, "IMG_TALK_LEFT")
	m_imgTalkLeftBig = m_fnGetWidget(m_mainWidget,"IMG_TALK_LEFT_BIG")

	m_imgTalkRight = m_fnGetWidget(m_mainWidget, "IMG_TALK_RIGHT")
	m_imgTalkRightBig = m_fnGetWidget(m_mainWidget, "IMG_TALK_RIGHT_BIG")

	m_textLabLeft = m_fnGetWidget(m_mainWidget, "TFD_TALK_LEFT")
	m_textLabLeftBig = m_fnGetWidget(m_mainWidget, "TFD_TALK_LEFT_BIG")

	m_textLabRight = m_fnGetWidget(m_mainWidget, "TFD_TALK_RIGHT")
	m_textLabRightBig = m_fnGetWidget(m_mainWidget,"TFD_TALK_RIGHT_BIG")

	m_imgTalkCenter = m_fnGetWidget(m_mainWidget, "IMG_TALK_CENTER")
	m_textLabCenter = m_fnGetWidget(m_mainWidget, "TFD_TALK_CENTER")

	m_imgTalkCenterTrun = m_fnGetWidget(m_mainWidget, "IMG_TALK_CENTER_TURN")
	m_textLabCenterTrun = m_fnGetWidget(m_mainWidget, "TFD_TALK_CENTER_TURN")

	IMG_MENGBAN1 = m_fnGetWidget(m_mainWidget, "IMG_MENGBAN1")
	IMG_MENGBAN2 = m_fnGetWidget(m_mainWidget, "IMG_MENGBAN2")

	

	m_imgFace = ImageView:create()
	m_imgFace:setAnchorPoint(ccp(0.5,0))
	m_imgFace:retain()

	m_imgMood = ImageView:create()
	m_imgMood:retain()
	setVisible(false)
end

function setVisible(bVisible )
	m_labLeft:setVisible(bVisible)
	m_labRight:setVisible(bVisible)
	m_imgLeft:setVisible(bVisible)
	m_imgRight:setVisible(bVisible)
	m_LAY_HERO:setVisible(bVisible)
	m_imgNameLeft:setVisible(bVisible)
	m_imgNameRight:setVisible(bVisible)

	m_imgTalkLeft:setVisible(bVisible)
	m_imgTalkLeftBig:setVisible(bVisible)

	m_imgTalkRight:setVisible(bVisible)
	m_imgTalkRightBig:setVisible(bVisible)

	m_textLabLeft:setVisible(bVisible)
	m_textLabLeftBig:setVisible(bVisible)

	m_textLabRight:setVisible(bVisible)
	m_textLabRightBig:setVisible(bVisible)

	m_textLabCenter:setVisible(bVisible)
	m_imgTalkCenter:setVisible(bVisible)

	m_imgTalkCenterTrun:setVisible(bVisible)
	m_textLabCenterTrun:setVisible(bVisible)


end

function afterEnter( ... )
	m_mainWidget:addTouchEventListener(fnTouchLayer)
	setVisible(true)
	m_labLeft:setText("")
	m_labRight:setText("")
	showNext()
end

function easeFunc1( )
	IMG_MENGBAN1:setPosition(ccp(g_winSize.width*.5,  g_winSize.height+IMG_MENGBAN1:getSize().height))
	local arrActions = CCArray:create()
	local move = CCMoveTo:create(0.2, ccp(g_winSize.width*.5, g_winSize.height))
	
	-- local moveby = CCMoveBy:create(0.5,  ccp(0, g_winSize.height))
	local ease = CCEaseIn:create(move,2)
	arrActions:addObject(ease)
	local delay = CCDelayTime:create(0.2)
	arrActions:addObject(delay)
	local delay = CCCallFunc:create(afterEnter)
	arrActions:addObject(delay)
	local seq = CCSequence:create(arrActions)
	IMG_MENGBAN1:runAction(seq)
end


function easeFunc2( )
	IMG_MENGBAN2:setPosition(ccp(g_winSize.width*.5,  -IMG_MENGBAN2:getSize().height))
	
	local move = CCMoveTo:create(0.2, ccp(g_winSize.width*.5, 0))
	-- local moveby = CCMoveBy:create(0.5,  ccp(0, g_winSize.height))
	local ease = CCEaseIn:create(move,2)
	IMG_MENGBAN2:runAction(ease)
end


function create(talkId)
	init()
	m_talkId = talkId
	m_talkSimple = TalkModel.getTalkById(talkId)
	local json = "ui/talk.json"
	m_mainWidget = g_fnLoadUI(json)
	m_mainWidget:setSize(g_winSize)
	loadedUI()
	-- easeFunc(IMG_MENGBAN1)
	-- m_mainWidget:addTouchEventListener(fnTouchLayer)
	UIHelper.registExitAndEnterCall(m_mainWidget, function (  )
		m_imgFace:release()
		m_imgMood:release()
	end)
	return m_mainWidget
end

--<< 对话震屏
function shakeFunc(node, callback, delay,times,posx,posy)
    local delay = CCDelayTime:create(delay)
    local callfunc = CCCallFuncN:create(callback)
    local sequence = CCSequence:createWithTwoActions(delay, callfunc)
    local repeatAct = CCRepeat:create(sequence,times)
    local callfunc1 = CCCallFuncN:create(function (  )
    	node:setPosition(ccp(posx,posy))
    end)
    local seq = CCSequence:createWithTwoActions(repeatAct, callfunc1)

    node:runAction(seq)
    return seq
end


function doShakeScene(node)
	AudioHelper.playEffect("audio/talk/UI_zhenjing.mp3")
    math.randomseed(os.time())
    local shakeY = math.floor(math.random()*3+1)*g_winSize.height*0.003
    if( node:getPositionY()>= m_originalPosY ) then
        shakeY = -shakeY
    end
  
    node:setPositionY(shakeY)
end

function doShake( node )
	local shakeX = math.floor(math.random()*3+1)*2.4
    if(node:getPositionX()>=m_npcOriginalPosX) then
    	shakeX = -shakeX
    end

    node:setPositionX(m_npcOriginalPosX+shakeX)
end

function startShakeNpc( node,delta,times )
	m_npcOriginalPosX,m_npcOriginalPosY = node:getPosition()
    if(node:getActionByTag(kTalkShakeTag)==nil)then
        local action = shakeFunc(node,doShake,delta,times,m_npcOriginalPosX,m_npcOriginalPosY)
        action:setTag(kTalkShakeTag)
    end
end

function startShake(node,delta,times)
	m_originalPosX,m_originalPosY = node:getPosition()
    if(node:getActionByTag(kTalkShakeTag)==nil)then
        local action = shakeFunc(node,doShakeScene,delta,times,m_originalPosX,m_originalPosY)
        action:setTag(kTalkShakeTag)
    end
end

function endShake()
	local runningScene = CCDirector:sharedDirector():getRunningScene()
	if (runningScene:getActionByTag(kTalkShakeTag)) then
		runningScene:stopActionByTag(kTalkShakeTag)
	end
	runningScene:setPosition(ccp(0,0))

	if(m_imgLeft:getActionByTag(kTalkShakeTag)) then
		m_imgRight:stopActionByTag(kTalkShakeTag)
	end
	if(m_imgRight:getActionByTag(kTalkShakeTag)) then
		m_imgRight:stopActionByTag(kTalkShakeTag)
	end

end

--- 对话震屏 >>>
