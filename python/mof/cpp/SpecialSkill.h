#ifndef MOF_SPECIALSKILL_H
#define MOF_SPECIALSKILL_H

class SpecialSkill{
public:
	void setBG(cocos2d::CCSprite	*,int);
	void ccTouchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void isTouchInside(cocos2d::CCTouch *);
	void playSkillCoolingEffect(int);
	void getCDBtton(int);
	void getButtonSate(int);
	void resetAllSkillButton(void);
	void restoreSkillButton(void);
	void create(void);
	void addSkill(int, int);
	void ccTouchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void AutoTouchSkill(int);
	void cancelSkillCooling(int);
	void ccTouchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void SpecialSkill(void);
	void addSkill(int,int);
	void setBG(cocos2d::CCSprite	*, int);
	void ~SpecialSkill();
	void init(void);
	void skillIsCoolding(int);
}
#endif