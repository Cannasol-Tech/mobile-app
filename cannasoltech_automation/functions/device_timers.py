import requests

INVALID_REQUEST_ERR = -1

SERVER_URL = "https://device-timers-681058687134.us-central1.run.app"

def send_timer_request(device_id, op, api_key=None):
    """
    Sends a POST request to the Flask server to start the timer for the specified device.

    Args:
        device_id (str): The ID of the device (e.g., "SIMULATION-DEVICE-1").
        server_url (str): The base URL of your Flask server (e.g., "https://device-timers-xyz.a.run.app").
        api_key (str, optional): An API key for authentication, if your server requires it.

    Returns:
        dict: The JSON response from the server if the request was successful.
        None: If the request failed.
    """
    print(f"DEBUG -> device timer operation = {op}")
    if op not in ["start", "stop", "reset"]:
        return INVALID_REQUEST_ERR
    
    # Define the endpoint URL
    endpoint = f"{SERVER_URL}/api/timer/{op}"

    # Define the payload
    payload = {
        "device-id": device_id
    }

    # Define the headers
    headers = {
        "Content-Type": "application/json"
    }

    # If an API key is provided, add it to the headers
    if api_key:
        headers["Authorization"] = f"Bearer {api_key}"

    try:
        # Send the POST request
        response = requests.post(endpoint, json=payload, headers=headers, timeout=10)  # 10 seconds timeout

        # Raise an exception if the request was unsuccessful
        response.raise_for_status()

        # Return the JSON response
        return response.json()

    except requests.exceptions.HTTPError as http_err:
        print(f"HTTP error occurred: {http_err} - {response.text}")
    except requests.exceptions.ConnectionError as conn_err:
        print(f"Connection error occurred: {conn_err}")
    except requests.exceptions.Timeout as timeout_err:
        print(f"Timeout error occurred: {timeout_err}")
    except requests.exceptions.RequestException as req_err:
        print(f"An error occurred: {req_err}")

    return None

def start_run_timer(device_id, api_key=None):
    print(f"DEBUG -> starting run timer for device_id = {device_id}")
    response = send_timer_request(device_id, op="start", api_key=api_key)
    print(f"DEBUG -> response = {response}")
    
def stop_run_timer(device_id, api_key=None):
    print(f"DEBUG -> stopping run timer for device_id = {device_id}")
    response = send_timer_request(device_id, op="stop", api_key=api_key)
    print(f"DEBUG -> response = {response}")

    
def reset_run_timer(device_id, api_key=None):
    print(f"DEBUG -> resetting run timer for device_id = {device_id}")
    response = send_timer_request(device_id, op="reset", api_key=api_key)
    print(f"DEBUG -> response = {response}")
