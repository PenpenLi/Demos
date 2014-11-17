#ifndef MOF_ATTACKBUTTON_H
#define MOF_ATTACKBUTTON_H

class AttackButton{
public:
	void holdEnd(void);
	void ccTouchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void registerWithTouchDispatcher(void);
	void holdBegan(void);
	void ccTouchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ~AttackButton();
	void create(void);
	void isTouchInside(cocos2d::CCTouch *);
	void init(void);
}
#endif