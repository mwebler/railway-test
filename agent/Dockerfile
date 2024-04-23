FROM grafana/agent:v0.40.4

RUN apt-get update
RUN apt-get install -y gettext

ARG GRAFANA_API_KEY

COPY agent-config.yaml /etc/agent/agent.yaml

RUN envsubst < /etc/agent/agent.yaml > /etc/agent/agent.yaml

RUN cat /etc/agent/agent.yaml

# Set environment variables
# ENV DD_LOGS_ENABLED=true
# ENV DD_APM_ENABLED=true
# ENV DD_LOGS_CONFIG_CONTAINER_COLLECT_ALL=true
# ENV DD_DOGSTATSD_NON_LOCAL_TRAFFIC=true
# ENV DD_APM_NON_LOCAL_TRAFFIC=true
# ENV DD_BIND_HOST=::1

# Reference Variables defined in Railway
# ARG DD_API_KEY
# ARG DD_HOSTNAME
# ARG DD_SITE

# Copy datadog.yaml into the container
# COPY datadog.yaml /etc/datadog-agent/datadog.yaml

# Copy syslog configuration file
# COPY syslog.yaml /etc/datadog-agent/conf.d/syslog.d/

# DogStatsD port, APM port, and the syslog port
# EXPOSE 8125/udp
# EXPOSE 8126
EXPOSE 514/udp
ENTRYPOINT ["sleep", "100000"]