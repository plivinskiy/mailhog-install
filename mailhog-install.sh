#!/usr/bin/env bash

echo ">>> Installing Mailhog"

# Download binary from github
wget --quiet -O ~/mailhog https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64

# Download mhsendmail
wget --quiet -O ~/sendmail https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64

# Move mhsendmail to /usr/local/bin/
sudo mv ~/sendmail /usr/local/bin/sendmail

# Make sendmail executable
sudo chmod +x /usr/local/bin/sendmail

# Rename standard sendmail and add link to mhsendmail
sudo mv /usr/sbin/sendmail /usr/sbin/sendmail_backup
sudo ln -s /usr/local/bin/sendmail /usr/sbin/sendmail

# Move mailhog to /usr/local/bin/
sudo mv ~/mailhog /usr/local/bin/mailhog

# Make mailhog executable
sudo chmod +x /usr/local/bin/mailhog

# Make it start on reboot
sudo tee /etc/systemd/system/mailhog.service <<EOL
[Unit]
Description=MailHog Service

[Service]
Type=simple
ExecStart=/usr/bin/env /usr/local/bin/mailhog > /dev/null 2>&1 &

[Install]
WantedBy=multi-user.target
EOL

# Start on reboot
sudo systemctl enable mailhog

# Start background service now
sudo systemctl start mailhog
