# Скрипт для ежедневного обновления данных по лидам Битрикс24 (crm.lead) для облачных функций Яндекс.Облака
# Необходимо в переменных окружения указать
# * DB_TYPE - тип базы данных (куда выгружать данные)
# * DB_HOST - адрес (хост) базы данных
# * DB_USER - пользователь базы данных
# * DB_PASSWORD - пароль к базе данных (если требуется)
# * DB_DB - имя базы данных
# * DB_PREFIX - префикс базы данных (может отличаться от имени при облачном подключении)
# * BITRIX24_WEBHOOK - URL вебхука (интеграции) Битрикс24
# * BITRIX24_TABLE_LEADS - имя таблицы с лидами

# requirements.txt:
# pandas
# numpy
# requests
# datetime

# timeout: 300
# memory: 512

import pandas as pd
import numpy as np
import os
import io
import requests
from datetime import datetime as dt
from datetime import date, timedelta

def handler(event, context):
    auth = {
        'X-ClickHouse-User': os.getenv('DB_USER'),
        'X-ClickHouse-Key': context.token["access_token"]
    }
    auth_post = auth.copy()
    auth_post['Content-Type'] = 'application/octet-stream'
    cacert = '/etc/ssl/certs/ca-certificates.crt'
    yesterday = (date.today() - timedelta(days=1)).strftime('%Y-%m-%d 00:00:00')

# подключение к БД
    if os.getenv('DB_TYPE') == "MYSQL":
        engine = create_engine('mysql+mysqldb://' + os.getenv('DB_USER') + ':' + os.getenv('DB_PASSWORD') + '@' + os.getenv('DB_HOST') + '/' + os.getenv('DB_DB') + '?charset=utf8')
    elif os.getenv('DB_TYPE') == "POSTGRESQL":
        engine = create_engine('postgresql+psycopg2://' + os.getenv('DB_USER') + ':' + os.getenv('DB_PASSWORD') + '@' + os.getenv('DB_HOST') + '/' + os.getenv('DB_DB') + '?client_encoding=utf8')
    elif os.getenv('DB_TYPE') == "MARIADB":
        engine = create_engine('mariadb+mysqldb://' + os.getenv('DB_USER') + ':' + os.getenv('DB_PASSWORD') + '@' + os.getenv('DB_HOST') + '/' + os.getenv('DB_DB') + '?charset=utf8')
    elif os.getenv('DB_TYPE') == "ORACLE":
        engine = create_engine('oracle+pyodbc://' + os.getenv('DB_USER') + ':' + os.getenv('DB_PASSWORD') + '@' + os.getenv('DB_HOST') + '/' + os.getenv('DB_DB'))
    elif os.getenv('DB_TYPE') == "SQLITE":
        engine = create_engine('sqlite:///' + os.getenv('DB_DB'))

# создание подключения к БД
    if os.getenv('DB_TYPE') in ["MYSQL", "POSTGRESQL", "MARIADB", "ORACLE", "SQLITE"]:
        connection = engine.connect()
        if os.getenv('DB_TYPE') in ["MYSQL", "MARIADB"]:
            connection.execute(text('SET NAMES utf8mb4'))
            connection.execute(text('SET CHARACTER SET utf8mb4'))
            connection.execute(text('SET character_set_connection=utf8mb4'))

# формируем запрос для получения общего количества измененных лидов
    try:
        leads_req = requests.get(os.getenv('BITRIX24_WEBHOOK') + 'crm.lead.list.json?ORDER[ID]=ASC&FILTER[>DATE_MODIFY]=' + yesterday).json()
# делаем еще одну попытку
    except Exception as E:
        leads_req = requests.get(os.getenv('BITRIX24_WEBHOOK') + 'crm.lead.list.json?ORDER[ID]=ASC&FILTER[>DATE_MODIFY]=' + yesterday).json()
    leads = {}
    last_lead_id = '0'
# разбираем текущий запрос
    for lead in leads_req["result"]:
        leads[lead['ID']] = lead
        last_lead_id = lead['ID']
# получаем количество лидов для следующего запроса
    if "next" in leads_req:
        leads_next = int(leads_req["next"])
    else:
        leads_next = 0
# получаем лиды пакетами по 50, начиная с последнего измененного вчера
    while leads_next > 0:
        leads_req = requests.get(os.getenv('BITRIX24_WEBHOOK') + 'crm.lead.list.json?ORDER[ID]=ASC&FILTER[>ID]=' + last_lead_id).json()
# разбираем текущий запрос
        for lead in leads_req["result"]:
            leads[lead['ID']] = lead
            last_lead_id = lead['ID']
# получаем количество лидов для следующего запроса
        if "next" in leads_req:
            leads_next = int(leads_req["next"])
        else:
            leads_next = 0

# преобразуем словарь в датафрейм
    data = pd.DataFrame.from_dict(leads, orient='index')
# список ID для удаления из текущих данных
    ids = list(leads.keys())
    del leads
# базовый процесс очистки: приведение к нужным типам
    for col in data.columns:
# приведение целых чисел
        if col in ["COMPANY_ID", "ASSIGNED_BY_ID", "CONTACT_ID", "CREATED_BY_ID", "MODIFY_BY_ID", "MOVED_BY_ID", "ADDRESS_COUNTRY_CODE", "ADDRESS_LOC_ADDR_ID", "LAST_ACTIVITY_BY", "ID"]:
            data[col] = data[col].fillna('').replace('', 0).astype(np.int64)
# приведение вещественных чисел
        elif col in ["OPPORTUNITY"]:
# приведение дат
            data[col] = data[col].fillna('').replace('', 0.0).astype(float)
        elif col in ["DATE_CREATE", "DATE_MODIFY", "DATE_CLOSED", "MOVED_TIME", "LAST_ACTIVITY_TIME"]:
            data[col] = pd.to_datetime(data[col].fillna('').replace('', '2000-01-01T00:00:00+03:00').apply(lambda x: dt.strptime(x, '%Y-%m-%dT%H:%M:%S%z').strftime("%Y-%m-%d %H:%M:%S").replace('202-','2024-')))
# приведение строк
        else:
            data[col] = data[col].fillna('')
    if len(data):
        if "DATE_CREATE" in data.columns:
            data['ts'] = pd.DatetimeIndex(data["DATE_CREATE"]).asi8
# удаление старых данных
        if os.getenv('DB_TYPE') in ["MYSQL", "POSTGRESQL", "MARIADB", "ORACLE", "SQLITE"]:
            connection.execute(text("DELETE FROM " + os.getenv('BITRIX24_TABLE_LEADS') + " WHERE ID IN (" + ",".join(ids) + ")"))
            connection.commit()
        elif os.getenv('DB_TYPE') == "CLICKHOUSE":
            requests.post("https://" + os.getenv('DB_HOST') + ":8443/?database=" + os.getenv('DB_DB') + "&query=DELETE FROM " + os.getenv('DB_PREFIX') + "." + os.getenv('BITRIX24_TABLE_LEADS') + " WHERE ID IN (" + ",".join(ids) + ")",
                headers=auth_post, verify=cacert)
# добавление новых данных
        if os.getenv('DB_TYPE') in ["MYSQL", "POSTGRESQL", "MARIADB", "ORACLE", "SQLITE"]:
# обработка ошибок при добавлении данных
            try:
                data.to_sql(name=os.getenv('BITRIX24_TABLE_LEADS'), con=engine, if_exists='append', chunksize=100)
                connection.commit()
            except Exception as E:
                print (E)
                connection.rollback()
        elif os.getenv('DB_TYPE') == "CLICKHOUSE":
            csv_file = data.to_csv().encode('utf-8')
            requests.post('https://' + os.getenv('DB_HOST') + ':8443', headers=auth_post, verify=cacert,
                params={"database": os.getenv('DB_DB'), "query": 'INSERT INTO ' + os.getenv('DB_PREFIX') + '.' + os.getenv('BITRIX24_TABLE_LEADS') + ' FORMAT CSV'},
                data=csv_file, stream=True)
    if os.getenv('DB_TYPE') in ["MYSQL", "POSTGRESQL", "MARIADB", "ORACLE", "SQLITE"]:
        connection.close()

    return {
        'statusCode': 200,
        'body': "Modified: " + str(len(data))
    }