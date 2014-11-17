#ifndef MOF_WALKTO_H
#define MOF_WALKTO_H

class WalkTo{
public:
	void ~WalkTo();
	void WalkTo(cocos2d::CCPoint);
	void step(float);
	void startWithTarget(cocos2d::CCNode *);
	void isDone(void);
	void create(cocos2d::CCPoint,std::string);
}
#endif