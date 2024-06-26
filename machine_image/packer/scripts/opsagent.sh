curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

sudo systemctl start google-cloud-ops-agent

# append the following line to the /etc/hosts file using tee

echo "
logging:
  receivers:
    my-app-receiver:
      type: files
      include_paths:
        - /var/log/webapp/webapp.log
      record_log_file_path: true
  processors:
    move_severity:
      type: modify_fields
      fields:
        severity:
          move_from: jsonPayload.severity
    my-app-processor:
      type: parse_json
      time_key: timestamp
      time_format: "%Y-%m-%dT%H:%M:%S.%LZ"
  service:
    pipelines:
      default_pipeline:
        receivers: [my-app-receiver]
        processors: [my-app-processor, move_severity]
" | sudo tee -a /etc/google-cloud-ops-agent/config.yaml

sudo systemctl restart google-cloud-ops-agent

sudo systemctl status google-cloud-ops-agent
