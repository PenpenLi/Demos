#ifndef MOF_SYNARENAMGR_H
#define MOF_SYNARENAMGR_H

class SynArenaMgr{
public:
	void keepPvpResultData(notify_realpvp_fighting_result	const&);
	void onMenuItemSurePk(cocos2d::CCObject *);
	void reqLastCancel(void);
	void reqStartMatch(void);
	void keepDuelResultData(notify_duel_result const&);
	void notifyInviteResult(notify_duel_invite_respond const&);
	void ackMakeDealResult(int,int,int);
	void ackMatchResult(ack_bereadyto_realpvp_matching const&);
	void reqExchangeShopData(void);
	void reqCancelMatch(void);
	void reqSureToPk(void);
	void notifyBeInvitedPk(notify_duel_invite_notice const&);
	void delDuleApplyById(int);
	void notifyMatchResult(notify_realpvp_matching_info const&);
	void notifyAllRdy(notify_duel_be_ready const&);
	void reqCancelToPk(void);
	void ackInviteResult(ack_duel_invite_respond const&);
	void onMenuItemCancelWait(cocos2d::CCObject *);
	void ackMatchResultFail(notify_realpvp_matching_fail const&);
	void ackExchangeShopData(ack_realpvp_exchange_itemlist const&);
	void ~SynArenaMgr();
	void notifyMakeduelResult(int);
	void reqSureMedalExchange(int);
	void ackMakeDealResult(int, int, int);
	void ackBeInvitePk(ack_duel_invite const&);
	void reqInvitePk(int);
	void onMenuItemCancelPk(cocos2d::CCObject *);
	void showPkWaitDialog(void);
	void ackCancelMatch(void);
	void showPvpResult(void);
	void ackMainRolePanelData(ack_get_realpvp_data const&);
	void ackLastCancel(ack_duel_invite_cancel const&);
	void reqMainRolePanelData(void);
	void isStillApply(void);
	void ackMedalExchangeResult(ack_realpvp_medal_exchange const&);
	void showPkMakeSureDialog(void);
	void SynArenaMgr(void);
	void addNewDuleApply(_DuleApplyData);
	void notifyCancelPK(notify_duel_invite_cancel	const&);
	void delFirstDuleApply(void);
	void getSynArenaShopData(void);
}
#endif