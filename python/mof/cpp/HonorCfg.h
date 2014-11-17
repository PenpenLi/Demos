#ifndef MOF_HONORCFG_H
#define MOF_HONORCFG_H

class HonorCfg{
public:
	void getTypeName(eHonorType);
	void getTypeCfg(std::vector<std::string,std::allocator<std::string>> &);
	void getCfg(std::string,std::vector<HonorDef *,std::allocator<HonorDef *>> &);
	void getCfg(std::string,	std::vector<HonorDef *,	std::allocator<HonorDef	*>> &);
	void getTypeId(std::string);
	void getCfg(eHonorType, std::vector<HonorDef *, std::allocator<HonorDef *>> &);
	void getCfg(eHonorType,std::vector<HonorDef *,std::allocator<HonorDef *>> &);
	void getTypeCfg(std::vector<std::string,	std::allocator<std::string>> &);
	void getCfg(int);
	void ~HonorCfg();
	void read(IniFile &);
}
#endif