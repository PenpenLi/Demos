#ifndef MOF_AUDIOMANAGER_H
#define MOF_AUDIOMANAGER_H

class AudioManager{
public:
	void stopEffect(unsigned int);
	void playSoundEffect(std::string,bool);
	void stopEffect(uint);
	void stopSoundEffect(unsigned int);
	void stopBackgroundMusic(void);
	void stopSoundEffect(uint);
	void playAudio(int);
	void playBackgroundMusic(std::string);
	void preloadAudio(void);
	void playSoundEffect(std::string, bool);
}
#endif