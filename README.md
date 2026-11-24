<img alt="icon" src=".alixea/icon.svg" width="32">

# FastAPI component for Alixea

Runs on Alixea's Python base image ([component-bases](https://github.com/alixea-erp/component-bases)), which has [uv](https://docs.astral.sh/uv/). The version tag is the FastAPI version of the starter.

## Operation

### Getting started

1. In the Dashboard, click **Create Project +**
2. Under **Pick Components**, choose **FastAPI**. Here you can also add a frontend framework to create a monorepo app, eg, FastAPI for backend and React+Vite for frontend
3. In **Pick Add-ons**, you can add one or multiple databases to your app
4. Choose **Create Repository** so Alixea creates a new GitHub repository for your project
5. Finally, click **Launch Stack**

### Python version

The default Python version is **3.12**. You can change it in two ways:

- **`.python-version` file** - add a `.python-version` file to your component's folder containing just the version number (e.g. `3.11`). This is the standard convention used by tools like `uv`.
- **`PYTHON_VERSION` environment variable** - set this in `alixea.yaml` as a static value in `env.include` under your component.

If both are set, the `.python-version` file takes precedence. `uv` downloads the version you ask for when it installs the dependencies.

### Development

Dependencies are installed with `uv sync`, or `uv pip install -r requirements.txt` in a project without a `pyproject.toml`. The development server is started with:

```sh
uv run uvicorn src.main:app --host 0.0.0.0 --port $PORT --reload --reload-dir src
```

This can be changed with the `containerCommands.developmentStart` field in `alixea.yaml`. See [Ports](#ports).

### Production

Staging and production install the deployment's commit on the deployment itself, without the `dev` dependencies. A restart reuses that install, and a new commit or a changed environment variable installs again. If the install fails, the previous version keeps running and the deployment page shows the log.

The app is then started with:

```sh
uvicorn src.main:app --host 0.0.0.0 --port $PORT --proxy-headers
```

This can be changed with the `containerCommands.productionStart` field in `alixea.yaml`. `uvicorn` has to be in your dependencies, as it is in the `pyproject.toml` this component starts with.

In staging and production the project folder is read-only while the app runs. Data the app keeps belongs in another component, such as a database, and `/tmp` is only for temporary files.

#### System packages

The image has no packages beyond `uv`. Install more with `initScript` in `alixea.yaml`, which runs as root when the component starts, or `preBuildScript`, which runs as root before the install, for example to compile a dependency:

```yaml
- name: FastAPI
  identifier: fastapi
  package: https://github.com/alixea-erp/component-fastapi#v0.165.0
  preBuildScript: |
    apt-get update && apt-get install -y --no-install-recommends build-essential
```

#### Ports

The component serves on port **8000** in every stage. To use another one, change the `port` of its `app` host in `alixea.yaml` (`hosts: [{ identifier: app, port: 8080 }]`). Alixea sets the `PORT` environment variable to it.

A start command of your own should listen on `$PORT` too. Staging and production count a new version as ready once it accepts connections on that port, and one that listens elsewhere never becomes ready.

## Links

- [FastAPI documentation](https://fastapi.tiangolo.com/)
- [Python documentation](https://docs.python.org/)
- [uv documentation](https://docs.astral.sh/uv/)
