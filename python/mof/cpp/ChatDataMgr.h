#ifndef MOF_CHATDATAMGR_H
#define MOF_CHATDATAMGR_H

class ChatDataMgr{
public:
	void getChatDatasByType(chatChannel);
	void getChatContentByType(chatChannel,int);
	void addChatByType(chatChannel, chatingContent, bool);
	void addChatByType(chatChannel,chatingContent,bool);
	void deleteChatData(std::vector<chatingContent, std::allocator<chatingContent>> &, int);
	void getChatContentByType(chatChannel, int);
	void ChatDataMgr(void);
	void deleteChatData(std::vector<chatingContent,std::allocator<chatingContent>> &,int);
}
#endif