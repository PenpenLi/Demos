#ifndef MOF_NOTIFY_SERVER_BREAK_SOCKET_H
#define MOF_NOTIFY_SERVER_BREAK_SOCKET_H

class notify_server_break_socket{
public:
	void decode(ByteArray &);
	void ~notify_server_break_socket();
	void PacketName(void);
	void notify_server_break_socket(void);
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif