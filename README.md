# DevOps project

## Что это за проект

Этот репозиторий содержит небольшой, но максимально приближённый к боевым условиям DevOps-проект.

Цель проекта — продемонстрировать следующие навыки:
- сборка Docker-образов и контейнеризация приложений
- написание и проверка Bash-скриптов
- работа с Git (feature-ветки, pull request’ы, merge)
- построение CI-pipeline с использованием GitHub Actions
- базовое smoke-тестирование контейнера после сборки

---
## Описание
Тестовое задание на позицию DevOps-инженера.
Цель — продемонстрировать базовые навыки работы с Docker, Bash, Git и понимание CI/CD-процессов.

Все задания выполнены локально в Linux-среде.

---
## Требования
- Linux / macOS / Windows (WSL)
- Docker
- Docker Compose
- Git

---
## Быстрый старт

### 1. Клонировать репозиторий
```bash
git clone https://github.com/Aleksandrlee/test-project.git
cd test-project

```

### 2. Собрать Docker-образ
docker build -t my-web-app:local .

### 3. Запустить контейнер
docker run -d -p 8080:80 --name my-web-app my-web-app:local

### 4. Проверить работу приложения

Откройте в браузере:

http://localhost:8080

Или выполните команду:

curl http://localhost:8080

### 5. Остановить и удалить контейнер
docker rm -f my-web-app

---
## CI / CD

В проекте настроен CI-pipeline с использованием **GitHub Actions**.

Pipeline автоматически запускается в следующих случаях:
- при push в ветку `master`
- при создании или обновлении pull request
- вручную через `workflow_dispatch`

### Этапы CI-pipeline

CI состоит из нескольких независимых задач:

#### 1. Lint — ShellCheck
- проверка Bash-скрипта `clean_old_logs.sh`
- выявление синтаксических ошибок и потенциальных проблем

#### 2. Lint — Yamllint
- проверка YAML-файлов GitHub Actions
- контроль форматирования и структуры workflow

#### 3. Build + Smoke test
- сборка Docker-образа приложения
- валидация `docker-compose.yml`
- запуск контейнера
- smoke-тест: проверка доступности HTTP-сервиса и ожидаемого ответа

Pipeline настроен таким образом, что сборка выполняется **только при успешном прохождении всех линтеров**.

### Best practices, реализованные в CI

- разделение lint-задач по типам (ShellCheck / Yamllint)
- минимальные permissions (`contents: read`)
- отмена старых прогонов при новых push (`concurrency`)
- таймауты на jobs
- обязательное прохождение CI перед merge в `master`

---
## B3 — Концепция CI/CD (сборка + Docker Hub + Telegram)

Ниже — логика, что происходит, когда разработчик пушит код в ветку `main`/`master` в GitHub/GitLab:

1. **Push в main/master** — разработчик отправляет изменения в репозиторий.
2. **CI стартует pipeline** — GitHub Actions / GitLab CI запускает сценарий.
3. **Checkout кода** — runner забирает код репозитория.
4. **Запуск тестов** — выполняются проверки (например, lint/юнит-тесты).  
   Если тесты упали — pipeline завершается ошибкой.
5. **Сборка Docker-образа** — собирается image из Dockerfile.
6. **Логин в Docker Hub** — CI использует секреты (`DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`) для авторизации.
7. **Пуш образа в Docker Hub** — образ публикуется в registry (например, теги `latest` и `commit-sha`).
8. **Уведомление в Telegram** — отправляется сообщение об **успехе** или **провале** pipeline (через bot token / webhook).

---
## Запуск через Docker Compose

Для быстрого локального запуска можно использовать Docker Compose.

### 1. Запуск

```bash
docker compose up -d --build

```
### 2. Проверка

Открой в браузере:

http://localhost:8080

Или проверь через curl:

curl -fsS http://localhost:8080

### 3. Остановка и очистка
docker compose down

---
## Структура проекта

```text
.
├── Dockerfile
├── docker-compose.yml
├── index.html
├── clean_old_logs.sh
├── .gitignore
└── README.md

```                      

---
## Возможные улучшения

При дальнейшем развитии проекта можно реализовать следующие улучшения:

- публикацию Docker-образа в Docker Registry (Docker Hub / GHCR)
- добавление stage deploy в CI/CD pipeline
- использование `.env` файлов для конфигурации
- добавление unit-тестов приложения
- использование Trivy или Grype для security-сканирования образов
- настройку branch protection rules (запрет merge без CI)
