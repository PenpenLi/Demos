#ifndef MOF_THREADDELEGATEPROTOCOL_H
#define MOF_THREADDELEGATEPROTOCOL_H

class ThreadDelegateProtocol{
public:
	void recieveThreadMessage(ThreadMessage *);
	void ~ThreadDelegateProtocol();
	void ThreadDelegateProtocol(void);
}
#endif