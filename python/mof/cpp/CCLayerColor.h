#ifndef MOF_CCLAYERCOLOR_H
#define MOF_CCLAYERCOLOR_H

class CCLayerColor{
public:
	void draw(void);
	void ~CCLayerColor();
	void setBlendFunc(cocos2d::_ccBlendFunc);
	void create(cocos2d::_ccColor4B const&);
	void initWithColor(cocos2d::_ccColor4B const&, float, float);
	void setOpacityModifyRGB(bool);
	void initWithColor(cocos2d::_ccColor4B const&,float,float);
	void setOpacity(unsigned char);
	void create(cocos2d::_ccColor4B const&, float, float);
	void setColor(cocos2d::_ccColor3B const&);
	void setContentSize(cocos2d::CCSize	const&);
	void getColor(void);
	void getBlendFunc(void);
	void getOpacity(void);
	void CCLayerColor(void);
	void create(void);
	void setOpacity(uchar);
	void initWithColor(cocos2d::_ccColor4B const&);
	void create(cocos2d::_ccColor4B const&,float,float);
	void init(void);
	void updateColor(void);
	void isOpacityModifyRGB(void);
}
#endif