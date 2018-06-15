package com.otsi.util;

import java.net.InetAddress;


import java.net.UnknownHostException;

import org.elasticsearch.client.Client;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

public class DBUtil {

	// elastic cluster name
	private static String clusterName = "elasticsearch";

	// ElasticSearch http port defaul to 9300
	private static int port = 9300;

	// Elasticsearch client node ip
	private static String hostName = "10.80.15.81";
	// close Client
	private static Client client = null;

	// To establish a new Connection
	public static Client getConnection() {
		if (client == null) {
			Settings settings = Settings.builder().put("cluster.name", clusterName).put("client.transport.sniff", true)
					.build();
			try {
				client = new PreBuiltTransportClient(settings)
						.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(hostName), 9300));
			} catch (UnknownHostException e) {
				e.printStackTrace();
			}

		}
		return client;
	}

	public static String getClusterName() {
		return clusterName;
	}

	public static void setClusterName(String clusterName) {
		DBUtil.clusterName = clusterName;
	}

	public static int getPort() {
		return port;
	}

	public static void setPort(int port) {
		DBUtil.port = port;
	}

	public static String getHostName() {
		return hostName;
	}

	public static void setHostName(String hostName) {
		DBUtil.hostName = hostName;
	}

	public static void closeConnection() {
		client.close();
	}

}
