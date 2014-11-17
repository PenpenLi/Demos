#ifndef MOF_CCLAYERLOADER_H
#define MOF_CCLAYERLOADER_H

class CCLayerLoader{
public:
	void onHandlePropTypeCheck(cocos2d::CCNode *,cocos2d::CCNode *,char const*,bool,cocos2d::extension::CCBReader *);
	void ~CCLayerLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
}
#endif