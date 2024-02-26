"""
Downloads the model and caches it, if it's not already available.
Run as part of the build process.
"""

from transformers import pipeline

from .. import config

if __name__ == "__main__":
    print("Preparing the model...")
    pipeline("summarization", model=config.BASE_MODEL_NAME)