#ifndef MOF_CCDISPLAYLINKDIRECTOR_H
#define MOF_CCDISPLAYLINKDIRECTOR_H

class CCDisplayLinkDirector{
public:
	void stopAnimation(void);
	void setAnimationInterval(double);
	void ~CCDisplayLinkDirector();
	void mainLoop(void);
	void startAnimation(void);
}
#endif