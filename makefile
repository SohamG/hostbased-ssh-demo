all: clean network run

server: Containerfile.server
	podman build -t slyng-ssh-server -f Containerfile.server

client: Containerfile.server
	podman build -t slyng-ssh-client -f Containerfile.client

clean:
	podman stop -a
	podman rm -a

network:
	podman network create --subnet 10.0.0.0/24 --ignore hostssh

create-server: server
	podman create --name server --hostname server --ip 10.0.0.5 -p 2222:2222 --network hostssh --replace slyng-ssh-server

run: create-server client
	podman start server
	podman run -it --network hostssh --ip 10.0.0.6 --hostname client slyng-ssh-client bash


.PHONY: all server client clean network create-server run
