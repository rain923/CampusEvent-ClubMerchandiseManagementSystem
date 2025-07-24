/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.campus.dao;

import com.campus.models.Club;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ClubDAO {
    private static final Logger logger = Logger.getLogger(ClubDAO.class.getName());
    private String jdbcURL = "jdbc:derby://localhost:1527/GroupProject584";
    private String jdbcUsername = "app";
    private String jdbcPassword = "app";

    private Connection getConnection() throws SQLException {
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
        } catch (ClassNotFoundException e) {
            logger.log(Level.SEVERE, "JDBC Driver not found", e);
            throw new SQLException("JDBC Driver not found", e);
        }
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public ArrayList<Club> getAllClubs() {
        ArrayList<Club> clubList = new ArrayList<>();
        String sql = "SELECT * FROM CLUBS";

        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Club c = new Club();
                c.setId(rs.getInt("ID"));
                c.setName(rs.getString("CLUB_NAME"));
                c.setDescription(rs.getString("DESCRIPTION"));
                clubList.add(c);
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving clubs", e);
        }
        return clubList;
    }
    
    public Club getClubByUserId(int userId) {
        Club club = null;
        String sql = "SELECT c.* FROM clubs c JOIN club_members cm ON c.id = cm.club_id WHERE cm.user_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    club = new Club();
                    club.setId(rs.getInt("ID"));
                    club.setName(rs.getString("CLUB_NAME"));
                    club.setDescription(rs.getString("DESCRIPTION"));
                }
            }
        } catch (SQLException e) {
            logger.log(Level.SEVERE, "Error retrieving club by user ID", e);
        }

        return club;
    }

}