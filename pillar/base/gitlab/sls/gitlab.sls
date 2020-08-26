gitlab_external_url: "https://gitlab.fdisk.cc"
gitlab_data_dir: "/data/gitlab"

gitlab_nginx_ssl_enable: True
gitlab_nginx_ssl_cert: "gitlab.fdisk.cc.crt"
gitlab_nginx_ssl_cert_key: "gitlab.fdisk.cc.key"

gitlab_smtp_enable: False
gitlab_smtp_config: {
  "smtp_address": "smtp.mxhichina.com",
  "smtp_port": 465,
  "smtp_user_name": "your@email.com",
  "smtp_password": "your email password",
  "smtp_domain": "mxhichina.com",
  "smtp_enable_starttls_auto": true,
  "smtp_tls": true,
  "gitlab_email_from": "your@email.com",
  "gitlab_email_reply_to": "your@email.com"
}
