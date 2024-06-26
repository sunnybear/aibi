CREATE VIEW DB.mart_mkt_attribution_base AS 

SELECT
    `Date` as `_����`,
    IFNULL(SUM(`Visits`), 0) AS `_������`,
    IFNULL(SUM(`Costs`), 0.0) AS `_�������`,
    IFNULL(SUM(`Leads`), 0) AS `_����`,
    IFNULL(SUM(`Deals`), 0) AS `_������`,
    IFNULL(SUM(`Revenue`), 0.0) AS `_�������`,
    IFNULL(SUM(`RepeatDeals`), 0) AS `_���������������`,
    CASE
	WHEN `Channel`='app' THEN '��������� ����������'
    WHEN `Channel`='sms' THEN '���'
    WHEN `Channel`='mail' THEN '����������� �����'
    WHEN `Source`='e.mail.ru' THEN '����������� �����'
    WHEN `Source`='click.mail.ru' THEN '����������� �����'
    WHEN `Channel`='smm' THEN '���������� ����'
    WHEN `Source`='Social network traffic' THEN '���������� ����'
    WHEN `Source`='m.vk.com' THEN '���������� ����'
    WHEN `Source`='away.vk.com' THEN '���������� ����'
    WHEN `Channel`='messenger' THEN '�����������'
    WHEN `Source`='Messenger traffic' THEN '�����������'
    WHEN `Channel`='Chat' THEN '�����������'
    WHEN `Channel`='referral' THEN '������ �� ������'
    WHEN `Source`='Link traffic' THEN '������ �� ������'
    WHEN `Channel`='webview' THEN '������ �� ������'
	WHEN `Source`='Recommendation system traffic' THEN '������ �� ������'
    WHEN `Channel`='offline' THEN '�������-�������'
    WHEN `Channel`='listovka' THEN '�������-�������'
    WHEN `Channel`='buklet' THEN '�������-�������'
    WHEN `Channel`='talon' THEN '�������-�������'
    WHEN `Channel`='cpm' THEN '����������� �������'
    WHEN `Channel`='vdo.cpm' THEN '����������� �������'
    WHEN `Channel`='rtb-cpm' THEN '����������� �������'
    WHEN `Channel`='cpc' THEN '����������� �������'
	WHEN `Channel`='cpa' THEN '����������� �������'
    WHEN `Source`='Ad traffic' THEN '����������� �������'
    WHEN `Channel`='banner' THEN '����������� �������'
    WHEN `Channel`='cpc,cpc' THEN '����������� �������'
    WHEN `Channel`='organic' THEN '��������� �������'
    WHEN `Source`='organic' THEN '��������� �������'
    WHEN `Source`='ya.ru' THEN '��������� �������'
    WHEN `Source`='yandex.com' THEN '��������� �������'
	WHEN `Source`='Yandex' THEN '��������� �������'
    WHEN `Source`='duckduckgo.com' THEN '��������� �������'
    WHEN `Channel`='direct' THEN '������ ������'
    WHEN `Channel`='' THEN '������ ������'
    WHEN `Channel`='other' THEN '�� ����������'
    WHEN `Channel`='calls' THEN '������'
    WHEN `Channel`='free' THEN '������'
    WHEN `Channel`='partners' THEN '�������� � ������������'
    ELSE IFNULL(`Channel`, '������ ������')
    END AS `_�����`,
    CASE
    WHEN `Source`='yandex,yandex' THEN '������.�����'
    WHEN `Source`='yandex-direct' THEN '������.�����'
    WHEN `Source`='Yandex' THEN '������.�����'
    WHEN `Source`='organic' THEN `Channel`
	WHEN `Source`='Link traffic' THEN '������'
	WHEN `Source`='Social network traffic' THEN '������'
	WHEN `Source`='Ad traffic' THEN '������'
	WHEN `Source`='Messenger traffic' THEN '������'
	WHEN `Source`='Internal traffic' THEN '������'
	WHEN `Source`='Direct traffic' THEN '������'
	WHEN `Source`='Recommendation system traffic' THEN '���������������� �������'
	WHEN `Source`='yandex_network' THEN '���'
    WHEN `Source`='yandex' THEN CASE WHEN `Channel`='cpc' THEN '������.�����' WHEN `Channel`='cpm' THEN '������.�����' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='google' THEN CASE WHEN `Channel`='cpc' THEN 'Google.Adwords' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='e.mail.ru' THEN CASE WHEN `Channel`='referral' THEN '����� Mail.Ru' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='click.mail.ru' THEN CASE WHEN `Channel`='referral' THEN '����� Mail.Ru' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='m.vk.com' THEN CASE WHEN `Channel`='referral' THEN '���.����|VK' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='away.vk.com' THEN CASE WHEN `Channel`='referral' THEN '���.����|VK' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='ya.ru' THEN CASE WHEN `Channel`='referral' THEN 'yandex' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='yandex.com' THEN CASE WHEN `Channel`='referral' THEN 'yandex' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    WHEN `Source`='duckduckgo.com' THEN CASE WHEN `Channel`='referral' THEN 'duckduckgo' ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END END
    ELSE CASE WHEN `Source`='' THEN '������' ELSE IFNULL(`Source`, '������') END
    END AS `_��������`,
    IFNULL(`Campaign`, '') AS `_��������`
FROM (SELECT
    l.DT AS `Date`,
    SUM(v.VISITS) AS `Visits`,
    SUM(c.COSTS) AS `Costs`,
    SUM(l.LEADS) AS `Leads`,
    SUM(d.DEALS) AS `Deals`,
    SUM(d.REVENUE) AS `Revenue`,
	SUM(d.REPEATDEALS) AS `RepeatDeals`,
    l.UTM_MEDIUM_PURE AS `Channel`,
    IFNULL(c.UTM_SOURCE_PURE,l.UTM_SOURCE_PURE) AS `Source`,
    l.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_bx_leads as l
LEFT JOIN DB.mart_mkt_bx_deals as d ON
    d.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND d.UTM_SOURCE_PURE=l.UTM_SOURCE_PURE AND d.UTM_CAMPAIGN_PURE=l.UTM_CAMPAIGN_PURE AND d.DT=l.DT
LEFT JOIN DB.mart_mkt_ym_visits as v ON
    v.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND v.UTM_SOURCE_PURE=l.UTM_SOURCE_PURE AND v.UTM_CAMPAIGN_PURE=l.UTM_CAMPAIGN_PURE AND v.DT=l.DT
LEFT JOIN DB.mart_mkt_yd_costs as c ON
    c.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=l.UTM_CAMPAIGN_ID AND c.DT=l.DT AND c.COSTS>0
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    d.DT AS `Date`,
    SUM(v.VISITS) AS `Visits`,
    SUM(c.COSTS) AS `Costs`,
    SUM(l.LEADS) AS `Leads`,
    SUM(d.DEALS) AS `Deals`,
    SUM(d.REVENUE) AS `Revenue`,
	SUM(d.REPEATDEALS) AS `RepeatDeals`,
    d.UTM_MEDIUM_PURE AS `Channel`,
    IFNULL(c.UTM_SOURCE_PURE,d.UTM_SOURCE_PURE) AS `Source`,
    d.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_bx_deals as d
LEFT JOIN DB.mart_mkt_bx_leads as l ON
    d.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND d.UTM_SOURCE_PURE=l.UTM_SOURCE_PURE AND d.UTM_CAMPAIGN_PURE=l.UTM_CAMPAIGN_PURE AND d.DT=l.DT
LEFT JOIN DB.mart_mkt_ym_visits as v ON
    v.UTM_MEDIUM_PURE=d.UTM_MEDIUM_PURE AND v.UTM_SOURCE_PURE=d.UTM_SOURCE_PURE AND v.UTM_CAMPAIGN_PURE=d.UTM_CAMPAIGN_PURE AND v.DT=d.DT
LEFT JOIN DB.mart_mkt_yd_costs as c ON
    c.UTM_MEDIUM_PURE=d.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=d.UTM_CAMPAIGN_ID AND c.DT=d.DT AND c.COSTS>0
WHERE l.LEADS IS NULL
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    v.DT AS `Date`,
    SUM(v.VISITS) AS `Visits`,
    SUM(c.COSTS) AS `Costs`,
    SUM(l.LEADS) AS `Leads`,
    SUM(d.DEALS) AS `Deals`,
    SUM(d.REVENUE) AS `Revenue`,
	SUM(d.REPEATDEALS) AS `RepeatDeals`,
    v.UTM_MEDIUM_PURE AS `Channel`,
    IFNULL(c.UTM_SOURCE_PURE,v.UTM_SOURCE_PURE) AS `Source`,
    v.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_ym_visits as v
LEFT JOIN DB.mart_mkt_bx_leads as l ON
    v.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND v.UTM_SOURCE_PURE=l.UTM_SOURCE_PURE AND v.UTM_CAMPAIGN_PURE=l.UTM_CAMPAIGN_PURE AND v.DT=l.DT
LEFT JOIN DB.mart_mkt_bx_deals as d ON
    v.UTM_MEDIUM_PURE=d.UTM_MEDIUM_PURE AND v.UTM_SOURCE_PURE=d.UTM_SOURCE_PURE AND v.UTM_CAMPAIGN_PURE=d.UTM_CAMPAIGN_PURE AND v.DT=d.DT
LEFT JOIN DB.mart_mkt_yd_costs as c ON
    c.UTM_MEDIUM_PURE=v.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=v.UTM_CAMPAIGN_ID AND c.DT=v.DT AND c.COSTS>0
WHERE d.DEALS IS NULL AND l.LEADS IS NULL
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    c.DT AS `Date`,
    SUM(v.VISITS) AS `Visits`,
    SUM(c.COSTS) AS `Costs`,
    SUM(l.LEADS) AS `Leads`,
    SUM(d.DEALS) AS `Deals`,
    SUM(d.REVENUE) AS `Revenue`,
	SUM(d.REPEATDEALS) AS `RepeatDeals`,
    c.UTM_MEDIUM_PURE AS `Channel`,
    c.UTM_SOURCE_PURE AS `Source`,
    replaceAll(c.CAMPAIGN_NAME, ' ', '_') AS `Campaign`
FROM
    DB.mart_mkt_yd_costs as c
LEFT JOIN DB.mart_mkt_bx_leads as l ON
    c.UTM_MEDIUM_PURE=l.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=l.UTM_CAMPAIGN_ID AND c.DT=l.DT
LEFT JOIN DB.mart_mkt_bx_deals as d ON
    c.UTM_MEDIUM_PURE=d.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=d.UTM_CAMPAIGN_ID AND c.DT=d.DT
LEFT JOIN DB.mart_mkt_ym_visits as v ON
    c.UTM_MEDIUM_PURE=v.UTM_MEDIUM_PURE AND c.UTM_CAMPAIGN_ID=v.UTM_CAMPAIGN_ID AND c.DT=v.DT AND c.COSTS>0
WHERE d.DEALS IS NULL AND l.LEADS IS NULL AND v.VISITS IS NULL
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

SETTINGS join_use_nulls = 1)

GROUP BY `_�����`,`_��������`,`_��������`,`_����`