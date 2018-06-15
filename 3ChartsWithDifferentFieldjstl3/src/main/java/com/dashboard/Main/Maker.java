package com.dashboard.Main;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.sort.SortOrder;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import org.json.simple.JSONObject;

import com.google.gson.Gson;

public class Maker extends HttpServlet {
	// elastic cluster name
	static String clusterName = "elasticsearch";
	// ElasticSearch http port defaul to 9300
	static int port = 9300;
	// Elasticsearch client node ip
	static String hostName = "10.80.15.102";
	// close Client
	private static Client client = null;

	static Settings settings = null;
	private static final long serialVersionUID = 1L;
	SearchResponse s = null;
	Map<String, Object> chartParameterMap = new HashMap<String, Object>();
	static Properties properties = new Properties();

	static {
		properties = new Properties();
		InputStream is = Maker.class.getClassLoader().getResourceAsStream("com/dashboard/Main/dbinfo.properties");
		try {
			properties.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}// drill map

	public Map<String, Object> getCharts(String chartID) {
		ArrayList<String> bucketKey = new ArrayList<String>();
		ArrayList<Long> bucketCount = new ArrayList<Long>();

		String[] chart = properties.getProperty(chartID).split(" ");
		chartParameterMap.put("index", chart[0]);
		chartParameterMap.put("docType", chart[1]);
		chartParameterMap.put("fieldname", chart[2]);
		chartParameterMap.put("size", chart[3]);
		chartParameterMap.put("id", chartID);
		chartParameterMap.put("chartType", chart[4]);
		chartParameterMap.put("agg", chart[5]);

		s = client.prepareSearch(chartParameterMap.get("index").toString())
				.setTypes(chartParameterMap.get("docType").toString())
				.addSort(chartParameterMap.get("fieldname").toString(), SortOrder.ASC).setSize(10)
				.setScroll(new TimeValue(10000)).setExplain(true)
				.addAggregation(AggregationBuilders.terms(chartParameterMap.get("agg").toString())
				.field(chartParameterMap.get("fieldname").toString()).order(Terms.Order.count(false)))
				.get();
		
		//s= client.prepareSearchScroll(s.getScrollId()).setScroll(new TimeValue(10000)).execute().actionGet();
		System.out.print(s);
		Terms agg = s.getAggregations().get(chartParameterMap.get("agg").toString());

		// For each entry Bucket is used
		for (Terms.Bucket entry : agg.getBuckets()) {
			// JSONObject member = new JSONObject();
			String key = entry.getKey().toString(); // bucket key
			long docCount = entry.getDocCount();// bucket docCount
			bucketKey.add(key);
			bucketCount.add(docCount);
		} // for
		chartParameterMap.put("bucketKeys", bucketKey);
		chartParameterMap.put("bucketCounts", bucketCount);
		// System.out.println(chartParameterMap);
		return chartParameterMap;
	}

	@Override
	public void init() throws ServletException {
		// get the setting
		settings = Settings.builder().put("cluster.name", clusterName).put("client.transport.sniff", true).build();

		try {
			client = new PreBuiltTransportClient(settings)
					.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(hostName), 9300));
		} catch (UnknownHostException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String[] allid = properties.getProperty("allids").split(" ");
		req.setAttribute("allids", allid);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PrintWriter pw = resp.getWriter();
		resp.setContentType("application/pdf");
		String[] allid = properties.getProperty("allids").split(" ");
		req.setAttribute("allids", allid);
		Map<String, Object> mapobject = null;

		pw.println("[");
		for (int i = 0; i < allid.length; i++) {
			mapobject = getCharts(allid[i]);
			Gson gson = new Gson();
			String gsonTojson = gson.toJson(mapobject);
			pw.println(gsonTojson);
			if (i != allid.length - 1)
				pw.println(",");
		}
		pw.println("]");
	}
}
