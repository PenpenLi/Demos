#ifndef MOF_RC5_ENCRYPT_STREAM_H
#define MOF_RC5_ENCRYPT_STREAM_H

class RC5_Encrypt_Stream{
public:
	void RC5_Encrypt(void *,ulong);
	void RC5_Encrypt(void *, unsigned long);
	void RC5_SetPWD(char const*);
	void rc5_setup(unsigned char const*, int, int,	Rc5_key	*);
	void rc5_ecb_encrypt(unsigned char const*, unsigned char *, Rc5_key *);
	void rc5_setup(uchar const*,int,int,Rc5_key *);
	void rc5_ecb_encrypt(uchar const*,uchar *,Rc5_key *);
}
#endif