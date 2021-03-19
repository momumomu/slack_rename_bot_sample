import boto3

def def_get_ssm_parameter(parameter_name, with_decryption):
    #arg1: パラメータストア名
    #arg2: 暗号化しているか(True)、否(False)か。

    ssm = boto3.client("ssm", region_name="ap-northeast-1")
    res = ssm.get_parameters(
        Names=[
            parameter_name
        ],
        WithDecryption=with_decryption
    )
    parameter_value = res["Parameters"][0]["Value"]
    return parameter_value