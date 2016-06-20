module("BATTLE_CLASS_NAME")
class 								= "script/module/public/class"

CallHandle							= "script/battle/callbacker/CallHandle"
CallHandleArray						= "script/battle/callbacker/CallHandleArray"
BattelEvtCallBacker					= "script/battle/callbacker/BattelEvtCallBacker"
CallForverHandle					= "script/battle/callbacker/CallForverHandle"
BattleForEverCallBacker				= "script/battle/callbacker/BattleForEverCallBacker"
ClosureHandle						= "script/battle/callbacker/ClosureHandle"
ClosureHandleArray					= "script/battle/callbacker/ClosureHandleArray"
BaseEventDispatcher					= "script/battle/callbacker/BaseEventDispatcher"

BattleBaseObject					= "script/battle/BattleBaseObject"

BSNode								= "script/battle/BSTree/BSNode"
BSConditionNode						= "script/battle/BSTree/BSConditionNode"
BSOrLogicNode						= "script/battle/BSTree/BSOrLogicNode"
BSAndLogicNode						= "script/battle/BSTree/BSAndLogicNode"
BSActionNode						= "script/battle/BSTree/BSActionNode"
BSParallelOr						= "script/battle/BSTree/BSParallelOr"
BSDecoratorCompleteFalse 			= "script/battle/BSTree/BSDecoratorCompleteFalse"
BSInstantActionNode 				= "script/battle/BSTree/BSInstantActionNode"
BSCustomActionNode 					= "script/battle/BSTree/BSCustomActionNode"

AttackerLogic 						= "script/battle/BSTree/AttackerLogic"
BuffAddLogic 						= "script/battle/BSTree/BuffAddLogic"
BuffHurtLogic 						= "script/battle/BSTree/BuffHurtLogic"
BenchShowLogic 						= "script/battle/logicData/BenchShowLogic"
ShipAttackLogic 						= "script/battle/logicData/ship/ShipAttackLogic"
----------------------------- order
BSSequence 							= "script/battle/action/order/BSSequence"
BSSpawn 							= "script/battle/action/order/BSSpawn"
----------------------------- action
local actionPath = "script/battle/action/"
BaseAction												= actionPath.."BaseAction"
BaseActionForMoveTo										= actionPath.."BaseActionForMoveTo"
-- BattleActionForObjectPlayXMLAnimation					= actionPath.."BattleActionForObjectPlayXMLAnimation"

BattleActionForRunActionInSameTime						= actionPath.."BattleActionForRunActionInSameTime"
--BaseActionForKeyFramesTrigger							= actionPath.."BaseActionForKeyFramesTrigger"
BAForAttackAnimationTrigger								= actionPath.."BAForAttackAnimationTrigger"
BAForShowRageSkillFireEffect 							= actionPath.."BAForShowRageSkillFireEffect"
BAForPlayEffectAtHero 									= actionPath.."BAForPlayEffectAtHero"
BAForSpellRangeAttack 									= actionPath.."BAForSpellRangeAttack"
BAForSpellAttack 										= actionPath.."BAForSpellAttack"
BAForKeyFramesAnimationTrigger							= actionPath.."BAForKeyFramesAnimationTrigger"
BAForShowNumberAnimation 								= actionPath.."BAForShowNumberAnimation"
BAForPlayEffectAtPostion 								= actionPath.."BAForPlayEffectAtPostion"
BAForRemoteSpell 										= actionPath.."BAForRemoteSpell"

BAForRemoteSpellTrigger 								= actionPath.."BAForRemoteSpellTrigger"
BAForDelayAction										= actionPath.."BAForDelayAction"

BAForRunActionSequencely 								= actionPath.."BAForRunActionSequencely"

BAForFunction 											= actionPath.."BAForFunction"
BAForCallClosureFunction 								= actionPath.."BAForCallClosureFunction"
BAForRemoteSpellAttack 									= actionPath.."BAForRemoteSpellAttack"

BAForRunActionParallel 									= actionPath.."BAForRunActionParallel"

BAForRunActionQueueSequencely 							= actionPath.."BAForRunActionQueueSequencely"

BAForShowAddBuffEffect 									= actionPath.."BAForShowAddBuffEffect"
BAForNodeComplete 										= actionPath.."BAForNodeComplete"
BAForAddBuffIcon 										= actionPath.."BAForAddBuffIcon"

BAForPlayEffectAtHero 									= actionPath.."BAForPlayEffectAtHero"
BAForObjectPlayXMLAnimation 							= actionPath.."BAForObjectPlayXMLAnimation"

BAForHeroRageBarChange 									= actionPath.."BAForHeroRageBarChange"
BAForHeroHpBarChange 									= actionPath.."BAForHeroHpBarChange"
BAForRemoveBuffIcon 									= actionPath.."BAForRemoveBuffIcon"

BAForBSBuffAddAction 									= actionPath.."BAForBSBuffAddAction"
BAForBSBuffDamageAction 								= actionPath.."BAForBSBuffDamageAction"
BAForBSBuffDeleteAction 								= actionPath.."BAForBSBuffDeleteAction"
BAForBSBuffImAction 									= actionPath.."BAForBSBuffImAction"
BAForChangeTargetHpData									= actionPath.."BAForChangeTargetHpData"
BAForChangeTargetRageData								= actionPath.."BAForChangeTargetRageData"
BAForRunActionQueueWithWeight							= actionPath.."BAForRunActionQueueWithWeight"
BAForBSAction 											= actionPath.."BAForBSAction"
BAForBSSkillRageAction									= actionPath.."BAForBSSkillRageAction"
BAForRunAllBuffByTimeAction 							= actionPath.."BAForRunAllBuffByTimeAction"

BAForBSAttackAction 									= actionPath.."BAForBSAttackAction"
BAForBSHandleSkillAction								= actionPath.."BAForBSHandleSkillAction"
BAForBeAttackedCompleteAction 							= actionPath.."BAForBeAttackedCompleteAction"
BAForSubSkillsAction 									= actionPath.."BAForSubSkillsAction"
BAForBSBattleRoundLogicAction							= actionPath.."BAForBSBattleRoundLogicAction"

BAForRageChangeAnimationAction							= actionPath.."BAForRageChangeAnimationAction"
BAForReactionAnimationAction 							= actionPath.."BAForReactionAnimationAction"
BAForHeroCallDieFunction 								= actionPath.."BAForHeroCallDieFunction"
BAForAddEffectAtHero 									= actionPath.."BAForAddEffectAtHero"
BAForBSDieAction 										= actionPath.."BAForBSDieAction"


BAForHideTargetsAction									= actionPath.."BAForHideTargetsAction"
BAForBackGroundImgScrollAction 							= actionPath.."BAForBackGroundImgScrollAction"
BAForTargetsPlayMoveInTimeAction						= actionPath.."BAForTargetsPlayMoveInTimeAction"
BAForTargetsFadeInOrOutAction							= actionPath.."BAForTargetsFadeInOrOutAction"
BAForShowBattleNumberStateAction 						= actionPath.."BAForShowBattleNumberStateAction"
BAForMoveArmyFromFarAction 								= actionPath.."BAForMoveArmyFromFarAction"
BAForTargetsPlayEffectAction							= actionPath.."BAForTargetsPlayEffectAction"
BAForShakeScreen										= actionPath.."BAForShakeScreen"
BAForFlyAttack											= actionPath.."BAForFlyAttack"
BAForPlayerToRawPosition								= actionPath.."BAForPlayerToRawPosition"

--BAForRunActionParallel 									= actionPath.."BAForRunActionParallel"
BAForRunActionQueueParallel								= actionPath.."BAForRunActionQueueParallel"
BAForPlayAndMoveAnimation 								= actionPath.."BAForPlayAndMoveAnimation"
BAForPierceAttackFromBack								= actionPath.."BAForPierceAttackFromBack"
BAForPierceAttack 										= actionPath.."BAForPierceAttack"
TestAction												= actionPath.."TestAction"
BAForShowSkillNameAction								= actionPath.."BAForShowSkillNameAction"
BAForMoveBackAction 									= actionPath.."BAForMoveBackAction"
BAForSendNotification 									= actionPath.."BAForSendNotification"
BAForPushBuffInfoTo 									= actionPath.."BAForPushBuffInfoTo"
BAForPlayRageSkilBar 									= actionPath.."BAForPlayRageSkilBar"

BAForMoveTargetsTo 										= actionPath.."BAForMoveTargetsTo"

BAForSetZOrder 											= actionPath.."BAForSetZOrder"


BAForShowTotalHurtAnimation 							= actionPath .. "BAForShowTotalHurtAnimation"
BAForShakeScreen 										= actionPath .. "BAForShakeScreen"
BAForPlayAnimationByFrame 								= actionPath .. "BAForPlayAnimationByFrame"
BAForChangeTargetUnVisable 								= actionPath .. "BAForChangeTargetUnVisable"
BAForChangeTargetVisable 								= actionPath .. "BAForChangeTargetVisable"

BAForUpTargetsZOder 									= actionPath .. "BAForUpTargetsZOder"
BAForResumeTargetsZOder 								= actionPath .. "BAForResumeTargetsZOder"
BAForAddImageRageMask 									= actionPath .. "BAForAddImageRageMask"
BAForRemoveImageRageMask 									= actionPath .. "BAForRemoveImageRageMask"
BAForVisibleTargetsAction 								= actionPath .. "BAForVisibleTargetsAction"
BAForRepeatCall 										= actionPath .. "BAForRepeatCall"
BAForShowAddBuffTip 									= actionPath .. "BAForShowAddBuffTip"
BAForCamera 											= actionPath .. "BAForCamera"
BAForTargetFadeInWithIDs 								= actionPath .. "BAForTargetFadeInWithIDs"
BAForAddAnimationRageMask 								= actionPath .. "BAForAddAnimationRageMask"
BAForZoomScene 											= actionPath .. "BAForZoomScene"
BAForKickOutScreenAction 								= actionPath .. "BAForKickOutScreenAction"
BAForNearDeathSkillHandler 								= actionPath .. "BAForNearDeathSkillHandler"
BAForPreStartEvt 										= actionPath .. "BAForPreStartEvt"

BAforChestDropAndFlyAction 								= actionPath .. "chestShow/BAforChestDropAndFlyAction"

BAForSelfTeamMoveAndScrollImg 							= actionPath .. "BAForShow/BAForSelfTeamMoveAndScrollImg"
BAForArmyTeamMoveIn 									= actionPath .. "BAForShow/BAForArmyTeamMoveIn"
BAForSelfTeamMoveIn 									= actionPath .. "BAForShow/BAForSelfTeamMoveIn"
BAForHeroesEffectShow 									= actionPath .. "BAForShow/BAForHeroesEffectShow"
BAForLightingEffectShow 								= actionPath .. "BAForShow/BAForLightingEffectShow"
BAForMagicEffectShow 									= actionPath .. "BAForShow/BAForMagicEffectShow"
BAForPlayTalk 											= actionPath .. "BAForShow/BAForPlayTalk"
BAForScaleDownActionShow 								= actionPath .. "BAForShow/BAForScaleDownActionShow"
BAForHideTargets 										= actionPath .. "BAForShow/BAForHideTargets"
BAForMoveTargetsDown 									= actionPath .. "BAForShow/BAForMoveTargetsDown"
BAForMoveTargetsUp 										= actionPath .. "BAForShow/BAForMoveTargetsUp"

BAForShowTargetsWithDynamicEffect 						= actionPath .. "BAForShow/BAForShowTargetsWithDynamicEffect"
BAForChangeBackGround 									= actionPath .. "BAForShow/BAForChangeBackGround"
BAForChangeMusic 										= actionPath .. "BAForShow/BAForChangeMusic"
BAForPlayEffectAtScene 									= actionPath .. "BAForShow/BAForPlayEffectAtScene"
BAForSetTargetsVisible 									= actionPath .. "BAForShow/BAForSetTargetsVisible"

BAForMoveTeam1Out 										= actionPath .. "BAForShow/BAForMoveTeam1Out"
BAForMoveTeam2Out 										= actionPath .. "BAForShow/BAForMoveTeam2Out"
BAForHideTagetsWithDynamicEffect 						= actionPath .. "BAForShow/BAForHideTagetsWithDynamicEffect"
BAForAnimationFrameDelay 								= actionPath .. "BAForShow/BAForAnimationFrameDelay"
BAForShowTipInCenter 									= actionPath .. "BAForShow/BAForShowTipInCenter"
BAForShowTitleWithBlackBG 								= actionPath .. "BAForShow/BAForShowTitleWithBlackBG"
BAForShowBossInfo 										= actionPath .. "BAForShow/BAForShowBossInfo"

-- 切屏特效
BAForChangeSceneMoveInEffect 							= actionPath .. "BAForChangeScene/BAForChangeSceneMoveInEffect"

----  替补
BAForBenchDataActiveAction 								= actionPath .. "benchShow/BAForBenchDataActiveAction"
BAForBenchDisplayActiveAction 							= actionPath .. "benchShow/BAForBenchDisplayActiveAction"
BAForPlayEffectAtHeroByID 								= actionPath .. "BAForPlayEffectAtHeroByID"
BSForBenchShow 											= actionPath .. "BSActions/BSForBenchShow"
-- 随机声音
BAForPlayRandomSound 									= actionPath .. "randomSound/BAForPlayRandomSound"



--------------------------------- ship action

BAForShipRoatationGunForAimAction 					 	= actionPath .. "ship/BAForShipRoatationGunForAimAction"
BAForShowShipInfo 					 					= actionPath .. "ship/BAForShowShipInfo"
BAForShipEnterScene 					 				= actionPath .. "ship/BAForShipEnterScene"
BAForShipQuitScene 					 					= actionPath .. "ship/BAForShipQuitScene"
BAForShowEffectAtTargets 					 			= actionPath .. "ship/BAForShowEffectAtTargets"
BAForInitializeShipUIAction 					 		= actionPath .. "ship/BAForInitializeShipUIAction"
BAForShowShipSkillName 					 				= actionPath .. "ship/BAForShowShipSkillName"
BAForShipPlayFireAnimation 					 			= actionPath .. "ship/BAForShipPlayFireAnimation"
BAForPlayAnimationOfGun									= actionPath .. "ship/BAForPlayAnimationOfGun"
BAForPlayAnimationAtShipGunAction						= actionPath .. "ship/BAForPlayAnimationAtShipGunAction"

BAForBSShipAttackAction									= actionPath .. "ship/BAForBSShipAttackAction"
BAForBSHandleShipSkillAction							= actionPath .. "ship/BAForBSHandleShipSkillAction"
BAForBSShipSubSkillsAction								= actionPath .. "ship/BAForBSShipSubSkillsAction"
BAForShipRemoteSpellAttack								= actionPath .. "ship/BAForShipRemoteSpellAttack"
BAForAnimationTrigerAction								= actionPath .. "ship/BAForAnimationTrigerAction"
BAForShowShipInfo										= actionPath .. "ship/BAForShowShipInfo"
BAForShowTeamFightUpAnimation							= actionPath .. "ship/BAForShowTeamFightUpAnimation"

--------------------------------- blockboard
local bbPath 											= "script/battle/BSTree/blackBoard/"
BSBlackBoard											= bbPath .. "BSBlackBoard"
BSBuffDeleteBB 											= bbPath .. "BSBuffDeleteBB"
BSBuffAddBB												= bbPath .. "BSBuffAddBB"
BSBuffDamageBB											= bbPath .. "BSBuffDamageBB"
BSBufferBB 												= bbPath .. "BSBufferBB"
BSBuffImBB 												= bbPath .. "BSBuffImBB"
BSSkillSystemBBData 									= bbPath .. "BSSkillSystemBBData"
BSSkillRageDamageBB										= bbPath .. "BSSkillRageDamageBB"
BSSkillHpDamageBB										= bbPath .. "BSSkillHpDamageBB"
BSBattleRoundBB 										= bbPath .. "BSBattleRoundBB"
BSDieBB 												= bbPath .. "BSDieBB"
BSArmyShowBB											= bbPath .. "BSArmyShowBB"
BSBenchShowBB 											= bbPath .. "BSBenchShowBB"

BSShipAttackBBData 										= bbPath .. "ship/BSShipAttackBBData"
BSShipSkillRoundBBData 									= bbPath .. "ship/BSShipSkillRoundBBData"
BSShipSkillHandleBBData 								= bbPath .. "ship/BSShipSkillHandleBBData"
--------------------------------- logic data




---------------------------------ui
Battle4XRageBackImages 									= "script/battle/ui/Battle4XRageBackImages"
BattleHeroHPBarUI 										= "script/battle/ui/BattleHeroHPBarUI"
BattleHeroRageBar 										= "script/battle/ui/BattleHeroRageBar"
CCSpriteBatchNumber 									= "script/battle/ui/CCSpriteBatchNumber"
BattleFormationUI 										= "script/battle/ui/BattleFormationUI"
LabelButton												= "script/battle/ui/LabelButton"
BattleInfoUI 											= "script/battle/ui/BattleInfoUI"
BattleAnimation 										= "script/battle/ui/BattleAnimation"
BattleBenchInfoComponent 								= "script/battle/ui/BattleBenchInfoComponent"
BattleBenchInfoIcon 									= "script/battle/ui/BattleBenchInfoIcon"
BattleBellyEventInfoLabel 								= "script/battle/ui/BattleBellyEventInfoLabel"
BaseBoundingBox 										= "script/battle/geo/BaseBoundingBox"
QuadTreeNode 											= "script/battle/geo/QuadTreeNode"


-------------------------------- property selector
local psPath 											= "script/battle/BSTree/propertySelector/"
PSAttackerUIToHeroUI 									= psPath .. "PSAttackerUIToHeroUI"
PSDamageEffectNameToAnimationName						= psPath .. "PSDamageEffectNameToAnimationName"
PSDamageActionNameToAnimationName 						= psPath .. "PSDamageActionNameToAnimationName"
PSHpDamageToValue 										= psPath .. "PSHpDamageToValue"
PSHpNumberColorToColor 									= psPath .. "PSHpNumberColorToColor"
PSBuffChangeEffectToAnimationName 						= psPath .. "PSBuffChangeEffectToAnimationName"
PSRageDamgeToValue 										= psPath .. "PSRageDamgeToValue"
PSForSetter 											= psPath .. "PSForSetter"
PSBuffDamageTitleToTitle 								= psPath .. "PSBuffDamageTitleToTitle"



-------------------------------  data
local recordDataPath = "script/battle/data/battleRecordData/"
BattleBuffsInfo											= recordDataPath .. "BattleBuffsInfo"
BattlePlayerRoundData 									= recordDataPath .. "BattlePlayerRoundData"
BattleUnderAttackerData 								= recordDataPath .. "BattleUnderAttackerData"
BattleRecordSourcAnalyser 								= recordDataPath .. "BattleRecordSourcAnalyser"
BattleBenchListData 									= recordDataPath .. "BattleBenchListData"

local battleDataPath = "script/battle/data/"
-- local recordDataPath = battleDataPath.."battleRecordData/"
BattleObjectBuffData 									= battleDataPath .. "BattleObjectBuffData"
BattleDataADT 											= recordDataPath .. "BattleDataADT"
BattleFightRecordData 									= recordDataPath .. "BattleFightRecordData"
BattleEnvironment 										= recordDataPath .. "BattleEnvironment"
BattleChestData 										= battleDataPath .. "chest/BattleChestData"



BattleTeamInfo 											= recordDataPath .. "BattleTeamInfo"
BattleResultData 										= recordDataPath .. "BattleResultData"
BattleObjectData 										= battleDataPath .. "BattleObjectData"
BattleBuffDamage 										= recordDataPath .. "BattleBuffDamage"
BattleDamageGenerater 									= recordDataPath .. "BattleDamageGenerater"
BattleDamageGeneraterWithTime 							= recordDataPath .. "BattleDamageGeneraterWithTime"


LinkNodeQueue 											= battleDataPath .. "LinkNodeQueue"

----------------------------  ship 

BattleShipDisplay  										= "script/battle/ui/ship/BattleShipDisplay"
BattleShipGunDisplay  									= "script/battle/ui/ship/BattleShipGunDisplay"
BattleShipBodyDisplay  									= "script/battle/ui/ship/BattleShipBodyDisplay" 					

BattleShipData  										= recordDataPath .. "ship/BattleShipData"
BattleShipGunData  										= recordDataPath .. "ship/BattleShipGunData"
BattleShipPropertyData  										= recordDataPath .. "ship/BattleShipPropertyData"

----------------------------  state machine
StateMachine 											= "script/battle/statemachine/StateMachine"







