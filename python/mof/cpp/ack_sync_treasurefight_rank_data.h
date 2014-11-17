#ifndef MOF_ACK_SYNC_TREASUREFIGHT_RANK_DATA_H
#define MOF_ACK_SYNC_TREASUREFIGHT_RANK_DATA_H

class ack_sync_treasurefight_rank_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_sync_treasurefight_rank_data(void);
	void ~ack_sync_treasurefight_rank_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif