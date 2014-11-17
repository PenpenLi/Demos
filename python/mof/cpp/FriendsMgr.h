#ifndef MOF_FRIENDSMGR_H
#define MOF_FRIENDSMGR_H

class FriendsMgr{
public:
	void deleteAckFriend(int);
	void notifyAgreeFriend(bool,obj_friendRoleinfo);
	void ackAddFriend(int,	int);
	void notifyDeleteFriend(int);
	void reqDeleteFriend(int);
	void refreshFriendIntimacy(int, int);
	void changeRoleStateCity(int,int);
	void reqAgreeFriend(bool,int);
	void unLockDeleteSomeOne(int);
	void lockDeleteSomeOne(int);
	void getFriendsList(void);
	void ackAgreeFriend(int, bool,	obj_friendRoleinfo);
	void ackDeleteFriend(int,int);
	void lockAgreeSomeOne(int);
	void deleteFriendInList(int);
	void ackDeleteFriend(int, int);
	void reqAddFriend(int);
	void ~FriendsMgr();
	void unLockAgreeSomeOne(int);
	void ackAddFriend(int,int);
	void notifyAddFrined(obj_friendRoleinfo);
	void uiGetFriendList(void);
	void lockAddSomeOne(int);
	void getAckFriend(int);
	void uiGetAckFriendList(void);
	void notifyFriendOnLine(int,bool);
	void refreshFriendIntimacy(int,int);
	void reqAgreeFriend(bool, int);
	void ackAgreeFriend(int,bool,obj_friendRoleinfo);
	void isMyFriend(int);
	void notifyAgreeFriend(bool, obj_friendRoleinfo);
	void ackGetFriendList(std::vector<obj_friendRoleinfo,std::allocator<obj_friendRoleinfo>>);
	void changeRoleStateCity(int, int);
	void notifyFriendOnLine(int, bool);
	void unLockAddSomeOne(int);
	void getFrinedInfo(int);
}
#endif