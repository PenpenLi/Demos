#ifndef MOF_GAMEOBJECT_H
#define MOF_GAMEOBJECT_H

class GameObject{
public:
	void setClientInstID(int);
	void getStandingArmatureDisplay(cocos2d::CCNode *);
	void setTpltID(int);
	void readyToDelete(void);
	void getServerInstID(void);
	void getSceneID(void)const;
	void getSceneID(void);
	void getTpltID(void);
	void update(float);
	void GameObject(ObjType, int, int);
	void reset(void);
	void onPick(void);
	void GameObject(ObjType,int,int);
	void generateObjClientInstID(ObjType);
	void getServerInstID(void)const;
	void getForwardPos(float);
	void getClientInstID(void)const;
	void ~GameObject();
	void getClientInstID(void);
	void isLivingObject(void);
	void setServerInstID(int);
	void setSceneID(int);
}
#endif