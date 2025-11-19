# Cognitive Parliament - Makefile
.PHONY: help install test lint format clean docker docs

help:
	@echo "Cognitive Parliament - Available Commands:"
	@echo "  install       Install dependencies"
	@echo "  test          Run all tests"
	@echo "  test-unit     Run unit tests only"
	@echo "  test-integration  Run integration tests"
	@echo "  lint          Run code linters"
	@echo "  format        Format code with black"
	@echo "  clean         Remove build artifacts"
	@echo "  docker        Build Docker image"
	@echo "  docs          Generate documentation"

install:
	pip install -e ".[dev,docs]"
	pre-commit install

test:
	pytest tests/ -v

test-unit:
	pytest tests/unit/ -v

test-integration:
	pytest tests/integration/ -v

test-performance:
	pytest tests/performance/ -v

coverage:
	pytest tests/ --cov=cognitive_parliament --cov-report=html
	@echo "Coverage report: htmlcov/index.html"

lint:
	ruff check src/ tests/
	mypy src/

format:
	black src/ tests/
	ruff check --fix src/ tests/

clean:
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf build/ dist/ *.egg-info
	rm -rf .pytest_cache .coverage htmlcov/

docker:
	docker build -t cognitive-parliament:latest .

docker-compose-up:
	docker-compose up -d

docker-compose-down:
	docker-compose down

docs:
	mkdocs build
	@echo "Documentation: site/index.html"

docs-serve:
	mkdocs serve
