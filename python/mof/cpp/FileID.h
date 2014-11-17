#ifndef MOF_FILEID_H
#define MOF_FILEID_H

class FileID{
public:
	void MachoIdentifier(int,int,uchar *);
	void MachoIdentifier(int,	int, unsigned char *);
	void FileID(char const*);
}
#endif