#ifndef MOF_THREADMESSAGEHANDER_H
#define MOF_THREADMESSAGEHANDER_H

class ThreadMessageHander{
public:
	void ~ThreadMessageHander();
	void sendThreadMessage(ThreadDelegateProtocol	*,ThreadMessage	*);
	void sendThreadMessage(ThreadDelegateProtocol	*, ThreadMessage *);
	void ThreadMessageHander(void);
	void unregistDelegate(ThreadDelegateProtocol *);
	void update(float);
	void registDelegate(ThreadDelegateProtocol *);
}
#endif