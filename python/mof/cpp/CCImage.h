#ifndef MOF_CCIMAGE_H
#define MOF_CCIMAGE_H

class CCImage{
public:
	void getWidth(void);
	void getWidth(void)const;
	void _initWithRawData(void *, int, int, int, int);
	void _initWithRawData(void *,int,int,int,int);
	void initWithImageData(void *,int,cocos2d::CCImage::EImageFormat,int,int,int);
	void initWithString(char	const*,	int, int, cocos2d::CCImage::ETextAlign,	char const*, int);
	void saveToFile(char const*,bool);
	void getHeight(void);
	void initWithString(char	const*,int,int,cocos2d::CCImage::ETextAlign,char const*,int);
	void getBitsPerComponent(void);
	void initWithImageData(void *, int, cocos2d::CCImage::EImageFormat, int,	int, int);
	void ~CCImage();
	void CCImage(void);
	void getBitsPerComponent(void)const;
	void saveToFile(char const*, bool);
	void getHeight(void)const;
}
#endif