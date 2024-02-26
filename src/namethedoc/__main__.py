from transformers import pipeline

import config

if __name__ == "__main__":
    print("Starting the server!")

    summarizer = pipeline("summarization", model=config.BASE_MODEL_NAME)
    print(
        "Example summary: %s",
        summarizer("An example document to be summarized.", min_length=3, max_lenght=5),
    )
