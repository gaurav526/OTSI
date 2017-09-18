package com.otsi.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.Client;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;

import com.google.gson.Gson;
import com.otsi.util.DBUtil;

public class ChartsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	static Properties props = null;
	Map<String, Object> chartMap = new HashMap<>();
	static Client client;
	SearchResponse searchResponse = null;

	// static block...
	static {
		props = new Properties();
		InputStream input = ChartsServlet.class.getClassLoader().getResourceAsStream("resource.properties");
		try {
			props.load(input);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// getCharts method...
	public Map<String, Object> getCharts(String chartName) {
		String[] ids = props.getProperty(chartName).split(",");

		chartMap.put("index_name", ids[0]);
		chartMap.put("index_type", ids[1]);
		chartMap.put("field_name", ids[2]);
		chartMap.put("size", ids[3]);
		chartMap.put("chart_Type", ids[4]);
		chartMap.put("id", chartName);

		DBUtil db = new DBUtil();
		// to get connection for client..........
		client = db.getConnection();

		System.out.println(DBUtil.getPath());

		// searchResponse object...
		searchResponse = client.prepareSearch(chartMap.get("index_name").toString())
				.setTypes(chartMap.get("index_type").toString())
				.addAggregation(AggregationBuilders.terms("agg")
						.field(chartMap.get("field_name").toString() + ".keyword")
						.size(Integer.parseInt(chartMap.get("size").toString())).order(Terms.Order.count(false)))
				.execute().actionGet();

		Terms agg = searchResponse.getAggregations().get("agg");
		List<String> bucketKeys = new ArrayList<>();

		List<Long> bucketCounts = new ArrayList<>();

		// For each entry
		for (Terms.Bucket entry : agg.getBuckets()) {
			String key = entry.getKeyAsString();
			long docCount = entry.getDocCount();
			bucketKeys.add(key);
			bucketCounts.add(docCount);
		}
		chartMap.put("bucketKeys", bucketKeys);
		chartMap.put("bucketCounts", bucketCounts);
		return chartMap;
	}

	// doGet method...
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String[] allids = props.getProperty("allids").split(",");
		request.setAttribute("allids", allids);

	}

	// doPost method...
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PrintWriter out = resp.getWriter();
		resp.setContentType("text/json");

		String[] allids = props.getProperty("allids").split(",");

		List<String> al = new ArrayList<String>();
		for (int i = 0; i < allids.length; i++) {
			al.add(allids[i]);
		}
		chartMap.put("allids", al);

		String json = null;
		Map<String, Object> map = null;
		out.println("[");
		for (int i = 0; i < allids.length; i++) {
			map = getCharts(allids[i]);
			// convert Json format...
			Gson gson = new Gson();
			json = gson.toJson(map);
			out.println(json);
			if (i != allids.length - 1)
				out.println(",");
		}
		out.println("]");
	}
}
