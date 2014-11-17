#ifndef MOF_NOTIFY_FRESH_FAMESHALL_LIST_H
#define MOF_NOTIFY_FRESH_FAMESHALL_LIST_H

class notify_fresh_fameshall_list{
public:
	void decode(ByteArray	&);
	void ~notify_fresh_fameshall_list();
	void notify_fresh_fameshall_list(void);
	void PacketName(void);
	void encode(ByteArray	&);
	void build(ByteArray &);
}
#endif