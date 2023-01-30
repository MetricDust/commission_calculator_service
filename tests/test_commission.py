import unittest
import app
import json

stage = 'beta'


class MyTestCase(unittest.TestCase):

    def test_1_commission(self):
        event = {
            "pathParameters": {
                "tenant": "shaikagency"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagency"

                        },
            "queryStringParameters": {
                "home_value": '500000',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name": "shaikagency"
            },
            "requestContext": {"stage": "beta"}
        }
        res = app.commission_handler(event, None)
        print(res)
        res_body = json.loads(res['body'])
        assert res['statusCode'] == 200
        assert res_body["tenant_commission"] == 8000.0
        assert res_body["others_commission"] == 1000.0

    def test_2_commission(self):
        event = {
            "pathParameters": {
                "tenant": "tenant"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagency"

                        },
            "queryStringParameters": {
                "home_value": '800000',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name":"shaikagency"
            },
            "requestContext": {"stage": "beta"}
        }
        res = app.commission_handler(event, None)
        print(res)
        res_body = json.loads(res['body'])
        assert res['statusCode'] == 200
        assert res_body["tenant_commission"] == 26000.0
        assert res_body["others_commission"] == 2000.0

    def test_3_commission(self):
        event = {
            "pathParameters": {
                "tenant": "tenant"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagency"

                        },
            "queryStringParameters": {
                "home_value": '2100000',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name":"shaikagency"
            },
            "requestContext": {"stage": "beta"}
        }
        res = app.commission_handler(event, None)
        print(res)
        res_body = json.loads(res['body'])
        assert res['statusCode'] == 200
        assert res_body["tenant_commission"] == 57000.0
        assert res_body["others_commission"] == 65500.0

    def test_4_commission(self):
        event = {
            "pathParameters": {
                "tenant": "tenant"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagency"

                        },
            "queryStringParameters": {
                "home_value": '5500000',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name":"shaikagency"
            },
            "requestContext": {"stage": "beta"}
        }
        res = app.commission_handler(event, None)
        print(res)
        res_body = json.loads(res['body'])
        assert res['statusCode'] == 200
        assert res_body["tenant_commission"] == 362000.0
        assert res_body["others_commission"] == 448000.0

    # path is incorrect
    def test_1_commission_fail(self):
        event = {
            "pathParameters": {
                "tenant": "shaikagencya"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagencyy"

                        },
            "queryStringParameters": {
                "home_value": ' 170000',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name": "shaikagency"
            },
            "requestContext": {"stage": "beta"}

        }
        res = app.commission_handler(event, None)
        print(res)
        assert res['statusCode'] == 400

    # value is incorect
    def test_2_commission_fail(self):
        event = {
            "pathParameters": {
                "tenant": "tenant"
            },
            "headers": {"apikey": "778a7eaf-b774-4373-b457-df57cc0777c4",
                        "tenant": "shaikagency"

                        },
            "queryStringParameters": {
                "home_value": ' 170000a',
                "path": "shaikagency/public/commission/csv/test1/1662547041_commission.csv",
                "root": "document-manager-storage",
                "tenant_name": "shaikagency"
            },
            "requestContext": {"stage": "beta"}
        }
        res = app.commission_handler(event, None)
        print(res)
        assert res['statusCode'] == 400
