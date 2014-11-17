#ifndef MOF_STARGAMEUI_H
#define MOF_STARGAMEUI_H

class StarGameUI{
public:
	void goToLoginScene(float);
	void ~StarGameUI();
	void checkClientVersion(float);
	void onEnter(void);
	void launchGameLogo(float);
	void init(void);
	void onExit(void);
	void launchVxinYouLogo(float);
}
#endif