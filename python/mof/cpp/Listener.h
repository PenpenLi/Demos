#ifndef MOF_LISTENER_H
#define MOF_LISTENER_H

class Listener{
public:
	void recv(int, int, cocos2d::CCPoint, int);
	void recv(void *);
	void recv(int, void *);
	void recv(int,int,char const*);
	void recv(int,int,cocos2d::CCPoint,int);
	void recv(int,void *);
}
#endif