#ifndef MOF_MD5_H
#define MOF_MD5_H

class MD5{
public:
	void MD5(std::string const&);
	void transform(unsigned char const*);
	void hexdigest(void);
	void finalize(void);
	void update(char const*,uint);
	void hexdigest(void)const;
	void encode(uchar *,uint const*,uint);
	void transform(uchar const*);
	void MD5(void);
	void update(uchar const*,uint);
	void update(unsigned char const*, unsigned int);
	void finalize(void)::padding;
	void decode(unsigned int *, unsigned char const*, unsigned int);
	void update(char const*, unsigned int);
	void encode(unsigned char *, unsigned	int const*, unsigned int);
	void decode(uint *,uchar const*,uint);
}
#endif