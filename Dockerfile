FROM alpine

# install ssh client and libcap
RUN apk add --no-cache openssh-client ca-certificates libcap

# create non-privileged user
RUN addgroup --gid 1000 -S proxygroup && adduser --uid 1000 -S proxyuser -G proxygroup

# allow ssh to bind to ports below 1024
RUN setcap 'cap_net_bind_service=+ep' /usr/bin/ssh

USER proxyuser

CMD ssh -N -g -L ${LOCAL_PORT}:${FORWARDED_HOST}:${FORWARDED_PORT} -i /run/secrets/ssh_key $([[ ! -z ACCEPT_FINGERPRINT ]] && echo -o "StrictHostKeyChecking=no" ) ${CONNECTION_STRING}