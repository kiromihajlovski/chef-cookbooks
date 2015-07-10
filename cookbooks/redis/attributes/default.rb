

# Init.d script related options
default['redis']['init.d']['required_start'] = []
default['redis']['init.d']['required_stop'] = []																																					


# Attributes for redis-cluster
#Master and Slave
default["redis-all"]["cluster"]["master1"] = { "cluster-port" => "7000"}
default["redis-all"]["cluster"]["master2"] = { "cluster-port" => "7001"}
default["redis-all"]["cluster"]["master3"] = { "cluster-port" => "7002"}
default["redis-all"]["cluster"]["slave1"] = { "cluster-port" => "7003"}
default["redis-all"]["cluster"]["slave2"] = { "cluster-port" => "7004"}
default["redis-all"]["cluster"]["slave3"] = { "cluster-port" => "7005"}
#Sentinel
default["redis-all"]["monitor"]["sentinel1"] = { "monitor-port" => "5000", "master_port" => "7000"}
default["redis-all"]["monitor"]["sentinel2"] = { "monitor-port" => "5001", "master_port" => "7001"}
default["redis-all"]["monitor"]["sentinel3"] = { "monitor-port" => "5002", "master_port" => "7002"}

