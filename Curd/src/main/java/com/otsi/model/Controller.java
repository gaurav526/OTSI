package com.otsi.model;

import java.io.IOException;


import java.util.InputMismatchException;
import java.util.Scanner;
import java.util.concurrent.ExecutionException;

import com.otsi.dao.UserDAOImplementation;

public class Controller {

	// main method..
	public static void main(String[] args) {

		// DAO Class Object..
		while (true) {
			UserDAOImplementation dao = new UserDAOImplementation();
			Scanner sc = new Scanner(System.in);

			System.out.println("______________WELCOME TO CRUD OPERATION_______________");
			System.out.println("@1-->  Press 1 to add a record");
			System.out.println("@2-->  Press 2 to delete a record");
			System.out.println("@3-->  Press 3 to update existed record");
			System.out.println("@4-->  Press 4 to search for a record");
			System.out.println(" ");

			int n = 0;
			try {

				System.out.println("Enter the Number");
				n = sc.nextInt();
			} catch (InputMismatchException e) {
				System.out.println("please enter only above mentaioned values...");
				break;

			}

			// switch cases to perform CRUD operations..
			switch (n) {
			case 1:
				System.out.println("Welcome you selected ADD Operation...");
				dao.addUser();
				break;
			case 2:
				System.out.println("Welcome you selected DELETE Operation...");
				dao.deleteUser();
				break;
			case 3:
				System.out.println("Welcome you selected UPDATE Operation...");
				try {
					dao.updateUser();
				} catch (IOException e) {

					e.printStackTrace();
				} catch (InterruptedException e) {

					e.printStackTrace();
				} catch (ExecutionException e) {

					e.printStackTrace();
				}
				break;
			case 4:
				System.out.println("Welcome you selected SEARCH Operation...");
				dao.getUserById();
				break;

			default:
				System.out.println("You entered Wrong Number");
				System.out.println("Please enter b/w 1 to 4");
				break;
			}

		}
	}// main

}// class
