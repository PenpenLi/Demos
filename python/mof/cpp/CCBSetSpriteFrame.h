#ifndef MOF_CCBSETSPRITEFRAME_H
#define MOF_CCBSETSPRITEFRAME_H

class CCBSetSpriteFrame{
public:
	void create(cocos2d::CCSpriteFrame *);
	void copyWithZone(cocos2d::CCZone *);
	void ~CCBSetSpriteFrame();
	void update(float);
}
#endif