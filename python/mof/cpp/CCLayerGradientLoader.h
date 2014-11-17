#ifndef MOF_CCLAYERGRADIENTLOADER_H
#define MOF_CCLAYERGRADIENTLOADER_H

class CCLayerGradientLoader{
public:
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::_ccBlendFunc, cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor3(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccColor3B,cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *,cocos2d::CCNode *,char const*,uchar,cocos2d::extension::CCBReader *);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *,cocos2d::CCNode *,char	const*,cocos2d::_ccBlendFunc,cocos2d::extension::CCBReader *);
	void onHandlePropTypePoint(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCPoint,cocos2d::extension::CCBReader *);
	void ~CCLayerGradientLoader();
	void onHandlePropTypePoint(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::CCPoint,	cocos2d::extension::CCBReader *);
	void onHandlePropTypeByte(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, unsigned char, cocos2d::extension::CCBReader *);
	void loader(void);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
}
#endif