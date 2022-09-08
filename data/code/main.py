def hello_gcp(event, context):
    from datetime import datetime
    import json
    import base64
    import os

    pubsub_message = base64.b64decode(event['data']).decode('utf-8')
    print(pubsub_message)
    j = json.loads(pubsub_message)
    print(j)
