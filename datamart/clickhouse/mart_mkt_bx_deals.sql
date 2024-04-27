CREATE VIEW DB.mart_mkt_bx_deals AS
SELECT
    count(d.ID) as DEALS,
    countIf(d.IS_RETURN_CUSTOMER='Y') as REPEATDEALS,
    toDate(CLOSEDATE) AS DT,
    sum(OPPORTUNITY) as REVENUE,
    UTM_CAMPAIGN_ID,
    UTM_CAMPAIGN_PURE,
    UTM_SOURCE_PURE,
    UTM_MEDIUM_PURE
FROM DB.mart_mkt_bx_crm_deal as d
WHERE
    (CASE
WHEN POSITION(REVERSE(`STAGE_ID`), ':')>0 THEN SUBSTRING(`STAGE_ID`, LENGTH(`STAGE_ID`)-POSITION(REVERSE(`STAGE_ID`), ':')+2, LENGTH(`STAGE_ID`))
ELSE `STAGE_ID`
END) = 'WON'
GROUP BY UTM_CAMPAIGN_PURE,UTM_CAMPAIGN_ID,UTM_SOURCE_PURE,UTM_MEDIUM_PURE,DT

SETTINGS join_use_nulls = 1