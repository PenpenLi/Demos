#ifndef MOF_OBJ_ROLE_H
#define MOF_OBJ_ROLE_H

class obj_role{
public:
	void decode(ByteArray &);
	void operator=(obj_role const&);
	void obj_role(void);
	void ~obj_role();
	void encode(ByteArray &);
}
#endif