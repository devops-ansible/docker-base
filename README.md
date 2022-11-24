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

### Useful File Locations

* `/certs` - location for custom certificates

### environmental variables

| env                   | default               | change recommended | description |
| --------------------- | --------------------- |:------------------:| ----------- |
| `EDITOR`              | `vim`                 | yes                | Default editor for the container – there are multiple ones installed like `vim` (default) and `nano`. |
| `TIMEZONE`            | `Europe/Berlin`       | yes                | Timezone used within container – adjust to where you are living |
| `SET_LOCALE`          | `de_DE.UTF-8`         | yes                | Default locale used for keyboard layout selection, etc – not always relevant within containers, but sometimes very usefull |
| `START_CRON`          | `0`                   | yes                | Should cron be started within the container? Then set it to `1`. |
| `BOOT_MSG_SHOW`       | `1`                   | yes                | Should messages of `boot.sh` sourced scripts be shown? Then `1` is perfect, otherwise change to `0`. |
| `CRON_PATH`           | `/etc/cron.d/docker`  | no                 | Where is the cron file located? for information about the cron file, see below. |
| `CUSTOM_CERTS_PATH`   | `/certs`              | no                 | Location where to find custom certificates which will be imported and trusted – useful to accept custom (selfsigned) RootCAs. |
| `TERM`                | `xterm`               | no                 | |
| `DEBIAN_FRONTEND`     | `noninteractive`      | no                 | |

#### build variables

There are also some special variables, that are only used during build process of the docker image:

| variable name       | type  | value                       | description |
| ------------------- | ----- | --------------------------- | ----------- |
| `IMAGE`             | `ARG` | `ubuntu`                    | The docker images built within this repository are built on official docker library version of Ubuntu. |
| `VERSION`           | `ARG` | `20.04`                     | We relay on the LTS releases of Ubuntu for docker images built through this repository. |
| `JDK_NAME`          | `ENV` | `temurin-17-jdk`            | Temurin JDK to be installed. For the `latest` tag, no JDK will be installed. |

*By using the different types of environmental variables within the image build and usage process, we assure them being available in relevant contexts.  
Docker uses build arguments (type `ARG`) for environmental variables only available during the build process of an image. `ENV` type variables are available in both contexts, during the build and when running a container from the image.*

### Cron-File

```
# This crontab file holds commands for all users to be run by
# cron. Each command is to be defined within a separate line.
#
# To define the time you can provide concrete (numeric) values,
# comma separate them or use \`*\` to use any of the possible
# values.
# You can also use basic calculation - i.e. if you want to run
# a job every 20th minute use \`*/20\`.
#
# The tasks will be started based on the system time and
# timezone.
#
#
# The example below would print a message to the STDOUT of the
# docker container and - if any error does occur – the errors
# will be printed to the STDERR of the container.
#
# Please be aware that you are locating the crontab file within
# \`/etc/cron.d\` directory and for that there is also the need
# to define the user who should run the cron command!
#
# ┌────────────────────────────────── minute (0-59)
# │    ┌───────────────────────────── hour (0-23)
# │    │    ┌──────────────────────── day (1-31)
# │    │    │    ┌─────────────────── month (1-12)
# │    │    │    │    ┌────────────── day of week (0-6, sunday equals 0)
# │    │    │    │    │    ┌───────── user
# │    │    │    │    │    │    ┌──── command
# │    │    │    │    │    │    │
# ┴    ┴    ┴    ┴    ┴    ┴    ┴
# */20 *    *    *    *    root echo 'this is a demonstration cronjob'  1> /proc/1/fd/1  2> /proc/1/fd/2
```

### License

This project is published under the [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/deed.en) license.
