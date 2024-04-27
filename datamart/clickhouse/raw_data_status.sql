CREATE VIEW DB.raw_data_status AS

(SELECT
    'YM' as `source`,
	'������.�������: ������ �� ����' as `title`,
    count(*) as total,
    max(`ym:s:dateTime`) as date_end,
    min(`ym:s:dateTime`) as date_start
FROM
    DB.raw_ym_visits

/*UNION ALL

SELECT
    'AM' as `source`,
	'������.����������: ��������� ����������' as `title`,
    count(*) as total,
    max(`install_datetime`) as date_end,
    min(`install_datetime`) as date_start
FROM
    DB.raw_am_installs
*/
/*UNION ALL

SELECT
    'AME' as `source`,
	'������.����������: ������� � ����������' as `title`,
    count(*) as total,
    max(`event_datetime`) as date_end,
    min(`event_datetime`) as date_start
FROM
    DB.raw_am_events
*/
/*UNION ALL

SELECT
    'CT' as `source`,
	'Calltouch: ������' as `title`,
    count(*) as total,
    max(`date`) as date_end,
    min(`date`) as date_start
FROM
    DB.raw_ct_calls
*/
UNION ALL

SELECT
    'BX24LEAD' as `source`,
	'�������24: ����' as `title`,
    count(*) as total,
    max(`DATE_CREATE`) as date_end,
    min(`DATE_CREATE`) as date_start
FROM
    DB.raw_bx_crm_lead

UNION ALL

SELECT
    'BX24DEAL' as `source`,
	'�������24: ������' as `title`,
    count(*) as total,
    max(`DATE_CREATE`) as date_end,
    min(`DATE_CREATE`) as date_start
FROM
    DB.raw_bx_crm_deal
	
UNION ALL

SELECT
    'BX24CONTACT' as `source`,
	'�������24: ��������' as `title`,
    count(*) as total,
    max(`DATE_CREATE`) as date_end,
    min(`DATE_CREATE`) as date_start
FROM
    DB.raw_bx_crm_contact
	
UNION ALL

SELECT
    'BX24CONTACTS' as `source`,
	'�������24: ������� � email' as `title`,
    count(*) as total,
    NOW() as date_end,
    NOW() as date_start
FROM
    DB.raw_bx_crm_contact_contacts
	
UNION ALL

SELECT
    'BX24COMPANY' as `source`,
	'�������24: ��������' as `title`,
    count(*) as total,
    max(`DATE_CREATE`) as date_end,
    min(`DATE_CREATE`) as date_start
FROM
    DB.raw_bx_crm_company
	
UNION ALL

SELECT
    'BX24STATUS' as `source`,
	'�������24: �������' as `title`,
    count(*) as total,
    NOW() as date_end,
    NOW() as date_start
FROM
    DB.raw_bx_crm_status

UNION ALL

SELECT
    'BX24DEALCAT' as `source`,
	'�������24: ��������� ������' as `title`,
    count(*) as total,
    NOW() as date_end,
    NOW() as date_start
FROM
    DB.raw_bx_crm_category

/*UNION ALL

SELECT
    'VK' as `source`,
	'��: �������' as `title`,
    count(*) as total,
	max(`date`) as date_end,
    min(`date`) as date_start
FROM
    DB.raw_vk_costs
*/
UNION ALL

SELECT
    'YD' as `source`,
	'������.������: �������' as `title`,
    count(*) as total,
	max(`Date`) as date_end,
    min(`Date`) as date_start
FROM
    DB.raw_yd_costs)