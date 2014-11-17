#ifndef MOF_CCTRANSITIONFADE_H
#define MOF_CCTRANSITIONFADE_H

class CCTransitionFade{
public:
	void create(float,cocos2d::CCScene *,cocos2d::_ccColor3B const&);
	void create(float, cocos2d::CCScene *);
	void create(float,cocos2d::CCScene *);
	void initWithDuration(float,cocos2d::CCScene *);
	void initWithDuration(float, cocos2d::CCScene *, cocos2d::_ccColor3B const&);
	void create(float, cocos2d::CCScene *, cocos2d::_ccColor3B const&);
	void ~CCTransitionFade();
	void initWithDuration(float, cocos2d::CCScene *);
	void onEnter(void);
	void initWithDuration(float,cocos2d::CCScene *,cocos2d::_ccColor3B const&);
	void onExit(void);
}
#endif