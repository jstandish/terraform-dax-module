/*
arn - The ARN of the DAX cluster

nodes - List of node objects including id, address, port and availability_zone. Referenceable e.g. as ${aws_dax_cluster.test.nodes.0.address}

configuration_endpoint - The configuration endpoint for this DAX cluster, consisting of a DNS name and a port number

cluster_address - The DNS name of the DAX cluster without the port appended

port - The port used by the configuration endpoint
*/

output "arn" {
    value = "${aws_dax_cluster.cluster.arn}"
}

output "nodes" {
    value = "${aws_dax_cluster.cluster.nodes}"
}

output "configuration_endpoint" {
    value = "${aws_dax_cluster.cluster.configuration_endpoint}"
}

output "cluster_address" {
    value = "${aws_dax_cluster.cluster.cluster_address}"
}

output "port" {
    value = "${aws_dax_cluster.cluster.port}"
}

output "security_group_id" {
    value = "${aws_security_group.allow_communication.id}"
}