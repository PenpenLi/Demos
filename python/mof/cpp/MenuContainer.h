#ifndef MOF_MENUCONTAINER_H
#define MOF_MENUCONTAINER_H

class MenuContainer{
public:
	void onItemTochDownClicked(cocos2d::CCObject *);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject	*);
	void ~MenuContainer();
	void onItemTochDownClicked(cocos2d::CCObject	*);
	void setEffect(cocos2d::CCPoint);
	void adjustScrollView(cocos2d::extension::CCScrollView *,int,int *);
	void onReceiveDragInsideClicked(cocos2d::CCObject *);
	void clickedAction(float);
	void onReceiveTouchUpOutsideClicked(cocos2d::CCObject *);
	void create(void);
	void MenuContainer(void);
	void onEnter(void);
	void createControl(void);
	void onReceiveTouchUpInsideClicked(cocos2d::CCObject *);
	void init(void);
	void onExit(void);
}
#endif