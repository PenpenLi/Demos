
module("BattleDataUtil",package.seeall)



 
	------------------ properties ----------------------
	selectModule									= nil 		-- module
	--ID_MARK											= 10000000	--id分界线（hero和monster）
	------------------ functions -----------------------



    -- 计算伤害可以获取的伤害额外贝里
    function caculateDamageGetExtraBelly( damage , dpsLevel , bellyLevel)
        if(damage == nil) then damage = 0 end
        if(damage < 0 ) then
            damage = damage * -1
        end
        local result = 0
        if(dpsLevel) then
            local len = #dpsLevel 
            local damageLevel
            for i=1,len do
                damageLevel = dpsLevel[i]
                if(damage >= damageLevel) then
                    result = bellyLevel[i]
                    -- break
                else
                    break
                end
            end

            if(result == nil) then
                damageLevel = dpsLevel[#dpsLevel]
                if(damageLevel <= damage) then
                    result = bellyLevel[#bellyLevel]
                end
            end

        end

        return result
    end


    function caculateDamgeGetTotalBelly(id,damage)
        
         dpsLevel,bellyLevel = db_activitycopy_util.getDamgeDesInfo(id)
         assert(dpsLevel,"贝里副本未发现伤害和获得贝里描述数据")
         assert(bellyLevel,"贝里副本未发现伤害和获得贝里描述数据")
         radio = db_activitycopy_util.getBellyRatio(id)

        local baseBelly     = damage * radio
        local extraBelly    = caculateDamageGetExtraBelly(damage,dpsLevel,bellyLevel)
        local activeRadio   = OutputMultiplyUtil.getDailyCopyRateNum( id ) /10000
        if(activeRadio == nil or activeRadio <= 0) then
            activeRadio = 1
        end
        local total         = math.floor((baseBelly + extraBelly)* BattleMainData.activeRadio)
        -- print(" --caculateDamgeGetTotalBelly:",BattleMainData.activeRadio,damage,radio,dpsLevel,bellyLevel,extraBelly,total)
        return total
        
        -- 获得贝里值=基础贝里+额外贝里
        -- 基础贝里=伤害值*系数，系数在表中有配置
        -- 额外贝里按照伤害档次划分，获得额外贝里总值和伤害总值档位在表中有配置，是一一对应的关系。

    end 

	-- 获取替补显示数据(data->BattleObjectData)
    function getBenchDisplayData( targetData )
        
        -- assert(targetData,"未找到替补英雄数据htid:".. tostring(targetData.htid))
        assert(targetData,"替补数据为空!!")

            local db_hero       = DB_Heroes.getDataById(tonumber(targetData.htid))
            local sHeadIconImg  = "images/base/hero/head_icon/" .. db_hero.head_icon_id
            local grade         = BattleDataUtil.getGrade(targetData.id,targetData.htid)
            local gradeName     = "officer_" .. grade .. ".png"
            local bgURL         = BattleURLManager.getBenchIconBG(gradeName)
            if(not file_exists(bgURL)) then
                error("替补资源头像不存在:" .. tostring(gradeName) .. tostring("  id=") .. tostring(targetData.id) .. tostring(" htid:") .. tostring(targetData.htid))
                return 
            end
           return {id=targetData.id,htid=targetData.htid,headURL=sHeadIconImg,bgURL=bgURL,isDead=targetData:isDead(),pos=targetData.positionIndex}
    end

-- 获取替补显示数据(data->BattleObjectData)
    function getBenchDisplayDataFromHeroModel( targetData ,position)
        
        -- assert(targetData,"未找到替补英雄数据htid:".. tostring(targetData.htid))
        assert(targetData,"替补数据为空!!")

            local db_hero       = DB_Heroes.getDataById(tonumber(targetData.htid))
            local sHeadIconImg  = "images/base/hero/head_icon/" .. db_hero.head_icon_id
            local grade         = BattleDataUtil.getGrade(targetData.hid,targetData.htid)
            local gradeName     = "officer_" .. grade .. ".png"
            local bgURL         = BattleURLManager.getBenchIconBG(gradeName)
            if(not file_exists(bgURL)) then
                error("替补资源头像不存在:" .. tostring(gradeName))
                return 
            end
           return {id=targetData.hid,headURL=sHeadIconImg,bgURL=bgURL,pos=tonumber(position)}
    end


    function getBenchDisplayDataFrom( ... )
    end


    function getHpNumberColor( value , fatal )
        if(fatal == true) then
            return BATTLE_CONST.NUMBER_ORANGE
        elseif(value <0) then
            return BATTLE_CONST.NUMBER_RED
        else
            return BATTLE_CONST.NUMBER_GREEN
        end
    end
	--获取真实htid
	function getRealHtid( hid ,htid)
		local realHtid = htid
		local isPlayer = false
		--怪物的hid == htid
		if isMonster(hid) then
			realHtid = hid
		end
	end


	--判断是否是英雄
	function isHero( hid )
        if hid == nil then
            --print("isHero-》 hid is nil")
        end
		return tonumber(hid) >= BATTLE_CONST.ID_MARK
	end
	--判断是否是怪物
	function isMonster( hid )
		return tonumber(hid) < BATTLE_CONST.ID_MARK
	end

    -- 获取星等 和对应的颜色(用于名字)
    function getGradeColor(grade)
        local color = 0
        if(grade == 3) then
             color = ccc3(77,236,23)
        elseif(grade == 4) then
             color = ccc3(31,215,255)
        elseif(grade == 5) then
            color = ccc3(238,70,236)
        elseif(grade == 6) then
            color = ccc3(255,144,0)
        elseif(grade == 7) then
            color = ccc3(255,48,27)
        elseif(grade == BATTLE_CONST.CARD_DEMON_GRADE) then
            color = ccc3(238,70,236)
        else

            color = ccc3(219,219,219)
        end
        return color
    end


    -- 怪用hid 索引 db_monster得到htid
    -- 英雄用htid直接索引
    function getGrade( hid , htid)
        hid             = tonumber(hid)
        local hero      
        local grade     = 0
        if  isHero(hid) then
           hero = db_heroes_util.getItemByid(htid)--DB_Heroes.getDataById(htid)
            if(hero==nil)then
                grade = db_monsters_tmpl_util.getGrade(htid)
            else
                grade = db_heroes_util.getGrade(htid)
            end -- if end
        else
            
            local monster = db_monsters_util.getItemById(hid)
            
            if(monster==nil) then
               monster = db_monsters_util.getItemById(3014201)
            end -- if end
 
            grade = db_monsters_tmpl_util.getGrade(monster.htid)
    
        end
        
        
        return grade

    end


    function isRoleHero(modelid)
        return  modelid == 20001 or modelid == 20002
    end
    
    function getHeroName( hid , htid ,teamid)
        hid             = tonumber(hid)
        local teamData = BattleMainData.fightRecord
        local getTeamName = function ( ... )

                                                if(teamid == BATTLE_CONST.TEAM2) then
                                                    return  BattleMainData.team2LeaderName
                                                end
                                                return BattleMainData.team1LeaderName
                            end
        local name      
        -- if(not isRoleHero(htid)) then
            -- 10058044,20101 
            if isHero(hid) then


                -- Logger.debug("== target is hero ")
               -- name = db_heroes_util.getName(htid)--DB_Heroes.getDataById(htid)
               local hero = db_heroes_util.getItemByid(htid)
               if(hero and not isRoleHero(hero.model_id)) then
                     -- Logger.debug("== target is hero ")
                    if(hero==nil)then

                        name = db_monsters_tmpl_util.getName(htid)
                    else
                        name = db_heroes_util.getName(htid)
                    end -- if end
                --如果是主句
                else
                    Logger.debug("== target is role " .. tostring(getTeamName()))
                    name = getTeamName()
                end
            else
                -- Logger.debug("target hid:" .. hid .. ", htid:" .. htid)
                local monster = db_monsters_util.getItemById(hid)
                
                if(monster==nil) then
                   monster = db_monsters_util.getItemById(3014201)
                end -- if end
                local monster_tem = db_monsters_tmpl_util.getItemByid(monster.htid)

                -- Logger.debug("== target hid:" .. tostring(hid) .. ", htid:" .. tostring(monster.htid) .. ",modelid:" .. tostring(monster_tem.model_id))
                if(not isRoleHero(tonumber(monster_tem.model_id))) then
                    -- Logger.debug("== target is monster")
                    name = db_monsters_tmpl_util.getName(monster.htid)
                else
                    -- Logger.debug("== target is leader")
                    name = getTeamName()
                end
        
            end
       
           
        -- end
        
        return name

    end

    -- --获取人物动作图片名字
    -- function getActionImage(hid,htid)

    --     if isHero(hid) then
    --         selectModule    = DB_Heroes
    --     else
    --         local monster   = DB_Monsters.getDataById(tonumber(hid))
    --          if monster == nil then
    --              monster    = DB_Monsters.getDataById(1002011)
    --          end
            

    --         htid            = monster.htid
            
    --         selectModule    = DB_Monsters_tmpl
    --     end


    --     local  item = selectModule.getDataById(tonumber(htid))
    --     if item ~= nil then
    --         return item.action_module_id
    --     else
    --         --print("can't find :hid",hid," htid:",htid)
    --     end


         
    -- end
     -- 获取反击技能
     function getBeatBackSKill( hid , htid )
         local beatBackSkill = nil
         local realyHtid = getHtid(hid,htid)
           if isHero(hid) then
                beatBackSkill =  db_heroes_util.getBeatBackSkillId(realyHtid)
           else
                beatBackSkill =  db_monsters_tmpl_util.getBeatBackSkillId(realyHtid)
           end
        return beatBackSkill
     end
     function getRageHeadIconName(hid , htid)

        local rageHeadName
           if isHero(hid) then
                rageHeadName =  db_heroes_util.getRageHeadIconName(hid)
           else

                rageHeadName =  db_monsters_tmpl_util.getRageHeadIconName(hid)
           end
        return rageHeadName
     end

     function getHtid(hid,htid)
        if  isHero(hid) then
            return htid
        else
            local monster = db_monsters_util.getItemById(hid)
            return monster.htid
        end
        
     end
      --获取人物动作图片名字
     function getActionImage(hid , htid ,isBoss,isOutline,isSuper)
       -- --print("@@@      hid:",hid," htid:",htid)
                    ---- 10010271    htid:  20201
        local hero      
        local actionModuleName     = 0
        if  isHero(hid) then
            -- Logger.debug("@@@  hid ".. hid .. "  htid:".. htid .." is hero" .. " isboss:" .. tostring(isBoss == true))
           hero = db_heroes_util.getItemByid(htid)--DB_Heroes.getDataById(htid)
            if(hero==nil)then
                actionModuleName = db_monsters_tmpl_util.getActionModuleName(htid,isBoss,isOutline,isSuper)
            else
                actionModuleName = db_heroes_util.getActionModuleName(htid,isBoss,isOutline,isSuper)
            end -- if end

        else
            ----print("@@@         is monster")
            -- Logger.debug("@@@  hid ".. hid .. "  htid:".. htid .." is monster" .. " isboss:" .. tostring(isBoss == true))
            local monster = db_monsters_util.getItemById(hid)
            local fake = ""
            if(monster==nil) then
               -- print("@@@      not find monster:",hid)
               monster = db_monsters_util.getItemById(3014201)
               fake = "nil:"
                
                ObjectTool.showTipWindow( "未找到:monsters" .. hid, nil, false, nil)
                return
            else
            --     --print("@@@      find monster:",hid)
            end -- if end
 
            actionModuleName = fake..db_monsters_tmpl_util.getActionModuleName(monster.htid,isBoss,isOutline,isSuper)
            -- Logger.debug("@@@  hid ".. hid .. "  htid:".. htid .. " isboss:" .. tostring(isBoss == true) .. " isSuper:" .. tostring(isSuper == true) .. "name:" ..actionModuleName )
        end
        -- --print("@@@         actionName:",actionModuleName)
        return actionModuleName
        
	end


function getDifferenceYByImageName(imageFile,isBoss)
    if(isBoss==nil)then
        isBoss = false;
    end
    
    local changeY = 0
    if("zhan_jiang_dingyuan.png"==imageFile) then
        changeY = -37
        elseif("zhan_jiang_guanyinping.png"==imageFile) then
        changeY = -25
        elseif("zhan_jiang_zhegeliang.png"==imageFile) then
        changeY = -44
        elseif("zhan_jiang_zhenji.png"==imageFile) then
        changeY = -8
        elseif("zhan_jiang_diaochan.png"==imageFile) then
        changeY = -15
        elseif("zhan_jiang_ganning.png"==imageFile and isBoss==false) then
        changeY = -17
        elseif("zhan_jiang_xiahoudun.png"==imageFile) then
        changeY = -17
        elseif("zhan_jiang_zhangfei.png"==imageFile) then
        changeY = -6
        elseif("zhan_jiang_nvzhu.png"==imageFile) then
        changeY = -23
        elseif("zhan_jiang_wenguan6.png"==imageFile) then
        changeY = -61
        elseif("zhan_jiang_zhugeliang.png"==imageFile and isBoss==false) then
        changeY = -40
        elseif("zhan_jiang_sunjian.png"==imageFile and isBoss==false) then
        changeY = -10
        elseif("zhan_jiang_taishici.png"==imageFile and isBoss==false) then
        changeY = -30
        elseif("zhan_jiang_zhangbao.png"==imageFile) then
        changeY = -47
        elseif("zhan_jiang_guanyu.png"==imageFile) then
        changeY = -31
        elseif("zhan_jiang_dongzhuo.png"==imageFile) then
        changeY = -15
        elseif("zhan_jiang_simayi.png"==imageFile) then
        changeY = -12
        elseif("zhan_jiang_wujiang9.png"==imageFile) then
        changeY = -38
        elseif("zhan_jiang_yujin.png"==imageFile) then
        changeY = -44
        elseif("zhan_jiang_zhaoyun.png"==imageFile) then
        changeY = -32
        elseif("zhan_jiang_zhurong.png"==imageFile) then
        changeY = -17
        elseif("zhan_jiang_sunce.png"==imageFile) then
        changeY = -31
        elseif("zhan_jiang_xuchu.png"==imageFile and isBoss == false) then
        changeY = -10
        elseif("zhan_jiang_xuchu.png"==imageFile) then
        changeY = -12
        elseif("zhan_jiang_xuhuang.png"==imageFile) then
        changeY = -32
        elseif("zhan_jiang_xushu.png"==imageFile) then
        changeY = -6
        elseif("zhan_jiang_dianwei.png"==imageFile) then
        changeY = -31
        elseif("zhan_jiang_weiyan.png"==imageFile) then
        changeY = -7
        elseif("zhan_jiang_xunyou.png"==imageFile) then
        changeY = -35
        elseif("zhan_jiang_guanping.png"==imageFile) then
        changeY = -22
        elseif("zhan_jiang_chengpu.png"==imageFile) then
        changeY = -21
        elseif("zhan_jiang_xunyu.png"==imageFile) then
        changeY = -21
        elseif("zhan_jiang_lvbu.png"==imageFile and isBoss==false) then
        changeY = -45
        elseif("zhan_jiang_molvbu.png"==imageFile and isBoss==false) then
        changeY = -102
        elseif("zhan_jiang_mozhangjiao.png"==imageFile and isBoss==false) then
        changeY = -78
        elseif("zhan_jiang_molvbu.png"==imageFile) then
        changeY = -138
        elseif("zhan_jiang_mozhangjiao.png"==imageFile) then
        changeY = -144
        elseif("zhan_jiang_mowang.png"==imageFile) then
        changeY = -41
        elseif("zhan_jiang_mowang_1.png"==imageFile) then
        changeY = -41
        elseif("zhan_jiang_sunjian.png"==imageFile) then
        changeY = -32
        elseif("zhan_jiang_lvbu.png"==imageFile) then
        changeY = -63
        elseif("zhan_jiang_fazheng.png"==imageFile) then
        changeY = -20
        elseif("zhan_jiang_caoren.png"==imageFile and isBoss==false) then
        changeY = -42
        elseif("zhan_jiang_handang.png"==imageFile and isBoss==false) then
        changeY = -27
        elseif("zhan_jiang_huatuo.png"==imageFile and isBoss==false) then
        changeY = -38
        elseif("zhan_jiang_sunquan.png"==imageFile and isBoss==false) then
        changeY = -46
        elseif("zhan_jiang_zhuhuan.png"==imageFile and isBoss==false) then
        changeY = -28
        elseif("zhan_jiang_nanzhu2.png"==imageFile and isBoss==false) then
        changeY = -29
        elseif("zhan_jiang_nvzhu2.png"==imageFile and isBoss==false) then
        changeY = -16
        elseif("zhan_jiang_yinma.png"==imageFile and isBoss==false) then
        changeY = -25
        elseif("zhan_jiang_jinma.png"==imageFile and isBoss==false) then
        changeY = -23
        elseif("zhan_jiang_zhuyi.png"==imageFile and isBoss==false) then
        changeY = -43
        elseif("zhan_jiang_zhuyi.png"==imageFile ) then
        changeY = -52
        elseif("zhan_jiang_yinma.png"==imageFile ) then
        changeY = -18
        elseif("zhan_jiang_jinma.png"==imageFile ) then
        changeY = -16
        elseif("zhan_jiang_caoren.png"==imageFile ) then
        changeY = -66
        elseif("zhan_jiang_ganning.png"==imageFile) then
        changeY = -32
        elseif("zhan_jiang_handang.png"==imageFile ) then
        changeY = -26
        elseif("zhan_jiang_sunquan.png"==imageFile ) then
        changeY = -81
        elseif("zhan_jiang_zhugeliang.png"==imageFile ) then
        changeY = -56
        elseif("zhan_jiang_taishici.png"==imageFile ) then
        changeY = -77
        elseif("zhan_jiang_feiwei.png"==imageFile ) then
        changeY = -38
        elseif("zhan_jiang_guansuo.png"==imageFile ) then
        changeY = -41
        elseif("zhan_jiang_masu.png"==imageFile ) then
        changeY = -39
        elseif("zhan_jiang_simazhao.png"==imageFile ) then
        changeY = -36
        elseif("zhan_jiang_xunyu.png"==imageFile ) then
        changeY = -25
        elseif("zhan_jiang_yangxiu.png"==imageFile ) then
        changeY = -45
        elseif("zhan_jiang_xiahouyuan.png"==imageFile and isBoss==false) then
        changeY = -29
        elseif("zhan_jiang_xiahouyuan.png"==imageFile ) then
        changeY = -37
        elseif("zhan_jiang_nanzhu_shizhuang1.png"==imageFile ) then
        changeY = -21
        elseif("zhan_jiang_nvzhu_shizhuang1.png"==imageFile ) then
        changeY = -32
    end
    
    return changeY
end