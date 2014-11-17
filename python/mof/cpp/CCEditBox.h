#ifndef MOF_CCEDITBOX_H
#define MOF_CCEDITBOX_H

class CCEditBox{
public:
	void setMaxLength(int);
	void create(cocos2d::CCSize	const&,	cocos2d::extension::CCScale9Sprite *, cocos2d::extension::CCScale9Sprite *, cocos2d::extension::CCScale9Sprite *);
	void touchDownAction(cocos2d::CCObject *, unsigned int);
	void setPlaceHolder(char const*);
	void keyboardWillShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void create(cocos2d::CCSize	const&,cocos2d::extension::CCScale9Sprite *,cocos2d::extension::CCScale9Sprite *,cocos2d::extension::CCScale9Sprite *);
	void keyboardDidHide(cocos2d::CCIMEKeyboardNotificationInfo	&);
	void setInputMode(cocos2d::extension::EditBoxInputMode);
	void keyboardDidHide(cocos2d::CCIMEKeyboardNotificationInfo &);
	void keyboardDidShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void visit(void);
	void setDelegate(cocos2d::extension::CCEditBoxDelegate *);
	void setPosition(cocos2d::CCPoint const&);
	void setContentSize(cocos2d::CCSize	const&);
	void initWithSizeAndBackgroundSprite(cocos2d::CCSize const&, cocos2d::extension::CCScale9Sprite *);
	void setText(char const*);
	void keyboardWillHide(cocos2d::CCIMEKeyboardNotificationInfo &);
	void setInputFlag(cocos2d::extension::EditBoxInputFlag);
	void touchDownAction(cocos2d::CCObject *,uint);
	void initWithSizeAndBackgroundSprite(cocos2d::CCSize const&,cocos2d::extension::CCScale9Sprite *);
	void setFontColor(cocos2d::_ccColor3B const&);
	void CCEditBox(void);
	void keyboardDidShow(cocos2d::CCIMEKeyboardNotificationInfo	&);
	void ~CCEditBox();
	void onExit(void);
}
#endif