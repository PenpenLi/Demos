#ifndef MOF_REQ_SYNC_TREASUREFIGHT_RANK_DATA_H
#define MOF_REQ_SYNC_TREASUREFIGHT_RANK_DATA_H

class req_sync_treasurefight_rank_data{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void req_sync_treasurefight_rank_data(void);
	void ~req_sync_treasurefight_rank_data();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif