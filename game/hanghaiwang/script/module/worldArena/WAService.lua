-- FileName: WAService.lua
-- Author: huxiaozhou
-- Date: 2016-02-17
-- Purpose: 网络请求服务
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("WAService", package.seeall)
--[[
	/**
	 * 拉取基础信息
	 *
	 * @return array
	 * {
	 * 		ret								请求状态，取值范围： 'ok'
	 * 		stage							所处阶段，取值范围：'before_signup','signup','range_room','attack','reward'
	 * 		team_id							分组id，没分组则为0
	 * 		room_id							房间id，没分房则为0
	 * 		pid								返给前端自己的Pid
	 * 		signup_time						报名时间，没报名则为0
	 * 		period_bgn_time					周期开始时间
	 * 		period_end_time					周期结束时间
	 * 		signup_bgn_time					报名开始时间
	 * 		signup_end_time					报名结束时间
	 * 		attack_bgn_time					攻打开始时间
	 * 		attack_end_time					攻打结束时间
	 * 		cd_duration_before_end			攻打结束前有cd的持续时间，目前是10分钟
	 * 		extra							扩展信息，可以取如下值,处于不同阶段时候，这个字段的key不同
	 * 		{
	 * 			[stage为before_signup时候取如下值:]
	 * 			空
	 *
	 * 			[stage为signup时候取如下值:]
	 * 			update_fmt_time				更新战斗信息时间
	 *
	 * 			[stage为range_room时候取如下值:]
	 * 			空
	 *
	 * 			[stage为attack时候取如下值:]
	 * 			atk_num						当前剩余的攻击次数
	 * 			buy_atk_num					已经购买的攻击次数
	 * 			silver_reset_num			银币重置次数
	 * 			gold_reset_num				金币重置次数
	 * 			kill_num					玩家的击杀总数
	 * 			cur_conti_num				玩家当前的连杀数
	 * 			max_conti_num				玩家最大的连杀数
	 * 			last_attack_time			玩家上次主动攻打的时间
	 * 			player						玩家列表，包括对手和自己，按照pos排序
	 * 			[
	 * 				pos => array
	 * 				{
	 * 					server_id
	 * 					server_name
	 * 					pid
	 * 					uname
	 * 					htid
	 * 					level
	 * 					vip
	 * 					fight_force
	 * 					dress
	 * 					hp_percent			以10000作为基地
	 * 					protect_time
	 * 					self				如果是自己为1，别人为0
	 * 				}
	 * 			]
	 *
	 * 			[stage为reward时候取如下值:]
	 * 			空
	 * 		}
	 * }
	 */
--]]

function getWorldArenaInfo(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getWorldArenaInfo","worldarena.getWorldArenaInfo",nil,true)
end
	
function getWorldArenaInfoLogin( fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getWorldArenaInfoLogin","worldarena.getWorldArenaInfoLogin",nil,true)
end


-- /**
-- * 玩家报名
-- * 
-- * @return	int							返回玩家报名时间
-- */
function signUp(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.signUp","worldarena.signUp",nil,true)
end

-- /**
-- * 更新战斗信息
-- * 
-- * @return	int							返回玩家更新战斗力的时间
-- */
function updateFmt( fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.updateFmt","worldarena.updateFmt",nil,true)
end


function enter( fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.enter","worldarena.enter",nil,true)
end

function leave( fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.leave","worldarena.leave",nil,true)
end

--[[
	/**
	 * 攻击某个排名的玩家
	 *
	 * @param int $serverId
	 * @param int $pid
	 * @param int $skip
	 * @return array
	 * {
	 * 		ret								请求状态，取值范围： 'ok'正常/'out_range'对手和自己的相对排名变化超出范围/'protect'对方在保护时间内
	 *
	 * 		以下字段和getWorldArenaInfo中返回的相同
	 * 		atk_num							当前剩余的攻击次数
	 * 		buy_atk_num						已经购买的攻击次数
	 * 		silver_reset_num				银币重置次数
	 * 		gold_reset_num					金币重置次数
	 * 		kill_num						玩家的击杀总数
	 * 		cur_conti_num					玩家当前的连杀数
	 * 		max_conti_num					玩家最大的连杀数
	 * 		last_attack_time				玩家上次主动攻打的时间
	 * 		player							玩家列表，包括对手和自己，按照pos排序
	 * 		[
	 * 			pos => array
	 * 			{
	 * 				server_id
	 * 				server_name
	 * 				pid
	 * 				uname
	 * 				htid
	 * 				level
	 * 				vip
	 * 				fight_force
	 * 				dress
	 * 				hp_percent				以10000作为基地
	 * 				protect_time
	 * 				self					如果是自己为1，别人为0
	 * 			}
	 * 		]
	 *
	 * 		以下字段只有在ret为ok的时候才有的字段
	 * 		fightRet						战斗串，不是跳过战斗的情况下才有这个值
	 * 
	 * 		reward							各种奖励
	 * 		{
	 * 			win_reward					打赢对手的奖励，普通奖励
	 * 			conti_reward				打赢对手的奖励，连杀的奖励
	 * 			terminal_conti_reward		打赢对手的奖励，终结连杀奖励
	 * 		}
	 * 		terminal_conti_num				如果胜利的话，而且终结了对方的连胜，这个值是终结的对方的连胜值
	 * }
	*/
--]]

function attack( p_serverId, p_pid, p_skip, fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ p_serverId, p_pid, p_skip })
	Network.rpc(requestFunc,"worldarena.attack","worldarena.attack",args,true)
end
	
-- /**
-- * 购买攻击次数
-- * 
-- * @param int $num
-- * @return num
-- */
function buyAtkNum(p_num, fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ tonumber(p_num) })
	Network.rpc(requestFunc,"worldarena.buyAtkNum","worldarena.buyAtkNum",args,true)
end
	
-- /**
-- * 重置，包含更新战斗信息，回满血
-- * 
-- * @param str $type 					取值如下：'silver'银币重置/'gold'金币重置 
-- * @return 'ok'
-- */
function reset( p_type, fnCallBack )
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ p_type })
	Network.rpc(requestFunc,"worldarena.reset","worldarena.reset",args,true)
end

-- /**
--  * 获得战报列表
--  *
--  * @return array
--  * {
--  * 		my => array
--  * 		[
--  * 			{
--  * 				attacker_server_id		攻方服务器id
--  * 				attacker_server_name	攻方服名字
--  * 				attacker_pid			攻方pid
--  * 				attacker_uname			攻方名字
--  * 				attacker_utid			攻方utid
--  * 				attacker_rank			攻方名次
--  * 				attacker_conti          攻方连胜次数
--  * 				attacker_terminal_conti 攻方终结对方连胜次数
--  * 				defender_server_id		守方服务器id
--  * 				defender_server_name	守方服名字
--  * 				defender_pid			守方pid
--  * 				defender_uname			守方名字
--  * 				defender_utid			守方utid
--  * 				defender_rank			守方名次
--  * 				defender_conti          守方连胜次数
--  * 				defender_terminal_conti 守方终结对方连胜次数
--  * 				attack_time				攻击时间
--  * 				result					结果，1代表攻方胜，0代表守方胜
--  * 				brid					战报id
--  * 			}
--  * 		]
--  * 		conti => array
--  * 		[
--  * 			{
--  * 				结构同上
--  * 			}
--  * 		]
--  * }
-- */
function getRecordList(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getRecordList","worldarena.getRecordList",nil,true)
end

-- /**
--  * 获得排行
--  *
--  * @return array
--  * {
--  * 		pos_rank => array				对决排行
--  * 		[
--  * 			{
--  * 				rank
--  * 				server_id
--  * 				server_name
--  * 				pid
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				fight_force
--  * 				figure
--  * 				ship_figure
--  * 			}
--  * 		]
--  * 		kill_rank => array				击杀排行
--  * 		[
--  * 			{
--  * 				rank
--  * 				kill_num				击杀数
--  * 				server_id
--  * 				server_name
--  * 				pid
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				fight_force
--  * 				figure
--  * 				ship_figure
--  * 			}
--  * 		]
--  * 		conti_rank => array				连杀排行
--  * 		[
--  * 			{
--  * 				rank
--  * 				max_conti_num			最大连杀数
--  * 				server_id
--  * 				server_name
--  * 				pid
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				fight_force
--  * 				figure
--  * 				ship_figure
--  * 			}
--  * 		]
--  * }
-- */
function getRankList(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getRankList","worldarena.getRankList",nil,true)
end

-- /**
--  * 获得押注列表，战力排行靠前的一部分人和自己每个榜单押注的人
--  *
--  * @return array
--  * {
--  * 		fight_force_rank => array		战斗力排行
--  * 		[
--  * 			{
--  * 				rank					玩家的战力的排名
--  * 				kill_rank				玩家的击杀排名,0代表未上榜
--  * 				conti_rank				玩家的连杀排名,0代表未上榜
--  * 				pos_rank				玩家的位置排名,0代表未上榜
--  * 				kill_beted_num			玩家击杀榜被押注的人数
--  * 				conti_beted_num			玩家连杀榜被押注的人数
--  * 				pos_beted_num			玩家位置榜被押注的人数
--  * 				server_id
--  * 				server_name
--  * 				pid
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				fight_force
--  * 				figure
--  * 				ship_figure
--  * 			}
--  * 		]
--  * 		self_bet => array				自己押注的人，如果没有押注，则为空
--  * 		[
--  * 			{
--  * 				rank_type				押注的榜单类型
--  * 				bet_type
--  * 				bet_num
--  * 				rank					被押注者的榜单排名,0代表未上榜
--  * 				beted_num				被押注者的被押注数量
--  * 				server_id
--  * 				server_name
--  * 				pid
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				fight_force
--  * 				figure
--  * 				ship_figure
--  * 			}
--  * 		]
--  * }
--  */
function getBetList(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getBetList","worldarena.getBetList",nil,true)
end

-- /**
--  * 押注
--  *
--  * @param int $serverId
--  * @param int $pid
--  * @param int $rankType					榜单类型：'1'击杀排行/'2'连杀排行/'3'名次排行
--  * @param int $type 					取值如下：'1'银币押注/'2'金币押注
--  * @param int $num
--  * @return 'ok'
-- */
function bet(p_serverId, p_pid, p_rankType, p_type, p_num, fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ p_serverId, p_pid, p_rankType, p_type, p_num })
	Network.rpc(requestFunc,"worldarena.bet","worldarena.bet",args,true)
end

-- /**
--  * 获取留言板内容
--  * 
--  * @return
--  * array
--  * {
--  * 		my_msg_num						我自己发的消息次数
--  * 		msg => array					本房间内的所有消息
--  * 		[
--  * 			{
--  * 				uname
--  * 				utid
--  * 				level
--  * 				vip
--  * 				figure
--  * 				ship_figure
--  * 				msg
--  * 				msg_time
--  * 			}
--  * 		]
--  * }
--  */
function getMsg(fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	Network.rpc(requestFunc,"worldarena.getMsg","worldarena.getMsg",nil,true)
end

-- /**
--  * 留言
--  * 
--  * @param string $msg
--  * @return string 'ok'
--  */
function leaveMsg(p_msg, fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ p_msg })
	Network.rpc(requestFunc,"worldarena.leaveMsg","worldarena.leaveMsg",args,true)
end

function getFighterDetail( p_serverId, p_pid, fnCallBack)
	local requestFunc = function(cbFlag,dictData,bRet)
		if dictData.err == "ok" then
			if(fnCallBack ~= nil)then
				fnCallBack(dictData.ret)
			end
		end
	end
	local args = Network.argsHandlerOfTable({ p_serverId, p_pid})
	Network.rpc(requestFunc,"worldarena.getFighterDetail","worldarena.getFighterDetail",args,true)
end


