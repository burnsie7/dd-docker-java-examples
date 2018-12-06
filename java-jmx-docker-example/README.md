# Run jmx enabled Datadog agent using :latest-jmx

sudo docker run -d --name datadog-agent \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY="YOUR_API_KEY" \
  -e DD_HOSTNAME="$HOSTNAME.jmx-docker-auto" \
  -e DD_DOGSTATSD_ORIGIN_DETECTION=true \
  -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
  -e SD_JMX_ENABLE=true \
  -e SD_BACKEND=docker \
  -e TAGS="role:jmx-test" \
  -p 8125:8125/tcp \
  datadog/agent:latest-jmx

# Build the example image
docker image build -t my-company/my-app:latest .

# Run the example image
docker run -d --name my-app -p 7199:7199 -p 8080:8080 my-company/my-app:latest
