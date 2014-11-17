#ifndef MOF_CCIMEDISPATCHER_H
#define MOF_CCIMEDISPATCHER_H

class CCIMEDispatcher{
public:
	void attachDelegateWithIME(cocos2d::CCIMEDelegate *);
	void sharedDispatcher(void);
	void dispatchKeyboardDidShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void detachDelegateWithIME(cocos2d::CCIMEDelegate *);
	void addDelegate(cocos2d::CCIMEDelegate *);
	void dispatchInsertText(char const*,int);
	void dispatchKeyboardWillShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void removeDelegate(cocos2d::CCIMEDelegate *);
	void dispatchKeyboardDidHide(cocos2d::CCIMEKeyboardNotificationInfo &);
	void dispatchInsertText(char const*, int);
	void ~CCIMEDispatcher();
	void dispatchDeleteBackward(void);
	void dispatchKeyboardWillHide(cocos2d::CCIMEKeyboardNotificationInfo &);
}
#endif