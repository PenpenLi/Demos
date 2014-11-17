#ifndef MOF_GUILDGOODSCFG_H
#define MOF_GUILDGOODSCFG_H

class GuildGoodsCfg{
public:
	void RemainGoods(std::vector<int,std::allocator<int>> &);
	void ~GuildGoodsCfg();
	void checkIsIndex(int);
	void read(void);
}
#endif