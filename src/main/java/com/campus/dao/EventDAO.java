/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.campus.dao;

import com.campus.models.Event;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EventDAO {
    private static final Logger logger = Logger.getLogger(EventDAO.class.getName());
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";

    /**
     * Establish database connection.
     */
    private Connection getConnection() throws SQLException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "JDBC Driver not found", e);
            throw new SQLException("JDBC Driver not found", e);
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    /**
     * Retrieve all events with status 'active' from EVENTS table.
     */
    public ArrayList<Event> getAllEvents() {
        ArrayList<Event> eventList = new ArrayList<>();
        String sql = "SELECT * FROM EVENTS WHERE STATUS = 'active'";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("ID"));
                e.setName(rs.getString("EVENT_NAME"));
                e.setDate(rs.getDate("EVENT_DATE").toString());
                e.setLocation(rs.getString("LOCATION"));
                e.setDescription(rs.getString("DESCRIPTION"));
                e.setPayment(rs.getDouble("PAYMENT"));

                try {
                    e.setClubId(rs.getInt("CLUB_ID"));
                } catch (SQLException ex) {
                    logger.log(Level.FINE, "CLUB_ID column not found for event: " + e.getId(), ex);
                }

                eventList.add(e);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving events", e);
        }
        return eventList;
    }

    /**
     * Allow user to join an event by inserting into EVENT_PARTICIPANTS table.
     */
    public boolean joinEvent(int eventId, int userId) {
        String sql = "INSERT INTO EVENT_PARTICIPANTS (EVENT_ID, USER_ID) VALUES (?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, eventId);
            stmt.setInt(2, userId);
            int affectedRows = stmt.executeUpdate();
            return affectedRows > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            logger.log(Level.INFO, "User {0} already joined event {1}", new Object[]{userId, eventId});
            return false;
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Join failed for event: " + eventId, e);
            return false;
        }
    }

    /**
     * Retrieve all events a user has joined.
     */
    public ArrayList<Event> getJoinedEvents(int userId) {
        ArrayList<Event> joinedEvents = new ArrayList<>();
        String sql = "SELECT e.* FROM EVENTS e "
                   + "JOIN EVENT_PARTICIPANTS ep ON e.ID = ep.EVENT_ID "
                   + "WHERE ep.USER_ID = ?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Event e = new Event();
                e.setId(rs.getInt("ID"));
                e.setName(rs.getString("EVENT_NAME"));
                e.setDate(rs.getDate("EVENT_DATE").toString());
                e.setLocation(rs.getString("LOCATION"));
                e.setDescription(rs.getString("DESCRIPTION"));
                e.setPayment(rs.getDouble("PAYMENT"));

                try {
                    e.setClubId(rs.getInt("CLUB_ID"));
                } catch (SQLException ex) {
                    logger.log(Level.FINE, "CLUB_ID column not found for joined event: " + e.getId(), ex);
                }

                joinedEvents.add(e);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving joined events for user: " + userId, e);
        }
        return joinedEvents;
    }
}