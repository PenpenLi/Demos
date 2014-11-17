#ifndef MOF_ACK_GET_GUILD_TRAIN_DATA_H
#define MOF_ACK_GET_GUILD_TRAIN_DATA_H

class ack_get_guild_train_data{
public:
	void decode(ByteArray &);
	void ack_get_guild_train_data(void);
	void PacketName(void);
	void ~ack_get_guild_train_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif