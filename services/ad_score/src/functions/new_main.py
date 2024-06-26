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

def Hello_pubsub(cloud_event,context):
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
        