#ifndef MOF_CCSPRITELOADER_H
#define MOF_CCSPRITELOADER_H

class CCSpriteLoader{
public:
	void onHandlePropTypeBlendFunc(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,cocos2d::_ccBlendFunc,cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor3(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccColor3B,cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *, cocos2d::CCNode *, char const*, unsigned char, cocos2d::extension::CCBReader *);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, cocos2d::CCSpriteFrame *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *,cocos2d::CCNode *,char const*,uchar,cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode	*, cocos2d::CCNode *, char const*, cocos2d::_ccBlendFunc, cocos2d::extension::CCBReader	*);
	void ~CCSpriteLoader();
	void loader(void);
	void onHandlePropTypeColor3(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	cocos2d::_ccColor3B, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFlip(cocos2d::CCNode *, cocos2d::CCNode *, char const*, bool *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeFlip(cocos2d::CCNode *,cocos2d::CCNode *,char const*,bool	*,cocos2d::extension::CCBReader	*);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSpriteFrame *,cocos2d::extension::CCBReader *);
}
#endif