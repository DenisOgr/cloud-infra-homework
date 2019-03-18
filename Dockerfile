FROM python:3.7


COPY ./service /service
WORKDIR /service

CMD ["./loader_cpu"]
