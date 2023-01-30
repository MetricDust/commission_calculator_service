import json
from urllib.parse import unquote
import boto3
import io
import pandas as pd
import traceback


def modify_input(event):
    result = {}
    path_parameters = event.get("pathParameters") if event.get("pathParameters") else {}
    result.update({k: unquote(v) if isinstance(v, str) else v for k, v in path_parameters.items()})
    result.update(event.get("queryStringParameters") if event.get("queryStringParameters") else {})
    result.update(json.loads(event.get("body")) if event.get("body") else {})
    result.update(event.get("headers") if event.get("headers") else {})
    if 'requestContext' in event:
        result['stage'] = event.get('requestContext', {}).get('stage')
    return result


def Commission(home_value, df):
    for values in range(0, len(df)):
        if (home_value > df['HomeValueMinimum'].iloc[values]) and (home_value <= df['HomeValueMaximum'].iloc[values]):
            return (((home_value * df['PercentageCommission'].iloc[values]) / 100) + df['ValueCommission'].iloc[
                values]), (((home_value * df['PercentageOthersCommision'].iloc[values]) / 100) +
                           df['ValueOthersCommission'].iloc[values])

        elif (home_value >= df['HomeValueMinimum'].iloc[-1]):
            return (((home_value * df['PercentageCommission'].iloc[-1]) / 100) + df['ValueCommission'].iloc[-1]), (
                    ((home_value * df['PercentageOthersCommision'].iloc[-1]) / 100) +
                    df['ValueOthersCommission'].iloc[-1])


def commission_handler(event, context):
    try:
        data = modify_input(event)
        home_value = data['home_value']
        path = data['path']
        print(path)
        root = data["stage"] + "-" + data['root']
        print(root)
        tenant = data['tenant']
        if tenant != data['tenant_name']:
            result = "tenant does not match"
            return returnResponse(400, result)
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=f'{root}', Key=f"{path}")
        df = pd.read_csv(io.BytesIO(obj['Body'].read()))
        tenant_commission, others_commission = Commission(int(home_value), df)
        output = {'tenant_commission': tenant_commission, 'others_commission': others_commission}
        return returnResponse(200, output)
    except Exception as exp:
        print(traceback.format_exc())
        return returnResponse(400, {"message": str(exp)})


def returnResponse(statusCode, body):
    return {
        "statusCode": statusCode,
        "body": json.dumps(body),
        "headers": {
            "Access-Control-Allow-Headers": "*",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET"
        }
    }
