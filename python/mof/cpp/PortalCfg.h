#ifndef MOF_PORTALCFG_H
#define MOF_PORTALCFG_H

class PortalCfg{
public:
	void findPortalsForSceneID(int,std::vector<int,std::allocator<int>> *);
	void findPortalForSceneID(int, int);
	void findPortalForSceneID(int,int);
	void findPortalsForSceneID(int,	std::vector<int, std::allocator<int>> *);
	void load(std::string);
	void getCfg(int);
}
#endif