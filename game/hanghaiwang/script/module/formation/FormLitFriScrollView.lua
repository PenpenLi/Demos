-- FileName: FormLitFriScrollView.lua 
-- Author: zhaoqiangjun 
-- Date: 14-6-13 
-- Purpose: function description of module

module("FormLitFriScrollView", package.seeall)

require "script/module/formation/FormationUtil"
require "script/module/formation/MainFormationTools"
require "script/module/public/UIHelper"
require "script/model/hero/HeroModel"
require "script/battle/data/db_hero_offset_util"
require "script/libs/LuaCCLabel"

local SHOW_SELF_SQUAD   = 11000
local SHOW_THEM_SQUAD   = 11001

local m_tabLitFriend			--阵容伙伴数据
local m_tabBench            --替补数据
local m_litFriShowType 			--现实的伙伴的类型
local m_litFriHeroOpenForm      --阵容上伙伴开放的位置
local m_benchOpen               --替补上开放的位置
local m_litFriName              --阵容伙伴的主角名字
local m_externHero              --伙伴的信息
local m_tabjiban                --伙伴羁绊的数量。
local curheroHid                --当前的伙伴
local headAnchor = ccp(0.5, 0)
local btnJibanInfo
local btnFormView

local layTabView    
local imgFormTitle  

local layFormView   
local imgFormation  
local imgFormJIban  
local labnJibanNum

local m_litFriScrollView
local m_litFriLayer

local SHOW_SELF_SQUAD   = 11000
local SHOW_THEM_SQUAD   = 11001

local showForm

local SHOW_FROM_INFO    = 10000     --阵型信息
local SHOW_JIBN_INFO    = 10001     --羁绊效果

local littleUnactiveInfoColor  = ccc3( 0xb2, 0xb2, 0xb2)
local littleUnactiveNameColor  = ccc3( 0xae, 0x95, 0x93)
local littleOpenUnionInfoColor = ccc3( 0xfa, 0xdc, 0x63)
local littleOpenUnionNameColor = ccc3( 0xff, 0xf6, 0x00)

local jibanScrollHeight
local m_i18n = gi18n

local getWidgetByName = g_fnGetWidgetByName
local m_showWidth = 400

local addJibanNum       --增加的羁绊数量.
local curActiveUnion    = {}    --当前激活的羁绊.
local befActiveUnion    = {}    --之前激活的羁绊.

local function getNameByHeroInfo(heroId,heroDBInfo)
	local name
   	if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or 
   		((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        name = m_litFriName
    else
        name = heroDBInfo.name
    end
    return name
end

local function getHeroLinkInfo( linkGroup,herohid,heroInfo )
    local heroLinkGroupInfo
    if m_litFriShowType     == SHOW_SELF_SQUAD then
        heroLinkGroupInfo   = FormationUtil.parseHeroUnionProfit(herohid, linkGroup)
    elseif m_litFriShowType == SHOW_THEM_SQUAD then
        logger:debug("m_externHero:")
        logger:debug(m_externHero)
        heroLinkGroupInfo   = FormationUtil.parseOtherHeroUnionProfit(herohid, linkGroup ,heroInfo ,m_externHero)
    end

    return heroLinkGroupInfo
end
--获得返回的羁绊信息
function getBefCurLinkInfo( ... )
    return befActiveUnion,curActiveUnion
end

-- 将当前羁绊放到之前羁绊表，并去掉当前的激活羁绊
local function removeAllCurLinkInfo( ... )
    befActiveUnion = {}

    for pos,linkInfo in ipairs(curActiveUnion) do
        table.insert(befActiveUnion,linkInfo)
    end

    curActiveUnion = {}
end

local function showHeroLinkInfoOnScrollView( heroLinkGroupInfo )

    local heroActive = 0
    for index = #heroLinkGroupInfo , 1, -1 do

        local linkInfo      = heroLinkGroupInfo[index]

        local isUnionActive = linkInfo.isActive

        local linkGroupName = linkInfo.dbInfo.union_arribute_name or " "
        local linkGroupDesc = linkInfo.dbInfo.union_arribute_desc or " "

        local linkNameColor =  linkInfo.isActive and littleOpenUnionNameColor or littleUnactiveNameColor
        local linkDescColor =  linkInfo.isActive and littleOpenUnionInfoColor or littleUnactiveInfoColor

        local labLinkGroupDesc = nil
        local pHeight = 0
        if(not linkInfo.showNames or #linkInfo.showNames == 0) then
            labLinkGroupDesc = LuaCCLabel.createMultiLineLabel(
                {text=linkGroupDesc, fontsize=22, color=linkDescColor, width=m_showWidth})
            labLinkGroupDesc:setAnchorPoint(ccp(0, 0))
            labLinkGroupDesc:setPosition(ccp(130, jibanScrollHeight))
            m_litFriLayer:addChild(labLinkGroupDesc)
            pHeight = labLinkGroupDesc:getContentSize().height
        else
            labLinkGroupDesc = LuaCCLabel.createMultiLineLabel(
                {text="", fontsize=22, color=linkDescColor, width=m_showWidth})

            local pStr = ""
            local pCol = {}
            for i=1 , #linkInfo.showNames do
                pStr = UIHelper.concatString({pStr,linkInfo.showNames[i]})
                local pC = linkDescColor
                if(linkInfo.showColors[i]) then
                    pC = littleOpenUnionInfoColor
                end
                table.insert(pCol,{color = pC})
                if(i ~= #linkInfo.showNames) then
                    pStr = UIHelper.concatString({pStr,"、"})
                    table.insert(pCol,{color = linkDescColor})
                end
            end
            local richStr =  UIHelper.concatString({pStr,linkGroupDesc})
            table.insert(pCol,{color = linkDescColor})
            textInfo = {
            richStr, pCol
            }
            local richText = BTRichText.create(textInfo, nil)
            richText:setSize(CCSizeMake(390,0))
            labLinkGroupDesc:addChild(richText)
            richText:visit()
            pHeight = richText:getTextHeight()

            labLinkGroupDesc:setPosition(ccp(130, jibanScrollHeight + pHeight))
            m_litFriLayer:addChild(labLinkGroupDesc)
        end

        --加上行高
        jibanScrollHeight = jibanScrollHeight + pHeight

        local lablinkGroupName  = LuaCCLabel.createMultiLineLabel(
            {text=linkGroupName, fontsize=22, color=linkNameColor, width=m_showWidth})
        lablinkGroupName:setAnchorPoint(ccp(0, 1))
        lablinkGroupName:setPosition(ccp(30, jibanScrollHeight))
        m_litFriLayer:addChild(lablinkGroupName, 2)
        
        local spriteStr
        if (linkInfo.isActive) then
            spriteStr = "ui/gold.png"
            heroActive = heroActive + 1
            table.insert(curActiveUnion,linkInfo)
        else
            spriteStr = "ui/gold.png"
        end

        local linkNSprite = CCSprite:create(spriteStr)
        linkNSprite:setAnchorPoint(ccp(0,1.0))
        linkNSprite:setPosition(ccp(24, jibanScrollHeight + 2))
        m_litFriLayer:addChild(linkNSprite, 1)

        jibanScrollHeight = jibanScrollHeight + 12
    end
    m_tabjiban[curheroHid ..""] = heroActive
end

--[[desc:功能简介
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
local function fnAddJibanInfo( heroInfo)
    if(not heroInfo) then
        return
    end

    local heroHtid = tonumber(heroInfo.htid)
    require "db/DB_Heroes"
    local heroDBInfo = DB_Heroes.getDataById(heroHtid)
    local heroNameStr = getNameByHeroInfo(heroHtid,heroDBInfo)

    local heroColor = g_QulityColor2[heroDBInfo.star_lv]
    local heroNameColor = heroColor

    --显示羁绊信息
    local linkGroup = heroDBInfo.link_group1
    local herohid = heroInfo.hid
    local heroLinkGroupInfo = getHeroLinkInfo( linkGroup,herohid,heroInfo )

    local imgHegit = jibanScrollHeight
    --有羁绊显示伙伴的羁绊
    curheroHid = herohid
    if table.count(heroLinkGroupInfo) > 0 then
        showHeroLinkInfoOnScrollView(heroLinkGroupInfo)
    --没有羁绊时显示该伙伴没有羁绊
    else
        m_tabjiban[curheroHid ..""] = 0
        local lablinkGroupName  = UIHelper.createUILabel(m_i18n[1215] , nil , 22 , littleUnactiveInfoColor , nil , kCCTextAlignmentCenter)
        lablinkGroupName:setAnchorPoint(ccp(0.5,0.5))
        local pX = m_litFriLayer:getContentSize().width*0.5
        local ppsize = lablinkGroupName:getContentSize()
        lablinkGroupName:setPosition(ccp(pX - ppsize.width*0.35, jibanScrollHeight + ppsize.height*0.5 - 5))
        m_litFriLayer:addChild(lablinkGroupName)
        jibanScrollHeight = jibanScrollHeight + lablinkGroupName:getContentSize().height
    end

    local jibanHeight = jibanScrollHeight - imgHegit
    --添加形变的Sprite
    local jibanBgSprite = CCScale9Sprite:create("ui/gold.png", CCRectMake(0,0,24,24),CCRectMake(8,8,8,8))
    jibanBgSprite:setPreferredSize(CCSizeMake(m_litFriScrollView:getViewSize().width,jibanHeight + 10))
    jibanBgSprite:setAnchorPoint(ccp(0.5, 1.0))
    jibanBgSprite:setPosition(m_litFriScrollView:getViewSize().width*0.5, jibanScrollHeight)
    m_litFriLayer:addChild(jibanBgSprite)
    --左右图片显示的位置。
    local lineSprite    = CCSprite:create("ui/gold.png")
    lineSprite:setAnchorPoint(ccp(0.5, 0))
    lineSprite:setPosition(ccp(m_litFriScrollView:getViewSize().width/2, jibanScrollHeight + 12))
    m_litFriLayer:addChild(lineSprite)

    jibanScrollHeight = jibanScrollHeight + 50

    local labHeroName   = CCLabelTTF:create(heroNameStr or "", g_sFontPangWa or g_FontInfo.name, g_tbFontSize.title or g_tbFontSize.normal) -- 默认方正简黑
    labHeroName:setFontFillColor(heroNameColor or ccc3(0,0,0)) -- 默认黑色
    labHeroName:setAnchorPoint(ccp(0.5, 1))
    labHeroName:setPosition(ccp(m_litFriScrollView:getViewSize().width/2, jibanScrollHeight-10))
    m_litFriLayer:addChild(labHeroName)

    jibanScrollHeight = jibanScrollHeight + 10

end

--倒着往上面添加从最后一个伙伴的最后一个羁绊开始添加
local function showScrollViewData( )
    removeAllCurLinkInfo()
    jibanScrollHeight = jibanScrollHeight + 12

    for index = m_benchOpen, 1 , -1 do
        local heroInfo = m_tabBench[index]
        fnAddJibanInfo(heroInfo)
    end

	for index = m_litFriHeroOpenForm, 1 , -1 do
        local heroInfo = m_tabLitFriend[index]
        fnAddJibanInfo(heroInfo)
	end


    m_litFriScrollView:setContentSize(CCSizeMake(m_litFriScrollView:getContentSize().width, jibanScrollHeight))
    m_litFriScrollView:setContentOffset(ccp(0, -jibanScrollHeight+m_litFriScrollView:getViewSize().height),false)
end

local function showFormView( )
    if (showForm == SHOW_FROM_INFO) then
        layFormView:setVisible(true)
        imgFormation:setVisible(true)
        imgFormJIban:setVisible(true)
        labnJibanNum:setVisible(true)
        btnFormView:setVisible(false)
        btnFormView:setTouchEnabled(false)

        layTabView:setVisible(false)
        imgFormTitle:setVisible(false)
        btnJibanInfo:setVisible(true)
        btnJibanInfo:setTouchEnabled(true)
    elseif(showForm == SHOW_JIBN_INFO) then
        layFormView:setVisible(false)
        imgFormation:setVisible(false)
        imgFormJIban:setVisible(false)
        labnJibanNum:setVisible(false)
        btnFormView:setVisible(true)
        btnFormView:setTouchEnabled(true)

        layTabView:setVisible(true)
        imgFormTitle:setVisible(true)
        btnJibanInfo:setVisible(false)
        btnJibanInfo:setTouchEnabled(false)
    end
end

local function getHeroName(heroInfo)
    require "script/model/user/UserModel"

    local heroname

    local heroId = heroInfo.model_id
    if ((tonumber(heroId) < 20003 and tonumber(heroId)>20000) or ((tonumber(heroId) > 20100 and tonumber(heroId) < 20211))) then
        heroname = UserModel.getUserName()
    else
        heroname = heroInfo.name
    end

    return heroname
end

function getHeroHeadImgAndOffset( herohid )
    require "script/model/hero/HeroModel"
    local heroInfo = HeroModel.getHeroByHid(herohid)
    local herotid = heroInfo.htid
    local heroData = DB_Heroes.getDataById(herotid)

    local heroOffset = db_hero_offset_util.getHeroImgOffset(heroData.action_module_id)

    return "images/base/hero/action_module/" .. heroData.action_module_id ,heroOffset
end


function refreshFormView( ... )
    if(not m_litFriScrollView) then
        return
    end
    local formData = nil
    if(not m_externHero) then
        formData = DataCache.getFormationInfo()
    else
        formData = m_externHero.squad
    end

    local jibanSum = 0
    for i = 1, 6 do
        local heroHid
        if(not m_externHero) then
            heroHid = formData[(i-1) ..""] or 0
        else
            heroHid = formData[i..""] or 0
        end
        local layPartner    = getWidgetByName(layFormView, "LAY_ZHENXING".. i)
        local labFormName   = getWidgetByName(layPartner, "TFD_PARTNER_NAME")
        local labnJibanNum  = getWidgetByName(layPartner, "LABN_JIBAN_NUM")
        local labnTransfer  = getWidgetByName(layPartner, "LABN_TRANSFER_NUM")
        local imgHead   = getWidgetByName(layPartner, "IMG_HERO")
        if(tonumber(heroHid) == 0 or (tonumber(heroHid) == -1))then
            labnTransfer:setStringValue(0)
            labnJibanNum:setStringValue(0)
            labFormName:setText("")
            imgHead:setVisible(false)
        else
            local heroInfo  = HeroModel.getHeroByHid(heroHid)
            local herotid   = heroInfo.htid
            local heroData  = DB_Heroes.getDataById(herotid)

            local heroNameColor = g_QulityColor[heroData.star_lv] or ccc3{255, 255, 255}
            local heroname  = getHeroName(heroData)
            local herotransfer  = heroInfo.evolve_level
            local heroImg, heroOff  = getHeroHeadImgAndOffset(heroHid)
            logger:debug("heroHid:".. heroHid)
            local JibanNum = m_tabjiban[heroHid ..""] or 0
            jibanSum = jibanSum + JibanNum
            labnTransfer:setStringValue(herotransfer)
            labnJibanNum:setStringValue(JibanNum)
            labFormName:setText(heroname)
            labFormName:setColor(heroNameColor)
            imgHead:setVisible(true)
            imgHead:loadTexture(heroImg)
            --换位置

            local imgSize   = imgHead:getContentSize()
            imgHead:setAnchorPoint(ccp(headAnchor.x - heroOff[1]/imgSize.width, headAnchor.y - heroOff[2]/imgSize.height))
        end
    end

    local pBenchData = nil
    if(not m_externHero) then
        pBenchData = DataCache.getBench()
    else
        pBenchData = m_externHero.arrBench
    end
    for i = 1, 3 do
        local heroHid
        if(not m_externHero) then
            heroHid = pBenchData[(i-1) ..""] or 0
        else
            heroHid = pBenchData[i..""].hid or 0
        end
        if(tonumber(heroHid) ~= 0) then
            local JibanNum = m_tabjiban[heroHid ..""] or 0
            jibanSum = jibanSum + JibanNum
        end
    end

    local originNum = labnJibanNum:getStringValue()
    addJibanNum = tonumber(jibanSum) - tonumber(originNum) --增加的羁绊数量
    labnJibanNum:setStringValue(jibanSum)
end

function getAddJibanNum( ... )
    return addJibanNum
end

local function createScrollView( layTabView )
    jibanScrollHeight = 0

    local litFriScrollSize  = CCSizeMake(layTabView:getContentSize().width, layTabView:getContentSize().height)

    m_litFriScrollView      = CCScrollView:create()
    m_litFriScrollView:setViewSize(litFriScrollSize)
    m_litFriScrollView:setTouchPriority(-100)            --提高了优先级，因为TouchGroup的触摸优先级为0，这样设置可以让ScrollView首先响应。
    m_litFriScrollView:setContentSize(litFriScrollSize)
    m_litFriScrollView:setDirection(kCCScrollViewDirectionVertical)
    m_litFriScrollView:setPosition(ccp(0,0))
    m_litFriScrollView:setTouchEnabled(true)
    layTabView:addNode(m_litFriScrollView)

    m_litFriLayer = CCLayer:create()
    m_litFriLayer:setPosition(0, 0)
    m_litFriScrollView:addChild(m_litFriLayer)

    showScrollViewData()
end

function refreshScrollView( _allSquadData , _allBenchData)
    if(not m_litFriScrollView) then
        return
    end
    local allSquadData = _allSquadData
    local allBenchData = _allBenchData
    if(m_litFriShowType == SHOW_SELF_SQUAD) then
        if(not allSquadData) then
            allSquadData = DataCache.getSquad()
        end
        if(not allBenchData) then
            allBenchData = DataCache.getBench()
        end
    end

    logger:debug("refreshScrollView")
    if(m_litFriLayer) then
        m_litFriLayer:removeAllChildrenWithCleanup(true)
    end
    jibanScrollHeight = 0

    local tbLitFriend = {}
    tbLitFriend.heroOpenForm    = m_litFriHeroOpenForm
    tbLitFriend.benchOpen       = m_benchOpen
    tbLitFriend.squadType       = m_litFriShowType
    tbLitFriend.litFriendData   = allSquadData
    tbLitFriend.benchData       = allBenchData
    tbLitFriend.uname           = m_litFriName


    require "script/module/formation/FormLitFriCtrl"
    m_tabLitFriend , m_tabBench     = FormLitFriCtrl.getDataResource(tbLitFriend)
    -- m_litFriScrollView:setEnabled(true)
    showScrollViewData()

    refreshFormView()
end

function fnShowJiBan( ... )
    showForm = SHOW_JIBN_INFO
    MainFormationTools.fnSetLinkNumberTrue()
    showFormView()
end

function cleanScrollView( ... )
    m_litFriScrollView = nil
    m_litFriLayer = nil
end

function createFormLitFriend( tabLitFriend, layLitFriend)
    m_tabjiban = {}
	require "script/module/formation/FormLitFriCtrl"
	m_tabLitFriend,m_tabBench  = FormLitFriCtrl.getDataResource(tabLitFriend)
	m_litFriShowType	= tabLitFriend.squadType
    m_litFriHeroOpenForm= tabLitFriend.heroOpenForm
    m_benchOpen         = tabLitFriend.benchOpen
    m_litFriName        = tabLitFriend.uname
    if m_litFriShowType == SHOW_THEM_SQUAD then
        m_externHero    = tabLitFriend.externHero
    else
        m_externHero = nil
    end
    showForm = SHOW_FROM_INFO   --默认初始化显示阵型信息
    --切换羁绊效果或者阵型信息
    btnJibanInfo  = getWidgetByName(layLitFriend,"BTN_JIBAN_INFORMATION")
    btnJibanInfo:addTouchEventListener(
                function ( sender, eventType )
                    if (eventType == TOUCH_EVENT_ENDED) then
                        AudioHelper.playCommonEffect()
                        showForm = SHOW_JIBN_INFO
                        MainFormationTools.fnSetLinkNumberTrue()
                        logger:debug("Jiban")
                        showFormView()
                    end
                end)
    btnFormView   = getWidgetByName(layLitFriend,"BTN_PARTNER")
    btnFormView:addTouchEventListener(
                function ( sender, eventType )
                    if (eventType == TOUCH_EVENT_ENDED) then
                        AudioHelper.playCommonEffect()
                        showForm = SHOW_FROM_INFO
                        MainFormationTools.fnSetLinkNumberTrue()
                        logger:debug("Form")
                        showFormView()
                    end
                end)
    --伙伴羁绊信息
    layTabView    = getWidgetByName(layLitFriend, "LAY_FORTBV")
    imgFormTitle  = getWidgetByName(layLitFriend, "IMG_EFFECT_TITLE")
    --伙伴阵型信息
    layFormView   = getWidgetByName(layLitFriend, "LAY_ZHENXING")
    imgFormation  = getWidgetByName(layLitFriend, "IMG_ZHENSHANG_TITLE")
    imgFormJIban  = getWidgetByName(layLitFriend, "IMG_TOTAL_JIBAN")
    labnJibanNum  = getWidgetByName(layLitFriend, "LABN_TOTAL_NUM")
    --显示羁绊信息。
	createScrollView(layTabView)
    if m_litFriShowType == SHOW_SELF_SQUAD then
        refreshFormView()
        showFormView()
    else
        layFormView:setVisible(false)
        btnJibanInfo:setEnabled(false)
        btnFormView:setEnabled(false)
        imgFormation:setVisible(false)
        labnJibanNum:setVisible(false)
        imgFormJIban:setVisible(false)
    end
end