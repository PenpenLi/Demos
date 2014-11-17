#ifndef MOF_PETPVPREDEMPTIONCFG_H
#define MOF_PETPVPREDEMPTIONCFG_H

class PetPvpRedemptionCfg{
public:
	void load(std::string);
	void consumPoints(int);
	void getItems(PetPvpType);
}
#endif