#ifndef MOF_GUILDSKILL_H
#define MOF_GUILDSKILL_H

class GuildSkill{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setupgradeImageStata(int);
	void setSkillIconStata(int);
	void showBatPoint(void);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchCancelled(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void create(void);
	void ~GuildSkill();
	void init(void);
	void ccTouchCancelled(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setType2Value(int);
	void initDescType1(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,	char const*);
	void setType3Value(int);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void onSkillupgradeImageClicked(cocos2d::CCObject *);
	void onEnter(void);
	void getSkillIdByTemplate(int);
	void initDescType3(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void Init(void);
	void showDonation(void);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent	*);
	void setType1Value(int);
	void showSkillDescAndImageStata(int);
	void initDescType2(void);
	void initGuildSkillsScrollView(void);
	void onMenuItemDevoteClick(cocos2d::CCObject *);
	void GuildSkill(void);
	void onExit(void);
}
#endif