# Create a docker network for communication between java container and datadog-agent

docker network create dognet

# Run Datadog agent

sudo docker run -d --name datadog-agent \
  --network=dognet \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  -v /proc/:/host/proc/:ro \
  -v /sys/fs/cgroup/:/host/sys/fs/cgroup:ro \
  -e DD_API_KEY="YOUR_API_KEY" \
  -e DD_HOSTNAME="$HOSTNAME.jmx-docker-auto" \
  -e DD_DOGSTATSD_ORIGIN_DETECTION=true \
  -e DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true \
  -e DD_APM_ENABLED=true \
  -e DD_APM_NON_LOCAL_TRAFFIC=true \
  -e SD_JMX_ENABLE=true \
  -e SD_BACKEND=docker \
  -e TAGS="env:test" \
  -p 8125:8125/tcp \
  -p 8126:8126/tcp \
  datadog/agent:latest-jmx

# Build the example image
docker image build -t my-company/my-app:latest .

# Run the example image
docker run -d --name my-app --network dognet -p 7199:7199 -p 8080:8080 -p 8000:8000 my-company/my-app:latest

# Hit the endpoint to generate traces and jmx metrics
curl 127.0.0.1:8080/Tester/tester
