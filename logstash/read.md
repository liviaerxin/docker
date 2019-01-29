```
10.255.0.2 - - [14/Dec/2017:10:22:54 +0000] "GET /DPMS/case/ventana/slide/ER_1010/user/test/snapshot?_end=1000&_start=0&type=RDV HTTP/1.1" 200 656 "http://10.6.64.19:8080/rdv/?slide=/DPMS/case/ventana/slide/ER_1010" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0" 0.007 0.007 "test"
10.255.0.2 - - [14/Dec/2017:10:22:54 +0000] "GET /DPMS/case/ventana/slide/ER_1010/user/test/snapshot?_end=1000&_start=0&type=RDV HTTP/1.1" 200 656 "http://10.6.64.19:8080/rdv/?slide=/DPMS/case/ventana/slide/ER_1010" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:55.0) Gecko/20100101 Firefox/55.0" 0.007 - "test"
```

```
docker run -it --rm logstash logstash -e 'input { stdin { } }
filter {
    grok {
        match => { "message" => "%{IPORHOST:remote_addr} - %{USERNAME:remote_user} \[%{HTTPDATE:timestamp}\] \"%{WORD:method} %{DATA:url} %{DATA:version}\" %{INT:status} (?:%{NUMBER:bytes_sent}|-) %{QS:http_referer} %{QS:http_user_agent} %{NUMBER:request_time} (?:%{NUMBER:upstream_response_time}|-) \"%{DATA:username}\""
        }
        overwrite => [ "message" ]
    }

    mutate {
        gsub => [ "http_referer", "\"", "" ]
        gsub => [ "http_user_agent", "\"", "" ]
        convert => ["bytes_sent", "integer"]
        convert => ["request_time", "float"]
        convert => ["upstream_response_time", "float"]
    }

    date {
        match => [ "timestamp" , "dd/MMM/YYYY:HH:mm:ss Z" ]
        remove_field => [ "timestamp" ]
    }

    useragent {
        source => "http_user_agent"
    }

    geoip {
        source => "remote_addr"
    }
}
output { stdout { codec => rubydebug } }'
```

```
docker run -it --rm logstash logstash -e 'input { stdin { } }
filter {
    grok {
        match => { "message" => "%{IPORHOST:remote_addr} - %{USERNAME:remote_user} \[%{HTTPDATE:timestamp}\] \"%{WORD:method} %{DATA:url} %{DATA:version}\" %{INT:status} (?:%{NUMBER:bytes_sent}|-) (?:\"(?:%{URI:referrer}|-)\"|%{QS:referrer})"
        }
        overwrite => [ "message" ]
    }
}
output { stdout { codec => rubydebug } }'
```

