# tomo-plugin-good_job

[![Gem Version](https://badge.fury.io/rb/tomo-plugin-good_job.svg)](https://rubygems.org/gems/tomo-plugin-good_job)
[![Circle](https://circleci.com/gh/gauravtiwari/tomo-plugin-good_job/tree/main.svg?style=shield)](https://app.circleci.com/pipelines/github/gauravtiwari/tomo-plugin-good_job?branch=main)
[![Code Climate](https://codeclimate.com/github/gauravtiwari/tomo-plugin-good_job/badges/gpa.svg)](https://codeclimate.com/github/gauravtiwari/tomo-plugin-good_job)

This is a [tomo](https://github.com/mattbrictson/tomo) plugin that provides tasks for managing [good_job](https://github.com/bensheldon/good_job) via [systemd](https://en.wikipedia.org/wiki/Systemd), based on the recommendations in the good_job documentation. This plugin assumes that you are also using the tomo `rbenv` and `env` plugins, and that you are using a systemd-based Linux distribution like Ubuntu 18 LTS.

---

- [Installation](#installation)
- [Settings](#settings)
- [Tasks](#tasks)
- [Support](#support)
- [License](#license)
- [Code of conduct](#code-of-conduct)
- [Contribution guide](#contribution-guide)

## Installation

Run:

```
$ gem install tomo-plugin-good_job
```

Or add it to your Gemfile:

```ruby
gem "tomo-plugin-good_job"
```

Then add the following to `.tomo/config.rb`:

```ruby
plugin "good_job"

setup do
  # ...
  run "good_job:setup_systemd"
end

deploy do
  # ...
  # Place this task at *after* core:symlink_current
  run "good_job:restart"
end
```

### enable-linger

This plugin installs good_job as a user-level service using systemctl --user. This allows good_job to be installed, started, stopped, and restarted without a root user or sudo. However, when provisioning the host you must make sure to run the following command as root to allow the good_job process to continue running even after the tomo deploy user disconnects:

```
# run as root
$ loginctl enable-linger <DEPLOY_USER>
```

## Settings

| Name                                     | Purpose                                                                                                                                                                                                         |
| ---------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `good_job_systemd_service`               | Name of the systemd unit that will be used to manage good*job <br>**Default:** `"good_job*%{application}.service"`                                                                                              |
| `good_job_systemd_service_path`          | Location where the systemd unit will be installed <br>**Default:** `".config/systemd/user/%{good_job_systemd_service}"`                                                                                         |
| `good_job_systemd_service_template_path` | Local path to the ERB template that will be used to create the systemd unit <br>**Default:** [service.erb](https://github.com/gauravtiwari/tomo-plugin-good_job/blob/main/lib/tomo/plugin/good_job/service.erb) |

## Tasks

### good_job:setup_systemd

Configures systemd to manage good_job. This means that good_job will automatically be restarted if it crashes, or if the host is rebooted. This task essentially does two things:

1. Installs a `good_job.service` systemd unit
1. Enables it using `systemctl --user enable`

Note that these units will be installed and run for the deploy user. You can use `:good_job_systemd_service_template_path` to provide your own template and customize how good_job and systemd are configured.

`good_job:setup_systemd` is intended for use as a [setup](https://tomo-deploy.com/commands/setup/) task. It must be run before good_job can be started during a deploy.

### good_job:restart

Gracefully restarts the good_job service via systemd, or starts it if it isn't running already. Equivalent to:

```
systemctl --user restart good_job.service
```

### good_job:start

Starts the good_job service via systemd, if it isn't running already. Equivalent to:

```
systemctl --user start good_job.service
```

### good_job:stop

Stops the good_job service via systemd. Equivalent to:

```
systemctl --user stop good_job.service
```

### good_job:status

Prints the status of the good_job systemd service. Equivalent to:

```
systemctl --user status good_job.service
```

### good_job:log

Uses `journalctl` (part of systemd) to view the log output of the good_job service. This task is intended for use as a [run](https://tomo-deploy.com/commands/run/) task and accepts command-line arguments. The arguments are passed through to the `journalctl` command. For example:

```
$ tomo run -- good_job:log -f
```

Will run this remote script:

```
journalctl -q --user-unit=good_job.service -f
```

## Support

If you want to report a bug, or have ideas, feedback or questions about the gem, [let me know via GitHub issues](https://github.com/gauravtiwari/tomo-plugin-good_job/issues/new) and I will do my best to provide a helpful answer. Happy hacking!

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).

## Code of conduct

Everyone interacting in this project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md).

## Contribution guide

Pull requests are welcome! Thanks @mattbrictson for Tomo 🙏
