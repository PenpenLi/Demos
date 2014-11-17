#ifndef MOF_CCFILEUTILS_H
#define MOF_CCFILEUTILS_H

class CCFileUtils{
public:
	void fullPathForFilename(char const*);
	void getPathForFilename(std::string const&, std::string const&, std::string const&);
	void getFileData(char const*, char const*, unsigned long *);
	void setSearchPaths(std::vector<std::string,std::allocator<std::string>> const&);
	void getClassTypeInfo(void)::id;
	void getSearchPaths(void);
	void getFileData(char const*,char const*,ulong *);
	void fullPathFromRelativeFile(char const*, char const*);
	void purgeCachedEntries(void);
	void purgeFileUtils(void);
	void fullPathFromRelativeFile(char const*,char const*);
	void setSearchPaths(std::vector<std::string,	std::allocator<std::string>> const&);
	void getClassTypeInfo(void);
	void getNewFilename(char const*);
	void getPathForFilename(std::string const&,std::string const&,std::string const&);
	void init(void);
	void sharedFileUtils(void);
	void getWriteablePath(void);
}
#endif