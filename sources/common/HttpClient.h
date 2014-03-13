/*!
 * @file HttpClient.h
 * @brief http client, using libcurl
 * @author lxb
 * @version 1.0
 * @date 2014-03-13
 */
#ifndef XL_HTTPCLIENT_H
#define XL_HTTPCLIENT_H
#include <string>
#include <map>
#include <boost/noncopyable.hpp>
#include <boost/enable_shared_from_this.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/function.hpp>

namespace XL {


class CHttpClient: private boost::noncopyable, public boost::enable_shared_from_this<CHttpClient> {
public:
	typedef std::map<std::string, std::string> HeadersMap;
	typedef std::map<std::string, std::string> CookiesMap;
	typedef boost::shared_ptr<CHttpClient> HttpClientPtr;
	typedef boost::function<void(HttpClientPtr)> Callback;	//void (*Callback)(HttpClientPtr)

	static HttpClientPtr Create(const std::string& baseUrl, bool bDebug = false) {
		HttpClientPtr client = HttpClientPtr(new CHttpClient(baseUrl));
		if (bDebug) {
			client->EnableDebug();
		}
		return client;
//		return client->shared_from_this();
	}

	/*!
	 * @brief
	 */
	CHttpClient();

	/*!
	 * @brief
	 */
	explicit CHttpClient(const std::string& baseUrl);

	~CHttpClient();

	void AddHeader(const std::string& key, const std::string& value);

	/*!
	 * TODO headers and cookies
	 * @brief GET
	 * @param |urlPath|, 拼接到baseUrl后面
	 * @return 成功返回true，失败返回false
	 */
	bool SyncGet(const std::string& urlPath = "", const HeadersMap& headers = HeadersMap(), const CookiesMap& cookies =
			CookiesMap());

	/*!
	 * @brief POST
	 * @param |urlPath|, 拼接到baseUrl后面
	 * @param |postFields|，p1=v1&p2=v2...
	 * @return 成功返回true，失败返回false
	 */
	bool SyncPost(const std::string& urlPath, const std::string& postFields);

	/*!
	 * TODO
	 * @brief GET
	 * @param |urlPath|, 拼接到baseUrl后面
	 * @param |callback|，回调
	 * @return 成功返回true，失败返回false
	 */
	bool AyncGet(const std::string& urlPath, Callback callback);

	/*!
	 * TODO
	 * @brief POST
	 * @param |urlPath|, 拼接到baseUrl后面
	 * @param |postData|，p1=v1&p2=v2...
	 * @param |callback|，回调
	 * @return 成功返回true，失败返回false
	 */
	bool AyncPost(const std::string& urlPath, const std::string& postData, Callback callback);

	int GetErrorCode() {
		return m_iErrorCode;
	}

	const std::string& GetErrorMessage() {
		return m_strErrorMessage;
	}

	const std::string& GetResponseString() {
		return m_strResponse;
	}

	void EnableDebug();
private:
	HeadersMap m_mapHeaders;			//headers
	CookiesMap m_mapCookies;			//cookies
	std::string m_strResponse;		//reponse
	std::string m_strErrorMessage;	//error message
	int m_iErrorCode;					//error code
	void* m_pCUrl;					//curl handle
	std::string m_strBaseUrl;		//base url
	static CHttpClient* m_pSelf;	//this pointer for static function

	// reset
	void ReSet();

	// curl write function
	static size_t WriteFunc(void *buffer, size_t size, size_t nitems, void *user);
};

}  // namespace XL

#endif
