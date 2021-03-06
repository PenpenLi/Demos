-- Filename: DB_Achie_table.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Achie_table", package.seeall)

keys = {
	"id", "parent_type", "child_type", "achie_name", "achie_des", "achie_icon", "achie_quality", "finish_arry", "achie_reward", "sort", "is_display", "is_show", 
}

Achie_table = {
	id_101001 = {101001, 1, 101, "哥特岛", "通关哥特岛普通副本", "day_task_1.png", 4, "1|1", "1|0|10000", 1001, 1, 1, },
	id_101002 = {101002, 1, 101, "谢尔兹镇", "通关谢尔兹镇普通副本", "day_task_1.png", 4, "2|1", "1|0|12000", 1001, 1, 1, },
	id_101003 = {101003, 1, 101, "橘子镇", "通关橘子镇普通副本", "day_task_1.png", 4, "3|1", "7|104212|1", 1001, 1, 1, },
	id_101004 = {101004, 1, 101, "糖汁村", "通关糖汁村普通副本", "day_task_1.png", 4, "4|1", "1|0|15000", 1001, 1, 1, },
	id_101005 = {101005, 1, 101, "海上餐厅", "通关海上餐厅普通副本", "day_task_1.png", 4, "5|1", "7|104212|1", 1001, 1, 1, },
	id_101006 = {101006, 1, 101, "阿龙公园", "通关阿龙公园普通副本", "day_task_1.png", 4, "6|1", "1|0|16000", 1001, 1, 1, },
	id_101007 = {101007, 1, 101, "巴格镇", "通关巴格镇普通副本", "day_task_1.png", 4, "7|1", "1|0|18000", 1001, 1, 1, },
	id_101008 = {101008, 1, 101, "李维斯山", "通关李维斯山普通副本", "day_task_1.png", 4, "8|1", "1|0|20000", 1001, 1, 1, },
	id_101009 = {101009, 1, 101, "威士忌山上", "通关威士忌山上普通副本", "day_task_1.png", 4, "9|1", "1|0|25000", 1001, 1, 1, },
	id_101010 = {101010, 1, 101, "威士忌山下", "通关威士忌山下普通副本", "day_task_1.png", 4, "10|1", "1|0|30000", 1001, 1, 1, },
	id_101011 = {101011, 1, 101, "小花园上", "通关小花园上普通副本", "day_task_1.png", 4, "11|1", "1|0|35000", 1001, 1, 1, },
	id_101012 = {101012, 1, 101, "小花园下", "通关小花园下普通副本", "day_task_1.png", 4, "12|1", "1|0|40000", 1001, 1, 1, },
	id_101013 = {101013, 1, 101, "铁桶岛", "通关铁桶岛普通副本", "day_task_1.png", 4, "13|1", "1|0|50000", 1001, 1, 1, },
	id_101014 = {101014, 1, 101, "拿哈那沙漠", "通关拿哈那沙漠普通副本", "day_task_1.png", 4, "14|1", "1|0|60000", 1001, 1, 1, },
	id_101015 = {101015, 1, 101, "阿拉巴斯坦上", "通关阿拉巴斯坦上普通副本", "day_task_1.png", 4, "15|1", "1|0|80000", 1001, 1, 1, },
	id_101016 = {101016, 1, 101, "阿拉巴斯坦下", "通关阿拉巴斯坦下普通副本", "day_task_1.png", 4, "16|1", "1|0|100000", 1001, 1, 1, },
	id_101017 = {101017, 1, 101, "加亚上", "通关加亚上普通副本", "day_task_1.png", 4, "17|1", "1|0|120000", 1001, 1, 1, },
	id_101018 = {101018, 1, 101, "加亚下", "通关加亚下普通副本", "day_task_1.png", 4, "18|1", "1|0|140000", 1001, 1, 1, },
	id_101019 = {101019, 1, 101, "天空圣地", "通关天空圣地普通副本", "day_task_1.png", 4, "19|1", "1|0|160000", 1001, 1, 1, },
	id_101020 = {101020, 1, 101, "黄金乡上", "通关黄金乡上普通副本", "day_task_1.png", 4, "20|1", "1|0|180000", 1001, 1, 1, },
	id_101021 = {101021, 1, 101, "黄金乡中", "通关黄金乡中普通副本", "day_task_1.png", 4, "21|1", "1|0|220000", 1001, 1, 1, },
	id_101022 = {101022, 1, 101, "黄金乡下", "通关黄金乡下普通副本", "day_task_1.png", 4, "22|1", "1|0|260000", 1001, 1, 1, },
	id_101023 = {101023, 1, 101, "长环岛上", "通关长环岛上普通副本", "day_task_1.png", 4, "23|1", "1|0|300000", 1001, 1, 1, },
	id_101024 = {101024, 1, 101, "长环岛下", "通关长环岛下普通副本", "day_task_1.png", 4, "24|1", "1|0|340000", 1001, 1, 1, },
	id_101025 = {101025, 1, 101, "七水之城上", "通关七水之城上普通副本", "day_task_1.png", 4, "25|1", "1|0|380000", 1001, 1, 1, },
	id_101026 = {101026, 1, 101, "七水之城中", "通关七水之城中普通副本", "day_task_1.png", 4, "26|1", "1|0|420000", 1001, 1, 1, },
	id_101027 = {101027, 1, 101, "七水之城下", "通关七水之城下普通副本", "day_task_1.png", 4, "27|1", "1|0|460000", 1001, 1, 1, },
	id_101028 = {101028, 1, 101, "海上列车", "通关海上列车普通副本", "day_task_1.png", 4, "28|1", "1|0|500000", 1001, 1, 1, },
	id_101029 = {101029, 1, 101, "司法岛上", "通关司法岛上普通副本", "day_task_1.png", 4, "29|1", "1|0|540000", 1001, 1, 1, },
	id_101030 = {101030, 1, 101, "司法岛下", "通关司法岛下普通副本", "day_task_1.png", 4, "30|1", "1|0|580000", 1001, 1, 1, },
	id_101031 = {101031, 1, 101, "司法塔上", "通关司法塔上普通副本", "day_task_1.png", 4, "31|1", "1|0|620000", 1001, 1, 1, },
	id_101032 = {101032, 1, 101, "司法塔中", "通关司法塔中普通副本", "day_task_1.png", 4, "32|1", "1|0|660000", 1001, 1, 1, },
	id_101033 = {101033, 1, 101, "司法塔下", "通关司法塔下普通副本", "day_task_1.png", 4, "33|1", "1|0|700000", 1001, 1, 1, },
	id_101034 = {101034, 1, 101, "踌躇之桥", "通关踌躇之桥普通副本", "day_task_1.png", 4, "34|1", "1|0|740000", 1001, 1, 1, },
	id_102001 = {102001, 1, 102, "数星星", "副本星数达到300", "day_task_2.png", 3, "300", "3|0|100", 1002, 1, 1, },
	id_102002 = {102002, 1, 102, "500星", "副本星数达到500", "day_task_2.png", 4, "500", "3|0|150", 1002, 1, 1, },
	id_102003 = {102003, 1, 102, "700星", "副本星数达到700", "day_task_2.png", 4, "700", "3|0|180", 1002, 1, 1, },
	id_102004 = {102004, 1, 102, "900星", "副本星数达到900", "day_task_2.png", 4, "900", "3|0|200", 1002, 1, 1, },
	id_102005 = {102005, 1, 102, "1200星", "副本星数达到1200", "day_task_2.png", 5, "1200", "3|0|300", 1002, 1, 1, },
	id_102006 = {102006, 1, 102, "1500星", "副本星数达到1500", "day_task_2.png", 5, "1500", "3|0|350", 1002, 1, 1, },
	id_102007 = {102007, 1, 102, "1800星", "副本星数达到1800", "day_task_2.png", 5, "1800", "3|0|400", 1002, 1, 1, },
	id_102008 = {102008, 1, 102, "星光璀璨", "副本星数达到2100", "day_task_2.png", 5, "2100", "3|0|500", 1002, 1, 1, },
	id_108001 = {108001, 1, 108, "竟然失败了！", "攻打普通副本失败10次", "day_task_1.png", 3, "10", "1|0|4000", 1008, 1, 1, },
	id_108002 = {108002, 1, 108, "再接再厉！", "攻打普通副本失败50次", "day_task_1.png", 3, "50", "1|0|8000", 1008, 1, 1, },
	id_108003 = {108003, 1, 108, "战斗失败100次", "攻打普通副本失败100次", "day_task_1.png", 3, "100", "1|0|10000", 1008, 1, 1, },
	id_108004 = {108004, 1, 108, "战斗失败200次", "攻打普通副本失败200次", "day_task_1.png", 3, "200", "1|0|20000", 1008, 1, 1, },
	id_108005 = {108005, 1, 108, "屡败屡战！", "攻打普通副本失败300次", "day_task_1.png", 3, "300", "1|0|25000", 1008, 1, 1, },
	id_108006 = {108006, 1, 108, "战斗失败400次", "攻打普通副本失败400次", "day_task_1.png", 3, "400", "1|0|30000", 1008, 1, 1, },
	id_108007 = {108007, 1, 108, "战斗失败500次", "攻打普通副本失败500次", "day_task_1.png", 3, "500", "1|0|35000", 1008, 1, 1, },
	id_108008 = {108008, 1, 108, "战斗失败700次", "攻打普通副本失败700次", "day_task_1.png", 3, "700", "1|0|40000", 1008, 1, 1, },
	id_108009 = {108009, 1, 108, "让我赢一次吧！", "攻打普通副本失败999次", "day_task_1.png", 3, "999", "1|0|45000", 1008, 1, 1, },
	id_201001 = {201001, 2, 201, "新手船长", "主角等级达到10", "day_task_2.png", 4, "10", "1|0|10000", 2001, 1, 1, },
	id_201002 = {201002, 2, 201, "主角等级:15", "主角等级达到15", "day_task_2.png", 4, "15", "1|0|20000", 2001, 1, 1, },
	id_201003 = {201003, 2, 201, "主角等级:20", "主角等级达到20", "day_task_2.png", 4, "20", "1|0|25000", 2001, 1, 1, },
	id_201004 = {201004, 2, 201, "主角等级:25", "主角等级达到25", "day_task_2.png", 5, "25", "1|0|50000", 2001, 1, 1, },
	id_201005 = {201005, 2, 201, "主角等级:30", "主角等级达到30", "day_task_2.png", 5, "30", "1|0|80000", 2001, 1, 1, },
	id_201006 = {201006, 2, 201, "主角等级:32", "主角等级达到32", "day_task_2.png", 5, "32", "1|0|120000", 2001, 1, 1, },
	id_201007 = {201007, 2, 201, "主角等级:35", "主角等级达到35", "day_task_2.png", 5, "35", "1|0|180000", 2001, 1, 1, },
	id_201008 = {201008, 2, 201, "主角等级:37", "主角等级达到37", "day_task_2.png", 5, "37", "1|0|250000", 2001, 1, 1, },
	id_201009 = {201009, 2, 201, "主角等级:40", "主角等级达到40", "day_task_2.png", 5, "40", "1|0|300000", 2001, 1, 1, },
	id_201010 = {201010, 2, 201, "主角等级:42", "主角等级达到42", "day_task_2.png", 5, "42", "1|0|320000", 2001, 1, 1, },
	id_201011 = {201011, 2, 201, "主角等级:45", "主角等级达到45", "day_task_2.png", 5, "45", "1|0|340000", 2001, 1, 1, },
	id_201012 = {201012, 2, 201, "主角等级:47", "主角等级达到47", "day_task_2.png", 5, "47", "1|0|360000", 2001, 1, 1, },
	id_201013 = {201013, 2, 201, "主角等级:50", "主角等级达到50", "day_task_2.png", 5, "50", "1|0|400000", 2001, 1, 1, },
	id_201014 = {201014, 2, 201, "主角等级:52", "主角等级达到52", "day_task_2.png", 5, "52", "1|0|450000", 2001, 1, 1, },
	id_201015 = {201015, 2, 201, "主角等级:55", "主角等级达到55", "day_task_2.png", 5, "55", "1|0|500000", 2001, 1, 1, },
	id_201016 = {201016, 2, 201, "主角等级:57", "主角等级达到57", "day_task_2.png", 5, "57", "1|0|550000", 2001, 1, 1, },
	id_201017 = {201017, 2, 201, "主角等级:60", "主角等级达到60", "day_task_2.png", 5, "60", "1|0|600000", 2001, 1, 1, },
	id_201018 = {201018, 2, 201, "主角等级:62", "主角等级达到62", "day_task_2.png", 5, "62", "1|0|650000", 2001, 1, 1, },
	id_201019 = {201019, 2, 201, "老资历", "主角等级达到65", "day_task_2.png", 5, "65", "1|0|700000", 2001, 1, 1, },
	id_202001 = {202001, 2, 202, "修心炼身", "修炼15次", "day_task_3.png", 3, "15", "3|0|30", 2002, 1, 1, },
	id_202002 = {202002, 2, 202, "修炼次数：20", "修炼20次", "day_task_3.png", 3, "20", "3|0|30", 2002, 1, 1, },
	id_202003 = {202003, 2, 202, "修炼次数：25", "修炼25次", "day_task_3.png", 3, "25", "3|0|30", 2002, 1, 1, },
	id_202004 = {202004, 2, 202, "修炼次数：30", "修炼30次", "day_task_3.png", 3, "30", "3|0|40", 2002, 1, 1, },
	id_202005 = {202005, 2, 202, "修炼次数：35", "修炼35次", "day_task_3.png", 3, "35", "3|0|50", 2002, 1, 1, },
	id_202006 = {202006, 2, 202, "修炼次数：40", "修炼40次", "day_task_3.png", 3, "40", "3|0|60", 2002, 1, 1, },
	id_202007 = {202007, 2, 202, "修炼狂人", "修炼50次", "day_task_3.png", 3, "50", "3|0|80", 2002, 1, 1, },
	id_202008 = {202008, 2, 202, "修炼次数:100", "修炼100次", "day_task_3.png", 4, "100", "3|0|100", 2002, 1, 1, },
	id_202009 = {202009, 2, 202, "修炼次数:120", "修炼120次", "day_task_3.png", 4, "120", "3|0|120", 2002, 1, 1, },
	id_202010 = {202010, 2, 202, "修炼次数:150", "修炼150次", "day_task_3.png", 4, "150", "3|0|150", 2002, 1, 1, },
	id_202011 = {202011, 2, 202, "修炼次数:180", "修炼180次", "day_task_3.png", 4, "180", "3|0|200", 2002, 1, 1, },
	id_202012 = {202012, 2, 202, "修炼次数:220", "修炼220次", "day_task_3.png", 5, "220", "3|0|240", 2002, 1, 1, },
	id_202013 = {202013, 2, 202, "修炼次数:250", "修炼250次", "day_task_3.png", 5, "250", "3|0|260", 2002, 1, 1, },
	id_202014 = {202014, 2, 202, "修炼宗师", "修炼300次", "day_task_3.png", 5, "300", "3|0|300", 2002, 1, 1, },
	id_203001 = {203001, 2, 203, "空岛贝：紫", "获得紫色品质空岛贝", "day_task_3.png", 5, "5", "7|72003|1", 2003, 0, 0, },
	id_205001 = {205001, 2, 205, "第一桶金", "拥有贝里1000000", "day_task_2.png", 3, "1000000", "7|30012|1", 2005, 1, 1, },
	id_205002 = {205002, 2, 205, "贝里：200W", "拥有贝里2000000", "day_task_2.png", 4, "2000000", "7|30012|1", 2005, 1, 1, },
	id_205003 = {205003, 2, 205, "贝里：500W", "拥有贝里5000000", "day_task_2.png", 4, "5000000", "7|30012|1", 2005, 1, 1, },
	id_205004 = {205004, 2, 205, "贝里：1000W", "拥有贝里10000000", "day_task_2.png", 4, "10000000", "7|30012|1", 2005, 1, 1, },
	id_205005 = {205005, 2, 205, "贝里：1500W", "拥有贝里15000000", "day_task_2.png", 5, "15000000", "7|30012|1", 2005, 1, 1, },
	id_205006 = {205006, 2, 205, "贝里：2000W", "拥有贝里20000000", "day_task_2.png", 5, "20000000", "7|30012|1", 2005, 1, 1, },
	id_205007 = {205007, 2, 205, "贝里山", "拥有贝里50000000", "day_task_2.png", 5, "50000000", "7|30013|1", 2005, 1, 1, },
	id_206001 = {206001, 2, 206, "小有名气", "拥有声望1000", "day_task_2.png", 3, "1000", "3|0|30", 2006, 1, 1, },
	id_206002 = {206002, 2, 206, "声望:5000", "拥有声望5000", "day_task_2.png", 4, "5000", "3|0|40", 2006, 1, 1, },
	id_206003 = {206003, 2, 206, "声望:1W", "拥有声望10000", "day_task_2.png", 4, "10000", "3|0|50", 2006, 1, 1, },
	id_206004 = {206004, 2, 206, "声望:2W", "拥有声望20000", "day_task_2.png", 5, "20000", "3|0|100", 2006, 1, 1, },
	id_206005 = {206005, 2, 206, "家喻户晓", "拥有声望50000", "day_task_2.png", 5, "50000", "3|0|200", 2006, 1, 1, },
	id_207001 = {207001, 2, 207, "海魂:1000", "拥有海魂1000", "day_task_2.png", 3, "1000", "7|500002|1", 2007, 1, 1, },
	id_207002 = {207002, 2, 207, "海魂:5000", "拥有海魂5000", "day_task_2.png", 3, "5000", "7|500002|1", 2007, 1, 1, },
	id_207003 = {207003, 2, 207, "海魂:10000", "拥有海魂10000", "day_task_2.png", 3, "10000", "7|500002|1", 2007, 1, 1, },
	id_207004 = {207004, 2, 207, "海魂:30000", "拥有海魂30000", "day_task_2.png", 4, "30000", "7|500002|2", 2007, 1, 1, },
	id_207005 = {207005, 2, 207, "海魂:50000", "拥有海魂50000", "day_task_2.png", 5, "50000", "7|500002|3", 2007, 1, 1, },
	id_207006 = {207006, 2, 207, "海魂:10W", "拥有海魂100000", "day_task_2.png", 5, "100000", "7|500002|3", 2007, 1, 1, },
	id_208001 = {208001, 2, 208, "呼朋唤友", "好友数量10", "day_task_2.png", 4, "10", "7|60006|1", 2008, 1, 1, },
	id_208002 = {208002, 2, 208, "好友：20", "好友数量20", "day_task_2.png", 4, "20", "7|60006|1", 2008, 1, 1, },
	id_208003 = {208003, 2, 208, "好友：40", "好友数量40", "day_task_2.png", 4, "40", "7|60006|2", 2008, 1, 1, },
	id_208004 = {208004, 2, 208, "好友：60", "好友数量60", "day_task_2.png", 4, "60", "7|60006|2", 2008, 1, 1, },
	id_208005 = {208005, 2, 208, "好友：80", "好友数量80", "day_task_2.png", 4, "80", "7|60006|2", 2008, 1, 1, },
	id_208006 = {208006, 2, 208, "知己遍天下", "好友数量100", "day_task_2.png", 4, "100", "7|10042|1", 2008, 1, 1, },
	id_210001 = {210001, 2, 210, "初试身手", "挑战竞技场10次", "day_task_1.png", 3, "10", "12|0|100", 2010, 1, 1, },
	id_210002 = {210002, 2, 210, "竞技30次", "挑战竞技场30次", "day_task_1.png", 3, "30", "12|0|100", 2010, 1, 1, },
	id_210003 = {210003, 2, 210, "竞技50次", "挑战竞技场50次", "day_task_1.png", 4, "50", "12|0|100", 2010, 1, 1, },
	id_210004 = {210004, 2, 210, "竞技100次", "挑战竞技场100次", "day_task_1.png", 4, "100", "12|0|200", 2010, 1, 1, },
	id_210005 = {210005, 2, 210, "竞技200次", "挑战竞技场200次", "day_task_1.png", 5, "200", "12|0|200", 2010, 1, 1, },
	id_210006 = {210006, 2, 210, "好战人士", "挑战竞技场500次", "day_task_1.png", 5, "500", "12|0|200", 2010, 1, 1, },
	id_214001 = {214001, 2, 214, "击杀海王类", "在激战海王类中击杀海王类", "day_task_3.png", 5, "1", "12|0|300", 2014, 0, 0, },
	id_217001 = {217001, 2, 217, "崭露头角", "战斗力达到100000", "day_task_2.png", 3, "100000", "3|0|50", 2017, 1, 1, },
	id_217002 = {217002, 2, 217, "战斗力：30W", "战斗力达到300000", "day_task_2.png", 3, "300000", "3|0|80", 2017, 1, 1, },
	id_217003 = {217003, 2, 217, "战斗力：50W", "战斗力达到500000", "day_task_2.png", 3, "500000", "3|0|120", 2017, 1, 1, },
	id_217004 = {217004, 2, 217, "战斗力：80W", "战斗力达到800000", "day_task_2.png", 4, "800000", "3|0|150", 2017, 1, 1, },
	id_217005 = {217005, 2, 217, "战斗力：120W", "战斗力达到1200000", "day_task_2.png", 4, "1200000", "3|0|300", 2017, 1, 1, },
	id_217006 = {217006, 2, 217, "战斗力：160W", "战斗力达到1600000", "day_task_2.png", 4, "1600000", "3|0|400", 2017, 1, 1, },
	id_217007 = {217007, 2, 217, "战斗力：200W", "战斗力达到2000000", "day_task_2.png", 5, "2000000", "3|0|500", 2017, 1, 1, },
	id_217008 = {217008, 2, 217, "战斗力：250W", "战斗力达到2500000", "day_task_2.png", 5, "2500000", "3|0|500", 2017, 1, 1, },
	id_217009 = {217009, 2, 217, "战斗力：300W", "战斗力达到3000000", "day_task_2.png", 5, "3000000", "3|0|600", 2017, 1, 1, },
	id_217010 = {217010, 2, 217, "战斗力：400W", "战斗力达到4000000", "day_task_2.png", 5, "4000000", "3|0|600", 2017, 1, 1, },
	id_217011 = {217011, 2, 217, "战斗力：500W", "战斗力达到5000000", "day_task_2.png", 5, "5000000", "3|0|700", 2017, 1, 1, },
	id_217012 = {217012, 2, 217, "战力爆表！", "战斗力达到6000000", "day_task_2.png", 5, "6000000", "3|0|800", 2017, 1, 1, },
	id_218001 = {218001, 2, 218, "来一起玩耍！", "上阵5个伙伴", "day_task_2.png", 4, "5", "7|440022|3", 2018, 1, 1, },
	id_221001 = {221001, 2, 221, "找到组织了！", "加入公会且公会等级5", "day_task_2.png", 3, "5", "1|0|5000", 2021, 1, 1, },
	id_221002 = {221002, 2, 221, "公会等级：10", "加入公会且公会等级10", "day_task_2.png", 4, "10", "1|0|10000", 2021, 1, 1, },
	id_221003 = {221003, 2, 221, "公会等级：15", "加入公会且公会等级15", "day_task_2.png", 5, "15", "1|0|20000", 2021, 1, 1, },
	id_221004 = {221004, 2, 221, "超大号公会", "加入公会且公会等级20", "day_task_2.png", 5, "20", "1|0|50000", 2021, 1, 1, },
	id_222001 = {222001, 2, 222, "建设公会", "公会个人总贡献达到1000", "day_task_2.png", 4, "1000", "1|0|5000", 2022, 1, 1, },
	id_222002 = {222002, 2, 222, "公会贡献：2000", "公会个人总贡献达到2000", "day_task_2.png", 5, "2000", "1|0|10000", 2022, 1, 1, },
	id_222003 = {222003, 2, 222, "公会贡献：1万", "公会个人总贡献达到10000", "day_task_2.png", 5, "10000", "1|0|20000", 2022, 1, 1, },
	id_222004 = {222004, 2, 222, "公会贡献：2W", "公会个人总贡献达到20000", "day_task_2.png", 5, "20000", "1|0|30000", 2022, 1, 1, },
	id_222005 = {222005, 2, 222, "公会贡献：5W", "公会个人总贡献达到50000", "day_task_2.png", 5, "50000", "1|0|50000", 2022, 1, 1, },
	id_222006 = {222006, 2, 222, "公会砥柱", "公会个人总贡献达到100000", "day_task_2.png", 5, "100000", "1|0|80000", 2022, 1, 1, },
	id_225001 = {225001, 2, 225, "探索一下~", "探索100次", "day_task_2.png", 3, "100", "7|60019|5", 2025, 1, 1, },
	id_225002 = {225002, 2, 225, "探索：200次", "探索200次", "day_task_2.png", 4, "200", "7|60019|5", 2025, 1, 1, },
	id_225003 = {225003, 2, 225, "探索：400次", "探索400次", "day_task_2.png", 4, "400", "7|60019|5", 2025, 1, 1, },
	id_225004 = {225004, 2, 225, "探索：500次", "探索500次", "day_task_2.png", 4, "500", "7|60019|10", 2025, 1, 1, },
	id_225005 = {225005, 2, 225, "探索：600次", "探索600次", "day_task_2.png", 4, "600", "7|60019|10", 2025, 1, 1, },
	id_225006 = {225006, 2, 225, "探索：800次", "探索800次", "day_task_2.png", 4, "800", "7|60019|10", 2025, 1, 1, },
	id_225007 = {225007, 2, 225, "探索：1000次", "探索1000次", "day_task_2.png", 5, "1000", "7|60019|10", 2025, 1, 1, },
	id_225008 = {225008, 2, 225, "探索：3000次", "探索3000次", "day_task_2.png", 5, "3000", "7|60019|15", 2025, 1, 1, },
	id_225009 = {225009, 2, 225, "探索：5000次", "探索5000次", "day_task_2.png", 5, "5000", "7|60019|15", 2025, 1, 1, },
	id_225010 = {225010, 2, 225, "探索：1W次", "探索10000次", "day_task_2.png", 5, "10000", "7|60019|20", 2025, 1, 1, },
	id_225011 = {225011, 2, 225, "打捞王", "探索20000次", "day_task_2.png", 5, "20000", "7|60019|30", 2025, 1, 1, },
	id_226001 = {226001, 2, 226, "攒点钱", "购买贝里10次", "day_task_2.png", 3, "10", "7|30012|1", 2026, 1, 1, },
	id_226002 = {226002, 2, 226, "购买贝里：50次", "购买贝里50次", "day_task_2.png", 4, "50", "7|30012|1", 2026, 1, 1, },
	id_226003 = {226003, 2, 226, "购买贝里：200次", "购买贝里200次", "day_task_2.png", 4, "200", "7|30012|2", 2026, 1, 1, },
	id_226004 = {226004, 2, 226, "购买贝里：500次", "购买贝里500次", "day_task_2.png", 5, "500", "7|30012|3", 2026, 1, 1, },
	id_226005 = {226005, 2, 226, "想买就买", "购买贝里1000次", "day_task_2.png", 5, "1000", "7|30012|4", 2026, 1, 1, },
	id_226006 = {226006, 2, 226, "购买贝里：2000次", "购买贝里2000次", "day_task_2.png", 5, "2000", "7|30013|4", 2026, 1, 1, },
	id_226007 = {226007, 2, 226, "购买贝里：5000次", "购买贝里5000次", "day_task_2.png", 5, "5000", "7|30013|5", 2026, 1, 1, },
	id_226008 = {226008, 2, 226, "购买贝里：8000次", "购买贝里8000次", "day_task_2.png", 5, "8000", "7|30013|6", 2026, 1, 1, },
	id_226009 = {226009, 2, 226, "购物达人", "购买贝里10000次", "day_task_2.png", 5, "10000", "7|30013|7", 2026, 1, 1, },
	id_227001 = {227001, 2, 227, "开宝箱！", "开宝箱10次", "day_task_2.png", 3, "10", "3|0|30", 2027, 1, 1, },
	id_227002 = {227002, 2, 227, "开宝箱：50次", "开宝箱50次", "day_task_2.png", 4, "50", "3|0|50", 2027, 1, 1, },
	id_227003 = {227003, 2, 227, "开宝箱：100次", "开宝箱100次", "day_task_2.png", 4, "100", "3|0|100", 2027, 1, 1, },
	id_227004 = {227004, 2, 227, "开宝箱：200次", "开宝箱200次", "day_task_2.png", 4, "200", "3|0|120", 2027, 1, 1, },
	id_227005 = {227005, 2, 227, "开宝箱：400次", "开宝箱400次", "day_task_2.png", 5, "400", "3|0|150", 2027, 1, 1, },
	id_227006 = {227006, 2, 227, "开宝箱：600次", "开宝箱600次", "day_task_2.png", 5, "600", "3|0|180", 2027, 1, 1, },
	id_227007 = {227007, 2, 227, "开宝箱：800次", "开宝箱800次", "day_task_2.png", 5, "800", "3|0|200", 2027, 1, 1, },
	id_227008 = {227008, 2, 227, "开箱有喜！", "开宝箱1000次", "day_task_2.png", 5, "1000", "1|0|40000", 2027, 1, 1, },
	id_228001 = {228001, 2, 228, "神秘惊喜！", "伙伴商店兑换10次", "day_task_2.png", 3, "10", "11|0|50", 2028, 1, 1, },
	id_228002 = {228002, 2, 228, "积少成多！", "伙伴商店兑换50次", "day_task_2.png", 3, "50", "11|0|100", 2028, 1, 1, },
	id_228003 = {228003, 2, 228, "兑换:100次", "伙伴商店兑换100次", "day_task_2.png", 3, "100", "11|0|150", 2028, 1, 1, },
	id_228004 = {228004, 2, 228, "兑换:300次", "伙伴商店兑换300次", "day_task_2.png", 4, "300", "11|0|250", 2028, 1, 1, },
	id_228005 = {228005, 2, 228, "心想事成！", "伙伴商店兑换500次", "day_task_2.png", 5, "500", "11|0|300", 2028, 1, 1, },
	id_229001 = {229001, 2, 229, "招募船员！", "商城招募10次", "day_task_2.png", 3, "10", "7|60001|2", 2029, 1, 1, },
	id_229002 = {229002, 2, 229, "招募:50次", "商城招募50次", "day_task_2.png", 4, "50", "7|60001|3", 2029, 1, 1, },
	id_229003 = {229003, 2, 229, "招募:100次", "商城招募100次", "day_task_2.png", 4, "100", "7|60001|3", 2029, 1, 1, },
	id_229004 = {229004, 2, 229, "招募:200次", "商城招募200次", "day_task_2.png", 4, "200", "7|60001|4", 2029, 1, 1, },
	id_229005 = {229005, 2, 229, "招募:300次", "商城招募300次", "day_task_2.png", 5, "300", "7|60001|4", 2029, 1, 1, },
	id_229006 = {229006, 2, 229, "酒馆常客！", "商城招募500次", "day_task_2.png", 5, "500", "7|60001|5", 2029, 1, 1, },
	id_230001 = {230001, 2, 230, "背包客", "扩充任意背包1次", "day_task_2.png", 3, "1", "1|0|5000", 2030, 1, 1, },
	id_230002 = {230002, 2, 230, "扩充背包：5", "扩充任意背包5次", "day_task_2.png", 4, "5", "1|0|10000", 2030, 1, 1, },
	id_230003 = {230003, 2, 230, "扩充背包：10", "扩充任意背包10次", "day_task_2.png", 5, "10", "1|0|15000", 2030, 1, 1, },
	id_231001 = {231001, 2, 231, "为了公会！", "公会捐献100金币", "day_task_2.png", 3, "100", "1|0|30000", 2031, 1, 1, },
	id_231002 = {231002, 2, 231, "捐献金币：200", "公会捐献200金币", "day_task_2.png", 4, "200", "1|0|50000", 2031, 1, 1, },
	id_231003 = {231003, 2, 231, "捐献金币：500", "公会捐献500金币", "day_task_2.png", 5, "500", "1|0|80000", 2031, 1, 1, },
	id_231004 = {231004, 2, 231, "捐献金币：1000", "公会捐献1000金币", "day_task_2.png", 5, "1000", "1|0|100000", 2031, 1, 1, },
	id_231005 = {231005, 2, 231, "有钱，任性！", "公会捐献2000金币", "day_task_2.png", 5, "2000", "1|0|120000", 2031, 1, 1, },
	id_301001 = {301001, 3, 301, "紫色勇士", "招募任意1个紫色品质伙伴", "day_task_2.png", 5, "5", "7|440023|1", 3001, 0, 1, },
	id_301002 = {301002, 3, 301, "橙色冒险者", "招募任意1个橙色品质伙伴", "day_task_2.png", 6, "6", "7|440001|2", 3001, 1, 1, },
	id_301003 = {301003, 3, 301, "红色大海盗", "招募任意1个红色品质伙伴", "day_task_2.png", 6, "7", "7|440001|3", 3001, 1, 1, },
	id_302001 = {302001, 3, 302, "海盗团！", "获得20位不同伙伴", "day_task_2.png", 3, "20", "7|440001|2", 3002, 1, 1, },
	id_302002 = {302002, 3, 302, "50名伙伴", "获得50位不同伙伴", "day_task_2.png", 4, "50", "7|440001|2", 3002, 1, 1, },
	id_302003 = {302003, 3, 302, "超级船长", "获得100位不同伙伴", "day_task_2.png", 5, "100", "7|440001|3", 3002, 1, 1, },
	id_304001 = {304001, 3, 304, "伙伴进阶：1", "任意伙伴进阶等级达到1", "day_task_3.png", 3, "1", "3|0|50", 3004, 1, 1, },
	id_304002 = {304002, 3, 304, "伙伴进阶：2", "任意伙伴进阶等级达到2", "day_task_3.png", 3, "2", "3|0|60", 3004, 1, 1, },
	id_304003 = {304003, 3, 304, "伙伴进阶：3", "任意伙伴进阶等级达到3", "day_task_3.png", 3, "3", "3|0|80", 3004, 1, 1, },
	id_304004 = {304004, 3, 304, "人体改造", "任意伙伴进阶等级达到4", "day_task_3.png", 3, "4", "3|0|100", 3004, 1, 1, },
	id_304005 = {304005, 3, 304, "伙伴进阶：5", "任意伙伴进阶等级达到5", "day_task_3.png", 5, "5", "3|0|120", 3004, 1, 1, },
	id_304006 = {304006, 3, 304, "伙伴进阶：6", "任意伙伴进阶等级达到6", "day_task_3.png", 5, "6", "3|0|150", 3004, 1, 1, },
	id_304007 = {304007, 3, 304, "伙伴进阶：7", "任意伙伴进阶等级达到7", "day_task_3.png", 5, "7", "3|0|200", 3004, 1, 1, },
	id_304008 = {304008, 3, 304, "伙伴进阶：8", "任意伙伴进阶等级达到8", "day_task_3.png", 5, "8", "3|0|250", 3004, 1, 1, },
	id_304009 = {304009, 3, 304, "伙伴进阶：9", "任意伙伴进阶等级达到9", "day_task_3.png", 5, "9", "3|0|300", 3004, 1, 1, },
	id_304010 = {304010, 3, 304, "伙伴进阶：10", "任意伙伴进阶等级达到10", "day_task_3.png", 5, "10", "3|0|400", 3004, 1, 1, },
	id_304011 = {304011, 3, 304, "超凡脱俗", "任意伙伴进阶等级达到11", "day_task_3.png", 5, "11", "3|0|500", 3004, 1, 1, },
	id_306001 = {306001, 3, 306, "共同成长", "任意紫色及以上伙伴等级达到15", "day_task_3.png", 5, "15", "7|440001|4", 3006, 1, 1, },
	id_306002 = {306002, 3, 306, "伙伴等级：20", "任意紫色及以上伙伴等级达到20", "day_task_3.png", 5, "20", "7|440001|6", 3006, 1, 1, },
	id_306003 = {306003, 3, 306, "伙伴等级：25", "任意紫色及以上伙伴等级达到25", "day_task_3.png", 5, "25", "7|440001|8", 3006, 1, 1, },
	id_306004 = {306004, 3, 306, "伙伴等级：30", "任意紫色及以上伙伴等级达到30", "day_task_3.png", 5, "30", "7|440001|8", 3006, 1, 1, },
	id_306005 = {306005, 3, 306, "伙伴等级：35", "任意紫色及以上伙伴等级达到35", "day_task_3.png", 5, "35", "7|440001|8", 3006, 1, 1, },
	id_306006 = {306006, 3, 306, "伙伴等级：40", "任意紫色及以上伙伴等级达到40", "day_task_3.png", 5, "40", "7|440001|8", 3006, 1, 1, },
	id_306007 = {306007, 3, 306, "伙伴等级：45", "任意紫色及以上伙伴等级达到45", "day_task_3.png", 5, "45", "7|440001|8", 3006, 1, 1, },
	id_306008 = {306008, 3, 306, "伙伴等级：50", "任意紫色及以上伙伴等级达到50", "day_task_3.png", 5, "50", "7|440001|8", 3006, 1, 1, },
	id_308001 = {308001, 3, 308, "强力伙伴！", "通过影子合成紫色伙伴1个", "day_task_3.png", 5, "5|1", "7|30021|2", 3008, 1, 1, },
	id_308002 = {308002, 3, 308, "紫色伙伴：5", "通过影子合成紫色伙伴5个", "day_task_3.png", 5, "5|5", "7|30021|2", 3008, 1, 1, },
	id_308003 = {308003, 3, 308, "精英集结！", "通过影子合成紫色伙伴10个", "day_task_3.png", 5, "5|10", "7|30021|2", 3008, 1, 1, },
	id_310001 = {310001, 3, 310, "豪华阵容！", "通过影子合成橙色伙伴1个", "day_task_3.png", 6, "6|1", "7|30021|2", 3010, 1, 1, },
	id_310002 = {310002, 3, 310, "橙色伙伴：5", "通过影子合成橙色伙伴5个", "day_task_3.png", 6, "6|5", "7|30021|2", 3010, 1, 1, },
	id_310003 = {310003, 3, 310, "所向披靡！", "通过影子合成橙色伙伴10个", "day_task_3.png", 6, "6|10", "7|30021|2", 3010, 1, 1, },
	id_401001 = {401001, 4, 401, "蓝色品质", "获得任意1件蓝色品质装备", "day_task_3.png", 4, "4", "1|0|20000", 4001, 1, 1, },
	id_401002 = {401002, 4, 401, "紫色品质", "获得任意1件紫色品质装备", "day_task_3.png", 5, "5", "1|0|20000", 4001, 1, 1, },
	id_401003 = {401003, 4, 401, "橙色品质", "获得任意1件橙色品质装备", "day_task_3.png", 6, "6", "1|0|20000", 4001, 1, 1, },
	id_402001 = {402001, 4, 402, "紫水晶", "获得任意1件紫色品质饰品", "day_task_3.png", 5, "5", "1|0|20000", 4002, 1, 1, },
	id_403001 = {403001, 4, 403, "一身装备", "获得30种不同装备", "day_task_3.png", 5, "30", "1|0|20000", 4003, 1, 1, },
	id_403002 = {403002, 4, 403, "装备：50", "获得50种不同装备", "day_task_3.png", 5, "50", "1|0|50000", 4003, 1, 1, },
	id_403003 = {403003, 4, 403, "装备：70", "获得70种不同装备", "day_task_3.png", 5, "70", "1|0|80000", 4003, 1, 1, },
	id_403004 = {403004, 4, 403, "装备库", "获得77种不同装备", "day_task_3.png", 5, "77", "1|0|150000", 4003, 1, 1, },
	id_404001 = {404001, 4, 404, "满手饰品", "获得10种不同饰品", "day_task_3.png", 3, "10", "7|60019|5", 4004, 1, 1, },
	id_404002 = {404002, 4, 404, "饰品：30", "获得30种不同饰品", "day_task_3.png", 5, "30", "7|60019|10", 4004, 1, 1, },
	id_404003 = {404003, 4, 404, "饰品：60", "获得60种不同饰品", "day_task_3.png", 5, "60", "7|60019|15", 4004, 1, 1, },
	id_404004 = {404004, 4, 404, "饰品：100", "获得100种不同饰品", "day_task_3.png", 5, "100", "7|60019|20", 4004, 1, 1, },
	id_404005 = {404005, 4, 404, "饰品陈列室", "获得136种不同饰品", "day_task_3.png", 5, "136", "7|60019|25", 4004, 1, 1, },
	id_405001 = {405001, 4, 405, "饰品合成5次", "饰品合成5次", "day_task_3.png", 5, "5", "1|0|20000", 4005, 1, 1, },
	id_406001 = {406001, 4, 406, "打磨饰品", "任意饰品等级达到5级", "day_task_3.png", 3, "5", "3|0|40", 4006, 1, 1, },
	id_406002 = {406002, 4, 406, "饰品等级：8", "任意饰品等级达到8级", "day_task_3.png", 4, "8", "3|0|40", 4006, 1, 1, },
	id_406003 = {406003, 4, 406, "饰品等级：10", "任意饰品等级达到10级", "day_task_3.png", 4, "10", "3|0|40", 4006, 1, 1, },
	id_406004 = {406004, 4, 406, "饰品等级：12", "任意饰品等级达到12级", "day_task_3.png", 4, "12", "3|0|50", 4006, 1, 1, },
	id_406005 = {406005, 4, 406, "饰品等级：15", "任意饰品等级达到15级", "day_task_3.png", 4, "15", "3|0|100", 4006, 1, 1, },
	id_406006 = {406006, 4, 406, "饰品等级：20", "任意饰品等级达到20级", "day_task_3.png", 5, "20", "3|0|200", 4006, 1, 1, },
	id_406007 = {406007, 4, 406, "饰品等级：30", "任意饰品等级达到30级", "day_task_3.png", 5, "30", "3|0|300", 4006, 1, 1, },
	id_406008 = {406008, 4, 406, "传世之宝", "任意饰品等级达到40级", "day_task_3.png", 5, "40", "3|0|400", 4006, 1, 1, },
	id_407001 = {407001, 4, 407, "饰品精炼1级", "任意饰品精炼达到1级", "day_task_3.png", 5, "1", "3|0|50", 4007, 1, 1, },
	id_407002 = {407002, 4, 407, "饰品精炼2级", "任意饰品精炼达到2级", "day_task_3.png", 5, "2", "3|0|80", 4007, 1, 1, },
	id_407003 = {407003, 4, 407, "饰品精炼3级", "任意饰品精炼达到3级", "day_task_3.png", 5, "3", "3|0|100", 4007, 1, 1, },
	id_407004 = {407004, 4, 407, "饰品精炼4级", "任意饰品精炼达到4级", "day_task_3.png", 5, "4", "3|0|150", 4007, 1, 1, },
	id_409001 = {409001, 4, 409, "改造装备", "任意装备等级达到20级", "day_task_3.png", 3, "20", "7|60502|3", 4009, 1, 1, },
	id_409002 = {409002, 4, 409, "装备强化：40", "任意装备等级达到40级", "day_task_3.png", 4, "40", "7|60502|3", 4009, 1, 1, },
	id_409003 = {409003, 4, 409, "装备强化：60", "任意装备等级达到60级", "day_task_3.png", 5, "60", "7|60502|3", 4009, 1, 1, },
	id_409004 = {409004, 4, 409, "装备强化：80", "任意装备等级达到80级", "day_task_3.png", 5, "80", "7|60503|3", 4009, 1, 1, },
	id_409005 = {409005, 4, 409, "强化百分百", "任意装备等级达到100级", "day_task_3.png", 5, "100", "7|60503|3", 4009, 1, 1, },
	id_409006 = {409006, 4, 409, "装备强化：120", "任意装备等级达到120级", "day_task_3.png", 5, "120", "7|60504|3", 4009, 1, 1, },
	id_410001 = {410001, 4, 410, "附魔新手", "任意装备附魔等级达到3级", "day_task_3.png", 5, "3", "7|60502|3", 4010, 1, 1, },
	id_410002 = {410002, 4, 410, "附魔：5", "任意装备附魔等级达到5级", "day_task_3.png", 5, "5", "7|60502|3", 4010, 1, 1, },
	id_410003 = {410003, 4, 410, "附魔：7", "任意装备附魔等级达到7级", "day_task_3.png", 5, "7", "1|0|10000", 4010, 1, 1, },
	id_410004 = {410004, 4, 410, "附魔：10", "任意装备附魔等级达到10级", "day_task_3.png", 5, "10", "1|0|20000", 4010, 1, 1, },
	id_412001 = {412001, 4, 412, "初级强化", "3名伙伴身上装备都强化到20级", "day_task_3.png", 5, "20", "1|0|10000", 4012, 1, 1, },
	id_412002 = {412002, 4, 412, "装备强化(3人)", "3名伙伴身上装备都强化到30级", "day_task_3.png", 5, "30", "1|0|10000", 4012, 1, 1, },
	id_413001 = {413001, 4, 413, "装备强化(4人)", "4名伙伴身上装备都强化到30级", "day_task_3.png", 5, "30", "1|0|10000", 4013, 1, 1, },
	id_413002 = {413002, 4, 413, "装备强化(4人)", "4名伙伴身上装备都强化到40级", "day_task_3.png", 5, "40", "1|0|20000", 4013, 1, 1, },
	id_413003 = {413003, 4, 413, "装备强化(4人)", "4名伙伴身上装备都强化到50级", "day_task_3.png", 5, "50", "1|0|30000", 4013, 1, 1, },
	id_414001 = {414001, 4, 414, "装备强化(5人)", "5名伙伴身上装备都强化到50级", "day_task_3.png", 5, "50", "1|0|40000", 4014, 1, 1, },
	id_415001 = {415001, 4, 415, "装备强化(6人)", "6名伙伴身上装备都强化到50级", "day_task_3.png", 5, "50", "1|0|50000", 4015, 1, 1, },
	id_416001 = {416001, 4, 416, "装备附魔(3人)", "3名伙伴身上装备都附魔到20级", "day_task_3.png", 5, "20", "1|0|20000", 4016, 1, 1, },
	id_417001 = {417001, 4, 417, "装备附魔(4人)", "4名伙伴身上装备都附魔到20级", "day_task_3.png", 5, "20", "1|0|30000", 4017, 1, 1, },
	id_418001 = {418001, 4, 418, "主力附魔：1", "5名伙伴身上装备都附魔到1级", "day_task_3.png", 5, "1", "3|0|30", 4018, 1, 1, },
	id_418002 = {418002, 4, 418, "主力附魔：2", "5名伙伴身上装备都附魔到2级", "day_task_3.png", 5, "2", "3|0|50", 4018, 1, 1, },
	id_418003 = {418003, 4, 418, "主力附魔：3", "5名伙伴身上装备都附魔到3级", "day_task_3.png", 5, "3", "1|0|10000", 4018, 1, 1, },
	id_418004 = {418004, 4, 418, "主力附魔：4", "5名伙伴身上装备都附魔到4级", "day_task_3.png", 5, "4", "1|0|20000", 4018, 1, 1, },
	id_419001 = {419001, 4, 419, "多人附魔：4", "6名伙伴身上装备都附魔到4级", "day_task_3.png", 5, "3", "1|0|30000", 4019, 1, 1, },
	id_420001 = {420001, 4, 420, "饰品强化(3人)", "3名伙伴身上饰品都强化到3级", "day_task_3.png", 5, "3", "3|0|30", 4020, 1, 1, },
	id_421001 = {421001, 4, 421, "饰品强化(4人)", "4名伙伴身上饰品都强化到3级", "day_task_3.png", 5, "3", "3|0|30", 4021, 1, 1, },
	id_422001 = {422001, 4, 422, "主力饰品强化：3", "5名伙伴身上饰品都强化到3级", "day_task_3.png", 5, "3", "3|0|50", 4022, 1, 1, },
	id_422002 = {422002, 4, 422, "主力饰品强化：5", "5名伙伴身上饰品都强化到5级", "day_task_3.png", 5, "5", "3|0|50", 4022, 1, 1, },
	id_423001 = {423001, 4, 423, "多人饰品强化：5", "6名伙伴身上饰品都强化到5级", "day_task_3.png", 5, "5", "3|0|70", 4023, 1, 1, },
	id_424001 = {424001, 4, 424, "饰品精炼(3人)", "3名伙伴身上饰品都精炼到1级", "day_task_3.png", 5, "1", "3|0|80", 4024, 1, 1, },
	id_425001 = {425001, 4, 425, "饰品精炼(4人)", "4名伙伴身上饰品都精炼到1级", "day_task_3.png", 5, "1", "3|0|80", 4025, 1, 1, },
	id_426001 = {426001, 4, 426, "主力精炼：1", "5名伙伴身上饰品都精炼到1级", "day_task_3.png", 5, "1", "3|0|90", 4026, 1, 1, },
	id_426002 = {426002, 4, 426, "主力精炼：2", "5名伙伴身上饰品都精炼到2级", "day_task_3.png", 5, "2", "3|0|90", 4026, 1, 1, },
	id_427001 = {427001, 4, 427, "多人精炼：1", "6名伙伴身上饰品都精炼到1级", "day_task_3.png", 5, "1", "3|0|100", 4027, 1, 1, },
}

local mt = {}
mt.__index = function (table, key)
	for i = 1, #keys do
		if (keys[i] == key) then
			return table[i]
		end
	end
end

function getDataById(key_id)
	local id_data = Achie_table["id_" .. key_id]
	assert(id_data, "Achie_table not found " ..  key_id)
	if id_data == nil then
		return nil
	end
	if getmetatable(id_data) ~= nil then
		return id_data
	end
	setmetatable(id_data, mt)

	return id_data
end

function getArrDataByField(fieldName, fieldValue)
	local arrData = {}
	local fieldNo = 1
	for i=1, #keys do
		if keys[i] == fieldName then
			fieldNo = i
			break
		end
	end
	for k, v in pairs(Achie_table) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Achie_table"] = nil
	package.loaded["DB_Achie_table"] = nil
	package.loaded["db/DB_Achie_table"] = nil
end

