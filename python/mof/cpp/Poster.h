#ifndef MOF_POSTER_H
#define MOF_POSTER_H

class Poster{
public:
	void send(int,int,cocos2d::CCPoint);
	void removeListener(Listener *);
	void send(int, int, cocos2d::CCPoint);
	void addListener(Listener *);
	void send(int,void	*);
	void setOnlySingleListener(Listener *);
	void getOnlySingleListener(void);
	void send(int, void *);
	void ~Poster();
}
#endif