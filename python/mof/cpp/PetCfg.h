#ifndef MOF_PETCFG_H
#define MOF_PETCFG_H

class PetCfg{
public:
	void getMaxSpecialSkills(int);
	void getStagePropertyRatio(int, int);
	void loadPetStageCfg(char const*);
	void getMaxCommmonSkills(int);
	void calcAbsorbedPropPointsNum(int,std::vector<float,std::allocator<float>> const&);
	void calcAbsorbedPropPointsNum(int, std::vector<float, std::allocator<float>> const&);
	void load(std::string,std::string,std::string);
	void getLvlTotalExp(int,int);
	void getLvlTotalExp(int, int);
	void getCfg(int);
	void calcMaxRateAbsorbedPropPoints(float,int,std::vector<float,std::allocator<float>> const&);
	void calcMaxRateAbsorbedPropPoints(float, int, std::vector<float, std::allocator<float>> const&);
	void getMaxStageLvl(int);
	void getLvlExp(int,int);
	void getLvlExp(int, int);
	void getStagePropertyRatio(int,int);
	void getGrowthVal(int, int);
	void getStageUpConsumeFactor(int,int);
	void calcMinAbsorbedPropPoints(float,int,std::vector<float,std::allocator<float>> const&);
	void loadPetStarCfg(char const*);
	void loadPetGrowCfg(char const*);
	void getGrowthVal(int,int);
	void calcMinAbsorbedPropPoints(float, int,	std::vector<float, std::allocator<float>> const&);
	void getStageUpConsumeFactor(int, int);
}
#endif