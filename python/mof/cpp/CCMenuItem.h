#ifndef MOF_CCMENUITEM_H
#define MOF_CCMENUITEM_H

class CCMenuItem{
public:
	void registerScriptTapHandler(int);
	void isSelected(void);
	void rect(void);
	void unregisterScriptTapHandler(void);
	void setEnabled(bool);
	void initWithTarget(cocos2d::CCObject	*));
	void isEnabled(void);
	void setTarget(cocos2d::CCObject *));
	void selected(void);
	void ~CCMenuItem();
	void unselected(void);
	void activate(void);
}
#endif