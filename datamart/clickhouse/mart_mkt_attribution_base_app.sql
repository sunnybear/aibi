CREATE VIEW DB.mart_mkt_attribution_base_app AS 

SELECT
    `Date` as `_����`,
    IFNULL(SUM(`Visits`), 0) AS `_������`,
    IFNULL(SUM(`Costs`), 0.0) AS `_�������`,
	IFNULL(SUM(`Installs`), 0.0) AS `_���������`,
    IFNULL(SUM(`Leads`), 0) AS `_����`,
    IFNULL(SUM(`Deals`), 0) AS `_������`,
    IFNULL(SUM(`Revenue`), 0.0) AS `_�������`,
    IFNULL(SUM(`RepeatDeals`), 0) AS `_���������������`,
    CASE 
    WHEN `Channel`='app' THEN '��������� ����������'
    WHEN `Channel`='sms' THEN '���'
    WHEN `Channel`='mail' THEN '����������� �����'
    WHEN `Channel`='email' THEN '����������� �����'
    WHEN `Channel`='3Demail' THEN '����������� �����'
    WHEN `Source`='e.mail.ru' THEN '����������� �����'
    WHEN `Source`='click.mail.ru' THEN '����������� �����'
    WHEN `Channel`='smm' THEN '���������� ����'
    WHEN `Channel`='Social' THEN '���������� ����'
	WHEN `Channel`='social' THEN '���������� ����'
	WHEN `Channel`='social/' THEN '���������� ����'
    WHEN `Source`='Social network traffic' THEN '���������� ����'
    WHEN `Source`='m.vk.com' THEN '���������� ����'
    WHEN `Source`='away.vk.com' THEN '���������� ����'
	WHEN `Channel`='paidsocial' THEN '���������� ����'
    WHEN `Channel`='messenger' THEN '�����������'
	WHEN `Source`='whatsapp' THEN '�����������'
    WHEN `Source`='Messenger traffic' THEN '�����������'
    WHEN `Channel`='Chat' THEN '�����������'
    WHEN `Channel`='referral' THEN '������ �� ������'
    WHEN `Channel`='link' THEN '������ �� ������'
    WHEN `Source`='Link traffic' THEN '������ �� ������'
    WHEN `Channel`='webview' THEN '������ �� ������'
    WHEN `Source`='Recommendation system traffic' THEN '������ �� ������'
    WHEN `Channel`='offline' THEN '�������-�������'
    WHEN `Channel`='listovka' THEN '�������-�������'
    WHEN `Channel`='buklet' THEN '�������-�������'
    WHEN `Channel`='talon' THEN '�������-�������'
    WHEN `Channel`='vizitka' THEN '�������-�������'
    WHEN `Channel`='cpm' THEN '����������� �������'
    WHEN `Channel`='vdo.cpm' THEN '����������� �������'
    WHEN `Channel`='rtb-cpm' THEN '����������� �������'
    WHEN `Channel`='cpc' THEN '����������� �������'
	WHEN `Channel`='cpc|DB.ru/app-2gis' THEN '����������� �������'
	WHEN `Channel`='cpc/' THEN '����������� �������'
    WHEN `Channel`='cpc (ymclid)' THEN '����������� �������'
	WHEN `Channel`='cpc (yclid)' THEN '����������� �������'
	WHEN `Channel`='cpc (gclid)' THEN '����������� �������'
    WHEN `Channel`='click' THEN '����������� �������'
	WHEN `Channel`='click_click' THEN '����������� �������'
    WHEN `Channel`='cpa' THEN '����������� �������'
    WHEN `Channel`='ad' THEN '����������� �������'
    WHEN `Source`='Ad traffic' THEN '����������� �������'
    WHEN `Channel`='banner' THEN '����������� �������'
    WHEN `Channel`='cpc,cpc' THEN '����������� �������'
    WHEN `Channel`='organic' THEN '��������� �������'
    WHEN `Source`='organic' THEN '��������� �������'
    WHEN `Source`='ya.ru' THEN '��������� �������'
    WHEN `Source`='yandex.com' THEN '��������� �������'
    WHEN `Source`='Yandex' THEN '��������� �������'
    WHEN `Source`='duckduckgo.com' THEN '��������� �������'
    WHEN `Channel`='���-����' THEN '������ ������'
	WHEN `Channel`='CRM-�����' THEN '������ ������'
    WHEN `Channel`='direct' THEN '������ ������'
	WHEN `Channel`='<�� �������>' THEN '������ ������'
	WHEN `Channel`='<�� ���������>' THEN '������ ������'
    WHEN `Channel`='' THEN '������ ������'
    WHEN `Channel`='other' THEN '�� ����������'
	WHEN `Channel`='��� � ������' THEN '�� ����������'
	WHEN `Channel`='avito' THEN '������������'
    WHEN `Channel`='calls' THEN '������'
    WHEN `Channel`='free' THEN '������'
    WHEN `Channel`='partners' THEN '�������� � ������������'
    ELSE IFNULL(`Channel`, '������ ������')
    END AS `_�����`,
    CASE
    WHEN `Source`='yandex,yandex' THEN '������.�����'
    WHEN `Source`='yandex-direct' THEN '������.�����'
    WHEN `Source`='Yandex' THEN '������.�����'
    WHEN `Source`='yandex' THEN '������.�����'
    WHEN `Source`='organic' THEN `Channel`
    WHEN `Source`='Link traffic' THEN '������'
    WHEN `Source`='Social network traffic' THEN '������'
    WHEN `Source`='Ad traffic' THEN '������'
    WHEN `Source`='Messenger traffic' THEN '������'
    WHEN `Source`='Internal traffic' THEN '������'
    WHEN `Source`='Direct traffic' THEN '������'
    WHEN `Source`='Recommendation system traffic' THEN '���������������� �������'
    WHEN `Source`='yandex_network' THEN '���'
	WHEN `Campaign`='rsa' THEN '���'
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
	CASE
		WHEN `Campaign`='<�� �������>' THEN ''
		WHEN `Channel`='organic' THEN ''
		WHEN `Campaign`='rsa' THEN `Source`
		ELSE IFNULL(`Campaign`, '')
	END AS `_��������`

FROM (SELECT
    l.DT AS `Date`,
    0 AS `Visits`,
    0 AS `Costs`,
    0 AS `Installs`,
    SUM(l.LEADS) AS `Leads`,
    0 AS `Deals`,
    0 AS `Revenue`,
    0 AS `RepeatDeals`,
    l.UTM_MEDIUM_PURE AS `Channel`,
    l.UTM_SOURCE_PURE AS `Source`,
    l.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_bx_leads_app as l
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    d.DT AS `Date`,
    0 AS `Visits`,
    0 AS `Costs`,
    0 AS `Leads`,
	0 AS `Installs`,
    SUM(d.DEALS) AS `Deals`,
    SUM(d.REVENUE) AS `Revenue`,
    SUM(d.REPEATDEALS) AS `RepeatDeals`,
    d.UTM_MEDIUM_PURE AS `Channel`,
    d.UTM_SOURCE_PURE AS `Source`,
    d.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_bx_deals_app as d
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    v.DT AS `Date`,
    SUM(v.VISITS) AS `Visits`,
    0 AS `Costs`,
	0 AS `Installs`,
    0 AS `Leads`,
    0 AS `Deals`,
    0 AS `Revenue`,
    0 AS `RepeatDeals`,
    v.UTM_MEDIUM_PURE AS `Channel`,
    v.UTM_SOURCE_PURE AS `Source`,
    v.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_ym_visits as v
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    c.DT AS `Date`,
    0 AS `Visits`,
    SUM(c.COSTS) AS `Costs`,
	0 AS `Installs`,
    0 AS `Leads`,
    0 AS `Deals`,
    0 AS `Revenue`,
    0 AS `RepeatDeals`,
    c.UTM_MEDIUM_PURE AS `Channel`,
    c.UTM_SOURCE_PURE AS `Source`,
    replaceAll(c.CAMPAIGN_NAME, ' ', '_') AS `Campaign`
FROM
    DB.mart_mkt_yd_costs as c
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    DT AS `Date`,
    0 AS `Visits`,
    SUM(COSTS) AS `Costs`,
	0 AS `Installs`,
    0 AS `Leads`,
    0 AS `Deals`,
    0 AS `Revenue`,
    0 AS `RepeatDeals`,
    vk.UTM_MEDIUM_PURE AS `Channel`,
    vk.UTM_SOURCE_PURE AS `Source`,
    vk.UTM_CAMPAIGN_ID AS `Campaign`
FROM
    DB.mart_mkt_vk_costs as vk
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

UNION ALL

SELECT
    DT AS `Date`,
    0 AS `Visits`,
    0 AS `Costs`,
	SUM(INSTALLS) AS `Installs`,
    0 AS `Leads`,
    0 AS `Deals`,
    0 AS `Revenue`,
    0 AS `RepeatDeals`,
    ya.UTM_MEDIUM_PURE AS `Channel`,
    ya.UTM_SOURCE_PURE AS `Source`,
    ya.UTM_CAMPAIGN_PURE AS `Campaign`
FROM
    DB.mart_mkt_ya_installs as ya
GROUP BY `Channel`,`Source`,`Campaign`,`Date`

SETTINGS join_use_nulls = 1)

GROUP BY `_�����`,`_��������`,`_��������`,`_����`