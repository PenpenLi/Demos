#ifndef MOF_ACK_GUILD_APPLICANT_LIST_H
#define MOF_ACK_GUILD_APPLICANT_LIST_H

class ack_guild_applicant_list{
public:
	void decode(ByteArray &);
	void PacketName(void);
	void ack_guild_applicant_list(void);
	void ~ack_guild_applicant_list();
	void build(ByteArray &);
	void encode(ByteArray &);
}
#endif