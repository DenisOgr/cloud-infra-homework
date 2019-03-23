from flask import Flask
from multiprocessing import Pool, Process
from multiprocessing import cpu_count
from time import sleep

app = Flask(__name__)
@app.route("/")
def hello():
    return "This is loader CPU service!"


@app.route("/run/<secs>")
def run(secs=10):
    processes = [create_processes(x) for x in range(cpu_count())]
    [start_processes(x) for x in processes]

    sleep(secs)
    [stop_processes(x) for x in processes]
    return "I loaded CPUs (number: %s) for %s secs" % (cpu_count(), secs)


@app.route("/status")
def status():
    return "service is running!"

##############Service############


def f(x):
    while True:
        x*x


def create_processes(x):
    return Process(target=f, args=(x,))


def start_processes(p: Process):
    p.start()


def stop_processes(p: Process):
    p.terminate()


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
