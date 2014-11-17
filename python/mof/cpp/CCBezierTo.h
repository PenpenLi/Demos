#ifndef MOF_CCBEZIERTO_H
#define MOF_CCBEZIERTO_H

class CCBezierTo{
public:
	void create(float,cocos2d::_ccBezierConfig const&);
	void ~CCBezierTo();
	void initWithDuration(float,cocos2d::_ccBezierConfig const&);
	void initWithDuration(float, cocos2d::_ccBezierConfig	const&);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
}
#endif