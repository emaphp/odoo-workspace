# Odoo branch
ODOO_BRANCH := 19.0

# The Python version to use
PYTHON_VERSION := 3.12.10

# The name of the virtual environment
ODOO_VENV := odoo_v19

# The Docker volume storing the Odoo database
# Note: should include COMPOSE_PROJECT_NAME as a prefix (check .env)
PG_VOLUME := odoo-v19-workspace_pg_odoo

# The Docker network to use
DOCKER_NETWORK := odoo_workspace

# Used to symlink to the modules folder
PARENT_DIR := $(shell cd .. && pwd)
ADDONS_DIR := odoo-v19-modules

setup:
	pyenv install $(PYTHON_VERSION)
	pyenv local $(PYTHON_VERSION)
	pyenv virtualenv $(PYTHON_VERSION) $(ODOO_VENV)

install:
	pip install -r requirements.txt

fetch:
	git submodule add -b $(ODOO_BRANCH) https://github.com/odoo/odoo.git odoo

update:
	git submodule update --remote

download:
	wget https://github.com/odoo/odoo/archive/refs/heads/$(ODOO_BRANCH).zip -O odoo.zip
	unzip odoo.zip "odoo-$(ODOO_BRANCH)/*" -d . && mv odoo-$(ODOO_BRANCH) odoo
	rm -f odoo.zip

symlink:
	ln -s $(PARENT_DIR)/$(ADDONS_DIR) extra-addons

network:
	docker network create $(DOCKER_NETWORK)

up:
	docker compose up -d

down:
	docker compose down

purge:
	@docker compose down
	docker volume rm $(PG_VOLUME)

shell:
	@eval "$$(pyenv init -)" && \
	pyenv activate ${ODOO_VENV} && \
	python odoo/odoo-bin shell -c odoo/odoo.conf

.PHONY: setup install symlink network up down purge update shell
