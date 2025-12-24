SHELL := /bin/bash
SUDO ?= sudo

.PHONY: up prereqs containerd kubernetes init calico metrics diag reset

up: prereqs containerd kubernetes init calico metrics

prereqs:
	$(SUDO) bash scripts/00-prereqs.sh

containerd:
	$(SUDO) bash scripts/01-containerd.sh

kubernetes:
	$(SUDO) bash scripts/02-kubernetes.sh

init:
	$(SUDO) bash scripts/03-init.sh

calico:
	$(SUDO) bash scripts/04-calico.sh

metrics:
	$(SUDO) bash scripts/05-metrics-server.sh

diag:
	$(SUDO) bash scripts/diag-apiserver.sh

reset:
	$(SUDO) bash scripts/reset.sh
