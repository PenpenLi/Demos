#ifndef MOF_TCP_H
#define MOF_TCP_H

class Tcp{
public:
	void create(std::string,int);
	void pushPacket2SafeQueue(INetPacket *);
	void close(void);
	void calculatePing(INetPacket	*);
	void send(INetPacket &));
	void onRecvPacket(char *,int);
	void setIsProcessMultiPackets(bool);
	void processPacket(void);
	void onRecvPacket(char *, int);
}
#endif