-- CPV = Cost Per Visit
CREATE OR REPLACE VIEW mart_mkt_yd_cpv AS SELECT
    c.DT,
    MIN(c.Costs)/(SUM(v.Visits)+0.00000001) AS CPV,
    MIN(c.Costs) AS C,
    SUM(v.Visits) AS V,
    REPLACE(c.UTMCampaign, '�', ' ') AS UTMCampaign
FROM mart_costs_dt as c
    LEFT JOIN mart_visits_dt as v ON c.UTMCampaign=v.UTMCampaign AND c.DT=v.DT
GROUP BY c.DT, UTMCampaign;

-- orders --
CREATE OR REPLACE VIEW mart_mkt_yd_campaigns_keywords_orders AS SELECT
    DT AS 'Date',
    0 AS 'Impressions',
    0 AS 'Clicks',
    Visits,
    Costs,
    Orders,
    Sales,
    Revenue,
    UTMSource AS 'Source',
    UTMCampaign AS 'Campaign',
    UTMTerm AS 'Term',
    Region
FROM
    mart_orders_dt
WHERE UTMMedium='cpc'
GROUP BY Term, Campaign, Source, Date, Region;

-- sales --
CREATE OR REPLACE VIEW mart_mkt_yd_campaigns_keywords_sales AS
SELECT
    DT AS 'Date',
    0 AS 'Impressions',
    0 AS 'Clicks',
    Visits,
    Costs,
    Orders,
Sales,
Revenue,
    UTMSource AS 'Source',
    UTMCampaign AS 'Campaign',
    UTMTerm AS 'Term',
Region
FROM
    mart_sales_dt
WHERE UTMMedium='cpc'
GROUP BY Term, Campaign, Source, Date, Region;

-- visits/costs --
CREATE OR REPLACE VIEW mart_mkt_yd_campaigns_keywords_visits AS
SELECT
    v.DT AS 'Date',
    0 AS 'Impressions',
    0 AS 'Clicks',
    SUM(v.VISITS) AS 'Visits',
    SUM(v.VISITS*c.CPV) AS 'Costs',
    0 AS 'Orders',
    0 AS 'Sales',
    0.0 AS 'Revenue',
    v.UTMSource AS 'Source',
    v.UTMCampaign AS 'Campaign',
    v.UTMTerm AS 'Term',
    Region
FROM mart_visits_dt as v
    LEFT JOIN mart_mkt_yd_cpv as c ON c.UTMCampaign=v.UTMCampaign AND c.DT=v.DT
WHERE v.UTMMedium='cpc'
GROUP BY Term, Campaign, Source, Date;

-- costs w/o visits --
CREATE OR REPLACE VIEW mart_mkt_yd_campaigns_keywords_costs AS
SELECT
    c.DT AS 'Date',
    0 AS 'Impressions',
    0 AS 'Clicks',
    0 AS 'Visits',
    SUM(c.C) AS 'Costs',
    0 AS 'Orders',
    0 AS 'Sales',
    0.0 AS 'Revenue',
    'yandex' AS 'Source',
    c.UTMCampaign AS 'Campaign',
    '' AS 'Term',
    'MSK' AS Region
FROM mart_mkt_yd_cpv as c
WHERE c.V=0 OR c.V IS NULL
GROUP BY Term, Campaign, Source, Date;

-- clicks/impressions visits --
CREATE OR REPLACE VIEW mart_mkt_yd_campaigns_keywords_clicks AS
SELECT
    DATE(`Date`) AS 'Date',
    SUM(Impressions) AS 'Impressions',
    SUM(Clicks) AS 'Clicks',
    0 AS 'Visits',
    0 AS 'Costs',
    0 AS 'Orders',
    0 AS 'Sales',
    0.0 AS 'Revenue',
    'yandex' AS 'Source',
    REPLACE(IFNULL(u.CampaignName, c.CampaignName), '�', ' ') AS 'Campaign',
    '' AS 'Term',
    'MSK' AS Region
FROM raw_yd_costs as c
    LEFT JOIN raw_yd_campaigns_utms as u ON c.CampaignId=u.CampaignId
GROUP BY Term, Campaign, Source, Date;

-- alltogether --
CREATE OR REPLACE EVENT mart_mkt_yd_campaigns_keywords
  ON SCHEDULE EVERY 1 DAY STARTS '2024-01-01 08:30:00.000' DO
  CREATE OR REPLACE TABLE `mart_mkt_yd_campaigns_keywords` (
  `_����` datetime DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�����` bigint(20) DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_�����` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_�������� �����` text DEFAULT NULL,
  `_������` text DEFAULT NULL,
  KEY `ix_datetime` (`_����`),
  KEY `ix_channel` (`_�����`(768)),
  KEY `ix_source` (`_��������`(768)),
  KEY `ix_campaign` (`_��������`(768)),
  KEY `ix_term` (`_�������� �����`(768)),
  KEY `ix_region` (`_������`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 SELECT
`Date` as '_����',
    IFNULL(SUM(`Impressions`), 0) AS '_������',
    IFNULL(SUM(`Clicks`), 0) AS '_�����',
    IFNULL(SUM(`Visits`), 0) AS '_������',
    IFNULL(SUM(`Costs`), 0.0) AS '_�������',
    IFNULL(SUM(`Orders`), 0) AS '_������',
    IFNULL(SUM(`Sales`), 0) AS '_�������',
    IFNULL(SUM(`Revenue`), 0.0) AS '_�������',
    CASE
        WHEN `Source`='<�� �������>' THEN ''
        WHEN `Source`='<�� ���������>' THEN ''
        ELSE IFNULL(`Source`, '')
    END  AS '_��������',
    CASE
        WHEN `Campaign`='rsa' THEN '����� ���'
        WHEN `Campaign`='<�� �������>' THEN ''
        WHEN `Campaign`='<�� ���������>' THEN ''
        ELSE REPLACE(IFNULL(cuid.CampaignName, IFNULL(cucamp.CampaignName, IFNULL(e.Campaign, ''))), '�', ' ')
    END AS '_��������',
    IFNULL(`Term`, '') AS '_�������� �����'
FROM
(SELECT * FROM mart_mkt_yd_campaigns_keywords_orders
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_sales
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_visits
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_costs
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_clicks) as e
LEFT JOIN raw_yd_campaigns_utms as cuid ON CAST(cuid.CampaignId AS CHAR)=e.Campaign
    LEFT JOIN raw_yd_campaigns_utms as cucamp ON cucamp.UTMCampaign=e.Campaign
GROUP BY Source, Campaign, Term, Date;

CREATE OR REPLACE TABLE `mart_mkt_yd_campaigns_keywords` (
  `_����` datetime DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�����` bigint(20) DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_�����` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_�������� �����` text DEFAULT NULL,
  `_������` text DEFAULT NULL,
  KEY `ix_datetime` (`_����`),
  KEY `ix_channel` (`_�����`(768)),
  KEY `ix_source` (`_��������`(768)),
  KEY `ix_campaign` (`_��������`(768)),
  KEY `ix_term` (`_�������� �����`(768)),
  KEY `ix_region` (`_������`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 SELECT
    `Date` as '_����',
    IFNULL(SUM(`Impressions`), 0) AS '_������',
    IFNULL(SUM(`Clicks`), 0) AS '_�����',
    IFNULL(SUM(`Visits`), 0) AS '_������',
    IFNULL(SUM(`Costs`), 0.0) AS '_�������',
    IFNULL(SUM(`Orders`), 0) AS '_������',
    IFNULL(SUM(`Sales`), 0) AS '_�������',
    IFNULL(SUM(`Revenue`), 0.0) AS '_�������',
    CASE
        WHEN `Source`='<�� �������>' THEN ''
        WHEN `Source`='<�� ���������>' THEN ''
        ELSE IFNULL(`Source`, '')
    END  AS '_��������',
    CASE
        WHEN `Campaign`='rsa' THEN '����� ���'
        WHEN `Campaign`='<�� �������>' THEN ''
        WHEN `Campaign`='<�� ���������>' THEN ''
        ELSE REPLACE(IFNULL(cuid.CampaignName, IFNULL(cucamp.CampaignName, IFNULL(e.Campaign, ''))), '�', ' ')
    END AS '_��������',
    IFNULL(`Term`, '') AS '_�������� �����'
FROM
(SELECT * FROM mart_mkt_yd_campaigns_keywords_orders
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_sales
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_visits
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_costs
    UNION ALL
SELECT * FROM mart_mkt_yd_campaigns_keywords_clicks) as e
LEFT JOIN raw_yd_campaigns_utms as cuid ON CAST(cuid.CampaignId AS CHAR)=e.Campaign
    LEFT JOIN raw_yd_campaigns_utms as cucamp ON cucamp.UTMCampaign=e.Campaign
GROUP BY Source, Campaign, Term, Date;