#ifndef MOF_OBJ_WORLDROLE_INFO_H
#define MOF_OBJ_WORLDROLE_INFO_H

class obj_worldrole_info{
public:
	void decode(ByteArray &);
	void obj_worldrole_info(void);
	void encode(ByteArray &);
	void operator=(obj_worldrole_info const&);
}
#endif