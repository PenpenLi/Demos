#ifndef MOF_CITEMBUTTON_H
#define MOF_CITEMBUTTON_H

class CItemButton{
public:
	void ccTouchEnded(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void setTitleLabel(cocos2d::CCLabelTTF *);
	void setEnabled(bool);
	void createBySprite(char const*, char const*, char const*, float,	cocos2d::_ccColor3B);
	void setSelected(bool);
	void createBySprite(char const*,char const*,char const*,float,cocos2d::_ccColor3B);
	void ccTouchEnded(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void needsLayout(void);
	void getTitleLabel(void)const;
	void getBackgroundSprite(void)const;
	void ccTouchCancelled(cocos2d::CCTouch *,	cocos2d::CCEvent *);
	void setBackgroundSprite(cocos2d::CCSprite *);
	void create(char const*, char const*, char const*, float,	cocos2d::_ccColor3B);
	void ccTouchCancelled(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void SetItemModAndNum(int,int);
	void getZoomOnTouchDown(void);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void SetItemModAndNum(int, int);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void create(char const*,char const*,char const*,float,cocos2d::_ccColor3B);
	void setLabelAnchorPoint(cocos2d::CCPoint);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent	*);
	void getLabelAnchorPoint(void);
	void create(int, int, char const*, float,	cocos2d::_ccColor3B);
	void ccTouchMoved(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void ccTouchMoved(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void getBackgroundSprite(void);
	void CItemButton(void);
	void initWithLabelAndBackgroundSprite(float, int);
	void setHighlighted(bool);
	void ccTouchCancelled(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void ~CItemButton();
	void getTitleLabel(void);
	void create(int,int,char const*,float,cocos2d::_ccColor3B);
	void setZoomOnTouchDown(bool);
	void initWithLabelAndBackgroundSprite(cocos2d::CCSprite *,char const*,char const*,float,cocos2d::_ccColor3B);
}
#endif