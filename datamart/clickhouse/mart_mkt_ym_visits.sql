CREATE OR REPLACE VIEW DB.mart_mkt_ym_visits as
SELECT
    count(`ym:s:visitID`) as VISITS,
    toDate(`ym:s:dateTime`) AS DT,
    CASE 
        WHEN `ym:s:lastUTMCampaign`='(not set)' THEN ''
        WHEN `ym:s:lastUTMCampaign`='(referral)' THEN ''
        WHEN `ym:s:lastUTMCampaign`='(organic)' THEN ''
        ELSE IFNULL(ctui.CampaignName, IFNULL(uc.CampaignName, IFNULL(ui.CampaignName, `ym:s:lastUTMCampaign`)))
    END as UTM_CAMPAIGN_PURE,
    CASE 
        WHEN toUInt64OrNull(SUBSTRING(`ym:s:lastUTMCampaign`, LENGTH(`ym:s:lastUTMCampaign`) - POSITION(REVERSE(`ym:s:lastUTMCampaign`), '_')+2, LENGTH(`ym:s:lastUTMCampaign`))) IS NOT NULL THEN SUBSTRING(`ym:s:lastUTMCampaign`, LENGTH(`ym:s:lastUTMCampaign`) - POSITION(REVERSE(`ym:s:lastUTMCampaign`), '_')+2, LENGTH(`ym:s:lastUTMCampaign`))
        ELSE ''
    END as UTM_CAMPAIGN_ID,
    CASE 
        WHEN `ym:s:lastUTMMedium`='Ad traffic' THEN 'yandex'
		WHEN `ym:s:lastUTMMedium`=''  THEN `ym:s:lastTrafficSource`
		WHEN `ym:s:lastUTMMedium`='(direct)'  THEN `ym:s:lastTrafficSource`
        ELSE IFNULL(`ym:s:lastUTMMedium`,`ym:s:lastTrafficSource`)
    END as UTM_MEDIUM_PURE,
    CASE 
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='AOL' THEN 'aol'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Aport' THEN 'aport'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Ask.com' THEN 'ask'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Babylon Search' THEN 'babylon'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Baidu' THEN 'baidu'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Bing' THEN 'bing'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Conduit' THEN 'conduit'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='DuckDuckGo' THEN 'duckduckgo'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Ecosia' THEN 'ecosia'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='hi.ru' THEN 'hi'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Gigabase' THEN 'gigabase'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Google' THEN 'google'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='google' THEN 'google'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Magna' THEN 'magna'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Mail.ru' THEN 'mailru'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Metabot.ru' THEN 'metabot'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Nigma' THEN 'nigma'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Poisk.ru' THEN 'poisk'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Quintura' THEN 'quintura'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Rambler' THEN 'rambler'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Search on ICQ.com' THEN 'icq'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Search on QIP.ru' THEN 'qip'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search-results.com' THEN 'search-results'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search.avg.com' THEN 'search.avg'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search.iminent.com' THEN 'search.iminent'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search.incredibar.com' THEN 'search.incredibar'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search.softonic.com' THEN 'search.softonic'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='search.sweetim.com' THEN 'search.sweetim'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='searchya.com' THEN 'searchya'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Sputnik' THEN 'sputnik'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Tut.by' THEN 'tutby'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Ukr.net' THEN 'ukrnet'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='virgilio.it' THEN 'virgilio'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Webalta' THEN 'webalta'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Yahoo!' THEN 'yahoo'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Yandex' THEN 'yandex'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='yandex' THEN 'yandex'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Zapmeta' THEN 'zapmeta'
        WHEN `ym:s:lastTrafficSource`='organic' AND `ym:s:lastSearchEngineRoot`='Zen News' THEN 'zen'
        WHEN `ym:s:lastUTMSource`='(direct)' THEN CASE WHEN `ym:s:lastTrafficSource`='' THEN 'direct' ELSE `ym:s:lastTrafficSource` END
        WHEN `ym:s:lastUTMSource`='' THEN CASE WHEN `ym:s:lastTrafficSource`='' THEN 'direct' ELSE `ym:s:lastTrafficSource` END
        WHEN `ym:s:lastUTMSource`='' THEN 'direct'
        WHEN `ym:s:lastUTMSource` IS NULL THEN 'direct'
        WHEN `ym:s:lastUTMMedium`='Direct traffic' THEN 'direct'
        WHEN `ym:s:lastUTMSource`='Chat' THEN 'messenger'
        WHEN `ym:s:lastUTMSource`='Messenger traffic' THEN 'messenger'
        WHEN `ym:s:lastUTMMedium`='Social network traffic' THEN 'smm'
        WHEN `ym:s:lastUTMMedium`='vk' THEN 'smm'
        WHEN `ym:s:lastUTMMedium`='google' THEN 'organic'
        WHEN `ym:s:lastUTMMedium`='nigma' THEN 'organic'
        WHEN `ym:s:lastUTMMedium`='Search engine traffic' THEN 'organic'
        WHEN `ym:s:lastUTMMedium`='yandex' THEN 'organic'
        WHEN `ym:s:lastUTMMedium`='Ad traffic' THEN 'cpc'
        WHEN `ym:s:lastUTMSource`='banner' THEN 'cpc'
        ELSE `ym:s:lastUTMSource`
    END as UTM_SOURCE_PURE,
	`ym:s:lastUTMTerm` as UTM_TERM_PURE
FROM DB.raw_ym_visits as v
	LEFT JOIN DB.raw_yd_campaigns_utms as uc ON `ym:s:lastUTMCampaign`=uc.UTMCampaign
	LEFT JOIN DB.raw_yd_campaigns_utms as ui ON `ym:s:lastUTMCampaign`=toString(ui.CampaignId)
	LEFT JOIN DB.raw_yd_campaigns_utms as ctui ON SUBSTRING(SUBSTRING(`ym:s:startURL`, POSITION(`ym:s:startURL`, 'calltouch_tm=yd_c:')+18), 1, POSITION(SUBSTRING(`ym:s:startURL`, POSITION(`ym:s:startURL`, 'calltouch_tm=yd_c:')+18), '_')-1)=toString(ctui.CampaignId)
GROUP BY UTM_TERM_PURE, UTM_CAMPAIGN_PURE, UTM_CAMPAIGN_ID, UTM_MEDIUM_PURE, UTM_SOURCE_PURE, DT

SETTINGS join_use_nulls = 1