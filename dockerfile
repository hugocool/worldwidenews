# For more information, please refer to https://aka.ms/vscode-docker-python
FROM python:3.9.1-buster
RUN apt-get update && apt-get -y install locales
# RUN apt-get update --fix-missing&& \
#     apt-get upgrade -y  && \
#     apt-get install -y git

RUN locale-gen nl_NL.UTF-8

# https://stackoverflow.com/questions/53835198/integrating-python-poetry-with-docker
# ARG MY_ENV= Production how and when should this be set?

ENV PORT=8080
EXPOSE ${PORT}


ENV PYTHONIOENCODING=UTF-8
ENV YOUR_ENV=${YOUR_ENV} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.5 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONIOENCODING=UTF-8

# System deps:
RUN pip install "poetry==$POETRY_VERSION"

# Copy only requirements to cache them in docker layer
WORKDIR /app
COPY poetry.lock pyproject.toml /app/
WORKDIR /app
COPY . /app

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN adduser -u 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser


# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
# CMD ["python", "main.py"]
#CMD ["gunicorn", "--bind", "0.0.0.0:${PORT}", "main:app"]
CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 main:app