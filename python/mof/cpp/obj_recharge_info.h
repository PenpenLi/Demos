#ifndef MOF_OBJ_RECHARGE_INFO_H
#define MOF_OBJ_RECHARGE_INFO_H

class obj_recharge_info{
public:
	void decode(ByteArray &);
	void obj_recharge_info(void);
	void encode(ByteArray &);
}
#endif