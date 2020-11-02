nodejs_logrotate:
  file.managed:
    - name: /opt/scripts/logrotate_pm2
    - source: salt://nodejs/files/logrotate_pm2
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

nodejs_logrotate_cron:
  cron.present:
    - name: /usr/sbin/logrotate -f /opt/scripts/logrotate_pm2
    - identifier: logrotate_pm2
    - comment: logrotate_pm2
    - user: root
    - minute: 59
    - hour: 23
    - require:
      - file: nodejs_logrotate