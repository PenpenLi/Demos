#ifndef MOF_CCSCROLLVIEWLOADER_H
#define MOF_CCSCROLLVIEWLOADER_H

class CCScrollViewLoader{
public:
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *,cocos2d::CCNode *,char const*,int,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,float,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(float, int);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void ~CCScrollViewLoader();
	void loader(void);
	void onHandlePropTypeCheck(cocos2d::CCNode	*, cocos2d::CCNode *, char const*, bool, cocos2d::extension::CCBReader *);
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *, cocos2d::CCNode *, char const*, int, cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::CCSize, cocos2d::extension::CCBReader *);
	void onHandlePropTypeCCBFile(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeCCBFile(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *,cocos2d::CCNode *,char	const*,cocos2d::CCSize,cocos2d::extension::CCBReader *);
	void onHandlePropTypeCheck(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,bool,cocos2d::extension::CCBReader *);
}
#endif