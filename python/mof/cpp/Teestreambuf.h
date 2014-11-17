#ifndef MOF_TEESTREAMBUF_H
#define MOF_TEESTREAMBUF_H

class Teestreambuf{
public:
	void sync(void);
	void ~Teestreambuf();
	void underflow(void);
	void overflow(int);
}
#endif