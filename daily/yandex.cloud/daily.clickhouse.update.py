# ������ ��� ����������� ���������� ����������������� ������������� Clickhouse
# ���������� � ���������� ��������� �������
# * DB_TYPE - ��� ���� ������ (���� ��������� ������)
# * DB_HOST - ����� (����) ���� ������
# * DB_USER - ������������ ���� ������
# * DB_PASSWORD - ������ � ���� ������ (���� ���������)
# * DB_DB - ��� ���� ������
# * DB_PREFIX - ������� ���� ������ (����� ���������� �� ����� ��� �������� �����������)

# requirements.txt:
# requests
# sqlalchemy

# timeout: 300
# memory: 128

# ������ ����� ���������
import requests
import os
from sqlalchemy import create_engine, text
from requests.packages.urllib3.exceptions import InsecureRequestWarning
# ������� �������������� Unverified HTTPS request
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

def handler(event, context):
    auth = {
        'X-ClickHouse-User': os.getenv('DB_USER'),
        'X-ClickHouse-Key': context.token["access_token"]
    }
    auth_post = auth.copy()
    auth_post['Content-Type'] = 'application/octet-stream'
    cacert = '/etc/ssl/certs/ca-certificates.crt'
    ret = []

# ������ Materialized Views (ground table) ��� ���������� � ������� ������������
    mvs = ["dict_bxdealid_phone", "dict_bxleadid_phone", "dict_ctphone_attribution_lndc", "dict_ctphone_yclid", "dict_yainstallationid_phone", "dict_yainstallationid_phone_hash", "dict_yainstallationid_yclid", "dict_yclid_attribution_lndc", "mart_mkt_bx_crm_lead", "mart_mkt_bx_crm_deal", "mart_mkt_bx_deals_app", "mart_mkt_bx_leads_app"]
    for mv in mvs:
        req_sql_view = requests.get('https://' + os.getenv('DB_HOST') + ':8443', headers=auth, verify=cacert,
            params={"database": os.getenv('DB_DB'), "query": "SHOW CREATE VIEW " + os.getenv('DB_PREFIX') + "." + mv + "_mv"})
        if req_sql_view.status_code == 200:
            req_sql = req_sql_view.text[req_sql_view.text.find("SELECT"):].replace("\\n"," ").replace("\\","")
# ������� �������
            requests.post('https://' + os.getenv('DB_HOST') + ':8443', headers=auth_post, verify=cacert,
                params={"database": os.getenv('DB_DB'), "query": "TRUNCATE TABLE " + os.getenv('DB_PREFIX') + "." + mv})
# ���������� ������� ������
            requests.post('https://' + os.getenv('DB_HOST') + ':8443', headers=auth_post, verify=cacert,
                params={"database": os.getenv('DB_DB'), "query": "INSERT INTO " + os.getenv('DB_PREFIX') + "." + mv + " " + req_sql})
            ret.append(mv)
    return {
        'statusCode': 200,
        'body': "Updated: " + ','.join(ret)
    }