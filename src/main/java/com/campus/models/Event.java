

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author User
 */
package com.campus.models;

public class Event {
    private int id;
    private String name;
    private String date;
    private String location;
    private String description;
    private double payment;
    private int clubId;

    // Default constructor (recommended if using frameworks like JSP/Servlets, Hibernate, JDBC mapping)
    public Event() {
    }

    // Optional: parameterized constructor for convenience
    public Event(int id, String name, String date, String location,String description, Double payment,int clubId) {
        this.id = id;
        this.name = name;
        this.date = date;
        this.location = location;
        this.description = description;
        this.payment = payment;
        this.clubId = clubId;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Double getPayment() { return payment; }
    public void setPayment(Double payment) { this.payment = payment; }
    
    public int getClubId() { return clubId; }
    public void setClubId(int clubId) { this.clubId = clubId; }
}