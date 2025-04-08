from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col
from pyspark.context import SparkContext
import sys


class DataProcessor:
    def __init__(self, source_path: str, destination_path: str):
        self.sc = SparkContext.getOrCreate()
        self.glueContext = GlueContext(self.sc)
        self.spark = self.glueContext.spark_session
        self.logger = self.glueContext.get_logger()
        self.job = Job(self.glueContext)
        self.source_path = source_path
        self.destination_path = destination_path

    def read_data(self, database: str, table: str):
        try:
            self.logger.info(f"Reading from Glue Catalog: {database}.{table}")
            df = self.glueContext.create_dynamic_frame.from_catalog(
                database=database,
                table_name=table
            ).toDF()
            self.logger.info(
                f"Read completed. Rows: {df.count()}, Columns: {len(df.columns)}")
            return df
        except Exception as e:
            self.logger.error(f"Failed to read data: {e}")
            raise

    def transform_data(self, df):
        self.logger.info("Applying basic transformations")
        df_cleaned = df.dropna(how="all")
        return df_cleaned

    def save_data(self, df, table: str):
        try:
            output_path = f"{self.destination_path}{table}"
            self.logger.info(f"Saving transformed data to: {output_path}")
            df.write.mode("overwrite").parquet(output_path)
        except Exception as e:
            self.logger.error(f"Failed to write data: {e}")
            raise


def main():
    args = getResolvedOptions(sys.argv, [
        'JOB_NAME',
        'GLUE_DATABASE',
        'TABLE_NAME',
        'S3_SOURCE_PATH',
        'S3_DESTINATION_PATH'
    ])

    processor = DataProcessor(
        source_path=args['S3_SOURCE_PATH'],
        destination_path=args['S3_DESTINATION_PATH']
    )

    try:
        df = processor.read_data(args['GLUE_DATABASE'], args['TABLE_NAME'])
        df_transformed = processor.transform_data(df)
        processor.save_data(df_transformed, args['TABLE_NAME'])
    except Exception as e:
        processor.logger.error(f"ETL job failed for {args['TABLE_NAME']}: {e}")
        sys.exit(1)
    finally:
        processor.job.commit()


if __name__ == "__main__":
    main()
