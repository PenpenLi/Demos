#ifndef MOF_OBJMOTIONUTILS_H
#define MOF_OBJMOTIONUTILS_H

class ObjMotionUtils{
public:
	void walkDestinationToSpeedVector(cocos2d::CCPoint, cocos2d::CCPoint, float);
	void speedVectorToWalkDestinationForArea(cocos2d::CCPoint,	cocos2d::CCPoint, cocos2d::CCRect, bool);
	void walkDestinationToSpeedVector(cocos2d::CCPoint,cocos2d::CCPoint,float);
	void calculateOrientation(cocos2d::CCPoint,cocos2d::CCPoint);
	void speedVectorToWalkDestinationForArea(cocos2d::CCPoint,cocos2d::CCPoint,cocos2d::CCRect,bool);
	void calculateOrientationRadian(cocos2d::CCPoint);
}
#endif