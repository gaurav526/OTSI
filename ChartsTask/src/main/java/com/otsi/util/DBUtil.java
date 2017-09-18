package com.otsi.util;

import java.io.FileInputStream;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Properties;

import org.elasticsearch.client.Client;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.transport.client.PreBuiltTransportClient;

public class DBUtil {

	// elastic cluster name
	private static String clusterName = null;

	// ElasticSearch http port defaul to 9300
	private static int port;

	// Elasticsearch client node ip
	private static String hostName = null;
	// Client
	private static Client client = null;

	private static String path = null;

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

	public static Client getClient() {
		return client;
	}

	public static void setClient(Client client) {
		DBUtil.client = client;
	}

	public static String getPath() {
		return path;
	}

	public static void setPath(String path) {
		DBUtil.path = path;
	}

	// To establish a new Connection
	public Client getConnection() {

		InputStream inputStream;

		try {
			Properties prop = new Properties();
			String propFileName = "resource.properties";

			inputStream = getClass().getClassLoader().getResourceAsStream(propFileName);

			if (inputStream != null) {
				prop.load(inputStream);
			}

			// getting values from properties class...
			clusterName = prop.getProperty("CLUSTER_NAME");
			port = Integer.parseInt(prop.getProperty("PORT"));
			hostName = prop.getProperty("HOST_NAME");
			path = prop.getProperty("path");

			// setting values to class variables..
			DBUtil.setClusterName(clusterName);
			DBUtil.setPort(port);
			DBUtil.setHostName(hostName);
			DBUtil.setPath(path);

		} catch (Exception e) {
			System.out.println("Exception: " + e);
		}

		if (client == null) {
			Settings settings = Settings.builder().put("cluster.name", DBUtil.getClusterName())
					.put("client.transport.sniff", true).build();
			try {
				// preparing client object...
				client = new PreBuiltTransportClient(settings).addTransportAddress(
						new InetSocketTransportAddress(InetAddress.getByName(DBUtil.getHostName()), DBUtil.getPort()));
			} catch (UnknownHostException e) {
				e.printStackTrace();
			}

		}

		return client;
	}
}
