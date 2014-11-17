#ifndef MOF_CCCONTROL_H
#define MOF_CCCONTROL_H

class CCControl{
public:
	void addTargetWithActionForControlEvent(cocos2d::CCObject *,uint),uint);
	void setEnabled(bool);
	void removeTargetWithActionForControlEvents(cocos2d::CCObject *,uint),uint);
	void setSelected(bool);
	void getTouchLocation(cocos2d::CCTouch *);
	void getDefaultTouchPriority(void);
	void sendActionsForControlEvents(unsigned int);
	void needsLayout(void);
	void removeTargetWithActionForControlEvents(cocos2d::CCObject *, unsigned int), unsigned int);
	void CCControl(void);
	void isSelected(void);
	void dispatchListforControlEvent(uint);
	void ~CCControl();
	void setOpacityModifyRGB(bool);
	void setDefaultTouchPriority(int);
	void getState(void);
	void setOpacity(unsigned char);
	void dispatchListforControlEvent(unsigned int);
	void registerWithTouchDispatcher(void);
	void removeTargetWithActionForControlEvent(cocos2d::CCObject *, unsigned int), unsigned int);
	void isEnabled(void);
	void setColor(cocos2d::_ccColor3B const&);
	void addTargetWithActionForControlEvents(cocos2d::CCObject *,uint),uint);
	void onEnter(void);
	void getColor(void);
	void getState(void)const;
	void isHighlighted(void);
	void addTargetWithActionForControlEvent(cocos2d::CCObject *, unsigned int), unsigned int);
	void getOpacity(void);
	void setHighlighted(bool);
	void setOpacity(uchar);
	void getDefaultTouchPriority(void)const;
	void isTouchInside(cocos2d::CCTouch	*);
	void sendActionsForControlEvents(uint);
	void removeTargetWithActionForControlEvent(cocos2d::CCObject *,uint),uint);
	void isOpacityModifyRGB(void);
	void init(void);
	void onExit(void);
	void addTargetWithActionForControlEvents(cocos2d::CCObject	*, unsigned int), unsigned int);
}
#endif