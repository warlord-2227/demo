
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

def hello_pubsub(cloud_event,context):
    try:
        logging.getLogger().setLevel(logging.INFO)
        pubsub_message = base64.b64decode(cloud_event["data"]).decode('utf-8')
        input_data = json.loads(pubsub_message)
        logging.info(f"Keys in it {input_data.keys()}")
        publisher = pubsub_v1.PublisherClient()
        result_topic = "projects/my-project-6242-308916/topics/pubsub-result-topic"
        # result_topic = os.getenv('RESULT_TOPIC')
        json_output = {"abc":1}
        future = publisher.publish(result_topic, data=json.dumps(json_output).encode('utf-8'))
    except KeyError as e:
        print(f"KeyError - missing key: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")
           