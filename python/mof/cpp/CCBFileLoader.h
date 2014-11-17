#ifndef MOF_CCBFILELOADER_H
#define MOF_CCBFILELOADER_H

class CCBFileLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeCCBFile(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void loader(void);
	void ~CCBFileLoader();
}
#endif