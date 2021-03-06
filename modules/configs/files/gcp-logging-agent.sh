echo "[$(date +"%FT%T")]  Install and Configure GCP logging agent..."
curl -s https://dl.google.com/cloudagents/add-logging-agent-repo.sh | bash


# RHEL
# sudo yum list --showduplicates google-fluentd
sudo yum install -y google-fluentd-1.*

# UBUNTU
# local gcp_logging_version="1.8.3-1"
# apt-get -y update
# apt-get install -y "google-fluentd=$gcp_logging_version"
sudo tee /etc/google-fluentd/google-fluentd.conf << EOF
<source>
  @type syslog
  port 5140
  bind 0.0.0.0
  <transport udp>
  </transport>
  <parse>
    message_format rfc5424
  </parse>
  tag tfe-logs
</source>
<source>
  @type syslog
  port 5140
  bind 0.0.0.0
  <transport tcp>
  </transport>
  <parse>
    message_format rfc5424
  </parse>
  tag tfe-logs
</source>
<source>
  @type tail

  # Parse the timestamp, but still collect the entire line as 'message'
  format syslog

  path /var/log/syslog,/var/log/messages
  pos_file /var/lib/google-fluentd/pos/syslog.pos
  read_from_head true
  tag syslog
</source>
# Uncomment to add debugging logs to /var/log/google-fluentd/google-fluentd.log
# <system>
#   log_level debug
# </system>
# Do not collect fluentd's own logs to avoid infinite loops.
<match fluent.**>
  @type null
</match>
# Add a unique insertId to each log entry that doesn't already have it. # This helps guarantee the order and prevent log duplication.
<filter **>
  @type add_insert_ids
</filter>
# Configure all sources to output to Google Cloud Logging
<match **>
  @type google_cloud
  buffer_type file
  buffer_path /var/log/google-fluentd/buffers
  # Set the chunk limit conservatively to avoid exceeding the recommended # chunk size of 5MB per write request.
  buffer_chunk_limit 512KB
  # Flush logs every 5 seconds, even if the buffer is not full. flush_interval 5s
  # Enforce some limit on the number of retries.
  disable_retry_limit false
  # After 3 retries, a given chunk will be discarded.
  retry_limit 13
  # Wait 10 seconds before the first retry. The wait interval will be doubled on
  # each following retry (20s, 40s...) until it hits the retry limit.
  retry_wait 10
  detect_json true
  # Never wait longer than 5 minutes between retries. If the wait interval
  # reaches this limit, the exponentiation stops.
  # Given the default config, this limit should never be reached, but if
  # retry_limit and retry_wait are customized, this limit might take effect.
  max_retry_wait 300
  # Use multiple threads for processing.
  num_threads 8
  # Use the gRPC transport.
  use_grpc true
  # If a request is a mix of valid log entries and invalid ones, ingest the
  # valid ones and drop the invalid ones instead of dropping everything.
  partial_success true
  # Enable monitoring via Prometheus integration.
  enable_monitoring true
  monitoring_type opencensus
</match>
EOF
sudo service google-fluentd restart

logspout_version="v3.2.11"
private_ip=$(curl -H "Metadata-Flavor: Google" \
    http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)

sudo docker pull gliderlabs/logspout:$logspout_version
sudo docker run -dt --privileged --name="logspout" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e LOGSPOUT="ignore" \
  --restart always \
  gliderlabs/logspout:$logspout_version \
  syslog+tcp://$private_ip:5140 || true