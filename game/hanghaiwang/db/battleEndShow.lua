module("battleEndShow",package.seeall)
local logics = {
id_1003 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={303},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1017,des="",data={1,"meffect_16"},weight=99}}},{type=8,weight=998,des="装饰节点",children={{type=2,actionType=1006,des="",data={304},weight=99}}},{type=8,weight=997,des="装饰节点",children={{type=2,actionType=1017,des="",data={7,"meffect_16"},weight=99}}},{type=8,weight=996,des="装饰节点",children={{type=2,actionType=1006,des="",data={305},weight=99}}}}},
id_1 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={328},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1017,des="",data={0,2,3,4,5,"meffect_16"},weight=99}}},{type=8,weight=998,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4607"},weight=99}}},{type=8,weight=997,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4608"},weight=99}}},{type=8,weight=996,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4609"},weight=99}}}}},
id_490004 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={513},weight=99}}}}},
id_490005 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={518},weight=99}}}}},
id_490006 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={522},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1017,des="",data={1,10,"meffect_16"},weight=99}}},{type=8,weight=998,des="装饰节点",children={{type=2,actionType=1006,des="",data={523},weight=99}}}}},
id_490007 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={528},weight=99}}}}},
id_490010 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={500},weight=99}}}}},
id_490020 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={349},weight=99}}}}},
id_490022 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={363},weight=99}}}}},
id_490024 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={374},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1015,des="",data={1},weight=99}}}}},
id_490026 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={381},weight=99}}}}},
id_490027 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={391},weight=99}}}}},
id_490028 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={396},weight=99}}}}},
id_490032 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={416},weight=99}}}}},
id_490033 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={424},weight=99}}}}},
id_490034 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={427},weight=99}}}}},
id_490037 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={447},weight=99}}}}},
id_490039 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1015,des="",data={1,2},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1006,des="",data={533},weight=99}}}}},
id_490040 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={628},weight=99}}}}},
id_490017 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={338},weight=99}}}}},
id_490043 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1006,des="",data={702},weight=99}}}}},
id_2 = {type=3,weight=1000,des="NODE",children={{type=8,weight=1000,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4610"},weight=99}}},{type=8,weight=999,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4611"},weight=99}}},{type=8,weight=998,des="装饰节点",children={{type=2,actionType=1026,des="",data={"4612"},weight=99}}}}}
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