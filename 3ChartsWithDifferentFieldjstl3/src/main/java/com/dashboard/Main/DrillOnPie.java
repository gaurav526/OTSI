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
import javax.servlet.http.HttpSession;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.transport.InetSocketTransportAddress;
import org.elasticsearch.common.unit.TimeValue;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.transport.client.PreBuiltTransportClient;
import com.google.gson.Gson;

public class DrillOnPie extends HttpServlet {
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
		InputStream is = DrillOnPie.class.getClassLoader().getResourceAsStream("com/dashboard/Main/dbinfo.properties");
		try {
			properties.load(is);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// drill map
	public Map<String, Object> getCharts(String chartID, Map<String, Object> drillValues, HttpSession session) {
		ArrayList<String> bucketKey = new ArrayList<String>();
		ArrayList<Long> bucketCount = new ArrayList<Long>();
		String[] chart = properties.getProperty(chartID).split(" ");
		BoolQueryBuilder boolQueryBuilder = null;
		chartParameterMap.put("index", chart[0]);
		chartParameterMap.put("docType", chart[1]);
		chartParameterMap.put("fieldname", chart[2]);
		chartParameterMap.put("size", chart[3]);
		chartParameterMap.put("id", chartID);
		chartParameterMap.put("chartType", chart[4]);
		chartParameterMap.put("agg", chart[5]);
		// System.out.println(session);
		if (session.getAttribute("values") != null) {
			boolQueryBuilder = QueryBuilders.boolQuery().must(QueryBuilders.matchQuery(
					drillValues.get("fieldName").toString(), drillValues.get("clickedFieldName").toString()));
			// System.out.println(boolQueryBuilder.toString());
			s = client.prepareSearch(chartParameterMap.get("index").toString())
					.setTypes(chartParameterMap.get("docType").toString()).setSize(10).setQuery(boolQueryBuilder)
					.setScroll(new TimeValue(10000))
					.addAggregation(AggregationBuilders.terms(chartParameterMap.get("agg").toString())
							.field(chartParameterMap.get("fieldname").toString()).order(Terms.Order.count(false)))
					.execute().actionGet();

			// System.out.print(arg0);
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
		}

		// System.out.println(chartParameterMap);
		return chartParameterMap;
	}

	@SuppressWarnings("resource")
	@Override
	public void init() throws ServletException {
		if (client == null) {
			// get the setting
			settings = Settings.builder().put("cluster.name", clusterName).put("client.transport.sniff", true).build();

			try {
				// get the client
				client = new PreBuiltTransportClient(settings)
						.addTransportAddress(new InetSocketTransportAddress(InetAddress.getByName(hostName), 9300));
			} // try
			catch (UnknownHostException e) {
				e.printStackTrace();
			} // catch(-)
		} // if
	}

	@Override
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String[] allid = properties.getProperty("allids").split(" ");
		req.setAttribute("allids", allid);
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PrintWriter pw = resp.getWriter();
		resp.setContentType("application/pdf");
		String[] allid = properties.getProperty("allids").split(" ");
		req.setAttribute("allids", allid);
		Map<String, Object> drillValues = new HashMap<String, Object>();
		// get the values
		String fieldName = req.getParameter("fieldName");
		String clickedFieldName = req.getParameter("clickedFieldName");

		drillValues.put("fieldName", fieldName);
		drillValues.put("clickedFieldName", clickedFieldName);

		HttpSession session = req.getSession();
		session.setAttribute("values", drillValues);
		System.out.println(drillValues.toString());
		Map<String, Object> mapobject = null;
		pw.println("[");
		for (int i = 0; i < allid.length; i++) {
			mapobject = getCharts(allid[i], drillValues, session);
			Gson gson = new Gson();
			String gsonTojson = gson.toJson(mapobject);
			pw.println(gsonTojson);
			if (i != allid.length - 1)
				pw.println(",");

		}
		pw.println("]");
	}
}// class