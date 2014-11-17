#ifndef MOF_CCPROGRESSTIMER_H
#define MOF_CCPROGRESSTIMER_H

class CCProgressTimer{
public:
	void setMidpoint(cocos2d::CCPoint);
	void draw(void);
	void getBarChangeRate(void)const;
	void getMidpoint(void);
	void textureCoordFromAlphaPoint(cocos2d::CCPoint);
	void setSprite(cocos2d::CCSprite	*);
	void setPercentage(float);
	void getBarChangeRate(void);
	void setOpacityModifyRGB(bool);
	void vertexFromAlphaPoint(cocos2d::CCPoint);
	void updateRadial(void);
	void setType(cocos2d::CCProgressTimerType);
	void setBarChangeRate(cocos2d::CCPoint);
	void setOpacity(unsigned char);
	void setColor(cocos2d::_ccColor3B const&);
	void getColor(void);
	void setOpacity(unsigned	char);
	void updateBar(void);
	void getOpacity(void);
	void create(cocos2d::CCSprite *);
	void ~CCProgressTimer();
	void updateProgress(void);
	void setOpacity(uchar);
	void initWithSprite(cocos2d::CCSprite *);
	void CCProgressTimer(void);
	void setAnchorPoint(cocos2d::CCPoint);
	void boundaryTexCoord(char);
	void updateColor(void);
	void isOpacityModifyRGB(void);
}
#endif