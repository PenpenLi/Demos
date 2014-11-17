#ifndef MOF_REQ_GET_GUILD_TRAIN_DATA_H
#define MOF_REQ_GET_GUILD_TRAIN_DATA_H

class req_get_guild_train_data{
public:
	void decode(ByteArray &);
	void req_get_guild_train_data(void);
	void PacketName(void);
	void ~req_get_guild_train_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif