setup:
	python3 -m venv ~/.flask-ml-azure
	source ~/.flask-ml-azure/bin/activate
	
install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt

test:

lint:
	pylint --disable=R,C,W1203,bare-except --fail-under=6 app.py

all: install lint test