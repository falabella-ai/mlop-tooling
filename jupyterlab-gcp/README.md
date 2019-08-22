# Entorno docker para data people

## Versión JupyterLab GCP

### Instrucciones

1. Instalar ghclone
````
pip3 install -e git+git://github.com/HR/github-clone#egg=ghclone
````

2. Clonar este repo (folder)
````
ghclone https://github.com/falabella-ai/mlop-tooling/tree/master/jupyterlab-gcp
````
3. Instalar imagen (modo local requiere docker)
````
cd jupyterlab-gcp
sh build.sh -m l
````
4. Run imagen
````
sh run.sh
````
5. Acceder (modo local)

[localhost url](http://localhost/lab)
