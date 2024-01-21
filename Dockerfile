FROM python:3.10-slim

ENV APP_DIR /app
WORKDIR ${APP_DIR}

COPY requirements.txt ${APP_DIR}

RUN apt-get update && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY ./src/ ${APP_DIR}/rstan/tanoshiibais01/


# 環境変数設定
RUN export PYTHONPATH=/app

# Jupyter Lab
RUN jupyter lab --generate-config
RUN sed -i -e "s/# c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" ~/.jupyter/jupyter_notebook_config.py && \
   sed -i -e 's/# c.NotebookApp.allow_root = False/c.NotebookApp.allow_root = True/g' ~/.jupyter/jupyter_notebook_config.py
