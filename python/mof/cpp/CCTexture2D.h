#ifndef MOF_CCTEXTURE2D_H
#define MOF_CCTEXTURE2D_H

class CCTexture2D{
public:
	void ~CCTexture2D();
	void initPremultipliedATextureWithImage(cocos2d::CCImage *, unsigned	int, unsigned int);
	void initWithPVRFile(char const*);
	void setAliasTexParameters(void);
	void setMaxT(float);
	void getPixelsWide(void);
	void hasPremultipliedAlpha(void);
	void setShaderProgram(cocos2d::CCGLProgram *);
	void getPixelsHigh(void);
	void CCTexture2D(void);
	void initWithData(void const*,cocos2d::CCTexture2DPixelFormat,uint,uint,cocos2d::CCSize const&);
	void initWithImage(cocos2d::CCImage *);
	void setMaxS(float);
	void getContentSize(void);
	void initPremultipliedATextureWithImage(cocos2d::CCImage *,uint,uint);
	void getShaderProgram(void);
	void getPixelFormat(void);
	void initWithString(char const*,char	const*,float,cocos2d::CCSize const&,cocos2d::CCTextAlignment,cocos2d::CCVerticalTextAlignment);
	void initWithString(char const*, char const*, float,	cocos2d::CCSize	const&,	cocos2d::CCTextAlignment, cocos2d::CCVerticalTextAlignment);
	void getMaxS(void);
	void getMaxT(void);
	void initWithData(void const*, cocos2d::CCTexture2DPixelFormat, unsigned int, unsigned int, cocos2d::CCSize const&);
	void getName(void);
	void getContentSizeInPixels(void);
}
#endif