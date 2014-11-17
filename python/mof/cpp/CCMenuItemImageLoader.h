#ifndef MOF_CCMENUITEMIMAGELOADER_H
#define MOF_CCMENUITEMIMAGELOADER_H

class CCMenuItemImageLoader{
public:
	void ~CCMenuItemImageLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSpriteFrame	*,cocos2d::extension::CCBReader	*);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif