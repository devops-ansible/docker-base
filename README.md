# BaseImages – with and without pre-installed OpenJDK

The JDK-including images built by this repository rely on [Eclipse Adoptium Temurin OpenJDK](https://adoptium.net/), which is [the rebranded Adopt OpenJDK](https://blog.adoptopenjdk.net/2021/03/transition-to-eclipse-an-update/) since July 2021.

## Just another repository with Docker image definitions

This repository is meant to host Java-Applications – separated by branches:

* the `master` contains the “base image” with basic toolings and Java installation.
* all other branches are meant to host separate applications – as long as the branch name was added as a key of an empty dictionary to `built.json`.

### `built.json` – information and definition file

The file `built.json` is a JSON file containing a dictionary of dictionaries.  
The first level of keys is meant to define the branches reflected. If the `master` is removed for any reason, it will be re-added automatically. Every other branch will stay removed won’t build anymore.

```json
{
    "master": {
        "jdk8": "YYYY-MM-DD HH:ii:ss",
        "jdk11": "YYYY-MM-DD HH:ii:ss",
        "jdk17": "YYYY-MM-DD HH:ii:ss",
        "latest": "YYYY-MM-DD HH:ii:ss"
    },
    "application": {
        "tag": "YYYY-MM-DD HH:ii:ss"
    }
}
```

### The `workflow` directory

The `workflow` directory is important on every active branch, since the files there define the building-process during the Github workflow. That’s described below more in detail.

### License

This project is published under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en) license.
