PlatformNameEnum = {
    kHE         = "he",   
    kQQ         = "yingyongbao",
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
}

PlatformAuthEnum = {
    kGuest  = 0,
    kWeibo  = 1,
    kQQ     = 2,
    kWDJ    = 3,
    kMI     = 4,
    k360    = 5,
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
}

TelecomOperators = { 
    NO_SIM          = -1, -- 未插卡
    UNKNOWN         = 0, -- 未知
    CHINA_MOBILE    = 1, -- 中国移动
    CHINA_UNICOM    = 2, -- 中国联通
    CHINA_TELECOM   = 3, -- 中国电信
}

Payments = {
    UNSUPPORT       = 0,
    CHINA_MOBILE    = 1,       -- 移动mm
    CHINA_UNICOM    = 2,
    CHINA_TELECOM   = 3,
    WDJ             = 4,
    QQ              = 5,
    MI              = 6,
    QIHOO           = 7,
    MDO             = 8,
    CHINA_MOBILE_GAME = 9,  -- 移动游戏基地
    DUOKU             = 10,
    WECHAT          = 11,
    ALIPAY          = 12,
    WO3PAY          = 13,   --联通CUCCWO 3网计费
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
    kWO3PAY = Payments.WO3PAY,
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
}

PlatformPayType = {
    kNormal = 1,
    kWechat = 2,
    kAlipay = 3,
}

local AndroidPlatformConfigs = {
    kHE = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kPreMM = {
        name = PlatformNameEnum.kHE,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kCMCCMM = {
        name = PlatformNameEnum.kCMCCMM,
        authConfig = PlatformAuthEnum.kWeibo,
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
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kWDJ = {
        name = PlatformNameEnum.kWDJ,
        authConfig = PlatformAuthEnum.kWDJ,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWDJ, PlatformPaymentThirdPartyEnum.kWECHAT},
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
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.k360, PlatformPaymentThirdPartyEnum.kWECHAT},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME},
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat, PlatformShareEnum.k360 }
    },
    kMiPad = {
        name = PlatformNameEnum.kMiPad,
        authConfig = PlatformAuthEnum.kMI,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kMI, PlatformPaymentThirdPartyEnum.kWECHAT},
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
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
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
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWO3PAY, PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    k3GRoad = {
        name = PlatformNameEnum.k3GRoad,
        authConfig = PlatformAuthEnum.kWeibo,
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
        authConfig = PlatformAuthEnum.kWeibo,
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
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithCMGame = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithMDO = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kDUOKU},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEMM = {
        name = PlatformNameEnum.kHEMM,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithoutCM = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kHEWithoutCT = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC, PlatformPaymentChinaMobileEnum.kCMGAME },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kOppo = {
        name = PlatformNameEnum.kOppo,
        authConfig = PlatformAuthEnum.kWeibo,
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
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kWECHAT, PlatformPaymentThirdPartyEnum.kALIPAY},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
    kSj = {
        name = nil,
        authConfig = PlatformAuthEnum.kWeibo,
        paymentConfig = {
            thirdPartyPayment = {PlatformPaymentThirdPartyEnum.kUnsupport},
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kCMCC },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnicom,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kTelecom
        },
        shareConfig = { PlatformShareEnum.kWechat }
    },
}

-- 派生平台定义, key为派生源头平台的名称, 需要在AndroidPlatformConfigs中预定义
local ForkPlatformMap = {
    kHE = { 
        PlatformNameEnum.kHuaWei, 
        PlatformNameEnum.kLenovo, 
        PlatformNameEnum.kCoolpad,
        PlatformNameEnum.kAnZhi,
        PlatformNameEnum.kUUCun,
        PlatformNameEnum.kJinli,
        PlatformNameEnum.kYouKu,
        PlatformNameEnum.kJinShan,
        PlatformNameEnum.kMI,
        PlatformNameEnum.kLenovoGame,
    },
    kPreMM = {
        PlatformNameEnum.kJinliPre, 
        PlatformNameEnum.kLenovoPre,   
        PlatformNameEnum.kDoovPre, 
        PlatformNameEnum.kSina, 
    },
    kHEWithCMGame = {
        PlatformNameEnum.kZTEPre,
        PlatformNameEnum.k189Store,
    },
    kHEWithMDO = {
        PlatformNameEnum.kDuoku,
        PlatformNameEnum.k91,
        PlatformNameEnum.kBaiDuApp,
        PlatformNameEnum.kBaiDuTieBa,
        PlatformNameEnum.kHao123,
    },
    kHEWithoutCT = {
        PlatformNameEnum.kBBK,
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
}

local IOSPlatformConfigs = {
    kHE = {
        name = PlatformNameEnum.kHE,
        authConfig = PlatformAuthEnum.kQQ,
        paymentConfig = {
            thirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport,
            chinaMobilePayment = { PlatformPaymentChinaMobileEnum.kUnsupport },
            chinaUnicomPayment = PlatformPaymentChinaUnicomEnum.kUnsupport,
            chinaTelecomPayment = PlatformPaymentChinaTelecomEnum.kUnsupport
        },
        shareConfig = { PlatformShareEnum.kWechat }
    }
}

local WP8PlatformConfigs = {
    kHE = {
        name = PlatformNameEnum.kHE,
        authConfig = PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport,
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
        authConfig = PlatformAuthEnum.kGuest,
        paymentConfig = {
            thirdPartyPayment = PlatformPaymentThirdPartyEnum.kUnsupport,
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
}

PlatformConfig = {}
local currentPayType = PlatformPayType.kNormal

local function isPlatformLike(pfList, pfName)
    if not pfList or type(pfList) ~= "table" then return false end
    for i,v in ipairs(HE_LIKE) do
        if androidPlarformName == v then
            return true
        end
    end
end

local function initPlatformConfig()
    if __ANDROID then
        local androidPlarformName = StartupConfig:getInstance():getPlatformName()

        -- 预装包
        if PrepackageUtil:isPreNoNetWork() then 
            PlatformConfig = AndroidPlatformConfigs.kNoNetWorkMode
            PlatformConfig.name = androidPlarformName
            return;
        end
        -- 预定义平台
        for k, v in pairs(AndroidPlatformConfigs) do
            if androidPlarformName == v.name then
                PlatformConfig = v
                print("platform config name: " .. PlatformConfig.name)
                return
            end
        end
        -- 派生平台, 仅平台名与原始平台不同, 如果存在其他差异则需要在预定义中直接声明平台
        for srcPlatform, forkPlatforms in pairs(ForkPlatformMap) do
            if table.includes(forkPlatforms, androidPlarformName) then
                PlatformConfig = AndroidPlatformConfigs[srcPlatform]
                PlatformConfig.name = androidPlarformName
                print("platform config name: " .. PlatformConfig.name .. " fork from: " .. srcPlatform)
                return
            end
        end

        -- 缺少的默认HE_LIKE
        PlatformConfig = AndroidPlatformConfigs.kHE
        PlatformConfig.name = androidPlarformName
    elseif __IOS then
        PlatformConfig = IOSPlatformConfigs.kHE
    elseif __WP8 then
        PlatformConfig = WP8PlatformConfigs.kHE
    else
        PlatformConfig = WIN32PlatformConfigs.kHE
    end
end

initPlatformConfig()

function PlatformConfig:isPlatform(platformName)
    assert(platformName)
    return self.name == platformName
end

function PlatformConfig:isAuthConfig(authConfig)
    assert(authConfig)
    return self.authConfig == authConfig
end

function PlatformConfig:isBaiduPlatform()
    return self:isPlatform(PlatformNameEnum.kDuoku) or self:isPlatform(PlatformNameEnum.k91) or self:isPlatform(PlatformNameEnum.kBaiDuApp) or self:isPlatform(PlatformNameEnum.kHao123) or self:isPlatform(PlatformNameEnum.kBaiDuTieBa)
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
    if (PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) 
        or PlatformConfig:isPlatform(PlatformNameEnum.kQQ) 
        or PlatformConfig:isPlatform(PlatformNameEnum.k360) 
        or PlatformConfig:isPlatform(PlatformNameEnum.kMiPad)
        or PlatformConfig:isBaiduPlatform()) then
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