#ifndef MOF_NETPROXY_H
#define MOF_NETPROXY_H

class NetProxy{
public:
	void ~NetProxy();
	void connect(char const*,ushort);
	void postPacket(int this, int INetPacket);
	void sendProc(void *);
	void stopAsync(void);
	void startAsync(void);
	void sendThread(void);
	void connect(char const*, unsigned short);
	void postPacket(INetPacket *);
	void connect(void);
	void recvProc(void *);
	void passiveClose(void);
	void positiveClose(void);
	void writeNetMsg(NetProxy::NetMsg &);
	void readNetMsg(NetProxy::NetMsg	&);
	void recvThread(void);
}
#endif