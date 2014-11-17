#ifndef MOF_CLOUDMOVE_H
#define MOF_CLOUDMOVE_H

class CloudMove{
public:
	void CloudMove(float);
	void ~CloudMove();
	void CloudMove(cocos2d::CCNode *,float,float,float);
	void onArriveRightPos(void);
	void create(cocos2d::CCNode *,float,float,float);
}
#endif