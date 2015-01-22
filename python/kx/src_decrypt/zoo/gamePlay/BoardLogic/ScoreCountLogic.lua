
ScoreCountLogic = class{}

function ScoreCountLogic:addCombo(mainLogic, count)
 	mainLogic.comboCount = mainLogic.comboCount + count;
 	
 	local ts = mainLogic.comboCount;
 	if ts >8 then ts = 8 end;
 	local str = string.format(GameMusicType.kEliminate, ts)
 	GamePlayMusicPlayer:playEffect(str);
end

-- 在连消结束时显示评价图片和播放声音
function ScoreCountLogic:endCombo(mainLogic)
	if mainLogic.theGamePlayStatus ~= GamePlayStatus.kNormal and mainLogic.theGamePlayStatus ~= GamePlayStatus.kNormalAfterFailed then return end
	local sound
	local image
 	if mainLogic.comboCount >= 11 then
 		image = 5
 		sound = string.format(GameMusicType.kContinueMatch, 11)
 	elseif mainLogic.comboCount >= 9 then
 		image = 4
 		sound = string.format(GameMusicType.kContinueMatch, 9)
 	elseif mainLogic.comboCount >= 7 then
 		image = 3
 		sound = string.format(GameMusicType.kContinueMatch, 7)
 	elseif mainLogic.comboCount >= 5 then
 		image = 2
 		sound = string.format(GameMusicType.kContinueMatch, 5) 
 	elseif mainLogic.comboCount >= 3 then
 		image = 1
 		sound = string.format(GameMusicType.kContinueMatch, 3)
 	end 
 	if sound then GamePlayMusicPlayer:playEffect(sound); end
 	if image and mainLogic.PlayUIDelegate and mainLogic.PlayUIDelegate.effectLayer then
 		mainLogic.PlayUIDelegate.effectLayer:addChild(CommonEffect:buildSpecialEffectTitle(image))
 	end
 	mainLogic.comboCount = 0;
end

function ScoreCountLogic:getComboWithCount(mainLogic, count)
	return mainLogic.comboCount + count;
end

function ScoreCountLogic:addScoreToTotal(mainLogic, score)
	for i = 1,3 do 			----播放声音
		if mainLogic.totalScore < mainLogic.scoreTargets[i] and mainLogic.totalScore + score > mainLogic.scoreTargets[i] then
			GamePlayMusicPlayer:playEffect(GameMusicType.kNewStarLevel);
		end
	end
	mainLogic.totalScore = mainLogic.totalScore + score;
end


function ScoreCountLogic:getScoreWithItemBomb(item)
	if item.ItemType == GameItemType.kAnimal then
		if item.ItemSpecialType == AnimalTypeConfig.kLine then
			return GamePlayConfig_Score_SpecialBomb_kLine;
		elseif item.ItemSpecialType == AnimalTypeConfig.kColumn then
			return GamePlayConfig_Score_SpecialBomb_kCloumn;
		elseif item.ItemSpecialType == AnimalTypeConfig.kWrap then
			return GamePlayConfig_Score_SpecialBomb_kWrap;
		elseif item.ItemSpecialType == AnimalTypeConfig.kColor then
			return GamePlayConfig_Score_SpecialBomb_kBird;
		end
	end
	return 0;
end

----合成特效加分
function ScoreCountLogic:getScoreWithSpecialTypeCombine(spType)
	if spType == AnimalTypeConfig.kLine then
		return GamePlayConfig_Score_SpecialCombine_kLine;
	elseif spType == AnimalTypeConfig.kColumn then
		return GamePlayConfig_Score_SpecialCombine_kCloumn;
	elseif spType == AnimalTypeConfig.kWrap then
		return GamePlayConfig_Score_SpecialCombine_kWrap;
	elseif spType == AnimalTypeConfig.kColor then
		return GamePlayConfig_Score_SpecialCombine_kBird;
	end
	return 0;
end

function ScoreCountLogic:getItemDestroyBaseScore(itemType)
	local scoreBase = 0
	if itemType == GameItemType.kAnimal then
		scoreBase = GamePlayConfig_Score_MatchDeleted_Base
	elseif itemType == GameItemType.kCrystal then 
		scoreBase = 100
	elseif itemType == GameItemType.kCoin then
		scoreBase = 100
	elseif itemType == GameItemType.kBalloon then 
		scoreBase = GamePlayConfig_Score_Balloon
	elseif itemType == GameItemType.kRabbit then
		scoreBase = GamePlayConfig_Score_Rabbit
	end
	
	return scoreBase
end