#ifndef MOF_READER_H
#define MOF_READER_H

class Reader{
public:
	void decodeString(Json::Reader::Token &, std::string	&);
	void readObject(Json::Reader::Token &);
	void readCStyleComment(void);
	void decodeUnicodeCodePoint(Json::Reader::Token &, char const*&, char const*, unsigned int &);
	void recoverFromError(Json::Reader::TokenType);
	void ErrorInfo>(std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, Json::Reader::ErrorInfo const&, std::__false_type);
	void Reader(void);
	void decodeString(Json::Reader::Token &);
	void parse(std::string const&, Json::Value &, bool);
	void readValue(void);
	void readToken(Json::Reader::Token &);
	void addComment(char	const*,	char const*, Json::CommentPlacement);
	void addError(std::string const&,Json::Reader::Token	&,char const*);
	void ErrorInfo>(std::_Deque_iterator<Json::Reader::ErrorInfo,	Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*> const&, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*> const&, Json::Reader::ErrorInfo const&);
	void decodeUnicodeEscapeSequence(Json::Reader::Token	&,char const*&,char const*,uint	&);
	void ErrorInfo*>>(false, false,	std::random_access_iterator_tag);
	void decodeString(Json::Reader::Token &,std::string &);
	void parse(char const*, char	const*,	Json::Value &, bool);
	void ErrorInfo*>>(false, false, std::random_access_iterator_tag);
	void parse(char const*,char const*,Json::Value &,bool);
	void decodeNumber(Json::Reader::Token &);
	void skipCommentTokens(Json::Reader::Token &);
	void ErrorInfo>(std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*> const&,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*> const&,Json::Reader::ErrorInfo const&);
	void ErrorInfo>(std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,Json::Reader::ErrorInfo const&,std::__false_type);
	void ErrorInfo*>>(std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&,	Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::__false_type);
	void addError(std::string const&, Json::Reader::Token &, char const*);
	void decodeUnicodeCodePoint(Json::Reader::Token &,char const*&,char const*,uint &);
	void ErrorInfo>>(std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,Json::Reader::ErrorInfo const&,std::allocator<Json::Reader::ErrorInfo>);
	void readArray(Json::Reader::Token &);
	void match(char const*, int);
	void ErrorInfo>>(std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, Json::Reader::ErrorInfo const&, std::allocator<Json::Reader::ErrorInfo>);
	void match(char const*,int);
	void ErrorInfo*>>(std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::__false_type);
	void decodeDouble(Json::Reader::Token &);
	void decodeUnicodeEscapeSequence(Json::Reader::Token	&, char	const*&, char const*, unsigned int &);
	void addComment(char	const*,char const*,Json::CommentPlacement);
	void ErrorInfo*>>(false,false,std::random_access_iterator_tag);
	void readComment(void);
	void ErrorInfo>>(std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,Json::Reader::ErrorInfo const&,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::_Deque_iterator<Json::Reader::ErrorInfo,Json::Reader::ErrorInfo&,Json::Reader::ErrorInfo*>,std::allocator<Json::Reader::ErrorInfo>);
	void ErrorInfo>>(std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, Json::Reader::ErrorInfo const&, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::_Deque_iterator<Json::Reader::ErrorInfo, Json::Reader::ErrorInfo&, Json::Reader::ErrorInfo*>, std::allocator<Json::Reader::ErrorInfo>);
	void parse(std::string const&,Json::Value &,bool);
}
#endif