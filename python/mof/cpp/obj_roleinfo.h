#ifndef MOF_OBJ_ROLEINFO_H
#define MOF_OBJ_ROLEINFO_H

class obj_roleinfo{
public:
	void obj_roleinfo(void);
	void operator=(obj_roleinfo const&);
	void encode(ByteArray &);
	void decode(ByteArray &);
}
#endif