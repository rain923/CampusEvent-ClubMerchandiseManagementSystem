/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/GetReceiptServlet")
public class GetReceiptServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "C:/receipt_uploads"; // Your actual path

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileName = request.getParameter("file");
        if (fileName == null || fileName.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing file parameter");
            return;
        }

        File file = new File(UPLOAD_DIR, fileName);
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
            return;
        }

        // Set content type based on file extension (basic)
        if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            response.setContentType("image/jpeg");
        } else if (fileName.endsWith(".png")) {
            response.setContentType("image/png");
        } else if (fileName.endsWith(".gif")) {
            response.setContentType("image/gif");
        } else {
            response.setContentType("application/octet-stream");
        }

        response.setContentLengthLong(file.length());

        // Stream file to response
        try (FileInputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {

            byte[] buffer = new byte[1024];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
