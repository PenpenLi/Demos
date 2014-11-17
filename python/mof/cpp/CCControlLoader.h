#ifndef MOF_CCCONTROLLOADER_H
#define MOF_CCCONTROLLOADER_H

class CCControlLoader{
public:
	void onHandlePropTypeBlockCCControl(cocos2d::CCNode *,cocos2d::CCNode	*,char const*,cocos2d::extension::BlockCCControlData *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeCheck(cocos2d::CCNode *,cocos2d::CCNode *,char const*,bool,cocos2d::extension::CCBReader	*);
	void onHandlePropTypeBlockCCControl(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::extension::BlockCCControlData	*, cocos2d::extension::CCBReader *);
}
#endif