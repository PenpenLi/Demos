#ifndef MOF_UIEFFECT_H
#define MOF_UIEFFECT_H

class UIEffect{
public:
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void ~UIEffect();
	void animationHandler(BoneAniEventType, std::string, std::string, bool);
	void createEffect(ObjType, int, int, bool);
	void createEffect(ObjType,int,int,bool);
}
#endif