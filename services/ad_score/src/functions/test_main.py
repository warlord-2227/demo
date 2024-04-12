
import lib_main as training
import predict as testing
import pre_process
import utilities
from google.cloud import storage, pubsub_v1
import google.cloud.logging
import logging
import json
import base64
import os 

def Hello_pubsub(cloud_event,context):
    logging.getLogger().setLevel(logging.INFO)
    pubsub_message = base64.b64decode(cloud_event["data"]).decode('utf-8')
    input_data = json.loads(pubsub_message)
    logging.info(f"Keys in it {input_data.keys()}")
    publisher = pubsub_v1.PublisherClient()
    # result_topic = "projects/my-project-6242-308916/topics/pubsub-ad_score-meta-dev"
    result_topic = os.getenv('RESULT_TOPIC')
    json_output = {"abc":1}
    future = publisher.publish(result_topic, data=json.dumps(json_output).encode('utf-8'))
    