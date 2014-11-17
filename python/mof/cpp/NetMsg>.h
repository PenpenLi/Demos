#ifndef MOF_NETMSG>_H
#define MOF_NETMSG>_H

class NetMsg>{
public:
	void push(NetProxy::NetMsg);
	void pop(NetProxy::NetMsg&);
	void clear(void);
}
#endif