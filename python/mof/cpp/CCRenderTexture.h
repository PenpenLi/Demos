#ifndef MOF_CCRENDERTEXTURE_H
#define MOF_CCRENDERTEXTURE_H

class CCRenderTexture{
public:
	void end(void);
	void getSprite(void);
	void create(int,	int, cocos2d::CCTexture2DPixelFormat);
	void saveToFile(char const*, cocos2d::eImageFormat);
	void begin(void);
	void create(int,	int);
	void initWithWidthAndHeight(int,int,cocos2d::CCTexture2DPixelFormat,uint);
	void create(int,int,cocos2d::CCTexture2DPixelFormat);
	void draw(void);
	void initWithWidthAndHeight(int,	int, cocos2d::CCTexture2DPixelFormat, unsigned int);
	void newCCImage(bool);
	void create(int,int);
	void setSprite(cocos2d::CCSprite	*);
	void ~CCRenderTexture();
	void visit(void);
	void saveToFile(char const*,cocos2d::eImageFormat);
}
#endif