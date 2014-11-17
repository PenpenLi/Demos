#ifndef MOF_CCLABELBMFONT_H
#define MOF_CCLABELBMFONT_H

class CCLabelBMFont{
public:
	void setString(char const*,bool);
	void updateLabel(void);
	void setScaleX(float);
	void createFontChars(void);
	void setCString(char const*);
	void purgeCachedData(void);
	void initWithString(char const*, char const*, float, cocos2d::CCTextAlignment, cocos2d::CCPoint);
	void setOpacityModifyRGB(bool);
	void getString(void);
	void setLineBreakWithoutSpace(bool);
	void initWithString(char const*,char const*,float,cocos2d::CCTextAlignment,cocos2d::CCPoint);
	void setScaleY(float);
	void create(char const*, char const*);
	void setString(char const*);
	void ~CCLabelBMFont();
	void setOpacity(unsigned char);
	void updateString(bool);
	void setScale(float);
	void create(char const*,char const*,float,cocos2d::CCTextAlignment,cocos2d::CCPoint);
	void setString(char const*, bool);
	void setColor(cocos2d::_ccColor3B const&);
	void setWidth(float);
	void setFntFile(char const*);
	void getColor(void);
	void getOpacity(void);
	void setAnchorPoint(cocos2d::CCPoint const&);
	void create(void);
	void setOpacity(uchar);
	void create(char const*, char const*, float, cocos2d::CCTextAlignment, cocos2d::CCPoint);
	void setAlignment(cocos2d::CCTextAlignment);
	void getFntFile(void);
	void CCLabelBMFont(void);
	void create(char const*,char const*);
	void isOpacityModifyRGB(void);
}
#endif