#ifndef MOF_PLATFORMNOTICEDELEGATE_H
#define MOF_PLATFORMNOTICEDELEGATE_H

class PlatformNoticeDelegate{
public:
	void recieveThreadMessage(ThreadMessage *);
	void setPlatformNotice(PlatformNotice);
	void ~PlatformNoticeDelegate();
}
#endif