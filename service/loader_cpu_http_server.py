from flask import Flask
from multiprocessing import Pool, Process
from multiprocessing import cpu_count
from time import sleep
import os

app = Flask(__name__)
@app.route("/")
def hello():
    return "<h3>This is loader CPU service!</h3> <h4>Env:</h4>" + "<br>".join("<b>%s</b> : %s"%l for l in list(os.environ.items()))


@app.route("/run_cpu/<secs>")
def run_cpu(secs=10):
    processes = [create_processes(x, f_cpu) for x in range(cpu_count())]
    [start_processes(x) for x in processes]
    secs = int(secs)
    sleep(secs)
    [stop_processes(x) for x in processes]
    return "I loaded CPUs (number: %s) for %s secs" % (cpu_count(), secs)


@app.route("/run_ram/<secs>")
def run_ram(secs=10):
    processes = [create_processes(x, f_ram) for x in [1]]
    [start_processes(x) for x in processes]
    secs = int(secs)
    sleep(secs)
    [stop_processes(x) for x in processes]
    return "I loaded RAM %s secs" % secs



@app.route("/status")
def status():
    return "service is running!"


##############Service############
def f_cpu(x):
    while True:
        x*x


def f_ram(x):
    a = []
    while True:
        print(len(a))
        a.append(' ' * 100)


def create_processes(x,func):
    return Process(target=func, args=(x,))


def start_processes(p: Process):
    p.start()


def stop_processes(p: Process):
    p.terminate()


if __name__ == '__main__':

    app.run(debug=True, host='0.0.0.0')
