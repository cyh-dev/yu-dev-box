.PHONY: centos7_build centos7_run

centos7_build:
	docker build -t yu-dev-centos7 -f docker/yu-dev-centos7.Dockerfile .

centos7_run:
	docker run -it --rm --hostname centos7-tools yu-dev-centos7
