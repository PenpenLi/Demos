#ifndef MOF_CCTOUCH_H
#define MOF_CCTOUCH_H

class CCTouch{
public:
	void getDelta(void);
	void ~CCTouch();
	void getLocation(void);
	void CCTouch(void);
	void getLocationInView(void);
	void getDelta(void)const;
	void getLocation(void)const;
	void getLocationInView(void)const;
}
#endif