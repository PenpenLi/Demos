#ifndef MOF_PETMERGECFG_H
#define MOF_PETMERGECFG_H

class PetMergeCfg{
public:
	void getUplvlExp(int const&,int const&);
	void getMaxStage(void);
	void getPetMergeLvlItem(int const&,int const&);
	void getPetMergeItem(int const&);
	void getUplvlExp(int const&, int const&);
	void getUplvlByExp(int const&, int &,	int const&, int	&);
	void getUplvlTotalExp(int const&, int	const&);
	void getPetMergeLvlItem(int const&, int const&);
	void getUplvlByExp(int const&,int &,int const&,int &);
	void getUplvlTotalExp(int const&,int const&);
	void load(std::string	const&);
}
#endif