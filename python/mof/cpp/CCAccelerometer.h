#ifndef MOF_CCACCELEROMETER_H
#define MOF_CCACCELEROMETER_H

class CCAccelerometer{
public:
	void setDelegate(cocos2d::CCAccelerometerDelegate *);
	void setAccelerometerInterval(float);
	void ~CCAccelerometer();
	void CCAccelerometer(void);
}
#endif