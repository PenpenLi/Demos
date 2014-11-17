#ifndef MOF_CCLABELTTFLOADER_H
#define MOF_CCLABELTTFLOADER_H

class CCLabelTTFLoader{
public:
	void onHandlePropTypeText(cocos2d::CCNode *,cocos2d::CCNode *,char const*,char const*,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSize,cocos2d::extension::CCBReader *);
	void ~CCLabelTTFLoader();
	void onHandlePropTypeText(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	char const*, cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccBlendFunc,cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *,cocos2d::CCNode *,char const*,uchar,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFontTTF(cocos2d::CCNode	*, cocos2d::CCNode *, char const*, char	const*,	cocos2d::extension::CCBReader *);
	void onHandlePropTypeFontTTF(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,char const*,cocos2d::extension::CCBReader *);
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *, cocos2d::CCNode *, char const*, int, cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	cocos2d::CCSize, cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloatScale(float, int);
	void onHandlePropTypeFloatScale(cocos2d::CCNode *,cocos2d::CCNode *,char const*,float,cocos2d::extension::CCBReader *);
	void loader(void);
	void onHandlePropTypeByte(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	unsigned char, cocos2d::extension::CCBReader *);
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *,cocos2d::CCNode *,char	const*,int,cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, cocos2d::_ccBlendFunc, cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor3(cocos2d::CCNode *,cocos2d::CCNode *,char	const*,cocos2d::_ccColor3B,cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,	cocos2d::extension::CCBReader *);
}
#endif