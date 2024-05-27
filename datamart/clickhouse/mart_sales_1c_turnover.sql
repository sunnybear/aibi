CREATE OR REPLACE VIEW DB.mart_sales_1c_turnover AS
SELECT
	toDate(`Период`) AS `_Дата`,
	`ДоговорКонтрагента`,
	`Сделка`,
	`РасчетыВозврат`,
	`Организация`,
	`Контрагент`,
	toFloat64(`СуммаВзаиморасчетовОборот`) AS `СуммаВзаиморасчетовОборот`,
	toFloat64(`СуммаВзаиморасчетовПриход`) AS `СуммаВзаиморасчетовПриход`,
	toFloat64(`СуммаВзаиморасчетовРасход`) AS `СуммаВзаиморасчетовРасход`,
	toFloat64(`СуммаУпрОборот`) AS `СуммаУпрОборот`,
	toFloat64(`СуммаУпрПриход`) AS `СуммаУпрПриход`,
	toFloat64(`СуммаУпрРасход`) AS `СуммаУпрРасход`,
	toInt64orZero(`КонтрагентИНН`) AS `КонтрагентИНН`
FROM DB."raw_1c_РасчетыСКонтрагентамиОбороты"