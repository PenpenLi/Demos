    module("BattleDataProxy", package.seeall)

	------------------ properties ----------------------
    -- STATE_IDLE                    = "idle"
    -- STATE_WAITING_RESULT          = "waiting_result"

    -- local fake          = "eJydWN9P21YUzrVPQpwQEsdOodW20od10tAqwhJgP4QyhhCd1qmiVUU3NjDEAQ8nzmyHlv14gLZoL9vDHvYybbyt6ksf+ge0j3vbX7H/YpPYvXYMtpNzgSAR5V6f757vfuc7144zWZLb0FzX1KX9MslkiWRrWzoIMp3TNnd0Gw5e/KHKdb2ht+p09O/hck7bdA2rBY9XsrbVadWBjGq2vaz705LIVkmxQNnuzgFRaMSC1qRL+9dLdW9wd6+tU7g/uKeZHR0ezRDCIgQQAF4eyCmPQBqeXs8AGQ5WZ3MjQAr+uAiiCoRkG5qrmeIpnEYVPSZp+BXCcDrVgz6F0atB1qPVM7KWImyVE7aTPBxRoRzBqQHumXAGrhrBlU5w42fgZgPc8fHxf54yaleZx19mQBiWhnwoXTOGPHyTBJfookLwXY6FPfkumiFUulfzXoYIOQhjb/nQgBaFpkE4xeSbWqtuPWiJ/fIeOOSSGN/bSdVHwpk5VfeR4cI3ejlHoG/F04aq32/DEdL7Slws9fxYNY4tnR8btmvYAysZEDGdKO7RLbw9RJ5KBYJ2I5ov1o2xrsLTUZ7TeFdxcTN4V3FxVVxO4MnZxuUEnpwyLieajy8nno7ynMLl5OIquJzny9f3kEp2D6kxsd8xdfD9yTGlxE+wcYJV4onDPQGSvGKM9bANHzvJ8x87sZMDT8o6eK333FHPj75/iu61bIpn2Spu2RRPJQW3LJqPb1k8Hd+yXNx7eCcP8WT5AZdlaMBORvPxZcHT9Tw2RGTh4ircjkyHHhviyMPXyGmz9nTkBNqRhwK3I9ODd2T6Ih0Z6Sk8Keupq7h1JJ51VnHrSLxdlnDroPl6rBOxAJ4u9qQa216Gt70b+PYyAx4YaD7+9vB04e31dXh2WEqGHC6EskP87sMGka0KHv4cTx19nY5D6W6vcJ2eHdjpAZK1bT+vj+HFGb7gr6ui74Xh8DaLMVw5crsKuBb9suJIynQbJ5objGiOR/RaH/d1aeI4SnOPW8eRi/90KfrmGeGRnehvgaJvARzKfP4Rrmt+MF3zPKpXcV1xHOX5LU6zMBjNAo/m60H3xzjGQQKv2vLA1ZZ53N7GJcRxVEIHl7DIZRpu2ZiIRR7RN7i2xKFn2FIZrN7KwOcSjqRMv+Y2vDqwBVQe3Q94dHEkpWvgupbO5tojail6e+nXRorWbtua4WhmSlzM2foDza5LhEgbWzfrkJBc9sZQyDc7jrHpTWzYRh3+mZA7trnGvqeuNWYqM1P1RnW6OrsxWdHLWVfXmmWaQ2ppTT2Vn/b+qkMdCtz/U8ua+q5uQmHUtVzNXGp/bDkuHI3LhnPb1PZ0W8xrtr2k25b/JDC0TWHs1ihtu2yB35Ny23IM/zVnBQqX9V3L3NXX/FVJtqk9XGrDL2l5s2Pby967VUX/pmO0b7YaFl0vp9lNo7VFv4llSIhT9P9d+l+BBFGcHcM05y1rhwogu7auOR1bp5GfQuIzSNyGxDKNytZt3XH8WaI0jK1t947VMSmEyJT5HbYGHSjsva43oA82o/7b3e5whe3rQ68gc/C3WQOowMg8JBbgp7FFEJbo1U/iWe/SJe/FJ1e6LD5nyVfpx1fU1evULaTk8Vq07E0dfu5cNg32xnnRNvQWKy7xSjRF0TdS0vTk5OwUPH9Ygfw0/HV/VnhfyvoEXx7Ic+yjBokKXJoHsgA/vsMISkG2V/Pr8PS6H02tN8c+aqwsfvTzK5Hoo8Y6dWWwtsLWVmog8NaeDKJVFq3WQOREPxOC6BKLLtUgyYseJxvw2xeE/A9Fe+6T"
    local useFakeData   = false
    local state         = STATE_IDLE
    local serverObject  = "BattleDataProxy"
    local resendFunction = nil

    local fakes        = {
                            -- "eJylVc9vG0UU3rGf7diuMY6dWoFIcVRRgQTIzo/WcgIBY4KLCopix64QNIy943jJrtes16krIdSEEtMShDiABGmLVInSColDbwgOEdAbKidOnCvKP1AJCSm8mfVvrAiJw672vTff9733duaNx0t8BWqaKnOPE4+XuA26zsAWQBctbjADtm//tRiQWYlVZLR+v5vx0aKp6BW4Evcaer0iAwlTw1hhlttt5yxOvjBgtHxAgrgiRTWktuJjsjCy56sM7GHLyFG1zmA7TwhfYQMbcBKnSGAEbsoeIEfa7Nz3EJCHLXsUSAi2R3uAGF8QOYzAxTNdoF+jFVk/V7GL2ADBTrRPOStUmkOUmwPArbl+5SZnz47A7pO9QHT14uwheP+JPsHVdqm3IoeVisCtbL/gfEvw+sThgnN9ejnBvYAFLg/oLQwUqPfh8u3G/CvP5mCeR9rAg4ODv0Wqi61UryQ9YGthj9qHJftBqB/c06D9iX7wkBZdnLHQ3a2Qw63whsC5uqK5gUovaaQbzA8Gcz3B1cHgWRQM0mrVoEqNqk5XJpPxGewcNWR+qsrM0K3V7rKpyPDFl6+4KnUNPF6tZp6SOSEh7sI6fkpukx8L8Gv1mlIUjoKBkK0H7wTqhrrGDefU9InpGRotxmdOFtjJeGzWazKqxTh/hWrM+dif3+/dv/z5vRvf3vv49v0L7/1x6TtXnZP8QLwq22Qq+MOmblI1XX1Br5lwmQaU2rJKzzPD7sfDmub5unm+rjLCeIcj8OtYoKrXFHGkpQSQcbapq5tszSKUvBptpKvQjAWKdRwIYo4E2dt1pXqqUtKRykcNTams45c9BpJ9Gp8ZfGZBIsHahqKqSV3fcBMSMHFy1OoGw5XLIK2AlAUph6u8ssFqNctLgiVlvWxm9LqKEBLApDOcA40gn2HCwH0WtiZZy4zzkpJiU0Rg66ojBSQB/iUgafik9DLYTmP4VS7Ap4ViMm0Nq7/z9btT4hufqkpNxp07n2oB4eS/kQStuKIxx/O/HR396IIkjW/StRaqYSLdMax+hSnYCqPITouWTU71+sSPeJAkhBeMgBLc+SZRhp2vnnkLiMp5jyWRt4KhKkwacAtHJe/KGSz5tVbOiLkZLcO1X+bamEc+3Lcwj7a7amlL4bb9YqOKLKTb5tdbHT7LG/smvgp4dGScpJ3mNSNw96kU2BLgXAIpDbuLvb3r/WWd5HqdQwR2T8g4MDsC87jb5lMACXAIgab8fwWuH5dxQJIxsWuWeL9hLzWuKvzqWzIUvN74WnGMphE96/TNRaOxaCwO135yJCC0ADeOP2t7zu21csT7I8JfKX4SQmIDNRs8RzcXtBPY2Xu8AD8/LeP90UZkOSIr2vYfEascsZoCewcx2UHwovYnZBzD7dU5vjonujaU/2q2AD+uIP9yG5HniHwKHIfzN+Czlwj5B4Md3cc=",
                            -- "eJylVd1PHFUUn7t7dtlhXXG60JWKUNrokyZAaaEFZV2RULI2BAg2RlwuzF2YMh/r7AylmlYQZQtijA8mNm1J2kSFmPjQF2P0odH0rWmffPK5sf4DTUxM9Nw7O+zsQu2Dk8xkzrnndz5+99xz6+MkMUMdR2dyG6mPE9mmcwxCCqro7AKz4aNbfw0oKsszU0Xp93tTCTrraJYJ13rjtuWaKpAUte0x5qnlMPcS5YaKXdYBSaLFIDXQtbfepAph4kKBQTjlCZNUdxmsfkjieepQPUy4YQhCwH1FRR4x2DlcD+QpPwjXPQ3kGU8+AOFGWEmTChDX+6OwfHdnKwYfnw0iuS6IJI3wycUAkq8L//0xuJGtidlfg1xJVccs8fJzMdh8qQJUmJlx83lmowjbzcKiJvVAAokZ35ZDPeG0ijjZ4ZS1yCpSBP/gQzg9OZFWaR96SrX0PF+dap9Pz82W/6IHkd0kuCHT/oZsj+7dEKgiZ4wc9PZSBBzglU/HIBSEoaaG0ks+qByP+hXuiVeq3YweP1Fk5+9KzKkYXMvUQ6iMbTCoqVrnzbBYq6m19EG1j6pumKw42bcbVp/dk0ClCacEuI6vHxGhaQ16I0Iqi7WsrFPy2PZdP+KFxbMabLRDnkkL/rZCy+HH9EyohtFQZcN2m/mEMIv42e3TIuvB3Gu7+3I/5pekhYJNtSLVo3Xj4+MJm52ntsrHzjyzLRkt5Jk5bHSpFaDBcIvaLBfkGVtTYeXRRcW19RwXou3dKlV7uunJk709TM0fY3GHUaOTezKpwaIv/PnT1YcbVx588/2Dz289XF79Y/3HOpc7+ZnEdbbIdGhIORaOmeHC61bRgY0mRSuO6vQCs8MNOKyGeToyT75uHmG8ieR5B//uNykFq6iJsSalgTSzRUtfZDnPqRQ36NJwAUqdyqyLQ1HM0iR7z9UKp828he4S1DY0cw7/wp0ghbvwPYZvN0gkWVzQdD1jWQtIhOLg9Cy6NkPLsyC9DdI7IL2LVnHVZsWipyXJvDY374xbrs65UzDxce4DhSSf40LAtk9507ws9vKyhkVfjsDK9UgWSBoazgAZhS/yYxCawOVJHoAfE81hRg7rvvPtpXbxj29Bpw7jyrUvDUUoTdfAIe+tawaLvPbbwQOfLUtS8yLNlVFLDro7itWPMQ2psGdZVlDW1h7Uic14lCGEF4wAE+58d6oAa1+/YgNxuN+jGfS7iEtL0PY+7LxFCGdlGkueKeeMmO2OAmzdPe5jDn1628M857PqxZZSvvzGUgG9kArNapnhPCd2Hj/n8PDqeIvsklcagXsvZyGUhugZkEZhcyDIXXDLdpMLKvcJsHlCxztjN0DfCNzvywKkISIClNT/G+DmizoOetIkumaI8w1XB5t1jV//Q7aGVzy3FUepC9GnoonjHR2dHV2vwtav0TQ0ZuCH4mBoSI57OeLgHOGfLD8JjaKBSv08R9kPeLtFx/niWfOBMSK+ouE8+6/erLK/Manjdet7z3HvOUHxE73jsOTW01kI+9aXU7vWOArXrk+cg1/GdLxBfATlCJqFyJMRKxJcaSXkX464IO4="
                         }
    local fakeIndex   = 1
    ------------------ functions -----------------------
 

    function registerReconnectEvent( ... )
        require "script/module/public/GlobalNotify"
        GlobalNotify.removeObserver(GlobalNotify.RECONN_OK,serverObject)
        GlobalNotify.addObserver(GlobalNotify.RECONN_OK, function ( ... )
             if(resendFunction) then
                resendFunction()
                -- resendFunction = nil
             end
        end,true,serverObject)
        BattleState.setPlayRecordState(false)
    end

    function removeEvent( ... )
        BattleState.setPlayRecordState(true)
        resendFunction = nil
        require "script/module/public/GlobalNotify"
        if(GlobalNotify) then
            GlobalNotify.removeObserver(GlobalNotify.RECONN_OK,serverObject)
        end
    end
 
    function canSendMessage( ... )
        Logger.debug("Network.m_status:" .. Network.m_status)
        return Network.m_status == g_network_connected
    end

    -- function setWaitState( ... )
    --     state = STATE_WAITING_RESULT
    -- end

    -- function setIdleState( ... )
    --     state = STATE_IDLE
    -- end

	--请求当前阵型
	function requestFormationInfo()

        resendFunction = function ( ... ) requestFormationInfo() end
        registerReconnectEvent()

        if(canSendMessage()) then
		  RequestCenter.getFormationInfo( hanleFormationData )
        -- else
        else
            LoginHelper.reconnect()
        end
         -- --setWaitState()
	end

	--
	function requestEnterLevel()
        
        resendFunction = function ( ... ) requestEnterLevel() end
        registerReconnectEvent()
        if(canSendMessage()) then

           local args = BattleMainData.getEnterLevelArgs()
 

            -- --print("requestEnterLevel: copy_id:",BattleMainData.copy_id," base_id:",BattleMainData.base_id," level:",BattleMainData.level ,"copyType:",BattleMainData.copyType)
            
            -- 一般副本
            if(BattleMainData.copyType== COPY_TYPE_NORMAL)then
                RequestCenter.ncopy_enterBaseLevel(handleEnterBattleLevelCallback, args)
            -- 精英
            elseif(BattleMainData.copyType== COPY_TYPE_ECOPY)then
                RequestCenter.ecopy_enterCopy(handleEnterBattleLevelCallback, args)
            -- 活动本
            elseif(BattleMainData.copyType== COPY_TYPE_EVENT or 
                   BattleMainData.copyType== COPY_TYPE_EVENT_BELLT)then
                print("==requestEnterLevel:",RequestCenter.acopy_enterBaseLevel(handleEnterBattleLevelCallback, args))
            -- 爬塔
            -- elseif(BattleMainData.copyType==4)then
                -- RequestCenter.tower_enterLevel(handleEnterBattleLevelCallback, args)
            -- 觉醒副本
            elseif(BattleMainData.copyType == COPY_TYPE_AWAKE) then
                 RequestCenter.awakeCopy_enterBaseLevel(handleEnterBattleLevelCallback,args)
            else
                error("wrong copy type:" .. tostring(BattleMainData.copyType))
            end
            --setWaitState()
        -- else
        else
            LoginHelper.reconnect()
        end
	end

    function requestDoBattle(  )
        Logger.debug("=== requestDoBattle")
        resendFunction = function ( ... ) requestDoBattle() end
        registerReconnectEvent()
        if(canSendMessage()) then
            --setWaitState()
            if(useFakeData == false or useFakeData == nil ) then 
                local args = BattleMainData.getDoBattleData()

                if(BattleMainData.copyType== COPY_TYPE_NORMAL)then
                    RequestCenter.doBattle(handleDoBattleCallBack,args)
                elseif(BattleMainData.copyType== COPY_TYPE_ECOPY)then
                    RequestCenter.ecopy_doBattle(handleDoBattleCallBack,args)
                -- elseif(BattleMainData.copyType==4)then
                --     RequestCenter.tower_defeatMonster(handleDoBattleCallBack,args)
                elseif(BattleMainData.copyType==COPY_TYPE_EVENT or
                        BattleMainData.copyType==COPY_TYPE_EVENT_BELLT)then
                    RequestCenter.acopy_doBattle(handleDoBattleCallBack,args)
                 -- 觉醒副本
                elseif(BattleMainData.copyType == COPY_TYPE_AWAKE) then
                    RequestCenter.awakeCopy_doBattle(handleDoBattleCallBack,args)
                else
                    error("requestDoBattle:wrong copyType:" .. tostring())
                    -- RequestCenter.acopy_doBattle(handleDoBattleCallBack,args)
                end

                
            else
                local fakeResult = {}
                --print("strongholdid:",BattleMainData.strongholdId,"arymyid:",BattleMainData.strongholdData:getCurrentArmyData().id)

                fakeResult.err="ok"
                fakeResult.ret={}
                fakeResult.ret.fightRet = fakes[fakeIndex]
                fakeResult.ret.appraisal = "s"
                handleDoBattleCallBack(1,fakeResult,1) 
                fakeIndex = fakeIndex + 1
                if(fakeIndex > #fakes) then
                    fakeIndex = 1
                end

            end
        -- else
        else
            LoginHelper.reconnect()   
        end
 
    end

     -- 请求复活
    function requestReviveBench(hid)

        resendFunction = function ( ... ) requestReviveBench(hid) end
        registerReconnectEvent()
        if(canSendMessage()) then

            if(useFakeData == false or useFakeData == nil ) then 

            --setWaitState()
                local args = BattleMainData.getRevivedRequestArgs(hid)

                local callback = function ( cbFlag, dictData, bRet )
                    handleReviveBenchCallBack(cbFlag, dictData, bRet , hid)
                end

                if(BattleMainData.copyType==1)then
                    RequestCenter.ncopy_reviveCard(callback,args)
                elseif(BattleMainData.copyType==2 or BattleMainData.copyType==4)then
                    RequestCenter.ecopy_reviveCard(callback,args)
                else
                    RequestCenter.acopy_reviveCard(callback,args)
                end

            else
                local fakeResult = {}
                --print("strongholdid:",BattleMainData.strongholdId,"arymyid:",BattleMainData.strongholdData:getCurrentArmyData().id)

                fakeResult.err="ok"
                fakeResult.ret={}
                handleReviveBenchCallBack(true,fakeResult,true,hid,heroCard)
            end
        else
            LoginHelper.reconnect()
        end

    end
    -- 请求复活
    function requestRevive(hid,heroCard)
        --print("requestRevive:",hid)

        resendFunction = function ( ... ) requestRevive(hid,heroCard) end
        registerReconnectEvent()
        if(canSendMessage()) then

            if(useFakeData == false or useFakeData == nil ) then 

            --setWaitState()
                local args = BattleMainData.getRevivedRequestArgs(hid)

                local callback = function ( cbFlag, dictData, bRet )
                    handleReviveCallBack(cbFlag, dictData, bRet , hid ,heroCard)
                end

                if(BattleMainData.copyType==1)then
                    RequestCenter.ncopy_reviveCard(callback,args)
                elseif(BattleMainData.copyType==2 or BattleMainData.copyType==4)then
                    RequestCenter.ecopy_reviveCard(callback,args)
                else
                    RequestCenter.acopy_reviveCard(callback,args)
                end

            else
                local fakeResult = {}
                --print("strongholdid:",BattleMainData.strongholdId,"arymyid:",BattleMainData.strongholdData:getCurrentArmyData().id)

                fakeResult.err="ok"
                fakeResult.ret={}
                handleReviveCallBack(true,fakeResult,true,hid,heroCard)
            end
        else
            LoginHelper.reconnect()
        end

         
    end



	------------------ handler -----------------------

     -- 复活回调
    function handleReviveBenchCallBack( cbFlag, dictData, bRet , hid )
        removeEvent()

        function removeWindow(sender, eventType ) -- 确认按钮事件
                if (eventType == TOUCH_EVENT_ENDED) then
                     LayerManager.removeLayout() -- 关闭提示框
                end
        end

        --setIdleState()
        if(dictData.ret~=nil and dictData.err == "ok") then
            --print("复活成功")
            
             -- 增加复活次数
             BattleMainData.countRevivedTime()
      
              -- 修改贝里
             UserModel.addSilverNumber(BattleMainData.getRevivedCost())
             local targetData = BattleMainData.fightRecord:getTargetData(hid)

             if(targetData) then
                targetData.currHp = targetData.maxHp
             end
              -- 发送完毕广播
             EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REVIVE_SUCCESS,hid)
            
             
        elseif(dictData.ret~=nil and dictData.ret=="silver")then
                EventBus.sendNotification(NotificationNames.EVT_REVIVED_FAILED,hid)
                ObjectTool.showTipWindow(BATTLE_CONST.LABEL_3, removeWindow)
        else
                EventBus.sendNotification(NotificationNames.EVT_REVIVED_FAILED,hid)
                -- ObjectTool.showTipWindow( "数据异常，请稍后重试", removeWindow)
                ObjectTool.showTipWindow( gi18nString(1940), removeWindow)
        end
    end
    -- 复活回调
    function handleReviveCallBack( cbFlag, dictData, bRet , hid , heroCard)
        removeEvent()
        --setIdleState()
        if(dictData.ret~=nil and dictData.err == "ok") then
            --print("复活成功")
            
             -- 增加复活次数
             BattleMainData.countRevivedTime()
      
              -- 修改贝里
             UserModel.addSilverNumber(BattleMainData.getRevivedCost())
             
             if(heroCard) then
                heroCard.isDead = false
                
                -- 删除死亡记录
                -- BattleMainData.removeDeadRecord(heroCard.data.positionIndex) 

             end
              -- 发送完毕广播
             EventBus.sendNotification(NotificationNames.EVT_REVIVED_SUCCESS,heroCard)
              
           function removeWindow(sender, eventType ) -- 确认按钮事件
                    if (eventType == TOUCH_EVENT_ENDED) then
                         LayerManager.removeLayout() -- 关闭提示框
                    end
            end  
            
             
        elseif(dictData.ret~=nil and dictData.ret=="silver")then
                EventBus.sendNotification(NotificationNames.EVT_REVIVED_FAILED,hid)
                ObjectTool.showTipWindow(BATTLE_CONST.LABEL_3, removeWindow)
        else
                EventBus.sendNotification(NotificationNames.EVT_REVIVED_FAILED,hid)
                ObjectTool.showTipWindow(  gi18nString(1940), removeWindow)
                -- ObjectTool.showTipWindow( "数据异常，请稍后重试", removeWindow)
        end
         
       
        -- EventBus.sendNotification(NotificationNames.EVT_REVIVE_HERO_COMPLETE)

    end


    -- local behavierTree
    function handleDoBattleCallBack( cbFlag, dictData, bRet )
        --print("handleDoBattleCallBack!!")
        removeEvent()
        local ret = true
        --setIdleState()
        if(dictData.err == "ok") then

            if(dictData.ret.reward) then
                dictData.ret.reward["cur_drop_item"] = dictData.ret.cur_drop_item
            end
            BattleMainData.resetBattleRecordData(dictData.ret.fightRet,dictData.ret.newcopyorbase,dictData.ret.reward,dictData.ret.extra_reward)
            EventBus.sendNotification(NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS)

        else
             BattleModule.destroy()
             -- LayerManager.removeLayout()
             -- ObjectTool.showTipWindow( "请求战斗失败! 已退出战斗", nil, false, nil)
             -- BattleModule.destroy()
        end
      
    end -- function 
 
     function handleEnterBattleLevelCallback(  cbFlag, dictData, bRet )
         ----print("=======enterBaseLvCallback=======")
        --print_table("enterBaseLvCallback",dictData)
        removeEvent()
        local ret = true
        if(dictData.err ~= "ok") then
            -- ObjectTool.showTipWindow( "数据异常，请稍后再试", nil, false, nil)
            ret = false
            BattleModule.destroy()
            ObjectTool.showTipWindow( gi18nString(1940), nil, false, nil)
            -- ObjectTool.showTipWindow( "数据异常，请稍后再试", nil, false, nil)
            --closeLayer()
            -- return
        end -- if end

        if(dictData.ret == "execution") then
            BattleModule.destroy()
            ObjectTool.showTipWindow( gi18nString(1317), nil, false, nil)
            -- ObjectTool.showTipWindow( "体力不足", nil, false, nil)
            ret = false
            return 
            -- closeLayer()
        elseif (dictData.ret == "bag") then
            BattleModule.destroy()
            ObjectTool.showTipWindow( gi18nString(1608), nil, false, nil)
            -- ObjectTool.showTipWindow( "您的装备背包数量已达上限，可以整理或扩充您的装备背包", nil, false, nil)
            ret = false
            return 
                --closeLayer()
        end
        --print("handleEnterBattleLevelCallback:",ret)
        if(ret) then 
            EventBus.sendNotification(NotificationNames.EVT_ENTER_LEVEL_SUCCESS)
        else 
            EventBus.sendNotification(NotificationNames.EVT_ENTER_LEVEL_FAILED)
        end

         --setIdleState()
    end -- function end


 
	function hanleFormationData( cbFlag, dictData, bRet )
        if(dictData.err ~= "ok") then
            
                BattleModule.destroy()
                ObjectTool.showTipWindow( gi18nString(1940), nil, false, nil)
                -- ObjectTool.showTipWindow( "hanleFormationData 数据异常，请稍后再试", nil, false, nil)

        else
                removeEvent()    
                --setIdleState()
                local m_formation = {}
                -- BattleMainData.scPlayerFormation = {}
                for k,v in pairs(dictData.ret) do
                    --local teamInfo = dictData.ret[i]
                    m_formation[tostring(tonumber(k)-1)] = tonumber(v)
                    -- BattleMainData.scPlayerFormation[ (tonumber(k)-1)] = tonumber(v)
                    --print("--------------------- refresh sc:","" .. (tonumber(k)-1), "v:",v)
                end-- for end

                        local scNum = 0
                        for i,va in ipairs(m_formation) do
                            scNum = scNum + 1
                        end

                         --print("--------------------- refresh scNum:",scNum)
               
                FormationModel.setFormationInfo(m_formation)

                --print("------- get server Formation data ")
                --EVT_FORMATION_GET_SUCESS
                EventBus.sendNotification(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE)
        end


	end -- function en


	 

 

    
 
