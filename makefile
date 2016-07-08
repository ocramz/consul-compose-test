main:
	make test_create
	make test_view
	make test_destroy


http://www.smartjava.org/content/service-discovery-docker-and-consul-part-1

test_create:
	docker-machine create --driver virtualbox nb-consul
	docker run -d --restart always -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302/udp -p 8302:8302 -p 8400:8400 -p 8500:8500 -p 53:53/udp -h server1 progrium/consul -server -bootstrap -ui-dir /ui -advertise $(docker-machine ip nb-consul)
	docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery="consul://$(docker-machine ip nb-consul):8500" --engine-opt="cluster-store=consul://$(docker-machine ip nb-consul):8500" --engine-opt="cluster-advertise=eth1:2376" nb1
	docker-machine create -d virtualbox --swarm --swarm-discovery="consul://$(docker-machine ip nb-consul):8500" --engine-opt="cluster-store=consul://$(docker-machine ip nb-consul):8500" --engine-opt="cluster-advertise=eth1:2376" nb2


test_destroy:
	docker-machine rm -y nb-consul
	docker-machine rm -y nb1
	docker-machine rm -y nb2


test_view:
	docker ps  --format '{{ .ID }}\t{{ .Image }}\t{{ .Command }}\t{{ .Names}}'
