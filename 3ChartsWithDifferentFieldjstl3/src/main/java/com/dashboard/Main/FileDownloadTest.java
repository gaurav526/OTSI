package com.dashboard.Main;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import org.apache.commons.io.FileUtils;

/*
 * @author Singaram Subramanian
*/
public class FileDownloadTest {
	public static void main(String[] args) {
		// Make sure that this directory exists
		String dirName = "D:\\PDF fold/vik";
		try {
			System.out.println("Downloading \'Maven, Eclipse and OSGi working together\' PDF document...");
			saveFileFromUrlWithJavaIO(dirName,
					"https://singztechmusings.files.wordpress.com/2011/09/maven_eclipse_and_osgi_working_together.pdf");
			System.out.println("Downloaded \'Maven, Eclipse and OSGi working together\' PDF document.");
			System.out.println("Downloading \'InnoQ Web Services Standards Poster\' PDF document...");
			saveFileFromUrlWithCommonsIO(dirName + "\\innoq_ws-standards_poster_2007-02.pdf",
					"https://singztechmusings.files.wordpress.com/2011/08/innoq_ws-standards_poster_2007-02.pdf");
			System.out.println("Downloaded \'InnoQ Web Services Standards Poster\' PDF document.");
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	// Using Java IO
	public static void saveFileFromUrlWithJavaIO(String fileName, String fileUrl)
			throws MalformedURLException, IOException {
		BufferedInputStream in = null;
		FileOutputStream fout = null;
		try {
			in = new BufferedInputStream(new URL(fileUrl).openStream());
			fout = new FileOutputStream(fileName);
			byte data[] = new byte[1024];
			int count;
			while ((count = in.read(data, 0, 1024)) != -1) {
				fout.write(data, 0, count);
			}
		} finally {
			if (in != null)
				in.close();
			if (fout != null)
				fout.close();
		}
	}

	// Using Commons IO library
	// Available at http://commons.apache.org/io/download_io.cgi
	public static void saveFileFromUrlWithCommonsIO(String fileName, String fileUrl)
			throws MalformedURLException, IOException {
		FileUtils.copyURLToFile(new URL(fileUrl), new File(fileName));
	}
}