package com.otsi.dao;

//import static org.elasticsearch.common.xcontent.XContentFactory.*;

import org.apache.logging.log4j.core.script.Script;

import org.elasticsearch.action.delete.DeleteResponse;
import org.elasticsearch.action.get.GetResponse;
import org.elasticsearch.action.index.IndexResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.Client;
import org.elasticsearch.cluster.metadata.MetaData.XContentContext;
import org.elasticsearch.common.xcontent.XContent;
import org.elasticsearch.common.xcontent.XContentBuilder;
import org.elasticsearch.common.xcontent.XContentFactory;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.index.reindex.BulkIndexByScrollResponse;
import org.elasticsearch.index.reindex.DeleteByQueryAction;
import org.elasticsearch.index.reindex.UpdateByQueryRequestBuilder;
import static org.elasticsearch.common.xcontent.XContentFactory.*;

import java.io.IOException;
import java.util.HashMap;
import java.util.InputMismatchException;
import java.util.Map;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

import com.otsi.model.User;
import com.otsi.util.DBUtil;

public class UserDAOImplementation {

	private static Client client = null;
	private static Scanner sc = null;
	private static User user = null;

	// consturctor..
	public UserDAOImplementation() {
		client = DBUtil.getConnection();
		sc = new Scanner(System.in);
		user = new User();
	}

	// addUser() method to insert values in DB..
	public void addUser() {

		System.out.println("Enter UserId: ");
		String id = sc.next();
		user.setUserId(id);
		System.out.println("Enter FirstName: ");
		user.setFirstName(sc.next());
		System.out.println("Enter LastName: ");
		user.setLastName(sc.next());
		System.out.println("Enter Gender: ");
		user.setGender(sc.next());
		System.out.println("Enter ContactNo: ");
		try {
			user.setContactNo(sc.nextLong());
		} catch (InputMismatchException e) {
			e.getMessage();
			System.out.println("Only numeric allows");
		}
		System.out.println("Enter Address: ");
		user.setAddress(sc.next());
		System.out.println("Enter Pincode: ");
		try {
			user.setPinCode(sc.nextInt());
		} catch (InputMismatchException i) {
			System.out.println("Only numeric allows");
		}
		try {
			IndexResponse response = client.prepareIndex("users", "user", id).setSource(XContentFactory.jsonBuilder()

					.startObject().field("userId", user.getUserId())

					.field("firstName", user.getFirstName()).field("lastName", user.getLastName())

					.field("gender", user.getGender()).field("contactNo", user.getContactNo())
					.field("address", user.getAddress()).field("pincode", user.getPinCode()).endObject()).execute()
					.actionGet();

		} catch (IOException e) {

			e.printStackTrace();

		}
		// client.close();
		System.out.println(" Record inserted.....");

	}

	// deleteUser() method to delete values in DB..
	public void deleteUser() {

		System.out.println("Enter user ID: ");
		user.setUserId(sc.next());

		BulkIndexByScrollResponse response = DeleteByQueryAction.INSTANCE.newRequestBuilder(client)
				.filter(QueryBuilders.matchQuery("userId", user.getUserId())).source("users").get();
		if (response != null) {

			long deleted = response.getDeleted();

			// client.close();
			System.out.println(deleted + "Record deleted...");
		} else {
			// client.close();
			System.out.println("Record not found...");

		}

	}

	// updateUser() method to update values in DB..
	public void updateUser() throws IOException, InterruptedException, ExecutionException {

		System.out.println("Enter User Id: ");
		String id = null;
		try {
			id = sc.next();
			user.setUserId(id);
		} catch (InputMismatchException i) {
			i.getMessage();
		}

		GetResponse getResponse = client.prepareGet("users", "user", id).execute().actionGet();
		Map<String, Object> source = getResponse.getSource();
		if (source != null) {

			System.out.println("Enter new contact NO: ");
			user.setContactNo(sc.nextLong());

			System.out.println("Enter new Address : ");
			user.setAddress(sc.next());

			System.out.println("Enter new Pincode : ");
			user.setPinCode(sc.nextInt());

			UpdateRequest updateRequest = new UpdateRequest();
			updateRequest.index("users");
			updateRequest.type("user");
			updateRequest.id(id);
			updateRequest.doc(jsonBuilder().startObject().field("contactNo", user.getContactNo())
					.field("address", user.getAddress()).field("pincode", user.getPinCode()).endObject());
			client.update(updateRequest).get();
			// client.close();
			System.out.println("Record Updated...");

		} else {
			System.out.println("Record Not Found... ");
		}

	}

	// getUserById() method to search values from DB based on id..
	public void getUserById() {

		System.out.println("Enter User Id: ");
		user.setUserId(sc.next());

		GetResponse getResponse = client.prepareGet("users", "user", user.getUserId()).execute().actionGet();
		Map<String, Object> source = getResponse.getSource();
		if (source != null) {
			System.out.println("---------------------------------------------------------");
			System.out.println("UserId " + getResponse.getId() + " the data are as follows--");
			System.out.println("Index: " + getResponse.getIndex());
			System.out.println("Type: " + getResponse.getType());
			System.out.println(source);
			System.out.println("---------------------------------------------------------");
			// client.close();
		}

		else {
			System.out.println("Record not Found...");
		}
	}

}
