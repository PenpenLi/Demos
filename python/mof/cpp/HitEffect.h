#ifndef MOF_HITEFFECT_H
#define MOF_HITEFFECT_H

class HitEffect{
public:
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void animationHandler(BoneAniEventType, std::string, std::string,	bool);
	void animationHandler(BoneAniEventType,	std::string, std::string, bool);
	void ~HitEffect();
}
#endif