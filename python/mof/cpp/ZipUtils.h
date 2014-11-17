#ifndef MOF_ZIPUTILS_H
#define MOF_ZIPUTILS_H

class ZipUtils{
public:
	void ccInflateMemoryWithHint(unsigned char *, unsigned int, unsigned char **, unsigned int);
	void ccInflateMemoryWithHint(uchar *,uint,uchar	**,uint);
	void ccInflateGZipFile(char const*, unsigned char **);
	void ccInflateCCZFile(char const*, unsigned char **);
	void ccInflateMemoryWithHint(uchar *,uint,uchar	**,uint	*,uint);
	void ccInflateGZipFile(char const*,uchar **);
	void ccInflateCCZFile(char const*,uchar	**);
}
#endif