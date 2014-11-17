#ifndef MOF_NPC_H
#define MOF_NPC_H

class NPC{
public:
	void animationHandler(BoneAniEventType, std::string, std::string, bool);
	void animationHandler(BoneAniEventType,	std::string, std::string, bool);
	void NPC(ObjType,int);
	void update(float);
	void showQuestSign(int);
	void playPhysicalAnimate(float);
	void animationHandler(BoneAniEventType,std::string,std::string,bool);
	void onPick(void);
	void NPC(ObjType, int);
	void showNpcDialog(void);
	void ~NPC();
}
#endif