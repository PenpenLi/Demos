#ifndef MOF_CCSPRITEFRAME_H
#define MOF_CCSPRITEFRAME_H

class CCSpriteFrame{
public:
	void initWithTextureFilename(char const*,cocos2d::CCRect const&,bool,cocos2d::CCPoint const&,cocos2d::CCSize const&);
	void getTexture(void);
	void createWithTexture(cocos2d::CCTexture2D *,cocos2d::CCRect const&);
	void ~CCSpriteFrame();
	void initWithTexture(cocos2d::CCTexture2D *, cocos2d::CCRect const&);
	void copyWithZone(cocos2d::CCZone *);
	void createWithTexture(cocos2d::CCTexture2D *, cocos2d::CCRect const&, bool, cocos2d::CCPoint const&, cocos2d::CCSize const&);
	void initWithTextureFilename(char const*, cocos2d::CCRect const&, bool, cocos2d::CCPoint const&, cocos2d::CCSize const&);
	void createWithTexture(cocos2d::CCTexture2D *,cocos2d::CCRect const&,bool,cocos2d::CCPoint	const&,cocos2d::CCSize const&);
	void getOffset(void);
	void initWithTexture(cocos2d::CCTexture2D *, cocos2d::CCRect const&, bool,	cocos2d::CCPoint const&, cocos2d::CCSize const&);
	void initWithTexture(cocos2d::CCTexture2D *,cocos2d::CCRect const&);
	void setTexture(cocos2d::CCTexture2D *);
	void initWithTexture(cocos2d::CCTexture2D *,cocos2d::CCRect const&,bool,cocos2d::CCPoint const&,cocos2d::CCSize const&);
}
#endif