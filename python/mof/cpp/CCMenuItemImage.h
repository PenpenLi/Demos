#ifndef MOF_CCMENUITEMIMAGE_H
#define MOF_CCMENUITEMIMAGE_H

class CCMenuItemImage{
public:
	void setDisabledSpriteFrame(cocos2d::CCSpriteFrame *);
	void create(cocos2d::CCObject *));
	void setSelectedSpriteFrame(cocos2d::CCSpriteFrame *);
	void initWithNormalImage(cocos2d::CCObject *));
	void ~CCMenuItemImage();
	void create(void);
	void setNormalSpriteFrame(cocos2d::CCSpriteFrame	*);
	void create(cocos2d::CCObject	*));
	void createBySpriteFrame(cocos2d::CCObject *));
}
#endif