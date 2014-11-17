#ifndef MOF_SCENECFG_H
#define MOF_SCENECFG_H

class SceneCfg{
public:
	void checkCopyOpen(int,int);
	void findSceneForType(int, std::vector<int, std::allocator<int>>	&);
	void findSceneForType(int,std::vector<int,std::allocator<int>> &);
	void SceneToString(int);
	void findSceneForIndex(int);
	void checkCopyOpen(int, int);
	void load(std::string);
	void getCfg(int);
}
#endif