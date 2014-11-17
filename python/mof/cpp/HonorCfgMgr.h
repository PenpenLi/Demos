#ifndef MOF_HONORCFGMGR_H
#define MOF_HONORCFGMGR_H

class HonorCfgMgr{
public:
	void getTypeIdByName(std::string);
	void load(void);
	void getHonorByType(std::string, std::vector<HonorDef	*, std::allocator<HonorDef *>> &);
	void getHonorByType(std::string,std::vector<HonorDef *,std::allocator<HonorDef *>> &);
}
#endif