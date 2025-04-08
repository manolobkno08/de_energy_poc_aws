
import boto3
import urllib.parse
from datetime import datetime

s3 = boto3.client('s3')

def lambda_handler(event, context):
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        object_key = urllib.parse.unquote_plus(record['s3']['object']['key'])

        print(f"Received file: {object_key}")

        current_date = datetime.now().strftime("%Y%m%d")
        date_partition = f"fecha={current_date}"

        if "clientes" in object_key:
            entity_type = "clientes"
        elif "proveedores" in object_key:
            entity_type = "proveedores"
        elif "transacciones" in object_key:
            entity_type = "transacciones"
        else:
            print("Unrecognized file type")
            return

        original_filename = object_key.split("/")[-1]
        new_key = f"{entity_type}/{date_partition}/{original_filename}"

        s3.copy_object(
            Bucket=bucket,
            CopySource={'Bucket': bucket, 'Key': object_key},
            Key=new_key
        )

        s3.delete_object(Bucket=bucket, Key=object_key)
        print(f"File moved to: {new_key}")
