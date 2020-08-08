# MemcachedClone
Esta es una implementación de una alternativa para Memcached realizada con Ruby-lang para el reto [coding-challenges](https://github.com/moove-it/coding-challenges/blob/master/ruby.md)
## Correr los test
Estando en la carpeta raíz del proyecto (**MemcachedClone**), utilizar los siguientes comandos:
```
cd MemcachedServer
bundle install
rspec .
```
## Correr el server
Estando en la carpeta raíz del proyecto (**MemcachedClone**), utilizar los siguientes comandos:
```
cd MemcachedServer
ruby Index.rb <direccionIP> <puerto>
```
En donde `<direccionIP>` es la dirección IP donde se desea correr el servicio y `<puerto>` es el puerto por el que se escucharán las conexiones TCP.
## Correr un cliente demo
Para correr un cliente utilizando **Telnet** se debe utilizar el comando:
```
telnet <direccionIP> <puerto>
```
En donde `<direccionIP>` es la dirección IP del server y `<puerto>` es el puerto en el que está corriendo el servicio.\
En este punto, se pueden utilizar los siguientes comandos:
* set
* add
* replace
* append
* prepend
* cas
* get
* gets
* quit
## Correr los test de carga de JMeter
Correr el server con la ip `127.0.0.1` y el puerto `3000`.\
Abrir el archivo `TCPSampler.jmx` en `JMeterTestPlan` con *JMeter*, presionar **Arrancar** y esperar la duración del test: **2:15 min**.\
Para visualizar los resultados, entrar al componente **Response Time Graph**, aplicar el **intérvalo** deseado y dar click en **Mostrar gráfico**.
