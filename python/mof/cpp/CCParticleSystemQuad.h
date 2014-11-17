#ifndef MOF_CCPARTICLESYSTEMQUAD_H
#define MOF_CCPARTICLESYSTEMQUAD_H

class CCParticleSystemQuad{
public:
	void updateQuadWithParticle(cocos2d::sCCParticle *,cocos2d::CCPoint	const&);
	void draw(void);
	void postStep(void);
	void setTextureWithRect(cocos2d::CCTexture2D *, cocos2d::CCRect const&);
	void setTexture(cocos2d::CCTexture2D *);
	void setTextureWithRect(cocos2d::CCTexture2D *,cocos2d::CCRect const&);
	void ~CCParticleSystemQuad();
	void create(void);
	void allocMemory(void);
	void setTotalParticles(uint);
	void initWithTotalParticles(uint);
	void setTotalParticles(unsigned int);
	void updateQuadWithParticle(cocos2d::sCCParticle *,	cocos2d::CCPoint const&);
	void setupIndices(void);
	void listenBackToForeground(cocos2d::CCObject *);
	void initTexCoordsWithRect(cocos2d::CCRect const&);
	void setupVBOandVAO(void);
	void setBatchNode(cocos2d::CCParticleBatchNode *);
}
#endif