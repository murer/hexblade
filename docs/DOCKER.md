# Hexblade Docker Image

[<img src="https://github.com/murer/hexblade/raw/master/docs/HexbladeGitHub.png" width="280" />](https://github.com/murer/hexblade)

That is a image you can use to have a desktop inside container.

https://hub.docker.com/repository/docker/murer/hexblade

That would let you run any graphical application without the need to export the screen out.

Additionally you can connect using ``vnc`` client any time if you need to see the screen.

Basically it will start [hexblade](https://github.com/murer/hexblade) desktop inside ``xfvb`` and ``vnc`` server.

So you can put any graphical application to run like ``Selenium``, ``Firefox``, games, etc.

## How to start graphical applications automatically

Add a script on ``/etc/xdg/openbox/autostart.d``

## Start container

```shell
docker run -it -p 5900:5900 murer/hexblade
```

You can run a command. It will run after the X server is running.

```shell
docker run -it -p 5900:5900 murer/hexblade xterm
```


## Connect using any vnc client

```shell
# apt-get install xtightvncviewer
vncviewer localhost:5900
```

## Stop the container

If you exit from ``openbox`` the container will stop

## Running command in container


## Source Code

https://github.com/murer/hexblade

