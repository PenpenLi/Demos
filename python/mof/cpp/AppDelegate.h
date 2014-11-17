#ifndef MOF_APPDELEGATE_H
#define MOF_APPDELEGATE_H

class AppDelegate{
public:
	void applicationDidEnterBackground(void);
	void AppDelegate(void);
	void ~AppDelegate();
	void applicationDidFinishLaunching(void);
	void applicationWillEnterForeground(void);
}
#endif