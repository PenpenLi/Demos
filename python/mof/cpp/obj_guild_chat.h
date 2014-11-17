#ifndef MOF_OBJ_GUILD_CHAT_H
#define MOF_OBJ_GUILD_CHAT_H

class obj_guild_chat{
public:
	void decode(ByteArray &);
	void operator=(obj_guild_chat const&);
	void obj_guild_chat(void);
	void encode(ByteArray &);
}
#endif