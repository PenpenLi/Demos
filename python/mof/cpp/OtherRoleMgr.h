#ifndef MOF_OTHERROLEMGR_H
#define MOF_OTHERROLEMGR_H

class OtherRoleMgr{
public:
	void deleteRoleObjInScene(int);
	void uiClearSceneRoles(void);
	void isMainRoleInTown(void);
	void OtherRoleMgr(void);
	void clearSceneRoleList(void);
	void reqSearchSomeOne(std::string);
	void reqChangeLine(int);
	void getSearchRole(int);
	void changeRoleStateCity(int,int);
	void getSceneRoleInfo(int);
	void deleteRoleInList(int);
	void reqGetLineList(void);
	void ~OtherRoleMgr();
	void reqGetSceneRoles(void);
	void ackGetLineList(ack_get_scene_threads);
	void notifyRoleEnterCity(obj_roleinfo);
	void createAllRoleObjInScene(void);
	void createRoleObjInScene(obj_roleinfo);
	void changeShowOtherRoleObj(bool);
	void notifyRoleLeaveCitye(int);
	void clearRoleObjInSence(void);
	void getLineList(void);
	void getRandomPosInArea(cocos2d::CCRect);
	void ackGetSceneRoles(std::vector<obj_roleinfo, std::allocator<obj_roleinfo>>);
	void ackSearchSomeOne(std::string, std::vector<obj_roleinfo,	std::allocator<obj_roleinfo>>);
	void ackEnterCity(int);
	void changeRoleStateCity(int, int);
	void ackGetSceneRoles(std::vector<obj_roleinfo,std::allocator<obj_roleinfo>>);
	void ackSearchSomeOne(std::string,std::vector<obj_roleinfo,std::allocator<obj_roleinfo>>);
}
#endif