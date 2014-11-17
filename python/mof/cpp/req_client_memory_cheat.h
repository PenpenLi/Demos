#ifndef MOF_REQ_CLIENT_MEMORY_CHEAT_H
#define MOF_REQ_CLIENT_MEMORY_CHEAT_H

class req_client_memory_cheat{
public:
	void req_client_memory_cheat(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~req_client_memory_cheat();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif