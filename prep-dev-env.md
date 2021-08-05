For the dev env:
get the dev evironment variables
make sure the dockerfile is build correctly
make sure the poetry env is installed into the image
make sure pre-commit is installed

curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -
source $HOME/.poetry/env
poetry config virtualenvs.in-project true
mkdir .venv
export PIP_USER=false
poetry install
poetry shell
export PIP_USER=false
pre-commit install  --install-hooks
