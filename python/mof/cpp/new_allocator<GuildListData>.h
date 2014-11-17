#ifndef MOF_NEW_ALLOCATOR<GUILDLISTDATA>_H
#define MOF_NEW_ALLOCATOR<GUILDLISTDATA>_H

class new_allocator<GuildListData>{
public:
	void construct(GuildListData*,GuildListData const&);
}
#endif