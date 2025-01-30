# README
# Project Installation Guide

## Prerequisites

Before you begin, ensure that you have the following installed on your machine:

- **Ruby**: Check Ruby version:
  ```bash
  ruby -v
    ```

- Recommendate ruby version **ruby 3.3.5**

Install Ruby using [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/).

- **Rails**: Check Rails version:

```bash
  rails -v
```

Install Rails 7.2.2 using:

```bash
  gem install rails -v 7.2.2
```

## Setup Projects

run command below:

```bash
    mkdir backend-dev-test
    cd backend-dev-test
    git clone https://github.com/catch-design/be-dev-test
    git clone https://github.com/torrentdu64/backend
    git clone https://github.com/torrentdu64/frontend
```

### Tree Project
Ensure be-dev-test is as the same level as backend and frontend

```
backend-dev-test
│
├── backend
│   └── ...      
│      
├── be-dev-test
|   └── data
│       └── customers.csv
│   
└── frontend
```

## Install Backend

```bash
    cd backend
    bundle install
    rails db:create
    rails db:migrate
    rails test
```
## Populate database

> [!CAUTION]
> to populate database with CSV make sure tree files are correct. 

```bash
    cd backend
    rake csv:import_customers NAME=customers.csv
```

## Install Frontend

Need to install dependency

```bash
    cd frontend
    npm install
```

## Run project

- **backend**
    - ```rails server```
- **frontend**
    - ```npm run dev```