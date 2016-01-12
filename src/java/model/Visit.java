package model;
// Generated Jan 8, 2016 7:45:08 PM by Hibernate Tools 4.3.1

import java.sql.Time;
import java.util.Date;

/**
 * Consultations generated by hbm2java
 */
public class Visit implements java.io.Serializable {

    private Integer id;
    private String ped;
    private String spec;
    private String date;
    private String reason;
    private String prescription;
    private String comments;

    public Visit() {
    }

    public Visit(Integer id, String ped, String spec, String date, String reason,
            String prescription, String comments) {

        this.id = id;
        this.ped = ped;
        this.spec = spec;
        this.date = date;
        this.reason = reason;
        this.prescription = prescription;
        this.comments = comments;
    }

    public Integer getId() {
        return this.id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getPed() {
        return this.ped;
    }

    public void setPed(String ped) {
        this.ped = ped;
    }
    
    public String getSpec() {
        return this.spec;
    }

    public void setSpec(String spec) {
        this.spec = spec;
    }
    
    public String getDate() {
        return this.date;
    }

    public void setDate(String date) {
        this.date = date;
    }
    
    public String getReason() {
        return this.reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getPrescription() {
        return this.prescription;
    }

    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }

    public String getComments() {
        return this.comments;
    }

    public void setComments(String comments) {
        this.comments = comments;
    }

}