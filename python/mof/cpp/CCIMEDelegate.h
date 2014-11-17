#ifndef MOF_CCIMEDELEGATE_H
#define MOF_CCIMEDELEGATE_H

class CCIMEDelegate{
public:
	void keyboardDidHide(cocos2d::CCIMEKeyboardNotificationInfo &);
	void didAttachWithIME(void);
	void canDetachWithIME(void);
	void keyboardWillShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void didDetachWithIME(void);
	void keyboardDidShow(cocos2d::CCIMEKeyboardNotificationInfo &);
	void detachWithIME(void);
	void canAttachWithIME(void);
	void ~CCIMEDelegate();
	void insertText(char const*,int);
	void deleteBackward(void);
	void CCIMEDelegate(void);
	void attachWithIME(void);
	void getContentText(void);
	void keyboardWillHide(cocos2d::CCIMEKeyboardNotificationInfo &);
	void insertText(char const*, int);
}
#endif