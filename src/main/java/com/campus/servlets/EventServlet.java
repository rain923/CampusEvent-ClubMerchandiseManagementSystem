
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.campus.servlets;

import com.campus.dao.EventDAO;
import com.campus.models.Event;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/EventServlet")
public class EventServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(EventServlet.class.getName());
    private EventDAO eventDAO;

    @Override
    public void init() throws ServletException {
        logger.log(Level.INFO, "Initializing EventServlet");
        eventDAO = new EventDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("join".equals(action)) {
            handleJoinEvent(request, response);
        } else {
            listEvents(request, response);
        }
    }

    private void listEvents(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        ArrayList<Event> eventList = eventDAO.getAllEvents(); // Only available events
        ArrayList<Event> joinedEvents = new ArrayList<>();

        if (userId != null) {
            joinedEvents = eventDAO.getJoinedEvents(userId);
        }

        request.setAttribute("eventList", eventList);
        request.setAttribute("joinedEvents", joinedEvents);

        request.getRequestDispatcher("/student/events.jsp").forward(request, response);
    }

    private void handleJoinEvent(HttpServletRequest request, HttpServletResponse response)
        throws IOException {

        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            HttpSession session = request.getSession(false);
            if (session == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("session_expired");
                return;
            }

            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("login_required");
                return;
            }

            int eventId = Integer.parseInt(request.getParameter("eventId"));
            boolean success = eventDAO.joinEvent(eventId, userId);

            out.print(success ? "success" : "already_joined");

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("invalid_event");
            logger.log(Level.WARNING, "Invalid event ID format", e);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("server_error");
            logger.log(Level.SEVERE, "Join event error", e);
        } finally {
            if (out != null) {
                out.close();
            }
        }
    }
}