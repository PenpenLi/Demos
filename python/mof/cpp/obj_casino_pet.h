#ifndef MOF_OBJ_CASINO_PET_H
#define MOF_OBJ_CASINO_PET_H

class obj_casino_pet{
public:
	void obj_casino_pet(void);
	void decode(ByteArray &);
	void operator=(obj_casino_pet const&);
	void encode(ByteArray &);
}
#endif