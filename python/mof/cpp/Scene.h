#ifndef MOF_SCENE_H
#define MOF_SCENE_H

class Scene{
public:
	void getAreaCanAttackObjs(LivingObject *,ObjType);
	void clear(void);
	void canAttack(GameObject *,ObjType,LivingObject *);
	void getAttackObjsByArea(GameObject	*, ObjType, cocos2d::CCRect);
	void getAreaSelfGroup(LivingObject *);
	void getAreaObjsByType(ObjType);
	void leaveChildObj(cocos2d::CCNode *);
	void getAttackObjsByArea(GameObject	*,ObjType,cocos2d::CCRect);
	void ~Scene();
	void update(float);
	void Scene(int);
	void isContainObj(GameObject *);
	void getAreaCanAttackObjs(LivingObject *, ObjType);
	void getAttackObjsByArea(GameObject	*, cocos2d::CCRect);
	void deleteMarkedObjs(void);
	void atkObjs(LivingObject *);
	void canAttack(GameObject *, ObjType, LivingObject *);
	void areaMonsterNum(cocos2d::CCRect);
	void objLeave(GameObject *,bool);
	void clearAll(void);
	void objJoin(GameObject *);
	void getObjsByType(ObjType);
	void getAttackObjsByArea(GameObject	*,cocos2d::CCRect);
	void objLeave(GameObject *,	bool);
}
#endif