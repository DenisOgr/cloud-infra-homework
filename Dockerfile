FROM python:3.7

COPY . /app
WORKDIR /app
EXPOSE 80
#RUN pip install --upgrade pip

RUN pip install -r requirements.txt

ENTRYPOINT ["python"]
CMD ["service/loader_cpu_http_server.py"]