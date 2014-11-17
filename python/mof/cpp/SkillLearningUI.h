#ifndef MOF_SKILLLEARNINGUI_H
#define MOF_SKILLLEARNINGUI_H

class SkillLearningUI{
public:
	void checkPassiveSkillIsOpen(int *);
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setFrame3Value(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void setSelectEffectPos(int);
	void setGuildSkillDesc(int);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setSkillDesc(int);
	void initControl(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setUpdataSkillsStata(bool);
	void getEquipSkillPos(void);
	void recv(int, void	*);
	void sendUpDataMessage(int);
	void create(void);
	void setUpdataImageState(bool);
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void initDescriptionFrame1(void);
	void recv(int, int,	cocos2d::CCPoint, int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void refreshSkillsShowState(void);
	void recv(int, void *);
	void initDescriptionFrame2(void);
	void getPassiveSkillList(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int, int, cocos2d::CCPoint, int);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void recv(int,int,char const*);
	void initDescriptionFrame3(void);
	void onSkillupgradeImageClicked(cocos2d::CCObject	*);
	void recv(int,int,cocos2d::CCPoint,int);
	void showGuildDescType2(int);
	void ~SkillLearningUI();
	void setTipContent(int, int, bool, bool);
	void showEquipSkillByServer(int);
	void ShowSkillList(SkillList);
	void getInitiativeSkillList(void);
	void recv(int, int, char const*);
	void recv(int,void *);
	void onMenuItemGoToGuildSkillLearnClicked(cocos2d::CCObject *);
	void detectionFunctionOpen(void);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void setFrequentlyData(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onTakeOnEquipSkillImageClicked(cocos2d::CCObject *);
	void onEnter(void);
	void setTipContent(int,int,bool,bool);
	void SkillLearningUI(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void showGuildDescType1(int);
	void setFramenoShow(void);
	void initSkillsScrollView(SkillList);
	void onEquipSkillDescClicked(cocos2d::CCObject *);
	void recv(int, int,	char const*);
	void setEquipSkillsShow(void);
	void setGotoGuildSkillEnable(bool);
	void setEquipImageIsShow(int);
	void onMenuItemGuildSkillClicked(cocos2d::CCObject *);
	void setFrame1Value(int);
	void onSkillupgradeImageClicked(cocos2d::CCObject *);
	void onMenuItemActiveSkillClicked(cocos2d::CCObject *);
	void onMenuItemPassiveSkillClicked(cocos2d::CCObject *);
	void setFrame2Value(int);
	void onMenuItemGuildSkillClicked(cocos2d::CCObject	*);
	void init(void);
	void onExit(void);
}
#endif