PlatformNameEnum = {
    kIOS        = "apple",
    kWP8        = "windowsphone",
    kHE         = "he",   
    kQQ         = "yingyongbao",
    kYYB_CENTER = "yybcenter",
    kYYB_MARKET = "yybmarket",
    kYYB_JINSHAN = "yybjinshan",
    kYYB_BROWSER = "yybbrowser",
    kYYB_ZONE   = "yybzone",
    kYYB_VIDEO  = "yybvideo",
    kYYB_NEWS   = "yybnews",
    kYYB_QQ     = "yybqq",
    kYYB_PC     = "yybpc",
    kYYB_CORE     = "yybcore",
    kYYB_SHOP   = "yybshop",
    kYYB_TMS_CENTER     = "yybtmscenter",
    kYYB_TMS_SHOP     = "yybtmsshop",
    k360        = "360",
    kDuoku      = "duoku",
    kWDJ        = "wandoujia",
    kMI         = "mi",
    kMiTalk     = "mitalk",
    kBaiDuApp   = "baiduapp",
    kBaiDuTieBa = "tieba",
    k91         = "91",
    kHao123     = "hao123",
    kOppo       = "oppo",
    kBBK        = "bbk",
    kTYD        = "tianyida",
    kJinShan    = "jinshan",
    kLenovo     = "lenovo",
    kHuaWei     = "huawei",
    kMiPad      = "mipad",
    kCMCCMM     = "cmccmm",
    kCUCCWO     = "cuccwo",
    kCoolpad    = "coolpad",
    kAnZhi      = "anzhi",
    kUUCun      = "uucun",
    k4399       = "4399",
    kCooou      = "cooou",
    kCMGame     = "cmgame",
    kYouKu      = "youku",
    kZTEPre     = "zte_pre",
    kJinli      = "jinli",
    kHEMM       = "hemm",
    kJinliPre   = "jinli_pre",
    kLenovoPre  = "lenovo_pre",
    kDoovPre    = "doov_pre",
    kCoolpadPre = "coolpad_pre",
    k189Store   = "189store",
    kLanYue     = "lanyue",
    kLiQu       = "liqu",
    kPaoJiao    = "paojiao",
    k3533       = "3533",
    kWeiYunJiQu = "weiyunjiqu",
    k3GRoad     = "3groad",
    kSj         = "sj",
    kUC         = "uc",
    kLenovoGame = "lenovogame",
    kSina       = "sina",
    kMobileMM   = "mobilemm",
    kAndroidMM  = "androidmm",
    kSpringMM   = "springmm",
    kSogou      = "sogou",
    kSogouYysc  = "sogouyysc",
    kSogouYxdt  = "sogouyxdt",
    kSogouSs    = "sogouss",
    kSogouSrf   = "sogousrf",
    kSogouLlq   = "sogoullq",
    kSogouRC    = "sogourc",
    kLetv       = "letv",
    kVivo       = "vivo",
    kLvAn       = "lvan",
    kHTC        = "htc",
    kMT         = "mt",
    kZY         = "zy",
    kLemon      = "lemon",
    kMZ         = "mz",
    kFeiLiu     = "feiliu",
    k9Bang      = "9bang",
    kDangLe     = "dangle",
    kJJ         = "jj",
    kLeshop     = "leshop",
    kBaidule    = "baidule",
    kSamsung    = "samsung",
    kZm         = "zm",
    kAoruan     = "aoruan",
    kSohu       = "sohu",
    kYiwan      = "yiwan",
    kDK         = "dk",
    kALI        = "ali",
    kBaiduLemon = "baidulemon",
    kBaiduWifi  = "baiduwifi",
    kPP         = "pp",
    kTF         = "tf",
    kWTWDPre    = "wtwd_pre",
    kZTEMINIPre = "zte_mini_pre",
    kAsusPre    = "asus_pre",
    kIQiYi      = "iqiyi",
    kIQiYiSpgg  = "iqiyispgg",
    kIQiYiSpgl  = "iqiyispgl",
    kIQiYiSpjc  = "iqiyispjc",
    kALIPre  = "ali_pre",
}

PlatformAuthEnum = {
    kGuest  = 0,
    kWeibo  = 1,
    kQQ     = 2,
    kWDJ    = 3,
    kMI     = 4,
    k360    = 5,
    kPhone  = 6,
}

PlatformAuthDetail = {
    [PlatformAuthEnum.kWeibo]   = {
        name="weibo", 
        localization=Localization:getInstance():getText("platform.weibo"),
        },
    [PlatformAuthEnum.kQQ]      = {
        name="qq", 
        localization=Localization:getInstance():getText("platform.qq"),
        },
    [PlatformAuthEnum.kWDJ]     = {
        name="wandoujia", 
        localization=Localization:getInstance():getText("platform.wdj"),
        },
    [PlatformAuthEnum.kMI]      = {
        name="migame", 
        localization=Localization:getInstance():getText("platform.mi"),
        },
    [PlatformAuthEnum.k360]     = {
        name="360", 
        localization=Localization:getInstance():getText("platform.360"),
        },
    [PlatformAuthEnum.kPhone]   = {
        name="phone",
        localization=Localization:getInstance():getText("platform.phone"),
        },
}

TelecomOperators = { 
    NO_SIM          = -1, -- 未插卡
    UNKNOWN         = 0, -- 未知
    CHINA_MOBILE    = 1, -- 中国移动
    CHINA_UNICOM    = 2, -- 中国联通
    CHINA_TELECOM   = 3, -- 中国电信
}

--新加的支付方式 请同步到 http://wiki.happyelements.net/pages/viewpage.action?pageId=20275462 这个文档里
Payments = {
    UNSUPPORT       = 0,
    CHINA_MOBILE    = 1,       -- 移动mm
    CHINA_UNICOM    = 2,
    CHINA_TELECOM   = 3,
    WDJ             = 4,
    QQ              = 5,
    MI              = 6,
    QIHOO           = 7,
    MDO             = 8,    -- 已废弃
    CHINA_MOBILE_GAME = 9,  -- 移动游戏基地
    DUOKU             = 10,
    WECHAT          = 11,
    ALIPAY          = 12,
    WO3PAY          = 13,   --联通CUCCWO 3网计费
    VIVO          = 14,   --VIVO的SDK，默认短代。超限额、或无sim卡则使用第三方支付（包括支付宝，财付通，网银和充值卡）
    WIND_MILL       = 15,   --代表风车币支付(打点需求)
    IOS_RMB         = 16,   --代表IOS的RMB支付(打点需求)
    TELECOM3PAY     = 17,   --电信三网 计费
    ALI_QUICK_PAY   = 18,   --支付宝免密支付
    ALI_SIGN_PAY    = 19,
    WECHAT_QUICK_PAY = 20,
    HUAWEI          = 21,   --华为支付
    QQ_WALLET       = 22,  --qq 钱包
}

PaymentNames = {
    [Payments.UNSUPPORT] = "UNSUPPORT",
    [Payments.CHINA_MOBILE] = "CHINA_MOBILE",
    [Payments.CHINA_UNICOM] = "CHINA_UNICOM",
    [Payments.CHINA_TELECOM] = "CHINA_TELECOM",
    [Payments.WDJ] = "WDJ",
    [Payments.QQ] = "QQ",
    [Payments.MI] = "MI",
    [Payments.QIHOO] = "QIHOO",
    [Payments.MDO] = "MDO",
    [Payments.CHINA_MOBILE_GAME] = "CHINA_MOBILE_GAME",
    [Payments.DUOKU] = "DUOKU",
    [Payments.WECHAT] = "WECHAT",
    [Payments.ALIPAY] = "ALIPAY",
    [Payments.WO3PAY] = "WO3PAY",
    [Payments.VIVO] = "VIVO",
    [Payments.TELECOM3PAY] = "TELECOM3PAY",
    [Payments.HUAWEI] = "HUAWEI",
    [Payments.QQ_WALLET] = "QQ_WALLET",
}
-- 调起sdk前
PaymentsNeedPreOrder = {
    Payments.WDJ,
    Payments.QIHOO,
    Payments.MI,
}

-- 支付方式分组
PlatformPaymentThirdPartyEnum = {
    kUnsupport = Payments.UNSUPPORT,
    kQQ = Payments.QQ,
    kWDJ = Payments.WDJ,
    kMI = Payments.MI,
    k360 = Payments.QIHOO,
    kDUOKU = Payments.DUOKU,
    kWECHAT = Payments.WECHAT,
    kALIPAY = Payments.ALIPAY,
    kALI_QUICK_PAY = Payments.ALI_QUICK_PAY,
    kWO3PAY = Payments.WO3PAY,
    kVIVO = Payments.VIVO,
    kTELECOM3PAY = Payments.TELECOM3PAY,
    kHUAWEI = Payments.HUAWEI,
    kQQ_WALLET = Payments.QQ_WALLET,
}

PlatformPaymentChinaMobileEnum = {
    kUnsupport = Payments.UNSUPPORT,
    kCMCC = Payments.CHINA_MOBILE,
    kCMGAME = Payments.CHINA_MOBILE_GAME,
    kMDO = Payments.MDO,
}

PlatformPaymentChinaUnicomEnum = {
    kUnsupport = Payments.UNSUPPORT,
    kUnicom = Payments.CHINA_UNICOM,
}

PlatformPaymentChinaTelecomEnum = {
    kUnsupport = Payments.UNSUPPORT,
    kTelecom = Payments.CHINA_TELECOM,
}

PlatformShareEnum = {
    kWechat = 1,
    kMiTalk = 2,
    kWeibo = 3,
    k360 = 4,
    kQQ = 5,
}

PlatformPayType = {
    kNormal = 1,
    kWechat = 2,
    kAlipay = 3,
    kVivo = 4,
    kQihoo = 5,
    kWandoujia = 6,
    kQQ = 7,
    kMI = 8,
    kHuaWei = 9,
    kQQWallet = 10,
}

--包里默认有手机登录的平台
AndroidHasPhonePlatformNames = {
    PlatformNameEnum.kTF,
    PlatformNameEnum.kHE,

    PlatformNameEnum.kBaiDuApp,
    PlatformNameEnum.kMZ,
    PlatformNameEnum.kALI,
    PlatformNameEnum.kAnZhi,
    PlatformNameEnum.kWDJ,
    PlatformNameEnum.kCMCCMM,
    PlatformNameEnum.kCoolpad,
    PlatformNameEnum.kLenovoGame,
    PlatformNameEnum.kPP,
    PlatformNameEnum.kLeshop,
    PlatformNameEnum.kAoruan,
    PlatformNameEnum.kSamsung,
    PlatformNameEnum.kJinli,
    PlatformNameEnum.k91,
    PlatformNameEnum.kLenovo,
}

local AndroidPlatformConfigs = {
    kHE = {
        name = PlatformNameEnum.kHE,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY, PlatformPaymentThirdPartyEnum.kQQ_WALLET},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHE_2 = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithoutWeibo = {
        name = nil,
        authConfig = PlatformAuthEnum.kQQ,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kPreMM = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kPreMM_2 = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kCMCCMM = {
        name = PlatformNameEnum.kCMCCMM,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kCMCCMM_2 = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kQQ = {
        name = PlatformNameEnum.kQQ,
        authConfig = PlatformAuthEnum.kQQ,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kQQ},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat, PlatformShareEnum.kQQ }
    },
    kWDJ = {
        name = PlatformNameEnum.kWDJ,
        authConfig = PlatformAuthEnum.kWDJ,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWDJ},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    k360 = {
        name = PlatformNameEnum.k360,
        authConfig = PlatformAuthEnum.k360,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.k360},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        -- shareConfig = { PlatformShareEnum.kWechat, PlatformShareEnum.k360 }
        shareConfig = {PlatformShareEnum.kWechat}
    },
    kMiPad = {
        name = PlatformNameEnum.kMiPad,
        authConfig = PlatformAuthEnum.kMI,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kMI},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kMiTalk = {
        name = PlatformNameEnum.kMiTalk,
        authConfig = PlatformAuthEnum.kMI,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kUnsupport},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kMiTalk }
    },
    kNoNetWorkMode = {
        name = nil,
        authConfig = PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kUnsupport},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kUnsupport }
    },
    kCUCCWO = {
        name = PlatformNameEnum.kCUCCWO,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kWO3PAY },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    k3GRoad = {
        name = PlatformNameEnum.k3GRoad,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kCooou = {
        name = PlatformNameEnum.kCooou,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kCMGame = {
        name = PlatformNameEnum.kCMGame,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithCMGame = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithMDO = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME, PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithMDO_2 = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME, PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEMM = {
        name = PlatformNameEnum.kHEMM,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithoutCM = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },

    kHEWithoutMM = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },

    kHEWithoutCT = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithoutCT_2 = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo, PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kOppo = {
        name = PlatformNameEnum.kOppo,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kUC = {
        name = PlatformNameEnum.kUC,
        authConfig = PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kSj = {
        name = PlatformNameEnum.kSj,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },

    kLeshop = {
        name = PlatformNameEnum.kLeshop,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kMI = {
        name = PlatformNameEnum.kMI,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kMI},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC,PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithout3rdPay = {
        name = nil,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kUnsupport},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHuaWei = {
        name = PlatformNameEnum.kHuaWei,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kHUAWEI},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kVivo = {
        name = PlatformNameEnum.kVivo,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kVIVO},
            chinaMobilePayment = {PlatformPaymentChinaMobileEnum.kUnsupport},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport,
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kQQWithoutWeibo = {
        name = nil,
        authConfig = PlatformAuthEnum.kQQ,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    k189Store = {
        name = PlatformNameEnum.k189Store,
        authConfig = { PlatformAuthEnum.kWeibo,PlatformAuthEnum.kQQ },
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kTELECOM3PAY },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    }
}

-- 派生平台定义, key为派生源头平台的名称, 需要在AndroidPlatformConfigs中预定义
-- 凡带_2,_3的 都是与原本的在三方平台配置上有差异的 如kHE包含三方微信支付宝，而kHE_2只包含微信
local ForkPlatformMap = {
    kHE = { 
        PlatformNameEnum.kCoolpad,
        PlatformNameEnum.kUUCun,
        PlatformNameEnum.kJinShan, 
        PlatformNameEnum.kLetv,
        PlatformNameEnum.kBBK,
        PlatformNameEnum.kHTC,
        PlatformNameEnum.kJinli,
        PlatformNameEnum.kYouKu,
        PlatformNameEnum.kSamsung,
        PlatformNameEnum.kZm,
        PlatformNameEnum.kDangLe,
        PlatformNameEnum.kLemon,
        PlatformNameEnum.kALI,
        PlatformNameEnum.kMZ,
        PlatformNameEnum.kCoolpadPre,
        PlatformNameEnum.kTF,
        PlatformNameEnum.kPP,
        PlatformNameEnum.kSogou,
        PlatformNameEnum.kSogouYysc,
        PlatformNameEnum.kSogouYxdt,
        PlatformNameEnum.kSogouSs,
        PlatformNameEnum.kSogouSrf,
        PlatformNameEnum.kSogouLlq,
        PlatformNameEnum.kSogouRC,
        PlatformNameEnum.kMT,
        PlatformNameEnum.kLenovo, 
        PlatformNameEnum.kLenovoGame,
    },
    kHE_2 = { 
        PlatformNameEnum.kAnZhi,
    },
    kHEWithoutWeibo = {
        PlatformNameEnum.kWTWDPre,
    },
    kPreMM = {  
        PlatformNameEnum.kDoovPre,
    },
    
    kPreMM_2 = {
         
        PlatformNameEnum.kDK,
    },
    kCMCCMM = {
        PlatformNameEnum.kMobileMM,
    },
    kCMCCMM_2 = {
        PlatformNameEnum.kSina,
        PlatformNameEnum.kSpringMM,
        PlatformNameEnum.kAndroidMM, 
        PlatformNameEnum.kLvAn,
        PlatformNameEnum.kFeiLiu,
        PlatformNameEnum.k9Bang,
        PlatformNameEnum.kYiwan,
    },
    kHEWithCMGame = {
        PlatformNameEnum.kZTEPre,
    },
    kHEWithMDO = {
        PlatformNameEnum.kDuoku,
        PlatformNameEnum.k91,
        PlatformNameEnum.kBaiDuApp,
        PlatformNameEnum.kBaiDuTieBa,
        PlatformNameEnum.kJinliPre,
        PlatformNameEnum.kLenovoPre, 
    },
    kHEWithMDO_2 = {
        PlatformNameEnum.kHao123,
    },
    kHEWithoutCT = {
        PlatformNameEnum.kTYD,
    },
    kHEWithoutCT_2 = {
        PlatformNameEnum.k4399,
    },
    kHEWithoutCM = {
        PlatformNameEnum.kLanYue,
        PlatformNameEnum.kPaoJiao,
        PlatformNameEnum.kLiQu,
        PlatformNameEnum.k3533,
        PlatformNameEnum.kWeiYunJiQu,
    },
    kOppo = {
        PlatformNameEnum.kOppo,
    },
    kHEWithout3rdPay = {
        PlatformNameEnum.kJJ,
        PlatformNameEnum.kIQiYi,
        PlatformNameEnum.kIQiYiSpgg,
        PlatformNameEnum.kIQiYiSpgl,
        PlatformNameEnum.kIQiYiSpjc,
    },
    kQQ = {
        PlatformNameEnum.kYYB_CENTER,
        PlatformNameEnum.kYYB_MARKET,
        PlatformNameEnum.kYYB_JINSHAN,
        PlatformNameEnum.kYYB_BROWSER,
        PlatformNameEnum.kYYB_ZONE,
        PlatformNameEnum.kYYB_VIDEO,
        PlatformNameEnum.kYYB_NEWS,
        PlatformNameEnum.kYYB_QQ,
        PlatformNameEnum.kYYB_PC,
        PlatformNameEnum.kYYB_CORE,
        PlatformNameEnum.kYYB_SHOP,
        PlatformNameEnum.kYYB_TMS_CENTER,
        PlatformNameEnum.kYYB_TMS_SHOP,
    },
    kHEWithoutMM ={
        PlatformNameEnum.kBaidule,
        PlatformNameEnum.kAoruan,
        PlatformNameEnum.kSohu,
        PlatformNameEnum.kBaiduLemon, --没有百度sdk,只是他们的一个渠道
        PlatformNameEnum.kBaiduWifi, --没有百度sdk,只是他们的一个渠道
    },
    kQQWithoutWeibo = {
        PlatformNameEnum.kZTEMINIPre,
        PlatformNameEnum.kAsusPre,
        PlatformNameEnum.kALIPre,
    }
}

local IOSPlatformConfigs = {
    kIOS = {
        name = PlatformNameEnum.kIOS,
        authConfig = PlatformAuthEnum.kQQ,
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    }
}

local WP8PlatformConfigs = {
    kWP8 = {
        name = PlatformNameEnum.kWP8,
        authConfig = PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = {}
    }
}

local WIN32PlatformConfigs = {
    kHE = {
        name = PlatformNameEnum.kHE,
        authConfig = PlatformAuthEnum.kGuest,--PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport },
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = {}
    }
}

local NeedPayCheckTable = {
    Payments.WDJ,
    Payments.MI,
    Payments.QIHOO,
    -- Payments.DUOKU,
    Payments.WECHAT,
    Payments.ALIPAY,
    -- Payments.WO3PAY,
    Payments.QQ,
    Payments.HUAWEI,
    Payments.QQ_WALLET,
}

PlatformConfig = {}
local currentPayType = PlatformPayType.kNormal

local function isPlatformLike(pfList, pfName)
    if not pfList or type(pfList) ~= "table" then return false end
    for i,v in ipairs(HE_LIKE) do
        if androidPlatformName == v then
            return true
        end
    end
end

local function initPlatformConfig()
    if __ANDROID then
        local androidPlatformName = StartupConfig:getInstance():getPlatformName()
        print("RRR  initPlatformConfig  androidPlarformName = " .. tostring(androidPlarformName))
        -- 预装包
        if PrepackageUtil:isPreNoNetWork() then 
            PlatformConfig = AndroidPlatformConfigs.kNoNetWorkMode
            PlatformConfig.name = androidPlatformName
            print("RRR  预装包 platform config name: " .. PlatformConfig.name)
            return;
        end
        -- 预定义平台
        for k, v in pairs(AndroidPlatformConfigs) do
            if androidPlatformName == v.name then
                PlatformConfig = v
                print("RRR  预定义平台 platform config name: " .. PlatformConfig.name)
                return
            end
        end
        -- 派生平台, 仅平台名与原始平台不同, 如果存在其他差异则需要在预定义中直接声明平台
        for srcPlatform, forkPlatforms in pairs(ForkPlatformMap) do
            if table.includes(forkPlatforms, androidPlatformName) then
                PlatformConfig = AndroidPlatformConfigs[srcPlatform]
                PlatformConfig.name = androidPlatformName
                print("RRR  派生平台 platform config name: " .. PlatformConfig.name .. " fork from: " .. srcPlatform)
                return
            end
        end
        print("RRR  缺少的默认HE_LIKE platform config name: " .. tostring(androidPlarformName) )
        -- 缺少的默认HE_LIKE
        PlatformConfig = AndroidPlatformConfigs.kHE
        PlatformConfig.name = androidPlatformName
    elseif __IOS then
        PlatformConfig = IOSPlatformConfigs.kIOS
    elseif __WP8 then
        PlatformConfig = WP8PlatformConfigs.kWP8
    else
        PlatformConfig = WIN32PlatformConfigs.kHE
    end
end

initPlatformConfig()


-- 添加手机登录配置
function PlatformConfig:setPhonePlatformAuth( ... )
    if __ANDROID and PrepackageUtil:isPreNoNetWork() then 
        return 
    end
    if type(self.authConfig) == "table" then
        table.insertIfNotExist(self.authConfig,PlatformAuthEnum.kPhone)
    elseif self.authConfig == PlatformAuthEnum.kGuest then
        self.authConfig = { PlatformAuthEnum.kPhone }
        _G.kDeviceID = UdidUtil:getUdid() --这种情况默认会是游客,的重新获取下
    elseif self.authConfig ~= PlatformAuthEnum.kPhone then
        self.authConfig = { self.authConfig,PlatformAuthEnum.kPhone }
    end
end

function PlatformConfig:isPlatform(platformName)
    assert(platformName)
    return self.name == platformName
end

function PlatformConfig:isAuthConfig(authConfig)
    assert(authConfig)
    return self.authConfig == authConfig
end

function PlatformConfig:hasAuthConfig(authConfig)
    assert(authConfig) 
    if type(self.authConfig) == "table" then
        for _,v in pairs(self.authConfig) do
            if v == authConfig then 
                return true
            end
        end
        return false
    else
       return self.authConfig == authConfig
    end
end

function PlatformConfig:isMultipleAuthConfig( ... )
    return type(self.authConfig) == "table" and #self.authConfig > 1
end

function PlatformConfig:getAuthConfigs( ... )
    if type(self.authConfig) == "table" then 
        return self.authConfig
    else
        return { self.authConfig }
    end
end

function PlatformConfig:isBaiduPlatform()
    return self:isPlatform(PlatformNameEnum.kDuoku) or self:isPlatform(PlatformNameEnum.k91) or self:isPlatform(PlatformNameEnum.kBaiDuApp) or self:isPlatform(PlatformNameEnum.kHao123) or self:isPlatform(PlatformNameEnum.kBaiDuTieBa)
end

function PlatformConfig:isQQPlatform()
    return self:isPlatform(PlatformNameEnum.kQQ) 
        or self:isPlatform(PlatformNameEnum.kYYB_CENTER) 
        or self:isPlatform(PlatformNameEnum.kYYB_MARKET) 
        or self:isPlatform(PlatformNameEnum.kYYB_JINSHAN) 
        or self:isPlatform(PlatformNameEnum.kYYB_BROWSER) 
        or self:isPlatform(PlatformNameEnum.kYYB_ZONE) 
        or self:isPlatform(PlatformNameEnum.kYYB_VIDEO) 
        or self:isPlatform(PlatformNameEnum.kYYB_NEWS)
        or self:isPlatform(PlatformNameEnum.kYYB_QQ)
        or self:isPlatform(PlatformNameEnum.kYYB_PC)
        or self:isPlatform(PlatformNameEnum.kYYB_CORE)
        or self:isPlatform(PlatformNameEnum.kYYB_SHOP)
        or self:isPlatform(PlatformNameEnum.kYYB_TMS_CENTER)
        or self:isPlatform(PlatformNameEnum.kYYB_TMS_SHOP)

end

function PlatformConfig:isJJPlatform( )
    -- body
    return self:isPlatform(PlatformNameEnum.kJJ)
    -- return true
end

function PlatformConfig:isCUCCWOPlatform( )
    -- body
    return self:isPlatform(PlatformNameEnum.kCUCCWO)
    -- return true
end

function PlatformConfig:isCMPaymentSwitchable()
    if type(self.paymentConfig.chinaMobilePayment) == "table" 
        and table.includes(self.paymentConfig.chinaMobilePayment, PlatformPaymentChinaMobileEnum.kCMCC)
        and table.includes(self.paymentConfig.chinaMobilePayment, PlatformPaymentChinaMobileEnum.kCMGAME) then
        return true
    end
    return false
end

function PlatformConfig:getPlatformAuthDetail( authorType )
    local authDetail = nil
    if authorType then
        authDetail = PlatformAuthDetail[authorType]
    elseif SnsProxy and SnsProxy:getAuthorizeType() then -- use default authorize type
        authDetail = PlatformAuthDetail[SnsProxy:getAuthorizeType()]
    end
    return authDetail
end

function PlatformConfig:getPlatformNameLocalization(authorType)
    if self:isPlatform(PlatformNameEnum.kMiTalk) then
        return Localization.getInstance():getText("platform.mitalk")
    end
    
    local authDetail = self:getPlatformAuthDetail(authorType)
    if authDetail and authDetail.localization then 
        return authDetail.localization 
    else return "" end
end

function PlatformConfig:getPlatformAuthName( authorType )
    local authDetail = self:getPlatformAuthDetail(authorType)
    if authDetail and authDetail.name then 
        return authDetail.name 
    else return nil end
end

function PlatformConfig:setCurrentPayType(payType)
    currentPayType = payType or PlatformPayType.kNormal
end

function PlatformConfig:getCurrentPayType()
    return currentPayType
end

--是否支持大额支付
function PlatformConfig:isBigPayPlatform()
    if (PlatformConfig:isPlatform(PlatformNameEnum.kMiPad)
        -- or PlatformConfig:isPlatform(PlatformNameEnum.kWDJ)    
        -- or PlatformConfig:isPlatform(PlatformNameEnum.k360) 
        -- or PlatformConfig:isQQPlatform()
        -- or PlatformConfig:isBaiduPlatform()
        or PlatformConfig:isPlatform(PlatformNameEnum.kVivo)
        ) then
        return true
    end
    return false
end

function PlatformConfig:isNeedOrderSuccessCheck(paymentsType)
    if table.includes(NeedPayCheckTable,paymentsType) then
        return true
    end
    return false
end

function PlatformConfig:getLastPlatformAuthName()
    local lastLoginUserData = Localhost:readLastLoginUserData()
    local name = nil
    if lastLoginUserData and lastLoginUserData.authorType then
        local authDetail = PlatformAuthDetail[lastLoginUserData.authorType]
        if authDetail then name = authDetail.name end
    end
    return name
end

function PlatformConfig:getLastPlatformAuthType( ... )
    local lastLoginUserData = Localhost:readLastLoginUserData()
    if lastLoginUserData and lastLoginUserData.authorType then
        return lastLoginUserData.authorType
    end
    return nil
end

function PlatformConfig:getLoginTypeName()
    local lastLoginUserData = Localhost:readLastLoginUserData()
    local name = "guest"
    if lastLoginUserData and lastLoginUserData.authorType then
        local authDetail = PlatformAuthDetail[lastLoginUserData.authorType]
        if authDetail then name = authDetail.name end
    end
    return name
end

if __ANDROID and table.includes(AndroidHasPhonePlatformNames,PlatformConfig.name) then
    PlatformConfig:setPhonePlatformAuth()
end

if __WP8 then
    PlatformConfig:setPhonePlatformAuth()
end

-- if __WIN32 then
--     PlatformConfig:setPhonePlatformAuth()
-- end


-- 小米设备才有小米支付
if __ANDROID and (PlatformConfig:isPlatform(PlatformNameEnum.kMI) or PlatformConfig:isPlatform(PlatformNameEnum.kMiPad)) then
    pcall(function( ... )
        local MainActivity = luajava.bindClass("com.happyelements.hellolua.MainActivity")
        if not MainActivity:isXiaomi() then
            if PlatformConfig:isPlatform(PlatformNameEnum.kMI) then 
                PlatformConfig.paymentConfig.thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kWECHAT }
            else
                PlatformConfig.paymentConfig.thirdPartyPayment = { PlatformPaymentThirdPartyEnum.kUnsupport }
            end
        end
    end)
end