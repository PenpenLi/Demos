#ifndef MOF_CCSCALE9SPRITELOADER_H
#define MOF_CCSCALE9SPRITELOADER_H

class CCScale9SpriteLoader{
public:
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode	*, cocos2d::CCNode *, char const*, cocos2d::CCSpriteFrame *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeSize(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCSize,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(float, int);
	void onHandlePropTypeColor3(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccColor3B,cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *, cocos2d::CCNode *, char const*, unsigned char, cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor3(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::_ccColor3B, cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *,cocos2d::CCNode *,char const*,uchar,cocos2d::extension::CCBReader *);
	void onHandlePropTypeSpriteFrame(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,cocos2d::CCSpriteFrame *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *,cocos2d::CCNode	*,char const*,cocos2d::_ccBlendFunc,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(cocos2d::CCNode *,cocos2d::CCNode *,char const*,float,cocos2d::extension::CCBReader *);
	void loader(void);
	void onHandlePropTypeSize(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::CCSize, cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::_ccBlendFunc,	cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void ~CCScale9SpriteLoader();
}
#endif