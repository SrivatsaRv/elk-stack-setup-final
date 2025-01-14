## How to Proceed with Setup - Summary of Instructions:
- Setup ELK Stack as per instructions below
- Obtain Elasticsearch API Key with all access - curl call provided below
- Obtain Kibana API Key with all accesss - curl call provided below
- Start `generate_requests.sh` script for load generation , index created will be - `updated-logs-index`
- Ensure your Gitlab runner is working , with `gitlab-runner status` , and you receieve `gitlab-runner: Service is running`
- Ensure `Elasticsearch is running over https` a nd `Kibana is running http` for setup similarity
- Note Logstash Container takes at least a minute to come up , wait for it. Successfully started Logstash API endpoint will be the message.
- Peform tests mentioned in capability 
 

## Step by Step Guide:

### Step 0 - Verify Compatiblity Matrix with Elastic , to Ensure you have capability to custom install versions:
```
https://www.elastic.co/support/matrix#matrix_compatibility

Why we do this? 
- X-Pack , and Beats-* functionality has compatiblity issues with modern versions 
- look out for N/A and * remarks , and interpret accordingly, 
```

### Step 2 - Clone the repository
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

### Step 5 - Obtain API Keys for Kibana and Elasticsearch
**Eleasticsearch - All Access**
```

curl -X POST "http://localhost:9200/_security/api_key" \
  -H "Content-Type: application/json" \
  -u elastic:changeme \
  -d '{
    "name": "elasticsearch_super_admin_key",
    "role_descriptors": {
      "super_admin_role": {
        "cluster": ["all"],
        "index": [{
          "names": ["*"],
          "privileges": ["all"]
        }],
        "applications": [{
          "application": "kibana",
          "privileges": ["*"],
          "resources": ["*"]
        }],
        "global": { 
          "cluster": ["all"],
          "indices": ["*"]
        },
        "run_as": ["*"]
      }
    }
  }'
```

**Kibana - All Access**
```
curl -X POST "localhost:5601/internal/security/api_key" \
  -H "kbn-xsrf: true" \
  -H "Content-Type: application/json" \
  -u elastic:changeme \
  -d '{
    "name": "kibana_alerting_key",
    "role_descriptors": {
      "kibana_system": {
        "cluster": ["all"],
        "indices": [{
          "names": ["*"],
          "privileges": ["all"]
        }],
        "applications": [
        {
          "application": "kibana-.kibana",
          "privileges": ["*"],
          "resources": ["*"]
        }
      ]
      }
    }
  }'
```

### Step 6 - Create index, and start load generation onto Elasticserach cluster with  `generate_requests.sh`
```
$bash generate_requests.sh

Valid Response:
continous trail of generated index docs under the name -  "updated-logs-index"

Example:
{
  "_index" : "updated-logs-index",
  "_id" : "fhc5VZQB3weEWXrancXg",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 152,
  "_primary_term" : 1
}

```

### Step - 7 - Check Gitlab runner status that will execute your Gitlab Reponsitory status
```
$gitlab-runner stats

Response:
Runtime platform: arch=arm64 os=darwin pid=68443 revision=3153ccc6 version=17.7.0
gitlab-runner: Service is running
```

### You are ready to go 



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


