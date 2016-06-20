-- FileName: AudioHelper.lua
-- Author: menghao
-- Date: 2014-06-18
-- Purpose: 音乐音效


module("AudioHelper", package.seeall)


-- UI控件引用变量 --


-- 模块局部变量 --
local m_curMusic 
local m_isMusicOn
local m_isEffectOn


local tbState = {}

local _bStatOn = "true"
local _bStatOff = "false"

function destroy(...)
	package.loaded["AudioHelper"] = nil
end


function moduleName()
	return "AudioHelper"
end


-- 保存音乐状态（战斗中需要播放音乐）用于战斗结束还原音乐状态
function saveAudioState( ... )
	tbState.music = m_isMusicOn
	tbState.effect = m_isEffectOn
end
-- 战斗结束调用，还原音乐状态
function resetAudioState( ... )
	tbState.music = tbState.music or m_isMusicOn
	tbState.effect = tbState.effect or m_isEffectOn

	local isMusic = tbState.music == _bStatOn and true or false
	local isEffect = tbState.effect == _bStatOn and true or false
	
	setMusic(isMusic)
	setEffect(isEffect)
end

function getAudioState( ... )
	return m_isMusicOn, m_isEffectOn
end

function initAudioInfo()
	if (CCUserDefault:sharedUserDefault():getStringForKey("isAudioInit") == "") then
		CCUserDefault:sharedUserDefault():setStringForKey("isAudioInit", _bStatOn)
		CCUserDefault:sharedUserDefault():setStringForKey("m_isMusicOn", _bStatOn)
		CCUserDefault:sharedUserDefault():setStringForKey("m_isEffectOn", _bStatOn)
		CCUserDefault:sharedUserDefault():flush()

		m_isMusicOn = _bStatOn
		m_isEffectOn = _bStatOn
	else
		m_isMusicOn = CCUserDefault:sharedUserDefault():getStringForKey("m_isMusicOn")
		if (m_isMusicOn == _bStatOn) then
			SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0.8)
		else
			SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
		end

		m_isEffectOn = CCUserDefault:sharedUserDefault():getStringForKey("m_isEffectOn")
		if (m_isEffectOn == _bStatOn)then
			SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
		else
			SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
		end
	end
end


--播放背景音乐
function playMusic(strMusic, isLoop)
	if (m_isMusicOn == nil) then
		initAudioInfo()
	end

	if (m_isMusicOn ~= _bStatOn) then
		return
	end

	if (strMusic ~= m_curMusic or isLoop == false) then
		if (isLoop == nil) then
			isLoop = true
		end

		m_curMusic = strMusic
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(m_curMusic, isLoop)
	end
end



--停止背景音乐
function stopMusic()
	-- 已经执行SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true) 关闭音乐后。执行 pauseBackgroundMusic再执行
-- resumeBackgroundMusic，音乐能恢复 . 测得iOS有问题，安卓没有.修改为音乐关闭状态禁止执行 pause resume 操作
	if (m_isMusicOn==_bStatOff) then 
		return 
	end 
	SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
end


function resumeMusic( ... )
	if (m_isMusicOn==_bStatOff) then 
		return 
	end 
	SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
end


-- 停止指定effect
function stopEffect(effectID)
	if(effectID) then
		SimpleAudioEngine:sharedEngine():stopEffect(effectID)
	end
end


-- 停止所有音效
function stopAllEffects()
	SimpleAudioEngine:sharedEngine():stopAllEffects()
end


--播放音效
function playEffect(effect, isLoop)
	if (m_isEffectOn == nil) then
		initAudioInfo()
	end

	isLoop = isLoop or false
	if(m_isEffectOn)then
		return SimpleAudioEngine:sharedEngine():playEffect(effect,isLoop)
	end
	return nil
end


-- 设置音乐音量
function setMusicVolume( nVolume )
	if (m_isMusicOn==_bStatOn) then
		SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(nVolume)
	end
end


-- 设置音乐开关
function setMusic( bValue )
	if (isMusicOn() == bValue) then
		return
	end

	m_isMusicOn = bValue and _bStatOn or _bStatOff
	CCUserDefault:sharedUserDefault():setStringForKey("m_isMusicOn", m_isMusicOn)
	CCUserDefault:sharedUserDefault():flush()
	if (m_isMusicOn == _bStatOn) then
		SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0.8)
		m_curMusic = nil
		playMainMusic()
	else
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)  
	end
end


-- 设置音效开关
function setEffect( bValue )
	if (isEffectOn() == bValue) then
		return
	end

	m_isEffectOn = bValue and _bStatOn or _bStatOff
	CCUserDefault:sharedUserDefault():setStringForKey("m_isEffectOn", m_isEffectOn)
	CCUserDefault:sharedUserDefault():flush()
	if (m_isEffectOn == _bStatOn) then
		SimpleAudioEngine:sharedEngine():setEffectsVolume(1)
	else
		SimpleAudioEngine:sharedEngine():setEffectsVolume(0)
	end
end


function isMusicOn( ... )
	return m_isMusicOn == _bStatOn
end


function isEffectOn( ... )
	return m_isEffectOn == _bStatOn
end


-- 播放游戏主音乐
function playMainMusic()
	playMusic("audio/main.mp3")
end


-- 播放场景音乐，传入文件名
function playSceneMusic(fileName)
	playMusic("audio/bgm/" .. fileName)
end


-- 播放动画音效，传入文件名
function playSpecialEffect(fileName)
	playEffect("audio/effect/" .. fileName)
end


-- 播放按钮音效
function playBtnEffect(fileName)
	if (m_isEffectOn~=_bStatOn) then
		return
	end
	playEffect("audio/btn/" .. fileName)
end

-- 播放伙伴音效
function playHeroEffect( fileName )
	return playEffect("audio/heroeffect/" .. fileName)
end


-- 关闭按钮音效
function playCloseEffect( ... )
	playBtnEffect("guanbi.mp3")
end


-- 页签按钮音效
function playTabEffect( ... )
	playBtnEffect("yeqian.mp3")
end


-- 返回按钮音效
function playBackEffect( ... )
	playBtnEffect("fanhui.mp3")
end


-- 弹出信息面板按钮音效
function playInfoEffect( ... )
	playBtnEffect("jieshao.mp3")
end


-- 主界面活动ui的
function playMainUIEffect( ... )
	playBtnEffect("zhujiemian_mid.mp3")
end


-- 二级按钮音效
function playCommonEffect( ... )
	playBtnEffect("anniu.mp3")
end


-- 进入游戏音效
function playEnter( ... )
	playBtnEffect("jinruyouxi.mp3")
end


-- 进入副本音效
function playEnterCopy( ... )
	playBtnEffect("fuben.mp3")
end


-- 主界面底部菜单按钮音效
function playMainMenuBtn( ... )
	playBtnEffect("zhujiemian_bottom.mp3")
end

-- 背包展开按钮

function playDeployedEffect( ... )
	playBtnEffect("zhankai.mp3")
end

-- 背包收起按钮
function playRetractedEffect( ... )
	playBtnEffect("shouqi.mp3")
end

-- 装备点击
function playClickArmEffect( ... )
	playBtnEffect("zhuangbei_dianji.mp3")
end

-- 穿戴装备后
function playArmOn( ... )
	playBtnEffect("zhuangbei_on.mp3")
end

-- 脱下装备后
function playArmOff( ... )
	playBtnEffect("zhuangbei_off.mp3")
end

-- 购买物品
function playBuyGoods( ... )
	playBtnEffect("buttonbuy.mp3")
end

-- tansuo02音效
function playTansuo02( ... )
	playBtnEffect("tansuo02.mp3")
end

-- 合成 招募音效
function playCompound( ... )
	playBtnEffect("anniu_hecheng.mp3")
end

function clearCache( ... )
	m_curMusic = nil
end

-- 发送战报音效
function playSendReport( ... )
	playBtnEffect("jieshao.mp3")
end

-- 查看攻略音效
function playStrategy( ... )
	playSpecialEffect("renwu.mp3")
end

-- 装备炮弹
function playLoadBall( ... )
	playBtnEffect("zhuchuan_zhuangbei_on.mp3")
end

-- 卸载炮弹
function playReLoadBall( ... )
	playBtnEffect("zhuchuan_zhuangbei_off.mp3")
end


