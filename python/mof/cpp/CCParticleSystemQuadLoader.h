#ifndef MOF_CCPARTICLESYSTEMQUADLOADER_H
#define MOF_CCPARTICLESYSTEMQUADLOADER_H

class CCParticleSystemQuadLoader{
public:
	void ~CCParticleSystemQuadLoader();
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccBlendFunc,cocos2d::extension::CCBReader	*);
	void onHandlePropTypeBlendFunc(cocos2d::CCNode *, cocos2d::CCNode *, char const*, cocos2d::_ccBlendFunc, cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloatVar(cocos2d::CCNode *, cocos2d::CCNode *, char const*, float *, cocos2d::extension::CCBReader *);
	void onHandlePropTypePoint(cocos2d::CCNode	*, cocos2d::CCNode *, char const*, cocos2d::CCPoint, cocos2d::extension::CCBReader *);
	void onHandlePropTypeTexture(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, cocos2d::CCTexture2D *, cocos2d::extension::CCBReader *);
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *, cocos2d::CCNode *, char const*, int, cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(float, int);
	void createCCNode(cocos2d::CCNode *, cocos2d::extension::CCBReader	*);
	void onHandlePropTypeTexture(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::CCTexture2D *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor4FVar(cocos2d::CCNode *,cocos2d::CCNode *,char const*,cocos2d::_ccColor4F *,cocos2d::extension::CCBReader *);
	void onHandlePropTypePoint(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,cocos2d::CCPoint,cocos2d::extension::CCBReader *);
	void onHandlePropTypeInteger(cocos2d::CCNode *, cocos2d::CCNode *,	char const*, int, cocos2d::extension::CCBReader	*);
	void onHandlePropTypeFloatVar(cocos2d::CCNode *,cocos2d::CCNode *,char const*,float *,cocos2d::extension::CCBReader *);
	void loader(void);
	void onHandlePropTypeIntegerLabeled(cocos2d::CCNode *,cocos2d::CCNode *,char const*,int,cocos2d::extension::CCBReader *);
	void onHandlePropTypeColor4FVar(cocos2d::CCNode *,	cocos2d::CCNode	*, char	const*,	cocos2d::_ccColor4F *, cocos2d::extension::CCBReader *);
	void createCCNode(cocos2d::CCNode *,cocos2d::extension::CCBReader *);
	void onHandlePropTypeInteger(cocos2d::CCNode *,cocos2d::CCNode *,char const*,int,cocos2d::extension::CCBReader *);
	void onHandlePropTypeFloat(cocos2d::CCNode	*,cocos2d::CCNode *,char const*,float,cocos2d::extension::CCBReader *);
}
#endif