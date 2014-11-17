#ifndef MOF_CCCONTROLBUTTONLOADER_H
#define MOF_CCCONTROLBUTTONLOADER_H

class CCControlButtonLoader{
public:
	void onHandlePropTypeFloatScale(float, int);
	void onHandlePropTypePoint(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCPoint,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSize,cocos2d::extension::CCBReader	*);
	void onHandlePropTypeColor3(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccColor3B,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, cocos2d::CCSize, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeFontTTF(cocos2d::CCNode *,cocos2d::CCNode *,char const*,char const*,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloatScale(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,float,cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor3(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::_ccColor3B, cocos2d::extension::CCBReader *);
	void onHandlePropTypeCheck(cocos2d::CCNode *,cocos2d::CCNode *,char const*,bool,cocos2d::extension::CCBReader *);
	void onHandlePropTypeString(cocos2d::CCNode *,cocos2d::CCNode *,char const*,char const*,cocos2d::extension::CCBReader *);
	void onHandlePropTypePoint(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::CCPoint,	cocos2d::extension::CCBReader *);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSpriteFrame	*,cocos2d::extension::CCBReader	*);
	void loader(void);
	void onHandlePropTypeFontTTF(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	char const*, cocos2d::extension::CCBReader *);
	void onHandlePropTypeString(cocos2d::CCNode *, cocos2d::CCNode *, char const*, char const*, cocos2d::extension::CCBReader *);
	void ~CCControlButtonLoader();
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::CCSpriteFrame *, cocos2d::extension::CCBReader *);
}
#endif