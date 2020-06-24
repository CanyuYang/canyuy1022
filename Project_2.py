#1 Data from mysql
import mysql.connector
mydb = mysql.connector.connect(host="localhost",user="root",password="ycy19941022", database="ClassicModels")
mycursor = mydb.cursor()
mycursor.execute("SELECT * FROM customers")
myresult = mycursor.fetchall()
for x in myresult:
  print(x)


#2 Data from csv
import numpy as np
import pandas as pd
from pandas import Series, DataFrame
import json
csv_data = pd.read_csv('/Users/jasmine/Downloads/customer.csv')



#3 S3 buckets
import boto3
import botocore
from boto3.session import Session

foo = 'AKIA4GC25EXFQ5VFVA5C'
bar = 'moFZBKB+QU33NTYcZH1FcGyd9C9lNZjsNWU/CI7n'
session = Session(aws_access_key_id= foo, aws_secret_access_key=bar, region_name='us-west-1')
s3 = session.client("s3")

s3.download_file(Filename='customers', Key='customers/customer.txt', Bucket='mandt')

s3 = boto3.client('s3',aws_access_key_id=foo, aws_secret_access_key=bar)
f = s3.get_object(Bucket=bucket, Key=key)
contents = f['Body'].read()
print(contents)

#4 SQS Message
import boto
import boto.sqs
from boto.sqs.message import Message
sqs_conn= boto.connect_sqs('AKIA4GC25EXFQ5VFVA5C','moFZBKB+QU33NTYcZH1FcGyd9C9lNZjsNWU/CI7n')
sqs_conn.get_all_queues()
q1 = sqs_conn.create_queue('devworks-sqs-1')
all_queues = sqs_conn.get_all_queues()
len(all_queues)
for q in all_queues:
    print (q.id)
    print (q.count())
    print (q.get_timeout())
    print (q.url)
m1 = Message()
m1.set_body('{“customer”:”johnson”, “phone”:”408-483-8824”}')
status = q1.write(m1)
print (status)
msgs = q1.get_messages()
for msg in msgs:
    print ("Queue ID: ", msg.queue.id)
    print ("Message Body: ", msg.get_body())
me = msg.get_body()
print(me)


import boto3
sqs= boto3.resource('sqs',aws_access_key_id=foo, aws_secret_access_key=bar)
for queue in sqs.queues.all():
    print(queue.url)

#5 MongoDB
import pymongo
import pprint
hiddenimports=['dns']
import pandas as pd
from pymongo import MongoClient
import dns
client = pymongo.MongoClient("mongodb+srv://jasmine:KceTQ5YXgUcCLVVY@cluster0-0ri7y.mongodb.net/Customers?retryWrites=true&w=majority")
db = client.Customers
collection = db.Customer
data_m1 = collection.find()
for x in data_m1 :
  print(x)

data_m2 = pd.DataFrame(list(collection.find()))
print(data_m2)
for x in data_m2 :
  print(x)

#6 Restful API
import os
from flask import Flask
def create_app(test_config=None):
    """Create and configure an instance of the Flask application."""
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        # a default secret that should be overridden by instance config
        SECRET_KEY="dev",
        # store the database in the instance folder
        DATABASE=os.path.join(app.instance_path, "flaskr.sqlite"),
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile("config.py", silent=True)
    else:
        # load the test config if passed in
        app.config.update(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    @app.route("/customers")
    def show_entries():
        from flaskr.db import get_db
        db = get_db()
        cur = db.execute('SELECT customer_number, customer_lastName, customer_firstName FROM user order by id')
        uListStr = ""
        for row in cur.fetchall():
            uListStr += 'ID: '+str(row[0])+'      \t '+'Username：'+str(row[1])+ '    \r'+str(row[2])
        return uListStr

bp.route('/api/v1.0/customers', methods=['GET'])
def get_users():
    db = get_db
    users = db.execute(
        "SELECT id, username  FROM customer"
        "order by id "
    ).fetchall()
    return jsonify({'tasks': customer})

bp.route('/api/v1.0/customers/customer_number', methods=['GET'])
def get_users():
    db = get_db
    users = db.execute(
        "SELECT id, username  FROM customer where customer_number = ?"(customer_number,)
        "order by id "
    ).fetchone()
    return jsonify({'tasks': customer_number})

import pyodbc
 
conn = pyodbc.connect(
    r'DRIVER={ZappySys JSON Driver};'
    )
cursor = conn.cursor()	
 
#execute query to fetch data from API service
cursor.execute("SELECT CustomerNum,customer_lastName,customer_firstName, phone, address,city,state,postalcode,country FROM customer with SRC = http://127.0.0.1:5000//api/v1.0/customers"
) 
row = cursor.fetchone() 
while row: 
    print (row[0:9]) 
    row = cursor.fetchone()

##7 store in 
# DynamoDB
import boto3
foo = 'AKIA4GC25EXFQ5VFVA5C'
bar = 'moFZBKB+QU33NTYcZH1FcGyd9C9lNZjsNWU/CI7n'
dy = boto3.client('dynamodb',aws_access_key_id=foo, aws_secret_access_key=bar)
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('customer')
response= dy.batch_write_item(RequestItems=data_m1)
items = data_m1
with table.batch_writer() as batch:
    for r in items:
        batch.put_item(Item=r)
# Bigtable 
import datetime

from google.cloud import bigtable
from google.cloud.bigtable import column_family
from google.cloud.bigtable import row_filters
client = bigtable.Client(project=project_id, admin=True)
instance = client.instance(instance_id)
print('Creating the {} table.'.format(table_id))
table = instance.table(table_id)

print('Creating column family cf1 with Max Version GC rule...')
# Create a column family with GC policy : most recent N versions
# Define the GC policy to retain only the most recent 2 versions
max_versions_rule = column_family.MaxVersionsGCRule(2)
column_family_id = 'cf1'
column_families = {column_family_id: max_versions_rule}
if not table.exists():
    table.create(column_families=column_families)
else:
    print("Table {} already exists.".format(table_id))

rows = []
column = 'data_m2'.encode()
for i, value in enumerate('data_m2'):
       row_key = 'data_m2{}'.format(i).encode()
    row = table.direct_row(row_key)
    row.set_cell(column_family_id,
                 column,
                 value,
                 timestamp=datetime.datetime.utcnow())
    rows.append(row)
table.mutate_rows(rows)
row_filter = row_filters.CellsColumnLimitFilter(1)
# Links, Python access, Query 
import pyodbc  
  
DBfile = r"test.mdb"  
conn = pyodbc.connect(r"Driver={Driver do Microsoft Access (*.mdb)};DBQ=" + DBfile + ";Uid=;Pwd=;")  

cursor = conn.cursor()  
SQL = "SELECT * from customer;"  
for row in cursor.execute(SQL):  
    print row  
cursor.close()  
conn.close() 

#8 Kafka
from time import sleep
from json import dumps
from kafka import KafkaProducer
producer = KafkaProducer(bootstrap_servers=['localhost:9092'],
                         value_serializer=lambda x: 
                         dumps(x).encode('utf-8'))
for e in range(1000):
    data = {'number' : e}
    producer.send('numtest', value=data)
    sleep(5)

from kafka import KafkaConsumer
from pymongo import MongoClient
from json import loads

consumer = KafkaConsumer(
    'numtest',
     bootstrap_servers=['localhost:9092'],
     auto_offset_reset='earliest',
     enable_auto_commit=True,
     group_id='my-group',
     value_deserializer=lambda x: loads(x.decode('utf-8')))

client = MongoClient('localhost:27017')
collection = client.numtest.numtest

for message in consumer:
    message = message.value
    collection.insert_one(message)
    print('{} added to {}'.format(message, collection))


#9 Redis
import redis
 
conn = redis.Redis(host='192.168.26.128', port='6379')

conn.mset(customer_number = '546', lastName = 'Labrune',firstName = 'Janine',phone = '40.67.8555')
data_r = conn.mget('customer_number','lastName','firstName','phone')

#10 cloudwatch
s3 = boto3.resource('s3') 
s3_client = boto3.client('s3') 

command = "aws cloudwatch get-metric-statistics --metric-name BucketSizeBytes --namespace AWS/S3 --start-time {} --end-time {} --statistics Average --unit  Bytes --region {} --dimensions Name=BucketName,Value={} Name=StorageType,Value=StandardStorage --period 86400 --output json" 

for bucket in s3.buckets.all(): 
    region = s3_client.get_bucket_location(Bucket=bucket.name) 
    region_name = region['LocationConstraint'] 

    start_date = datetime.now() - timedelta(days=7) 
    start_date_str = str(start_date.date()) + 'T00:00:00Z' 
    end_date = datetime.now() 
    end_date_str = str(end_date.date()) + 'T00:00:00Z' 
    cmd = command.format(start_date_str, end_date_str, region_name, bucket.name) 
    res = subprocess.check_output(cmd, stderr=subprocess.STDOUT) 
    bucket_stats = json.loads(res.decode('ascii')) 
    if len(bucket_stats['Datapoints']) > 0: 
     print(bucket_stats['Datapoints']) 

#11 cronjob

# retrive the data at the first day of every month on 10am
0 10 1 * * /Users/jasmine/Downloads/Project_2.py
