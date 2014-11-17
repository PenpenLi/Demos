#ifndef MOF_OBJ_PRIVATE_CHAT_H
#define MOF_OBJ_PRIVATE_CHAT_H

class obj_private_chat{
public:
	void decode(ByteArray &);
	void obj_private_chat(void);
	void encode(ByteArray &);
	void operator=(obj_private_chat const&);
}
#endif