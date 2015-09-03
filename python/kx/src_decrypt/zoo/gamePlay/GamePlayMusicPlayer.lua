
GamePlayMusicPlayer = class{}

GameMusicType = table.const
{
	kNewStarLevel = "",											-- 分数达到一颗新的星星
	kContinueMatch = "music/sound.contnuousMatch.%d.mp3",		-- 连击
	kDeadlineStep = "music/sound.DeadlineStep.mp3",				-- 仅剩5步时
	kSlide = "music/sound.Drop.mp3",							-- 斜向滑落
	kDrop = "music/sound.Drop.mp3",								-- 落到底部
	kCreateColor = "music/sound.create.color.mp3",				-- 生成魔力鸟
	kCreateLine = "music/sound.create.strip.mp3",				-- 生成直线特效
	kCreateWrap = "music/sound.create.wrap.mp3",				-- 生成区域特效
	kEliminateColor = "music/sound.eliminate.color.mp3",		-- 消除魔力鸟
	kEliminateLine = "music/sound.eliminate.strip.mp3",			-- 消除直线特效
	kEliminateWrap = "music/sound.eliminate.wrap.mp3",			-- 消除区域特效
	kEliminate = "music/sound.Eliminate%d.mp3",					-- 消除Animal
	kEliminateTip = "music/sound.EliminateTip.mp3",				-- 长时间不动的消除提示
	kSnowBreak = "music/sound.frosint.break.mp3",				-- 雪破裂
	kIceBreak = "music/sound.ice.break.mp3",					-- 冰破裂
	kKeyboard = "music/sound.Keyboard.mp3",						-- 动物被选中
	kPopupClose = "music/sound.PopupClose.mp3",					-- 关闭面板
	kPopupOpen = "music/sound.PopupOpen.mp3",					-- 打开面板
	kBtnClick = "sound.clipStar.mp3",							-- 点击开始等硬质按钮
	kBubbleBreak = "sound.clipStar.mp3",						-- 道具泡泡破裂的声音
	kStarOnPanel = "music/sound.star.light.mp3",					-- 星星落在面板上
	kGetNewStar = "sound.clipStar.mp3",							-- 本关获得的这颗星星是新的
	kSwap = "music/sound.Swap.mp3",								-- 交换
	kSwapFun = "music/sound.SwapFun.mp3",						-- 搞笑交换（被绳子挡住）
	kPropWrong = "sound.clipStar.mp3",							-- 道具使用错误（使用位置错误）
	kLineBrush = "sound.clipStar.mp3",							-- 道具直线特效刷子（魔棒）
	kBonusTime = "music/sound.bonus.time.mp3",					-- BonusTime字样
	kBonusTimeSteps = "sound.clipStar.mp3",						-- BonusTime光飞到面板上
	kWorldSceneBGM = "music/sound.WorldSceneBGM.mp3",			-- 世界地图背景音乐
	kGameSceneBGM = "music/sound.GameSceneBGM.mp3",				-- 关卡背景音乐
	kSwapColorColorSwap = "music/sound.swap.colorcolor.swap.mp3",
	kSwapColorColorCleanAll = "music/sound.swap.colorcolor.cleanAll.mp3",
	kSwapColorLine = "music/sound.swap.colorline.mp3",
	kSwapLineLine = "music/sound.swap.lineline.mp3",
	kSwapWrapLine = "music/sound.swap.wrapline.mp3",
	kSwapWrapWrap = "music/sound.swap.wrapwrap.mp3",
	kRoostUpgrade = "music/sound.roost%d.mp3",
	kBalloonBreak = "music/sound.balloon.break.mp3",
	kBalloonRunaway = "music/sound.balloon.runaway.mp3",
	kTileBlockerTurn = "music/sound.tileBlocker.turn.mp3",
	kMonsterJumpOut = "music/sound.monster.jumpout.mp3",
	kGetRewardProp = "music/sound.reward.prop.mp3",
	kUseEnergy = "music/sound.use.energy.mp3",
	kGetRewardCoin = "music/sound.reward.coin.mp3",
	kClickBubble = "music/sound.click.bubble.mp3",
	kClickCommonButton = "music/sound.click.common.button.mp3",
	kBonusStepToLine = "music/sound.step.to.line.mp3",
	kAddEnergy = "music/sound.add.energy.mp3",
	kPanelVerticalPopout = "music/sound.panel.vertical.popout.mp3",
	kCoinTick = "music/sound.coin.tick.mp3",
	kFirework = "music/sound.fireworks.mp3",
	kBlessing = "music/sound.blessing.mp3",
	kElephantBoss = "music/sound.elephant.boss.effect.mp3",
}

local instance = nil

function GamePlayMusicPlayer:ctor()
	self.IsMusicOpen = not CCUserDefault:sharedUserDefault():getBoolForKey("game.disable.sound.effect")
	self.IsBackgroundMusicOPen = not CCUserDefault:sharedUserDefault():getBoolForKey("game.disable.background.music")
	self.normalBgMusicVolume = SimpleAudioEngine:sharedEngine():getBackgroundMusicVolume()
	self.curBgMusicFile = false
	self.bgMusicDelay = -1
	self.iosVideoPlay = false
end

function GamePlayMusicPlayer:enterBackground()
	if self.IsBackgroundMusicOPen then
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
		self:disposeBgMusicDelay()
		--SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
	end

	if self.IsMusicOpen then
		SimpleAudioEngine:sharedEngine():pauseAllEffects()
	end

	self:disposeBgMusicDelay()
end

function GamePlayMusicPlayer:enterForeground()
	if self.IsBackgroundMusicOPen then
		if self.curBgMusicFile then
			SimpleAudioEngine:sharedEngine():playBackgroundMusic(self.curBgMusicFile, true)
		end
	end

	if self.IsMusicOpen then
		SimpleAudioEngine:sharedEngine():resumeAllEffects()
	end

	if self.iosVideoPlay then 
		self:oncePauseBackgroundMusic() 
	end 
end

function GamePlayMusicPlayer:appPause()
	if self.IsBackgroundMusicOPen then
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
	end

	if self.IsMusicOpen then
		SimpleAudioEngine:sharedEngine():pauseAllEffects()
	end
end

function GamePlayMusicPlayer:appResume()
	if self.IsBackgroundMusicOPen then
		if self.curBgMusicFile then
			local function cb()
				if not SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying() then
					SimpleAudioEngine:sharedEngine():playBackgroundMusic(self.curBgMusicFile, true)
				end
				self:disposeBgMusicDelay()
			end
			if self.iosVideoPlay then 
				self:disposeBgMusicDelay()
			else
				self.bgMusicDelay = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(cb, 1, false)
			end
		end
	end

	if self.IsMusicOpen then
		SimpleAudioEngine:sharedEngine():resumeAllEffects()
	end
end

function GamePlayMusicPlayer:disposeBgMusicDelay()
	if self.bgMusicDelay >= 0 then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(self.bgMusicDelay) 
		self.bgMusicDelay = -1
	end
end

function GamePlayMusicPlayer:pauseBackgroundMusic(...)
	assert(#{...} == 0)

	self.IsBackgroundMusicOPen	= false
	--SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0)
	SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
	local config = CCUserDefault:sharedUserDefault()
	config:setBoolForKey("game.disable.background.music", true)
	config:flush()

	self:disposeBgMusicDelay()
end

function GamePlayMusicPlayer:resumeBackgroundMusic(...)
	assert(#{...} == 0)
	self.IsBackgroundMusicOPen	= true
	if self.curBgMusicFile then
		--SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(self.normalBgMusicVolume)
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(self.curBgMusicFile, true)
	end
	local config = CCUserDefault:sharedUserDefault()
	config:setBoolForKey("game.disable.background.music", false)
	config:flush()
end

function GamePlayMusicPlayer:oncePauseBackgroundMusic( ... )
	if __IOS then 
		self.iosVideoPlay = true
	end
	-- body
	if self.IsBackgroundMusicOPen then 
		SimpleAudioEngine:sharedEngine():pauseBackgroundMusic(true)
	end
end

function GamePlayMusicPlayer:onceResumeBackgroundMusic( ... )
	if __IOS then 
		self.iosVideoPlay = false
	end
	-- body
	if self.IsBackgroundMusicOPen then
		SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
	end

end

function GamePlayMusicPlayer:pauseSoundEffects(...)
	assert(#{...} == 0)
	self.IsMusicOpen = false
	local config = CCUserDefault:sharedUserDefault()
	config:setBoolForKey("game.disable.sound.effect", true)
	config:flush()
end

function GamePlayMusicPlayer:resumeSoundEffects(...)
	assert(#{...} == 0)
	self.IsMusicOpen = true
	local config = CCUserDefault:sharedUserDefault()
	config:setBoolForKey("game.disable.sound.effect", false)
	config:flush()
end

function GamePlayMusicPlayer:getInstance()
	if instance == nil then
		instance = GamePlayMusicPlayer.new();
	end
	return instance;
end

function GamePlayMusicPlayer:playWorldSceneBgMusic(Volume, ...)
	assert(#{...} == 0)

	if self.curBgMusicFile ~= GameMusicType.kWorldSceneBGM then
		self.curBgMusicFile = GameMusicType.kWorldSceneBGM

		if self.IsBackgroundMusicOPen then
			-- Stop Previous Background Music
			SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
			SimpleAudioEngine:sharedEngine():playBackgroundMusic(GameMusicType.kWorldSceneBGM, true)
		else
			-- Do Nothing
		end
	end
end

function GamePlayMusicPlayer:playGameSceneBgMusic(...)
	assert(#{...} == 0)

	self.curBgMusicFile = GameMusicType.kGameSceneBGM

	if self.IsBackgroundMusicOPen then
		-- Stop Previous Background Music
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic(true)
		SimpleAudioEngine:sharedEngine():playBackgroundMusic(GameMusicType.kGameSceneBGM, true)
	else
		-- Do Nothing
	end
end

function GamePlayMusicPlayer:playEffect(filename, vol)
	if filename == "" then 
		return
	end

	local context = self
	local function setEffectLifeDead()
		context.effectLifeCycle[filename] = false
	end

	if GamePlayMusicPlayer:getInstance().IsMusicOpen then
		if self.effectLifeCycle == nil then
			self.effectLifeCycle = {}
		end
		
		if self.effectLifeCycle[filename] then
			return
		else
			self.effectLifeCycle[filename] = true
			-- setTimeOut(setEffectLifeDead, GameMusicDuration[filename])
			setTimeOut(setEffectLifeDead, 0.1)
			SimpleAudioEngine:sharedEngine():playEffect(filename)
		end
	end
end
