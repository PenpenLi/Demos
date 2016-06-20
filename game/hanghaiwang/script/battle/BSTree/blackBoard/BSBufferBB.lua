


-- 攻击者blackBoard,输入table.roundData 为所需要的数据
require (BATTLE_CLASS_NAME.class)
local BSBufferBB = class("BSBufferBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
 		BSBufferBB.hasDeleteTimeBuff			= nil -- 移除buff是否可以释放
 		BSBufferBB.hasAddTimeBuff				= nil -- 添加buff是否可以释放
 		BSBufferBB.hasDamageTimeBuff 			= nil -- 伤害buff是否可以释放
 		BSBufferBB.hasImTimeBuff 				= nil -- 免疫

 		BSBufferBB.bufferData 					= nil -- buff数据- BattleObjectBuffData
 		
 		BSBufferBB.addList						= nil -- 添加
 		BSBufferBB.hasAddBuff					= nil 

 		BSBufferBB.deleteList 					= nil -- 删除
 		BSBufferBB.hasDeleteBuff				= nil

 		BSBufferBB.imList 						= nil -- 免疫
 		BSBufferBB.hasImBuff					= nil -- 

 		BSBufferBB.damageList					= nil -- buff伤害
 		-- BSBufferBB.hasDamageBuff				= nil 
 		BSBufferBB.targetId 					= nil -- buff释放目标
 		BSBufferBB.target 						= nil -- buff释放目标
 		BSBufferBB.des							= "BSBufferBB"
 		BSBufferBB.delayBuffDamage 				= nil -- 是否延迟播放buff伤害(如果有hp技能伤害时,会有延迟)
 		------------------ functions -----------------------
 		-- data:buffDataInfo, 
 		-- inBuffList:所有buff
 		-- outBuff:buff输出
 		-- indexTimeFunc buff时间检索函数
 		-- timeType 当前时间类型
 		-- 状态名称
 		function BSBufferBB:handleTimeBuff(data,inBuffList,outBuff,indexTimeFunc,timeType,stateName,bfType)
 			local count 					= 0
			for k,item in pairs(inBuffList) do
				local buffid
				local inertItem  
				if(type(item) == "table") then 
					buffid 						= tonumber(item.id)
					inertItem 					= true
					-- --print("itemIs table:",item.id)
				else
					buffid 						= tonumber(item)
					-- --print("itemIs table:",buffid)
					inertItem					= false
				end
				
				-- 是否运行过
				-- Logger.debug("get buff:" .. buffid)
				-- if(data:isFirstRun(buffid,bfType)) then
					
					local showTimeType		= indexTimeFunc(buffid)
					 -- Logger.debug("target:".. self.targetId .." isFirstRun ".. stateName ..  " showTimeType:" .. showTimeType .. " timeType:" .. timeType .. " buffid:" .. buffid)
					 -- local showTimeType		= db_buff_util.getAddTime(buffid)
					if(
						showTimeType == timeType or
						timeType     == nil or 
						showTimeType == nil
						-- showTimeType == 2 	or
					  ) then  --or (showTimeType==2 and timeType==3)
						
						-- Logger.debug(stateName,": buff is first run:"..buffid.. " target:".. self.targetId .. " timeType:" .. bfType)
						-- data:record(buffid,bfType)
						count 				= count + 1
						if(inertItem) then
							table.insert(outBuff,item)
						else
							table.insert(outBuff,buffid)
						end	 
						inBuffList[k] = nil
						
						-- --print("buff record:",buffid)
					else
						 -- Logger.debug("buff:" .. buffid .. " is not fire time " .. " showTimeType:" .. showTimeType .. " timeType:" .. timeType)
					end

					if(count > 0) then 
						self[stateName] = true 
					end
				-- else
				-- 	--print("buff is not first run")
				-- end -- if end
				
			end -- for end
 		end
		function BSBufferBB:reset( data ,timeType) -- data BattleBuffsInfo

			if(data ~= nil ) then
					-- self.data 						= data
					self.targetId					= data.id
					self.target 					= BattleMainData.fightRecord:getTargetData(self.targetId)
					-- Logger.debug("SBufferBB:reset id:" .. data.id)
					-- 初始化各种类型的buffer
					self.hasAddTimeBuff				= false
					if(data.enBuffer ~= nil) then
				
						self.hasAddBuff 			= true
						self.addList 				= {}
						-- --print("BSBufferBB: self.hasAddBuff:",self.hasAddBuff)
						
						self:handleTimeBuff(data,data.enBuffer,self.addList,db_buff_util.getAddTime,timeType,"hasAddTimeBuff",BATTLE_CONST.BF_ADD)

					else
						self.hasAddBuff 			= false
					end

					self.delayBuffDamage 			= data.hasSkillDamage
					-- print("--- BattleUnderAttackerData delayBuffDamage:",data.hasSkillDamage,self.delayBuffDamage)
		

					self.hasImTimeBuff 				= false
					if(data.imBuffer ~= nil) then
						self.hasImBuff 				= true
						self.imList					= {}
						self:handleTimeBuff(data,data.imBuffer,self.imList,db_buff_util.getAddTime,timeType,"hasImTimeBuff",BATTLE_CONST.BF_IM)
					
					else
						self.hasImBuff 				= false
					end




					self.hasDeleteTimeBuff			= false
					if(data.deBuffer ~= nil) then
						self.hasDeleteBuff 			= true
						self.deleteList				= {}
						self:handleTimeBuff(data,data.deBuffer,self.deleteList,db_buff_util.getRemoveTime,timeType,"hasDeleteTimeBuff",BATTLE_CONST.BF_REMOVE)
					else
						self.hasDeleteBuff 			= false
					end



					self.hasDamageTimeBuff			= false
					if(data.buffer ~= nil) then

						

						self.hasDamageTimeBuff 		= true
						self.damageList				= {}
						-- print("data.buffer type:" .. type(data.buffer))
						-- if(type(data.buffer) == "table") then
						-- 	for k,v in pairs(data.buffer) do
						-- 		print("data.buffer:",k,v)
						-- 	end
						-- end
						self:handleTimeBuff(data,data.buffer,self.damageList,db_buff_util.getDamageTime,timeType,"hasDamageTimeBuff",BATTLE_CONST.BF_DAMAGE)
						-- Logger.debug("BSBufferBB: self.hasDamageTimeBuff:" .. tostring(self.hasDamageTimeBuff) .. " time:" .. timeType)
					else
						self.hasDamageTimeBuff 		= false
					end


					-- if(self.hasAddTimeBuff) then
					-- 	print("#	--- 有buff添加")
					-- else
					-- 	print("#	--- 无buff添加")
					-- end


					-- if(self.hasImTimeBuff) then
					-- 	print("#	--- 有buff免疫")
					-- else
					-- 	print("#	--- 无buff免疫")
					-- end

					-- if(self.hasDeleteTimeBuff) then
					-- 	print("#	--- 有buff删除")
					-- else
					-- 	print("#	--- 无buff删除")
					-- end

					-- if(self.hasDamageTimeBuff) then
					-- 	print("#	--- 有buff伤害")
					-- else
					-- 	print("#	--- 无buff伤害")
					-- end
			else
				assert(self.targetId)
			end -- if end

		end -- function end
		
return BSBufferBB