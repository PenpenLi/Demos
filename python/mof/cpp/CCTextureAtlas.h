#ifndef MOF_CCTEXTUREATLAS_H
#define MOF_CCTEXTUREATLAS_H

class CCTextureAtlas{
public:
	void setQuads(cocos2d::_ccV3F_C4B_T2F_Quad *);
	void insertQuad(cocos2d::_ccV3F_C4B_T2F_Quad *, unsigned int);
	void getTexture(void);
	void listenBackToForeground(cocos2d::CCObject *);
	void resizeCapacity(uint);
	void drawNumberOfQuads(unsigned int, unsigned int);
	void drawNumberOfQuads(uint,uint);
	void insertQuad(cocos2d::_ccV3F_C4B_T2F_Quad *,uint);
	void getCapacity(void);
	void setupIndices(void);
	void updateQuad(cocos2d::_ccV3F_C4B_T2F_Quad *,uint);
	void setTexture(cocos2d::CCTexture2D *);
	void mapBuffers(void);
	void removeQuadAtIndex(uint);
	void initWithTexture(cocos2d::CCTexture2D	*,uint);
	void initWithTexture(cocos2d::CCTexture2D	*, unsigned int);
	void updateQuad(cocos2d::_ccV3F_C4B_T2F_Quad *, unsigned int);
	void getQuads(void);
	void CCTextureAtlas(void);
	void setupVBOandVAO(void);
	void resizeCapacity(unsigned int);
	void ~CCTextureAtlas();
	void removeAllQuads(void);
	void getTotalQuads(void);
	void removeQuadAtIndex(unsigned int);
	void drawQuads(void);
}
#endif