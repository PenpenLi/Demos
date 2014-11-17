#ifndef MOF_CCBKEYFRAME_H
#define MOF_CCBKEYFRAME_H

class CCBKeyframe{
public:
	void setEasingType(int);
	void CCBKeyframe(void);
	void getEasingOpt(void);
	void setValue(cocos2d::CCObject *);
	void setTime(float);
	void getTime(void);
	void getValue(void);
	void setEasingOpt(float);
	void getEasingType(void);
	void ~CCBKeyframe();
}
#endif