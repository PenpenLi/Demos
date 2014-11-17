#ifndef MOF_CCLABELTTF_H
#define MOF_CCLABELTTF_H

class CCLabelTTF{
public:
	void create(char const*, char	const*,	float, cocos2d::CCSize const&, cocos2d::CCTextAlignment, cocos2d::CCVerticalTextAlignment);
	void create(char const*, char	const*,	float, cocos2d::CCSize const&, cocos2d::CCTextAlignment);
	void create(char const*,char const*,float);
	void setFontName(char	const*);
	void initWithString(char const*,char const*,float,cocos2d::CCSize const&,cocos2d::CCTextAlignment,cocos2d::CCVerticalTextAlignment);
	void getString(void);
	void setFontSize(float);
	void setDimensions(cocos2d::CCSize const&);
	void CCLabelTTF(void);
	void setString(char const*);
	void initWithString(char const*, char	const*,	float, cocos2d::CCSize const&, cocos2d::CCTextAlignment, cocos2d::CCVerticalTextAlignment);
	void getFontSize(void);
	void create(char const*,char const*,float,cocos2d::CCSize const&,cocos2d::CCTextAlignment,cocos2d::CCVerticalTextAlignment);
	void setVerticalAlignment(cocos2d::CCVerticalTextAlignment);
	void setHorizontalAlignment(cocos2d::CCTextAlignment);
	void getFontName(void);
	void ~CCLabelTTF();
	void updateTexture(void);
	void create(void);
	void create(char const*,char const*,float,cocos2d::CCSize const&,cocos2d::CCTextAlignment);
	void init(void);
	void create(char const*, char	const*,	float);
}
#endif