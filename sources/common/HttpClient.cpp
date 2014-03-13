/*!
 * @file HttpClient.cpp
 * @brief http client
 * @author lxb
 * @version 1.0
 * @date 2014-03-13
 */
#include "HttpClient.h"
#include <curl/curl.h>

#define LOG_TAG "CHttpClient"
#include "XLLogger.h"

namespace XL {

CHttpClient* CHttpClient::m_pSelf = NULL;

/*!
 * @brief
 */
CHttpClient::CHttpClient() :
		m_iErrorCode(CURLE_OK), m_pCUrl(curl_easy_init()) {
	LOGT("CHttpClient()");
	m_pSelf = this;
}

/*!
 * @brief
 */
CHttpClient::CHttpClient(const std::string& baseUrl) :
		m_iErrorCode(CURLE_OK), m_pCUrl(curl_easy_init()), m_strBaseUrl(baseUrl) {
	LOGT("CHttpClient()");
	m_pSelf = this;
}

CHttpClient::~CHttpClient() {
	LOGT("~CHttpClient()");
	m_pSelf = NULL;
	if (m_pCUrl) {
		curl_easy_cleanup(m_pCUrl);
		m_pCUrl = NULL;
	}
}

void CHttpClient::AddHeader(const std::string& key, const std::string& value) {

}

/*!
 * @brief GET
 * @param |urlPath|, 拼接到baseUrl后面
 * @return 成功返回true，失败返回false
 */
bool CHttpClient::SyncGet(const std::string& urlPath, const HeadersMap& headers, const CookiesMap& cookies) {
	// todo headers and cookies
	if (!m_pCUrl) {
		m_iErrorCode = -1;
		m_strErrorMessage = "curl init error!";
		return false;
	}
	ReSet();
	std::string strUrl = m_strBaseUrl.append(urlPath);
	LOGT("url: " << strUrl);
	CURLcode code = curl_easy_setopt(m_pCUrl, CURLOPT_URL, strUrl.c_str());
	if (CURLE_OK != code) {
		m_iErrorCode = code;
		m_strErrorMessage = "curl set url error!";
		return false;
	}

	LOGT("curl set write function ...");
	code = curl_easy_setopt(m_pCUrl, CURLOPT_WRITEFUNCTION, &CHttpClient::WriteFunc);
	if (CURLE_OK != code) {
		m_iErrorCode = code;
		m_strErrorMessage = "curl set write function error!";
		return false;
	}

	LOGT("curl perform ...");
	code = curl_easy_perform(m_pCUrl);
	if (CURLE_OK != code) {
		LOGT("curl_easy_perform error, code=" << code);
		m_iErrorCode = code;
		m_strErrorMessage = curl_easy_strerror(code);
		return false;
	}
	m_iErrorCode = code;
	m_strErrorMessage = curl_easy_strerror(code);
	return true;
}

/*!
 * @brief POST
 * @param |urlPath|, 拼接到baseUrl后面
 * @param |postData|，p1=v1&p2=v2...
 * @return 成功返回true，失败返回false
 */
bool CHttpClient::SyncPost(const std::string& urlPath, const std::string& postFields) {
	if (!m_pCUrl) {
		m_iErrorCode = -1;
		m_strErrorMessage = "curl init error!";
		return false;
	}
	ReSet();
	std::string strUrl = m_strBaseUrl.append(urlPath);
	LOGT("url: " << strUrl);
	CURLcode code = curl_easy_setopt(m_pCUrl, CURLOPT_URL, strUrl.c_str());
	if (CURLE_OK != code) {
		m_iErrorCode = code;
		m_strErrorMessage = "curl set url error!";
		return false;
	}

	LOGT("curl set write function ...");
	code = curl_easy_setopt(m_pCUrl, CURLOPT_WRITEFUNCTION, &CHttpClient::WriteFunc);
	if (CURLE_OK != code) {
		m_iErrorCode = code;
		m_strErrorMessage = "curl set write function error!";
		return false;
	}

	LOGT("curl set post fields ...");
	curl_easy_setopt(m_pCUrl, CURLOPT_POST, 1);
	code = curl_easy_setopt(m_pCUrl, CURLOPT_POSTFIELDS, postFields.c_str());
	if (CURLE_OK != code) {
		m_iErrorCode = code;
		m_strErrorMessage = "curl set write function error!";
		return false;
	}

	LOGT("curl perform ...");
	code = curl_easy_perform(m_pCUrl);
	if (CURLE_OK != code) {
		LOGT("curl_easy_perform error, code=" << code);
		m_iErrorCode = code;
		m_strErrorMessage = curl_easy_strerror(code);
		return false;
	}
	m_iErrorCode = code;
	m_strErrorMessage = curl_easy_strerror(code);
	return true;
}

/*!
 * @brief GET
 * @param |urlPath|, 拼接到baseUrl后面
 * @return 成功返回true，失败返回false
 */
bool CHttpClient::AyncGet(const std::string& urlPath, Callback callback) {
	return false;
}

/*!
 * @brief POST
 * @param |urlPath|, 拼接到baseUrl后面
 * @param |postData|，p1=v1&p2=v2...
 * @return 成功返回true，失败返回false
 */
bool CHttpClient::AyncPost(const std::string& urlPath, const std::string& postData, Callback callback) {
	return false;
}

void CHttpClient::EnableDebug() {
	if (m_pCUrl) {
		curl_easy_setopt(m_pCUrl, CURLOPT_VERBOSE, 1);
	}
}

void CHttpClient::ReSet() {
	curl_easy_reset(m_pCUrl);
	m_iErrorCode = CURLE_OK;
	m_strErrorMessage.clear();
	m_strResponse.clear();
	// 使用cookies
	curl_easy_setopt(m_pCUrl, CURLOPT_COOKIEFILE, "cookies");
	// 处理location
	curl_easy_setopt(m_pCUrl, CURLOPT_FOLLOWLOCATION, 1);
	// 处理redirection
	curl_easy_setopt(m_pCUrl, CURLOPT_POSTREDIR, CURL_REDIR_POST_ALL);
}

size_t CHttpClient::WriteFunc(void *buffer, size_t size, size_t nitems, void *user) {
	size_t retSize = size * nitems;
	LOGT("Write size: " << retSize);
	m_pSelf->m_strResponse.append((char *) buffer, retSize);
	return retSize;
}

}  // namespace XL
