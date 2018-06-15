package com.dashboard.Main;

import java.util.HashMap;
import java.util.Map;

public class Cache {
	private static Cache instance;
	private Map<String, Object> mapData;

	private Cache() {
		mapData = new HashMap<String, Object>();
	}

	public void put(String key, Object value) {
		mapData.put(key, value);
	}

	public Object get(String key) {
		return mapData.get(key);
	}

	public boolean containsKey(String key) {
		return mapData.containsKey(key);
	}
	public static synchronized Cache getInstance() {
		if (instance == null) {
			instance = new Cache();
		}
		return instance;
	}
}
