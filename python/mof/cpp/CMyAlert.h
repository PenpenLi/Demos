#ifndef MOF_CMYALERT_H
#define MOF_CMYALERT_H

class CMyAlert{
public:
	void oneBtnDelegate(void);
	void getInstance(void);
	void cancelButtonDelegate(void);
	void ~CMyAlert();
	void dismissWaitingAlert(void);
	void CMyAlert(void);
	void autoDismissDelegate(void);
	void setAppPause(bool);
	void confirmButtonDelegate(void);
}
#endif