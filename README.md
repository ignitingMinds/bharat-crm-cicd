## Bharat-CRM-CICD

## commands :
    ~ sh server_up.sh
    ~ sh server_down.sh

## configs folder structure
```
- config
    - .env
    - config.yaml
```

we will not add any configuration file on github these file will be store on server
like in this case all the config files are store in /config folder which is created on server

## note :
all the host should be written as service names 
eg :- 
```
- localhost:5432 for pg      --> db-crm
- localhost:6379 for redis   --> cache-redis
```

Reason is that all of the above are comming under same docker
network so there name will act like a dns-host and they will 
be resolved internally 

## server_up.sh
- this will contain code to up the crm including db, cache and backend, frontend
- ever time when we run the script bharat-crm will get removed and new
folder with the same name will be create again

## server_down.sh
- this will contain down code which will down all the things which are 
running



