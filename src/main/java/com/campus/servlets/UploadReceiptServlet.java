/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebServlet("/UploadReceiptServlet")
@MultipartConfig
public class UploadReceiptServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Get uploaded file
        Part filePart = request.getPart("receipt");
        String fileName = filePart.getSubmittedFileName();

        // Define save directory
        String uploadsDir = getServletContext().getRealPath("/uploads/receipts");
        File uploadsFolder = new File(uploadsDir);
        if (!uploadsFolder.exists()) {
            uploadsFolder.mkdirs();
        }

        // Save file
        filePart.write(uploadsDir + File.separator + fileName);

        // Redirect back with status
        response.sendRedirect("checkout.jsp?status=receipt_uploaded");
    }
}