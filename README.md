# D2 for Developers
Active life, awesome loot.

This repository contains the D2 SDK, its documentation and general information about D2 for Developers. 

The D2 SDK is a Roblox module that allows you to create your own games using the D2 backend.

The docs are available at https://docs.d2health.club.

**Note: You have to sign in with your @karta.game Google account to view the docs.**

## Getting Started

### Developing the module
To develop, you can use Rojo and the development.project.json file to load the module into Roblox Studio.

```bash
rojo serve development.project.json
```	

### Building the module
To build the module from scratch, use:

```bash
rojo build -o "D2.rbxm"
```

## Documentation
The docs are generated using Moonwave. 

### Viewing the docs locally
To view the docs locally, make sure to have `moonwave` installed (via `npm install -g moonwave`) and then run:

```bash
moonwave dev
```

The docs will be available at `http://localhost:3000`.

### Publishing the docs
The docs are published to a Fly.io app. Please make sure to have the `fly` CLI installed and configured before proceeding.


#### Building the module (Optional)
```bash
rojo build -o ".moonwave/static/D2.rbxm"
```

