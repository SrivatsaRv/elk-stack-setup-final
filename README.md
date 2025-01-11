# How to use it? 

### Step 0 - Verify Compatiblity Matrix with Elastic , to Ensure you have capability to custom install versions:
```
https://www.elastic.co/support/matrix#matrix_compatibility

Why we do this? 
- X-Pack , and Beats-* functionality has compatiblity issues with modern versions 
- look out for N/A and * remarks , and interpret accordingly, 
```

### Step 1 - Clone the repository
```
$git clone https://github.com/SrivatsaRv/elk-stack-setup-final
```

### Step 2 - Configs have been tweaked to M2 Macbook Air Specifications - adjust accordingly
```
ES_MEM_LIMIT=6073741824
KB_MEM_LIMIT=2073741824
LS_MEM_LIMIT=1073741824

- should be reviewed actually, doesn't need this much
```

### Step 3 - Bring up the compose setup
```
docker compose up 
or
docker compose up --build
or
$STACK_VERSION=8.2.3 docker compose up --build
```


### Step 4 - Verify things come up correctly 
```
NAME                                           IMAGE                                                 COMMAND                  SERVICE        CREATED             STATUS                       PORTS
elastic-stack-docker-part-one-es01-1           docker.elastic.co/elasticsearch/elasticsearch:8.2.3   "/bin/tini -- /usr/l…"   es01           About an hour ago   Up About an hour (healthy)   0.0.0.0:9200->9200/tcp, 9300/tcp
elastic-stack-docker-part-one-filebeat01-1     docker.elastic.co/beats/filebeat:8.2.3                "/usr/bin/tini -- /u…"   filebeat01     About an hour ago   Up About an hour             
elastic-stack-docker-part-one-kibana-1         docker.elastic.co/kibana/kibana:8.2.3                 "/bin/tini -- /usr/l…"   kibana         About an hour ago   Up About an hour (healthy)   0.0.0.0:5601->5601/tcp
elastic-stack-docker-part-one-logstash01-1     docker.elastic.co/logstash/logstash:8.2.3             "/usr/local/bin/dock…"   logstash01     About an hour ago   Up About an hour             5044/tcp, 9600/tcp
elastic-stack-docker-part-one-metricbeat01-1   docker.elastic.co/beats/metricbeat:8.2.3              "/usr/bin/tini -- /u…"   metricbeat01   About an hour ago   Up About an hour             


Good check to ensure you're healthy?
- 5 containers will be up - elasticsearach , kibana , logstash , filebeat and metricbeat
- 1 container will be down and in exited stage - elasticsearch setup container
```


### Known Issues?
**Issue-1 - Kibana sometimes doesn't come up , and gives an error log , that Kibana exited / stopped**
- **Solution** - Restart compose setup , and bring it up again


**Issue-2 - If you are hit with this error - Could not load codec 'Lucene95'. Did you forget to add lucene-backward-codecs.jar?** 
- **Solution** - 
```
Stop the running containers and remove volumes:
$docker-compose down -v

Now bring the stack back up:
docker-compose up --build

Root Cause:
- Elasticsearch uses Lucene internally for indexing and managing data.
- Incompatible Lucene versions occur when downgrading Elasticsearch because the data directory contains structures created by newer Lucene versions.
- Your esdata01 volume still contains metadata from the previous 8.7.x setup, which references Lucene95, a codec introduced after 8.2.x.

```




