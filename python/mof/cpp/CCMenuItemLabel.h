#ifndef MOF_CCMENUITEMLABEL_H
#define MOF_CCMENUITEMLABEL_H

class CCMenuItemLabel{
public:
	void getOpacity(void);
	void setOpacityModifyRGB(bool);
	void create(cocos2d::CCObject *));
	void setEnabled(bool);
	void setOpacity(unsigned	char);
	void unselected(void);
	void setColor(cocos2d::_ccColor3B const&);
	void getDisabledColor(void);
	void setOpacity(uchar);
	void selected(void);
	void getLabel(void);
	void ~CCMenuItemLabel();
	void activate(void);
	void setDisabledColor(cocos2d::_ccColor3B const&);
	void getColor(void);
	void setString(char const*);
	void initWithLabel(cocos2d::CCObject *));
	void isOpacityModifyRGB(void);
	void setOpacity(unsigned char);
	void initWithLabel(cocos2d::CCObject	*));
	void setLabel(cocos2d::CCNode *);
}
#endif