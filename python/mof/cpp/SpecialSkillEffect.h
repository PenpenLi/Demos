#ifndef MOF_SPECIALSKILLEFFECT_H
#define MOF_SPECIALSKILLEFFECT_H

class SpecialSkillEffect{
public:
	void effectCallBack1(void);
	void ~SpecialSkillEffect();
	void startEffect(cocos2d::CCNode *,cocos2d::CCPoint);
	void effectCallBack2(void);
	void create(void);
	void SpecialSkillEffect(void);
	void init(void);
}
#endif