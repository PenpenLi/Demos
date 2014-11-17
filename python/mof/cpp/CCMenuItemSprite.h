#ifndef MOF_CCMENUITEMSPRITE_H
#define MOF_CCMENUITEMSPRITE_H

class CCMenuItemSprite{
public:
	void setDisabledImage(cocos2d::CCNode *);
	void getNormalImage(void);
	void getOpacity(void);
	void setSelectedImage(cocos2d::CCNode *);
	void setOpacity(unsigned char);
	void setColor(cocos2d::_ccColor3B	const&);
	void getDisabledImage(void);
	void setColor(cocos2d::_ccColor3B const&);
	void setOpacity(uchar);
	void setOpacityModifyRGB(bool);
	void selected(void);
	void setEnabled(bool);
	void setNormalImage(cocos2d::CCNode *);
	void updateImagesVisibility(void);
	void getSelectedImage(void);
	void getColor(void);
	void unselected(void);
	void initWithNormalSprite(cocos2d::CCObject *));
	void isOpacityModifyRGB(void);
}
#endif