#ifndef MOF_SIMPLEAUDIOENGINE_H
#define MOF_SIMPLEAUDIOENGINE_H

class SimpleAudioEngine{
public:
	void playEffect(char const*, bool);
	void end(void);
	void sharedEngine(void);
	void playBackgroundMusic(char const*, bool);
	void pauseBackgroundMusic(void);
	void isBackgroundMusicPlaying(void);
	void resumeBackgroundMusic(void);
	void stopBackgroundMusic(bool);
	void playBackgroundMusic(char const*,bool);
	void setBackgroundMusicVolume(float);
	void playEffect(char const*,bool);
	void preloadBackgroundMusic(char	const*);
	void stopEffect(unsigned	int);
	void setEffectsVolume(float);
	void getClassTypeInfo(void);
	void stopEffect(uint);
	void preloadEffect(char const*);
}
#endif