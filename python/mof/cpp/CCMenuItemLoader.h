#ifndef MOF_CCMENUITEMLOADER_H
#define MOF_CCMENUITEMLOADER_H

class CCMenuItemLoader{
public:
	void onHandlePropTypeCheck(cocos2d::CCNode *, cocos2d::CCNode *, char const*, bool, cocos2d::extension::CCBReader *);
	void onHandlePropTypeCheck(cocos2d::CCNode *,cocos2d::CCNode	*,char const*,bool,cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlock(cocos2d::CCNode *,cocos2d::CCNode	*,char const*,cocos2d::extension::BlockData *,cocos2d::extension::CCBReader *);
}
#endif