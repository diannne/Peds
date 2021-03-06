package model;
// Generated Jan 8, 2016 7:45:08 PM by Hibernate Tools 4.3.1


import java.util.HashSet;
import java.util.Set;

/**
 * Pediatricians generated by hbm2java
 */
public class Pediatricians  implements java.io.Serializable {


     private Integer id;
     private Specialties specialties;
     private String firstName;
     private String lastName;
     private String grade;
     private Set consultationses = new HashSet(0);

    public Pediatricians() {
    }

	
    public Pediatricians(Specialties specialties) {
        this.specialties = specialties;
    }
    public Pediatricians(Specialties specialties, String firstName, String lastName, 
            String grade, Set consultationses) {
       this.specialties = specialties;
       this.firstName = firstName;
       this.lastName = lastName;
       this.grade = grade;
       this.consultationses = consultationses;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public Specialties getSpecialties() {
        return this.specialties;
    }
    
    public void setSpecialties(Specialties specialties) {
        this.specialties = specialties;
    }
    public String getFirstName() {
        return this.firstName;
    }
    
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    public String getLastName() {
        return this.lastName;
    }
    
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    public String getGrade() {
        return this.grade;
    }
    
    public void setGrade(String grade) {
        this.grade = grade;
    }
    public Set getConsultationses() {
        return this.consultationses;
    }
    
    public void setConsultationses(Set consultationses) {
        this.consultationses = consultationses;
    }

    public void addConsultation(Consultations consultation) {
        this.consultationses.add(consultation);
    }



}


