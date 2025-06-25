import os
from common import *
import genai
# fromgenai import types


genai_api_key = os.getenv('GENAI_API_KEY')
client = genai.Client(api_key=genai_api_key)


def analyze_system_run(data: SystemRunLog):
    prompt = f"""
    You are a system engineer analyzing the run logs of a Cannasol PLC. 
    The run logs are as follows: {data}
    Analyze the run logs and provide a summary of the system run.
    """
    model = client.get_model("gemini-pro")
    response = model.generate_content(prompt)
    return response.text