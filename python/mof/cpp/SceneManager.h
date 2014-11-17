#ifndef MOF_SCENEMANAGER_H
#define MOF_SCENEMANAGER_H

class SceneManager{
public:
	void objJoinScene(GameObject	*,GameObject *,int,int);
	void updateAll(float);
	void objJoinScene(GameObject	*, GameObject *, int, int);
	void objLeaveScene(GameObject *);
	void isContainObj(int,GameObject *);
	void clearAllData(void);
	void removeScene(Scene *);
	void create(int);
	void getScene(int);
	void objJoinScene(GameObject	*);
	void isContainObj(int, GameObject *);
}
#endif