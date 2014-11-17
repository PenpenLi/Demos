#ifndef MOF_CCAPPLICATION_H
#define MOF_CCAPPLICATION_H

class CCApplication{
public:
	void setAnimationInterval(double);
	void ~CCApplication();
	void getTargetPlatform(void);
	void sharedApplication(void);
	void CCApplication(void);
	void getCurrentLanguage(void);
	void run(void);
}
#endif