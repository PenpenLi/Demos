#ifndef MOF_ANIMATE_H
#define MOF_ANIMATE_H

class Animate{
public:
	void startWithTarget(cocos2d::CCNode *);
	void step(float);
	void ~Animate();
}
#endif