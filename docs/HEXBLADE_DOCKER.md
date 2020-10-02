# Hexblade Docker Image

That is a image you can use to have a desktop inside container.

Basically it will start ``hexblade`` desktop inside ``xfvb`` and ``vnc`` server.

Any script on ``/etc/xdg/openbox/autostart.d`` will during the container startup. So you can put a graphical application to run like ``Selenium``, ``Firefox``, games, etc.

```shell
docker run -it -p 5900:5900 murer/hexblade
```

Connect using any vnc client

```shell
# apt-get install xtightvncviewer
vncviewer localhost:5900
```

If you exit from ``openbox`` the container will stop
