#ifndef MOF_CCANIMATION_H
#define MOF_CCANIMATION_H

class CCAnimation{
public:
	void setDelayPerUnit(float);
	void getDuration(void);
	void setLoops(uint);
	void getDelayPerUnit(void);
	void CCAnimation(void);
	void setFrames(cocos2d::CCArray *);
	void getTotalDelayUnits(void);
	void getTotalDelayUnits(void)const;
	void getRestoreOriginalFrame(void);
	void copyWithZone(cocos2d::CCZone *);
	void initWithAnimationFrames(cocos2d::CCArray *, float, unsigned int);
	void setRestoreOriginalFrame(bool);
	void create(cocos2d::CCArray	*, float, unsigned int);
	void getRestoreOriginalFrame(void)const;
	void getFrames(void)const;
	void setLoops(unsigned int);
	void getFrames(void);
	void getLoops(void)const;
	void getDelayPerUnit(void)const;
	void initWithAnimationFrames(cocos2d::CCArray *,float,uint);
	void getLoops(void);
	void ~CCAnimation();
	void create(cocos2d::CCArray	*,float,uint);
}
#endif