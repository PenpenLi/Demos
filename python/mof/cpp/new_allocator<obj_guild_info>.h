#ifndef MOF_NEW_ALLOCATOR<OBJ_GUILD_INFO>_H
#define MOF_NEW_ALLOCATOR<OBJ_GUILD_INFO>_H

class new_allocator<obj_guild_info>{
public:
	void construct(obj_guild_info*,obj_guild_info const&);
}
#endif