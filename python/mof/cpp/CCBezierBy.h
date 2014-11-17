#ifndef MOF_CCBEZIERBY_H
#define MOF_CCBEZIERBY_H

class CCBezierBy{
public:
	void create(float,cocos2d::_ccBezierConfig const&);
	void initWithDuration(float,cocos2d::_ccBezierConfig const&);
	void initWithDuration(float, cocos2d::_ccBezierConfig	const&);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void ~CCBezierBy();
	void reverse(void);
}
#endif