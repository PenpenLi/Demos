-- 屏幕中央播放文字提示
require (BATTLE_CLASS_NAME.class)
local BAForShowTipInCenter = class("BAForShowTipInCenter",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForShowTipInCenter.cid					= nil -- 国际化文字id
	BAForShowTipInCenter.container				= nil -- 容器
	------------------ functions -----------------------
 	function BAForShowTipInCenter:start()

 		if(self.data ~= nil and tonumber(self.data[1]) > 0) then
 			-- Logger.debug("==== BAForShowTipInCenter:start:" .. tostring(self.data[1]))
 			self.cid = tonumber(self.data[1])
			self:doLogic()
		else
			self:complete()
		end
	end


	function BAForShowTipInCenter:doLogic()

		-- 获取国际化
		local words  = gi18nString(self.cid)
		ObjectTool.removeObject(self.container)
		
		-- 生成背景图

		self.container = CCScale9Sprite:create(BATTLE_CONST.TIP_TEXTURE_URL)
		self.container:setCapInsets(CCRectMake(self.container:getContentSize().width/2 - 2,self.container:getContentSize().height/2 -2 ,2,2))
		self.container:setContentSize(CCSizeMake(g_winSize.width,46))
		-- 生成label
		local label = CCLabelTTF:create(tostring(words),g_sFontPangWa,24)
 		label:setFontFillColor(ccc3(255,255,255))
 		label:setAnchorPoint(CCP_HALF)
 		label:enableStroke(ccc3(0,0,0),2)
 		label:enableShadow(CCSizeMake(2, -2), 255, 0)
 		self.container:addChild(label)
 		label:setPositionX(self.container:getContentSize().width/2)
 		label:setPositionY(self.container:getContentSize().height/2)
 		-- label:setPositionX(label:getContentSize().width/2)
 		BattleLayerManager.battleUILayer:addChild(self.container)
 		


 		local scaleX = g_winSize.width/640
 		-- self.container:setPosition(g_winSize.width/2,g_winSize.height/2)
 		-- self.container:setPosition(g_winSize.width/2,g_winSize.height/2)
 		self.container:setPosition(-334 * scaleX,g_winSize.height/2)








 		-- -- 淡入淡出
 		-- local actionArray = CCArray:create()
   --          actionArray:addObject(CCFadeIn:create(0.2))
   --          actionArray:addObject(CCDelayTime:create(1.5)) -- 1
   --      	actionArray:addObject(CCFadeOut:create(0.2))
   --          actionArray:addObject(CCCallFuncN:create(function( ... )
   --              -- Logger.debug("数字动画完毕")
   --              if(self.disposed ~= true) then
   --                   self:complete()
   --                   self:release()  
                    
   --              end
   --               -- --print("BAForShowNumberAnimation complete,title:")
               
   --          end))
   --         self.container:runAction(CCSequence:create(actionArray))








          local actionArray = CCArray:create()
             -- 4
            actionArray:addObject(CCMoveBy:create(3 * BATTLE_CONST.FRAME_TIME,ccp(444 * scaleX,0)))
            --5
            actionArray:addObject(CCMoveBy:create(1 * BATTLE_CONST.FRAME_TIME,ccp(210 * scaleX,0)))
            
            --7
            actionArray:addObject(CCMoveBy:create(2 * BATTLE_CONST.FRAME_TIME,ccp(6 * scaleX,0)))

            --9
            actionArray:addObject(CCMoveBy:create(2 * BATTLE_CONST.FRAME_TIME,ccp(-6 * scaleX,0)))
            
            -- 40
            actionArray:addObject(CCDelayTime:create(60 * BATTLE_CONST.FRAME_TIME))

            -- 42
            actionArray:addObject(CCMoveBy:create(4 * BATTLE_CONST.FRAME_TIME,ccp(-6 * scaleX,0)))

            -- 44
            actionArray:addObject(CCMoveBy:create(8 * BATTLE_CONST.FRAME_TIME,ccp(706 * scaleX,0)))


            -- 45
            actionArray:addObject(CCMoveBy:create(14 * BATTLE_CONST.FRAME_TIME,ccp(100 * scaleX,0)))

            -- 48
            -- actionArray:addObject(CCMoveBy:create(200 * BATTLE_CONST.FRAME_TIME,ccp(131 * scaleX,0)))

            actionArray:addObject(CCCallFuncN:create(function( ... )
                -- Logger.debug("数字动画完毕")
                if(self.disposed ~= true) then
                     self:complete()
                     self:release()  
                    
                end
                 -- --print("BAForShowNumberAnimation complete,title:")
               
            end))
            self.container:runAction(CCSequence:create(actionArray))

            -- 第1帧 位置  -334；0             透明度  0

            -- 第4帧 位置  110 ；0             透明度  100

            -- 第5帧 位置  320 ；0             透明度  100

            -- 第7帧 位置  326 ；0             透明度  100 

            -- 第9帧 位置  320 ；0             透明度  100

            -- 第40帧 位置 320 ；0             透明度  100

            -- 第42帧 位置 314；0              透明度  100

            -- 第44帧 位置 320；0              透明度  100

            -- 第45帧 位置 350；0              透明度  100

            -- 第48帧 位置 581；0              透明度  0

	end



	function BAForShowTipInCenter:release( ... )
		self.super.release(self)
		ObjectTool.removeObject(self.container)
		self.container = nil
	end

return BAForShowTipInCenter