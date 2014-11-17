#ifndef MOF_INIFILE_H
#define MOF_INIFILE_H

class IniFile{
public:
	void getValueT<double>(std::string	const&,	std::string const&, double const&)const;
	void getTableT<double>(std::string const&,std::string const&,double const&);
	void exists(std::string const&, std::string const&)const;
	void exists(std::string const&,std::string const&);
	void IniFile(std::string const&);
	void getValueT<int>(std::string const&, std::string const&, int const&)const;
	void getTable(std::string	const&,	std::string const&)const;
	void getValueT<int>(std::string const&,std::string const&,int const&);
	void getValueT<float>(std::string	const&,std::string const&,float	const&);
	void getValue(std::string	const&,std::string const&,std::string const&);
	void getTableT<int>(std::string const&,std::string const&,int const&);
	void getValueT<double>(std::string const&,std::string const&,double const&);
	void getTableT<double>(std::string const&, std::string const&, double	const&)const;
	void getValueT<bool>(std::string const&, std::string	const&,	bool const&)const;
	void getValueT<bool>(std::string const&,std::string const&,bool const&);
	void getTable(std::string	const&,std::string const&);
}
#endif