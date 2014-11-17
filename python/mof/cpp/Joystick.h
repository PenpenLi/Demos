#ifndef MOF_JOYSTICK_H
#define MOF_JOYSTICK_H

class Joystick{
public:
	void draw(void);
	void Inactive(void);
	void endCheckHoldEvent(void);
	void holdBegan(void);
	void checkArea(cocos2d::CCPoint);
	void initWithCenter(cocos2d::CCPoint,float,cocos2d::CCSprite *,cocos2d::CCSprite	*);
	void holdEnd(void);
	void ~Joystick();
	void checkTouchesMovedEvent(cocos2d::CCTime);
	void ccTouchesEnded(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void initWithCenter(cocos2d::CCPoint, float, cocos2d::CCSprite *, cocos2d::CCSprite *);
	void ccTouchesEnded(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet *, cocos2d::CCEvent *);
	void waitForHoldEvent(float);
	void ccTouchesBegan(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesBegan(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesEnded(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void createJoystick(void);
	void registerWithTouchDispatcher(void);
	void ccTouchesMoved(cocos2d::CCSet	*, cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet *, cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet *,cocos2d::CCEvent *);
	void ccTouchesMoved(cocos2d::CCSet	*,cocos2d::CCEvent *);
	void Active(void);
	void create(void);
	void Joystick(void);
	void checkTouchEndSchedule(float);
	void updatePos(cocos2d::CCTime);
	void isTouching(void);
	void init(void);
	void isMoveToBoundary(cocos2d::CCPoint);
}
#endif