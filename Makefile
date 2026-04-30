VENV ?= .venv
PROJECT ?= my_project

define green
	@echo "\033[32m$(1)\033[0m"
endef

setup: clean venv install

clean:
	rm -rf $(VENV) __pycache__ .pytest_cache .mypy_cache

venv:
	python3 -m venv $(VENV)

install:
	$(VENV)/bin/pip install --upgrade pip
	$(VENV)/bin/pip install -r requirements.txt
	$(VENV)/bin/pip install pylint
	$(VENV)/bin/pre-commit install || true

run:
	$(VENV)/bin/python -m $(PROJECT)

test:
	$(VENV)/bin/pytest -v

coverage:
	$(call green,"Coverage report")
	@$(VENV)/bin/pytest --cov=$(PROJECT) --cov-report=term-missing


lint:
	$(VENV)/bin/ruff check .
	$(VENV)/bin/pylint src/

format:
	$(VENV)/bin/black .

typecheck:
	$(VENV)/bin/mypy src/

precommit:
	$(VENV)/bin/pre-commit run --all-files

validate:
	$(VENV)/bin/python -m compileall src

ci: validate precommit lint test
	@echo "CI passed ✔"
# Variables
REPO := $(shell gh repo view --json nameWithOwner -q .nameWithOwner)
BRANCH := $(shell git branch --show-current)

# Create a pull request
pr-create:
	gh pr create --base main --head $(BRANCH) --fill

# View PRs
pr-list:
	gh pr list

# Checkout a PR
pr-checkout:
	gh pr checkout $(PR)

# Create an issue
issue-create:
	gh issue create --title "$(TITLE)" --body "$(BODY)"

# List issues
issue-list:
	gh issue list

# Create a release
release-create:
	gh release create $(TAG) --title "$(TITLE)" --notes "$(NOTES)"

# Trigger a workflow
workflow-run:
	gh workflow run $(WORKFLOW)

# View workflow runs
workflow-list:
	gh run list

git-status:
	git status

git-fetch:
	git fetch

git-pull:
	git pull origin $(BRANCH)

git-push:
	git push origin $(BRANCH)

git-log:
	git log --oneline --graph --decorate --all

git-add:
	git add .

git-commit:
	git commit -m "$(MSG)"

git-sync: git-fetch git-pull git-push
