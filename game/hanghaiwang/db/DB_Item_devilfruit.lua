-- Filename: DB_Item_devilfruit.lua
-- Author: auto-created by XmlToScript tool.
-- Function: it`s auto-created by XmlToScript tool.

module("DB_Item_devilfruit", package.seeall)

keys = {
	"id", "name", "desc", "icon_small", "icon_big", "item_type", "quality", "sellable", "sell_type", "sell_num", "max_stack", "canDestroy", "awake_ability_ID", "canDeleted", "use_costBely", "use_costGold", "use_needItem", "exp_eat", "max_lv", "canUp", "up_id", "effectType", 
}

Item_devilfruit = {
	id_200001 = {200001, "恶魔果实1", "恶魔果实1", "devilfruit1.png", nil, 15, 2, 1, 1, 2000, 1, nil, "21000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200002 = {200002, "恶魔果实2", "恶魔果实1", "devilfruit1.png", nil, 15, 3, 1, 1, 3000, 1, nil, "21100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200003 = {200003, "恶魔果实3", "恶魔果实1", "devilfruit1.png", nil, 15, 4, 1, 1, 4000, 1, nil, "21200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200004 = {200004, "恶魔果实4", "恶魔果实1", "devilfruit1.png", nil, 15, 5, 1, 1, 5000, 1, nil, "21300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200005 = {200005, "恶魔果实5", "恶魔果实1", "devilfruit1.png", nil, 15, 2, 1, 1, 2000, 1, nil, "21400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200006 = {200006, "恶魔果实6", "恶魔果实1", "devilfruit1.png", nil, 15, 3, 1, 1, 3000, 1, nil, "21500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200007 = {200007, "恶魔果实7", "恶魔果实1", "devilfruit1.png", nil, 15, 4, 1, 1, 4000, 1, nil, "21600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_200008 = {200008, "恶魔果实8", "恶魔果实1", "devilfruit1.png", nil, 15, 5, 1, 1, 5000, 1, nil, "21700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205001 = {205001, "震动之果", "引发振动并进行操控的能力。其冲击力拥有掀翻大地的力量。\n格挡率提高10%，反击时的伤害提高1倍", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205002 = {205002, "黑暗之果", "能操纵黑暗的力量。即使是他人的恶魔果实能力，也能够用引力进行封锁。缺点就是会不分敌我地将所有攻击都吸引过来。\n普攻攻击可吞噬目标2点怒气（若目标怒气不足2点，则吞噬全部）", "fruit_anan.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205003 = {205003, "闪光之果", "能将肉体变为光线的能力。可以高速移动，以光速踢向对方。而且在指间和脚尖装配弹药后，可同时发射爆炸性射线。\n闪避后对敌方直线造成攻击80%伤害（不增加目标怒气）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205004 = {205004, "冰冻之果", "可将自己的身体化为冰的能力。即使被打碎也能再生，接触的物体即便是大海，也能在瞬间让其冰冻。\n怒气攻击有60%概率使目标冰冻1回合（冰冻状态下不能行动且不能恢复怒气）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205005 = {205005, "岩浆之果", "可将肉体化为岩浆的能力。被果实能力打中的人，连五脏六腑都会被烧坏，身负重伤。\n普通攻击有50%概率使目标灼烧2回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205006 = {205006, "剧毒之果", "可获得从身体中分泌剧毒的能力。或是利用毒液攻击敌人，或是化为雾状，将特定空间充满毒雾，用途广泛。\n中毒伤害提高20%", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205007 = {205007, "线线之果", "能够使用线操控敌人，可以通过线切割敌人的身体。\n免疫混乱，怒气攻击有70%概率使目标混乱1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205008 = {205008, "人人之果", "该果实能够获得变身为人类的力量。动物食用后，会得到直立行走等人类特有的能力。\n普通攻击20%概率给己方随机2人附加1个守护效果（守护效果下受到的伤害减少20%）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205009 = {205009, "烟雾之果", "能将肉体变为烟雾的能力。由于在烟雾状态下也能拥有实体，所以最擅长缠绕住猎物，将其捕获。\n怒气攻击有20%概率使其眩晕1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "80900", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205010 = {205010, "肉球之果", "食用者可获得将所有物体弹回的肉球。不仅可压缩大气产生冲击波，还可从人体内将疲劳等能量也自由地弹出。\n普通攻击有10%概率使目标放逐1回合（被放逐的目标不能攻击且不受到普通攻击）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205011 = {205011, "花花之果", "可将手足等身体的部位在任意场所开花的能力！\n怒气攻击100%概率降低目标1点怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205012 = {205012, "黄泉之果", "食用者在死后会灵魂出窍，待再次返回到自己的身体时即可复生。不过，肉体受到的伤害是无法复原的。\n每次行动后回复自身30%与自身攻击相关的血量", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205013 = {205013, "砂砂之果", "可将肉体变为沙子的能力。擅长运用沙漠风暴进行攻击，另外，还能夺走所接触到的物体中的所有水分。\n普通攻击可以把75%的伤害转化为自己生命", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205014 = {205014, "雷电之果", "自由操纵雷电的能力。可将自己的身体变为雷，或是进行高速移动，或是化解攻击。可称为万能的力量，不过唯一的天敌就是橡皮。\n免疫麻痹，攻击20%概率给目标附加麻痹1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205015 = {205015, "颓靡之果", "能将男女老幼尽数迷倒，并有将对方变成石头的能量。还可让飞吻变成实体，发动物理性攻击。\n免疫石化，免疫魅惑，怒气攻击目标石化1回合（石化状态下不能行动并且不能回复血量）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205016 = {205016, "不明", "能够通过将身体变为磁石，自由地操纵周围的金属。\n怒气攻击吸血，将15%的伤害转化成自身血量，任何攻击吸取目标攻击，持续1回合。", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205017 = {205017, "幽灵之果", "能指挥操纵无数幽灵的能力。幽灵中有的能给予接触者精神攻击，也有的能引爆，并发射冲击波，种类多种多样。\n怒气攻击100%沮丧1回合沮丧效果", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205018 = {205018, "影子之果", "能够剪下人的影子放入“人偶”中，制造和影子所有者同等能力的部下。\n普攻攻击和怒气攻击增加自身魔攻，持续10回合（可叠加），每次增加自身魔攻基础值的5%", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205019 = {205019, "橡皮之果", "食用者的全身可像橡皮一样自由地伸缩！可利用弹力和斥力进行攻击以及高速移动。\n免疫麻痹、石化，自身伤害提高5%", "fruit_xiangjiao.png", nil, 15, 5, 1, 1, 8000, 1, nil, "81900", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205020 = {205020, "手术之果", "产生称为“ROOM”的球状空间，将包裹在其中的人进行任意切割，也可以自由替换。\n怒气攻击造成伤害的45%转化为己方血最少伙伴的生命", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205021 = {205021, "燃烧之果", "自由操纵全身迸发出的火焰。也可将自己的肉体变为火焰，进行移动和攻击。\n免疫灼烧状态，怒气攻击时有60%概率使目标灼烧2回合，若目标处于灼烧状态，任何攻击降低其1点怒气", "fruit_shaoshao.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205022 = {205022, "不死鸟之果", "可以变身为不死鸟的动物系幻兽种的能力。缠绕全身的再生火焰，可以瞬间治愈所有的损伤。\n受到致死伤害时不死，并回复20%生命（生效1次）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205023 = {205023, "槛槛之果", "最适合捕获敌人的能力。能将触碰到能力者身体的人关进坚固的铁笼里！\n普通攻击20%概率使目标眩晕1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205024 = {205024, "不明", "极其稀有的古代种动物系。能够变身为太古时代的王者恐龙。\n怒气攻击使目标撕裂状态2回合，使其受到的物理伤害增加15%，同时攻击处于撕裂状态的目标可以把伤害的20%转化成自身生命。", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205025 = {205025, "不明", "承受住对受的攻击后，将受到的伤害还原为自己的力量，身体也随之变得巨大无比。\n普通攻击100%不增加目标怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205026 = {205026, "荷尔蒙之果", "拥有针状的指尖像注射器一样弹出，能自由调节荷尔蒙的活动。\n普通攻击后回复己方血最少的伙伴30%与自身攻击相关的生命", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205027 = {205027, "牛牛之果", "不仅具备长颈鹿的身体特征，而且可以伸缩脖子和手脚，获得其他动物系所不具备的特殊体质。\n格挡反击时给自身回复1怒气", "fruit_animal2.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205028 = {205028, "不明", "可以变身为斑点狗，拥有敏捷的速度和强健的身体。\n普通攻击有10%概率攻击敌方单体1次，造成50%攻击伤害", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205029 = {205029, "猫猫之果", "兼具猫科动物特有的柔软和肉食兽的争斗本能，特别是能在格斗战中发挥出最顶级的力量。\n普通攻击使敌方后排进入撕裂状态2回合，使其受到的物理伤害增加15%，同时攻击处于撕裂状态的目标可以把伤害的20%转化成自身生命。", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "82900", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205030 = {205030, "不明", "可将身体变为堪称具有极高硬度的钻石。\n怒气攻击后自身无敌1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205031 = {205031, "不明", "体内藏有稻草人，可以用来当做替身。自己也能变身为巨大的稻草人。\n怒气攻击时给自身附加1回合底力", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205032 = {205032, "不明", "能够将自己身体的所有部位变为乐器，弹奏的乐声中拥有攻击敌人的力量。\n怒气攻击降低目标的魔法抗性2回合，使其受到的魔法伤害增加15%", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205033 = {205033, "泡泡之果", "该能力可从全身产生泡泡，将接触到的物体全部洗掉。\n怒气攻击时增加自身闪避10%，持续2回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205034 = {205034, "蛇蛇之果", "得到蟒蛇的能力。虽然没有毒性，但是最擅长用长长的身体和力量对对手进行绞杀。\n怒气攻击有30%概率眩晕目标1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205035 = {205035, "蛇蛇之果", "变身为蛇的一种眼镜王蛇。敏捷的动作和口中喷出的剧毒是武器。\n免疫灼烧状态，如果目标处于灼烧状态，普通攻击必定使其中毒1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205036 = {205036, "不明", "随意操作年龄，肉体也能随着年龄而相应改变。对自己和他人都有效。\n普通攻击后回复自己30%与自身攻击相关的生命", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205037 = {205037, "不明", "将部下和兵器缩小，藏于体内。拥有能输送庞大战斗力的能力。\n普通攻击有40%攻击敌方全体", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205038 = {205038, "模仿之果", "可以记忆用手触摸过的人物相貌和体形，让自身的身体发生与之完全一样的变形。记录可以无限制地储存。\n被攻击时，如果攻击力低于攻击者，获得和对方相同的攻击力3回合（只生效1次且对怪物不生效）", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205039 = {205039, "热热之果", "能够在1度到10000度范围内任意改变体温。\n当目标处于灼烧状态时，普通攻击降低其1怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "83900", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205040 = {205040, "四分五裂之果", "可将身体各部分进行分割的能力。分离的部位只要是在离开脚的一定范围内，就可以随意操作。\n被普通攻击时有50%概率免疫100%伤害", "fruit_sifenwulie.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205041 = {205041, "快斩之果", "可将身体的任何部位变为刀刃。刀刃的形状也可随意变化，还可以像钢钻一样旋转。\n怒气攻击使目标撕裂状态2回合，使其受到的物理伤害增加15%，同时攻击处于撕裂状态的目标可以把伤害的20%转化成自身生命。", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205042 = {205042, "犬犬之果", "该果实可以获得狼的力量。变身后不仅爆发力和力量同时获得大幅提升，而且由于野生动物的血性浓厚，凶暴程度也剧增。\n普通攻击有50%概率回复自身1怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205043 = {205043, "门门之果", "该能力能够在任意场所制造出各种各样的门。不仅仅是在墙壁上，在空间和身体上也能制造出一扇门来！门外通往异空间，可用于转移或物质的转换。\n怒气攻击时50%概率使目标眩晕1回合", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205044 = {205044, "剪刀之果", "从巨大的建筑物到钢铁，都能用化作剪刀的双手将其像纸片一样剪碎。而且可将剪下的对象如同纸一样折叠，随心所欲地进行造型。\n怒气攻击降低目标的魔法抗性2回合，使其受到的魔法伤害增加15%", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205045 = {205045, "缓慢之果", "可获得世间罕见的发射缓慢光子的能力。受到光波辐射的人动作会变得迟缓，其间所受到的由敌人发动攻击所产生的破坏力会积蓄在体内。\n怒气攻击降低目标1怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205046 = {205046, "人人之果", "大佛一般巨大的身体，加上极为清晰的头脑，成为精神、技能和身体三方面都达到极致的人。\n怒气攻击后随机给己方1伙伴增加1怒气", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205047 = {205047, "不知名果实", "\n这是1个不知名", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205048 = {205048, "融化之果", "可以自由操纵从体内分泌的蜡。蜡可以随意变形，凝固后具有钢铁的强度。\n普通攻击伤害增加10%", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205049 = {205049, "滑滑之果", "食用后，全身的肌肤会变得嫩滑无比！摩擦力为零的极致美肤能让刀剑全部打滑！\n被怒气攻击时有50%概率免疫30%伤害", "fruit_super2.png", nil, 15, 5, 1, 1, 8000, 1, nil, "84900", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_205050 = {205050, "洗洗之果", "能将一切物体洗尽晾干，使其变得无力的能力。如果是恶人会被洗净心灵，降低其作恶的气力。\n怒气攻击时可以清洗掉敌方单体目标身上的各种增益buff", "devilfruit5.png", nil, 15, 5, 1, 1, 8000, 1, nil, "85000", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204001 = {204001, "狼吞虎咽之果", "获得能够吃下任何物体的能力。可以将吃下的东西作为材料， 对自己的身体进行变形或改变性质。\n怒气攻击后回复自身血量1次", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85100", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204002 = {204002, "弹簧之果", "该恶魔果实可使食用者的全身变形成为强韧的弹簧。利用弹簧的反弹力，可让弹跳力和速度实现惊人的提升。\n怒气攻击时弹射2次随机伤害", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85200", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204003 = {204003, "荆棘之果", "能从自己的体内长出锋利尖刺的能力。其数量和长度都可以自由操控。\n怒气攻击时有10%概率使目标中毒1回合", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85300", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204004 = {204004, "鼹鼠之果", "获得鼹鼠的能力。潜藏在地下进行移动，擅长神出鬼没的战法。\n怒气攻击时使对方随机1个目标中毒1回合", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85400", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204005 = {204005, "炸弹之果", "全身的所有部位都可变为炸弹，无论是鼻屎还是吐出的气息，体内产生的任何物体全都能够爆炸。\n怒气攻击时有40%概率使目标灼烧1回合", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85500", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204006 = {204006, "轻重之果", "将体重从1千克到10000千克自由自在地进行变化，像羽毛般在空中飞舞之后，会利用巨大的重量压向敌人。\n怒气攻击时使目标眩晕1回合", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85600", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204007 = {204007, "牛牛之果", "力量和速度即便是在动物系中也是出类拔萃的！锋利的犄角发动的袭击破坏力超群。\n怒气攻击后增加自身伤害5%，生效1次", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85700", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_204008 = {204008, "透明之果", "该果实在食用后人的身体会变得通透，成为一个透明人。\n怒气攻击后增加自身闪避,生效2回合", "devilfruit5.png", nil, 15, 4, 1, 1, 4000, 1, nil, "85800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_203001 = {203001, "鸟鸟之果", "获得飞行能力的稀有种类。特别是隼的速度和滑翔能力极为突出。\n", "devilfruit5.png", nil, 15, 3, 1, 1, 2000, 1, nil, "85800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
	id_203002 = {203002, "生锈之果", "能将接触到的金属在一瞬间腐蚀成无法修复的状态。\n", "devilfruit5.png", nil, 15, 3, 1, 1, 2000, 1, nil, "85800", nil, nil, nil, nil, nil, nil, nil, nil, nil, },
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
	local id_data = Item_devilfruit["id_" .. key_id]
	assert(id_data, "Item_devilfruit not found " ..  key_id)
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
	for k, v in pairs(Item_devilfruit) do
		if v[fieldNo] == fieldValue then
			setmetatable (v, mt)
			arrData[#arrData+1] = v
		end
	end

	return arrData
end

function release()
	_G["DB_Item_devilfruit"] = nil
	package.loaded["DB_Item_devilfruit"] = nil
	package.loaded["db/DB_Item_devilfruit"] = nil
end

