# Inspired by: https://medium.com/@albertazzir/blazing-fast-python-docker-builds-with-poetry-a78a66f5aed0

### Builder image:
FROM python:3.12-bookworm as builder

RUN pip install poetry==1.8.1

ENV POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_VIRTUALENVS_CREATE=1

WORKDIR /app

COPY pyproject.toml poetry.lock ./
RUN touch README.md

# Install dependencies only, to have them in the first layer:
RUN poetry install --without dev --no-root && rm -rf $POETRY_CACHE_DIR

### Intermediate image (cached model):
FROM python:3.12-bookworm as model

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"
    
WORKDIR /app

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

COPY src/config ./config
COPY src/prepare ./prepare

# Run the preparation script, populating the model cache
RUN python -m prepare

### Runtime image (clear, runtime only):
FROM python:3.12-slim-bookworm as runtime

ENV VIRTUAL_ENV=/app/.venv \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

COPY --from=model ${VIRTUAL_ENV} ${VIRTUAL_ENV}
COPY --from=model /root/.cache/huggingface /root/.cache/huggingface
COPY --from=model /app/config /app/config
COPY ./src/namethedoc ./namethedoc

ENTRYPOINT ["python", "-m", "namethedoc"]
CMD []