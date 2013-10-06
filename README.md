# ForemanBackground

Adds background execution support for foreman (http://theforeman.org).

This Foreman plugin allows to perform certain operations in the background, while not blocking the UI/API.
This is useful when you want to speed up foreman performance.

You will need to install a redis instance to use this plugin.

Note: Ruby 1.9 or newer is required.

## Configuration

By default, the plugin will enable sidekiq based background service pointing to redis service running on the local host.

The background host(s) and options can be changed by adding settings to `/usr/share/foreman/config/settings.plugins.d/foreman_background.yaml`, or Foreman's own `settings.yaml`.

Example config file:

```yaml
:sidekiq:
  :url: 'redis://redis.example.com:7372/12'
```
## Running

You would need to run sidekiq to actually process the background queue: for that execute:

sidekiq -q reports -q default


## Currently implemented tasks

* Reports import
