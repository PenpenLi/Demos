#ifndef MOF_SYN_SERVER_TIME_H
#define MOF_SYN_SERVER_TIME_H

class syn_server_time{
public:
	void syn_server_time(void);
	void decode(ByteArray &);
	void PacketName(void);
	void ~syn_server_time();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif