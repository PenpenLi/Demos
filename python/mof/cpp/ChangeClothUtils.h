#ifndef MOF_CHANGECLOTHUTILS_H
#define MOF_CHANGECLOTHUTILS_H

class ChangeClothUtils{
public:
	void nameToBodyPart(std::string);
	void getItemClothName(int);
	void getItemBodyPart(int);
	void getItemSkeletonName(int);
	void isSelfQualityEquip(int);
	void bodyPartToName(BodyPart);
}
#endif