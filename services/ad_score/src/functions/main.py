
import base64
import json
import numpy as np
import pandas as pd
import pickle
import joblib
import sklearn
from google.cloud import storage, pubsub_v1
import google.cloud.logging
import logging
from io import BytesIO
from ad_scoring import ad_scoring_model
import os 
ad_model = ad_scoring_model()
client = google.cloud.logging.Client(project="project")
client.setup_logging()

def hello_pubsub(cloud_event,context):
    # Print out the data from Pub/Sub, to prove that it worked
    #TODO clear all the     
    # result_topic = os.getenv('RESULT_TOPIC')
    logging.getLogger().setLevel(logging.INFO)
    # env_variables = {"result_topic":result_topic,"bucket_name":os.getenv('BUCKET_NAME')}
    try:
        ad_model.predicting_model(cloud_event)
        logging.info(f"Successfully worked")
    except Exception as e:
        logging.info(f"error as {e}")
        

# def hello_pubsub(cloud_event,context):
#     try:
#         logging.getLogger().setLevel(logging.INFO)
#         logging.info(f"cloud_even_data{cloud_event.keys()}")
#         pubsub_message = base64.b64decode(cloud_event["data"]).decode('utf-8')
#         input_data = json.loads(pubsub_message)
#         logging.info(f"Keys in it {input_data.keys()}")
#         publisher = pubsub_v1.PublisherClient()
#         result_topic = "projects/my-project-6242-308916/topics/pubsub-result-topic"
#         # result_topic = os.getenv('RESULT_TOPIC')
#         json_output = {"abc":1}
#         future = publisher.publish(result_topic, data=json.dumps(json_output).encode('utf-8'))
#     except KeyError as e:
#         print(f"KeyError - missing key: {e}")
#         logging.info(f"KeyError - missing key: {e}")
#     except Exception as e:
#         logging.error(f"and erro through error log{e}")
#         logging.info(f"An error occurred: {e}")
           