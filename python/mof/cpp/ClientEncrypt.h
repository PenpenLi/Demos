#ifndef MOF_CLIENTENCRYPT_H
#define MOF_CLIENTENCRYPT_H

class ClientEncrypt{
public:
	void Connect(char const*);
	void SendEncrypt(void *, unsigned short);
	void SendEncrypt(void *,ushort);
}
#endif