#ifndef MOF_MINIDUMPFILEWRITER_H
#define MOF_MINIDUMPFILEWRITER_H

class MinidumpFileWriter{
public:
	void WriteString(char	const*,uint,MDLocationDescriptor *);
	void CopyStringToMDString(char const*,uint,google_breakpad::TypedMDRVA<MDString> *);
	void Close(void);
	void MinidumpFileWriter(void);
	void Allocate(unsigned long);
	void Allocate(ulong);
	void CopyStringToMDString(char const*, unsigned int, google_breakpad::TypedMDRVA<MDString> *);
	void Copy(unsigned int, void const*, long);
	void Copy(uint,void const*,long);
	void Open(char const*);
	void WriteStringCore<char>(char const*,uint,MDLocationDescriptor *);
	void WriteStringCore<char>(char const*,uint,MDLocationDescriptor *). PRESS KEYPAD	CTRL-"+" TO EXPAND];
	void WriteString(char	const*,	unsigned int, MDLocationDescriptor *);
	void ~MinidumpFileWriter();
	void WriteStringCore<char>(char const*, unsigned	int, MDLocationDescriptor *);
}
#endif