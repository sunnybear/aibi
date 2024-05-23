create or replace view mart_ym_goals_close_lpc as (select
	YEAR(goals.gdt) as gdt_year,
    MONTH(goals.gdt) as gdt_month,
    DAYOFMONTH(goals.gdt) as gdt_day,
    HOUR(goals.gdt) as gdt_hour,
    MINUTE(goals.gdt) as gdt_minute,
	clients.vdt,
	clients.cid,
	`UTMMedium`,
	`UTMSource`,
	`UTMCampaign`,
	region,
	ROW_NUMBER() OVER (PARTITION BY goals.gdt ORDER BY DATEDIFF(goals.gdt, clients.vdt)) AS rowNum
from mart_ym_goals_purchase as goals
    left join mart_ym_clients as clients on goals.cid=clients.cid
WHERE
	goals.gdt > clients.vdt AND
	`UTMMedium` IN ('cpc', 'ad', 'cpm'));

create or replace view mart_ym_goals_utm_lpc as (select *
from mart_ym_goals_close_lpc
WHERE rowNum=1);

create or replace view mart_bx_orders_utm_lpc as (select
	id,
	price,
	dateInsert,
	canceled,
	statusId,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	region
from mart_ym_goals_utm_lpc
left join mart_bx_orders_datetime on odt_year=gdt_year and odt_month=gdt_month and odt_day=gdt_day and odt_hour=gdt_hour and odt_minute=gdt_minute
where odt_minute IS NOT NULL

UNION ALL

select
	id,
	price,
	dateInsert,
	canceled,
	statusId,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	region
from mart_ym_goals_utm_lpc
left join mart_bx_orders_datetime_1 on odt_year=gdt_year and odt_month=gdt_month and odt_day=gdt_day and odt_hour=gdt_hour and odt_minute=gdt_minute
where odt_minute IS NOT NULL);

create or replace view mart_bx_orders_all_lpc as (SELECT
	id,
	price,
	dateInsert,
	canceled,
	statusId,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	region
FROM mart_bx_orders_utm_lpc

UNION ALL

SELECT
	id,
	price,
	dateInsert,
	canceled,
	statusId,
	CASE
		WHEN LOCATE('YAMARKET_', xmlId)>0 THEN '������.������'
		WHEN LOCATE('����� �������� � �����', userDescription)>0 THEN '����'
		ELSE 'direct'
	END AS UTMMedium,
	CASE 
		WHEN LOCATE('YAMARKET_', xmlId)>0 THEN 'Yandex.Market'
		WHEN LOCATE('����� �������� � �����', userDescription)>0 THEN 'OZON'
		ELSE ''
	END AS UTMSource,
	'' AS UTMCampaign,
	'MSK' AS region
FROM raw_bx_orders
WHERE id NOT IN (SELECT id FROM mart_bx_orders_utm_lpc));

create or replace view mart_orders_dt_lpc as (SELECT
	DATE(dateInsert) AS `DT`,
	0 as Visits,
	0 as Costs,
	COUNT(id) AS 'Orders',
	0 AS Sales,
	0 AS Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	region AS Region
FROM mart_bx_orders_all_lpc
GROUP BY DATE(dateInsert), UTMMedium, UTMSource, UTMCampaign, Region);

create or replace view mart_sales_dt_lpc as (SELECT
	DATE(dateInsert) AS `DT`,
	0 AS Visits,
	0 AS Costs,
	0 AS Orders,
	COUNT(id) AS Sales,
	SUM(price) as Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	region AS Region
FROM mart_bx_orders_all_lpc
WHERE statusId IN ('D', 'F', 'G', 'OG', 'P', 'YA')
GROUP BY DATE(dateInsert), UTMMedium, UTMSource, UTMCampaign, Region);

create or replace view mart_sales_dt_all_lpc as (
SELECT * FROM mart_sales_dt_lpc
UNION ALL
SELECT * FROM mart_sales_1c_dt
);

create or replace view mart_mkt_e2e_lpc as (SELECT
	DT,
	Visits,
	Costs,
	Orders,
	Sales,
	Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	Region
FROM mart_visits_dt
WHERE Visits>0

UNION ALL

SELECT
	DT,
	Visits,
	Costs,
	Orders,
	Sales,
	Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	Region
FROM mart_costs_dt
WHERE Costs>0

UNION ALL

SELECT
	DT,
	Visits,
	Costs,
	Orders,
	Sales,
	Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	Region
FROM mart_orders_dt_lpc
WHERE Orders>0

UNION ALL 

SELECT
	DT,
	Visits,
	Costs,
	Orders,
	Sales,
	Revenue,
	UTMMedium,
	UTMSource,
	UTMCampaign,
	Region
FROM mart_sales_dt_all_lpc
WHERE Revenue>0);

CREATE OR REPLACE EVENT mart_mkt_attribution_lpc
  ON SCHEDULE EVERY 1 DAY STARTS '2024-01-01 08:20:00.000' DO
   CREATE OR REPLACE TABLE `mart_mkt_attribution_lpc` (
  `_����` datetime DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_�����` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_������` text DEFAULT NULL,
  KEY `ix_datetime` (`_����`),
  KEY `ix_channel` (`_�����`(768)),
  KEY `ix_source` (`_��������`(768)),
  KEY `ix_campaign` (`_��������`(768)),
  KEY `ix_region` (`_������`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 SELECT
	DT as '_����',
	SUM(Visits) as '_������',
	SUM(Costs) as '_�������',
	SUM(Orders) as '_������',
	SUM(Sales) as '_�������',
	SUM(Revenue) as '_�������',
	e.UTMMedium as '_�����',
	e.UTMSource as '_��������',
	REPLACE(IFNULL(cuid.CampaignName, IFNULL(cucamp.CampaignName, e.UTMCampaign)), "�", " ") as '_��������',
	Region as '_������'
FROM mart_mkt_e2e_lpc as e
    LEFT JOIN raw_yd_campaigns_utms as cuid ON CAST(cuid.CampaignId AS CHAR)=e.UTMCampaign
    LEFT JOIN raw_yd_campaigns_utms as cucamp ON cucamp.UTMCampaign=e.UTMCampaign
GROUP BY DT, e.UTMMedium, e.UTMSource, e.UTMCampaign, e.Region;

CREATE OR REPLACE TABLE `mart_mkt_attribution_lpc` (
  `_����` datetime DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_������` bigint(20) DEFAULT NULL,
  `_�������` bigint(20) DEFAULT NULL,
  `_�������` double DEFAULT NULL,
  `_�����` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_��������` text DEFAULT NULL,
  `_������` text DEFAULT NULL,
  KEY `ix_datetime` (`_����`),
  KEY `ix_channel` (`_�����`(768)),
  KEY `ix_source` (`_��������`(768)),
  KEY `ix_campaign` (`_��������`(768)),
  KEY `ix_region` (`_������`(768))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 SELECT
	DT as '_����',
	SUM(Visits) as '_������',
	SUM(Costs) as '_�������',
	SUM(Orders) as '_������',
	SUM(Sales) as '_�������',
	SUM(Revenue) as '_�������',
	e.UTMMedium as '_�����',
	e.UTMSource as '_��������',
	REPLACE(IFNULL(cuid.CampaignName, IFNULL(cucamp.CampaignName, e.UTMCampaign)), "�", " ") as '_��������',
	Region as '_������'
FROM mart_mkt_e2e_lpc as e
    LEFT JOIN raw_yd_campaigns_utms as cuid ON CAST(cuid.CampaignId AS CHAR)=e.UTMCampaign
    LEFT JOIN raw_yd_campaigns_utms as cucamp ON cucamp.UTMCampaign=e.UTMCampaign
GROUP BY DT, e.UTMMedium, e.UTMSource, e.UTMCampaign, e.Region;