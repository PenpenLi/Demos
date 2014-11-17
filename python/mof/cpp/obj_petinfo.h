#ifndef MOF_OBJ_PETINFO_H
#define MOF_OBJ_PETINFO_H

class obj_petinfo{
public:
	void encode(ByteArray	&);
	void obj_petinfo(void);
	void decode(ByteArray	&);
	void operator=(obj_petinfo const&);
}
#endif