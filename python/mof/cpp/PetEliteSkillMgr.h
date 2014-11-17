#ifndef MOF_PETELITESKILLMGR_H
#define MOF_PETELITESKILLMGR_H

class PetEliteSkillMgr{
public:
	void playSkillCoolingEffect(int);
	void addPetSkill(cocos2d::CCNode	*,SkillCfgDef *,cocos2d::CCPoint);
	void getPetID(void)const;
	void ccTouchesMoved(cocos2d::CCSet *,cocos2d::CCEvent *);
	void isTouchInside(cocos2d::CCTouch *);
	void skillIsCoolding(int);
	void ~PetEliteSkillMgr();
	void ccTouchesEnded(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void setPetID(int);
	void createPetInfor(void);
	void ccTouchesBegan(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void ccTouchesMoved(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet *, cocos2d::CCEvent *);
	void freshPetHP(void);
	void onEnter(void);
	void addPetSkill(cocos2d::CCNode	*, SkillCfgDef *, cocos2d::CCPoint);
	void ccTouchesMoved(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void create(void);
	void init(void);
	void getPetID(void);
	void releaseTouchSkill(int);
}
#endif