# `trombik.sensu_agent`

`ansible` role to install `sensu-agent`.

# Requirements

Ruby must be installed.

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `sensu_agent_user` | User name of `sensu-agent` | `{{ __sensu_agent_user }}` |
| `sensu_agent_group` | Group name of `sensu-agent` | `{{ __sensu_agent_group }}` |
| `sensu_agent_service` | Service name of `sensu-agent` | `{{ __sensu_agent_service }}` |
| `sensu_agent_package` | Package name of `sensu-agent` | `{{ __sensu_agent_package }}` |
| `sensu_agent_log_dir` | Path to log directory | `/var/log/sensu_agent` |
| `sensu_agent_db_dir` | Path to database directory | `{{ __sensu_agent_db_dir }}` |
| `sensu_agent_conf_dir` | Path to configuration directory | `{{ __sensu_agent_conf_dir }}` |
| `sensu_agent_conf_file` | Path to `agent.yml` | `{{ sensu_agent_conf_dir }}/agent.yml` |
| `sensu_agent_ruby_plugins` | List of ruby `gem` to install | `[]` |
| `sensu_agent_flags` | Optional arguments to pass service `sensu-agent` | `""` |

## Debian

| Variable | Default |
|----------|---------|
| `__sensu_agent_user` | `sensu` |
| `__sensu_agent_group` | `sensu` |
| `__sensu_agent_service` | `sensu-agent` |
| `__sensu_agent_package` | `sensu-go-agent` |
| `__sensu_agent_db_dir` | `/var/lib/sensu_agent` |
| `__sensu_agent_conf_dir` | `/etc/sensu` |

## FreeBSD

| Variable | Default |
|----------|---------|
| `__sensu_agent_user` | `sensu` |
| `__sensu_agent_group` | `sensu` |
| `__sensu_agent_service` | `sensu-agent` |
| `__sensu_agent_package` | `sysutils/sensu-go` |
| `__sensu_agent_db_dir` | `/var/db/sensu_agent` |
| `__sensu_agent_conf_dir` | `/usr/local/etc/sensu` |

# Dependencies

None

# Example Playbook

```yaml
---
- hosts: localhost
  roles:
    - name: trombik.freebsd_pkg_repo
      when: ansible_os_family == 'FreeBSD'
    - name: trombik.apt_repo
      when: ansible_os_family == 'Debian'
    - name: trombik.language_ruby
    - ansible-role-sensu_agent
  vars:
    apt_repo_keys_to_add:
      - https://packagecloud.io/sensu/stable/gpgkey
    apt_repo_to_add:
      - deb https://packagecloud.io/sensu/stable/ubuntu/ bionic main
    apt_repo_enable_apt_transport_https: yes
    freebsd_pkg_repo:

      # disable the default package repository
      FreeBSD:
        enabled: "false"
        state: present

      # enable my own package repository, where the latest package is
      # available
      FreeBSD_devel:
        enabled: "true"
        state: present
        url: "http://pkg.i.trombik.org/{{ ansible_distribution_version | regex_replace('\\.', '') }}{{ansible_architecture}}-default-default/"
        mirror_type: http
        signature_type: none
        priority: 100

    sensu_agent_flags: |
      sensu_agent_config='{{ sensu_agent_conf_dir }}/agent.yml'
    sensu_agent_config:
      name: localhost
      namespace: default
    sensu_agent_ruby_plugins:
      - sensu-plugin
      - sensu-plugins-disk-checks
```

# License

```
Copyright (c) 2019 Tomoyuki Sakurai <y@trombik.org>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <y@trombik.org>

This README was created by [qansible](https://github.com/trombik/qansible)
