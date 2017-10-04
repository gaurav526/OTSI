package co.in.otsi.util;

import java.util.ArrayList;
import java.util.Scanner;
import java.math.BigDecimal;
import java.math.RoundingMode;

public class ExpressionCalculator {

	ArrayList<String> arrayList;
	String item;
	static ExpressionCalculator calculator;

	public static String brackets(String string) { // deal with brackets...
		calculator = new ExpressionCalculator();

		while (string.contains(Character.toString('(')) || string.contains(Character.toString(')'))) {
			for (int i = 0; i < string.length(); i++) {
				try {
					if ((string.charAt(i) == ')' || Character.isDigit(string.charAt(i)))
							&& string.charAt(i + 1) == '(') {
						string = string.substring(0, i + 1) + "*" + (string.substring(i + 1));
						System.out.println(string);
					}
				} catch (Exception ignored) {
				}
				if (string.charAt(i) == ')') {
					for (int j = i; j >= 0; j--) {
						if (string.charAt(j) == '(') {
							String in = string.substring(j + 1, i);
							in = calculator.find(in);
							string = string.substring(0, j) + in + string.substring(i + 1);
							j = i = 0;
						}
					}
				}
			}
			if (string.contains(Character.toString('(')) || string.contains(Character.toString(')'))
					|| string.contains(Character.toString('(')) || string.contains(Character.toString(')'))) {
				System.out.println("Error: incorrect brackets...");
				return "Error: incorrect brackets placement";
			}
		}
		string = calculator.find(string);
		return string;
	}

	public String find(String s) { // method divide String on numbers and operators
		Use use = new Use();
		arrayList = new ArrayList<String>();
		item = "";
		for (int i = s.length() - 1; i >= 0; i--) {
			if (Character.isDigit(s.charAt(i))) {
				item = s.charAt(i) + item;
				if (i == 0) {
					use.put();
				}
			} else {
				if (s.charAt(i) == '.') {
					item = s.charAt(i) + item;
				} else if (s.charAt(i) == '-' && (i == 0 || (!Character.isDigit(s.charAt(i - 1))))) {
					item = s.charAt(i) + item;
					use.put();
				} else {
					use.put();
					item += s.charAt(i);
					use.put();
					if (s.charAt(i) == '|') {
						item += " ";
						use.put();
					}
				}
			}
		}
		arrayList = use.result(arrayList, "^", "|"); // check Strings
		arrayList = use.result(arrayList, "*", "/"); // for chosen
		arrayList = use.result(arrayList, "+", "-"); // operators
		return arrayList.get(0);
	}

	public class Use {

		public void put() {
			if (!item.equals("")) {
				arrayList.add(0, item);
				item = "";
			}
		}

		public ArrayList<String> result(ArrayList<String> arrayList, String op1, String op2) {
			int scale = 10; // controls BigDecimal decimal point accuracy
			BigDecimal result = new BigDecimal(0);

			for (int c = 0; c < arrayList.size(); c++) {
				if (arrayList.get(c).equals(op1) || arrayList.get(c).equals(op2)) {
					if (arrayList.get(c).equals("^")) {
						result = new BigDecimal(arrayList.get(c - 1)).pow(Integer.parseInt(arrayList.get(c + 1)));
					} else if (arrayList.get(c).equals("|")) {
						result = new BigDecimal(Math.sqrt(Double.parseDouble(arrayList.get(c + 1))));
					} else if (arrayList.get(c).equals("*")) {
						result = new BigDecimal(arrayList.get(c - 1)).multiply(new BigDecimal(arrayList.get(c + 1)));
					} else if (arrayList.get(c).equals("/")) {
						result = new BigDecimal(arrayList.get(c - 1)).divide(new BigDecimal(arrayList.get(c + 1)),
								scale, BigDecimal.ROUND_DOWN);
					} else if (arrayList.get(c).equals("+")) {
						result = new BigDecimal(arrayList.get(c - 1)).add(new BigDecimal(arrayList.get(c + 1)));
					} else if (arrayList.get(c).equals("-")) {
						result = new BigDecimal(arrayList.get(c - 1)).subtract(new BigDecimal(arrayList.get(c + 1)));
					}
					try {
						arrayList.set(c,
								(result.setScale(scale, RoundingMode.HALF_DOWN).stripTrailingZeros().toPlainString()));
						arrayList.remove(c + 1); // replace the operator with result
						arrayList.remove(c - 1); // remove used numbers from list
					} catch (Exception ignored) {
					}
				} else {
					continue;
				}
				c = 0; // reset
			}
			return arrayList;
		}
	
	
    }
}