#ifndef MOF_CCLAYERGRADIENT_H
#define MOF_CCLAYERGRADIENT_H

class CCLayerGradient{
public:
	void setStartColor(cocos2d::_ccColor3B const&);
	void initWithColor(cocos2d::_ccColor4B const&, cocos2d::_ccColor4B const&);
	void getEndOpacity(void);
	void setEndOpacity(unsigned char);
	void setEndOpacity(uchar);
	void setStartOpacity(unsigned char);
	void setVector(cocos2d::CCPoint const&);
	void initWithColor(cocos2d::_ccColor4B const&, cocos2d::_ccColor4B const&, cocos2d::CCPoint const&);
	void getEndColor(void);
	void isCompressedInterpolation(void);
	void getStartOpacity(void);
	void getVector(void);
	void setStartOpacity(uchar);
	void setCompressedInterpolation(bool);
	void initWithColor(cocos2d::_ccColor4B const&,cocos2d::_ccColor4B const&,cocos2d::CCPoint const&);
	void ~CCLayerGradient();
	void getStartColor(void);
	void create(void);
	void init(void);
	void initWithColor(cocos2d::_ccColor4B const&,cocos2d::_ccColor4B const&);
	void setEndColor(cocos2d::_ccColor3B const&);
	void updateColor(void);
}
#endif