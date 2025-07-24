/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import com.campus.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int studentId = (Integer) session.getAttribute("userId");

        if ("placeOrder".equals(action)) {
            int merchandiseId = Integer.parseInt(request.getParameter("merchandiseId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            String postageInfo = request.getParameter("postageInfo");

            boolean success = orderDAO.placeOrder(studentId, merchandiseId, quantity, postageInfo);

            if (success) {
                response.sendRedirect("student/ordersuccess.jsp");
            } else {
                response.sendRedirect("student/orderfail.jsp");
            }
        }
    }
}