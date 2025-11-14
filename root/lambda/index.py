import os
import json
from datetime import datetime

def lambda_handler(event, context):
    # Read environment variable passed from Terraform
    greeting = os.getenv("GREETING", "Hello")

    # Get current server time in ISO format
    server_time = datetime.utcnow().isoformat() + "Z"

    # Build JSON response
    response = {
        "greeting": greeting,
        "server_time": server_time
    }

    return {
        "statusCode": 200,
        "headers": { "Content-Type": "application/json" },
        "body": json.dumps(response)
    }
