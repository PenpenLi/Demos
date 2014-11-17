#ifndef MOF_CONFIGFILE_H
#define MOF_CONFIGFILE_H

class ConfigFile{
public:
	void AppendCrashTimeParameters(char const*);
	void WriteFile(char const*,google_breakpad::NonAllocatingMap<256ul,256ul,64ul> const*,char const*,char const*);
	void WriteFile(char const*, google_breakpad::NonAllocatingMap<256ul, 256ul, 64ul> const*, char const*, char const*);
	void AppendConfigData(char const*,void const*,ulong);
}
#endif