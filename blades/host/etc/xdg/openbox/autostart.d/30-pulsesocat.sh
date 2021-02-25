
socat -d -d TCP-LISTEN:4713,reuseaddr,fork,bind=127.0.0.1 UNIX-CLIENT:/run/user/1000/pulse/native &

