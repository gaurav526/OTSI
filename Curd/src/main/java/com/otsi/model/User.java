package com.otsi.model;

public class User {
	
	
	private String userId;
    private String firstName;
    private String lastName;
    private String gender;
    private long contactNo;
    private String address;
    private int pinCode;
 
	//getter & setter methods...
	    public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public long getContactNo() {
		return contactNo;
	}

	public void setContactNo(long contactNo) {
		this.contactNo = contactNo;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getPinCode() {
		return pinCode;
	}

	public void setPinCode(int pinCode) {
		this.pinCode = pinCode;
	}

	//toString() override...
	@Override
	public String toString() {
	        return "User [UserId=" + userId + "\n"
	        		+ " firstName=" + firstName
	                + "\n"
	                + " lastName=" + lastName + "\n"
	                		+ " Gender=" + gender + "\n"
	                				+ " ContactNo=" + contactNo + "\n"
	                		+ " Address=" + address + "\n"
	                				+ " Pincode=" + pinCode + "]";
	    }
}

		
	 
	


