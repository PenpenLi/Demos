#ifndef MOF_FUSIONKEYCMP_H
#define MOF_FUSIONKEYCMP_H

class FusionKeyCmp{
public:
	void operator(EquipFusionCfg::FusionKey const&,EquipFusionCfg::FusionKey const&);
}
#endif