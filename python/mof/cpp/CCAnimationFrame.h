#ifndef MOF_CCANIMATIONFRAME_H
#define MOF_CCANIMATIONFRAME_H

class CCAnimationFrame{
public:
	void getDelayUnits(void)const;
	void initWithSpriteFrame(cocos2d::CCSpriteFrame	*, float, cocos2d::CCDictionary	*);
	void getSpriteFrame(void)const;
	void getUserInfo(void)const;
	void getUserInfo(void);
	void CCAnimationFrame(void);
	void setSpriteFrame(cocos2d::CCSpriteFrame *);
	void ~CCAnimationFrame();
	void initWithSpriteFrame(cocos2d::CCSpriteFrame	*,float,cocos2d::CCDictionary *);
	void getSpriteFrame(void);
	void copyWithZone(cocos2d::CCZone *);
	void setDelayUnits(float);
	void getDelayUnits(void);
	void setUserInfo(cocos2d::CCDictionary *);
}
#endif