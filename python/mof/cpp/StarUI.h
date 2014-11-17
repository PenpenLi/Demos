#ifndef MOF_STARUI_H
#define MOF_STARUI_H

class StarUI{
public:
	void setpageShow(int, int);
	void setInitShow(int, int,	int);
	void setSpriteMove(int, int);
	void showStarValue(int,int,int);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char	const*);
	void showLightSuccessEffect(int, int);
	void recv(int, int, char const*);
	void showLightSuccessEffect(int,int);
	void ~StarUI();
	void recv(int,void *);
	void setPageLabelShow(int);
	void setLeftImageIsEnable(bool);
	void setRightImageEnable(bool);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *,char const*);
	void setAttributeValue(int,int,int);
	void ccTouchBegan(cocos2d::CCTouch	*,cocos2d::CCEvent *);
	void setSpriteMove(int,int);
	void ccTouchBegan(cocos2d::CCTouch *,cocos2d::CCEvent *);
	void recv(int, void *);
	void ccTouchBegan(cocos2d::CCTouch *, cocos2d::CCEvent *);
	void setlightenShow(void);
	void recv(int,void	*);
	void recv(int,int,cocos2d::CCPoint,int);
	void setSpriteShow(int, int);
	void setAttributeValue(int, int, int);
	void ccTouchBegan(cocos2d::CCTouch	*, cocos2d::CCEvent *);
	void recv(int, int, cocos2d::CCPoint, int);
	void registerWithTouchDispatcher(void);
	void onResolveCCBCCMenuItemSelector(cocos2d::CCObject *, char const*);
	void onMenuItemRightClicked(cocos2d::CCObject *);
	void onMenuItemStarClicked(cocos2d::CCObject *);
	void setInitShow(int,int,int);
	void onEnter(void);
	void onMenuItemCloseClicked(cocos2d::CCObject *);
	void Init(void);
	void recv(int,int,char const*);
	void setpageShow(int,int);
	void setLastPageIconShow(int);
	void showStarValue(int, int, int);
	void create(void);
	void StarUI(void);
	void setStartImageIsEnable(bool);
	void setSpriteShow(int,int);
	void onMenuItemLeftClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif