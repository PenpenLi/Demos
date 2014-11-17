#ifndef MOF_OBJ_GUILD_INFO_H
#define MOF_OBJ_GUILD_INFO_H

class obj_guild_info{
public:
	void decode(ByteArray &);
	void obj_guild_info(void);
	void encode(ByteArray &);
	void operator=(obj_guild_info const&);
}
#endif