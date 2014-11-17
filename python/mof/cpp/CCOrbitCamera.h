#ifndef MOF_CCORBITCAMERA_H
#define MOF_CCORBITCAMERA_H

class CCOrbitCamera{
public:
	void sphericalRadius(float	*,float	*,float	*);
	void update(float);
	void copyWithZone(cocos2d::CCZone *);
	void startWithTarget(cocos2d::CCNode *);
	void sphericalRadius(float	*, float *, float *);
	void create(float,float,float,float,float,float,float);
	void ~CCOrbitCamera();
}
#endif