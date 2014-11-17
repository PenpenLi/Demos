#ifndef MOF_PLAYEREQUIP_H
#define MOF_PLAYEREQUIP_H

class PlayerEquip{
public:
	void calculateEquipResonance(void);
	void Create(int);
	void GetEquipInfo(int);
	void ~PlayerEquip();
	void GetName(void);
}
#endif