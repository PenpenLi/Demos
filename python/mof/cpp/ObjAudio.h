#ifndef MOF_OBJAUDIO_H
#define MOF_OBJAUDIO_H

class ObjAudio{
public:
	void getHittedAudioID(void);
	void playKOScream(void);
	void setObjAudios(std::vector<int, std::allocator<int>>,	std::vector<int, std::allocator<int>>, std::vector<int,	std::allocator<int>>, std::vector<int, std::allocator<int>>, int, int, int);
	void playAttack(int);
	void playDead(void);
	void stopWalk(void);
	void getHittedScreamAudioID(void);
	void playAttackScream(void);
	void ObjAudio(void);
	void playAttackHitted(void);
	void playHittedScream(void);
	void playWalk(void);
	void setObjAudios(std::vector<int,std::allocator<int>>,std::vector<int,std::allocator<int>>,std::vector<int,std::allocator<int>>,std::vector<int,std::allocator<int>>,int,int,int);
	void getAttackScreamAudioID(void);
}
#endif