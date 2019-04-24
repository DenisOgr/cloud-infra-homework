# Cloud-infra-homework
##### Student: Porplenko Denys. UCU 2019
Основна ідея домашнього завдання - створити сервіс, який виконує завдання, що вимагає ресурсів для роботи (завантажує CPU мінімум на 70%) та потребує масштабування. В якості сервісів, що можуть виконуватися можна взяти будь-які складні математичні обчислення, в тому числі з тематики машинного навчання, але не обов'язково. Наприклад - тренування класифікатора, або факторизація цілого числа, задача комівояжера і т.і. При цьому вітається повторне використання програмного коду, в тому числі отриманого із відкритих джерел із зазначенням посилання на автора (вирішення самої задачі не має бути точкою фокусування уваги студента).

Обов'язково повинен бути елементарний інтерфейс для запуску функції обчислення  та результат такого обчислення. Складність підібрати таким чином. щоб один виклик сервісу виконувався від 5 до 10 хвилин, або могла задаватися користувачем (щоб уникнути "вічних" обчислень, або секундних пікових завантажень)


### Критерії оцінювання:

1. Сервіс та докерфайл, або посилання на репозиторій з файлом-образом, з інструкцією як запускати - 60 балів.

2. Скрипти YAML для завантаження в Kubernetes,  - 5 балів.

3. Bash скрипт, який інсталює сервіс в MiniKube автоматично - 5 балів.

4. Kubernetes Readiness check + Liveness check - 5 балів.

5. Bash скрипт для локального деплою в minikube (без хмарного реєстру контейнерів) - 5 балів

6. Здати завдання (будь-яка кількість виконаних пунктів) достроково, до 23:59, 16 березня - 5 балів

7. Реалізувати Memory scaling (імітувати задачу, що потребує багато пам'яті і вирішити проблему масштабування у випадку досягнення критичного розміру по використанню пам'яті) - до 5 - 15 балів

# Solution
You need to copy `.env.dist` file to `.env`:
~~~bash
cp .env.dist .env
~~~
#### API document:
Main page. Show env variables:
```
GET /
```

Status page:
```
GET /status
```
Load CPU for 10 seconds
```
GET /run_cpu/10
```

Load memory (RAM) for 10 seconds
```
GET /run_ram/10
```
#### CLI document:
~~~bash
make help
Homwwork Kubertets
                   Available targets:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            create: Create deploment, services, pods, hpa`s
    create_cluster: Create minicube claster and open dashboard
 create_from_local: Create deploment (images ONLY from local rep), services, pods, hpa`s
              desc: Describe deploment, services, pods, hpa`s
           destroy: Remove deploment, services, pods, hpa`s
   destroy_cluster: Destroy minicube claster
              help: Show this help and exit (default target)
          load_cpu: Load CPU. Necessarily use argument secs={time}. For example: make load_cpu secs=10
       load_memory: Load memory. Necessarily use argument secs={time}. For example: make load_cpu secs=10
              show: Show deploment, services, pods, hpa`s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
~~~


##### Сервіс та докерфайл, або посилання на репозиторій з файлом-образом, з інструкцією як запускати - 60 балів.
Build service (docker image):
~~~bash
docker build . -t denisog/homework-load-cpu:0.7
~~~
Run service:
~~~bash
docker run  -d --rm -p 8080:5000 denisog/homework-load-cpu:0.7
~~~

##### Скрипти YAML для завантаження в Kubernetes, - 5 балів.
There are configs in `/kubernetes` directory.

#### Bash скрипт, який інсталює сервіс в MiniKube автоматично - 5 балів
~~~bash
make create_cluster
make create
~~~
#### Kubernetes Readiness check + Liveness check - 5 балів.
This features described in `/kubernetes/development.yml` file.
```
    livenessProbe:
          httpGet:
            path: /status
            port: 5000
          initialDelaySeconds: 60
          periodSeconds: 5
        readinessProbe:
          httpGet:
            path: /status
            port: 5000
          initialDelaySeconds: 60
          periodSeconds: 5
```
```
GET /status - 200 OK
```
##### Bash скрипт для локального деплою в minikube (без хмарного реєстру контейнерів) - 5 балів
This features described in `/kubernetes/development_local_repository.yml` file.

**How to imitate?**
You should connect your local Docker CLI to work with Minikube docker repository. And build image.
```
eval $(minikube docker-env)
docker build . -t denisog/homework-load-cpu:0.7
```
~~~bash
make create_cluster
make create_from_local
~~~

##### Реалізувати Memory scaling (імітувати задачу, що потребує багато пам’яті і вирішити проблему масштабування у випадку досягнення критичного розміру по використанню пам’яті) - до 5 - 15 балів

Prepare create cluster and entities(deploments, pods, services, HPAs):
~~~bash
make create_cluster
make create
~~~
Waiting time while pods will running....
Show:
~~~bash
make show
~~~

**How to imitate CPU autoscaling?**
This features described in `/kubernetes/autoscale-cpu.yml` file.
```
GET /run_cpu/60
```
or
~~~bash
make load_cpu
~~~
And see result:
~~~bash
make show
~~~
or
~~~bash
make desc
~~~

**How to imitate Memory autoscaling?**
This features described in `/kubernetes/autoscale-memory.yml` file.
```
GET /run_ram/60
```
or
~~~bash
make load_memory
~~~
And see result:
~~~bash
make show
~~~
or
~~~bash
make desc
~~~
