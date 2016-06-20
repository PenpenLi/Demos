module("battlingShow",package.seeall)
local logics = {
id_1 = {round_1_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={322},weight=99}}}}},
round_1_9={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={323},weight=99}}},{type=9,weight=999,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1013,des="",data={1,"cut_ice"},weight=99}}},{type=3,weight=999,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1018,des="",data={73},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1012,des="",data={"bgfighthuangdaobing0.jpg"},weight=99}}}}}}}}},
round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={327},weight=99}}},{type=9,weight=999,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1013,des="",data={1,"meffect_44"},weight=99}}},{type=9,weight=999,des="NODE",children={{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1018,des="",data={65},weight=99}}},{type=3,weight=998,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1013,des="",data={1,"meffect_fire"},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1012,des="",data={"bgfighthuangdaohuo0.jpg"},weight=99}}}}}}}}}}}}
,
id_2 = {round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={332},weight=99}}}}}}
,
id_490005 = {round_0_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={517},weight=99}}}}}}
,
id_490006 = {round_0_0={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={521},weight=99}}}}}}
,
id_490007 = {round_1_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={527},weight=99}}}}}}
,
id_490015 = {round_2_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={504},weight=99}}}}}}
,
id_490022 = {round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1006,des="",data={361},weight=99}}}}},
round_4_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={362},weight=99}}}}}}
,
id_490024 = {round_2_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={373},weight=99}}}}}}
,
id_490026 = {round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={379},weight=99}}}}},
round_4_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={380},weight=99}}}}}}
,
id_490027 = {round_2_7={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={389},weight=99}}}}},
round_4_7={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={390},weight=99}}}}}}
,
id_490028 = {round_2_7={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={395},weight=99}}}}}}
,
id_490030 = {round_3_7={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={404},weight=99}}}}}}
,
id_490032 = {round_2_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={415},weight=99}}}}}}
,
id_490034 = {round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={426},weight=99}}}}}}
,
id_490037 = {round_2_10={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={446},weight=99}}}}}}
,
id_490040 = {round_1_7={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={627},weight=99}}}}}}
,
id_490043 = {round_2_1={type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={701},weight=99}}}}}}

               } --logic data complete
function hasArmyLogic(id)

         local id_data = logics["id_" .. id]
         if id_data == nil then
           return false
         end
         return true
end
function indexLogicByArmyID(id)

         local id_data = logics["id_" .. id]
         if id_data == nil then
           id_data = indexLogicByArmyID(0)
         end
         return id_data
end