#
# Makefile
# lizongzhe, 2016-01-30 16:11
#
SHELL = /bin/bash
VPATH = .make

# BUILD IMAGE 相關檔案
IMAGE_FILES = $(shell find image/* -type f)

# DOCKER IP
ifndef DOCKER_HOST
 	DOCKER_IP = 172.17.42.1  # default docker ip
else
	DOCKER_IP = $(shell echo "$(DOCKER_HOST)"|sed 's/[^:]*:\/\///'|sed 's/:[^:]*$$//')
endif
export DOCKER_IP

# 取得 host 空閒port
free_port=$(shell for port in $$(seq 8000 65000); do echo -ne "\035" | telnet $(HOST) $$port > /dev/null 2>&1; [ $$? -eq 1 ]  && break; done;echo $$port)

# 預設image name
export IMAGE={{ project_name }}


# 設定TAG
ifndef TAG
	TAG:=local
endif


WORK_DIR=/work/src

# docker run commend shortcut
RUN=docker run -it --rm \
			-v $(PWD):/work \
			-w $(WORK_DIR) \
			--env-file=deploy/$(TAG).env \
			--env-file=.make/env \
			-e PYTHONPATH=$(WORK_DIR) \
			${IMAGE} 
	

# docker run deamon shortcut
RUN_DEAMON=docker run -it \
			-d \
		 	-v $(PWD):/work \
			-w $(WORK_DIR) \
			--env-file=deploy/${TAG}.env \
			--env-file=.make/env \
			-e PYTHONPATH=/work/src \
			-p ${PORT} \
			${IMAGE}


# docker run http server shortcut
httpserver:
	container_id=`$(RUN_DEAMON) $(CMD)` && \
	host=`docker port $$container_id $(PORT) | sed "s/0.0.0.0/http:\/\/${DOCKER_IP}/"` && \
	sleep 3 && \
	open $$host && \
	docker attach $$container_id && \
	echo docker rm -f $$container_id




.PHONY: init shell test coverage runserver

-include init

$(shell mkdir .make)

build::
	@echo build > .make/build
setup:: $(DB).db
	@echo setup > .make/setup

init: build env setup



build:: $(IMAGE_FILES)
	curl https://raw.githubusercontent.com/gliacloud/deploy/new/src/build.sh -o build.sh && source build.sh && docker tag $$IMAGE_NAME $(IMAGE) && rm build.sh

env::
	mkdir -p .make && source deploy/$(TAG).sh && env > .make/env && ls .make



MIGRATE_FILES=$(shell find src/**/migrations/**.py)
setup:: $(MIGRATE_FILES) 
	$(RUN) python manage.py migrate



shell: 
	$(RUN) /bin/bash


PYTHON_FILES = $(shell find src/**/*.py)
test: $(PYTHON_FILES)
	$(RUN) py.test . --cov=. --pdb
	$(RUN) flake8 .
	$(RUN) coverage html 


coverage: PORT=8000 
coverage: CMD=python -m SimpleHTTPServer 8000
coverage: WORK_DIR=/work/src/htmlcov
coverage: httpserver


runserver: PORT=8000
runserver: WORK_DIR=/src
runserver: CMD=uwsgi --http 0.0.0.0:$(PORT) --module {{ project_name }}.wsgi:application
runserver: httpserver

run: CMD=$(args) 
run:
	$(RUN) $(CMD)

