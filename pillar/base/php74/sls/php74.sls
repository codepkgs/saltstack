php74_install_configs: [
  { 
    "src": "php.ini.j2",
    "dst": "/etc/opt/remi/php74/php.ini"
  },
  {
    "src": "php-fpm.conf.j2",
    "dst": "/etc/opt/remi/php74/php-fpm.conf"
  },
  {
    "src": "40-seaslog.ini.j2",
    "dst": "/etc/opt/remi/php74/php.d/40-seaslog.ini",
  },
  {
    "src": "www.conf.j2",
    "dst": "/etc/opt/remi/php74/php-fpm.d/www.conf"
  }
]