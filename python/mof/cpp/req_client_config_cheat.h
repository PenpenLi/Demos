#ifndef MOF_REQ_CLIENT_CONFIG_CHEAT_H
#define MOF_REQ_CLIENT_CONFIG_CHEAT_H

class req_client_config_cheat{
public:
	void ~req_client_config_cheat();
	void decode(ByteArray &);
	void PacketName(void);
	void req_client_config_cheat(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif